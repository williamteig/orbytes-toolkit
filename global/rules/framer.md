---
description: Conventions for Framer website projects — design, CDN code, and project structure. Apply when working on a Framer-stack project.
alwaysApply: false
---

# Framer Rules

## When Framer is Used

Framer is the stack choice for simpler marketing sites, single-page sites, and fast-turnaround projects. The design and build happen directly in Framer's visual editor — there is no Figma-to-code handoff.

## Project Structure

Framer projects have a minimal local repo:

```
repo/
├── project.md              # Source of truth
├── brand.md                # Brand kit
├── CLAUDE.md               # Project-level AI instructions
└── src/                    # Custom code (if needed)
    ├── scripts/            # JS for CDN delivery
    └── styles/             # CSS for CDN delivery
```

The Framer project URL is stored in `project.md` frontmatter as `framer_url`.

## Design Conventions

- Design directly in Framer — do not create separate Figma mockups unless the project also needs a Figma file for a specific reason
- Use Framer's built-in responsive breakpoints
- Use Framer's built-in interactions and animations — avoid custom JS unless necessary
- Use Framer CMS for any structured content (blog posts, team members, etc.)
- Apply brand tokens from `brand.md` to Framer's design system (colors, fonts)

## Custom Code via CDN

When a Framer site needs custom JavaScript or CSS beyond what Framer provides:

1. Write the code locally in `src/scripts/` or `src/styles/`
2. Push to GitHub
3. Deliver via CDN — either:
   - **jsDelivr:** `https://cdn.jsdelivr.net/gh/williamteig/[repo]@main/src/scripts/[file].js`
   - **Vercel:** Deploy the repo and use the Vercel URL
4. Embed in Framer via custom code block (`<script>` or `<link>`)

## Gotchas

**Gotcha — Framer has no local development.**
Unlike Astro, there is no `npm run dev`. All design and layout work happens in Framer's web editor. The local repo is only for project management files and custom code.

**Gotcha — Framer CMS is not Git-based.**
Content lives inside Framer, not in local markdown files. If the client needs Git-based content management, use Astro + CloudCannon instead.

**Gotcha — custom fonts need to be uploaded to Framer.**
Framer supports Google Fonts natively. For custom/self-hosted fonts, upload the font files directly in Framer's font settings.
