<template>
<button class="c-modal-close"
  type="button"
  @click.stop="onClick">
  <span class="c-close-bar"></span>
  <span class="close-bar"></span>
</button>
</template>

<script setup lang="ts">
const emit = defineEmits<{
  (e: 'close'): void
}>()

const onClick = () => {
  emit('close')
}
</script>

<style lang="scss" scoped>
@import "../../styles/variables.scss";

.c-modal-close {
  position: relative;
  display: inline-block;
  background-color: $white;
  color: $black;
  width: 32px;
  height: 32px;
  border-radius: 50%;
  border: 1px solid rgba(0, 0, 0, 0);
  cursor: pointer;
  transition:
    background-color 0.3s ease-out,
    border-color 0.3s ease-out;

  &:hover,
  &focus {
    background-color: $background-grey;
  }

  &:focus {
    border-color: $grey_3;
  }

  .c-close-bar {
    position: absolute;
    top: 50%;
    left: 50%;
    width: 24px;
    height: 2px;
    border-radius: 2px;
    background-color: currentColor;

    &:first-child {
      transform: translateX(-50%) rotate(45deg);
    }

    &:last-child {
      transform: translateX(-50%) rotate(-45deg);
    }
  }
}
</style>
