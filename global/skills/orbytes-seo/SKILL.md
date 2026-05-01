---
name: orbytes-seo
description: Opt-in SEO workflow for orbytes projects. Use only when the user explicitly asks for SEO work or runs /orbytes-seo. Default timing is after build (Stage 4 complete).
---

Run SEO as an explicit, post-build workflow for orbytes client projects.

## Invocation policy (strict)

- Never run this skill automatically.
- Run only when:
  - The user explicitly asks for SEO work, or
  - The user runs `/orbytes-seo`.
- If the user request is unrelated to SEO, do not invoke this skill.

## Stage gate (default behavior)

SEO is normally done after build.

1. Read `project.md` first.
2. Confirm build stage is complete (or Gate 3 is passed).
3. If build is not complete:
   - Stop and ask: "SEO is usually post-build. Do you want me to run an early audit anyway?"
   - Proceed only on explicit override.

## Workflow

1. **Scope the audit**
   - Confirm target: live URL, staging URL, or page list.
   - Confirm objective: technical SEO, on-page, content quality, GEO/AEO, or full sweep.

2. **Collect evidence**
   - Use deterministic checks and measurable evidence where possible.
   - Prefer tool-verified findings over assumptions.
   - Label certainty:
     - `Confirmed`
     - `Likely`
     - `Hypothesis`

3. **Produce deliverables**
   - Save outputs in `seo/` at the project root:
     - `seo/YYYY-MM-DD-audit.md`
     - `seo/YYYY-MM-DD-action-plan.md`
   - Action plan should be prioritized by impact and effort:
     - High impact / low effort first
     - Include owner and status placeholder

4. **Update project tracking**
   - Add a brief entry in `changelog/` describing SEO pass scope and outputs.
   - If relevant, add actionable follow-ups to `project.md` tasks/backlog.

## Integration with Agentic-SEO-Skill

This skill is the orbytes wrapper around the Agentic SEO approach. When deeper SEO diagnostics are requested, mirror the upstream structure:

- Technical SEO pass
- Content pass
- Schema pass
- GEO/AEO pass
- Prioritized plan

Keep the workflow aligned to orbytes process and file conventions (project-first, evidence-first, post-build default).

## Output format

At the end of a run, return:

- Scope covered
- Top risks/opportunities
- Quick wins (next 7 days)
- Structural work (next 30 days)
- Files created/updated
