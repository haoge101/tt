<template>
  <div
    class="flex items-center justify-between border-t px-5 py-4 transition-colors sm:px-8 sm:py-6"
    :class="'border-[rgb(var(--color-border))] bg-[rgb(var(--color-surface-muted)/0.5)]'"
  >
    <router-link
      v-if="linkText && linkTo"
      :to="linkTo"
      class="group flex items-center gap-1.5 text-xs font-medium transition-colors sm:gap-2 sm:text-sm"
      :class="
        'text-[rgb(var(--color-text-muted))] hover:text-[rgb(var(--color-text-strong))]'
      "
    >
      <SendIcon
        class="h-3.5 w-3.5 transition-transform group-hover:-translate-y-0.5 group-hover:translate-x-0.5 sm:h-4 sm:w-4"
      />
      {{ linkText }}
    </router-link>
    <span v-else></span>

    <button
      type="button"
      @click="$emit('toggle-drawer')"
      class="group flex items-center gap-1.5 text-xs font-medium transition-colors sm:gap-2 sm:text-sm"
      :class="
        'text-[rgb(var(--color-text-muted))] hover:text-[rgb(var(--color-text-strong))]'
      "
    >
      <HistoryIcon class="h-3.5 w-3.5 transition-transform group-hover:-rotate-12 sm:h-4 sm:w-4" />
      {{ drawerText }}
    </button>
  </div>
</template>

<script setup lang="ts">
import { inject } from 'vue'
import { HistoryIcon, SendIcon } from 'lucide-vue-next'

interface Props {
  linkText?: string
  linkTo?: string
  drawerText: string
}

interface Emits {
  'toggle-drawer': []
}

defineProps<Props>()
defineEmits<Emits>()

const isDarkMode = inject('isDarkMode')
</script>
