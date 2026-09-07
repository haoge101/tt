# 主题颜色深度修复说明

## 根因

项目里有两套并行的主题机制：

1. **新机制**：`src/assets/style/main.css` 里的 `--color-*` CSS 变量（`--color-page`、
   `--color-surface`、`--color-accent` 等），配合 `theme-page` / `theme-surface` /
   `theme-brand` 等工具类，颜色随变量统一变化，改一处全站生效。
2. **旧写法**：几乎所有页面和公共组件里，直接写死
   `isDarkMode ? 'bg-zinc-950 ...' : 'bg-white ...'` 这样的三元表达式，颜色是
   硬编码的 Tailwind 类名，和 `--color-*` 变量完全没有关系。

你之前改主题色时只动了变量本身，但大部分 UI 走的是旧写法，所以看起来"改了但没生效"。

## 本次改动内容

统计下来全项目里旧写法一共 **180+ 处**，分布在 30 个文件，本次全部改成了基于
`rgb(var(--color-xxx))` 的写法：

- **发送页 / 取件页**（`SendFileView.vue` / `RetrievewFileView.vue`）：卡片背景、
  提交按钮、页脚全部改为跟随 `--color-page` / `--color-surface` / `--color-accent`。
- **登录页**（`LoginView.vue`）：logo 徽标、输入框、登录按钮同上。
- **后台仪表盘 / 文件管理 / 系统设置**（`DashboardView.vue` /
  `FileManageView.vue` / `SystemSettingsView.vue`）：卡片、徽章、状态标签、
  健康检查提示等全部改为语义化变量（`--color-success` / `--color-warning` /
  `--color-danger` / `--color-accent`）。
- **公共组件**（`BaseButton` / `BaseModal` / `AlertComponent` / `DataPagination` /
  `DataTable` / `FileUploadArea` / `SideDrawer` / `SentRecordList` /
  `SentRecordDetailModal` / `FileDetailModal` / `ExpirationSelector` /
  `RetrieveForm` 等近 20 个组件）：同上。
- 修了几处**顺手发现的 bug**：
  - `select option:checked/:hover` 高亮色原来写死的靛蓝/青色，现在跟随
    `--color-accent`。
  - `DashboardView.vue` 里的进度条组件用的是 Tailwind `dark:` 变体类，但项目
    `tailwind.config.js` 没有配置 `darkMode: 'class'`，导致这些类**实际上只跟随
    系统级深色模式，不响应站内手动切换按钮**——已改成 CSS 变量驱动，从根上解决。
  - 几处 `bg-[rgb(var(--color-x))/0.5]` 这种透明度斜杠写在括号外的无效 Tailwind
    语法（不会生效，也不会报错，是"隐形"的失效样式）。
  - 表单校验错误提示、危险按钮等红色统一改为跟随 `--color-danger`，警告色跟随
    `--color-warning`，成功色跟随 `--color-success`，之后想统一改配色方案不用
    再逐处翻找。
- 清理了因为不再需要 `isDarkMode` 判断而变成"未使用变量"的 import / 声明，
  避免 `vue-tsc` 类型检查报错。

## 你需要做的

由于本次环境没有外网，无法在这里 `pnpm install / pnpm build`，所以交付的是
**修好的完整源码**，不是编译产物。请在你有依赖的环境（比如你原来那个容器）里：

```bash
pnpm install   # 或 npm install
pnpm build     # 或 npm run build
```

构建产物在 `dist/` 目录，把里面的内容整个替换掉你现在部署的 `2024` 主题目录即可。

## 如果还想调整配色本身

只需要改 `src/assets/style/main.css` 里 `:root` 和 `:root.dark` 两块变量
（比如 `--color-accent` 改成别的颜色），全站会自动跟着变——这也是这次改造的
意义所在：以后不用再一个个组件去找写死的颜色了。
