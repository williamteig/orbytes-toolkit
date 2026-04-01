# /new-orbytes-website — Scaffold a new orbytes website project

The user wants to create a new orbytes website client project. Walk them through the interactive onboarding, then scaffold the project.

## Step 1 — Gather project details

Ask the following questions interactively (use AskUserQuestion or equivalent prompts):

**Question 1: Client name**
- "What's the client/project name?" (free text)

**Question 2: Notion project page** *(ask this immediately after client name — Notion is the source of truth)*
- "What's the Notion project page URL for this client?"
- Allow free text (paste URL) or offer: "Should I search Notion for the client?" — if yes, use `notion-search` with the client name to find it
- Once you have the Notion page, **fetch it immediately** using `notion-fetch` and read its properties (`Figma URL`, `Webflow URL`, `Github URL`). Store any existing values — you'll use them to pre-populate later questions and to link the local repo to Notion in Step 3.

**Question 3: Service tier**
- Landing Page — single page, fixed price
- Full Website — multi-page with CMS, fixed price

**Question 4: Deployment target**
- Vercel (Recommended)
- Cloudflare Pages
- Netlify
- Other

**Question 5: Additional integrations**
(Allow multiple selections)
- Webflow CMS (headless content from Webflow)
- Blog / Content Collections
- Contact form
- Analytics (Plausible/Fathom)
- None of the above

**Question 6: Figma file**
- If a `Figma URL` was found in Notion → confirm: *"Found Figma URL in Notion: {url}. Use this?"*
- Otherwise: "Do you have a Figma file URL for this project?"
  - Yes → paste URL
  - Not yet — I'll create one manually later
  - N/A
- **Gotcha:** If the URL contains query params like `?node-id=...&p=...&t=...`, strip them. Only store the base URL up to the file name slug (e.g. `https://www.figma.com/design/{fileKey}/{fileName}`).

**Question 7: Webflow site**
- If a `Webflow URL` was found in Notion → confirm: *"Found Webflow URL in Notion: {url}. Use this?"*
- Otherwise: "Do you have a Webflow site URL for this project?"
  - Yes → paste URL
  - Not yet — I'll set one up later
  - N/A (not using Webflow)

## Step 2 — Scaffold the project

Once you have the answers, create the project:

1. **Create the project directory** using the client name (kebab-case)

2. **Copy global layer:**
   - Copy the global `CLAUDE.md` into the project root as `CLAUDE.md`
   - Copy global skills into `.claude/skills/`

3. **Copy website layer:**
   - Merge the website `CLAUDE.md` content into the project's `CLAUDE.md` (append after global rules)
   - Copy website templates into the project root:
     - `package.json` (replace `{{PROJECT_NAME}}` with the project name)
     - `astro.config.mjs` (replace `{{SITE_URL}}` with a placeholder or provided URL)
     - `tsconfig.json`
     - `src/layouts/BaseLayout.astro` (replace `{{DEFAULT_DESCRIPTION}}`)
     - `src/pages/index.astro` (replace `{{PROJECT_NAME}}`)

4. **Create the directory structure:**
   ```
   src/
   ├── components/
   │   ├── ui/
   │   ├── sections/
   │   └── layout/
   ├── layouts/
   ├── pages/
   ├── styles/
   ├── assets/
   └── lib/
   ```

5. **Apply customizations based on answers:**
   - If **Webflow CMS** selected: add `src/lib/webflow.ts` with a placeholder API client
   - If **Blog** selected: create `src/content/config.ts` with a blog collection schema
   - If **Contact form** selected: create `src/components/sections/ContactForm.astro` placeholder
   - If **Analytics** selected: add analytics snippet to `BaseLayout.astro`

6. **Create supporting files:**
   - `.gitignore` (Astro defaults)
   - `.prettierrc` with Astro plugin config
   - `README.md` with project name and basic setup instructions
   - `.env.example` with any needed environment variables

7. **Add Project Links to CLAUDE.md** — Append a `## Project Links` section to the project's `CLAUDE.md` with all known URLs:
   ```markdown
   ## Project Links
   - **Notion:** <notion-url or "TBD">
   - **GitHub:** https://github.com/williamteig/<project-name>
   - **Figma:** <figma-url or "TBD — create manually">
   - **Webflow:** <webflow-url or "TBD" or "N/A">
   ```

8. **Create a Notion task** — Add an initial task to the Dev Pipeline:
   - Task: "Project setup: {{CLIENT_NAME}} website"
   - Type: Chore
   - Priority: High
   - Project: Ask which project tag to use, or create suggestion
   - Status: In progress

## Step 3 — Initialize, create GitHub repo, and link

1. Run `npm install` in the project directory
2. Confirm the project builds with `npm run build`
3. Initialize git: `git init && git add -A && git commit -m "Initial scaffold via orbytes-claude-toolkit"`
4. **Create private GitHub repo** under your personal account:
   ```bash
   gh repo create williamteig/<project-name> --private --source=. --push
   ```
5. **Update Notion client record** — Set the following fields on the client's Notion project page:
   - `Github URL` → the new repo URL (`https://github.com/williamteig/<project-name>`)
   - `Figma URL` → the provided Figma URL (if one was given)
   - `Webflow URL` → the provided Webflow URL (if one was given)
   Use `notion-update-page` with the `update_properties` command.
6. Print a summary of what was created, including file tree, project links, and next steps
7. **If any links were "not yet" or "TBD"**, print a manual steps reminder:
   ```
   Manual steps remaining:
   - [ ] Create Figma file and add URL to Notion (Figma URL field)
   - [ ] Set up Webflow site and add URL to Notion (Webflow URL field)
   - [ ] Update the Project Links section in this project's CLAUDE.md

   Once added to Notion, run /orbytes-context-sync to pull the links into your session.
   ```

## Toolkit source

The template files for this command are in the orbytes-claude-toolkit repository. The install script sets the `ORBYTES_TOOLKIT_PATH` environment variable pointing to where the repo is cloned. Read templates from `$ORBYTES_TOOLKIT_PATH/website/templates/` and global files from `$ORBYTES_TOOLKIT_PATH/global/`.

If `ORBYTES_TOOLKIT_PATH` is not set, ask the user where they cloned the toolkit repo.
