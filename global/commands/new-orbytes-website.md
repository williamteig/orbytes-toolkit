# /new-orbytes-website — Onboard a new orbytes website client

This command orchestrates the full client onboarding flow for a new orbytes website project. It runs three steps in sequence, tracking progress so you can resume if interrupted.

## Onboarding steps

| Step | Skill | What it does | Output |
|------|-------|--------------|--------|
| 1 | `orbytes-qualify` | Client qualification interview | `qualification-summary.md` |
| 2 | `orbytes-scaffold` | Create project directory, Obsidian vault, config, git repo | Project directory with `.obsidian/`, `project.md`, `brand.md`, `CLAUDE.md`, etc. |
| 3 | `orbytes-discovery` | Process discovery questionnaire responses | `discovery-brief.md` |

## How to run

Work through each step in order. After completing each step, print a status update showing which steps are done:

```
Onboarding: [Client Name]
  [x] Step 1 — Qualify
  [ ] Step 2 — Scaffold
  [ ] Step 3 — Discovery
```

### Step 1 — Qualify

Invoke the `orbytes-qualify` skill. Walk through the qualification checklist interactively. When complete, hold the qualification summary — the project directory doesn't exist yet.

If the qualification reveals the client is **not ready** (e.g. needs branding first, no copy, major blockers), flag this clearly. Ask whether to proceed to scaffold anyway (the project directory is still useful for tracking) or pause onboarding.

### Step 2 — Scaffold

Invoke the `orbytes-scaffold` skill. Pass forward all context gathered during qualification (client name, package, branding status, etc.) so the scaffold skill doesn't re-ask those questions.

The scaffold step will:
- Create the project directory with Obsidian vault (`.obsidian/`)
- Generate `project.md`, `brand.md`, `CLAUDE.md`
- Save `qualification-summary.md` into the project directory
- Set up stack-specific files
- Init git and create GitHub repo

After scaffold completes, remind the user: **"Open this folder as a vault in Obsidian (File → Open Vault → Open folder as vault)"**

### Step 3 — Discovery

Invoke the `orbytes-discovery` skill. This step processes the client's completed discovery questionnaire.

**Important:** Discovery is asynchronous — the client fills out the questionnaire on their own time (days, not minutes). If responses aren't available yet:
- Print the status showing Steps 1-2 complete, Step 3 pending
- Tell the user: "Run `/orbytes-discovery` in this project once the client submits their questionnaire responses"
- End the command — don't block waiting

If responses ARE available (pasted, emailed, or already in the project directory), proceed with analysis and generate `discovery-brief.md`.

## Resuming

If the user runs `/new-orbytes-website` and a project directory already exists for this client:
- Check which output files exist (`qualification-summary.md`, `project.md`, `discovery-brief.md`)
- Show the status checklist
- Resume from the next incomplete step

## After onboarding

When all three steps are complete, print the final status and next steps:

```
Onboarding complete: [Client Name]
  [x] Step 1 — Qualify
  [x] Step 2 — Scaffold
  [x] Step 3 — Discovery

Next steps:
  1. Open project folder as Obsidian vault
  2. Review discovery-brief.md
  3. Begin Stage 1 — Research (or Stage X — Branding if Softriver add-on)
```
