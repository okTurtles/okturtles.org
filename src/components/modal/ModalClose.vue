<template>
<button class="c-modal-close"
  type="button"
  @click.stop="onClick"
  aria-label="Close modal">
  <span class="c-close-bar"></span>
  <span class="c-close-bar"></span>
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
  --c-btn-side: 26px;
  --c-bar-side: 12px;

  position: relative;
  display: inline-block;
  background-color: $white;
  color: $grey;
  width: var(--c-btn-side);
  height: var(--c-btn-side);
  border-radius: 50%;
  border: 1px solid rgba(0, 0, 0, 0);
  cursor: pointer;
  transition: background-color 150ms linear;

  @include from($tablet) {
    --c-btn-side: 32px;
    --c-bar-side: 16px;
  }

  &:hover,
  &:focus {
    background-color: $grey_3;

    .c-close-bar:first-child,
    .c-close-bar:last-child {
      transform: translateX(-50%) rotate(0deg);
    }
  }

  &:focus {
    border-color: $grey_2;
  }

  .c-close-bar {
    position: absolute;
    top: 50%;
    left: 50%;
    width: var(--c-bar-side);
    height: 2px;
    border-radius: 2px;
    background-color: currentColor;
    transition: transform 150ms linear;

    &:first-child {
      transform: translateX(-50%) rotate(45deg);
    }

    &:last-child {
      transform: translateX(-50%) rotate(-45deg);
    }
  }
}
</style>
