# /orbytes-seo — Run opt-in post-build SEO workflow

Invoke the `orbytes-seo` skill.

This command is intentionally **opt-in**:

- Do not run unless the user explicitly called `/orbytes-seo` or explicitly requested SEO work.
- Default timing is after build (Stage 4 complete / Gate 3 passed).
- If the project is pre-build, ask for explicit override before proceeding.

## Required sequence

1. Read `project.md`.
2. Verify current stage and gate status.
3. If post-build, run `orbytes-seo`.
4. If pre-build, ask:
   - "SEO is usually post-build. Do you want me to run an early audit anyway?"
5. Write outputs to `seo/`:
   - `seo/YYYY-MM-DD-audit.md`
   - `seo/YYYY-MM-DD-action-plan.md`
