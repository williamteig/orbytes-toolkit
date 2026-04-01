---
description: "Finish the current task: commit changes, push the branch, create a PR, and update the Notion task to Done. Run this when you're finished working on a /task session."
user-invocable: true
---

# /task-done — Complete the current task

You are wrapping up a coding session that was started with `/task`.

## Database reference

- **Database URL**: `https://www.notion.so/599e132701274298b902d85a529ebde5`
- **Data source**: `collection://277efdcf-8436-4503-84a6-20f3e9428ef7`

## Steps

### 1. Verify we're in a worktree session

Check that we're currently in a git worktree (the working directory should be under `.claude/worktrees/`).
If not, tell the user: "You're not in a worktree session. Run `/task` first to pick up a task." and stop.

### 2. Identify the current task

Get the current branch name with `git branch --show-current`.
Extract the task ID number from the branch name — look for the `dev-` prefix followed by a number (e.g., `dev-13-fix-contact-form` → task ID `13`).

Query the Dev Pipeline data source for the task:
```
SELECT * FROM "collection://277efdcf-8436-4503-84a6-20f3e9428ef7" WHERE "userDefined:ID" = <number>
```
Then use `notion-fetch` on the task's URL to read its full page content.

### 3. Check for uncommitted changes

Run `git status` and `git diff` to see what's changed.

If there are uncommitted changes:
- Stage and commit them with a descriptive commit message following the repo's commit style.
- The commit message should reference the task: e.g., `feat(dev-13): add auth CTA buttons`

If there are NO changes at all (nothing committed beyond what was on main):
- Tell the user: "No changes found on this branch. Nothing to push or PR."
- Ask if they want to mark the task as Done anyway, or leave it In Progress.

### 4. Push the branch

Run `git push -u origin {branch-name}`.

### 5. Create a Pull Request

Use `gh pr create` with:
- **Title**: The task title from Notion (e.g., "Add auth CTA buttons")
- **Body**: Include:
  - Link to the Notion task page
  - The session summary from step 6 (what was done, what was learned, follow-ups)
  - A test plan section

Target branch: `main`

If a PR already exists for this branch, skip creation and just note the existing PR URL.

### 6. Write a session summary

Before updating Notion, reflect on the entire session and write a summary that covers:

1. **What was done** — a concise list of the changes made (files added/modified, features implemented, bugs fixed).
2. **What was learned** — anything discovered during the session that would be useful for future work. This includes: gotchas encountered, unexpected behaviour, workarounds applied, architectural decisions made and why, patterns discovered in the codebase, or things that almost went wrong. This is the most valuable part — capture the knowledge that would otherwise be lost when the session ends.
3. **What's left / follow-ups** — any loose ends, known issues, or future improvements that came up but were out of scope.

Format this as a Markdown block. It will be used in both the PR body and the Notion task notes.

### 7. Update Notion

Use `notion-update-page` to:
- Set `Status` to `"Done"`
- Set the `Notes` field to the session summary from step 6, with the PR URL at the top. Format: `PR: {url}\n\n{session summary}\n\n{any existing notes}`

### 8. Merge the PR

Use `gh pr merge --auto` to merge on GitHub's side. Do NOT use `gh pr merge` without `--auto` — it will fail with `fatal: 'main' is already used by worktree` if main is checked out in the main repo.

If auto-merge is not enabled on the repo, tell the user: "Auto-merge isn't enabled. Merge the PR manually on GitHub, then run the cleanup step below."

### 9. Post-merge cleanup

After the PR is merged (or if the user confirms it was merged manually):

1. **Exit the worktree**: Navigate back to the main repo directory
2. **Remove the worktree**: `git worktree remove <worktree-path>`
3. **Delete the local branch**: `git branch -d <branch-name>`
4. **Delete the remote branch** (if GitHub didn't auto-delete): `git push origin --delete <branch-name>`
5. **Update local main**: `git checkout main && git pull origin main`

If the worktree removal fails (e.g. uncommitted changes), warn the user and skip to step 5.

### 10. Summary

Print:
```
Task DEV-{ID} complete!
Branch: {branch-name} (cleaned up)
PR: {pr-url} (merged)
Notion: Updated to Done
Worktree: Removed
Local main: Up to date
```
