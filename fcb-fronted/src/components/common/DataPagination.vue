<template>
  <div
    class="mt-4 flex items-center justify-between px-6 py-4 border-t"
    :class="['border-[rgb(var(--color-border))]']"
  >
    <div
      class="flex items-center text-sm"
      :class="['text-[rgb(var(--color-text-muted))]']"
    >
      显示第 {{ (currentPage - 1) * pageSize + 1 }} 到
      {{ Math.min(currentPage * pageSize, total) }} 条，共 {{ total }} 条
    </div>

    <div class="flex items-center space-x-2">
      <button
        @click="$emit('page-change', currentPage - 1)"
        :disabled="currentPage === 1"
        class="inline-flex items-center px-3 py-1.5 rounded-md transition-colors duration-200"
        :class="[
          currentPage === 1
            ? 'bg-[rgb(var(--color-surface-muted))] text-[rgb(var(--color-text-subtle))] cursor-not-allowed'
            : 'bg-[rgb(var(--color-surface)/0.7)] text-[rgb(var(--color-text-muted))] hover:bg-[rgb(var(--color-surface-muted))]'
        ]"
      >
        <ChevronLeftIcon class="w-4 h-4" />
        上一页
      </button>

      <div class="flex items-center space-x-1">
        <template v-for="pageNum in displayedPages" :key="pageNum">
          <button
            v-if="pageNum !== '...'"
            @click="$emit('page-change', pageNum as number)"
            class="inline-flex items-center px-3 py-1.5 rounded-md transition-colors duration-200"
            :class="[
              currentPage === pageNum
                ? 'bg-[rgb(var(--color-text-strong))] text-[rgb(var(--color-surface))]'
                : 'bg-[rgb(var(--color-surface)/0.6)] text-[rgb(var(--color-text-muted))] hover:bg-[rgb(var(--color-surface-muted))]'
            ]"
          >
            {{ pageNum }}
          </button>
          <span v-else class="px-2" :class="['text-[rgb(var(--color-text-muted))]']">
            ...
          </span>
        </template>
      </div>

      <button
        @click="$emit('page-change', currentPage + 1)"
        :disabled="currentPage >= totalPages"
        class="inline-flex items-center px-3 py-1.5 rounded-md transition-colors duration-200"
        :class="[
          currentPage >= totalPages
            ? 'bg-[rgb(var(--color-surface-muted))] text-[rgb(var(--color-text-subtle))] cursor-not-allowed'
            : 'bg-[rgb(var(--color-surface)/0.7)] text-[rgb(var(--color-text-muted))] hover:bg-[rgb(var(--color-surface-muted))]'
        ]"
      >
        下一页
        <ChevronRightIcon class="w-4 h-4" />
      </button>
    </div>
  </div>
</template>

<script setup lang="ts">
import { computed } from 'vue'
import { ChevronLeftIcon, ChevronRightIcon } from 'lucide-vue-next'

interface Props {
  currentPage: number
  pageSize: number
  total: number
}

const props = defineProps<Props>()

defineEmits<{
  'page-change': [page: number]
}>()

// 计算总页数
const totalPages = computed(() => Math.ceil(props.total / props.pageSize))

// 计算要显示的页码
const displayedPages = computed(() => {
  const current = props.currentPage
  const total = totalPages.value
  const delta = 2 // 当前页码前后显示的页码数

  const pages: (number | string)[] = []

  // 始终显示第一页
  pages.push(1)

  // 计算显示范围
  const left = Math.max(2, current - delta)
  const right = Math.min(total - 1, current + delta)

  // 添加省略号和页码
  if (left > 2) {
    pages.push('...')
  }

  for (let i = left; i <= right; i++) {
    pages.push(i)
  }

  if (right < total - 1) {
    pages.push('...')
  }

  // 始终显示最后一页
  if (total > 1) {
    pages.push(total)
  }

  return pages
})
</script>
