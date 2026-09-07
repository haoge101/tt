<template>
  <div class="p-6">
    <div class="mb-6 flex flex-col gap-2 sm:flex-row sm:items-end sm:justify-between">
      <div>
        <p class="text-sm" :class="[mutedTextClass]">FileCodeBox Admin</p>
        <h2 class="text-2xl font-bold" :class="[primaryTextClass]">
          {{ t('admin.dashboard.title') }}
        </h2>
        <p class="mt-1 text-xs" :class="[mutedTextClass]">
          {{ t('admin.dashboard.lastUpdated', { time: lastUpdatedText }) }}
        </p>
      </div>
      <button
        type="button"
        :disabled="isLoading"
        @click="fetchDashboardData"
        class="inline-flex items-center justify-center rounded-lg px-4 py-2 text-sm font-medium transition-colors disabled:cursor-not-allowed disabled:opacity-70"
        :class="[
          'bg-[rgb(var(--color-surface))] text-[rgb(var(--color-text-muted))] shadow-sm hover:bg-[rgb(var(--color-surface-muted))]'
        ]"
      >
        <RefreshCwIcon class="mr-2 h-4 w-4" :class="{ 'animate-spin': isLoading }" />
        {{ isLoading ? t('admin.dashboard.refreshing') : t('admin.dashboard.refresh') }}
      </button>
    </div>

    <div
      v-if="errorMessage"
      class="mb-6 rounded-lg border px-4 py-3 text-sm"
      :class="[
        'border-[rgb(var(--color-danger)/0.4)] bg-[rgb(var(--color-danger)/0.12)] text-[rgb(var(--color-danger))]'
      ]"
    >
      {{ errorMessage }}
    </div>

    <div class="grid grid-cols-1 gap-4 md:grid-cols-2 xl:grid-cols-4">
      <StatCard
        :title="t('admin.dashboard.totalFiles')"
        :value="dashboardData.totalFiles"
        :icon="FilesIcon"
        icon-color="zinc"
      >
        <template #description>
          {{ t('admin.dashboard.yesterdayShares', { count: dashboardData.yesterdayCount }) }}
        </template>
      </StatCard>

      <StatCard
        :title="t('admin.dashboard.storageSpace')"
        :value="dashboardData.storageUsedText"
        :icon="HardDriveIcon"
        icon-color="zinc"
      >
        <template #description>
          {{ t('admin.dashboard.todayIncrease', { count: dashboardData.todaySizeText }) }}
        </template>
      </StatCard>

      <StatCard
        :title="t('admin.dashboard.todayShares')"
        :value="dashboardData.todayCount"
        :icon="UploadCloudIcon"
        icon-color="zinc"
      >
        <template #description>
          {{ t('admin.dashboard.yesterdayShares', { count: dashboardData.yesterdayCount }) }}
        </template>
      </StatCard>

      <StatCard
        :title="t('admin.dashboard.totalRetrievals')"
        :value="dashboardData.usedCount"
        :icon="DownloadCloudIcon"
        icon-color="zinc"
      >
        <template #description>
          {{ t('admin.dashboard.serverUptime') }} {{ dashboardData.sysUptimeText }}
        </template>
      </StatCard>
    </div>

    <div v-if="dashboardData.hasExtendedStats" class="mt-6 grid grid-cols-1 gap-6 xl:grid-cols-3">
      <section class="xl:col-span-2 rounded-lg p-5 shadow-sm" :class="[panelClass]">
        <div class="mb-5 flex items-center justify-between">
          <div>
            <h3 class="text-lg font-semibold" :class="[primaryTextClass]">
              {{ t('admin.dashboard.fileHealth') }}
            </h3>
            <p class="text-sm" :class="[mutedTextClass]">
              {{ t('admin.dashboard.fileHealthDesc') }}
            </p>
          </div>
          <ActivityIcon class="h-5 w-5" :class="['text-[rgb(var(--color-text-muted))]']" />
        </div>

        <div class="grid grid-cols-1 gap-4 md:grid-cols-3">
          <MetricProgress
            :label="t('admin.dashboard.activeFileRatio')"
            :value="dashboardData.activeRatio"
            :detail="`${dashboardData.activeCount} / ${dashboardData.totalFiles}`"
            tone="zinc"
          />
          <MetricProgress
            :label="t('admin.dashboard.fileShareRatio')"
            :value="dashboardData.fileRatio"
            :detail="t('admin.dashboard.binaryFiles', { count: dashboardData.fileCount })"
            tone="zinc"
          />
          <MetricProgress
            :label="t('admin.dashboard.textShareRatio')"
            :value="dashboardData.textRatio"
            :detail="t('admin.dashboard.textShares', { count: dashboardData.textCount })"
            tone="zinc"
          />
        </div>

        <div class="mt-6 grid grid-cols-1 gap-3 md:grid-cols-2 xl:grid-cols-5">
          <button
            v-for="action in healthActions"
            :key="action.key"
            type="button"
            class="group flex min-h-28 flex-col justify-between rounded-lg border p-4 text-left transition-colors"
            :class="getHealthActionClass(action.tone)"
            @click="openHealthQueue(action.health)"
          >
            <span class="flex items-start justify-between gap-3">
              <span>
                <span class="block text-2xl font-semibold">{{ action.count }}</span>
                <span class="mt-1 block text-sm font-medium">{{ action.label }}</span>
              </span>
              <component :is="getHealthActionIcon(action.tone)" class="h-5 w-5 shrink-0" />
            </span>
            <span class="mt-3 flex items-center justify-between gap-2 text-xs">
              <span class="line-clamp-2">{{ action.description }}</span>
              <ArrowRightIcon
                class="h-4 w-4 shrink-0 transition-transform group-hover:translate-x-0.5"
              />
            </span>
          </button>
        </div>

        <div class="mt-6 grid grid-cols-1 gap-4 md:grid-cols-2">
          <div class="rounded-lg border p-4" :class="[subtlePanelClass]">
            <p class="text-sm" :class="[mutedTextClass]">
              {{ t('admin.dashboard.expiredFiles') }}
            </p>
            <div class="mt-2 flex items-end justify-between">
              <strong class="text-3xl" :class="[primaryTextClass]">
                {{ dashboardData.expiredCount }}
              </strong>
              <span class="text-sm" :class="[mutedTextClass]">
                {{ t('admin.dashboard.needCleanup') }}
              </span>
            </div>
          </div>

          <div class="rounded-lg border p-4" :class="[subtlePanelClass]">
            <p class="text-sm" :class="[mutedTextClass]">
              {{ t('admin.dashboard.chunkedFiles') }}
            </p>
            <div class="mt-2 flex items-end justify-between">
              <strong class="text-3xl" :class="[primaryTextClass]">
                {{ dashboardData.chunkedCount }}
              </strong>
              <span class="text-sm" :class="[mutedTextClass]">
                {{ dashboardData.enableChunk ? t('common.enabled') : t('common.disabled') }}
              </span>
            </div>
          </div>
        </div>
      </section>

      <section class="theme-text rounded-lg p-5 shadow-sm" :class="[panelClass]">
        <div class="mb-5">
          <h3 class="theme-text-strong text-lg font-semibold">
            {{ t('admin.dashboard.storagePolicy') }}
          </h3>
          <p class="theme-text-muted text-sm">
            {{ t('admin.dashboard.storagePolicyDesc') }}
          </p>
        </div>

        <div class="space-y-4">
          <PolicyRow
            :label="t('admin.dashboard.storageBackend')"
            :value="dashboardData.storageBackend"
          />
          <PolicyRow
            :label="t('admin.dashboard.singleFileLimit')"
            :value="dashboardData.uploadSizeLimitText"
          />
          <PolicyRow
            :label="t('admin.dashboard.guestUpload')"
            :value="dashboardData.openUpload ? t('common.enabled') : t('common.disabled')"
          />
          <PolicyRow :label="t('admin.dashboard.maxSaveTime')" :value="maxSaveTimeText" />
        </div>

        <div class="mt-5">
          <div class="mb-2 flex items-center justify-between text-sm">
            <span class="theme-text-muted">{{ t('admin.dashboard.todayCapacityReference') }}</span>
            <span class="theme-text-strong">{{ dashboardData.todaySizeRatio }}%</span>
          </div>
          <div
            class="h-2 overflow-hidden rounded-full bg-[rgb(var(--color-surface-muted))]"
          >
            <div
              class="h-full rounded-full bg-[rgb(var(--color-accent))]"
              :style="{ width: `${dashboardData.todaySizeRatio}%` }"
            ></div>
          </div>
        </div>
      </section>
    </div>

    <footer
      class="mt-6 flex flex-col gap-2 border-t pt-4 text-xs sm:flex-row sm:items-center sm:justify-between"
      :class="['border-[rgb(var(--color-border))] text-[rgb(var(--color-text-subtle))]']"
    >
      <span>{{ t('admin.dashboard.footerProduct') }}</span>
      <span class="flex flex-wrap items-center justify-end gap-2">
        <span>{{ t('admin.dashboard.backendVersion') }}</span>
        <span
          class="rounded-md border px-2 py-0.5 font-medium"
          :class="[
            'border-[rgb(var(--color-border))] bg-[rgb(var(--color-surface))] text-[rgb(var(--color-text-muted))]'
          ]"
        >
          {{ versionText }}
        </span>
        <span>{{ t('admin.dashboard.frontendVersion') }}</span>
        <span
          class="rounded-md border px-2 py-0.5 font-medium"
          :class="[
            'border-[rgb(var(--color-border))] bg-[rgb(var(--color-surface))] text-[rgb(var(--color-text-muted))]'
          ]"
        >
          {{ buildInfo.displayVersion }}
        </span>
      </span>
    </footer>
  </div>
</template>

<script setup lang="ts">
import { computed, defineComponent, h, onMounted } from 'vue'
import type { Component, PropType } from 'vue'
import { storeToRefs } from 'pinia'
import { useRouter } from 'vue-router'
import {
  ActivityIcon,
  AlertTriangleIcon,
  ArrowRightIcon,
  CheckCircleIcon,
  DownloadCloudIcon,
  FilesIcon,
  HardDriveIcon,
  RefreshCwIcon,
  ShieldCheckIcon,
  UploadCloudIcon
} from 'lucide-vue-next'
import StatCard from '@/components/common/StatCard.vue'
import { useDashboardStats } from '@/composables'
import { useI18n } from 'vue-i18n'
import { ROUTES } from '@/constants'
import { useConfigStore } from '@/stores/configStore'
import type { DashboardHealthAction } from '@/types'
import { buildInfo } from '@/utils/build-info'

const { t } = useI18n()
const router = useRouter()
const configStore = useConfigStore()
const { appVersion } = storeToRefs(configStore)
const { dashboardData, errorMessage, fetchDashboardData, isLoading, lastUpdatedText } =
  useDashboardStats({
    loadFailedMessage: t('admin.dashboard.loadFailed')
  })

const primaryTextClass = computed(() => ('text-[rgb(var(--color-text-strong))]'))
const mutedTextClass = computed(() => ('text-[rgb(var(--color-text-muted))]'))
const versionText = computed(() => appVersion.value || t('admin.dashboard.versionPending'))
const panelClass = computed(() =>
  'border border-[rgb(var(--color-border))] bg-[rgb(var(--color-surface)/0.75)] shadow-[var(--shadow-panel)] backdrop-blur-xl'
)
const subtlePanelClass = computed(() =>
  'border-[rgb(var(--color-border))] bg-[rgb(var(--color-surface-muted)/0.7)]'
)
const maxSaveTimeText = computed(() => {
  if (!dashboardData.maxSaveSeconds) return t('admin.dashboard.noSaveLimit')
  const days = Math.floor(dashboardData.maxSaveSeconds / 86400)
  if (days >= 1) return `${days}${t('common.day')}`
  const hours = Math.floor(dashboardData.maxSaveSeconds / 3600)
  if (hours >= 1) return `${hours}${t('common.hour')}`
  return `${Math.floor(dashboardData.maxSaveSeconds / 60)}${t('common.minute')}`
})

const healthActions = computed<DashboardHealthAction[]>(() => [
  {
    key: 'attention',
    label: t('admin.dashboard.healthActions.attention.title'),
    description: t('admin.dashboard.healthActions.attention.description'),
    count: dashboardData.healthAttentionCount,
    health: 'attention',
    tone: dashboardData.healthAttentionCount > 0 ? 'danger' : 'success'
  },
  {
    key: 'storageIssue',
    label: t('admin.dashboard.healthActions.storageIssue.title'),
    description: t('admin.dashboard.healthActions.storageIssue.description'),
    count: dashboardData.storageIssueCount,
    health: 'storage_issue',
    tone: dashboardData.storageIssueCount > 0 ? 'danger' : 'success'
  },
  {
    key: 'expiringSoon',
    label: t('admin.dashboard.healthActions.expiringSoon.title'),
    description: t('admin.dashboard.healthActions.expiringSoon.description'),
    count: dashboardData.expiringSoonCount,
    health: 'expiring_soon',
    tone: dashboardData.expiringSoonCount > 0 ? 'warning' : 'success'
  },
  {
    key: 'neverRetrieved',
    label: t('admin.dashboard.healthActions.neverRetrieved.title'),
    description: t('admin.dashboard.healthActions.neverRetrieved.description'),
    count: dashboardData.neverRetrievedCount,
    health: 'never_retrieved',
    tone: dashboardData.neverRetrievedCount > 0 ? 'neutral' : 'success'
  },
  {
    key: 'permanent',
    label: t('admin.dashboard.healthActions.permanent.title'),
    description: t('admin.dashboard.healthActions.permanent.description'),
    count: dashboardData.permanentCount,
    health: 'permanent',
    tone: 'success'
  }
])

const healthActionIconMap: Record<DashboardHealthAction['tone'], Component> = {
  danger: AlertTriangleIcon,
  warning: AlertTriangleIcon,
  success: CheckCircleIcon,
  neutral: ShieldCheckIcon
}

const getHealthActionIcon = (tone: DashboardHealthAction['tone']) => healthActionIconMap[tone]

const getHealthActionClass = (tone: DashboardHealthAction['tone']) => {
  const classes: Record<DashboardHealthAction['tone'], string> = {
    danger: 'border-[rgb(var(--color-danger)/0.25)] bg-[rgb(var(--color-danger)/0.1)] text-[rgb(var(--color-danger))] hover:border-[rgb(var(--color-danger)/0.45)]',
    warning: 'border-[rgb(var(--color-warning)/0.25)] bg-[rgb(var(--color-warning)/0.1)] text-[rgb(var(--color-warning))] hover:border-[rgb(var(--color-warning)/0.45)]',
    success: 'border-[rgb(var(--color-success)/0.25)] bg-[rgb(var(--color-success)/0.1)] text-[rgb(var(--color-success))] hover:border-[rgb(var(--color-success)/0.45)]',
    neutral: 'border-[rgb(var(--color-border))] bg-[rgb(var(--color-surface-muted))] text-[rgb(var(--color-text-muted))] hover:border-[rgb(var(--color-border-strong))]'
  }

  return classes[tone]
}

const openHealthQueue = (health: DashboardHealthAction['health']) => {
  void router.push({
    path: ROUTES.FILE_MANAGE,
    query: { health }
  })
}

const MetricProgress = defineComponent({
  name: 'MetricProgress',
  props: {
    label: { type: String, required: true },
    value: { type: Number, required: true },
    detail: { type: String, required: true },
    tone: {
      type: String as PropType<'zinc'>,
      required: true
    }
  },
  setup(props) {
    const toneClass = computed(() => 'bg-[rgb(var(--color-accent))]')

    return () =>
      h('div', { class: 'rounded-lg border p-4 border-[rgb(var(--color-border))]' }, [
        h('div', { class: 'mb-2 flex items-center justify-between text-sm' }, [
          h('span', { class: 'text-[rgb(var(--color-text-muted))]' }, props.label),
          h('span', { class: 'font-medium text-[rgb(var(--color-text-strong))]' }, `${props.value}%`)
        ]),
        h('div', { class: 'h-2 overflow-hidden rounded-full bg-[rgb(var(--color-surface-muted))]' }, [
          h('div', {
            class: ['h-full rounded-full', toneClass.value],
            style: { width: `${props.value}%` }
          })
        ]),
        h('p', { class: 'mt-2 text-sm text-[rgb(var(--color-text-muted))]' }, props.detail)
      ])
  }
})

const PolicyRow = defineComponent({
  name: 'PolicyRow',
  props: {
    label: { type: String, required: true },
    value: { type: String, required: true }
  },
  setup(props) {
    return () =>
      h(
        'div',
        {
          class:
            'theme-divider flex items-center justify-between gap-4 border-b pb-3 last:border-b-0'
        },
        [
          h('span', { class: 'theme-text-muted text-sm' }, props.label),
          h('span', { class: 'theme-text-strong text-sm font-medium' }, props.value)
        ]
      )
  }
})

onMounted(() => {
  void fetchDashboardData()
})
</script>
