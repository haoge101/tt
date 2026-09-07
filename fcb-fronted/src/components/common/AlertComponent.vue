<template>
  <transition-group
    name="alert-fade"
    tag="div"
    class="fixed left-4 right-4 top-4 z-50 space-y-3 sm:left-auto sm:w-[24rem]"
  >
    <div
      v-for="alert in alerts"
      :key="alert.id"
      :class="['w-full overflow-hidden rounded-2xl border shadow-2xl backdrop-blur-2xl', cardClass]"
    >
      <div class="flex items-start gap-3 p-4">
        <div
          class="mt-0.5 flex h-9 w-9 flex-shrink-0 items-center justify-center rounded-xl"
          :class="iconToneClass(alert.type)"
        >
          <component :is="alertIcons[alert.type]" class="h-5 w-5" />
        </div>
        <div class="min-w-0 flex-1">
          <p class="break-words text-sm font-medium leading-5" :class="messageClass">
            {{ alert.message }}
          </p>
        </div>
        <button
          @click="removeAlert(alert.id)"
          class="inline-flex rounded-lg p-1.5 transition-colors duration-200"
          :class="closeClass"
        >
          <span class="sr-only">{{ t('common.close') }}</span>
          <X class="h-4 w-4" />
        </button>
      </div>
      <div class="h-0.5" :class="progressTrackClass">
        <div
          class="h-full transition-all duration-100 ease-out"
          :class="progressToneClass(alert.type)"
          :style="{ width: `${alert.progress}%` }"
        ></div>
      </div>
    </div>
  </transition-group>
</template>

<script setup lang="ts">
import { storeToRefs } from 'pinia'
import { useAlertStore } from '@/stores/alertStore'
import { CheckCircle, AlertTriangle, AlertCircle, Info, X } from 'lucide-vue-next'
import { computed, onMounted, onUnmounted } from 'vue'
import { useI18n } from 'vue-i18n'

const { t } = useI18n()

const alertStore = useAlertStore()
const { alerts } = storeToRefs(alertStore)
const { removeAlert, startProgressTimer, stopProgressTimer } = alertStore

type AlertType = 'success' | 'error' | 'warning' | 'info'

const alertIcons = {
  success: CheckCircle,
  error: AlertTriangle,
  warning: AlertCircle,
  info: Info
}

const cardClass = computed(() =>
  'border-[rgb(var(--color-border))] bg-[rgb(var(--color-surface)/0.9)] shadow-[var(--shadow-panel)]'
)

const messageClass = computed(() => ('text-[rgb(var(--color-text-strong))]'))
const closeClass = computed(() =>
  'text-[rgb(var(--color-text-subtle))] hover:bg-[rgb(var(--color-surface-muted))] hover:text-[rgb(var(--color-text-muted))]'
)
const progressTrackClass = computed(() =>
  'bg-[rgb(var(--color-text)/0.05)]'
)

const iconToneClass = (type: AlertType) => {
  const classes: Record<AlertType, string> = {
    success: 'bg-[rgb(var(--color-success)/0.12)] text-[rgb(var(--color-success))]',
    info: 'bg-[rgb(var(--color-accent)/0.12)] text-[rgb(var(--color-accent))]',
    warning: 'bg-[rgb(var(--color-warning)/0.12)] text-[rgb(var(--color-warning))]',
    error: 'bg-[rgb(var(--color-danger)/0.12)] text-[rgb(var(--color-danger))]'
  }
  return classes[type]
}

const progressToneClass = (type: AlertType) => {
  const classes: Record<AlertType, string> = {
    success: 'bg-[rgb(var(--color-success))]',
    info: 'bg-[rgb(var(--color-accent))]',
    warning: 'bg-[rgb(var(--color-warning))]',
    error: 'bg-[rgb(var(--color-danger))]'
  }
  return classes[type]
}

onMounted(() => {
  startProgressTimer()
})

onUnmounted(() => {
  stopProgressTimer()
})
</script>

<style scoped>
.alert-fade-enter-active,
.alert-fade-leave-active {
  transition:
    opacity 0.24s cubic-bezier(0.22, 1, 0.36, 1),
    transform 0.24s cubic-bezier(0.22, 1, 0.36, 1);
}

.alert-fade-enter-from,
.alert-fade-leave-to {
  opacity: 0;
  transform: translateY(-8px) scale(0.98);
}
</style>
