---
description: Repo management policy + git conventions for orbytes projects. Apply when committing, branching, creating PRs, or deciding whether a project goes on GitHub.
alwaysApply: true
---

# Git & Repo Management Rules

## Repo Management Policy — the summary that governs every orbytes repo

One question decides how a repo is managed: **is there an app (a codebase) inside the repo?**

### Documentation vaults — no app code in the repo

The default for **Framer** projects and any project whose repo holds only documentation (`project.md`, `design.md`, `voice.md`, `brief.md`, `discovery/`, `content/`, `knowledge/`, inspiration). For Framer the site lives in Framer's cloud, so the repo is just the vault — at most a `src/` of CDN-delivered scripts.

- **Local git + iCloud only.** Commit history lives in the local repo; the project directory is backed up through iCloud. That is the backup.
- **Not pushed to GitHub.** No `gh repo create`, no remote, no PRs, no CI, no worktrees.
- **Commit straight to `main`.** Branch / PR / worktree ceremony adds nothing to a folder of markdown — skip all of it.
- Keep commit messages clean (conventional prefixes still welcome) — the vault is a client deliverable.

### App repos — code lives inside the repo

Any project with an actual codebase: **Astro** (and CloudCannon), custom builds, or anything where the site/app is built from files in the repo.

- **Everything lives in this one repo** — *all* app files and code **and** *all* documentation for that app. Do not split the docs into a separate vault; the code repo *is* the vault.
- **Pushed to GitHub** — private, under the `williamteig` account.
- **Managed as a real app** — feature branches, pull requests, worktrees, CI, and the conventions below.

> Unsure which kind? Check `project.md` → `stack`. `framer` (or any no-codebase stack) = documentation vault. `astro` (or any stack with code in the repo) = app repo.

---

Everything below applies to **app repos only**. Documentation vaults skip it.

## Repo Setup (app repos)

- Private under the `williamteig` GitHub account
- Repo names use kebab-case matching the project directory name
- Create repos with: `gh repo create williamteig/<project-name> --private --source=. --push`

## Branch & Commit Conventions (app repos)

- Use conventional commit format: `feat:`, `fix:`, `docs:`, `chore:`, `refactor:`
- Commit messages describe the "why" not just the "what"
- Branch names for Dev Pipeline tasks: `dev-{ID}-{short-description}` (e.g. `dev-13-fix-contact-form`)
- Parallel feature streams get their own branch / worktree; keep commits feature-scoped

## PR Conventions (app repos)

- PR title: short, under 70 characters
- PR body: summary bullets + test plan checklist
- Reference the task from `project.md` in the PR body

## Gotchas

**Gotcha — documentation vaults never touch GitHub.**
Framer and pure-doc projects are local git + iCloud only. If you catch yourself running `gh repo create`, opening a PR, writing a `.gitignore` full of build excludes, or creating a worktree on one — stop. That's app-repo ceremony on a notes folder. Commit to `main` and move on.

**Gotcha — never force-push to main.** (app repos)
Force-pushing to `main` can destroy history. Push to a feature branch and merge via PR.

**Gotcha — no slashes in branch names.** (app repos)
Use hyphens only (e.g. `dev-13-fix-contact-form`, not `DEV-13/fix-contact-form`). Slashes resolve to `+` in some contexts (CI, URL encoding) and cause parsing issues.

**Gotcha — strip tracking params from external URLs before storing.**
When storing URLs (Figma, Webflow, etc.) in config files or `project.md` frontmatter, strip any tracking or session query params. Store only the canonical base URL.
