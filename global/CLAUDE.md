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

## First-session protocol (every orbytes project)

The 2nd Brain wiki does not auto-load outside its own directory, and per-project memory is keyed per directory — so a client project starts each session with **no** wiki context unless it's been bridged. On the first interaction in any orbytes project, run this check:

1. Read `project.md` (always).
2. Check for `context-bridge.md` in the project root.
   - **If present** — read it for 2nd Brain context, then proceed.
   - **If missing** — say so in the first reply and offer: *"This project doesn't have a `context-bridge.md` yet. Want me to run `orbytes-context-bridge` to pull relevant 2nd Brain context before we start?"* Don't run it without confirmation — Will may want to dive straight into a small task.
3. Read the user's actual request and respond.

The bridge skill itself starts with a questionnaire — it asks Will what he already knows that's relevant, then searches the 2nd Brain based on his answers. Never search the wiki blindly; ask first, search second.

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
- **orbytes-ingest** — Ingest client comms, docs, and feedback into the project knowledge base.
- **orbytes-query** — Search the knowledge base for what the client said about a topic.
- **orbytes-context-bridge** — Pull context from Williams 2nd Brain into the current project.
- **orbytes-seo** — Opt-in SEO workflow. Run only on explicit request; post-build by default.

## Rules

Detailed rules and conventions are in `~/.claude/rules/` (Claude Code) or `~/.cursor/rules/` (Cursor):

- `behaviour.md` — Global behavioural rules: never fabricate, check gates with tools, draft in target tool, verify-in-app over guessing, session scope, multi-stack stance, William's email voice (always applies)
- `coding.md` — Naming, commit style, code quality (always applies)
- `git.md` — GitHub conventions, branch/PR patterns (always applies)
- `workflow.md` — Stage order, approval gates, service tiers
- `seo.md` — SEO execution policy (opt-in only, post-build default)
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
- `knowledge.md` — Knowledge base ingestion, retrieval, and contradiction detection
# graphify
- **graphify** (`~/.claude/skills/graphify/SKILL.md`) - any input to knowledge graph. Trigger: `/graphify`
When the user types `/graphify`, invoke the Skill tool with `skill: "graphify"` before doing anything else.
