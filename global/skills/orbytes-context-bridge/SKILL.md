---
name: orbytes-context-bridge
description: Pull relevant context from Williams 2nd Brain into the current client project. Run on first session in a new project (the scaffold invokes this automatically) and any time the user asks for "wiki context", "2nd Brain context", or cross-project insight. Always asks Will what context is relevant first — never searches blindly.
---

Pulls context from Williams 2nd Brain (`/Users/williamteig/Documents/AppDev/Williams 2nd Brain/`) into the **current** project. The 2nd Brain wiki does not auto-load anywhere except its own directory — this skill is the one-way bridge that brings relevant slices of it into a client project (or into orbytes' own projects).

## When to run

- **Automatically at scaffold time** — `orbytes-scaffold` invokes this as its final step (see step at the bottom of `orbytes-scaffold/SKILL.md`).
- **First session in any orbytes project** that doesn't yet have a `context-bridge.md` — see "First-session protocol" below. The global `~/.claude/CLAUDE.md` instructs Claude to check for this file at session start and offer to run the bridge if it's missing.
- **On request** — when Will says "pull from the 2nd Brain", "check the wiki", "what does the wiki say about X", or asks for cross-project insight.
- **After a major decision** — if Will makes a decision in the current project that's likely to apply elsewhere, run the bridge in reverse direction (suggest a wiki update). That's a separate concern from this skill — flag it, don't act on it here.

## How it works

Two-phase: **ask first, then search.** Never go to the wiki cold — Will's brain is a richer source of project context than any keyword match. The wiki supplements what he already knows; it doesn't replace asking.

### Phase 1 — Questionnaire (always)

Ask Will the questions below, **one at a time**, and capture his answers. If he says "you tell me" or "just check the wiki", skip to Phase 2 with whatever clues are available (project name, stack, type).

1. **What's the project?** One-line summary. (Often already in `project.md` — confirm rather than ask if so.)
2. **What do you already know that's relevant?** Brain-dump — prior projects this resembles, key decisions already made, relevant people, partner businesses, prior learnings. No need to be structured; bullet points fine.
3. **Are there specific 2nd Brain pages you want pulled in?** Wiki page names if Will already has them in mind (e.g. `[[astro-component-starter]]`, `[[william-email-voice]]`, `[[tat-greg-email-voice]]`).
4. **What domains apply?** Tick any that fit:
   - orbytes business strategy / pricing / workflow
   - TAT product / community / casting domain
   - A specific client (Fraser's Medical, Nina Van Sant, etc.)
   - A specific tool (Framer, CloudCannon, Webflow, Notion, Circle, Pixa)
   - Brand & copy voice
   - None — fresh ground
5. **Anything to *exclude*?** Sensitivities — e.g. TAT mgmt-confidential content, other clients' details, parked work.

If Will is offline / running this autonomously after scaffold, default to: confirm project metadata from `project.md`, list the most likely-relevant domains based on stack and tier, and write a thin `context-bridge.md` flagging that Phase 1 is pending Will's input.

### Phase 2 — Search the 2nd Brain

Using Will's answers as the search lens:

1. **Run `qmd query`** against the wiki collection for each domain/topic surfaced in Phase 1. `qmd` is the hybrid BM25+vector+rerank search — much faster and more accurate than reading files.
   - If `qmd` isn't available from the current directory (it's an MCP server scoped to the 2nd Brain), fall back to reading the relevant index shard:
     - `wiki/index-orbytes.md` for orbytes/cross-business topics
     - `wiki/index-tat.md` for TAT/cross-business topics
     - `wiki/index-shared.md` for cross-business only
2. **Read the candidate pages** — entities, topics, sources, analyses. Pull the actual page, not just the title.
3. **Filter to what applies.** Don't dump everything — pull the **insight**, not the page contents. A page may have 5KB of detail but only one paragraph that matters here.
4. **Cite by wikilink.** Always name the page (`[[page-name]]`) so Will can open the full source in Obsidian.

### Phase 3 — Write `context-bridge.md`

Save a synthesis to `context-bridge.md` in the project root (alongside `project.md`, `brand.md`). This file is the per-project state marker — its presence tells future sessions that the bridge has been run.

Format:

```markdown
---
title: 2nd Brain Context Bridge
project: <project-name>
last_run: YYYY-MM-DD
status: complete | pending-input
---

# 2nd Brain Context Bridge

## What Will told me

<paraphrased answers from Phase 1, in his words where possible>

## Relevant 2nd Brain pages

### Entities
- [[page-name]] — one-line why-it-matters

### Topics
- [[page-name]] — one-line why-it-matters

### Sources
- [[page-name]] — one-line why-it-matters

### Analyses
- [[page-name]] — one-line why-it-matters

## How this applies to <project-name>

<2–6 bullets connecting wiki knowledge to this project's actual work — design choices, copy voice, prior decisions to mirror, patterns to avoid>

## Excluded / out-of-scope

<anything Will explicitly excluded, plus anything I noticed but deemed inapplicable>

## Open questions for Will

<anything I couldn't resolve from the wiki — flag here so Will can answer in a future session>
```

If the bridge runs autonomously (no Will input), set `status: pending-input` and leave Phase-1 sections empty pending his answers. Don't fabricate his thinking.

## What lives where

| Knowledge type | Lives in | Access via |
|---|---|---|
| Client-specific decisions, preferences, feedback | Client vault `knowledge/` | `orbytes-query` |
| Client discovery, brief, brand | Client vault root files | Direct read |
| 2nd Brain context for this project | Client vault `context-bridge.md` | This skill |
| orbytes business strategy, pricing, workflow | 2nd Brain `wiki/topics/` | This skill (via `qmd`) |
| TAT business / casting domain | 2nd Brain `wiki/topics/`, `wiki/entities/` | This skill (via `qmd`) |
| People (Greg, Robyn, clients) | 2nd Brain `wiki/entities/` | This skill (via `qmd`) |
| Cross-project patterns | 2nd Brain `wiki/analyses/` | This skill (via `qmd`) |

## First-session protocol

When Claude starts a session in any orbytes project directory (anything under `~/Documents/AppDev/` other than `Williams 2nd Brain/` itself):

1. Check for `context-bridge.md` in the project root.
2. **If present** — read it for context, proceed with the user's request.
3. **If missing** — surface this in the first reply: *"This project doesn't have a `context-bridge.md` yet. Want me to run `orbytes-context-bridge` to pull relevant 2nd Brain context before we start?"* Don't run it without confirmation — Will may want to dive straight into a quick task.

This is reinforced by the global rule in `~/.claude/CLAUDE.md`. Don't skip it.

## Rules

- **Read-only on the 2nd Brain.** Never modify wiki content from a client project session. Wiki edits happen inside the 2nd Brain only, by the workflows defined there.
- **Ask first, search second.** Will's input is the most valuable signal — don't bypass Phase 1 just because the wiki is searchable.
- **Summarise, don't dump.** Pull the insight, not the page.
- **Cite by wikilink.** Always name the wiki page.
- **Respect scope.** Don't pull client A's context when working on client B unless Will explicitly asks for cross-client comparison.
- **Sensitive content stays out.** TAT mgmt-confidential material (salaries, staff decisions, partner agreements) never bridges into a vault that will be handed to a client. Will's wiki tags this clearly — respect it.
- **Re-run when context shifts.** If Will reports a major new decision in the wiki since the bridge last ran, offer to re-bridge. Update `last_run` in the frontmatter when you do.
