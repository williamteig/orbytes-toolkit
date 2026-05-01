---
description: Rules and gotchas for working with Figma — URLs, design context, branding assets. Apply when handling Figma links or design files.
alwaysApply: false
---

# Figma Rules

For **file page layout**, **brand vs wireframe vs hi-fi**, **variables-before-components**, **section handoff**, and **design-stage deploy**, see **`figma-file-structure.md`**.

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

## Design Philosophy

- Figma is **optional** and **on-request** — use it for low-fidelity mockups, early visual exploration, or branding moodboards when that aids communication with the client or designer.
- **Figma is not a source of truth.** The shipped, rendered site is canonical. Brand tokens live in `brand.md`. Copy and strategy live in the project vault. Do not treat a Figma file as authoritative for content, layout, or live design state.
- Do not attempt to keep Figma in sync with production. The live site wins, always.
- When migrating an existing site (e.g. Webflow → Astro), never use Figma as the source for content or layout. Capture the rendered browser DOM per `orbytes-discovery` Step 1b and work from that.
- Pixel-perfect accuracy is not the priority above getting the design right.
- If a Figma file exists for a project, its URL lives in `project.md` frontmatter (`figma_url` field).
