# Orbytes — Global Project Instructions

You are working on an Orbytes client project. Orbytes is a boutique web design studio run by Will Teig (william@orbytes.io) that builds websites for clients using a structured, stage-gated workflow.

## Source of Truth

Every client project has a **`project.md`** file in its repo root. This is the single source of truth for:
- Current stage and progress
- Client details and contact info
- Approval gate status
- Tasks and blockers
- Timeline

**Always read `project.md` first** before starting any work on a client project.

## Tools & Platforms

- **Obsidian / Markdown** — Project management, client notes, brand kit, copy drafts
- **GitHub** — Version control under `williamteig` personal account (private repos)
- **Cloudflare / Vercel** — Deployment (varies per project)
- **Softriver** — Whitelabeled branding partner (delivers logo, palette, fonts)
- **Claude Code / Cursor** — Development, copywriting, project automation

**On request (not foundational):**
- **Figma** — Mockups, graphics, branding assets when needed
- **Paper.design** — Quick design mockups with AI assistance

## Website Stacks

| Stack | When to use |
|-------|-------------|
| **Framer** | Primary for new work. Visual builder + built-in CMS. |
| **Astro + CloudCannon** | Code-heavy projects needing full codebase + Git-based CMS. |
| **Webflow** | Legacy/selective. Only when the engagement specifically uses Webflow. |

All website-tier projects have a local repo for `project.md`, `brand.md`, and any custom code (even Framer/Webflow projects may have CDN-delivered scripts).

## Skills

- **orbytes-qualify** — Walk a prospective client through the qualification checklist.
- **orbytes-scaffold** — Scaffold a new client project with correct stack and structure.
- **orbytes-discovery** — Process client discovery questionnaire responses.
- **orbytes-audit** — Audit pipeline checkmarks against actual repo state. Run before gate approvals or health checks.

## Rules

Detailed rules and conventions are in `~/.claude/rules/` (Claude Code) or `~/.cursor/rules/` (Cursor):

- `coding.md` — Naming, commit style, code quality (always applies)
- `git.md` — GitHub conventions, branch/PR patterns (always applies)
- `workflow.md` — Stage order, approval gates, service tiers
- `project-management.md` — project.md as source of truth, update patterns
- `framer.md` — Framer conventions, CMS, custom code delivery
- `astro.md` — Astro defaults for website projects
- `tailwind.md` — Tailwind tokens and breakpoints
- `cloudflare.md` — Pages, Workers, secrets, previews
- `cloudcannon.md` — Git-backed CMS editing and branch workflow
- `webflow.md` — Webflow site management (when engaged)
- `figma.md` — Figma URL handling, design mockups (when engaged)
- `copy.md` — Copy process: voice, page strategy, drafting, review
- `inspiration.md` — Inspiration ingestion: folder-per-reference, image renaming, notes template
