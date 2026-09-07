<template>
  <div
    class="mb-5 grid grid-cols-2 rounded-2xl border p-1 sm:mb-6"
    :class="'border-[rgb(var(--color-border))] bg-[rgb(var(--color-surface-muted)/0.6)]'"
  >
    <button
      type="button"
      @click="selectType('file')"
      class="flex items-center justify-center gap-2 rounded-xl px-4 py-2 text-sm font-semibold transition-all duration-300 sm:py-2.5"
      :class="getButtonClass('file')"
    >
      <FileIcon class="h-4 w-4" />
      {{ t('nav.sendFile') }}
    </button>
    <button
      type="button"
      @click="selectType('text')"
      class="flex items-center justify-center gap-2 rounded-xl px-4 py-2 text-sm font-semibold transition-all duration-300 sm:py-2.5"
      :class="getButtonClass('text')"
    >
      <FileTextIcon class="h-4 w-4" />
      {{ t('send.sendText') }}
    </button>
  </div>
</template>

<script setup lang="ts">
import { FileIcon, FileTextIcon } from 'lucide-vue-next'
import type { SendType } from '@/types'
import { useI18n } from 'vue-i18n'

const { t } = useI18n()

interface Props {
  selectedType: SendType
}

interface Emits {
  'update:selectedType': [type: SendType]
}

const props = defineProps<Props>()
const emit = defineEmits<Emits>()

const selectType = (type: SendType) => {
  emit('update:selectedType', type)
}

const getButtonClass = (type: SendType) => {
  if (props.selectedType === type) {
    return 'bg-[rgb(var(--color-accent))] text-[rgb(var(--color-accent-contrast))] shadow-[0_8px_22px_-12px_rgb(var(--color-accent)/0.45)]'
  }

  return 'text-[rgb(var(--color-text-subtle))] hover:text-[rgb(var(--color-text-strong))]'
}
</script>
