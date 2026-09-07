<template>
  <div class="space-y-2">
    <label
      class="block text-sm font-medium mb-2"
      :class="['text-[rgb(var(--color-text-muted))]']"
    >
      {{ label }}
    </label>
    <div class="flex items-center">
      <button
        type="button"
        class="relative inline-flex h-6 w-11 flex-shrink-0 cursor-pointer rounded-full border-2 border-transparent transition-colors duration-200 ease-in-out focus:outline-none focus:ring-2 focus:ring-[rgb(var(--color-focus-ring)/0.35)] focus:ring-offset-2"
        :class="[
          modelValue === 1
            ? 'bg-[rgb(var(--color-accent))]'
            : 'bg-[rgb(var(--color-border-strong))]'
        ]"
        role="switch"
        :aria-checked="modelValue === 1"
        @click="$emit('toggle')"
      >
        <span
          class="pointer-events-none inline-block h-5 w-5 transform rounded-full shadow ring-0 transition duration-200 ease-in-out"
          :class="[
            modelValue === 1 ? 'translate-x-5' : 'translate-x-0',
            modelValue === 1 ? 'bg-[rgb(var(--color-accent-contrast))]' : 'bg-white'
          ]"
        />
      </button>
      <span class="ml-3 text-sm" :class="['text-[rgb(var(--color-text-muted))]']">
        {{ modelValue === 1 ? enabledText : disabledText }}
      </span>
    </div>
  </div>
</template>

<script setup lang="ts">
defineProps<{
  label: string
  modelValue: number
  enabledText: string
  disabledText: string
}>()

defineEmits<{
  toggle: []
}>()
</script>
