# orbytes — Framer Website Project

This is an orbytes **Framer** website project. The site is designed and built inside Framer's visual editor. This repo holds project management files and optional custom code.

## Stack

- **Build:** Framer (visual editor)
- **CMS:** Framer CMS (built-in)
- **Deploy:** Framer hosting
- **Framer URL:** (see `project.md` frontmatter `framer_url`)

## Project Files

- `project.md` — Single source of truth for status, stages, tasks, approvals
- `brand.md` — Logo, colors, fonts, brand voice
- `CLAUDE.md` — This file
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

## Custom Code

When the site needs JavaScript or CSS beyond what Framer provides:

1. Write code in `src/scripts/` or `src/styles/`
2. Push to GitHub
3. Deliver via CDN:
   - **jsDelivr:** `https://cdn.jsdelivr.net/gh/williamteig/{{PROJECT_NAME}}@main/src/scripts/[file].js`
   - **Vercel:** Deploy repo and use the Vercel URL
4. Embed in Framer via custom code block (`<script>` or `<link>`)

If the code is short (< ~30 lines), embed it directly in Framer instead.

## How the LLM Helps

On a Framer project, the LLM assists with:
- **Strategy & planning** — site structure, page hierarchy, CMS schema, conversion funnels
- **Content** — copy, headlines, CTAs, meta descriptions, CMS content
- **Design & build via Framer MCP** — direct read/write access to Framer project (styles, components, layout, CMS, pages). Framer MCP plugin must be open in Framer during use.
- **Custom code** — JS/CSS that goes beyond Framer's built-in capabilities
- **CMS structure** — designing Framer CMS collections and fields
- **Brand application** — ensuring `brand.md` tokens are applied consistently
- **Project tracking** — updating `project.md` pipeline, logging changes

## Client Operations Defaults

- Treat `project.md` as the source of truth for client contact details.
- Default client email target is `project.md` frontmatter `client_contact_email`.
- For branding update checks, default to `project.md` `branding_vendor_domains` (Softriver domains by default) before asking follow-up questions.
- If contact details are missing in `project.md`, ask for them and then update `project.md` first.

## Design System

All design and development happens in Framer. No separate design tool (Figma is dropped). Use Framepad as the component/design system starting point for new builds.

## Changelog

The `changelog/` folder logs every meaningful change. See `changelog/` entries for format. **Always log after completing work.**
