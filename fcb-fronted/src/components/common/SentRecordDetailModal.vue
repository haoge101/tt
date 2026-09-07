<template>
  <transition name="fade">
    <div
      v-if="record"
      class="fixed inset-0 z-50 flex items-center justify-center overflow-y-auto bg-black/60 p-3 backdrop-blur-sm sm:p-4"
    >
      <div
        class="w-full max-w-2xl overflow-hidden rounded-2xl border shadow-2xl transition-all duration-300 ease-out"
        :class="'border-[rgb(var(--color-border))] bg-[rgb(var(--color-surface)/0.96)]'"
      >
        <div
          class="border-b px-4 py-3 sm:px-6 sm:py-4"
          :class="'border-[rgb(var(--color-border))]'"
        >
          <div class="flex items-center justify-between">
            <h3
              class="text-lg font-semibold sm:text-xl"
              :class="'text-[rgb(var(--color-text-strong))]'"
            >
              {{ t('send.fileDetails') }}
            </h3>
            <button
              @click="$emit('close')"
              class="rounded-lg p-1.5 transition-all duration-300 hover:scale-105 active:scale-95 sm:rounded-xl sm:p-2"
              :class="
                'text-[rgb(var(--color-text-muted))] hover:bg-[rgb(var(--color-surface-muted))] hover:text-[rgb(var(--color-text))]'
              "
            >
              <XIcon class="h-4 w-4 sm:h-5 sm:w-5" />
            </button>
          </div>
        </div>

        <div class="p-4 sm:p-6">
          <div
            class="mb-4 rounded-2xl p-3 sm:mb-6 sm:p-4"
            :class="'bg-[rgb(var(--color-surface)/0.92)]'"
          >
            <div class="flex items-center mb-3 sm:mb-4">
              <div class="rounded-xl p-2 sm:p-3" :class="'bg-[rgb(var(--color-surface))]'">
                <FileIcon
                  class="h-5 w-5 sm:h-6 sm:w-6"
                  :class="'text-[rgb(var(--color-text))]'"
                />
              </div>
              <div class="ml-3 sm:ml-4 min-w-0 flex-1">
                <h4
                  class="truncate text-sm font-medium sm:text-base"
                  :class="'text-[rgb(var(--color-text-strong))]'"
                >
                  {{ record.filename }}
                </h4>
                <p
                  class="truncate text-xs sm:text-sm"
                  :class="'text-[rgb(var(--color-text-muted))]'"
                >
                  {{ record.size }} · {{ record.date }}
                </p>
              </div>
            </div>
            <div class="grid grid-cols-2 gap-3 sm:gap-4">
              <div class="flex items-center min-w-0">
                <ClockIcon
                  class="w-3.5 h-3.5 sm:w-4 sm:h-4 mr-1.5 sm:mr-2 flex-shrink-0"
                  :class="'text-[rgb(var(--color-text-muted))]'"
                />
                <span
                  class="text-xs sm:text-sm truncate"
                  :class="'text-[rgb(var(--color-text-muted))]'"
                >
                  {{ record.expiration }}
                </span>
              </div>
              <div class="flex items-center min-w-0">
                <ShieldCheckIcon
                  class="w-3.5 h-3.5 sm:w-4 sm:h-4 mr-1.5 sm:mr-2 flex-shrink-0"
                  :class="'text-[rgb(var(--color-text-muted))]'"
                />
                <span
                  class="text-xs sm:text-sm truncate"
                  :class="'text-[rgb(var(--color-text-muted))]'"
                >
                  安全加密
                </span>
              </div>
            </div>
          </div>

          <div class="grid grid-cols-1 md:grid-cols-2 gap-4 sm:gap-6">
            <div class="space-y-3 sm:space-y-4">
              <div
                class="rounded-2xl p-4 sm:p-5"
                :class="
                  'bg-[rgb(var(--color-accent))] text-[rgb(var(--color-accent-contrast))] shadow-[0_14px_28px_-16px_rgb(var(--color-accent)/0.45)]'
                "
              >
                <div class="flex items-center justify-between mb-3 sm:mb-4">
                  <h4 class="font-medium text-sm sm:text-base">取件码</h4>
                  <button
                    @click="$emit('copy-code', record)"
                    class="p-1.5 sm:p-2 rounded-full hover:bg-white/10 transition-colors"
                  >
                    <ClipboardCopyIcon class="w-4 h-4 sm:w-5 sm:h-5" />
                  </button>
                </div>
                <p class="text-2xl sm:text-3xl font-bold tracking-wider text-center break-all">
                  {{ record.retrieveCode }}
                </p>
              </div>

              <div
                class="rounded-2xl p-3 sm:p-4"
                :class="'bg-[rgb(var(--color-surface)/0.92)]'"
              >
                <div class="flex items-center justify-between mb-2 sm:mb-3">
                  <h4
                    class="font-medium text-sm sm:text-base flex items-center min-w-0"
                    :class="'text-[rgb(var(--color-text-strong))]'"
                  >
                    <TerminalIcon
                      class="mr-1.5 h-4 w-4 flex-shrink-0 sm:mr-2 sm:h-5 sm:w-5"
                      :class="'text-[rgb(var(--color-text-muted))]'"
                    />
                    <span class="truncate">wget下载</span>
                  </h4>
                  <button
                    @click="$emit('copy-wget', record)"
                    class="flex-shrink-0 rounded-lg p-1.5 transition-colors sm:rounded-xl sm:p-2"
                    :class="'hover:bg-[rgb(var(--color-surface-muted))]'"
                  >
                    <ClipboardCopyIcon
                      class="h-4 w-4 sm:h-5 sm:w-5"
                      :class="'text-[rgb(var(--color-text-muted))]'"
                    />
                  </button>
                </div>
                <p
                  class="text-xs sm:text-sm font-mono break-all line-clamp-2"
                  :class="'text-[rgb(var(--color-text-muted))]'"
                >
                  点击复制wget命令
                </p>
              </div>
            </div>

            <div
              class="flex flex-col items-center rounded-2xl p-4 sm:p-5"
              :class="'bg-[rgb(var(--color-surface)/0.92)]'"
            >
              <div class="mb-3 rounded-xl bg-white p-3 shadow-sm sm:mb-4 sm:p-4">
                <QRCode :value="qrValue" :size="140" level="M" class="sm:w-[160px] sm:h-[160px]" />
              </div>
              <p
                class="text-xs sm:text-sm truncate max-w-full"
                :class="'text-[rgb(var(--color-text-muted))]'"
              >
                扫描二维码快速取件
              </p>
            </div>
          </div>
        </div>

        <div
          class="border-t px-4 py-3 sm:px-6 sm:py-4"
          :class="'border-[rgb(var(--color-border))]'"
        >
          <button
            @click="$emit('copy-link', record)"
            class="w-full rounded-xl px-4 py-2 text-sm font-semibold transition-colors sm:rounded-2xl sm:px-6 sm:py-3 sm:text-base"
            :class="
              'bg-[rgb(var(--color-accent))] text-[rgb(var(--color-accent-contrast))] hover:brightness-110'
            "
          >
            复制取件链接
          </button>
        </div>
      </div>
    </div>
  </transition>
</template>

<script setup lang="ts">
import { computed, inject } from 'vue'
import {
  ClipboardCopyIcon,
  ClockIcon,
  FileIcon,
  ShieldCheckIcon,
  TerminalIcon,
  XIcon
} from 'lucide-vue-next'
import QRCode from 'qrcode.vue'
import { useI18n } from 'vue-i18n'
import type { SentFileRecord } from '@/types'

const props = defineProps<{
  record: SentFileRecord | null
  getQRCodeValue: (record: SentFileRecord) => string
}>()

defineEmits<{
  close: []
  'copy-code': [record: SentFileRecord]
  'copy-link': [record: SentFileRecord]
  'copy-wget': [record: SentFileRecord]
}>()

const { t } = useI18n()
const isDarkMode = inject('isDarkMode')
const qrValue = computed(() => (props.record ? props.getQRCodeValue(props.record) : ''))
</script>

<style scoped>
.fade-enter-active,
.fade-leave-active {
  transition:
    opacity 0.3s ease,
    transform 0.3s ease;
}

.fade-enter-from,
.fade-leave-to {
  opacity: 0;
  transform: translateY(10px);
}
</style>
