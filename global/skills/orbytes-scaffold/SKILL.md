---
name: orbytes-scaffold
description: Scaffold a new orbytes client web project with the correct stack, directory structure, Obsidian vault, and configuration. Use when starting a new build, setting up a project, or the user says "scaffold" a client site.
---

Scaffold a new orbytes client project. You may receive context from a prior qualification step — use any provided answers (client name, package, stack, branding status) to skip questions that are already answered.

For any decisions not yet made, ask one at a time:

1. **Client name** — used for directory naming and config
2. **Stack choice:**
   - **Framer** — primary stack. Visual builder + built-in CMS.
   - **Astro + CloudCannon** — for code-heavy builds needing full codebase + Git-based CMS. Scaffolded from `CloudCannon/astro-component-starter` (official starter, three-file component pattern) with CloudCannon agent-skills installed per-project.
3. **Service tier** — Landing Page (single page, fixed price) or Full Website (multi-page with CMS, fixed price)
4. **Branding** — Outsourced to Softriver (default) / Client providing / Brand already exists / No branding needed
5. **Figma file URL** *(optional)* — paste URL or "not yet" (Figma is used on-request for mockups, not foundational)
6. **Framer project URL** *(Framer only)* — paste URL or "not yet"
7. **CloudCannon hosting mode** *(Astro only)* — CloudCannon-built (default — visual preview in the editor) / Headless + Cloudflare Pages (when the client prioritises an existing Cloudflare deploy pipeline over visual preview)

Then scaffold the project in `/Users/williamteig/Documents/AppDev/`:

## All stacks — core setup

1. **Create the project directory** using the client name (kebab-case)

2. **Set up Cursor IDE config** — copy the template from `$ORBYTES_TOOLKIT_PATH/website/templates/cursor/` into `.cursor/`:
   ```
   .cursor/
   ├── hooks.json                        # afterFileEdit hook config
   ├── hooks/
   │   └── post_claude_edit.sh           # mirrors CLAUDE.md → rules/project-context.mdc
   ├── mcp.json                          # empty — add project MCPs here if needed
   ├── rules/
   │   ├── project-context.mdc           # auto-mirror of CLAUDE.md (populated in step 7/11)
   │   └── memory-bridge.mdc             # pointer to Claude Code memory
   └── settings.json                     # enables notion + figma plugins
   ```
   Make `post_claude_edit.sh` executable:
   ```bash
   chmod +x .cursor/hooks/post_claude_edit.sh
   ```

3. **Create Obsidian vault** — add a `.obsidian/` folder with these defaults:
   ```
   .obsidian/
   ├── app.json          # {"showFrontmatter": true, "defaultViewMode": "preview"}
   ├── appearance.json    # {"baseFontSize": 16, "theme": "obsidian"}
   └── core-plugins.json  # ["file-explorer", "search", "tag-pane", "page-preview", "templates"]
   ```
   This makes the project directory openable as an Obsidian vault.

4. **Create `changelog/`** directory with an initial entry `changelog/YYYY-MM-DD-initial-scaffold.md` documenting the scaffold (use today's date).

5. **Create knowledge base directories:**
   ```
   raw/
   ├── comms/          # Slack exports, emails, voice note transcripts
   ├── docs/           # Brand guides, word docs, PDFs
   └── feedback/       # Revision requests, review notes
   knowledge/
   ├── index.md        # Knowledge index (seeded from template below)
   └── entries/        # Individual processed entries
   discovery/
   ├── current-site/   # Mirror of client's existing site + notes.md with their walkthrough
   │   └── .gitkeep
   └── inspirational-material/
       ├── index.md
       └── raw/
   ```

   Seed `knowledge/index.md` with:
   ```markdown
   ---
   title: Knowledge Index
   updated: {{DATE}}
   total_entries: 0
   ---

   # Knowledge Index

   All ingested client knowledge for this project, newest first.

   ## Recent Entries

   (no entries yet — run `/orbytes-ingest` to process client input)

   ## By Type

   ### Comms

   ### Docs

   ### Feedback

   ## Unresolved Contradictions

   (none)

   ## Unresolved Questions

   (none)
   ```

   If directories already exist (migrating an existing project), skip creation.

6. **Generate `project.md`** from the template at `$ORBYTES_TOOLKIT_PATH/website/templates/project.md`:
   - Replace all `{{PLACEHOLDERS}}` with gathered values
   - Set `stage: x-branding` if branding is outsourced, otherwise `1-research`
   - Set `stack:` to the chosen stack
   - Set `figma_url:`, `framer_url:` as applicable
   - Remove the branding stage section if "No branding needed"

7. **Generate `brand.md`** from the template at `$ORBYTES_TOOLKIT_PATH/website/templates/brand.md`:
   - Replace `{{CLIENT_NAME}}` and `{{BRANDING_SOURCE}}`
   - Set `{{DATE}}` to today's date

8. **Save qualification summary** — If a `qualification-summary.md` was generated in a prior step (or passed as context), save it into the project directory.

## Framer stack

9. **Copy Framer template** from `$ORBYTES_TOOLKIT_PATH/website/templates/framer/`:
   - `CLAUDE.md` — replace `{{PROJECT_NAME}}` with the repo name
   - `.gitignore`
   - `README.md` — replace `{{CLIENT_NAME}}`, `{{FRAMER_URL}}`, `{{LIVE_URL}}`

10. **Create directory structure:**
    ```
    src/
    ├── scripts/        # Custom JS for CDN delivery (if needed)
    └── styles/         # Custom CSS for CDN delivery (if needed)
    ```

11. **Populate `.cursor/rules/project-context.mdc`** from the project's `CLAUDE.md` (now that CLAUDE.md exists):
    ```bash
    { echo "---"; echo "description: Auto-mirror of this project's CLAUDE.md. Do not hand-edit."; echo "alwaysApply: true"; echo "---"; echo; cat CLAUDE.md; } > .cursor/rules/project-context.mdc
    ```

## Astro + CloudCannon stack

> **Important:** Do not run the generic "core setup" steps 1-8 in the project directory before this. The Astro scaffold creates the project directory itself via `npx create-astro-component-starter`. The vault overlay in step 11 below replaces the Obsidian/knowledge/raw/changelog setup from core steps 3-5.

9. **Scaffold via the Component Starter** (CloudCannon's official, April 2026 canonical):
   ```bash
   cd /Users/williamteig/Documents/AppDev
   npx create-astro-component-starter <project-name> --yes
   ```
   This:
   - Clones `CloudCannon/astro-component-starter`
   - Installs npm dependencies
   - Configures a git `upstream` remote pointing at the template (for future template pulls)
   - Leaves the template's commit history on `main` — orbytes overlay commits on top of it

   The starter ships with:
   - 40+ components across `src/components/building-blocks/`, `page-sections/`, `navigation/`
   - Three-file component pattern: `Component.astro` + `component.cloudcannon.inputs.yml` + `component.cloudcannon.structure-value.yml`
   - `cloudcannon.config.yml` pre-populated
   - Content collections for pages and blog (`src/content/`)
   - Design tokens in `src/styles/variables/` (colours, fonts, spacing, widths) + themes in `src/styles/themes/`
   - Component docs at `/component-docs/` (dev-only visual component builder)
   - Fonts pipeline via `site-fonts.mjs`
   - `.prettierrc`, `.stylelintrc.json`, ESLint config

   **Do not rebuild these** — apply client brand and content in place.

10. **Install CloudCannon agent-skills** (per-project — not global):
    ```bash
    cd <project-name>
    npx -y skills add CloudCannon/agent-skills -y
    ```
    Installs 5 skills into `.agents/skills/` and symlinks them into `.claude/skills/` and `.windsurf/skills/`.

    Also symlink into `.cursor/skills/` (not done by the CloudCannon installer):
    ```bash
    mkdir -p .cursor/skills
    for d in .agents/skills/*/; do ln -s "../../$d" ".cursor/skills/$(basename $d)"; done
    ```

    Immediately remove `brainstorming` — orbytes has better coverage via `shape`, `critique`, `impeccable`:
    ```bash
    rm -rf .agents/skills/brainstorming .claude/skills/brainstorming .windsurf/skills/brainstorming .cursor/skills/brainstorming
    ```
    Then edit `skills-lock.json` and remove the `brainstorming` entry from the `skills` object so `skills update` doesn't reinstall it.

11. **Overlay orbytes vault** on top of the Starter (do NOT replace the Starter's `src/`):
    - Create `.obsidian/` with:
      - `app.json` → `{"showFrontmatter": true, "defaultViewMode": "preview"}`
      - `appearance.json` → `{"baseFontSize": 16, "theme": "obsidian"}`
      - `core-plugins.json` → `["file-explorer", "search", "tag-pane", "page-preview", "templates"]`
    - Generate `project.md` from `$ORBYTES_TOOLKIT_PATH/website/templates/project.md` (placeholders filled)
    - Generate `brand.md` from `$ORBYTES_TOOLKIT_PATH/website/templates/brand.md` (placeholders filled)
    - Create `knowledge/index.md` (seeded from the snippet in core step 5) + `knowledge/entries/.gitkeep`
    - Create `raw/comms/.gitkeep`, `raw/docs/.gitkeep`, `raw/feedback/.gitkeep`
    - Create `discovery/current-site/.gitkeep`, `discovery/inspirational-material/index.md`, `discovery/inspirational-material/raw/.gitkeep`
    - Create `changelog/YYYY-MM-DD-initial-scaffold.md`
    - Copy `.cursor/` template from `$ORBYTES_TOOLKIT_PATH/website/templates/cursor/` (same as core step 2), then also symlink the `.agents/skills/` into `.cursor/skills/` (done in step 10)
    - Append to the Starter's `.gitignore`:
      ```
      # Obsidian workspace state (user-specific, not project config)
      .obsidian/workspace*.json
      .obsidian/cache
      .obsidian/graph.json
      ```

12. **Merge `CLAUDE.md`** — combine `$ORBYTES_TOOLKIT_PATH/global/CLAUDE.md` and `$ORBYTES_TOOLKIT_PATH/website/CLAUDE.md` into a project `CLAUDE.md`. Fill in the "Record for this project" section with stack=astro, CMS=cloudcannon, hosting=(chosen mode from step 7). Then populate `.cursor/rules/project-context.mdc`:
    ```bash
    { echo "---"; echo "description: Auto-mirror of this project's CLAUDE.md. Do not hand-edit."; echo "alwaysApply: true"; echo "---"; echo; cat CLAUDE.md; } > .cursor/rules/project-context.mdc
    ```

13. **Run `npm audit fix`** to clean up non-breaking vulnerabilities from transitive deps. Do NOT use `--force`. Record the residual count in the initial-scaffold changelog entry.

14. **Apply client brand tokens** to `src/styles/variables/` (colours, typography, spacing) from `brand.md`. If the brand uses custom fonts, update `site-fonts.mjs`.

15. **Verify build:**
    ```bash
    npm run build
    ```
    Starter demo content will still build — content migration happens after the initial commit.

## Initialize and create GitHub repo

**Framer stack:** git hasn't been initialised yet — run:
```bash
git init && git add -A && git commit -m "Initial scaffold via orbytes-toolkit"
```

**Astro stack:** git is already initialised by `create-astro-component-starter` (with the template's upstream history). Commit the orbytes overlay as a second commit on top:
```bash
git add -A && git commit -m "chore: overlay orbytes vault and install CloudCannon agent-skills"
```

Then (both stacks):

1. Create private GitHub repo and push:
   ```bash
   gh repo create williamteig/<project-name> --private --source=. --push
   ```
   **Gotcha (Astro stack):** the Component Starter ships with `.github/workflows/test.yml`, which requires the `workflow` OAuth scope. If push fails with "refusing to allow an OAuth App to create or update workflow ... without `workflow` scope", have the user run:
   ```bash
   gh auth refresh -h github.com -s workflow
   ```
   then retry the push.

2. Update `project.md` frontmatter with `github_url`.
3. Print summary: file tree, project links, and next steps.
4. Remind: "Open this folder as a vault in Obsidian (File → Open Vault → Open folder as vault)".
5. Mention: "Use `/orbytes-ingest` to process client input as it arrives. Use `/orbytes-query` to search the knowledge base."

## Bridge 2nd Brain context (final step, all stacks)

Once the repo is pushed and `project.md` is up to date, **invoke `orbytes-context-bridge`** to pull relevant context from Williams 2nd Brain into this project. This is mandatory — every new project gets a `context-bridge.md` before development begins, so the next session starts with the right context loaded.

The bridge skill runs its own questionnaire (Phase 1) — ask Will what he already knows that's relevant, then search the 2nd Brain (Phase 2), then write `context-bridge.md` to the project root (Phase 3).

If Will explicitly says "skip the bridge for now" — write a stub `context-bridge.md` with `status: pending-input` so the file exists and the first-session protocol doesn't re-prompt next time, but the work is flagged as not done.

## CloudCannon site connection (Astro stack only)

**Do this AFTER the first push.** CloudCannon's dashboard setup requires a branch to already exist in the GitHub repo — it cannot create a site against an unpushed repo. Don't reverse the order.

1. Confirm the repo was pushed successfully (the user sees it at `https://github.com/williamteig/<project-name>`).
2. Prompt the user to create the site in the CloudCannon dashboard (`app.cloudcannon.com`), pointing at the `main` branch (or `staging` if the project uses a branch-preview workflow — see `cloudcannon.md`).
3. Once the site is connected, update `project.md` frontmatter with the CloudCannon site URL and record the branch it tracks.

## Toolkit source

- `project.md`, `brand.md` templates live at `$ORBYTES_TOOLKIT_PATH/website/templates/`
- Global rules live at `$ORBYTES_TOOLKIT_PATH/global/`
- **Framer stack** templates live at `$ORBYTES_TOOLKIT_PATH/website/templates/framer/`
- **Astro stack** has no local template — the canonical source is `CloudCannon/astro-component-starter`, fetched at scaffold time via `npx create-astro-component-starter`. This keeps the orbytes Astro stack continuously up-to-date with CloudCannon's latest componentry without maintaining a fork.

If `ORBYTES_TOOLKIT_PATH` is not set, check `/Users/williamteig/Documents/AppDev/orbytes-toolkit`.
