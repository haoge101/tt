<template>
  <div ref="container" class="ad-code-container" />
</template>

<script setup lang="ts">
import { ref, onMounted, onBeforeUnmount } from 'vue'

const props = defineProps<{ code: string | null }>()
const container = ref<HTMLElement | null>(null)
const injectedScripts: HTMLScriptElement[] = []

/**
 * 全局缓存外链脚本 src，避免重复加载
 * 模块级别共享
 */
const loadedScriptSrc = (window as any).__loadedAdScriptSrc as Set<string> | undefined
if (!loadedScriptSrc) {
  ;(window as any).__loadedAdScriptSrc = new Set<string>()
}

function injectCode(html: string, mountEl: HTMLElement) {
  if (!html) return
  const tmp = document.createElement('div')
  tmp.innerHTML = html
  // 将非 script 节点先注入
  const scripts = Array.from(tmp.querySelectorAll('script'))
  // 剩余节点
  Array.from(tmp.childNodes)
    .filter((n) => n.nodeName !== 'SCRIPT')
    .forEach((n) => mountEl.appendChild(n.cloneNode(true)))

  const globalSet: Set<string> = (window as any).__loadedAdScriptSrc

  scripts.forEach((s) => {
    const newScript = document.createElement('script')
    // 复制属性
    for (let i = 0; i < s.attributes.length; i++) {
      const attr = s.attributes[i]
      newScript.setAttribute(attr.name, attr.value)
    }
    const src = s.getAttribute('src')
    if (src) {
      // 避免重复加载外链脚本
      if (globalSet.has(src)) return
      globalSet.add(src)
      newScript.src = src
      newScript.async = s.async
      // 选填：为外链 script 设置加载超时回退逻辑
      let loaded = false
      const timeout = setTimeout(() => {
        if (!loaded) {
          // 超时后可记录或回退，这里仅删除该 script
          try { newScript.remove() } catch {}
        }
      }, 8000) // 8s 超时可调
      newScript.addEventListener('load', () => {
        loaded = true
        clearTimeout(timeout)
      })
      newScript.addEventListener('error', () => {
        loaded = true
        clearTimeout(timeout)
      })
      mountEl.appendChild(newScript)
      injectedScripts.push(newScript)
    } else {
      // 内联脚本：直接注入以执行
      newScript.text = s.textContent || ''
      mountEl.appendChild(newScript)
      injectedScripts.push(newScript)
    }
  })
}

onMounted(() => {
  if (!props.code) return
  const el = container.value
  if (!el) return
  injectCode(props.code, el)
})

onBeforeUnmount(() => {
  // 尝试清理注入的 script（注意：某些广告可能注册全局事件不可完全清理）
  injectedScripts.forEach((s) => {
    try { s.remove() } catch {}
  })
})
</script>

<style scoped>
.ad-code-container { display:flex; justify-content:center; align-items:center; width:100%; }
</style>
