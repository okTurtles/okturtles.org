<template>
<modal-template modal-name="NewsLetterWarningModal"
  :title="modalTitle">
  <div class="c-warning-content">
    <p class="c-para-1">Google isn't delivering our newsletter to all subscribers. They aren't even sending it to junk, just black holing it.</p>
    <p class="c-para-2">For that reason we can't accept any Gmail addresses. We recommend one of these alternatives:</p>

    <ul class="c-url-list">
      <li v-for="link in links" :key="link.id">
        <a class="link" target="_blank" :href="link.url">{{ link.url }}</a>
      </li>
    </ul>
  </div>
</modal-template>
</template>

<script setup lang="ts">
import ModalTemplate from './ModalTemplate.vue'

const modalTitle = 'Sorry Gmail users!'
const links: Array<{ id: string, url: string }> = [
  { id: 'tuta', url: 'https://tuta.com/' },
  { id: 'startmail', url: 'https://www.startmail.com/' },
  { id: 'proton', url: 'https://proton.me/mail' },
  { id: 'fastmail', url: 'https://www.fastmail.com/' }
]
</script>

<style lang="scss" scoped>
@use "../../styles/variables" as *;

.c-warning-content {
  position: relative;
  color: $grey;

  @include from($tablet) {
    font-size: 18px;
  }
}

.c-para-1 {
  margin-bottom: 1.5rem;
}

.c-para-2 {
  margin-bottom: 1rem;
}

.c-url-list {
  position: relative;
  margin-left: 1.25rem;
  list-style-type: disc;

  li {
    margin-bottom: 0.25rem;

    a {
      font-size: 0.925em;
    }
  }
}
</style>
