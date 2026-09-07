<template>
  <button
    :type="type"
    :disabled="disabled || loading"
    @click="$emit('click', $event)"
    class="inline-flex items-center justify-center rounded-xl px-4 py-2 font-medium transition-all duration-200 focus:outline-none focus:ring-2 focus:ring-offset-2 disabled:cursor-not-allowed disabled:opacity-50"
    :class="[
      sizeClasses,
      variantClasses,
      loading ? 'cursor-wait' : '',
      disabled ? 'pointer-events-none' : ''
    ]"
  >
    <slot name="icon" v-if="$slots.icon && !loading"></slot>
    <div
      v-if="loading"
      class="animate-spin rounded-full h-4 w-4 border-2 border-current border-t-transparent mr-2"
    ></div>
    <slot></slot>
  </button>
</template>

<script setup lang="ts">
import { computed } from 'vue'
import { useInjectedDarkMode } from '@/composables'

interface Props {
  variant?: 'primary' | 'secondary' | 'danger' | 'success' | 'outline'
  size?: 'sm' | 'md' | 'lg'
  type?: 'button' | 'submit' | 'reset'
  disabled?: boolean
  loading?: boolean
}

const props = withDefaults(defineProps<Props>(), {
  variant: 'primary',
  size: 'md',
  type: 'button',
  disabled: false,
  loading: false
})

defineEmits<{
  click: [event: MouseEvent]
}>()

const isDarkMode = useInjectedDarkMode()

const sizeClasses = computed(() => {
  const sizes = {
    sm: 'px-3 py-1.5 text-sm',
    md: 'px-4 py-2 text-sm',
    lg: 'px-6 py-3 text-base'
  }
  return sizes[props.size]
})

const variantClasses = computed(() => {
  const baseClasses = 'focus:ring-2 focus:ring-offset-2'
  void isDarkMode.value // 主题色由 CSS 变量驱动，无需再按 isDarkMode 分支

  if (props.variant === 'primary') {
    return `${baseClasses} bg-[rgb(var(--color-accent))] text-[rgb(var(--color-accent-contrast))] hover:brightness-110 focus:ring-[rgb(var(--color-focus-ring)/0.35)] shadow-[0_12px_24px_-18px_rgb(var(--color-accent)/0.45)]`
  }

  if (props.variant === 'secondary') {
    return `${baseClasses} border border-[rgb(var(--color-border))] bg-[rgb(var(--color-surface)/0.7)] text-[rgb(var(--color-text-muted))] hover:bg-[rgb(var(--color-surface-muted))] focus:ring-[rgb(var(--color-focus-ring)/0.35)]`
  }

  if (props.variant === 'danger') {
    return `${baseClasses} bg-[rgb(var(--color-danger))] text-white hover:brightness-110 focus:ring-[rgb(var(--color-danger)/0.4)]`
  }

  if (props.variant === 'success') {
    return `${baseClasses} bg-[rgb(var(--color-accent))] text-[rgb(var(--color-accent-contrast))] hover:brightness-110 focus:ring-[rgb(var(--color-focus-ring)/0.35)]`
  }

  if (props.variant === 'outline') {
    return `${baseClasses} border border-[rgb(var(--color-border))] text-[rgb(var(--color-text-muted))] hover:bg-[rgb(var(--color-surface-muted))] focus:ring-[rgb(var(--color-focus-ring)/0.35)]`
  }

  return ''
})
</script>
