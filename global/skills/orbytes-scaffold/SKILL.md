---
name: orbytes-scaffold
description: Scaffold a new orbytes client web project with the correct stack, directory structure, Obsidian vault, and configuration. Use when starting a new build, setting up a project, or the user says "scaffold" a client site.
---

Scaffold a new orbytes client project. You may receive context from a prior qualification step — use any provided answers (client name, package, stack, branding status) to skip questions that are already answered.

For any decisions not yet made, ask one at a time:

1. **Client name** — used for directory naming and config
2. **Stack choice:**
   - **Framer** — primary stack. Visual builder + built-in CMS.
   - **Astro + CloudCannon CMS** — for complex/custom builds needing full codebase + Git-based CMS
3. **Service tier** — Landing Page (single page, fixed price) or Full Website (multi-page with CMS, fixed price)
4. **Branding** — Outsourced to Softriver (default) / Client providing / Brand already exists / No branding needed
5. **Figma file URL** *(optional)* — paste URL or "not yet" (Figma is used on-request for mockups, not foundational)
6. **Framer project URL** *(Framer only)* — paste URL or "not yet"
7. **Deployment target** *(Astro only)* — Vercel (recommended) / Cloudflare Pages / Netlify
8. **Additional integrations** *(Astro only)* — CloudCannon CMS, Blog, Contact form, Analytics, None

Then scaffold the project in `/Users/williamteig/Documents/AppDev/`:

## All stacks — core setup

1. **Create the project directory** using the client name (kebab-case)

2. **Create Obsidian vault** — add a `.obsidian/` folder with these defaults:
   ```
   .obsidian/
   ├── app.json          # {"showFrontmatter": true, "defaultViewMode": "preview"}
   ├── appearance.json    # {"baseFontSize": 16, "theme": "obsidian"}
   └── core-plugins.json  # ["file-explorer", "search", "tag-pane", "page-preview", "templates"]
   ```
   This makes the project directory openable as an Obsidian vault.

3. **Create `changelog/`** directory with an initial entry `changelog/YYYY-MM-DD-initial-scaffold.md` documenting the scaffold (use today's date).

4. **Generate `project.md`** from the template at `$ORBYTES_TOOLKIT_PATH/website/templates/project.md`:
   - Replace all `{{PLACEHOLDERS}}` with gathered values
   - Set `stage: x-branding` if branding is outsourced, otherwise `1-research`
   - Set `stack:` to the chosen stack
   - Set `figma_url:`, `framer_url:` as applicable
   - Remove the branding stage section if "No branding needed"

5. **Generate `brand.md`** from the template at `$ORBYTES_TOOLKIT_PATH/website/templates/brand.md`:
   - Replace `{{CLIENT_NAME}}` and `{{BRANDING_SOURCE}}`
   - Set `{{DATE}}` to today's date

6. **Save qualification summary** — If a `qualification-summary.md` was generated in a prior step (or passed as context), save it into the project directory.

## Framer stack

7. **Copy Framer template** from `$ORBYTES_TOOLKIT_PATH/website/templates/framer/`:
   - `CLAUDE.md` — replace `{{PROJECT_NAME}}` with the repo name
   - `.gitignore`
   - `README.md` — replace `{{CLIENT_NAME}}`, `{{FRAMER_URL}}`, `{{LIVE_URL}}`

8. **Create directory structure:**
   ```
   src/
   ├── scripts/        # Custom JS for CDN delivery (if needed)
   └── styles/         # Custom CSS for CDN delivery (if needed)
   ```

## Astro stack

7. **Copy `CLAUDE.md`** — Merge `$ORBYTES_TOOLKIT_PATH/global/CLAUDE.md` and `$ORBYTES_TOOLKIT_PATH/website/CLAUDE.md` into a single project `CLAUDE.md`. Fill in the "Record for this project" section with the chosen stack/CMS/deploy.

8. **Copy Astro templates** from `$ORBYTES_TOOLKIT_PATH/website/templates/astro/`:
   - `package.json` (replace `{{PROJECT_NAME}}`)
   - `astro.config.mjs`
   - `tsconfig.json`
   - `src/layouts/BaseLayout.astro`
   - `src/pages/index.astro`

9. **Create directory structure:**
   ```
   src/
   ├── components/
   │   ├── ui/
   │   ├── sections/
   │   └── layout/
   ├── layouts/
   ├── pages/
   ├── content/
   ├── styles/
   ├── assets/
   └── lib/
   ```

10. **Apply integrations** based on answers:
    - CloudCannon → add `cloudcannon.config.yml` placeholder
    - Blog → create `src/content/config.ts` with blog collection
    - Contact form → create `src/components/sections/ContactForm.astro` placeholder
    - Analytics → add snippet to `BaseLayout.astro`

11. **Create supporting files:** `.prettierrc`, `README.md`, `.env.example`

12. **Install and verify:** `npm install && npm run build`

## Initialize and create GitHub repo

1. Initialize git: `git init && git add -A && git commit -m "Initial scaffold via orbytes-toolkit"`
2. Create private GitHub repo:
   ```bash
   gh repo create williamteig/<project-name> --private --source=. --push
   ```
3. Update `project.md` frontmatter with `github_url`
4. Print summary: file tree, project links, and next steps
5. Remind: "Open this folder as a vault in Obsidian (File → Open Vault → Open folder as vault)"

## Toolkit source

Template files are in the orbytes-toolkit repository. The install script sets `ORBYTES_TOOLKIT_PATH` pointing to the repo location. Read templates from `$ORBYTES_TOOLKIT_PATH/website/templates/` and global files from `$ORBYTES_TOOLKIT_PATH/global/`.

If `ORBYTES_TOOLKIT_PATH` is not set, check `/Users/williamteig/Documents/AppDev/orbytes-toolkit`.
