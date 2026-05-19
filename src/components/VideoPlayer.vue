<template>
<div class="video-player-container plyr_override">
  <video ref="video-el" playsinline controls :poster="poster">
    <source :src="src" :type="mimeType" />
  </video>
</div>
</template>

<script setup lang="ts">
import { useTemplateRef, ref, onMounted, onBeforeUnmount } from 'vue'
interface ComponentProps {
  src: string,
  mimeType: string,
  poster?: string
}

const props = defineProps<ComponentProps>()

const videoEl = useTemplateRef('video-el')
const player = ref<any>(null)
const isPhone = ref<boolean>(false)
let isPhoneMatchMedia: any = null

// methods
const adjustDeviceOrientation = (toLandscape: boolean = false) => {
  const orientationHandle = screen?.orientation as any
  if (isPhone.value && orientationHandle && 'lock' in orientationHandle) {
    const valTo = toLandscape ? 'landscape' : 'any'
    orientationHandle.lock(valTo).catch((err: any) => {
      console.error('Failed to lock screen orientation', err)
    })
  }
}

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

  // Event listeners
  player.value.on('enterfullscreen', () => {
    adjustDeviceOrientation(true)
  })
  player.value.on('exitfullscreen', () => {
    adjustDeviceOrientation(false)
  })
}

onMounted(() => {
  initPlayer()

  isPhoneMatchMedia = matchMedia('(hover: none) and (pointer: coarse) and (max-width: 768px)')
  isPhoneMatchMedia.onchange = () => {
    isPhone.value = isPhoneMatchMedia.matches
  }
  isPhone.value = isPhoneMatchMedia.matches
})

onBeforeUnmount(() => {
  if (isPhoneMatchMedia) {
    isPhoneMatchMedia.onchange = null
  }
})
</script>

<style lang="scss" src="../styles/plyr/_plyr_override.scss"></style>