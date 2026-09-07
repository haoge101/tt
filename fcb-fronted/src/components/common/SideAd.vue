<template>
  <Teleport to="body">
    <div :class="['side-ad', positionClass]" v-if="show">
      <div class="side-ad-inner" :style="{ width: width + 'px' }">
        <AdCode v-if="code" :code="code" />
      </div>
    </div>
  </Teleport>
</template>

<script setup lang="ts">
import { computed } from 'vue'
import AdCode from './AdCode.vue'
const props = defineProps<{ position: 'left' | 'right'; code?: string | null; width?: number; enabled?: boolean }>()
const width = props.width ?? 160
const show = computed(() => !!props.enabled && !!props.code)
const positionClass = computed(() => (props.position === 'left' ? 'side-ad-left' : 'side-ad-right'))
</script>

<style scoped>
.side-ad { position: fixed; top: 120px; z-index: 9999; display: none; }
.side-ad-inner { background: transparent; }
@media (min-width: 1280px) {
  .side-ad-left { left: 12px; display:block }
  .side-ad-right { right: 12px; display:block }
}
</style>
