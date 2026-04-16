---
description: Orbytes client project workflow — approval gates, stage order, service tiers. Apply when managing or discussing client project progress.
alwaysApply: false
---

# Client Workflow Rules

## Stage Order

Never skip stages or begin a later stage before the prior approval gate is passed:

- **Stage X — Branding** (optional, runs in parallel, must complete before Design)
- **Stage 1 — Research & Discovery**
- **Stage 2 — Content Writeup + Sitemap** → ✅ Approval Gate 1
- **Stage 3 — Design** (Figma — lightweight, homepage + one page max) → ✅ Approval Gate 2
- **Stage 4 — Development** (implementation — typically **Astro + Tailwind** for sites; **Webflow** only when that engagement includes a Webflow build) → ✅ Approval Gate 3
- **Stage 5 — Launch & Handover**

## Key Rules

- Three approval gates only — after copy, after design, after development
- `project.md` is the source of truth — always read it before starting work
- Branding (Softriver) is always whitelabeled — never mention Softriver to clients
- Figma design is intentionally lightweight — site implementation defaults to the stack chosen in `project.md` (Astro, Framer, or Webflow)
- The qualification form lives on external platforms — project repo is only created once a client is qualified

## Service Tiers

- **Landing Page** — Fixed price, single page
- **Full Website** — Multi-page + CMS, fixed price
- **Custom Build** — Enterprise, technical integrations, custom scope
