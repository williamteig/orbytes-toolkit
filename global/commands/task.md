# /task — orbytes Dev Pipeline Task Manager

The user has run: `/task $ARGUMENTS`

You are working with the orbytes Dev Pipeline in Notion.

**Dev Pipeline Database ID:** `599e132701274298b902d85a529ebde5`
**Data Source:** `collection://277efdcf-8436-4503-84a6-20f3e9428ef7`

## Determine the mode

There are exactly two modes. No exceptions, no third path.

- If `$ARGUMENTS` is a number → **Mode A** (execute existing task)
- If `$ARGUMENTS` is anything else (text, phrase, sentence) → **Mode B** (create new task)

Do NOT search the pipeline, interpret the text as a request, or take any other action. Pick Mode A or Mode B and follow it.

### Mode A: Execute an existing task (argument is a number)

If `$ARGUMENTS` is a number (e.g., `13`), this is a task ID. Do the following:

1. **Fetch the task** — Query the Dev Pipeline data source for the task where `userDefined:ID` equals the number:
   ```
   SELECT * FROM "collection://277efdcf-8436-4503-84a6-20f3e9428ef7" WHERE "userDefined:ID" = <number>
   ```

2. **Read the task page** — Use `notion-fetch` on the task's URL to read the full page content, including any sub-content, checklists, or notes inside it.

3. **Check dependencies** — Read the task's `Blocked by` relation. For each linked task, fetch its page and check its `Status`.
   - If all blockers have Status "Done" → proceed normally
   - If any blocker is not "Done" → tell the user:
     *"DEV-{ID} is blocked by DEV-{blocker ID} (Status: {status}). Options: proceed anyway, switch to DEV-{blocker ID}, or skip."*
   - If the user chooses to proceed → fetch the blocker's page content and keep it as context (constraints, interfaces, decisions the blocker establishes)
   - If the user chooses to switch → restart Mode A with the blocker's ID
   - If no `Blocked by` relation is set → proceed normally

4. **Resolve the project repo** — Determine which local repo this task belongs to and ensure you're in the right place.

   **a) Check the current directory:**
   Run `git remote get-url origin 2>/dev/null` in the current working directory.

   **b) If a git remote exists (you're inside a repo):**
   - Follow the task's `Client Belonging` relation → fetch the client page from the Orbytes Clients DB (`collection://3282204c-5659-80e1-ad2b-000bdf0d92f2`) → read its `Github URL` field
   - Compare the current repo's remote to the task's expected `Github URL`
   - If they match → proceed
   - If they don't match → **STOP**: *"You're in {current repo} but this task belongs to {expected repo}. cd into the correct project first."*
   - If the task has no `Client Belonging` or the client has no `Github URL` → **STOP**: *"Cannot determine which repo this task belongs to. Set the Client Belonging relation and Github URL in Notion first."*

   **c) If no git remote exists (you're in a root/non-repo directory):**
   - Follow the `Client Belonging` → `Github URL` resolution chain as above
   - Extract the repo name from the Github URL (the last path segment, e.g. `theauditiontechnique-web` from `https://github.com/williamteig/theauditiontechnique-web`)
   - Check if `~/Documents/AppDev/{repo-name}/` exists and its `git remote get-url origin` matches the expected Github URL
   - If found → cd into that directory and proceed
   - If not found → **STOP**: *"Repo '{repo-name}' not found in ~/Documents/AppDev/. Clone it first."*

   **Note:** The `Github link` rollup field on the Dev Pipeline is for your visibility in Notion's UI only. It returns `<omitted />` via the API. Always follow the `Client Belonging` relation chain instead.

5. **Create a working branch and worktree** — Set up an isolated workspace for this task.
   - Generate the branch name: `dev-{ID}-{short-description}` (e.g. `dev-14-tailwind-cleanup`). Use lowercase, hyphens only — no slashes.
   - Create a git worktree: `git worktree add .claude/worktrees/dev-{ID}-{short-description} -b dev-{ID}-{short-description}`
   - cd into the worktree directory
   - Update the task's `Branch` property in Notion with the branch name
   - Update the task's `Status` to "In progress"

6. **Understand what's being asked** — The task title + notes + page content describe what needs to be done. Interpret the task in the context of the orbytes workflow:
   - If it's a **Feature** or **Bug** — this likely involves writing or modifying code
   - If it's **Research** — investigate and write up findings
   - If it's **Docs** — write or update documentation
   - If it's **Chore** — infrastructure, cleanup, or process work

7. **Execute the task** — Do the work. Use all tools available to you (file editing, code execution, web search, Notion, Figma, Webflow MCPs as needed). Be thorough.

8. **Write findings back to Notion** — Update the task's Notion page with your deliverables:
   - Use `notion-update-page` to write your findings, output, or summary into the page content
   - Be structured: use headings, bullet points, code blocks as appropriate
   - If you created files, mention their paths and purpose
   - Include any relevant links, screenshots, or references

9. **Update task status** — Move the task to the appropriate status:
   - If fully complete → set Status to "Done"
   - If blocked or needs review → keep as "In progress" and add a note explaining what's needed
   - Update any other relevant properties (Notes if needed)

10. **Check for unblocked tasks** — After completing the task, check the `Blocking` relation. If this task is blocking other tasks, mention them: *"DEV-{ID} is now unblocked and ready to pick up."*

11. **Report back** — Give the user a concise summary of what you did and what's now in the Notion page.

### Mode B: Create a new task (argument is a description)

If `$ARGUMENTS` is text (not a number), this is a new task description. Do the following:

1. **Parse the description** — Extract the task intent from the text.

2. **Resolve the project** — Determine which client this task belongs to. Do NOT use a hardcoded list of project names.

   **a) Check the current directory:**
   Run `git remote get-url origin 2>/dev/null` in the current working directory.

   **b) If a git remote exists (you're inside a repo):**
   - Query the Orbytes Clients DB (`collection://3282204c-5659-80e1-ad2b-000bdf0d92f2`) for a client whose `Github URL` matches the current remote.
   - If exactly one match → auto-suggest it: *"Detected project: {client name} (from current repo). Correct?"*
   - If the user confirms → use that client.
   - If the user says no → fall back to step (c).
   - If no client matches the current remote → tell the user: *"No client in Notion has Github URL matching {remote}."* Then fall back to step (c) and also offer to link the current repo to a client.

   **c) If no remote, no match, or user rejected the auto-detect:**
   - Fetch all clients from the Orbytes Clients DB and present them as selectable options.
   - Never hardcode project names — always query Notion dynamically.

   **d) After selecting a client, check its `Github URL`:**
   - If the client has no `Github URL` and you're in a git repo, ask for explicit consent before linking: *"{client name} has no Github URL linked. Would you like me to set it to {current remote}?"*
   - Only update the client's `Github URL` field in Notion if the user explicitly confirms. Never auto-fill this field.
   - If the user declines → proceed with task creation anyway, but warn that Mode A (executing the task) will fail without a linked repo.

3. **Ask remaining clarifying questions** — Use interactive prompts to confirm:
   - **Type**: What kind of task? (Feature / Bug / Chore / Research / Docs)
   - **Priority**: How urgent? (Critical / High / Medium / Low)
   - Optionally ask about Phase and Due date if not obvious

4. **Create the task** — Use `notion-create-pages` to create a new page in the Dev Pipeline database with:
   - Task (title): the task description, cleaned up into a clear title
   - Client Belonging: the resolved client (relation to Orbytes Clients DB)
   - Type: selected type
   - Priority: selected priority
   - Status: "Not started"
   - Notes: any additional context from the user's description
   - Phase: if provided
   - Due: if provided

5. **Confirm** — Show the user the created task with its auto-assigned ID and a link to the Notion page. Ask if they want to start working on it immediately (which would trigger Mode A behaviour).

## Important context

- The Dev Pipeline is shared across all orbytes projects. The `Client Belonging` relation determines which project a task belongs to.
- Each client project in the Orbytes Clients database can have a filtered view of this pipeline showing only their tasks.
- Task IDs are auto-incremented — you never set them manually.
- Always read the full task page content before executing, not just the database row properties.
- Branch names use hyphens only — never slashes. Format: `dev-{ID}-{short-description}` (e.g. `dev-14-tailwind-cleanup`).
- The `Blocked by` / `Blocking` relations are self-referencing on the Dev Pipeline. Use them to check dependency status before starting and to notify about unblocked tasks after finishing.
- Never guess or fuzzy-match repos. If the resolution chain is broken (missing Client Belonging, missing Github URL, missing local directory), stop and tell the user what to fix.

**Gotcha — text arguments always mean "create a new task".**
When `$ARGUMENTS` is text (not a number), always trigger Mode B. Never interpret the text as an ad-hoc request, never search the pipeline for a matching task, and never skip task creation to "just help directly." The user typed `/task` — they want a task created. If they wanted ad-hoc help they wouldn't have used the command.