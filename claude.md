# orbytes-toolkit — Project Instructions

You are helping Will build and maintain the **orbytes-toolkit**, a centralized configuration repo that standardizes how AI coding assistants work across all orbytes.io client projects — **Claude Code** and **Cursor** (multi-LLM).

## What this project is

A GitHub repo (`williamteig/orbytes-toolkit`) cloned at `/Users/williamteig/Documents/AppDev/orbytes-toolkit`. It contains two layers of project configuration — global and website — plus a slash command that scaffolds new projects.

- **`./install.sh`** (default `--target claude`) symlinks into **`~/.claude/`** so updates to this repo propagate instantly for Claude Code.
- Use `./install.sh --target cursor` or `./install.sh --target all` to also symlink into **`~/.cursor/`** (commands, rules as `.mdc`, skills).
- The committed **`.cursor/`** directory mirrors `global/` via symlinks so Cursor Cloud Agents and repo-local sessions load rules and commands in-repo.

## Architecture

```
orbytes-toolkit/
├── CLAUDE.md                  # This file — repo-level project instructions
├── README.md                  # Repo readme
├── install.sh                 # --target claude | cursor | all
├── uninstall.sh               # Removes symlinks
├── .gitignore
├── global/                    # Symlinked globally — applies to every session
│   ├── CLAUDE.md              # Orbytes identity, tools, pointers to rules + skills
│   ├── commands/              # Slash commands (/new-orbytes-website)
│   ├── rules/                 # Topic-based rules
│   ├── hooks/                 # Claude Code hook scripts
│   └── skills/                # Invocable skill modules
├── website/                   # Copied into new website projects during scaffolding
│   ├── CLAUDE.md              # Website project conventions (stack-agnostic wrapper)
│   ├── stacks.md              # Documents all website-tier stacks
│   └── templates/
│       ├── project.md         # Client project.md template (Obsidian)
│       ├── brand.md           # Brand kit template
│       ├── astro/             # Astro + Tailwind starter files
│       └── framer/            # Framer project starter files (TODO)
└── .cursor/                   # Committed symlinks for Cursor parity
```

## How it works

- **Global layer** lives in `~/.claude/` (and optionally `~/.cursor/`) via symlinks. Applies to every session. Editing files under `global/` updates everything once symlinked.
- **Website layer** is copied into each project during scaffolding via `/new-orbytes-website`. Becomes project-local and can be customized per client.
- **Commands** are prompt templates invoked via slash commands. They receive `$ARGUMENTS` and run inline.
- **Skills** are invocable modules with frontmatter. Claude/Cursor can trigger them based on context, or the user invokes them directly.

## orbytes context

- **orbytes.io** is a boutique web design studio run by Will Teig (william@orbytes.io)
- **Service tiers:** Landing Page (fixed price), Full Website (fixed price), Custom Build (enterprise)
- **Website stacks:** Framer (primary for new work), Astro + CloudCannon (code-heavy projects), Webflow (legacy/selective)
- **Tools:** Obsidian (project management via markdown), GitHub (version control), Cloudflare/Vercel (deploy), Softriver (whitelabel branding partner)
- **Design tools (on request, not foundational):** Figma, Paper.design — used for mockups and graphics when needed, not required for every project
- **Pipeline:** Stage X Branding (optional) → Stage 1 Research → Stage 2 Content (Gate 1) → Stage 3 Design (Gate 2) → Stage 4 Development (Gate 3) → Stage 5 Launch
- **Key rules:** Three approval gates only. `project.md` is always the source of truth. Branding is always whitelabeled. Never skip stages.

## The /new-orbytes-website command

Scaffolds a new website project:
1. **Qualify** — Walk through client readiness checklist
2. **Scaffold** — Create project directory, Obsidian vault, project.md, brand.md, stack-specific files, git repo
3. **Discovery** — Process questionnaire responses (if available, otherwise run later)

## How to work on this project

- Edit files directly in `/Users/williamteig/Documents/AppDev/orbytes-toolkit`
- Changes to `global/` take effect immediately everywhere symlinked
- Changes to `website/` only affect newly scaffolded projects
- The install script is idempotent — safe to re-run after adding new files

## Gotchas

- **Adding a new category** (e.g. `global/templates/`) requires updating both `install.sh` and `uninstall.sh`.
- **Cursor parity**: when adding a new global rule/command/skill, add the matching symlink under `.cursor/` too.
- **Empty directories** are invisible to git — always put a file in new directories.
- **Wrong layer**: `global/` is symlinked everywhere; `website/` is copied at scaffold time. Place files at the right scope.
- **macOS Finder** can create stray folders with spaces — check before committing.
