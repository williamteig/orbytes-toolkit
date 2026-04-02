---
description: Rules for working with Webflow — site management, styles, CMS, variables. Apply when building or updating a Webflow site.
alwaysApply: false
---

# Webflow Rules

## Role in the Stack

Webflow is the primary design and build tool for orbytes websites. Unlike Figma (which is intentionally lightweight), Webflow is where the full design happens — layout, typography, component styling, CMS structure.

The Webflow URL for each client is stored in their Notion project page (`Webflow URL` field).

## Working with Webflow

- Use `data_sites_tool → list_sites` to find a site by display name
- Use `variable_tool → get_variable_collections / get_variables` to check brand tokens
- Use `style_tool → get_styles` to review current typography and class styles
- After creating or linking a Webflow site, update the client's Notion page with the `Webflow URL`

## Gotchas

**Gotcha — Webflow is optional for app projects.**
App projects (Custom Build tier) do not use Webflow. Only website projects (Landing Page, Full Website) use Webflow as the build tool.

**Gotcha — Webflow CMS headless vs. native.**
When a website project selects "Webflow CMS" as an integration, it means using Webflow as a headless CMS (content pulled via API into Astro). This is different from a native Webflow site build. Clarify which mode is in use before making CMS changes.

**Gotcha — do not crawl local files when working on Webflow pages.**
When gathering context for a Webflow page or section, only use the Webflow MCP tools (`element_tool`, `style_tool`, `de_page_tool`, etc.) and the specific Webflow page/site provided. Do NOT search local project files for similarly named pages or components — Webflow pages are managed entirely through the Webflow API, and local files with similar names are unrelated. Crawling local files wastes context and can lead to incorrect assumptions about the Webflow page structure.
