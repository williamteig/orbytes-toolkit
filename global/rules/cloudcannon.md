---
description: >-
  CloudCannon — Git-based CMS, visual editing, site config, and branch workflow for orbytes sites
  that use CloudCannon. Apply when editing content structure or publishing from CloudCannon.
alwaysApply: false
---

# CloudCannon

## When this applies

Website projects that use **CloudCannon** for **Git-backed content editing** and visual previews. Confirm each client's stack in `project.md` — some sites use Webflow-only, and CloudCannon only pairs with the Astro stack in the orbytes toolkit.

## Canonical stack (as of 2026-04-23)

- **Starter:** `CloudCannon/astro-component-starter`, fetched via `npx create-astro-component-starter <project>` at scaffold time. **Do not** clone `tomrcc/rosey-astro-starter-demo` as the default baseline — use it only when the project needs multilingual (then prefer `CloudCannon/rosey-astro-starter` over tomrcc's personal fork).
- **Component pattern:** three-file convention — `{Component}.astro` + `{component}.cloudcannon.inputs.yml` + `{component}.cloudcannon.structure-value.yml`.
- **Bookshop is soft-deprecated** — do not introduce it; migrate any legacy project away from it when you touch the component layer.
- **Hosting:** CloudCannon-built by default (gives full visual preview in the editor). Cloudflare Pages headless mode is available if the engagement specifically prioritises the Cloudflare pipeline.
- **Agent-skills:** install 4 of 5 CloudCannon agent-skills per project via `npx -y skills add CloudCannon/agent-skills -y`. Always remove `brainstorming` (orbytes has better coverage in `shape`, `critique`, `impeccable`).

## Source of truth

- **Git** remains canonical for content and structure; CloudCannon edits **commit back** to the repo.
- **`project.md`** stays the project's operational source of truth for URLs, stakeholders, and approvals — not CloudCannon's UI alone.

## Configuration

- **Site config** (collections, paths, inputs) lives in the repo — change it **intentionally** and review in PR before merge.
- `cloudcannon.config.yml` is pre-populated by the Component Starter. Extend it; don't rebuild it from scratch.
- **Branch workflow:** editing and previews usually track a **staging** or **preview** branch; production merges follow the same **approval gates** as the rest of orbytes (see `workflow.md`).

## Editing experience

- **Do not** bypass schema: if a field is not in the config, add it via code/config first, then expose in CloudCannon.
- **Editable regions** beat full visual editing for orbytes' client profile — scope editable zones within fixed layouts so clients edit copy without breaking layout.
- **Preview** links are for **stakeholder review**; treat them like any other preview URL — do not confuse with production until DNS and deploy say so.

## Related rules

- **Git / PR:** `git.md`
- **Astro** (common static site target): `astro.md`
- **Scaffold:** `orbytes-toolkit/global/skills/orbytes-scaffold/SKILL.md` — operational steps for Astro+CloudCannon scaffold
