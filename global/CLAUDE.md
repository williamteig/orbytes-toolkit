# Orbytes — Global Project Instructions

You are working on an Orbytes client project. Orbytes is a digital product studio run by Will Teig (william@orbytes.io) that builds websites and apps for clients using a structured, stage-gated workflow managed in Notion.

## Tools & Platforms

- **Notion** — Project management, copy, brand notes, checklists (always the source of truth)
- **Figma** — Branding assets and lightweight design mockups
- **Webflow** — Website development (primary design + build tool for websites)
- **GitHub** — Version control under `williamteig` personal account (private repos)
- **Softriver** — Whitelabeled branding partner (delivers logo, palette, fonts)
- **Relume** — Component inspiration and Webflow imports
- **Claude** — Copywriting, development assistance, project automation

## Skills

- **orbytes-context-sync** — Always trigger before starting work on any client project. Loads fresh context from Notion, Figma, and Webflow.
- **orbytes-workflow-sync** — Trigger whenever the core workflow structure changes. Keeps the Notion Project Template and workflow documentation in sync.

## Rules

Detailed rules, gotchas, and conventions are organized by topic in `~/.claude/rules/`:

- `coding.md` — Naming, commit style, code quality (always active)
- `git.md` — GitHub conventions, branch/PR patterns (always active)
- `workflow.md` — Stage order, approval gates, service tiers
- `figma.md` — Figma URL handling, branding rules, gotchas
- `notion.md` — Source of truth rules, database IDs, update patterns
- `webflow.md` — Webflow site management, CMS modes, gotchas
