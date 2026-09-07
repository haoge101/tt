<script setup lang="ts">
import { inject, onMounted } from 'vue'
import { useI18n } from 'vue-i18n'
import { RefreshCwIcon, SaveIcon } from 'lucide-vue-next'
import BaseButton from '@/components/common/BaseButton.vue'
import SettingNumberInput from '@/components/common/SettingNumberInput.vue'
import SettingSwitch from '@/components/common/SettingSwitch.vue'
import { useSystemConfig } from '@/composables'

const isDarkMode = inject('isDarkMode')
const { t } = useI18n()
const {
  config,
  isRefreshing,
  isSaving,
  isDirty,
  fileSize,
  sizeUnit,
  storageLimit,
  storageLimitUnit,
  saveTime,
  saveTimeUnit,
  adminSessionDays,
  refreshConfig,
  submitConfig,
  toggleConfigFlag
} = useSystemConfig()

const updateAllowedFileTypes = (event: Event) => {
  const target = event.target as HTMLInputElement
  config.value.allowed_file_types = target.value
    .split(',')
    .map((item) => item.trim())
    .filter(Boolean)
}

onMounted(() => {
  void refreshConfig()
})
</script>

<template>
  <div class="settings-page p-6">
    <div
      class="theme-surface sticky top-0 z-20 -mx-6 -mt-6 mb-6 border-b px-6 py-4 backdrop-blur"
    >
      <div class="flex flex-col gap-4 lg:flex-row lg:items-center lg:justify-between">
        <div>
          <h2 class="theme-text-strong text-2xl font-bold">
            {{ t('admin.settings.title') }}
          </h2>
          <p
            class="mt-1 text-sm"
            :class="isDirty ? 'theme-warning' : 'theme-text-muted'"
          >
            {{
              isDirty ? t('manage.settings.unsavedChanges') : t('manage.settings.allChangesSaved')
            }}
          </p>
        </div>

        <div class="flex flex-wrap items-center gap-3">
          <BaseButton
            variant="secondary"
            :loading="isRefreshing"
            :disabled="isSaving || isDirty"
            :title="
              isDirty ? t('manage.settings.refreshBlocked') : t('manage.settings.refreshConfig')
            "
            @click="refreshConfig"
          >
            <template #icon>
              <RefreshCwIcon class="mr-2 h-4 w-4" />
            </template>
            {{
              isRefreshing ? t('manage.settings.refreshing') : t('manage.settings.refreshConfig')
            }}
          </BaseButton>

          <BaseButton
            :loading="isSaving"
            :disabled="!isDirty || isRefreshing"
            @click="submitConfig"
          >
            <template #icon>
              <SaveIcon class="mr-2 h-4 w-4" />
            </template>
            {{ isSaving ? t('manage.settings.saving') : t('manage.settings.saveChanges') }}
          </BaseButton>
        </div>
      </div>
    </div>

    <div
      class="theme-panel space-y-6 rounded-2xl border p-6 backdrop-blur-xl"
    >
      <!-- 基本设置 -->
      <section class="space-y-4">
        <h3 class="text-lg font-medium mb-4" :class="['text-[rgb(var(--color-text-strong))]']">
          {{ t('admin.settings.basicSettings') }}
        </h3>

        <!-- 网基本信息 -->
        <div class="grid grid-cols-1 gap-6">
          <div class="space-y-2">
            <label
              class="block text-sm font-medium"
              :class="['text-[rgb(var(--color-text-muted))]']"
            >
              {{ t('admin.settings.siteName') }}
            </label>
            <input
              type="text"
              v-model="config.name"
              class="w-full rounded-md shadow-sm px-4 py-2.5 transition-all duration-200 ease-in-out border focus:ring-2 focus:ring-[rgb(var(--color-focus-ring)/0.35)] focus:border-[rgb(var(--color-focus-ring))] outline-none"
              :class="[
                'border-[rgb(var(--color-border))] bg-[rgb(var(--color-surface-input)/0.8)] text-[rgb(var(--color-text-strong))] placeholder-[rgb(var(--color-text-subtle))] hover:border-[rgb(var(--color-border-strong))]'
              ]"
            />
          </div>

          <div class="space-y-2">
            <label
              class="block text-sm font-medium"
              :class="['text-[rgb(var(--color-text-muted))]']"
            >
              {{ t('admin.settings.websiteDescription') }}
            </label>
            <input
              type="text"
              v-model="config.description"
              class="w-full rounded-md shadow-sm px-4 py-2.5 transition-all duration-200 ease-in-out border focus:ring-2 focus:ring-[rgb(var(--color-focus-ring)/0.35)] focus:border-[rgb(var(--color-focus-ring))] outline-none"
              :class="[
                'border-[rgb(var(--color-border))] bg-[rgb(var(--color-surface-input)/0.8)] text-[rgb(var(--color-text-strong))] placeholder-[rgb(var(--color-text-subtle))] hover:border-[rgb(var(--color-border-strong))]'
              ]"
            />
          </div>

          <div class="space-y-2">
            <label
              class="block text-sm font-medium"
              :class="['text-[rgb(var(--color-text-muted))]']"
            >
              {{ t('admin.settings.adminPassword') }}
            </label>
            <div class="relative">
              <input
                type="password"
                minlength="6"
                v-model="config.admin_token"
                :placeholder="t('admin.settings.passwordPlaceholder')"
                class="w-full rounded-md shadow-sm px-4 py-2.5 transition-all duration-200 ease-in-out border focus:ring-2 focus:ring-[rgb(var(--color-focus-ring)/0.35)] focus:border-[rgb(var(--color-focus-ring))] outline-none"
                :class="[
                  'border-[rgb(var(--color-border))] bg-[rgb(var(--color-surface-input)/0.8)] text-[rgb(var(--color-text-strong))] placeholder-[rgb(var(--color-text-subtle))] hover:border-[rgb(var(--color-border-strong))]'
                ]"
              />
              <div
                class="absolute inset-y-0 right-0 flex items-center pr-3 text-sm text-[rgb(var(--color-text-subtle))]"
                :class="['text-[rgb(var(--color-text-subtle))]']"
              >
                <span class="text-xs">{{ t('admin.settings.passwordNote') }}</span>
              </div>
            </div>
          </div>

          <div class="grid grid-cols-1 gap-6 md:grid-cols-2">
            <div>
              <SettingNumberInput
                v-model="adminSessionDays"
                :label="t('admin.settings.sessionDuration')"
                :suffix="t('common.day')"
                :min="1"
                :max="365"
              />
              <p class="mt-2 text-xs" :class="['text-[rgb(var(--color-text-muted))]']">
                {{ t('admin.settings.sessionDurationHelp') }}
              </p>
            </div>

            <SettingSwitch
              :label="t('admin.settings.showAdminAddress')"
              :model-value="config.showAdminAddr"
              :enabled-text="t('common.enabled')"
              :disabled-text="t('common.disabled')"
              @toggle="toggleConfigFlag('showAdminAddr')"
            />
          </div>

          <div class="space-y-2">
            <label
              class="block text-sm font-medium"
              :class="['text-[rgb(var(--color-text-muted))]']"
            >
              {{ t('admin.settings.keywords') }}
            </label>
            <input
              type="text"
              v-model="config.keywords"
              class="w-full rounded-md shadow-sm px-4 py-2.5 transition-all duration-200 ease-in-out border focus:ring-2 focus:ring-[rgb(var(--color-focus-ring)/0.35)] focus:border-[rgb(var(--color-focus-ring))] outline-none"
              :class="[
                'border-[rgb(var(--color-border))] bg-[rgb(var(--color-surface-input)/0.8)] text-[rgb(var(--color-text-strong))] placeholder-[rgb(var(--color-text-subtle))] hover:border-[rgb(var(--color-border-strong))]'
              ]"
            />
          </div>

          <!-- 主题选择 -->
          <div class="space-y-2">
            <label
              class="block text-sm font-medium"
              :class="['text-[rgb(var(--color-text-muted))]']"
            >
              {{ t('manage.settings.themeSelection') }}
            </label>
            <select
              v-model="config.themesSelect"
              class="w-full rounded-md shadow-sm px-4 py-2.5 transition-all duration-200 ease-in-out border appearance-none bg-no-repeat bg-right focus:ring-2 focus:ring-[rgb(var(--color-focus-ring)/0.35)] focus:border-[rgb(var(--color-focus-ring))] outline-none cursor-pointer"
              :class="[
                'border-[rgb(var(--color-border))] bg-[rgb(var(--color-surface-input)/0.8)] text-[rgb(var(--color-text-strong))] hover:border-[rgb(var(--color-border-strong))]'
              ]"
              style="
                background-image: url('data:image/svg+xml;charset=US-ASCII,%3Csvg%20xmlns%3D%22http%3A%2F%2Fwww.w3.org%2F2000%2Fsvg%22%20width%3D%2220%22%20height%3D%2220%22%20viewBox%3D%220%200%2020%2020%22%20fill%3D%22none%22%3E%3Cpath%20d%3D%22M7%208l3%203%203-3%22%20stroke%3D%22%236B7280%22%20stroke-width%3D%222%22%20stroke-linecap%3D%22round%22%20stroke-linejoin%3D%22round%22%2F%3E%3C%2Fsvg%3E');
              "
            >
              <option v-for="item in config.themesChoices" :value="item.key" :key="item.key">
                {{ item.name }} (by {{ item.author }} V{{ item.version }})
              </option>
            </select>
          </div>
          <div class="space-y-2">
            <label
              class="block text-sm font-medium"
              :class="['text-[rgb(var(--color-text-muted))]']"
            >
              {{ t('manage.settings.robotsFile') }}
            </label>
            <textarea
              v-model="config.robotsText"
              rows="3"
              class="w-full rounded-md shadow-sm px-4 py-2.5 transition-all duration-200 ease-in-out border resize-none focus:ring-2 focus:ring-[rgb(var(--color-focus-ring)/0.35)] focus:border-[rgb(var(--color-focus-ring))] outline-none"
              :class="[
                'border-[rgb(var(--color-border))] bg-[rgb(var(--color-surface-input)/0.8)] text-[rgb(var(--color-text-strong))] placeholder-[rgb(var(--color-text-subtle))] hover:border-[rgb(var(--color-border-strong))]'
              ]"
            ></textarea>
          </div>
        </div>

        <!-- 通知设置 -->
        <div class="grid grid-cols-1 gap-6 mt-8">
          <div class="space-y-2">
            <label
              class="block text-sm font-medium"
              :class="['text-[rgb(var(--color-text-muted))]']"
            >
              {{ t('manage.settings.notificationTitle') }}
            </label>
            <input
              type="text"
              v-model="config.notify_title"
              class="w-full rounded-md shadow-sm px-4 py-2.5 transition-all duration-200 ease-in-out border focus:ring-2 focus:ring-[rgb(var(--color-focus-ring)/0.35)] focus:border-[rgb(var(--color-focus-ring))] outline-none"
              :class="[
                'border-[rgb(var(--color-border))] bg-[rgb(var(--color-surface-input)/0.8)] text-[rgb(var(--color-text-strong))] placeholder-[rgb(var(--color-text-subtle))] hover:border-[rgb(var(--color-border-strong))]'
              ]"
            />
          </div>

          <div class="space-y-2">
            <label
              class="block text-sm font-medium"
              :class="['text-[rgb(var(--color-text-muted))]']"
            >
              {{ t('manage.settings.notificationContent') }}
            </label>
            <textarea
              v-model="config.notify_content"
              rows="3"
              class="w-full rounded-md shadow-sm px-4 py-2.5 transition-all duration-200 ease-in-out border resize-none focus:ring-2 focus:ring-[rgb(var(--color-focus-ring)/0.35)] focus:border-[rgb(var(--color-focus-ring))] outline-none"
              :class="[
                'border-[rgb(var(--color-border))] bg-[rgb(var(--color-surface-input)/0.8)] text-[rgb(var(--color-text-strong))] placeholder-[rgb(var(--color-text-subtle))] hover:border-[rgb(var(--color-border-strong))]'
              ]"
            ></textarea>
          </div>
        </div>

        <!-- 广告设置 -->
        <div class="space-y-4 mt-8">
          <h3 class="text-lg font-medium mb-4" :class="['text-[rgb(var(--color-text-strong))]']">
            {{ t('admin.settings.adSettings') }}
          </h3>

          <SettingSwitch
            :label="t('admin.settings.adEnable')"
            :model-value="config.ad_enabled"
            :enabled-text="t('admin.settings.enabled')"
            :disabled-text="t('admin.settings.disabled')"
            @toggle="toggleConfigFlag('ad_enabled')"
          />
          <p class="text-xs" :class="['text-[rgb(var(--color-text-muted))]']">
            {{ t('admin.settings.adEnableHelp') }}
          </p>

          <div class="grid grid-cols-1 gap-6 sm:grid-cols-2">
            <div class="space-y-2">
              <label class="block text-sm font-medium" :class="['text-[rgb(var(--color-text-muted))]']">
                {{ t('admin.settings.adImageUrl') }}
              </label>
              <input
                type="text"
                v-model="config.ad_image_url"
                :placeholder="t('admin.settings.adImageUrlPlaceholder')"
                class="w-full rounded-md shadow-sm px-4 py-2.5 transition-all duration-200 ease-in-out border focus:ring-2 focus:ring-[rgb(var(--color-focus-ring)/0.35)] focus:border-[rgb(var(--color-focus-ring))] outline-none"
                :class="[
                  'border-[rgb(var(--color-border))] bg-[rgb(var(--color-surface-input)/0.8)] text-[rgb(var(--color-text-strong))] placeholder-[rgb(var(--color-text-subtle))] hover:border-[rgb(var(--color-border-strong))]'
                ]"
              />
            </div>

            <div class="space-y-2">
              <label class="block text-sm font-medium" :class="['text-[rgb(var(--color-text-muted))]']">
                {{ t('admin.settings.adLinkUrl') }}
              </label>
              <input
                type="text"
                v-model="config.ad_link_url"
                :placeholder="t('admin.settings.adLinkUrlPlaceholder')"
                class="w-full rounded-md shadow-sm px-4 py-2.5 transition-all duration-200 ease-in-out border focus:ring-2 focus:ring-[rgb(var(--color-focus-ring)/0.35)] focus:border-[rgb(var(--color-focus-ring))] outline-none"
                :class="[
                  'border-[rgb(var(--color-border))] bg-[rgb(var(--color-surface-input)/0.8)] text-[rgb(var(--color-text-strong))] placeholder-[rgb(var(--color-text-subtle))] hover:border-[rgb(var(--color-border-strong))]'
                ]"
              />
            </div>
          </div>

          <div class="space-y-2">
            <label class="block text-sm font-medium" :class="['text-[rgb(var(--color-text-muted))]']">
              {{ t('admin.settings.adAltText') }}
            </label>
            <input
              type="text"
              v-model="config.ad_alt"
              :placeholder="t('admin.settings.adAltTextPlaceholder')"
              class="w-full rounded-md shadow-sm px-4 py-2.5 transition-all duration-200 ease-in-out border focus:ring-2 focus:ring-[rgb(var(--color-focus-ring)/0.35)] focus:border-[rgb(var(--color-focus-ring))] outline-none"
              :class="[
                'border-[rgb(var(--color-border))] bg-[rgb(var(--color-surface-input)/0.8)] text-[rgb(var(--color-text-strong))] placeholder-[rgb(var(--color-text-subtle))] hover:border-[rgb(var(--color-border-strong))]'
              ]"
            />
          </div>

          <div v-if="config.ad_image_url" class="space-y-2">
            <p class="text-xs font-medium" :class="['text-[rgb(var(--color-text-muted))]']">
              {{ t('admin.settings.adPreview') }}
            </p>
            <img
              :src="config.ad_image_url"
              :alt="config.ad_alt"
              class="max-h-28 w-full max-w-md rounded-xl border object-cover"
              :class="['border-[rgb(var(--color-border))]']"
            />
          </div>
        </div>

        <!-- 存储设置 -->
        <div class="space-y-4">
          <h3
            class="text-lg font-medium mb-4"
            :class="['text-[rgb(var(--color-text-strong))]']"
          >
            {{ t('manage.settings.storageSettings') }}
          </h3>
          <!-- 通知设置 -->
          <div class="space-y-2">
            <label
              class="block text-sm font-medium"
              :class="['text-[rgb(var(--color-text-muted))]']"
            >
              {{ t('manage.settings.storagePath') }}
            </label>
            <input
              type="text"
              :placeholder="t('manage.settings.storagePathPlaceholder')"
              v-model="config.storage_path"
              class="w-full rounded-md shadow-sm px-4 py-2.5 transition-all duration-200 ease-in-out border focus:ring-2 focus:ring-[rgb(var(--color-focus-ring)/0.35)] focus:border-[rgb(var(--color-focus-ring))] outline-none"
              :class="[
                'border-[rgb(var(--color-border))] bg-[rgb(var(--color-surface-input)/0.8)] text-[rgb(var(--color-text-strong))] placeholder-[rgb(var(--color-text-subtle))] hover:border-[rgb(var(--color-border-strong))]'
              ]"
            />
          </div>

          <div class="space-y-4">
            <div class="space-y-2">
              <label
                class="block text-sm font-medium"
                :class="['text-[rgb(var(--color-text-muted))]']"
              >
                {{ t('manage.settings.storageMethod') }}
              </label>
              <select
                v-model="config.file_storage"
                class="w-full rounded-md shadow-sm px-4 py-2.5 transition-all duration-200 ease-in-out border appearance-none bg-no-repeat bg-right focus:ring-2 focus:ring-[rgb(var(--color-focus-ring)/0.35)] focus:border-[rgb(var(--color-focus-ring))] outline-none cursor-pointer"
                :class="[
                  'border-[rgb(var(--color-border))] bg-[rgb(var(--color-surface-input)/0.8)] text-[rgb(var(--color-text-strong))] hover:border-[rgb(var(--color-border-strong))]'
                ]"
                style="
                  background-image: url('data:image/svg+xml;charset=US-ASCII,%3Csvg%20xmlns%3D%22http%3A%2F%2Fwww.w3.org%2F2000%2Fsvg%22%20width%3D%2220%22%20height%3D%2220%22%20viewBox%3D%220%200%2020%2020%22%20fill%3D%22none%22%3E%3Cpath%20d%3D%22M7%208l3%203%203-3%22%20stroke%3D%22%236B7280%22%20stroke-width%3D%222%22%20stroke-linecap%3D%22round%22%20stroke-linejoin%3D%22round%22%2F%3E%3C%2Fsvg%3E');
                "
              >
                <option value="local">{{ t('manage.settings.localStorage') }}</option>
                <option value="s3">{{ t('manage.settings.s3Storage') }}</option>
                <option value="webdav">{{ t('manage.settings.webdavStorage') }}</option>
              </select>
            </div>
            <SettingSwitch
              v-if="config.file_storage === 'local'"
              :label="t('manage.settings.chunkUploadNote')"
              :model-value="config.enableChunk"
              :enabled-text="t('common.enabled')"
              :disabled-text="t('common.disabled')"
              @toggle="toggleConfigFlag('enableChunk')"
            />
            <div v-if="config.file_storage === 'webdav'" class="space-y-4">
              <!-- 通知设置 -->
              <div class="space-y-2">
                <label
                  class="block text-sm font-medium"
                  :class="['text-[rgb(var(--color-text-muted))]']"
                >
                  Webdav URL
                </label>
                <input
                  type="text"
                  :placeholder="t('manage.settings.webdavUrlPlaceholder')"
                  v-model="config.webdav_url"
                  class="w-full rounded-md shadow-sm px-4 py-2.5 transition-all duration-200 ease-in-out border focus:ring-2 focus:ring-[rgb(var(--color-focus-ring)/0.35)] focus:border-[rgb(var(--color-focus-ring))] outline-none"
                  :class="[
                    'border-[rgb(var(--color-border))] bg-[rgb(var(--color-surface-input)/0.8)] text-[rgb(var(--color-text-strong))] placeholder-[rgb(var(--color-text-subtle))] hover:border-[rgb(var(--color-border-strong))]'
                  ]"
                />
              </div>
              <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                <div class="space-y-2">
                  <label
                    class="block text-sm font-medium"
                    :class="['text-[rgb(var(--color-text-muted))]']"
                  >
                    Webdav Username
                  </label>
                  <input
                    type="text"
                    :placeholder="t('manage.settings.webdavUsernamePlaceholder')"
                    v-model="config.webdav_username"
                    class="w-full rounded-md shadow-sm px-4 py-2.5 transition-all duration-200 ease-in-out border focus:ring-2 focus:ring-[rgb(var(--color-focus-ring)/0.35)] focus:border-[rgb(var(--color-focus-ring))] outline-none"
                    :class="[
                      'border-[rgb(var(--color-border))] bg-[rgb(var(--color-surface-input)/0.8)] text-[rgb(var(--color-text-strong))] placeholder-[rgb(var(--color-text-subtle))] hover:border-[rgb(var(--color-border-strong))]'
                    ]"
                  />
                </div>

                <div class="space-y-2">
                  <label
                    class="block text-sm font-medium"
                    :class="['text-[rgb(var(--color-text-muted))]']"
                  >
                    Webdav Password
                  </label>
                  <input
                    type="password"
                    :placeholder="t('manage.settings.webdavPasswordPlaceholder')"
                    v-model="config.webdav_password"
                    class="w-full rounded-md shadow-sm px-4 py-2.5 transition-all duration-200 ease-in-out border focus:ring-2 focus:ring-[rgb(var(--color-focus-ring)/0.35)] focus:border-[rgb(var(--color-focus-ring))] outline-none"
                    :class="[
                      'border-[rgb(var(--color-border))] bg-[rgb(var(--color-surface-input)/0.8)] text-[rgb(var(--color-text-strong))] placeholder-[rgb(var(--color-text-subtle))] hover:border-[rgb(var(--color-border-strong))]'
                    ]"
                  />
                </div>
              </div>
            </div>
            <!-- S3 配置 -->
            <div v-if="config.file_storage === 's3'" class="space-y-4">
              <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                <div class="space-y-2">
                  <label
                    class="block text-sm font-medium"
                    :class="['text-[rgb(var(--color-text-muted))]']"
                  >
                    {{ t('manage.settings.s3AccessKeyId') }}
                  </label>
                  <input
                    type="text"
                    v-model="config.s3_access_key_id"
                    class="w-full rounded-md shadow-sm px-4 py-2.5 transition-all duration-200 ease-in-out border focus:ring-2 focus:ring-[rgb(var(--color-focus-ring)/0.35)] focus:border-[rgb(var(--color-focus-ring))] outline-none"
                    :class="[
                      'border-[rgb(var(--color-border))] bg-[rgb(var(--color-surface-input)/0.8)] text-[rgb(var(--color-text-strong))] placeholder-[rgb(var(--color-text-subtle))] hover:border-[rgb(var(--color-border-strong))]'
                    ]"
                  />
                </div>

                <div class="space-y-2">
                  <label
                    class="block text-sm font-medium"
                    :class="['text-[rgb(var(--color-text-muted))]']"
                  >
                    {{ t('manage.settings.s3SecretAccessKey') }}
                  </label>
                  <input
                    type="password"
                    v-model="config.s3_secret_access_key"
                    class="w-full rounded-md shadow-sm px-4 py-2.5 transition-all duration-200 ease-in-out border focus:ring-2 focus:ring-[rgb(var(--color-focus-ring)/0.35)] focus:border-[rgb(var(--color-focus-ring))] outline-none"
                    :class="[
                      'border-[rgb(var(--color-border))] bg-[rgb(var(--color-surface-input)/0.8)] text-[rgb(var(--color-text-strong))] placeholder-[rgb(var(--color-text-subtle))] hover:border-[rgb(var(--color-border-strong))]'
                    ]"
                  />
                </div>

                <div class="space-y-2">
                  <label
                    class="block text-sm font-medium"
                    :class="['text-[rgb(var(--color-text-muted))]']"
                  >
                    {{ t('manage.settings.s3BucketName') }}
                  </label>
                  <input
                    type="text"
                    v-model="config.s3_bucket_name"
                    class="w-full rounded-md shadow-sm px-4 py-2.5 transition-all duration-200 ease-in-out border focus:ring-2 focus:ring-[rgb(var(--color-focus-ring)/0.35)] focus:border-[rgb(var(--color-focus-ring))] outline-none"
                    :class="[
                      'border-[rgb(var(--color-border))] bg-[rgb(var(--color-surface-input)/0.8)] text-[rgb(var(--color-text-strong))] placeholder-[rgb(var(--color-text-subtle))] hover:border-[rgb(var(--color-border-strong))]'
                    ]"
                  />
                </div>

                <div class="space-y-2">
                  <label
                    class="block text-sm font-medium"
                    :class="['text-[rgb(var(--color-text-muted))]']"
                  >
                    {{ t('manage.settings.s3EndpointUrl') }}
                  </label>
                  <input
                    type="text"
                    v-model="config.s3_endpoint_url"
                    class="w-full rounded-md shadow-sm px-4 py-2.5 transition-all duration-200 ease-in-out border focus:ring-2 focus:ring-[rgb(var(--color-focus-ring)/0.35)] focus:border-[rgb(var(--color-focus-ring))] outline-none"
                    :class="[
                      'border-[rgb(var(--color-border))] bg-[rgb(var(--color-surface-input)/0.8)] text-[rgb(var(--color-text-strong))] placeholder-[rgb(var(--color-text-subtle))] hover:border-[rgb(var(--color-border-strong))]'
                    ]"
                  />
                </div>

                <div class="space-y-2">
                  <label
                    class="block text-sm font-medium"
                    :class="['text-[rgb(var(--color-text-muted))]']"
                  >
                    {{ t('manage.settings.s3RegionName') }}
                  </label>
                  <input
                    type="text"
                    v-model="config.s3_region_name"
                    :placeholder="t('manage.settings.autoPlaceholder')"
                    class="w-full rounded-md shadow-sm px-4 py-2.5 transition-all duration-200 ease-in-out border focus:ring-2 focus:ring-[rgb(var(--color-focus-ring)/0.35)] focus:border-[rgb(var(--color-focus-ring))] outline-none"
                    :class="[
                      'border-[rgb(var(--color-border))] bg-[rgb(var(--color-surface-input)/0.8)] text-[rgb(var(--color-text-strong))] placeholder-[rgb(var(--color-text-subtle))] hover:border-[rgb(var(--color-border-strong))]'
                    ]"
                  />
                </div>

                <div class="space-y-2">
                  <label
                    class="block text-sm font-medium"
                    :class="['text-[rgb(var(--color-text-muted))]']"
                  >
                    {{ t('manage.settings.s3SignatureVersion') }}
                  </label>
                  <select
                    v-model="config.s3_signature_version"
                    class="w-full rounded-md shadow-sm px-4 py-2.5 transition-all duration-200 ease-in-out border focus:ring-2 focus:ring-[rgb(var(--color-focus-ring)/0.35)] focus:border-[rgb(var(--color-focus-ring))] outline-none"
                    :class="[
                      'border-[rgb(var(--color-border))] bg-[rgb(var(--color-surface-input)/0.8)] text-[rgb(var(--color-text-strong))] hover:border-[rgb(var(--color-border-strong))]'
                    ]"
                  >
                    <option value="s3v2">{{ t('manage.settings.s3v2') }}</option>
                    <option value="s3v4">{{ t('manage.settings.s3v4') }}</option>
                  </select>
                </div>

                <div class="space-y-2">
                  <label
                    class="block text-sm font-medium"
                    :class="['text-[rgb(var(--color-text-muted))]']"
                  >
                    {{ t('manage.settings.s3AddressingStyle') }}
                  </label>
                  <select
                    v-model="config.s3_addressing_style"
                    class="w-full rounded-md shadow-sm px-4 py-2.5 transition-all duration-200 ease-in-out border focus:ring-2 focus:ring-[rgb(var(--color-focus-ring)/0.35)] focus:border-[rgb(var(--color-focus-ring))] outline-none"
                    :class="[
                      'border-[rgb(var(--color-border))] bg-[rgb(var(--color-surface-input)/0.8)] text-[rgb(var(--color-text-strong))] hover:border-[rgb(var(--color-border-strong))]'
                    ]"
                  >
                    <option value="auto">{{ t('manage.settings.s3AddressingAuto') }}</option>
                    <option value="path">{{ t('manage.settings.s3AddressingPath') }}</option>
                    <option value="virtual">{{ t('manage.settings.s3AddressingVirtual') }}</option>
                  </select>
                </div>

                <div class="space-y-2">
                  <label
                    class="block text-sm font-medium"
                    :class="['text-[rgb(var(--color-text-muted))]']"
                  >
                    {{ t('manage.settings.s3Hostname') }}
                  </label>
                  <input
                    type="text"
                    v-model="config.s3_hostname"
                    class="w-full rounded-md shadow-sm px-4 py-2.5 transition-all duration-200 ease-in-out border focus:ring-2 focus:ring-[rgb(var(--color-focus-ring)/0.35)] focus:border-[rgb(var(--color-focus-ring))] outline-none"
                    :class="[
                      'border-[rgb(var(--color-border))] bg-[rgb(var(--color-surface-input)/0.8)] text-[rgb(var(--color-text-strong))] placeholder-[rgb(var(--color-text-subtle))] hover:border-[rgb(var(--color-border-strong))]'
                    ]"
                  />
                </div>

                <SettingSwitch
                  :label="t('manage.settings.enableProxy')"
                  :model-value="config.s3_proxy"
                  :enabled-text="t('common.enabled')"
                  :disabled-text="t('common.disabled')"
                  @toggle="toggleConfigFlag('s3_proxy')"
                />

                <SettingSwitch
                  :label="t('manage.settings.chunkUploadNote')"
                  :model-value="config.enableChunk"
                  :enabled-text="t('common.enabled')"
                  :disabled-text="t('common.disabled')"
                  @toggle="toggleConfigFlag('enableChunk')"
                />
              </div>
            </div>
          </div>
        </div>

        <!-- 上传限制 -->
        <div class="mt-8">
          <h3
            class="text-lg font-medium mb-4"
            :class="['text-[rgb(var(--color-text-strong))]']"
          >
            {{ t('manage.settings.uploadLimits') }}
          </h3>

          <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
            <SettingNumberInput
              v-model="config.uploadMinute"
              :label="t('manage.settings.uploadPerMinute')"
              :suffix="t('common.minute')"
            />

            <SettingNumberInput
              v-model="config.uploadCount"
              :label="t('manage.settings.uploadCountLimit')"
              :suffix="t('common.files')"
            />

            <div class="space-y-2">
              <label
                class="block text-sm font-medium"
                :class="['text-[rgb(var(--color-text-muted))]']"
              >
                {{ t('manage.settings.fileSizeLimit') }}
              </label>
              <div class="flex items-center space-x-2">
                <input
                  type="number"
                  v-model="fileSize"
                  class="w-24 rounded-md shadow-sm px-4 py-2.5 transition-all duration-200 ease-in-out border focus:ring-2 focus:ring-[rgb(var(--color-focus-ring)/0.35)] focus:border-[rgb(var(--color-focus-ring))] outline-none"
                  :class="[
                    'border-[rgb(var(--color-border))] bg-[rgb(var(--color-surface-input)/0.8)] text-[rgb(var(--color-text-strong))] placeholder-[rgb(var(--color-text-subtle))] hover:border-[rgb(var(--color-border-strong))]'
                  ]"
                />
                <select
                  v-model="sizeUnit"
                  class="rounded-md shadow-sm px-4 py-2.5 transition-all duration-200 ease-in-out border focus:ring-2 focus:ring-[rgb(var(--color-focus-ring)/0.35)] focus:border-[rgb(var(--color-focus-ring))] outline-none"
                  :class="[
                    'border-[rgb(var(--color-border))] bg-[rgb(var(--color-surface-input)/0.8)] text-[rgb(var(--color-text-strong))] hover:border-[rgb(var(--color-border-strong))]'
                  ]"
                >
                  <option value="KB">{{ t('manage.settings.fileSizeUnits.kb') }}</option>
                  <option value="MB">{{ t('manage.settings.fileSizeUnits.mb') }}</option>
                  <option value="GB">{{ t('manage.settings.fileSizeUnits.gb') }}</option>
                </select>
              </div>
            </div>

            <div class="space-y-2 md:col-span-2">
              <label
                class="block text-sm font-medium"
                :class="['text-[rgb(var(--color-text-muted))]']"
              >
                {{ t('manage.settings.allowedFileTypes') }}
              </label>
              <input
                type="text"
                :value="config.allowed_file_types.join(', ')"
                @input="updateAllowedFileTypes"
                class="w-full rounded-md shadow-sm px-4 py-2.5 transition-all duration-200 ease-in-out border focus:ring-2 focus:ring-[rgb(var(--color-focus-ring)/0.35)] focus:border-[rgb(var(--color-focus-ring))] outline-none"
                :class="[
                  'border-[rgb(var(--color-border))] bg-[rgb(var(--color-surface-input)/0.8)] text-[rgb(var(--color-text-strong))] placeholder-[rgb(var(--color-text-subtle))] hover:border-[rgb(var(--color-border-strong))]'
                ]"
                :placeholder="t('manage.settings.allowedFileTypesPlaceholder')"
              />
              <p class="text-xs" :class="['text-[rgb(var(--color-text-muted))]']">
                {{ t('manage.settings.allowedFileTypesHelp') }}
              </p>
            </div>

            <div class="space-y-2">
              <label
                class="block text-sm font-medium mb-2"
                :class="['text-[rgb(var(--color-text-muted))]']"
              >
                {{ t('manage.settings.expirationType') }}
              </label>
              <div class="flex flex-wrap gap-3">
                <label
                  v-for="style in ['day', 'hour', 'minute', 'forever', 'count']"
                  :key="style"
                  class="relative inline-flex items-center group cursor-pointer"
                >
                  <input
                    type="checkbox"
                    :value="style"
                    v-model="config.expireStyle"
                    class="peer sr-only"
                  />
                  <div
                    class="px-4 py-2 rounded-full border-2 transition-all duration-200 select-none"
                    :class="[
                      config.expireStyle.includes(style)
                        ? 'bg-[rgb(var(--color-accent))] border-[rgb(var(--color-accent))] text-[rgb(var(--color-accent-contrast))]'
                        : 'bg-[rgb(var(--color-surface)/0.6)] border-[rgb(var(--color-border))] text-[rgb(var(--color-text-muted))] hover:border-[rgb(var(--color-border-strong))] hover:bg-[rgb(var(--color-surface-muted))]'
                    ]"
                  >
                    {{ t(`manage.settings.expiration.${style}`) }}
                  </div>
                </label>
              </div>
            </div>

            <div class="space-y-2">
              <label
                class="block text-sm font-medium"
                :class="['text-[rgb(var(--color-text-muted))]']"
              >
                {{ t('manage.settings.codeGenerateType') }}
              </label>
              <select
                v-model="config.code_generate_type"
                class="w-full rounded-md shadow-sm px-4 py-2.5 transition-all duration-200 ease-in-out border focus:ring-2 focus:ring-[rgb(var(--color-focus-ring)/0.35)] focus:border-[rgb(var(--color-focus-ring))] outline-none"
                :class="[
                  'border-[rgb(var(--color-border))] bg-[rgb(var(--color-surface-input)/0.8)] text-[rgb(var(--color-text-strong))] hover:border-[rgb(var(--color-border-strong))]'
                ]"
              >
                <option value="number">{{ t('manage.settings.codeGenerateNumber') }}</option>
                <option value="secret">{{ t('manage.settings.codeGenerateSecret') }}</option>
              </select>
              <p class="text-xs" :class="['text-[rgb(var(--color-text-muted))]']">
                {{ t('manage.settings.codeGenerateTypeHelp') }}
              </p>
            </div>

            <div class="space-y-2">
              <label
                class="block text-sm font-medium"
                :class="['text-[rgb(var(--color-text-muted))]']"
              >
                {{ t('manage.settings.maxSaveTime') }}
              </label>
              <div class="flex items-center space-x-2">
                <input
                  type="number"
                  v-model="saveTime"
                  class="w-24 rounded-md shadow-sm px-4 py-2.5 transition-all duration-200 ease-in-out border focus:ring-2 focus:ring-[rgb(var(--color-focus-ring)/0.35)] focus:border-[rgb(var(--color-focus-ring))] outline-none"
                  :class="[
                    'border-[rgb(var(--color-border))] bg-[rgb(var(--color-surface-input)/0.8)] text-[rgb(var(--color-text-strong))] placeholder-[rgb(var(--color-text-subtle))] hover:border-[rgb(var(--color-border-strong))]'
                  ]"
                />
                <select
                  v-model="saveTimeUnit"
                  class="rounded-md shadow-sm px-4 py-2.5 transition-all duration-200 ease-in-out border focus:ring-2 focus:ring-[rgb(var(--color-focus-ring)/0.35)] focus:border-[rgb(var(--color-focus-ring))] outline-none"
                  :class="[
                    'border-[rgb(var(--color-border))] bg-[rgb(var(--color-surface-input)/0.8)] text-[rgb(var(--color-text-strong))] hover:border-[rgb(var(--color-border-strong))]'
                  ]"
                >
                  <option value="秒">{{ t('common.second') }}</option>
                  <option value="分">{{ t('common.minute') }}</option>
                  <option value="时">{{ t('common.hour') }}</option>
                  <option value="天">{{ t('common.day') }}</option>
                </select>
              </div>
            </div>

            <div class="space-y-2">
              <label
                class="block text-sm font-medium"
                :class="['text-[rgb(var(--color-text-muted))]']"
              >
                {{ t('admin.settings.storageLimit') }}
              </label>
              <div class="flex items-center space-x-2">
                <input
                  v-model.number="storageLimit"
                  type="number"
                  min="0"
                  step="1"
                  class="w-28 rounded-md border px-4 py-2.5 shadow-sm outline-none transition-all duration-200 focus:border-[rgb(var(--color-focus-ring))] focus:ring-2 focus:ring-[rgb(var(--color-focus-ring)/0.35)]"
                  :class="[
                    'border-[rgb(var(--color-border))] bg-[rgb(var(--color-surface-input)/0.8)] text-[rgb(var(--color-text-strong))] hover:border-[rgb(var(--color-border-strong))]'
                  ]"
                />
                <select
                  v-model="storageLimitUnit"
                  class="rounded-md border px-4 py-2.5 shadow-sm outline-none transition-all duration-200 focus:border-[rgb(var(--color-focus-ring))] focus:ring-2 focus:ring-[rgb(var(--color-focus-ring)/0.35)]"
                  :class="[
                    'border-[rgb(var(--color-border))] bg-[rgb(var(--color-surface-input)/0.8)] text-[rgb(var(--color-text-strong))] hover:border-[rgb(var(--color-border-strong))]'
                  ]"
                >
                  <option value="KB">KB</option>
                  <option value="MB">MB</option>
                  <option value="GB">GB</option>
                </select>
              </div>
              <p class="text-xs" :class="['text-[rgb(var(--color-text-muted))]']">
                {{ t('admin.settings.storageLimitHelp') }}
              </p>
            </div>

            <SettingSwitch
              :label="t('manage.settings.guestUpload')"
              :model-value="config.openUpload"
              :enabled-text="t('common.enabled')"
              :disabled-text="t('common.disabled')"
              @toggle="toggleConfigFlag('openUpload')"
            />
          </div>
        </div>

        <!-- 错误限制 -->
        <div class="mt-8">
          <h3
            class="text-lg font-medium mb-4"
            :class="['text-[rgb(var(--color-text-strong))]']"
          >
            {{ t('manage.settings.errorLimits') }}
          </h3>

          <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
            <SettingNumberInput
              v-model="config.errorMinute"
              :label="t('manage.settings.errorPerMinute')"
              :suffix="t('common.minute')"
            />

            <SettingNumberInput
              v-model="config.errorCount"
              :label="t('manage.settings.errorCountLimit')"
              :suffix="t('common.times')"
            />
          </div>
        </div>
      </section>
    </div>
  </div>
</template>
<style scoped>
.settings-page :deep(input:not([type='checkbox'])),
.settings-page :deep(select),
.settings-page :deep(textarea) {
  background-color: rgb(var(--color-surface-input) / 0.8) !important;
  border-color: rgb(var(--color-border)) !important;
  color: rgb(var(--color-text-strong)) !important;
}

.settings-page :deep(input::placeholder),
.settings-page :deep(textarea::placeholder) {
  color: rgb(var(--color-text-subtle)) !important;
}

.settings-page :deep(input:hover),
.settings-page :deep(select:hover),
.settings-page :deep(textarea:hover) {
  border-color: rgb(var(--color-border-strong)) !important;
}

.settings-page :deep(label),
.settings-page :deep(h3) {
  color: rgb(var(--color-text)) !important;
}
</style>
