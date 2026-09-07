<script setup lang="ts">
import { inject } from 'vue'
import { SunIcon, MoonIcon } from 'lucide-vue-next'

const isDarkMode = inject('isDarkMode') as { value: boolean }
const toggleTheme = inject('toggleTheme') as () => void

const toggleColorMode = () => {
  toggleTheme()
}
</script>

<template>
  <button
    @click="toggleColorMode"
    class="rounded-full border p-2.5 shadow-sm backdrop-blur-xl transition-all duration-300 hover:scale-105 active:scale-95 sm:p-3"
    :class="
      'border-[rgb(var(--color-border))] bg-[rgb(var(--color-surface-muted))] text-[rgb(var(--color-text-muted))] hover:text-[rgb(var(--color-text-strong))]'
    "
    aria-label="切换主题"
  >
    <SunIcon v-if="isDarkMode" class="h-5 w-5" />
    <MoonIcon v-else class="h-5 w-5" />
  </button>
</template>
