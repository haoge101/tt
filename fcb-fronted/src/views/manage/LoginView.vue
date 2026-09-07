<template>
  <div
    :class="[
      'min-h-screen flex items-center justify-center py-12 px-4 sm:px-6 lg:px-8 transition-colors duration-200 relative overflow-hidden',
      'bg-[rgb(var(--color-surface-muted))]'
    ]"
  >
    <div class="absolute inset-0 z-0">
      <div class="cyber-grid"></div>
      <div class="floating-particles"></div>
    </div>
    <div
      class="max-w-md w-full space-y-8 backdrop-blur-lg bg-opacity-20 p-8 rounded-xl border border-opacity-20"
      :class="['bg-[rgb(var(--color-surface-input)/0.85)] border-[rgb(var(--color-border))]']"
    >
      <div>
        <div class="mx-auto h-16 w-16 relative">
          <div
            class="absolute inset-0 rounded-2xl"
            :class="'bg-[rgb(var(--color-accent)/0.12)]'"
          ></div>
          <div
            class="absolute -inset-2 rounded-[1.35rem] opacity-40 blur-md"
            :class="'bg-[rgb(var(--color-border-strong))]'"
          ></div>
          <div
            :class="[
              'absolute inset-1 rounded-[1rem] flex items-center justify-center',
              'bg-[rgb(var(--color-surface))]'
            ]"
          >
            <BoxIcon :class="['h-8 w-8', 'text-[rgb(var(--color-text))]']" />
          </div>
        </div>
        <h2
          :class="[
            'mt-6 text-center text-3xl font-extrabold',
            'text-[rgb(var(--color-text-strong))]'
          ]"
        >
          登录
        </h2>
      </div>
      <form class="mt-8 space-y-6" @submit.prevent="submitLogin">
        <input type="hidden" name="remember" value="true" />
        <label for="username" class="sr-only">用户名</label>
        <input
          id="username"
          name="username"
          type="text"
          autocomplete="username"
          value="admin"
          readonly
          tabindex="-1"
          class="sr-only"
        />
        <div class="rounded-md shadow-sm -space-y-px">
          <div>
            <label for="password" class="sr-only">密码</label>
            <input
              id="password"
              name="password"
              type="password"
              autocomplete="current-password"
              required
              v-model="password"
              :class="[
                'appearance-none rounded-t-md relative block w-full px-4 py-3 border transition-all duration-200 placeholder-[rgb(var(--color-text-subtle))] focus:outline-none focus:ring-2 focus:ring-[rgb(var(--color-focus-ring)/0.35)] focus:border-[rgb(var(--color-focus-ring))] focus:z-10 sm:text-sm backdrop-blur-sm',
                'bg-[rgb(var(--color-surface-input)/0.6)] border-[rgb(var(--color-border))] text-[rgb(var(--color-text-strong))] placeholder-[rgb(var(--color-text-subtle))] hover:border-[rgb(var(--color-border-strong))] focus:ring-[rgb(var(--color-focus-ring)/0.4)] focus:border-[rgb(var(--color-border-strong))]'
              ]"
              placeholder="密码"
            />
          </div>
        </div>
        <div>
          <button
            type="submit"
            :class="[
              'group relative w-full flex justify-center py-3 px-4 border border-transparent text-sm font-medium rounded-md transition-all duration-300 transform hover:scale-[1.02] focus:outline-none focus:ring-2 focus:ring-offset-2 shadow-lg',
              'bg-[rgb(var(--color-accent))] text-[rgb(var(--color-accent-contrast))] hover:brightness-110 focus:ring-[rgb(var(--color-focus-ring)/0.5)] hover:shadow-[rgb(var(--color-accent)/0.3)]',
              isLoading ? 'opacity-75 cursor-not-allowed' : ''
            ]"
            :disabled="isLoading"
          >
            <span class="absolute left-0 inset-y-0 flex items-center pl-3"> </span>
            {{ isLoading ? '登录中...' : '登录' }}
          </button>
        </div>
      </form>
    </div>
  </div>
</template>

<script setup lang="ts">
import { inject } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import { BoxIcon } from 'lucide-vue-next'
import { useAdminLogin } from '@/composables'
import { ROUTES } from '@/constants'

const isDarkMode = inject('isDarkMode')
const router = useRouter()
const route = useRoute()
const { password, isLoading, handleSubmit } = useAdminLogin()

const getRedirectPath = () => {
  const redirect = route.query.redirect
  if (typeof redirect === 'string' && redirect.startsWith('/')) {
    return redirect
  }
  return ROUTES.ADMIN
}

const submitLogin = async () => {
  const success = await handleSubmit()
  if (success) {
    await router.push(getRedirectPath())
  }
}
</script>

<style scoped>
@keyframes spin {
  from {
    transform: rotate(0deg);
  }

  to {
    transform: rotate(360deg);
  }
}

.animate-spin-slow {
  animation: spin 8s linear infinite;
}

.fade-enter-active,
.fade-leave-active {
  transition: opacity 0.3s ease;
}

.fade-enter-from,
.fade-leave-to {
  opacity: 0;
}

input:focus {
  box-shadow: 0 0 15px rgba(39, 39, 42, 0.18);
}

button:active:not(:disabled) {
  transform: scale(0.98);
}

.cyber-grid {
  background-image:
    linear-gradient(transparent 95%, rgba(39, 39, 42, 0.08) 50%),
    linear-gradient(90deg, transparent 95%, rgba(39, 39, 42, 0.08) 50%);
  background-size: 30px 30px;
  width: 100%;
  height: 100%;
  position: absolute;
  opacity: 0.5;
}

.floating-particles {
  position: absolute;
  width: 100%;
  height: 100%;
  background: radial-gradient(circle at center, transparent 0%, transparent 100%);
  filter: url(#gooey);
}

.floating-particles::before,
.floating-particles::after {
  content: '';
  position: absolute;
  width: 100%;
  height: 100%;
  background-image: radial-gradient(circle at center, rgba(39, 39, 42, 0.08) 0%, transparent 50%);
  animation: float 20s infinite linear;
}

.floating-particles::after {
  animation-delay: -10s;
  opacity: 0.5;
}

@keyframes float {
  0% {
    transform: translate(0, 0) scale(1);
  }

  50% {
    transform: translate(50px, 50px) scale(1.5);
  }

  100% {
    transform: translate(0, 0) scale(1);
  }
}

button:hover:not(:disabled) {
  box-shadow: 0 0 25px rgba(39, 39, 42, 0.22);
}

.fade-enter-active,
.fade-leave-active {
  transition: all 0.5s cubic-bezier(0.4, 0, 0.2, 1);
}
</style>
