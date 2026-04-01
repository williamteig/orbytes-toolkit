---
name: orbytes-context-sync
description: >
  Use this skill whenever you need to stay in sync with orbytes.io's active client projects across Notion, Webflow, and Figma. Trigger this skill when:
  - Starting work on any client project (to load fresh context before acting)
  - A client asks about their project status or details
  - New branding, design, or content arrives in Figma and needs to be written into Notion
  - A new Webflow site is created and needs to be linked in Notion
  - The user asks what projects are active, what stage a client is at, or what's in the pipeline
  - Any update is made in Figma or Webflow that should be reflected in the Notion project record
  - The user says anything like "update the client notes", "sync the project", "what's the status on X", "link the Figma file", "add the Webflow URL", or "update brand notes"

  Notion is always the primary source of truth. Always fetch Notion first, then use the Webflow URL and Figma URL stored there to pull additional context from those tools.
---

# orbytes-context-sync

This skill keeps your context fresh and accurate when working on orbytes.io client projects. It knows that:

- **Notion** holds the master project record — stages, contacts, copy, brand notes, checklists
- **Figma** holds design and branding assets — the Figma URL is stored in the Notion client record
- **Github** holds the live build — the github repo URL is stored in the Notion client record
- There may be a **webflow site** associated with the project, but not always. This can be considered a legacy feature, as sites are migrating to astro.

The goal is simple: before doing anything on a client project, load what you need. After making changes in Figma or Github, write the relevant updates back to Notion so it never falls out of date.

---
## Step 1 — Load client context from Notion

When a client name is mentioned, always start by fetching their record from the **Website Clients** database.

```
Database ID: 3282204c-5659-8003-8f3d-f3f7a7646643
Data source: collection://3282204c-5659-80e1-ad2b-000bdf0d92f2
```

Use `notion-search` to find the client page if you don't have the ID, then `notion-fetch` on the page to get:
- Current stage (which Stage X section has recent activity)
- Github URL (field: `Github URL`)
- Figma URL (field: `Figma URL`)
- Webflow URL (field: `Webflow URL`) (optional)
- Contact details, tier, launch date
- Brand notes (inside the Branding Checklist sub-database — look for a "Brand Notes" page)

**Notion is the source of truth.** If Notion says something and another tool says something different, trust Notion.

---

## Step 2 — Pull Figma context (when relevant)

If the task involves branding, design review, or implementing styles:

1. Get the Figma URL from the Notion client record
2. Use `get_design_context` (fileKey + nodeId from the URL) to pull colours, typography, logo details
3. Use `get_variable_defs` to pull any named design tokens
4. Use `get_screenshot` if you need a visual reference
**Key Figma URL pattern:**
`https://www.figma.com/design/{fileKey}/{fileName}?node-id={int1}-{int2}`
- fileKey = the segment after `/design/`
- nodeId = `{int1}:{int2}` (replace `-` with `:`)

---

## Step 3 — Pull Webflow context (when relevant)

If the task involves checking the build, updating styles/variables, or linking a new site:

1. Get the Webflow URL from the Notion client record
2. Use `data_sites_tool` → `list_sites` to find the site by display name if needed
3. Use `variable_tool` → `get_variable_collections` / `get_variables` to check what brand tokens are already set up
4. Use `style_tool` → `get_styles` to review current typography/class styles

---

## Step 4 — Write updates back to Notion

After fetching from Figma or Webflow, always ask: does Notion reflect what I just found?

### When to update Notion:

| Trigger | What to write |
|---------|---------------|
| New Figma branding delivered | Update/create "Brand Notes" page in the client's Branding Checklist sub-database |
| New Webflow site created | Set the `Webflow URL` field on the client's Notion page |
| New Figma file created | Set the `Figma URL` field on the client's Notion page |
| Stage completed | Note can be added to the relevant Stage section || Branding checklist item done | Mark it in the Branding Checklist database |

### Writing Brand Notes to Notion:

Brand notes live inside the client's **Branding Checklist** sub-database (inline, inside the project page). The page title is "Brand Notes". Create it if it doesn't exist.

**Brand Notes should always include:**
- Colour palette (hex values + names + usage)
- Logo description and variations
- Typography direction
- Design tone/personality
- Source Figma link
- Who delivered the branding (e.g., Softriver)

---

## Sync checklist (run mentally before any client task)

- [ ] Have I fetched the client's Notion page?
- [ ] Do I have their current stage and any active blockers?
- [ ] If branding is involved — have I pulled the Figma file?
- [ ] If development is involved — do I have the Webflow site ID?
- [ ] After my work — does Notion reflect what I just did or found?