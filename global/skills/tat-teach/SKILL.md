---
name: tat-teach
description: Sync team-safe operational knowledge from Williams 2nd Brain to the TAT Notion 2nd Brain. Use when Will says "teach the TAT vault", "sync TAT", "update the TAT brain", or after an end-of-session where meaningful TAT operational knowledge emerged.
---

Teach the **TAT Notion 2nd Brain** from Williams 2nd Brain — propagate operational knowledge to the team-facing vault while filtering out anything management-sensitive.

## When to use

- Will says "teach the TAT vault", "sync TAT", "update the TAT brain"
- End of a Williams 2nd Brain session where meaningful TAT operational knowledge emerged
- A `project_tat_*` or `reference_tat_*` memory was created or meaningfully updated
- Workflow / protocol changes were made that affect the TAT team
- A new decision that should be visible to the team was taken

## Destinations in the TAT Notion vault

Root: [TAT 2nd Brain](https://www.notion.so/TAT-2nd-Brain-3492ff1593c38033986dc4cecef24fb0) (see `[[reference_tat_2nd_brain]]`)

Route knowledge to the right surface:

| Knowledge type | TAT Notion destination |
|---|---|
| A decision, doctrine, framework, strategy | Topics database |
| A factual thing — person, platform, partner, tool | Entities database |
| An offering — course, community, event | Products database |
| An ingested source — call, email, doc | Sources database |
| A deep-dive, audit, comparison | Analyses database |
| A dated activity trail item | Ops Log page |

## Pre-check: sensitivity filter (NON-NEGOTIABLE)

Before writing anything, apply `[[feedback_tat_wiki_sensitivity]]`:

**Exclude from the TAT vault:**
- Salaries, rates, compensation
- Staffing decisions under consideration (hiring / firing / role change)
- Performance judgements about team members
- Confidential financial numbers
- Private strategic thinking about people
- Pending decisions not yet communicated to the team

**Include:**
- What people do — roles, responsibilities, domains
- How people communicate — channels, tools, handover points
- Public product / course / community strategy
- Published pricing, public positioning
- Factual team bios

**If in doubt, ask Will before writing.** Never auto-split mixed-content sources — confirm the split.

## Procedure

1. **Identify source** — which `/Users/williamteig/.claude/projects/-Users-williamteig-Documents-AppDev-Williams-2nd-Brain/memory/*.md` file(s) contain the knowledge to sync
2. **Filter for sensitivity** — redact or exclude management-layer content
3. **Check for existing TAT vault equivalent** — use `notion-search` against the relevant data source before creating; prefer updating existing over duplicating
4. **Write or update** in Notion
5. **Cross-link properly** — use Notion page links (URL form `https://www.notion.so/<page_id>`), not plain text; if newly created, do a second pass to add links after you have IDs
6. **Log the sync** — append to the [Ops Log](https://www.notion.so/3492ff1593c3818180afddb86ee96e1c) with `## [YYYY-MM-DD] learn | <title>` and affected pages
7. **Report back** — list what was synced, what was excluded and why, and where it landed

## Key references from Williams 2nd Brain

- `[[reference_tat_2nd_brain]]` — vault root URL + structure
- `[[feedback_tat_wiki_sensitivity]]` — the sensitivity boundary
- `[[reference_tat_asset_map]]` — per-course Circle/Vimeo/Notion/website URLs
- `[[project_tat_course_launch_protocol]]` — 8-stage launch template
- `[[feedback_mcp_inventory_vs_state]]` — MCP limitations; don't make state claims from MCP alone
- `[[project_tat_team_transition]]` — MANAGEMENT-CONFIDENTIAL; never copy any of this into the TAT vault

## Destination quick-map (data source IDs as of 2026-04-21)

| DB | Data source ID |
|---|---|
| Entities | `51bbcbfc-851d-45b2-a015-156b26939802` |
| Products | `9507b7fd-8c96-4645-8eb4-0d495163f40d` |
| Topics | `c2db1668-bac1-4e47-b92b-eaef5f86e45d` |
| Sources | `525a130c-e334-4e6d-abb7-d13ef0299155` |
| Analyses | `6e2f953c-63c0-4b95-9501-9be7fbbf61b5` |

Ops Log page ID: `3492ff15-93c3-8181-80af-ddb86ee96e1c`

## Stop-conditions

- If you can't tell whether something is operational vs management-sensitive → **ask Will before writing**
- If the TAT vault already has the knowledge accurately → **just cross-link, don't duplicate**
- If a source mixes operational + management content → **confirm the split with Will**, route operational to TAT and management to Will's private space
- If you're about to write something that names salary, performance, or pending staff decisions → **stop**

## Relationship to other skills

- `orbytes-context-bridge` — opposite direction: PULLS from Williams 2nd Brain into a local client vault (read-only)
- `tat-teach` (this skill) — PUSHES team-safe subset of Williams 2nd Brain into the TAT Notion vault (write)
- `learn` — reviews the current conversation and updates memory; can be chained with this skill for end-of-session sync

## Output format

```
TAT Teach: [topic]

Synced to TAT vault:
- [page link] — [what was added/updated]

Excluded (kept in Williams 2nd Brain only):
- [what was not synced and why — salary / pending decision / etc.]

Ops Log entry: [link]
```
