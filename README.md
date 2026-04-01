# orbytes-claude-toolkit

The standard Claude Code toolkit for all orbytes.io projects. Install once, update centrally, available everywhere.

## Install

```bash
cd ~/Documents/AppDev/orbytes-claude-toolkit
chmod +x install.sh
./install.sh
```

Everything is **symlinked**, not copied. The toolkit stays in one place on your machine.

## Update

```bash
cd ~/Documents/AppDev/orbytes-claude-toolkit
git pull
```

That's it. All commands, rules, and skills update across every project instantly because they're symlinks back to this repo.

## What's included

### Commands

`/task` uses the argument to decide what to do: a number fetches and executes an existing task; any other text creates a new one.

| Command | What it does |
|---------|-------------|
| `/task 13` | Reads task #13 from the Dev Pipeline, executes it, writes findings back to Notion, updates status |
| `/task Fix the mobile nav` | Creates a new task in the Dev Pipeline with interactive prompts for project, type, priority |
| `/new-orbytes-website` | Interactive onboarding → scaffolds an Astro + Tailwind project with orbytes defaults |
| `/new-orbytes-app` | Interactive onboarding → scaffolds a custom app project (Next.js, SvelteKit, etc.) |

### Global layer (applies to all projects)

- **CLAUDE.md** — orbytes identity, dev pipeline stages, approval gates, coding standards, git workflow
- **orbytes-context-sync** skill — keeps Notion, Figma, and Webflow in sync across client projects
- **orbytes-workflow-sync** skill — ensures the Notion Project Template and workflow docs stay matched

### Website layer (Astro + Tailwind)

- Website-specific CLAUDE.md rules (Astro conventions, Tailwind standards, SEO, performance targets)
- Starter templates: `package.json`, `astro.config.mjs`, `tsconfig.json`, `BaseLayout.astro`, `index.astro`

### App layer (Custom Builds)

- App-specific CLAUDE.md rules (architecture principles, security defaults, testing requirements)
- Flexible — stack is chosen during `/new-orbytes-app` onboarding

## How it works

```
~/.claude/
├── CLAUDE.md                      → symlink → toolkit/global/CLAUDE.md
├── commands/
│   ├── task.md                    → symlink → toolkit/commands/task.md
│   ├── new-orbytes-website.md     → symlink → toolkit/commands/new-orbytes-website.md
│   └── new-orbytes-app.md         → symlink → toolkit/commands/new-orbytes-app.md
└── skills/
    ├── orbytes-context-sync/      → symlink → toolkit/global/skills/orbytes-context-sync/
    └── orbytes-workflow-sync/     → symlink → toolkit/global/skills/orbytes-workflow-sync/
```
The **global layer** (CLAUDE.md, skills, commands) lives in `~/.claude/` via symlinks and applies to every Claude Code session.

When you scaffold a new project with `/new-orbytes-website` or `/new-orbytes-app`, the **type-specific layer** (website or app rules + templates) is copied into that project since it's project-specific and may be customised.

## Per-project overrides

After scaffolding, each project has its own `CLAUDE.md` in the project root. This contains the type-specific rules (website or app) and can be freely edited per project. It sits alongside the global `~/.claude/CLAUDE.md` — Claude reads both, with project-level rules taking priority.

To override a global rule for one project, just add the override to the project's `CLAUDE.md`.

## Uninstall

```bash
cd ~/Documents/AppDev/orbytes-claude-toolkit
./uninstall.sh
```

Removes all symlinks and restores any backed-up files.

## Structure

```
orbytes-claude-toolkit/
├── install.sh                 # One-time setup
├── uninstall.sh               # Clean removal
├── README.md
├── global/                    # Shared across ALL projects
│   ├── CLAUDE.md             # Global rules (symlinked to ~/.claude/)
│   └── skills/
│       ├── orbytes-context-sync/
│       └── orbytes-workflow-sync/
├── website/                   # Website project defaults
│   ├── CLAUDE.md             # Copied into new website projects
│   └── templates/            # Starter files for Astro + Tailwind
├── app/                       # App project defaults
│   └── CLAUDE.md             # Copied into new app projects
└── commands/                  # Slash commands (symlinked to ~/.claude/commands/)
    ├── task.md               # /task
    ├── new-orbytes-website.md # /new-orbytes-website
    └── new-orbytes-app.md     # /new-orbytes-app
```