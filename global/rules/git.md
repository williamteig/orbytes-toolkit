---
description: Git and GitHub conventions for orbytes projects. Apply when committing, branching, creating PRs, or setting up repos.
alwaysApply: true
---

# Git & GitHub Rules

## Repo Setup

- All repos are private under the `williamteig` GitHub account
- Repo names use kebab-case matching the project directory name
- Create repos with: `gh repo create williamteig/<project-name> --private --source=. --push`

## Branch & Commit Conventions

- Use conventional commit format: `feat:`, `fix:`, `docs:`, `chore:`, `refactor:`
- Commit messages describe the "why" not just the "what"
- Branch names for Dev Pipeline tasks: `dev-{ID}-{short-description}` (e.g. `dev-13-fix-contact-form`)

## PR Conventions

- PR title: short, under 70 characters
- PR body: summary bullets + test plan checklist
- Reference the task from `project.md` in the PR body

## Gotchas

**Gotcha — never force-push to main.**
All orbytes repos use `main` as the primary branch. Force-pushing to main can destroy history. Always push to a feature branch and merge via PR.

**Gotcha — no slashes in branch names.**
Use hyphens only in branch names (e.g. `dev-13-fix-contact-form`, not `DEV-13/fix-contact-form`). Slashes in branch names resolve to `+` in some contexts (CI systems, URL encoding) and cause parsing issues.

**Gotcha — strip tracking params from external URLs before storing.**
When storing URLs (Figma, Webflow, etc.) in config files or `project.md` frontmatter, strip any tracking or session query params. Store only the canonical base URL.
