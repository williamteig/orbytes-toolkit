# /new-orbytes-app — Scaffold a new orbytes app project

The user wants to create a new orbytes app (Custom Build) client project. Walk them through the interactive onboarding, then scaffold the project.

## Step 1 — Gather project details

Ask the following questions interactively:

**Question 1: Client/project name**
- "What's the client/project name?" (free text)

**Question 2: Frontend framework**
- Next.js (React) (Recommended)
- SvelteKit
- React Native (mobile app)
- None / API only

**Question 3: Backend**
- Supabase (Recommended — auth, database, storage out of the box)
- Cloudflare Workers + D1
- Node.js (Express/Fastify)
- Python (FastAPI)
- None / frontend only

**Question 4: Additional features**
(Allow multiple selections)
- Authentication (email + social login)
- File uploads / storage
- Real-time / websockets
- Scheduled jobs / cron
- Email notifications (Resend/Postmark)
- Payments (Stripe)
- None of the above

**Question 5: Notion project page**
- "What's the Notion project page URL for this client?"
- Allow free text (paste URL) or offer: "Should I search Notion for the client?" — if yes, use `notion-search` with the client name to find it

**Question 6: Figma file**
- "Do you have a Figma file URL for this project?"
  - Yes → paste URL
  - Not yet — I'll create one manually later
  - N/A
- **Gotcha:** If the URL contains query params like `?node-id=...&p=...&t=...`, strip them. Only store the base URL up to the file name slug (e.g. `https://www.figma.com/design/{fileKey}/{fileName}`).

## Step 2 — Scaffold the project

Once you have the answers, create the project:

1. **Create the project directory** using the client name (kebab-case)

2. **Copy global layer:**
   - Copy the global `CLAUDE.md` into the project root as `CLAUDE.md`
   - Copy global skills into `.claude/skills/`

3. **Copy app layer:**
   - Merge the app `CLAUDE.md` content into the project's `CLAUDE.md`
   - Write a `stack.md` file documenting the chosen stack and rationale

4. **Initialize the framework:**
   - If **Next.js**: run `npx create-next-app@latest` with TypeScript, Tailwind, App Router, src directory
   - If **SvelteKit**: run `npx sv create` with TypeScript
   - If **React Native**: run `npx create-expo-app` with TypeScript template
   - If **API only**: create a minimal Node/Python project structure

5. **Set up the backend:**
   - If **Supabase**: create `src/lib/supabase.ts` client, add `.env.example` with `SUPABASE_URL` and `SUPABASE_ANON_KEY`
   - If **Cloudflare Workers**: create `wrangler.toml` and worker entry point
   - If **Express/Fastify**: create `src/server/` with routes, middleware, and config
   - If **FastAPI**: create `src/api/` with main.py, routers, and requirements.txt

6. **Apply feature customizations:**
   - If **Authentication**: scaffold auth pages/components and middleware
   - If **File uploads**: create upload utility and storage configuration
   - If **Real-time**: add websocket setup or Supabase realtime subscription helpers
   - If **Scheduled jobs**: add cron configuration (Cloudflare Cron Triggers or equivalent)
   - If **Email**: create email service wrapper with templates
   - If **Payments**: create Stripe webhook handler and checkout utility

7. **Create supporting files:**
   - `.gitignore` (framework defaults + `.env`)
   - `.env.example` with all needed environment variables
   - `README.md` with project name, stack overview, and setup instructions
   - `docker-compose.yml` if local services are needed (database, etc.)

8. **Add Project Links to CLAUDE.md** — Append a `## Project Links` section to the project's `CLAUDE.md` with all known URLs:
   ```markdown
   ## Project Links
   - **Notion:** <notion-url or "TBD">
   - **GitHub:** https://github.com/williamteig/<project-name>
   - **Figma:** <figma-url or "TBD — create manually" or "N/A">
   ```

9. **Create a Notion task** — Add initial task to the Dev Pipeline:
   - Task: "Project setup: {{CLIENT_NAME}} app"
   - Type: Chore
   - Priority: High
   - Status: In progress

## Step 3 — Initialize, create GitHub repo, and link

1. Install dependencies
2. Verify the project builds/starts
3. Initialize git: `git init && git add -A && git commit -m "Initial scaffold via orbytes-claude-toolkit"`
4. **Create private GitHub repo** under your personal account:
   ```bash
   gh repo create williamteig/<project-name> --private --source=. --push
   ```
5. **Update Notion client record** — Set the following fields on the client's Notion project page:
   - `Github URL` → the new repo URL (`https://github.com/williamteig/<project-name>`)
   - `Figma URL` → the provided Figma URL (if one was given)
   Use `notion-update-page` with the `update_properties` command.
6. Print a summary: chosen stack, file tree, project links, environment variables needed, and next steps
7. **If any links were "not yet" or "TBD"**, print a manual steps reminder:
   ```
   Manual steps remaining:
   - [ ] Create Figma file and add URL to Notion (Figma URL field)
   - [ ] Update the Project Links section in this project's CLAUDE.md

   Once added to Notion, run /orbytes-context-sync to pull the links into your session.
   ```

## Toolkit source

Read global files from `$ORBYTES_TOOLKIT_PATH/global/` and app files from `$ORBYTES_TOOLKIT_PATH/app/`. If `ORBYTES_TOOLKIT_PATH` is not set, ask the user where they cloned the toolkit repo.
