<template>
  <div
    class="relative overflow-hidden rounded-2xl border p-5 shadow-sm backdrop-blur-xl transition-all duration-300 hover:-translate-y-0.5"
    :class="[
      'border-[rgb(var(--color-border))] bg-[rgb(var(--color-surface)/0.75)] shadow-[var(--shadow-panel)]'
    ]"
  >
    <div
      class="absolute inset-x-0 top-0 h-px bg-gradient-to-r from-transparent via-[rgb(var(--color-accent)/0.5)] to-transparent"
    ></div>
    <div class="flex items-center justify-between">
      <div>
        <p class="text-sm font-medium" :class="['text-[rgb(var(--color-text-muted))]']">
          {{ title }}
        </p>
        <h3
          class="text-2xl font-semibold mt-1"
          :class="['text-[rgb(var(--color-text-strong))]']"
        >
          {{ value }}
        </h3>
      </div>
      <div class="p-3 rounded-full bg-gradient-to-br" :class="iconBgClass">
        <component :is="icon" class="w-6 h-6" :class="iconClass" />
      </div>
    </div>
    <p class="text-sm mt-2" :class="descriptionClass">
      <slot name="description"></slot>
    </p>
  </div>
</template>

<script setup lang="ts">
import { computed } from 'vue'
import type { Component } from 'vue'

interface Props {
  title: string
  value: string | number
  icon: Component
  iconColor: 'zinc'
  descriptionType?: 'success' | 'error' | 'neutral'
}

const props = withDefaults(defineProps<Props>(), {
  descriptionType: 'neutral'
})


const iconBgClass = computed(() => {
  return 'from-[rgb(var(--color-accent)/0.16)] to-[rgb(var(--color-accent-2)/0.14)]'
})

const iconClass = computed(() => {
  return 'text-[rgb(var(--color-accent))]'
})

const descriptionClass = computed(() => {
  const typeMap = {
    success: 'text-[rgb(var(--color-text))]',
    error: 'text-[rgb(var(--color-danger))]',
    neutral: 'text-[rgb(var(--color-text-subtle))]'
  }
  return typeMap[props.descriptionType]
})
</script>
