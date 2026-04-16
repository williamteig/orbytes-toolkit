# orbytes-toolkit

The standard AI toolkit for all orbytes.io projects. Install once, update centrally, available everywhere. Works with **Claude Code** and **Cursor** (multi-LLM).

## Install

### Claude Code (default)

```bash
cd ~/Documents/AppDev/orbytes-toolkit
chmod +x install.sh
./install.sh
```

Equivalent to `./install.sh --target claude`. Symlinks into **`~/.claude/`** only.

### Cursor

```bash
./install.sh --target cursor
```

Symlinks commands, rules (as `.mdc`), and skills into **`~/.cursor/`**.

### Both

```bash
./install.sh --target all
```

Everything installed is **symlinked**, not copied. The toolkit stays in one place.

## Update

```bash
cd ~/Documents/AppDev/orbytes-toolkit
git pull
```

All symlinked files update across projects because they point back to this repo.

## Uninstall

```bash
./uninstall.sh              # default: claude only
./uninstall.sh --target cursor
./uninstall.sh --target all
```

## What's included

### Commands

| Command | What it does |
|---------|-------------|
| `/new-orbytes-website` | Interactive onboarding → scaffolds a website project (Astro, Framer, or Webflow) |

### Global layer (applies to all projects)

- **CLAUDE.md** — orbytes identity, workflow, tools, coding standards
- **Rules** — coding, git, workflow, pipeline, Figma, Framer, Astro, Tailwind, Webflow, CloudCannon, Cloudflare
- **Skills** — orbytes-context-sync, orbytes-workflow-sync
- **Agents** — project-manager, strategy, copy, design, developer, QA (component, section, page)

### Website layer (copied into new projects)

- Website-specific CLAUDE.md (stack-agnostic wrapper)
- `stacks.md` — documents all three website stacks (Astro, Framer, Webflow)
- Templates: `project.md` (client project tracker), `brand.md` (brand kit), Astro starter files

## How it works

```
~/.claude/ (or ~/.cursor/)
├── CLAUDE.md          → symlink → toolkit/global/CLAUDE.md
├── commands/          → symlinks → toolkit/global/commands/*.md
├── rules/             → symlinks → toolkit/global/rules/*.md
├── skills/            → symlinks → toolkit/global/skills/*/
├── agents/            → symlinks → toolkit/global/agents/*.md
└── hooks/             → symlinks → toolkit/global/hooks/*.{sh,py}
```

The **global layer** applies to every session. When you scaffold with `/new-orbytes-website`, the **website layer** is **copied** into that project and becomes project-local.

## Structure

```
orbytes-toolkit/
├── CLAUDE.md              # Repo-level project instructions
├── AGENTS.md              # Agent index
├── install.sh / uninstall.sh
├── global/                # Symlinked globally
│   ├── CLAUDE.md
│   ├── agents/
│   ├── commands/
│   ├── rules/
│   ├── hooks/
│   └── skills/
├── website/               # Copied into new website projects
│   ├── CLAUDE.md
│   ├── stacks.md
│   └── templates/
│       ├── project.md     # Client project template
│       ├── brand.md       # Brand kit template
│       └── astro/         # Astro starter files
└── .cursor/               # Committed symlinks for Cursor parity
```
