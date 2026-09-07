<template>
  <Teleport to="body">
    <Transition
      enter-active-class="transition duration-300 ease-out"
      enter-from-class="translate-y-full opacity-0"
      enter-to-class="translate-y-0 opacity-100"
      leave-active-class="transition duration-200 ease-in"
      leave-from-class="translate-y-0 opacity-100"
      leave-to-class="translate-y-full opacity-0"
    >
      <div
        v-if="shouldShow"
        class="fixed inset-x-0 bottom-0 z-40 flex justify-center px-3 pb-[max(0.75rem,env(safe-area-inset-bottom))] sm:px-4 sm:pb-4"
      >
        <div
          class="group relative flex w-full max-w-3xl items-center overflow-hidden rounded-2xl border shadow-[var(--shadow-panel)] backdrop-blur-xl"
          :class="'border-[rgb(var(--color-border))] bg-[rgb(var(--color-surface)/0.92)]'"
        >
          <div
            class="absolute inset-x-0 top-0 h-px bg-gradient-to-r from-transparent via-[rgb(var(--color-accent)/0.4)] to-transparent"
          ></div>

          <!-- 如果有 ad_code, 使用 AdCode 组件注入 -->
          <component
            v-if="adCode"
            is="div"
            class="block flex-1"
          >
            <AdCode :code="adCode" />
          </component>

          <!-- 否则回退到原来的图片+链接 -->
          <component
            v-else
            :is="linkUrl ? 'a' : 'div'"
            v-bind="linkUrl ? { href: linkUrl, target: '_blank', rel: 'noopener noreferrer' } : {}"
            class="block flex-1"
            :class="linkUrl ? 'cursor-pointer' : ''"
          >
            <img
              v-if="imageUrl"
              :src="imageUrl"
              :alt="altText"
              loading="lazy"
              class="block h-auto max-h-20 w-full object-cover transition-transform duration-500 group-hover:scale-[1.01] sm:max-h-24"
              @error="hasImageError = true"
            />
          </component>

          <span
            class="absolute left-2 top-2 rounded-md px-1.5 py-0.5 text-[10px] font-medium tracking-wide"
            :class="'bg-[rgb(var(--color-overlay)/0.55)] text-white'"
          >
            {{ t('common.adLabel') }}
          </span>
          <button
            type="button"
            :aria-label="t('common.close')"
            class="absolute right-2 top-2 rounded-full p-1 transition-colors"
            :class="'bg-[rgb(var(--color-overlay)/0.55)] text-white hover:bg-[rgb(var(--color-overlay)/0.75)]'"
            @click="dismissed = true"
          >
            <XIcon class="h-3.5 w-3.5" />
          </button>
        </div>
      </div>
    </Transition>
  </Teleport>
</template>

<script setup lang="ts">
import { computed, ref } from 'vue'
import { storeToRefs } from 'pinia'
import { useI18n } from 'vue-i18n'
import { XIcon } from 'lucide-vue-next'
import { useConfigStore } from '@/stores/configStore'
import AdCode from './AdCode.vue'

const { t } = useI18n()
const configStore = useConfigStore()
const { config } = storeToRefs(configStore)
const hasImageError = ref(false)
// 每次进入页面（组件重新挂载）都会重新展示，关闭只对当前这次浏览生效。
const dismissed = ref(false)

// 保留兼容字段
const imageUrl = computed(() => config.value.ad_image_url || '')
const linkUrl = computed(() => config.value.ad_link_url || '')
const altText = computed(() => config.value.ad_alt || t('common.adLabel'))

// 优先读取 ad_code（管理后台存入原始联盟代码）
const adCode = computed(() => {
  // 后端/管理页可把广告代码存到 config.ad_code
  return (config.value as any).ad_code || null
})

const shouldShow = computed(
  () =>
    Number(config.value.ad_enabled) === 1 &&
    !hasImageError.value &&
    !dismissed.value &&
    // 如果没有 image 且没有 ad_code，则不显示
    (!!adCode.value || !!imageUrl.value)
)
</script>

<style scoped>
/* 保留原有样式 */
</style>
