# orbytes — Website Project Rules

This is an orbytes **website** client project. These rules extend the global orbytes rules.

## Stack

Check `project.md` frontmatter for the `stack` field. This determines which conventions apply.

| Stack | Build tool | CMS | Deploy | Code repo? |
|-------|-----------|-----|--------|------------|
| **Astro + CloudCannon** | Astro + Tailwind | CloudCannon (Git-based) | Cloudflare Pages / Vercel | Yes — full codebase |
| **Framer** | Framer (visual) | Framer CMS | Framer hosting | Minimal — project files + CDN scripts only |
| **Webflow** | Webflow Designer | Webflow CMS | Webflow hosting | Minimal — project files + CDN scripts only |

See `stacks.md` for detailed conventions per stack.

### Record for this project (fill in)

- **Stack:** (Astro / Framer / Webflow)
- **CMS:** (CloudCannon / Framer CMS / Webflow CMS / none)
- **Deploy:** (Cloudflare Pages / Vercel / Framer / Webflow)
- **CDN code:** (yes — Vercel/jsDelivr | none)

## Project Files

Every website project has at minimum:
- `project.md` — Single source of truth for status, stages, tasks, approvals
- `brand.md` — Logo, colors, fonts, brand voice
- `CLAUDE.md` — This file (project-level AI instructions)
- `changelog/` — Log of all changes made to the project

## Changelog

The `changelog/` folder is a running log of every meaningful change made to the project. **You must log changes here after completing any task** that modifies project files.

### Format

Each entry is a separate markdown file named `YYYY-MM-DD-<slug>.md`:

```markdown
---
date: YYYY-MM-DD
stage: (current pipeline stage, e.g. 1-research, 3-design)
type: (scaffold | content | design | dev | config | fix | refactor)
---

## Summary
One-line description of what changed.

## Changes
- Bullet list of specific files added, modified, or removed
- Include why, not just what

## Context
Any relevant context — what prompted the change, linked tasks, decisions made.
```

### Rules

- **One file per logical change** — a feature, fix, or task completion. Don't batch unrelated changes.
- **Name the file descriptively** — e.g. `2026-04-13-initial-scaffold.md`, `2026-04-15-hero-section-copy.md`
- **Always log after completing work** — this is not optional. If you made changes, log them.
- **Reference project.md tasks** — if the change relates to a task in `project.md`, mention it.

## Astro Conventions (when stack = Astro)

- Use `.astro` components for pages and layouts
- Use framework components (React/Svelte) only when client-side interactivity is required
- Prefer Astro's built-in `<Image />` for optimized images
- Use content collections for structured content
- Keep pages in `src/pages/`, layouts in `src/layouts/`, components in `src/components/`

### Project Structure (Astro)

```
src/
├── components/          # Reusable UI components
│   ├── ui/             # Primitives (Button, Card, Input)
│   ├── sections/       # Page sections (Hero, CTA, Features)
│   └── layout/         # Header, Footer, Nav
├── layouts/            # Page layouts (BaseLayout, BlogLayout)
├── pages/              # File-based routes
├── content/            # Content collections
├── styles/             # Global styles, Tailwind base overrides
├── assets/             # Static assets (images, fonts, icons)
└── lib/                # Utilities, helpers, API clients
```

## Tailwind Conventions (when stack = Astro)

- Use utility classes directly in markup — avoid `@apply` except in base styles
- Define brand colours, fonts, and spacing in `tailwind.config.mjs` from `brand.md` tokens
- Use responsive prefixes (`sm:`, `md:`, `lg:`) for mobile-first breakpoints
- Use `prose` from `@tailwindcss/typography` for CMS/long-form content

## Performance Targets

- Lighthouse: 90+ across all categories
- LCP: < 2.5s, FCP: < 1.5s, TBT: < 200ms
- Lazy-load below-fold images
- Minimize client-side JavaScript

## SEO Defaults

- Unique `<title>` and `<meta name="description">` per page
- Semantic HTML (`<main>`, `<article>`, `<section>`, `<nav>`)
- Open Graph and Twitter Card meta tags
- Sitemap (`@astrojs/sitemap`)
- Structured data (JSON-LD) where appropriate
