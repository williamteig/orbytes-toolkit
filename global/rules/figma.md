---
description: Figma's only orbytes role is the optional design-inspiration moodboard (Stage M). URL handling, source-of-truth rules, and the moodboard_url field. Apply when building or handling the moodboard or any Figma link.
alwaysApply: false
---

# Figma Rules

Figma's only role in orbytes is the optional design-inspiration **moodboard** — see "The Moodboard" below and Stage M in `workflow.md`. It is **not** used to design, wireframe, or build the site.

## URL Handling

**Gotcha — strip query params from Figma URLs.**
When a user pastes a Figma URL, it often includes node-specific params that point to a single frame rather than the whole file. Only store the base URL up to the file name slug.

```
# Raw (do not store)
https://www.figma.com/design/R5PLf3RJErDKIXqGLIswlM/My-Project?node-id=0-1&p=f&t=KLtFCmyHrlPZKtSD-0

# Clean (store this)
https://www.figma.com/design/R5PLf3RJErDKIXqGLIswlM/My-Project
```

URL pattern: `https://www.figma.com/design/{fileKey}/{fileName}`
- `fileKey` = the segment after `/design/`
- When using MCP tools, `nodeId` = `{int1}:{int2}` (replace `-` with `:` from the URL param)

## The Moodboard — Figma's only role

In the orbytes workflow, Figma is used **only** for the optional **Moodboard** (Stage M — see `workflow.md`). Figma is **not** used to mock up, wireframe, or design the site — that happens in the build stack (Framer / Astro / Webflow). The old lightweight-Figma-mockup step is retired.

The moodboard is **one Figma canvas, built for the client**, where design inspiration is splashed together from many sources so everyone can see and agree the visual direction before Design begins. Pull from wherever good references live:

- Template galleries / marketplaces (e.g. Framer & Webflow template sites)
- [Pinterest](https://pinterest.com)
- [Land-book](https://land-book.com)
- [Variant](https://variant.com)
- Competitor and admired sites captured during discovery
- …and any other reference — the list is open-ended

The inspiration **library** (`discovery/inspirational-material/`, see `inspiration.md`) is the *source*; the moodboard is its consolidated visual *output* for the client.

## Design Philosophy

- The Moodboard stage is **optional** — skip it when the client already has clear, agreed direction (e.g. a quick landing page or a strong existing brand).
- **The moodboard is not a source of truth.** The shipped, rendered site is canonical. Brand tokens live in `design.md`. Copy and strategy live in the project vault. Do not treat the moodboard as authoritative for content, layout, or live design state — it captures *direction*, not the build.
- Do not attempt to keep Figma in sync with production. The live site wins, always.
- The moodboard is **not** an approval gate — it is shared with the client to set direction; the formal Gate 2 still sits after Design.
- When migrating an existing site (e.g. Webflow → Astro), never use Figma as the source for content or layout. Capture the rendered browser DOM per `orbytes-discovery` Step 1b and work from that.
- When a moodboard exists, its URL lives in `project.md` frontmatter as `moodboard_url` (base URL only, strip query params per URL Handling above).
