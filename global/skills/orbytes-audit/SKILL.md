---
name: orbytes-audit
description: Audit the project pipeline against the actual repo state. Checks that items marked as complete in project.md are actually present and valid in the repo. Use when checking project health, before gate approvals, or when the user says "audit".
---

Audit the current orbytes project by comparing `project.md` pipeline checkmarks against the actual state of the repo.

## How it works

1. **Read `project.md`** — parse the pipeline checklist and identify all items marked as complete (`[x]`)
2. **For each completed item, verify it exists in the repo:**

### Verification rules

| Pipeline item pattern | What to check |
|---|---|
| Logo delivered | `assets/` contains an SVG or PNG logo file |
| Colour palette defined | `design.md` has a populated color token table (not template placeholders) |
| Typography selected | `design.md` has actual font names (not placeholders) |
| Brand voice documented | `voice.md` exists and has content, OR `design.md` documents tone guidance |
| Brand system saved to `design.md` | `design.md` exists and is populated (not just the template) |
| Discovery brief complete | `brief.md` exists and has content |
| Site map finalized | `content/` directory has page files matching the site map in `brief.md` |
| CMS schema designed | Content files in `content/` have CMS field definitions |
| Competitor audit | A competitor audit document exists (in `brief.md` or separate file) |
| Homepage copy | `content/home.md` has actual copy (not just section placeholders) |
| [Page] copy | `content/<page>.md` has actual copy |
| All pages reviewed | All content files have copy (not placeholders) |
| Homepage design in Framer | `project.md` frontmatter has a `framer_url` set |
| Homepage built | Same as above (can't verify Framer state from repo) |
| Domain connected | `project.md` frontmatter has a `live_url` set |
| Git repo created | `.git/` exists and has a remote |

### For items that can't be verified from the repo
Some items (like "Client review", "Responsive QA", "Performance audit") can't be verified by checking files. Flag these as **"Cannot verify from repo — confirm manually"**.

## Output

Print a report:

```
Pipeline Audit: [Project Name]
Date: YYYY-MM-DD
Stage: [current stage from project.md]

VERIFIED ✅
- [x] Logo delivered — assets/logo.svg exists
- [x] Colour palette defined — design.md has 6 colors populated

FAILED ❌
- [x] Competitor audit — MARKED COMPLETE but no competitor audit found in repo

MANUAL CHECK NEEDED ⚠️
- [x] Client review — cannot verify from repo, confirm manually

UNCHECKED (not yet marked complete)
- [ ] Homepage copy — content/home.md exists but contains placeholders only
```

## When to run

- Before any approval gate (Gate 1, 2, or 3)
- When the user asks for a project health check
- When resuming work after a break
- When the user says "audit"

## Rules

- **Never mark items as complete in project.md** — only report discrepancies. The user decides what to fix.
- **Be specific** — don't just say "missing", say exactly what's expected and what was found.
- **Flag items marked complete that aren't actually done** — this is the primary purpose.
- **Flag items NOT marked complete that appear to be done** — helpful for keeping the pipeline current.
