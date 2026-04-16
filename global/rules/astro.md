---
description: >-
  Astro conventions for orbytes website projects — islands, routing, images, content collections.
  Apply when editing Astro sites or discussing static vs client-side behavior.
alwaysApply: false
---

# Astro

## When this applies

Website projects scaffolded with `/new-orbytes-website` and any client repo using **Astro**. Project-specific detail may also live in that repo’s `CLAUDE.md`; this rule is the **global** baseline.

## Principles

- **Static-first:** ship HTML by default; add client JS only where interaction requires it.
- **File-based routing:** pages live under `src/pages/`; layouts under `src/layouts/`; reusable UI under `src/components/`.
- **Images:** prefer Astro’s `<Image />` (or the project’s image pipeline) over unoptimized `<img>` for content images.
- **Content collections:** use for structured content (blog, case studies) when the project enables them.

## Islands

Use framework components (React, Svelte, etc.) only when **client-side** state or browser APIs are required. Default to `.astro` components for markup and composition.

## SEO

- Unique `<title>` and meta description per route.
- Semantic landmarks: `<main>`, `<article>`, `<section>`, `<nav>` as appropriate.
- Sitemap and structured data when the project includes them.

## Integration with Webflow CMS

When content is edited in **Webflow** and consumed at build time:

- Map collection fields to typed shapes in the Astro project.
- Cache or batch API calls during build; fail the build visibly on schema mismatch.

## Related rules

- **Website vs app path:** `dev-workflow.md`
- **Tailwind:** `tailwind.md`
- **Webflow / CMS mode:** `webflow.md`
