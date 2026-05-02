# orbytes — Website Project Rules

This is an orbytes **website** client project. These rules extend the global orbytes rules.

## Stack

Check `project.md` frontmatter for the `stack` field. This determines which conventions apply.

| Stack | Build tool | CMS | Deploy | Code repo? |
|-------|-----------|-----|--------|------------|
| **Astro + CloudCannon** | Astro (via `CloudCannon/astro-component-starter`) | CloudCannon (Git-based, three-file component pattern) | CloudCannon-built (default) / Cloudflare Pages headless (optional) | Yes — full codebase |
| **Framer** | Framer (visual) | Framer CMS | Framer hosting | Minimal — project files + CDN scripts only |
| **Webflow** | Webflow Designer | Webflow CMS | Webflow hosting | Minimal — project files + CDN scripts only |

See `stacks.md` for detailed conventions per stack.

### Record for this project (fill in)

- **Stack:** (Astro / Framer / Webflow)
- **CMS:** (CloudCannon / Framer CMS / Webflow CMS / none)
- **Deploy:** (CloudCannon-built / Cloudflare Pages headless / Framer / Webflow)
- **CDN code:** (yes — Vercel/jsDelivr | none)

## Project Files

Every website project has at minimum:
- `project.md` — Single source of truth for status, stages, tasks, approvals
- `brand.md` — Logo, colors, fonts, brand voice
- `CLAUDE.md` — This file (project-level AI instructions)
- `changelog/` — Log of all changes made to the project
- `ops/lint-project.sh` — Project lint protocol (style + ingest linkage checks)
- `.project-lint.json` — Project-specific lint config (purpose keywords + ingest paths)

## Project Lint Protocol

Run this before handoff and after major ingests:

```bash
./ops/lint-project.sh
```

Semantic-only:

```bash
./ops/lint-project.sh semantic-only
```

Checks include:
- Markdown hygiene for core project docs.
- Orphaned files in `raw/` that are not referenced in tracked project docs.
- Missing linkage from `knowledge/entries/*.md` to source files via frontmatter `source_file`.
- Entries that do not connect back to project purpose keywords.

## Client Operations Defaults

- Use `project.md` as the source of truth for client contact details.
- Default email target for client comms lookup is `project.md` frontmatter `client_contact_email`.
- Default branding-source checks to `project.md` frontmatter `branding_vendor_domains` (Softriver domains by default) unless the project explicitly uses another vendor.
- If contact details are missing in `project.md`, gather them and update the file before running comms workflows.

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

## Knowledge Base

The project has a knowledge ingestion system for processing client communications, documents, and feedback.

### Structure

```
raw/                    # Source material (human-managed)
  comms/                # Slack messages, emails, voice transcripts
  docs/                 # Brand guides, PDFs, attachments
  feedback/             # Revision requests, review notes
knowledge/              # Processed knowledge (LLM-managed)
  index.md              # Master catalog + unresolved items
  entries/              # One file per ingested source
```

### Skills

- **`orbytes-ingest`** — Process new client input into the knowledge base. Run whenever new material arrives in `raw/` or the user pastes client communications.
- **`orbytes-query`** — Search the knowledge base. Use when you need to know what the client said about a topic, or to check for contradictions before making decisions.
- **`orbytes-context-bridge`** — Pull context from Williams 2nd Brain. Use when you need orbytes business knowledge or cross-project insights.

### When to ingest

- Client sends a Slack message with decisions or preferences
- Client emails revision feedback
- Client sends a document (brief, brand guide, content)
- Voice note transcript is added
- Meeting notes are written up
- Design review comments come in

### When to query

- Before writing copy — check what the client said about tone, audience, messaging
- Before making design decisions — check stated preferences
- When something feels contradictory — verify against the knowledge base
- When resuming work after a break — check for new ingested material

## Astro + CloudCannon Conventions (when stack = Astro)

This project was scaffolded from `CloudCannon/astro-component-starter`. Its conventions take precedence over generic Astro patterns — modify in place, don't rebuild the structure.

### The three-file component pattern

Every component folder contains three files:

```
src/components/.../button/
├── Button.astro                           # The component
├── button.cloudcannon.inputs.yml          # Editor input schema
└── button.cloudcannon.structure-value.yml # Default content shape + picker metadata
```

**Do not** move to a Bookshop-style pattern; do not invent new component schemes. Every new component follows this three-file convention so CloudCannon's Visual Editor picks it up automatically.

### Project Structure (Astro — Component Starter)

```
src/
├── components/
│   ├── building-blocks/    # Core UI: buttons, headings, forms, layout wrappers
│   ├── page-sections/      # Full-width sections: heroes, features, CTAs, testimonials
│   └── navigation/         # Header, footer, mobile nav
├── component-docs/         # Dev-only docs site (excluded from production by default)
├── content/                # Pages and blog posts (Markdown/MDX)
├── layouts/
├── pages/
├── styles/
│   ├── variables/          # Design tokens — colours, fonts, spacing, widths
│   └── themes/             # Light / dark theme definitions
├── assets/
├── icons/
└── data/
```

### Styling

- **Vanilla CSS with CSS custom properties** — no Tailwind. The starter is intentionally framework-free so the CSS footprint stays small.
- Brand tokens from `brand.md` go into `src/styles/variables/` (colours, typography, spacing).
- Theme variants (light/dark) live in `src/styles/themes/`.
- Use utility classes only where the starter already provides them; don't add Tailwind or another utility framework.

### Astro framework basics

- Use `.astro` components for pages, layouts, and most UI.
- Use framework components (React/Svelte/etc.) only when client-side state or browser APIs are required.
- Prefer Astro's built-in `<Image />` for optimised images.
- Use content collections for structured content — the starter pre-configures `src/content/pages/` and `src/content/blog/`.

### CloudCannon agent-skills

Every Astro project installs four CloudCannon skills at scaffold time under `.agents/skills/`:
- `cloudcannon-configuration` — edit `cloudcannon.config.yml`, collections, inputs, structures
- `cloudcannon-visual-editing` — wire editable regions
- `cloudcannon-snippets` — configure MDX snippet components
- `migrating-to-cloudcannon` — 5-phase migration workflow

These trigger automatically from Claude Code based on the task. `brainstorming` is deliberately excluded — orbytes' `shape`, `critique`, `impeccable` skills cover that space.

### Component docs

The starter includes a `/component-docs/` route (dev-only) with a visual builder for every component. Use `npm run dev` and visit it to discover what's available before writing anything new.

### Hosting

- Default: CloudCannon-built — CloudCannon runs the Astro build and serves it, with full visual preview in the editor.
- Alternative: headless mode — CloudCannon is editor-only; Cloudflare Pages runs the build via GitHub Actions. Pattern demonstrated in `tomrcc/astro-headless-demo`. Only pick this when the client prioritises Cloudflare deploy over visual preview.

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
