# orbytes-claude-toolkit — Project Instructions

You are helping Will build and maintain the **orbytes-claude-toolkit**, a centralized Claude Code configuration repo that standardizes how Claude works across all orbytes.io client projects.

## What this project is

A GitHub repo (`williamteig/orbytes-claude-toolkit`) cloned at `/Users/williamteig/Documents/AppDev/orbytes-claude-toolkit`. It contains three layers of Claude Code configuration — global, website, and app — plus slash commands that scaffold new projects and manage the dev pipeline. Everything is symlinked into `~/.claude/` so updates to this repo propagate instantly to all projects.

## Architecture

```
orbytes-claude-toolkit/
├── global/                    # Applies to ALL orbytes projects via ~/.claude/ symlinks
│   ├── CLAUDE.md             # Global rules: orbytes identity, dev pipeline, coding standards
│   └── skills/               # Global skills symlinked into ~/.claude/skills/
│       ├── orbytes-context-sync/   # Syncs Notion ↔ Figma ↔ Webflow per client
│       └── orbytes-workflow-sync/  # Keeps Notion template + workflow.md in sync
├── website/                   # Copied into website projects during scaffolding
│   ├── CLAUDE.md             # Astro + Tailwind conventions, SEO, performance targets
│   └── templates/            # Starter files (package.json, astro.config, layouts, etc.)
├── app/                       # Copied into app projects during scaffolding
│   └── CLAUDE.md             # Architecture principles, security defaults, flexible stack
├── commands/                  # Symlinked into ~/.claude/commands/
│   ├── task.md               # /task — execute or create Dev Pipeline tasks in Notion
│   ├── new-orbytes-website.md # /new-orbytes-website — interactive website scaffolding
│   └── new-orbytes-app.md     # /new-orbytes-app — interactive app scaffolding
├── install.sh                 # Symlinks everything into ~/.claude/
└── uninstall.sh               # Removes symlinks, restores backups
```

## How it works

- **Global layer** lives in `~/.claude/` via symlinks. It applies to every Claude Code session automatically. Updating a file here updates it everywhere.
- **Type-specific layers** (website/app) are copied into each project during scaffolding via the `/new-orbytes-website` or `/new-orbytes-app` commands. These become project-local and can be customized per client.
- **Commands** are symlinked into `~/.claude/commands/` and available as slash commands in any Claude Code session.

## The /task command

`/task` interfaces with the orbytes Dev Pipeline in Notion.

- **Dev Pipeline Database ID:** `599e132701274298b902d85a529ebde5`
- **Data Source:** `collection://277efdcf-8436-4503-84a6-20f3e9428ef7`
- **Schema:** Task (title), Status (Not started / In progress / Done), Type (Feature / Bug / Chore / Research / Docs), Priority (Critical / High / Medium / Low), Project (TAT Website / TAT Connector / Orbytes / Personal), Due, Estimate (pts), Branch, Phase, Notes, ID (auto-increment)

Two modes:
1. `/task [number]` — Fetch the task by ID, read its full Notion page content, execute the work, write findings back to the Notion page, update status. If the task has questions or needs clarification, ask before executing.
2. `/task [description]` — Create a new task. Ask clarifying questions (project, type, priority), create the page in Notion, present it for approval.

## The scaffolding commands

`/new-orbytes-website` and `/new-orbytes-app` both follow the same pattern:
1. Ask interactive onboarding questions (client name, stack choices, integrations)
2. Create project directory
3. Copy global CLAUDE.md + skills into the project
4. Copy type-specific CLAUDE.md and templates
5. Apply customizations based on answers
6. Install dependencies, verify build, init git
7. Create an initial task in the Dev Pipeline

Website defaults to Astro + Tailwind. App stack is chosen during onboarding (Next.js, SvelteKit, React Native, etc.).

## orbytes context

- **orbytes.io** is a digital product studio run by Will Teig (william@orbytes.io)
- **Service tiers:** Landing Page (fixed), Full Website (fixed), Custom Build (enterprise)
- **Tools:** Notion (source of truth), Figma (design), Webflow (website builds), Relume (components), Claude (copy + code), Softriver (whitelabel branding)
- **Pipeline:** Client Summary → Stage X Branding (optional) → Stage 1 Research → Stage 2 Content (Approval Gate 1) → Stage 3 Design (Approval Gate 2) → Stage 4 Development (Approval Gate 3) → Stage 5 Launch
- **Key rules:** Three approval gates only. Notion is always truth. Figma is lightweight. Branding is always whitelabeled. Never skip stages.

## What still needs building

This toolkit is a living project. Areas to expand:

- **More global skills** — e.g., a `/deploy` command, a `/review` command for code review standards
- **Website templates** — more complete Astro starter (components, styles, content collections)
- **App templates** — framework-specific starters for Next.js, SvelteKit, etc.
- **MCP configuration** — standard `mcp-servers.json` for Notion, Figma, Webflow connections
- **Hooks** — auto-context loading on session start, pattern extraction
- **Rules** — language-specific coding rules (TypeScript, Python, etc.)
- **Testing** — verify commands work end-to-end in fresh Claude Code sessions

## How to work on this project

- Edit files directly in the repo at `/Users/williamteig/Documents/AppDev/orbytes-claude-toolkit`
- Changes to `global/`, `commands/`, and `global/skills/` take effect immediately everywhere (they're symlinked)
- Changes to `website/` and `app/` only affect newly scaffolded projects
- Commit and push to keep the GitHub remote in sync
- The install script is idempotent — safe to re-run after adding new commands or skills
