<template>
<div id='c-modal-container' class='l-modal'>
  <div class='c-modal-background'></div>

  <div class='c-modal-content'>
    <header class='c-modal-header'>
      <h1 v-if="title">{title}</h1>

      <button></button>
    </header>
  </div>
</div>
</template>

<script setup lang="ts">
interface ComponentProps {
  title?: string
  hideClose?: boolean
}

const props = defineProps<ComponentProps>()
</script>

<style lang="scss" scoped>
.c-modal-container {
  position: fixed;
}
</style>
