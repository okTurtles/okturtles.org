<template>
<div id='c-modal-container' class='l-modal'>
  <div class='c-modal-background'></div>

  <div class='c-modal-content'>
    <header class='c-modal-header'>
      <h1 v-if="title">{title}</h1>

      <modal-close class="c-close-btn" @close="closeModal" />
    </header>

    <section class="c-modal-body">
      <slot></slot>
    </section>

    <footer v-if="$slots.footer" class="c-modal-footer">
      <slot name="footer"></slot>
    </footer>
  </div>
</div>
</template>

<script setup lang="ts">
import ModalClose from './ModalClose.vue'

interface ComponentProps {
  modalName: string, // NOTE: required prop. 
  title?: string
  hideClose?: boolean
}

const props = defineProps<ComponentProps>()

const closeModal = () => {}

// define expose
defineExpose({
  closeModal
})
</script>

<style lang="scss" scoped>
.c-modal-container {
  position: fixed;
}
</style>
