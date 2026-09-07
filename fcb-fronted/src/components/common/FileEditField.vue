<template>
  <div class="space-y-2 group">
    <label
      class="text-sm font-medium flex items-center space-x-2 transition-colors duration-200"
      :class="[
        'text-[rgb(var(--color-text-muted))] group-focus-within:text-[rgb(var(--color-text-strong))]'
      ]"
    >
      <span>{{ label }}</span>
      <div
        class="h-px flex-1 transition-colors duration-200"
        :class="[
          'bg-[rgb(var(--color-border-strong))] group-focus-within:bg-[rgb(var(--color-accent)/0.35)]'
        ]"
      ></div>
    </label>
    <div class="relative rounded-lg shadow-sm">
      <input
        :type="type"
        :value="modelValue ?? ''"
        class="block w-full rounded-lg border-0 py-2.5 pl-4 pr-10 transition-all duration-200 focus:ring-2 focus:ring-inset sm:text-sm"
        :class="[
          'bg-[rgb(var(--color-surface-input)/0.8)] text-[rgb(var(--color-text-strong))] placeholder-[rgb(var(--color-text-subtle))] focus:ring-[rgb(var(--color-focus-ring)/0.4)]'
        ]"
        :placeholder="placeholder"
        @input="handleInput"
      />
      <div
        class="absolute inset-y-0 right-0 flex items-center pr-3 pointer-events-none transition-opacity duration-200 opacity-0 group-focus-within:opacity-100"
      >
        <CheckIcon class="w-5 h-5" :class="['text-[rgb(var(--color-text-strong))]']" />
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { inject } from 'vue'
import { CheckIcon } from 'lucide-vue-next'

const props = withDefaults(
  defineProps<{
    label: string
    modelValue: string | number | null
    placeholder?: string
    type?: 'text' | 'number' | 'datetime-local'
  }>(),
  {
    placeholder: '',
    type: 'text'
  }
)

const emit = defineEmits<{
  'update:modelValue': [value: string | number | null]
}>()

const isDarkMode = inject('isDarkMode')

const handleInput = (event: Event) => {
  const target = event.target as HTMLInputElement
  if (props.type === 'number') {
    emit('update:modelValue', target.value === '' ? null : target.valueAsNumber)
    return
  }

  emit('update:modelValue', target.value)
}
</script>
