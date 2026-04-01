---
description: Rules for working with Notion — source of truth, database IDs, update patterns. Apply when reading from or writing to Notion.
alwaysApply: false
---

# Notion Rules

## Source of Truth

Notion is always the primary source of truth for project state, client details, copy, and checklists. If Notion says something and another tool says something different, trust Notion.

Before starting any work on a client project, fetch the client's Notion project page. After completing work, update Notion to reflect what changed.

## Database References

- **Orbytes Clients DB:** `collection://3282204c-5659-80e1-ad2b-000bdf0d92f2`
- **Database ID:** `3282204c-5659-8003-8f3d-f3f7a7646643`
- **Project Template ID:** `3352204c-5659-80e2-a8ee-ef6a9121a71e`
- **Dev Pipeline DB ID:** `599e132701274298b902d85a529ebde5`
- **Dev Pipeline Data Source:** `collection://277efdcf-8436-4503-84a6-20f3e9428ef7`

## Client Record Fields

Each client page in the Orbytes Clients DB has:
- `Github URL` — GitHub repo URL
- `Figma URL` — Figma design file URL (base URL only, no query params)
- `Webflow URL` — Webflow site URL (optional)
- Current stage, contact details, tier, launch date

## Update Patterns

| Trigger | What to write |
|---------|---------------|
| New GitHub repo created | Set `Github URL` field on client's Notion page |
| New Figma file created | Set `Figma URL` field on client's Notion page |
| New Webflow site created | Set `Webflow URL` field on client's Notion page |
| Branding delivered | Create/update "Brand Notes" page in Branding Checklist sub-database |
| Stage completed | Add note to relevant Stage section |

## Gotchas

**Gotcha — Notion workspace is only created after qualification.**
Do not create a Notion project page for a client until they have passed the qualification stage. The qualification form lives on external platforms — never recreate it in Notion.
