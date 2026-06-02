# orbytes-seo

Opt-in SEO workflow for orbytes projects. This wraps the Agentic SEO approach into the orbytes process.

## What it does

- Runs evidence-first SEO analysis for a client project
- Produces:
  - `seo/YYYY-MM-DD-audit.md`
  - `seo/YYYY-MM-DD-action-plan.md`
- Prioritizes fixes by impact/effort
- Updates project tracking (`changelog/`, optional `project.md` follow-ups)

## When it runs

- Only when explicitly invoked:
  - You ask for SEO work, or
  - You run `/orbytes-seo`
- Never auto-runs during normal build tasks
- Default timing is post-build (Stage 4 complete / Gate 3 passed)

## Pre-build behavior

If the project is pre-build, the workflow should stop and ask:

`SEO is usually post-build. Do you want me to run an early audit anyway?`

It only proceeds if you explicitly confirm.

## How to use it (quick)

1. Open the client project repo.
2. Run `/orbytes-seo` and provide:
   - Target scope (`live`, `staging`, or specific pages)
   - Audit focus (`technical`, `content`, `schema`, `GEO/AEO`, or `full`)
3. Review `seo/*-audit.md`.
4. Execute items from `seo/*-action-plan.md` (quick wins first).

## Typical prompts

- "Run `/orbytes-seo` on production for a full sweep."
- "Run `/orbytes-seo` for technical + CWV only on staging."
- "Run `/orbytes-seo` for homepage + services page content and schema."

## How it works (internals)

1. Reads `project.md` and checks stage/gate status.
2. Confirms target and objective.
3. Collects measurable evidence.
4. Labels certainty for findings:
   - Confirmed
   - Likely
   - Hypothesis
5. Outputs audit + action plan and logs work.

## Notes

- This is intentionally process-aligned for orbytes (project-first, evidence-first).
- If a user asks for non-SEO work, this skill should not be invoked.
