<template>
  <div class="space-y-2">
    <label
      class="block text-sm font-medium"
      :class="['text-[rgb(var(--color-text-muted))]']"
    >
      {{ label }}
    </label>
    <div class="flex items-center space-x-2">
      <input
        type="number"
        :value="modelValue"
        :min="min"
        :max="max"
        step="1"
        class="w-24 rounded-xl border px-4 py-2.5 shadow-sm outline-none transition-all duration-200 ease-in-out focus:border-[rgb(var(--color-focus-ring))] focus:ring-2 focus:ring-[rgb(var(--color-focus-ring)/0.35)]"
        :class="[
          'border-[rgb(var(--color-border))] bg-[rgb(var(--color-surface-input)/0.8)] text-[rgb(var(--color-text-strong))] placeholder-[rgb(var(--color-text-subtle))] hover:border-[rgb(var(--color-border-strong))]'
        ]"
        @input="handleInput"
      />
      <span :class="['text-[rgb(var(--color-text-muted))]']">{{ suffix }}</span>
    </div>
  </div>
</template>

<script setup lang="ts">
import { inject } from 'vue'

const props = defineProps<{
  label: string
  modelValue: number
  suffix: string
  min?: number
  max?: number
}>()

const isDarkMode = inject('isDarkMode')

const emit = defineEmits<{
  'update:modelValue': [value: number]
}>()

const handleInput = (event: Event) => {
  const input = event.target as HTMLInputElement
  if (!input.value) {
    emit('update:modelValue', props.min ?? 0)
    return
  }

  const nextValue = input.valueAsNumber
  if (!Number.isNaN(nextValue)) {
    const integerValue = Math.round(nextValue)
    const lowerBound = props.min ?? Number.NEGATIVE_INFINITY
    const upperBound = props.max ?? Number.POSITIVE_INFINITY
    emit('update:modelValue', Math.min(upperBound, Math.max(lowerBound, integerValue)))
  }
}
</script>
