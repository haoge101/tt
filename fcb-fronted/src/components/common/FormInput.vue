<template>
  <div class="space-y-2">
    <label
      v-if="label"
      class="block text-sm font-medium"
      :class="['text-[rgb(var(--color-text-muted))]']"
    >
      {{ label }}
      <span v-if="required" class="text-[rgb(var(--color-danger))] ml-1">*</span>
    </label>
    <div class="relative">
      <input
        :type="type"
        :value="modelValue"
        @input="$emit('update:modelValue', ($event.target as HTMLInputElement).value)"
        :placeholder="placeholder"
        :required="required"
        :disabled="disabled"
        :minlength="minlength"
        :maxlength="maxlength"
        class="w-full rounded-xl border px-4 py-2.5 shadow-sm outline-none transition-all duration-200 ease-in-out focus:border-[rgb(var(--color-focus-ring))] focus:ring-2 focus:ring-[rgb(var(--color-focus-ring)/0.35)]"
        :class="[
          'border-[rgb(var(--color-border))] bg-[rgb(var(--color-surface-input)/0.8)] text-[rgb(var(--color-text-strong))] placeholder-[rgb(var(--color-text-subtle))] hover:border-[rgb(var(--color-border-strong))]',
          disabled ? 'opacity-50 cursor-not-allowed' : '',
          error ? 'border-[rgb(var(--color-danger))] focus:border-[rgb(var(--color-danger))] focus:ring-[rgb(var(--color-danger)/0.3)]' : ''
        ]"
      />
      <slot name="suffix"></slot>
    </div>
    <p v-if="error" class="text-sm text-[rgb(var(--color-danger))]">{{ error }}</p>
    <p v-if="hint" class="text-sm" :class="['text-[rgb(var(--color-text-muted))]']">
      {{ hint }}
    </p>
  </div>
</template>

<script setup lang="ts">
import { inject } from 'vue'

interface Props {
  modelValue: string
  label?: string
  type?: string
  placeholder?: string
  required?: boolean
  disabled?: boolean
  error?: string
  hint?: string
  minlength?: number
  maxlength?: number
}

withDefaults(defineProps<Props>(), {
  type: 'text',
  required: false,
  disabled: false
})

defineEmits<{
  'update:modelValue': [value: string]
}>()

const isDarkMode = inject('isDarkMode')
</script>
