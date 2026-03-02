# AGENTS.md

Guide for AI agents working in this repository.

## Project Overview

**okturtles.org** — the marketing/informational website for the okTurtles Foundation, a 501(c)(3) nonprofit supporting beneficial decentralization technologies.

- **Framework**: [Astro](https://astro.build/) v5 (static site generator)
- **UI layer**: Astro components (`.astro`) for static content, Vue 3 (`.vue`) for interactive islands
- **Styling**: SCSS (Sass) with scoped `<style lang="scss">` blocks per component
- **State management**: [nanostores](https://github.com/nanostores/nanostores) (shared between Astro and Vue via `@nanostores/vue`)
- **TypeScript**: Strict mode (`astro/tsconfigs/strict`), used in Vue `<script setup lang="ts">` blocks and store files
- **License**: MPL 2.0
- **Site URL**: https://okturtles.org

## Commands

```bash
npm install       # Install dependencies
npm run dev       # Start dev server (astro dev)
npm run build     # Production build (astro build) — output to dist/
npm run preview   # Preview production build (astro preview)
```

There are no test, lint, or format commands configured. The project has a `.sass-lint.yml` config but no sass-lint script in package.json.

## Project Structure

```
src/
├── pages/              # File-based routing (Astro pages)
│   ├── index.astro     # Homepage
│   ├── donate.astro
│   ├── dpki.astro
│   ├── finances.astro
│   ├── team.astro
│   ├── browser-extension.astro
│   └── hiring/
│       ├── index.astro
│       └── [job].astro     # Dynamic route using getStaticPaths()
├── layouts/
│   ├── BaseLayout.astro    # Root HTML shell (doctype, head, body)
│   └── JobPost.astro       # Layout for hiring pages
├── components/
│   ├── base/               # Site-wide structural components
│   │   ├── BaseHead.astro  # <head> meta, fonts, jQuery
│   │   ├── Header.astro    # Site header with nav ribbon
│   │   ├── Footer.astro    # Footer with newsletter form, social links
│   │   └── BodyScripts.astro  # Analytics (Matomo), retina.js, fancybox
│   ├── modal/              # Vue-based modal system
│   │   ├── ModalTemplate.vue
│   │   ├── ModalClose.vue
│   │   └── NewsLetterWarningModal.vue
│   ├── NewsLetterForm.vue  # Buttondown email signup (Vue)
│   ├── VideoPlayer.vue     # Plyr video player wrapper (Vue)
│   ├── Ribbon.astro
│   ├── BrowserExtensionCarousel.astro
│   └── JobContent.astro
├── store/
│   └── modal.ts            # Nanostores atom for modal state
├── content/
│   └── jobs/               # Markdown job postings
│       ├── grant-writer.md
│       ├── volunteering.md
│       ├── _designer.md    # Prefixed with _ = hidden/draft
│       ├── _developer.md
│       └── _godev.md
├── styles/
│   ├── main.scss           # Entry point — imports all partials
│   ├── _variables.scss     # Mixins, breakpoints, forwards _colors
│   ├── _colors.scss        # Color variables ($green, $blue, $black, etc.)
│   ├── _base.scss          # Body/html defaults, link styles
│   ├── _reset.scss
│   ├── _typography.scss
│   ├── _utils.scss
│   ├── _page_common.scss
│   └── plyr/               # Plyr video player style overrides
├── utils.js                # getAllJobs(), sortedPosts() helpers
└── env.d.ts                # Astro type references
public/                     # Static assets served as-is
├── fonts/                  # Proxima Nova webfonts, FontAwesome 5.3.1
├── images/                 # Site images (with @2x retina variants)
├── third-party/            # jQuery, Plyr, fancybox, retina.js, etc.
├── videos/
├── other/                  # PDFs, legacy files, bylaws
├── nginx/server.conf       # Nginx redirect rules
└── robots.txt, sitemap.xml, favicon.ico
.github/workflows/          # CI: AI-powered PR review workflows
```

## Key Patterns and Conventions

### Component Architecture

- **Astro components** (`.astro`): Used for all static/structural content. Each page imports `BaseLayout` or a specialized layout.
- **Vue components** (`.vue`): Used only for client-side interactivity (video player, newsletter form, modals). Hydrated with `client:load` or `client:only="vue"` directives.
- Interactive Vue components receive data through props; cross-component state uses nanostores.

### Import Aliases

The `@/` alias maps to `src/` (configured in `tsconfig.json`):
```js
import Layout from '@/layouts/BaseLayout.astro'
import { openModal } from '@/store/modal'
```

### Styling

- All SCSS variables and mixins live in `src/styles/_variables.scss` (which forwards `_colors.scss`).
- Components import variables with `@use "../styles/variables" as *` (modern Sass module syntax). Some older files use `@import`.
- Styles are scoped per component via `<style lang="scss" scoped>` in Vue or `<style lang="scss">` in Astro.
- The global stylesheet entry point is `src/styles/main.scss`, imported in `BaseHead.astro`.
- Key breakpoint variables: `$tablet: 760px`, `$desktop: 1200px`.
- Responsive mixins: `@include until($bp)`, `@include from($bp)`, `@include from_until($from, $until)`.
- Utility mixins: `@include transition(...)`, `@include side-margin`, `@include side-padding`.
- Box-shadow variables: `$drop-shadow_shallow`, `$drop-shadow_medium`, `$drop-shadow_deep`.
- CSS class naming uses kebab-case for Astro components (`header--index`, `other-project-list`). Vue components use BEM-like `c-` prefix (`c-modal-container`, `c-news-letter-form`, `c-error-msg`).

### Content (Job Postings)

- Job posts are Markdown files in `src/content/jobs/`.
- Frontmatter fields: `id`, `title`, `pubDate`, `type`, `permalink`.
- Files prefixed with `_` (e.g., `_designer.md`) are filtered out from the live listing in `JobPost.astro`. They still generate routes, but those routes immediately redirect to `/hiring` instead of rendering the job content.
- Jobs are loaded via `getAllJobs()` in `src/utils.js` using `import.meta.glob`.
- Dynamic routing at `/hiring/[job]` uses `getStaticPaths()` with the `permalink` frontmatter field as the slug.

### Third-Party Libraries

Loaded globally via `<script>` tags (not npm):
- **jQuery** (`/third-party/jquery.min.js`) — loaded in `<head>` via `BaseHead.astro`
- **Plyr** (`/third-party/plyr.3.7.8.min.js`) — conditionally loaded when `loadPlyr={true}` is passed to `BaseLayout`
- **Fancybox**, **retina.js** — loaded in `BodyScripts.astro`
- **FontAwesome 5.3.1** — CSS loaded from `/fonts/fontawesome-5.3.1/css/all.min.css`

NPM dependencies:
- `vue` ^3.5 — interactive islands
- `nanostores` + `@nanostores/vue` — cross-framework state
- `sass` — SCSS compilation
- `@astrojs/vue` — Astro Vue integration
- `astro` ^5.10

### Fonts

The site uses **Proxima Nova** webfonts (Regular, Bold, Light, RegularIt, Thin) loaded via `public/fonts/stylesheet.css`. Font families referenced in CSS as `proxima_novaregular`, `proxima_novabold`, etc.

### Modal System

Modals are managed through nanostores (`src/store/modal.ts`):
- `$activeModal` atom holds the currently active modal name (string).
- `openModal(name)` / `unloadModal(name)` to show/hide.
- `ModalTemplate.vue` reads the store and renders when `modalName` matches `$activeModal`.
- Currently only one modal exists: `NewsLetterWarningModal` (warns about Gmail addresses).

### Analytics

Matomo tracking is embedded in `BodyScripts.astro`, pointing to `https://piwik.okturtles.org/`.

## Deployment

- The site builds to static HTML (`dist/`).
- Nginx redirect rules are in `public/nginx/server.conf` (legacy URL redirects like `/blog` → `blog.okturtles.org`).
- The blog lives at a separate subdomain: `blog.okturtles.org`.

## CI/CD — AI PR Review Workflows

Two GitHub Actions workflows for automated PR code review (`.github/workflows/`):

1. **`pull-review.yml`** — Triggered by `/review` comment on PRs. Uses OpenRouter or Z.AI for LLM review, with opencode as the agentic reviewer.
2. **`pull-review-crush.yml`** — Triggered by `/crush` comment. Same pattern but uses crush as the agentic reviewer.

Both support:
- Fast mode (`/review_fast` or `/crush_fast`) — skips raw review and combine step.
- Provider/model override syntax: `{{provider, model}}` or `{{provider, model, small_model}}`.
- Default provider: OpenRouter with `stepfun/step-3.5-flash`.

## Gotchas

- **jQuery dependency**: jQuery is loaded globally in `<head>` and used in inline `<script is:inline>` blocks on some pages (e.g., `index.astro`). The `is:inline` directive prevents Astro from processing these scripts.
- **Legacy `server.coffee` reference**: `package.json` has `"main": "server.coffee"` — this is vestigial and unused.
- **Mixed SCSS import styles**: Most components use `@use "../styles/variables" as *` (modern), but `JobPost.astro` uses `@import "../styles/_variables.scss"` (legacy). Follow the `@use` pattern for new code.
- **Git submodule**: The repo has a submodule at `widgets/btn` pointing to `taoeffect/break-the-net`. This directory may not be present after a shallow clone.
- **Retina images**: Many images in `public/images/` have `@2x` variants. `retina.js` handles swapping automatically.
- **Job post drafts**: Files in `src/content/jobs/` prefixed with `_` still generate routes via `getStaticPaths()` but are hidden from the job listing sidebar. To fully disable a job post, remove or rename the file.
- **`utils.js` not TypeScript**: Despite strict TS being enabled, `src/utils.js` is plain JavaScript with `import.meta.glob`.
- **Plyr global**: `VideoPlayer.vue` references `Plyr` as a global (loaded via `<script>` tag), not as an import. It will error if the Plyr script isn't loaded.
