<template>
  <div
    class="overflow-hidden rounded-2xl border shadow-sm backdrop-blur-xl transition-all duration-300"
    :class="[
      'border-[rgb(var(--color-border))] bg-[rgb(var(--color-surface)/0.75)] shadow-[var(--shadow-panel)]'
    ]"
  >
    <div
      class="px-6 py-4 border-b"
      :class="['border-[rgb(var(--color-border))]']"
    >
      <h3 class="text-lg font-medium" :class="['text-[rgb(var(--color-text-strong))]']">
        {{ title }}
      </h3>
    </div>
    <div class="overflow-x-auto">
      <table
        class="min-w-full divide-y"
        :class="['divide-[rgb(var(--color-border))]']"
      >
        <thead :class="['bg-[rgb(var(--color-surface-muted)/0.55)]']">
          <tr>
            <th
              v-for="header in headers"
              :key="header"
              class="px-6 py-3.5 text-left text-xs font-medium uppercase tracking-wider"
              :class="['text-[rgb(var(--color-text-muted))]']"
            >
              {{ header }}
            </th>
          </tr>
        </thead>
        <tbody
          :class="[
            'bg-transparent divide-y divide-[rgb(var(--color-border))]'
          ]"
        >
          <slot name="body"></slot>
        </tbody>
      </table>
    </div>
    <slot name="footer"></slot>
  </div>
</template>

<script setup lang="ts">
import { inject } from 'vue'

interface Props {
  title: string
  headers: string[]
}

defineProps<Props>()

const isDarkMode = inject('isDarkMode')
</script>
