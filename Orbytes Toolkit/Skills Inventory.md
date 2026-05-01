# Skills Inventory

Master list of every skill available in the orbytes toolkit — both custom-built and third-party.

---

## Custom Skills (orbytes-toolkit)

Skills built by Will, defined in `global/skills/`. Symlinked globally via `install.sh`.

| Skill | Location | Trigger |
|-------|----------|---------|
| **orbytes-context-sync** | `global/skills/orbytes-context-sync/` | Load fresh context before starting work on any client project |
| **orbytes-workflow-sync** | `global/skills/orbytes-workflow-sync/` | Any change to the core workflow structure (stages, gates, tools) |
| **orbytes-qualify** | `~/.claude/skills/orbytes-qualify/` | Qualify a prospective client (package fit, readiness, scope) |
| **orbytes-scaffold** | `~/.claude/skills/orbytes-scaffold/` | Scaffold a new client web project |
| **orbytes-discovery** | `~/.claude/skills/orbytes-discovery/` | Process client discovery questionnaire responses |

### Custom Commands

| Command | Location | What it does |
|---------|----------|-------------|
| **/new-orbytes-website** | `global/commands/new-orbytes-website.md` | Interactive onboarding → scaffold a website project |
| **/new-app** | `~/.claude/commands/new-app.md` | Scaffold a new app project |

---

## Third-Party Skills — Installed Plugins

Managed via Claude Code plugin system. Configured in `~/.claude/settings.json`.

### Official Anthropic Plugins (`claude-plugins-official`)

| Plugin | Skills included | What it does |
|--------|----------------|-------------|
| **notion** | create-task, find, database-query, create-database-row, search, create-page, tasks:setup, tasks:build, tasks:plan, tasks:explain-diff | Full Notion workspace integration |
| **figma** | use_figma, get_design_context, get_screenshot, get_variable_defs, search_design_system, and more | Figma design context and Code Connect |
| **frontend-design** | frontend-design | Production-grade frontend UI generation with high design quality |

### Community Plugins

| Plugin | Source | Skills included | What it does |
|--------|--------|----------------|-------------|
| **andrej-karpathy-skills** | `forrestchang/andrej-karpathy-skills` | karpathy-guidelines | Behavioural guidelines to reduce common LLM coding mistakes |
| **cc-caffeine** | `samber/cc` | (tooling plugin) | Claude Code productivity utilities |

---

## Third-Party Skills — Standalone Installs

Skills installed directly from GitHub repos (not via the plugin system).

### Matt Pocock (`mattpocock/skills`)

Source: https://github.com/mattpocock/skills

| Skill | Status | What it does |
|-------|--------|-------------|
| **obsidian-vault** | Installed | Manage Obsidian vault — search notes, create notes, wikilinks, index organisation |
| **grill-me** | Installed | Intensive questioning sessions about plans/designs to resolve all decision branches |

#### Other available skills from this repo (not installed):

| Skill | What it does |
|-------|-------------|
| write-a-prd | Create a PRD through interactive interview, filed as GitHub issue |
| prd-to-plan | Transform PRD into structured implementation roadmap |
| prd-to-issues | Break PRD into discrete GitHub issues by feature slice |
| design-an-interface | Generate multiple interface design approaches via parallel sub-agents |
| request-refactor-plan | Detailed refactor plan with tiny commits via user interview |
| tdd | Test-driven development cycles (red-green-refactor) |
| triage-issue | Investigate bugs, identify root causes, document TDD repair strategies |
| improve-codebase-architecture | Analyse codebases for architectural improvements |
| setup-pre-commit | Set up Husky pre-commit hooks with lint-staged, Prettier, type checking |
| git-guardrails-claude-code | Configure hooks preventing dangerous git commands |
| write-a-skill | Create new skills with proper structure and bundled resources |
| edit-article | Improve articles through restructuring and prose refinement |
| ubiquitous-language | Extract domain-driven design glossaries from conversations |
| migrate-to-shoehorn | Convert test files to @total-typescript/shoehorn |
| scaffold-exercises | Generate exercise directory structures |

---

## Notes

- Custom skills in `global/skills/` are symlinked into `~/.claude/skills/` by `install.sh`
- Plugin skills live in `~/.claude/plugins/cache/` and are managed by the plugin system
- Standalone skills (mattpocock) need manual install/update
- To install more mattpocock skills: `claude install-skill https://github.com/mattpocock/skills/tree/main/{skill-name}`
