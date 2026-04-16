---
description: >-
  CloudCannon — Git-based CMS, visual editing, site config, and branch workflow for orbytes sites
  that use CloudCannon. Apply when editing content structure or publishing from CloudCannon.
alwaysApply: false
---

# CloudCannon

## When this applies

Website projects that use **CloudCannon** for **Git-backed content editing** and visual previews. Confirm each client's stack in `project.md`—some sites use Webflow-only or Astro-only CMS.

## Source of truth

- **Git** remains canonical for content and structure; CloudCannon edits **commit back** to the repo.
- **`project.md`** stays the project’s operational source of truth for URLs, stakeholders, and approvals—not CloudCannon’s UI alone.

## Configuration

- **Site config** (collections, paths, inputs) lives in the repo—change it **intentionally** and review in PR before merge.
- **Branch workflow:** editing and previews usually track a **staging** or **preview** branch; production merges follow the same **approval gates** as the rest of orbytes (see `workflow.md`).

## Editing experience

- **Do not** bypass schema: if a field is not in the config, add it via code/config first, then expose in CloudCannon.
- **Preview** links are for **stakeholder review**; treat them like any other preview URL—do not confuse with production until DNS and deploy say so.

## Related rules

- **Git / PR:** `git.md`
- **Astro** (common static site target): `astro.md`
