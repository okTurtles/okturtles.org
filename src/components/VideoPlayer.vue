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
const isPhone = ref<boolean | null>(null)
const isPhoneMatchMedia = ref<any>(null)

// methods
const onIsPhoneChange = (event: MediaQueryListEvent) => {
  isPhone.value = event.matches
}

const adjustOrientation = ({ toLandscape = false } = {}) => {
  if (isPhone.value) {
    const orientation = screen?.orientation as any
    if (orientation && 'lock' in orientation) {
      orientation.lock(toLandscape ? 'landscape' : 'any')
    }
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

  // plyr event handlers
  player.value.on('enterfullscreen', () => {
    adjustOrientation({ toLandscape: true })
  })
  player.value.on('exitfullscreen', () => {
    adjustOrientation({ toLandscape: false })
  })

  // browser event handlers
  isPhoneMatchMedia.value = window.matchMedia('(hover: none) and (pointer: coarse) and (max-width: 760px)')
  isPhone.value = isPhoneMatchMedia.value.matches
  isPhoneMatchMedia.value.addEventListener('change', onIsPhoneChange)
}

onMounted(() => {
  initPlayer()
})

onBeforeUnmount(() => {
  isPhoneMatchMedia.value.removeEventListener('change', onIsPhoneChange)
})
</script>

<style lang="scss" src="../styles/plyr/_plyr_override.scss"></style>