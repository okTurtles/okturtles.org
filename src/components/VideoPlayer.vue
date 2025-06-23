<template>
<div class="video-player-container plyr_override">
  <video ref="video-el" playsinline controls :poster="poster">
    <source :src="src" :type="mimeType" />
  </video>
</div>
</template>

<script setup lang="ts">
import { useTemplateRef, ref, onMounted } from 'vue'
interface ComponentProps {
  src: string,
  mimeType: string,
  poster?: string
}

const props = defineProps<ComponentProps>()

const videoEl = useTemplateRef('video-el')
const player = ref<any>(null)

// methods
const initPlayer = () => {
  const opts = {
    // Documentation for plyr options: https://www.npmjs.com/package/plyr#options
    debug: false,
    ratio: '16:9',
    keyboard: {
      // For more details about the keyboard shortcuts: https://www.npmjs.com/package/plyr#shortcuts
      focused: true,
      global: true
    }
  }

  player.value = new Plyr(videoEl.value as HTMLElement, opts)
}

onMounted(() => {
  initPlayer()
})
</script>

<style lang="scss" src="../styles/plyr/_plyr_override.scss"></style>