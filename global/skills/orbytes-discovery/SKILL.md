---
name: orbytes-discovery
description: Process and analyse client discovery questionnaire responses for an orbytes web project. Use when a client has submitted their discovery answers, when starting discovery, or when the user mentions "discovery" for a client project.
---

This skill handles the orbytes client discovery process. The discovery questionnaire has 19 questions across 5 sections + a current-site walkthrough, delivered to clients via VideoAsk or Typeform. The client fills it out asynchronously — it takes them days, not minutes.

Your job is to **process the completed responses**, not administer the questionnaire live. Here's the workflow:

## Step 1 — Ingest responses
Look for the client's discovery responses in the project directory (could be a markdown file, PDF, pasted text, or raw export from VideoAsk/Typeform). Read everything available. If no responses are found, ask me to provide them.

Also read any qualification summary, emails, briefs, or existing website content that's been collected for this client.

## Step 1b — Capture the current site (if one exists)

If the client provided a current-site URL in Q19, capture it before analysis. **The source of truth is the rendered DOM in a live browser — what the visitor actually sees.** Never substitute the Webflow Designer, a Figma file, or raw `view-source:` HTML. Modern sites (Webflow, Framer, anything client-rendered) serve an empty shell on initial HTML and build the visible page via JavaScript — a `wget` or `monolith` capture of those grabs nothing useful, and the Designer/Figma reflect authoring or design intent, not what actually shipped.

### Primary — render via browser

1. Create `discovery/current-site/` with `pages/` underneath.
2. Identify the pages to capture: home + every page listed in the client's Q19 walkthrough + any page they called out as "must keep / must kill." If unsure, walk the top-level nav plus the footer sitemap.
3. For each page, use a browser-backed MCP to load the URL and extract the rendered DOM:
   - **Chrome MCP** (preferred when the user wants to watch) — `mcp__Claude_in_Chrome__navigate` → `get_page_text` and/or `read_page` for DOM, plus a screenshot.
   - **Claude Preview** — `mcp__Claude_Preview__preview_start` → `preview_snapshot` for DOM + screenshot in one call.
   - If neither MCP is connected, ask Will to install/connect one before proceeding. **Do not silently fall back to `wget` or `monolith`** — both grab pre-JS HTML and will miss everything on a client-rendered site.
4. Save per-page captures under `discovery/current-site/pages/<page-slug>/`:
   - `rendered.html` — the post-JS DOM (the basis for rebuilding copy and layout).
   - `screenshot.png` — full-page screenshot for visual reference.
   - `notes.md` — section-by-section annotations tied to the Q19 walkthrough (keep / kill / must-change).

### Secondary — asset mirror (optional, static sites only)

If the site is fully static (browser View Source matches what the page renders — rare for anything built recently), you may additionally run `wget --mirror` to pull all images, fonts, and CSS in one sweep. Treat this as a complement to the rendered DOM, never a replacement:

```bash
cd discovery/current-site
wget --mirror --convert-links --adjust-extension --page-requisites --no-parent \
     --user-agent="Mozilla/5.0 (orbytes discovery archival)" \
     -P mirror/ <URL>
```

For JS-rendered sites, skip this entirely.

### Top-level notes

Create `discovery/current-site/notes.md`:

```markdown
# Current Site — {{Client Name}}

**URL:** <live URL>
**Captured:** YYYY-MM-DD
**Capture method:** Chrome MCP DOM | Claude Preview snapshot | SiteSucker | manual
**Pages captured:** <list of slugs under `pages/`>
**Asset mirror:** `mirror/` (only if the site is fully static)

## Client walkthrough (Q19)
<paste Q19 response verbatim here — their actual words, not a paraphrase>

## Likes (keep)
- <specific thing the client wants to preserve, with page/section reference>

## Hates (kill)
- <specific thing the client wants removed, with page/section reference>

## Must change
- <specific thing that must be different in the new site>

## Salvageable assets
- <copy, imagery, testimonials, stats worth pulling into the new site>

## Technical observations (LLM notes)
- <tech stack if visible, performance flags, SEO signals, accessibility flags — short bullets>

## Open questions for client
- <anything their walkthrough didn't answer>
```

### No current site

If Q19 says "no current website," skip capture but still create `notes.md` with a single line: `No current website — this is their first.` That record matters for later context.

### Feeding the Discovery Brief

Feed the client's likes/hates/must-changes into the Discovery Brief (Step 3 — `Current site findings` section). Do **not** silently rewrite their quotes; preserve them verbatim and summarise alongside.

## Step 2 — Analyse by section
Walk me through the responses section by section:

1. **Business Summary** (Q1-Q3) — Who they are, how clients find them, what differentiates them
2. **Business Goals** (Q4-Q6) — Why they need a site, desired visitor actions (primary/secondary/tertiary CTAs), success metrics
3. **Target Audience** (Q7-Q9) — Ideal customer profile, pain points, online behaviour
4. **Competitive Landscape** (Q10-Q12) — Competitors, strengths/weaknesses, inspiration sites
5. **Site Structure & Content** (Q13-Q18) — Pages needed, homepage messaging, social proof, brand tone, post-launch needs, asset inventory
6. **Current Site** (Q19) — Existing site URL and the client's annotated likes / hates / must-changes

For each section:
- Summarise the key insights
- Flag anything vague, contradictory, or missing
- Highlight the strongest material (quotes, proof points, differentiators)
- Suggest follow-up questions if critical info is missing

## Step 3 — Generate Discovery Brief
After we've discussed all sections, output a **Discovery Brief** document containing:

```markdown
# [Client Name] — Discovery Brief

## One-liner
What this business does in one sentence.

## Target audience
Detailed profile of ideal customer.

## Core differentiator
The real reason someone picks them over competitors.

## Primary CTA / Secondary CTA / Tertiary CTA
What the site needs visitors to do, in priority order.

## Success metrics
How we measure if the site is working (from Q6).

## Brand personality
Three words + tone description (from Q16).

## Homepage hook
What must land in the first 10 seconds (from Q14).

## Site structure
Recommended pages and sections (informed by Q13 + our analysis).

## Content inventory
What exists vs what needs to be created (from Q18).

## Current site findings
Summary of Q19 walkthrough — what to keep, what to kill, what must change. Link to `discovery/current-site/notes.md` for detail. If no current site, state that explicitly.

## Social proof
Available testimonials, case studies, stats, logos (from Q15).

## Competitive insights
What to learn from and what to avoid from competitors.

## Post-launch needs
What the client expects after handover (from Q17).

## Open questions
Anything we still need to resolve before writing/design begins.
```

Save this brief as `discovery-brief.md` in the project directory.

## Reference
The full questionnaire template is at: raw/orbytes/discovery-questionnaire.md
