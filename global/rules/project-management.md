---
description: Rules for project management — project.md as source of truth, update patterns. Apply when reading or updating project status.
alwaysApply: false
---

# Project Management Rules

## Source of Truth

Every client project has a `project.md` file in its repo root. This is the single source of truth for project state, client details, stage progress, tasks, approvals, and blockers.

**Always read `project.md` first** before starting any work on a client project. After completing work, update `project.md` to reflect what changed.

## Brand Kit

Each project also has a `brand.md` file containing:
- Logo files and usage
- Colour palette (hex codes)
- Typography (fonts, weights, sizes)
- Brand voice and tone

Brand details should be read from `brand.md`, not assumed or pulled from elsewhere.

## Project Record Fields

Each `project.md` has YAML frontmatter with:
- `client` — Client name
- `status` — active / paused / completed
- `stage` — Current stage (e.g. `1-research`, `3-design`)
- `stack` — Website stack (astro / framer / webflow)
- `tier` — Service tier (landing-page / website / custom)
- `figma_url` — Figma design file URL (base URL only, no query params)
- `framer_url` — Framer project URL (if Framer stack)
- `webflow_url` — Webflow site URL (if Webflow stack)
- `github_url` — GitHub repo URL
- `live_url` — Production URL

## Update Patterns

| Trigger | What to update in project.md |
|---------|------------------------------|
| Stage completed | Check off tasks, move `← CURRENT` marker |
| Approval received | Update Approvals table with status and date |
| New URL created | Set relevant frontmatter field |
| Blocker identified | Add to Blockers section |
| Blocker resolved | Remove from Blockers section |
| Notes from client | Add dated entry to Notes section |

## Frontmatter Stage Values

Use these exact values for the `stage` field:
- `x-branding` — Branding in progress (optional)
- `1-research` — Research & Discovery
- `2-content` — Content Writeup
- `3-design` — Design
- `4-development` — Development
- `5-launch` — Launch & Handover
- `completed` — Delivered
