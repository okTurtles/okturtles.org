<template>
<div v-if="isActive"
  class='c-modal-container'
  role="dialog"
  :aria-modal="true"
  :aria-label='title'>
  <div class='c-modal-background'
    @click.stop="closeModal"></div>

  <div class='c-modal-content'>
    <header class='c-modal-header'>
      <h1 v-if="title">{{ title }}</h1>

      <modal-close v-if="hideClose"
        class="c-close-btn"
        @close="closeModal" />
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
import { computed } from 'vue'
import { useStore } from '@nanostores/vue'
import { $activeModal, unloadModal } from '@/store/modal'
import ModalClose from './ModalClose.vue'

interface ComponentProps {
  modalName: string, // NOTE: required prop. 
  title?: string
  hideClose?: boolean
}

const props = defineProps<ComponentProps>()

// state
const activeModal = useStore($activeModal)

// computed
const isActive = computed(() => activeModal.value === props.modalName)

// methods
const closeModal = () => { unloadModal(props.modalName) }

// define expose
defineExpose({
  closeModal
})
</script>

<style lang="scss" scoped>
@use "../../styles/variables" as *;

.c-modal-container {
  position: fixed;
  display: flex;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  z-index: 50;
  justify-content: center;
  align-items: center;
  max-width: 100vw;
  overflow: hidden;
  box-sizing: border-box;

  * {
    box-sizing: inherit;
  }
}

.c-modal-background {
  position: absolute;
  left: 0;
  top: 0;
  width: 100%;
  height: 100%;
  background-color: rgba(10, 10, 10, 0.86);
  opacity: 0;
  animation: modal-bg-in 250ms ease-out forwards;
}

.c-modal-content {
  position: relative;
  border-radius: $radius-big;
  width: calc(100vw - 30px);
  max-width: 620px;
  height: auto;
  max-height: calc(100% - 50px);
  overflow: hidden;
  display: grid;
  grid-template-columns: 1fr;
  grid-template-rows: auto 1fr auto;
  grid-template-areas:
    "m-header"
    "m-body"
    "m-footer";
  background-color: $white;
  color: $black;
  text-align: left;
  opacity: 0;
  animation: modal-content-in 300ms ease-out forwards;
  animation-delay: 100ms;
}

.c-modal-header {
  grid-area: m-header;
  display: flex;
  align-items: flex-start;
  justify-content: flex-start;
  column-gap: 12px;
  padding: 24px 16px;
  background-color: $green;
  color: $white;

  h1 {
    font-size: 24px;
    font-weight: 600;
    line-height: 1.4;
    margin-top: 8px;
    flex-grow: 1;
    text-align: left;
  }

  button.c-close-btn {
    flex-shrink: 0;
  }

  @include from($tablet) {
    flex-direction: column-reverse;
    column-gap: 0;
    align-self: stretch;
    padding: 28px 20px;

    h1 {
      font-size: 32px;
      margin-top: 0;
      text-align: center;
    }

    button.c-close-btn {
      align-self: flex-end;
    }
  }
}

.c-modal-body {
  grid-area: m-body;
  padding: 24px 16px;
  overflow: auto;

  @include from($tablet) {
    padding: 28px 20px;
  }
}

.c-modal-footer {
  grid-area: m-footer;
  padding: 16px;
}

@keyframes modal-bg-in {
  0% { opacity: 0; }
  100% { opacity: 1; }
}

@keyframes modal-content-in {
  0% {
    opacity: 0;
    transform: scale(0.95);
  }

  100% {
    opacity: 1;
    transform: scale(1);
  }
}
</style>
