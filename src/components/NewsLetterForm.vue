<template>
<form class="c-news-letter-form"
    ref="emailFormEl"
    action="https://buttondown.email/api/emails/embed-subscribe/okturtles"
    method="post"
    target="popupwindow"
    @submit.prevent="onFormSubmit"
    novalidate
  >
    <div class="cta-container">
      <input type="email" name="email" id="bd-email" class="email"
      placeholder="Enter email for updates" required
      v-model.trim="email"
      ref="emailInputEl" />
      <input type="submit" value="Send" class="submit" />
    </div>

    <p v-if="emailErr" class="c-error-msg">{{ emailErr }}</p>
  </form>
</template>

<script setup lang="ts">
import { ref } from 'vue'
import { openModal } from '@/store/modal'

const EMAIL_BLACKLIST = [
  'gmail.com',
  'googlemail.com',
  'google.com'
]
const email = ref<string>('')
const emailErr = ref<string>('')
const emailFormEl = ref<HTMLFormElement | null>(null)
const emailInputEl = ref<HTMLInputElement | null>(null)

const validateEmail = (email: string) => {
  // reference: https://mailtrap.io/blog/javascript-email-validation/
  const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/
  return emailRegex.test(email)
}

const validateEmailField = () => {
  const getDomain = (str: string) => (str.split('@')[1] || '').toLowerCase()
  let passed = true

  if (!validateEmail(email.value)) {
    emailErr.value = 'Please enter correct email format.'
    passed = false
    emailInputEl.value?.focus()
  } else if (EMAIL_BLACKLIST.includes(getDomain(email.value))) {
    openModal('NewsLetterWarningModal')
    passed = false 
  }

  return passed
}

const onFormSubmit = () => {
  if (validateEmailField()) {
    emailFormEl.value?.submit()
    email.value = ''
    emailErr.value = ''
  }
}
</script>

<style lang="scss" scoped>
@use "../styles/variables" as *;
.c-news-letter-form {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  gap: 8px;

  .cta-container {
    position: relative;
    display: flex;
    flex-direction: row;
    align-items: center;
    justify-content: center;
    width: 100%;

    &:hover {
      input {
        border-color: $blue;
      }
    }

    input {
      position: relative;
      display: inline-block;
      box-sizing: border-box;
      vertical-align: bottom;
      appearance: none;
      -webkit-font-smoothing: antialiased;
      font-family: "proxima_novaregular";
      background-color: $background-grey;
      max-width: 300px;
      width: 100%;
      height: 50px;
      font-weight: normal;
      border-radius: 0;
      outline: none;
      font-size: 14px;
      text-align: left;
      margin: 5px 1px 3px 0px;
      padding: 3px 20px; 
      border: 1px solid $black;
      flex-shrink: 0;
      @include transition(all, .3s, ease);

      &:hover,
      &:focus {
        background-color: $white;
      }

      @include until(568px) {
        max-width: 190px;
        flex-shrink: unset;
      }
    }

    .submit {
      position: relative;
      color: $blue;
      width: 70px;
      max-height: 50px;
      height: 50px;
      padding-left: 5px;
      right: 7px;
      padding-right: 5px;
      margin-bottom: 3px;
      text-align: center;

      &:hover,
      &:focus,
      &:active {
        cursor: pointer;
        background-color: $blue;
        color: $white;
      }
    }
  }

  .c-error-msg {
    text-align: center;
    color: $danger;
    font-size: 14px;
    margin: 0;
  }
}
</style>
