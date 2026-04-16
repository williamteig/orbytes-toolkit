---
description: Rules for working with Webflow — site management, styles, CMS, variables. Apply when building or updating a Webflow site.
alwaysApply: false
---

# Webflow Rules

## Role in the Stack

Webflow is **optional** and **project-specific**: some website engagements use a **native Webflow Designer build** or **Webflow CMS** feeding a static site; many new sites are **Astro + Tailwind** with **CloudCannon** or other CMS—see **`dev-workflow.md`**. **Figma** is upstream for design handoff. **Never assume** Webflow until `project.md` confirms `stack: webflow`.

The Webflow URL for each client is stored in `project.md` frontmatter (`webflow_url` field).

## Modes (clarify before work)

| Mode | Meaning |
|------|---------|
| **Native Webflow Designer** | Pages and styles live in Webflow; publishing is Webflow-hosted. |
| **Webflow CMS → headless** | Content is edited in Webflow; the **marketing site** is built in Astro (or similar) and pulls content at **build time** via API. |
| **Webflow Code Components** | React (or similar) components deployed to a workspace library—see Webflow MCP skills for code-component workflows. |

Do not assume which mode applies—read `project.md` and the task brief.

## Working with Webflow

- Use `data_sites_tool → list_sites` to find a site by display name
- Use `variable_tool → get_variable_collections / get_variables` to check brand tokens
- Use `style_tool → get_styles` to review current typography and class styles
- After creating or linking a Webflow site, update `project.md` frontmatter with the `webflow_url`

## Gotchas

**Gotcha — Webflow is optional for websites too.**
Confirm in `project.md` whether this engagement includes a Webflow site (Designer build and/or headless CMS). **Custom app** projects do not use Webflow.

**Gotcha — Webflow CMS headless vs. native.**
When a website project selects "Webflow CMS" as an integration, it means using Webflow as a headless CMS (content pulled via API into Astro). This is different from a native Webflow site build. Clarify which mode is in use before making CMS changes.

**Gotcha — do not crawl local files when working on Webflow pages.**
When gathering context for a Webflow page or section, only use the Webflow MCP tools (`element_tool`, `style_tool`, `de_page_tool`, etc.) and the specific Webflow page/site provided. Do NOT search local project files for similarly named pages or components — Webflow pages are managed entirely through the Webflow API, and local files with similar names are unrelated. Crawling local files wastes context and can lead to incorrect assumptions about the Webflow page structure.
