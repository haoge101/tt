<template>
  <div class="mb-7 flex flex-col items-center text-center sm:mb-10">
    <button
      type="button"
      @click="$emit('title-click')"
      class="group relative mb-4 flex h-14 w-14 items-center justify-center rounded-[1rem] border transition-transform duration-300 hover:scale-105 sm:mb-6 sm:h-16 sm:w-16 sm:rounded-[1.25rem]"
      :class="
        'border-[rgb(var(--color-border))] bg-[rgb(var(--color-surface-muted))] text-[rgb(var(--color-text-strong))] shadow-[inset_0_1px_1px_rgb(var(--color-text-strong)/0.06)]'
      "
      :aria-label="title"
    >
      <div
        class="absolute inset-0 rounded-[1rem] opacity-0 blur-md transition-opacity duration-300 group-hover:opacity-100 sm:rounded-[1.25rem]"
        :class="'bg-[rgb(var(--color-border-strong)/0.5)]'"
      ></div>
      <component :is="headerIcon" class="relative z-10 h-7 w-7 sm:h-8 sm:w-8" :stroke-width="1.5" />
    </button>
    <h1
      @click="$emit('title-click')"
      class="mb-2 cursor-pointer text-xl font-semibold tracking-tight sm:text-2xl"
      :class="'text-[rgb(var(--color-text-strong))]'"
    >
      {{ title }}
    </h1>
    <p
      v-if="subtitle"
      class="text-xs font-medium sm:text-sm"
      :class="'text-[rgb(var(--color-text-muted))]'"
    >
      {{ subtitle }}
    </p>
  </div>
</template>

<script setup lang="ts">
import { computed, inject } from 'vue'
import { CloudDownloadIcon, SendIcon } from 'lucide-vue-next'

interface Props {
  title: string
  subtitle?: string
  mode?: 'retrieve' | 'send'
}

interface Emits {
  'title-click': []
}

const props = withDefaults(defineProps<Props>(), {
  subtitle: '',
  mode: 'retrieve'
})
defineEmits<Emits>()

const isDarkMode = inject('isDarkMode')
const headerIcon = computed(() => (props.mode === 'send' ? SendIcon : CloudDownloadIcon))
</script>
