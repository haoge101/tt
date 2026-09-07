<template>
  <div class="flex flex-col space-y-3">
    <label :class="['text-sm font-medium', 'text-[rgb(var(--color-text-muted))]']">
      {{ t('send.expiration.label') }}
    </label>
    <div class="relative flex-grow group">
      <div
        :class="[
          'relative h-12 rounded-2xl border transition-all duration-300 shadow-sm',
          'bg-[rgb(var(--color-surface))] border-[rgb(var(--color-border))] group-hover:border-[rgb(var(--color-border-strong))] group-hover:shadow-lg group-hover:shadow-[rgb(var(--shadow-color)/0.15)]'
        ]"
      >
        <template v-if="expirationMethod !== 'forever'">
          <input
            :value="expirationValue"
            @input="updateValue"
            type="number"
            :placeholder="getPlaceholder()"
            min="1"
            :class="[
              'w-full h-full px-5 pr-32 rounded-2xl placeholder-[rgb(var(--color-text-subtle))] transition-all duration-300',
              'focus:outline-none focus:ring-2 focus:ring-offset-0',
              '[appearance:textfield] [&::-webkit-outer-spin-button]:appearance-none [&::-webkit-inner-spin-button]:appearance-none',
              'bg-transparent',
              'text-[rgb(var(--color-text-strong))] focus:ring-[rgb(var(--color-focus-ring)/0.25)] placeholder-[rgb(var(--color-text-subtle))]'
            ]"
          />
          <div
            class="absolute right-28 top-0 h-full flex flex-col border-l"
            :class="['border-[rgb(var(--color-border))]']"
          >
            <button
              type="button"
              @click="incrementValue(1)"
              class="flex-1 px-2 flex items-center justify-center transition-all duration-200"
              :class="[
                'hover:bg-[rgb(var(--color-surface-muted))] text-[rgb(var(--color-text-muted))] hover:text-[rgb(var(--color-text))]'
              ]"
            >
              <svg class="w-3 h-3" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                <path
                  stroke-linecap="round"
                  stroke-linejoin="round"
                  stroke-width="2"
                  d="M5 15l7-7 7 7"
                />
              </svg>
            </button>
            <button
              type="button"
              @click="incrementValue(-1)"
              class="flex-1 px-2 flex items-center justify-center transition-all duration-200"
              :class="[
                'hover:bg-[rgb(var(--color-surface-muted))] text-[rgb(var(--color-text-muted))] hover:text-[rgb(var(--color-text))]'
              ]"
            >
              <svg class="w-3 h-3" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                <path
                  stroke-linecap="round"
                  stroke-linejoin="round"
                  stroke-width="2"
                  d="M19 9l-7 7-7-7"
                />
              </svg>
            </button>
          </div>
        </template>
        <select
          :value="expirationMethod"
          @change="updateMethod"
          :class="[
            'absolute right-0 top-0 h-full appearance-none cursor-pointer transition-all duration-300',
            'focus:outline-none focus:ring-2 focus:ring-offset-0',
            expirationMethod === 'forever'
              ? 'w-full px-5 rounded-2xl'
              : 'w-28 pl-4 pr-9 border-l rounded-r-2xl',
            'text-[rgb(var(--color-text-strong))] border-[rgb(var(--color-border))] focus:ring-[rgb(var(--color-focus-ring)/0.25)] bg-[rgb(var(--color-surface-input)/0.8)]'
          ]"
          :style="{
            color: 'rgb(var(--color-text-strong))',
            backgroundColor: 'rgb(var(--color-surface-input) / 0.8)'
          }"
        >
          <option
            v-for="option in options"
            :key="option.value"
            :value="option.value"
            :class="['bg-[rgb(var(--color-surface))] text-[rgb(var(--color-text-strong))]']"
            :style="{
              color: 'rgb(var(--color-text-strong))',
              backgroundColor: 'rgb(var(--color-surface))'
            }"
          >
            {{ option.label }}
          </option>
        </select>
        <div
          class="absolute pointer-events-none"
          :class="[
            expirationMethod === 'forever' ? 'right-3' : 'right-2',
            'top-1/2 -translate-y-1/2',
            'text-[rgb(var(--color-text-muted))]'
          ]"
        >
          <svg class="w-4 h-4" fill="none" viewBox="0 0 24 24" stroke="currentColor">
            <path
              stroke-linecap="round"
              stroke-linejoin="round"
              stroke-width="2"
              d="M19 9l-7 7-7-7"
            />
          </svg>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { inject } from 'vue'
import { useI18n } from 'vue-i18n'

const { t } = useI18n()

interface Props {
  expirationMethod: string
  expirationValue: string
  options: Array<{
    label: string
    value: string
  }>
}

interface Emits {
  'update:expirationMethod': [value: string]
  'update:expirationValue': [value: string]
}

const props = defineProps<Props>()
const emit = defineEmits<Emits>()
const isDarkMode = inject('isDarkMode')

const updateMethod = (event: Event) => {
  const target = event.target as HTMLSelectElement
  emit('update:expirationMethod', target.value)
}

const updateValue = (event: Event) => {
  const target = event.target as HTMLInputElement
  emit('update:expirationValue', target.value)
}

const incrementValue = (delta: number) => {
  const currentValue = parseInt(props.expirationValue) || 0
  const newValue = Math.max(1, currentValue + delta)
  emit('update:expirationValue', newValue.toString())
}

const getPlaceholder = () => {
  switch (props.expirationMethod) {
    case 'count':
      return t('send.expiration.placeholders.count')
    case 'minute':
      return t('send.expiration.placeholders.minutes')
    case 'hour':
      return t('send.expiration.placeholders.hours')
    case 'day':
      return t('send.expiration.placeholders.days')
    default:
      return t('send.expiration.placeholders.default')
  }
}
</script>
