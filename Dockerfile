# 第一阶段：构建前端主题
# 前端产物与 CPU 架构无关，使用原生构建平台避免在 QEMU 中运行 Node/pnpm。
FROM --platform=$BUILDPLATFORM node:20-alpine AS frontend-builder

# 2024 主题现在使用仓库内本地源码构建（./fcb-fronted），不再从 GitHub 克隆。
# 此参数仅用于镜像标签展示，不再驱动 git fetch。
ARG FRONTEND_2024_REF=local
ARG FRONTEND_2023_REF=main

RUN apk add --no-cache git python3 make g++

RUN corepack enable && \
    corepack prepare pnpm@9.15.9 --activate

WORKDIR /build

# 构建本地 2024 主题源码（来自构建上下文中的 fcb-fronted/ 目录）
# 注意：这里用 --no-frozen-lockfile 而非 --frozen-lockfile。
# 原因：fcb-fronted/pnpm-lock.yaml 当前与 package.json 的 overrides 配置对不上
# （pnpm 报 ERR_PNPM_LOCKFILE_CONFIG_MISMATCH），锁文件需要重新生成。
# 在修复/重新生成 fcb-fronted/pnpm-lock.yaml 之前，先用 --no-frozen-lockfile
# 保证本地构建能跑通；等锁文件修好后可以改回 --frozen-lockfile 以获得可复现构建。
COPY fcb-fronted/ /build/fronted-2024/
RUN cd /build/fronted-2024 && \
    pnpm install --no-frozen-lockfile --prod=false && \
    VITE_GIT_COMMIT="${FRONTEND_2024_REF}" pnpm run build

# 克隆并构建固定版本的 2023 主题（仍从 GitHub 拉取）
RUN git clone --filter=blob:none --no-checkout https://github.com/vastsa/FileCodeBoxFronted2023.git /build/fronted-2023 && \
    cd /build/fronted-2023 && \
    git fetch --depth 1 origin "${FRONTEND_2023_REF}" && \
    git checkout --detach FETCH_HEAD && \
    npm install --legacy-peer-deps && \
    npm run build

# 第二阶段：构建最终镜像
FROM python:3.12-slim-bookworm
ARG APP_VERSION
ARG VCS_REF=unknown
ARG FRONTEND_2024_REF=local
ARG FRONTEND_2023_REF=main
LABEL author="Lan"
LABEL email="xzu@live.com"
LABEL org.opencontainers.image.version="${APP_VERSION}"
LABEL org.opencontainers.image.revision="${VCS_REF}"
LABEL org.opencontainers.image.filecodebox.frontend-2024-revision="${FRONTEND_2024_REF}"
LABEL org.opencontainers.image.filecodebox.frontend-2023-revision="${FRONTEND_2023_REF}"

WORKDIR /app

# 仅复制运行所需的后端文件（显式列出，本地前端源码 fcb-fronted/ 不会进入运行时镜像）
COPY apps ./apps
COPY core ./core
COPY main.py requirements.txt VERSION ./

# 分支镜像使用带提交号的开发版本；正式镜像使用 VERSION 中的版本。
ENV APP_VERSION="${APP_VERSION}"

# 设置时区
RUN ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && \
    echo 'Asia/Shanghai' > /etc/timezone

# 从构建阶段复制编译好的前端主题
COPY --from=frontend-builder /build/fronted-2024/dist ./themes/2024
COPY --from=frontend-builder /build/fronted-2023/dist ./themes/2023

# 安装系统安全更新 + Python 依赖
# 清理 apt 缓存，降低镜像噪音与扫描面
RUN apt-get update \
 && apt-get upgrade -y --no-install-recommends \
 && rm -rf /var/lib/apt/lists/* \
 && pip install --no-cache-dir -r requirements.txt \
 && pip cache purge || true

# 环境变量配置
ENV HOST="0.0.0.0" \
    PORT=12345 \
    WORKERS=1 \
    APP_ENV="production" \
    LOG_LEVEL="warning" \
    ACCESS_LOG="false" \
    FORWARDED_ALLOW_IPS=""

EXPOSE 12345

# 生产环境启动命令
# FORWARDED_ALLOW_IPS 默认为空：仅信任直连 IP，避免任意客户端伪造 X-Forwarded-*。
# 若前面有反向代理，请显式设置为代理网段，例如 "10.0.0.0/8,172.16.0.0/12"。
CMD ["sh", "-c", "access_log_arg=--no-access-log; if [ \"${APP_ENV:-development}\" != \"production\" ] || [ \"${ACCESS_LOG:-false}\" = \"true\" ]; then access_log_arg=--access-log; fi; exec uvicorn main:app --host \"$HOST\" --port \"$PORT\" --workers \"$WORKERS\" --log-level \"$LOG_LEVEL\" \"$access_log_arg\" --proxy-headers --forwarded-allow-ips \"${FORWARDED_ALLOW_IPS:-}\""]
