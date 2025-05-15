import { defineConfig } from 'astro/config'
import astroVue from '@astrojs/vue'

// reference: https://docs.astro.build/en/reference/configuration-reference/
export default defineConfig({
  site: 'https://okturtles.org',
  integrations: [astroVue()]
})
