---
description: SEO execution rules for orbytes projects. Apply only when explicitly running SEO work.
alwaysApply: false
---

# SEO Rules

## Invocation

- SEO work is opt-in.
- Only run SEO when the user explicitly asks for it or invokes `/orbytes-seo`.
- Never auto-run SEO as part of standard build tasks.

## Timing

- Default: run SEO after build (Stage 4 complete / Gate 3 passed).
- If asked pre-build, confirm override before running.

## Process

1. Read `project.md` first.
2. Confirm target URL scope (staging/live, page list).
3. Collect evidence-based findings.
4. Separate certainty:
   - Confirmed
   - Likely
   - Hypothesis
5. Produce:
   - `seo/YYYY-MM-DD-audit.md`
   - `seo/YYYY-MM-DD-action-plan.md`

## Prioritization

- Sort fixes by impact and effort.
- Emphasize quick wins first.
- Avoid broad speculative rewrites without evidence.

## Reporting standards

- Every recommendation should include:
  - Why it matters
  - Expected impact
  - Verification step
