# Orbytes — Global Project Instructions

You are working on an Orbytes client project. Orbytes is a web agency that builds websites and apps for clients using a structured, stage-gated workflow managed in Notion.

## Source of Truth

Notion is always the primary source of truth for project state, client details, copy, and checklists. Before starting any work on a client project, fetch the client's Notion project page to load current context. After completing work, update Notion to reflect what changed.

## Tools & Platforms

- **Notion** — Project management, copy, brand notes, checklists (always the source of truth)
- **Figma** — Branding assets and lightweight design mockups
- **Webflow** — Website development (primary design + build tool for websites)
- **GitHub** — Version control under the `orbytes` organization (private repos)
- **Softriver** — Whitelabeled branding partner (delivers logo, palette, fonts)
- **Relume** — Component inspiration and Webflow imports
- **Claude** — Copywriting, development assistance, project automation

## Notion Database Reference

- **Orbytes Clients DB:** `collection://3282204c-5659-80e1-ad2b-000bdf0d92f2`
- **Database ID:** `3282204c-5659-8003-8f3d-f3f7a7646643`
- **Project Template ID:** `3352204c-5659-80e2-a8ee-ef6a9121a71e`

## Workflow Stages

Every client project follows this stage-gated workflow. Do not skip stages or begin work on a later stage until the prior approval gate has been passed.

- **Stage X — Branding** (optional add-on via Softriver, runs in parallel, must complete before Design)
- **Stage 1 — Research & Discovery** — Asset Docs, Discovery Notes, Competitor Research, Moodboard
- **Stage 2 — Content Writeup + Sitemap** → ✅ Client Approval Gate 1 (all copy approved before design)
- **Stage 3 — Design** (Figma, intentionally lightweight — homepage + optionally one more page) → ✅ Client Approval Gate 2
- **Stage 4 — Development** (Webflow for websites, primary design happens here) → ✅ Client Approval Gate 3
- **Stage 5 — Launch & Handover**

## Service Tiers

- **Landing Page** — Fixed price, single page
- **Full Website** — Multi-page + CMS, fixed price
- **Custom Build** — Enterprise, technical integrations, custom scope

## Key Rules

- Notion workspace is only created once a client is qualified
- Branding (Softriver) is always whitelabeled — never mention Softriver to clients
- Three approval gates: after copy, after design, after development
- Figma design is intentionally lightweight — Webflow is the primary design tool for websites
- The qualification form lives on external platforms — never recreate it in Notion

## Coding Standards

- Write clean, readable code with meaningful names — avoid abbreviations
- Commit messages should be concise and describe the "why" not just the "what"
- All repos are private under the `orbytes` GitHub organization
- Use conventional commit format where practical: `feat:`, `fix:`, `docs:`, `chore:`

## Skills

This project has access to Orbytes-specific skills. Use them:

- **orbytes-context-sync** — Always trigger before starting work on any client project. Loads fresh context from Notion, Figma, and Webflow.
- **orbytes-workflow-sync** — Trigger whenever the core workflow structure changes. Keeps the Notion Project Template and workflow documentation in sync.
