---
name: orbytes-ingest
description: Ingest client-sent material (comms, docs, feedback, voice transcripts) into the project knowledge base. Use when processing new client input, when the user says "ingest", or when new files appear in raw/.
---

Ingest one or more sources into the project's knowledge base. Sources can be:
- A file path (point at a file in `raw/` or anywhere on disk)
- Pasted text (Slack messages, email body, voice transcript)
- A directory (process all files in it)

## Before you start

1. **Read `project.md`** — confirm the project context, current stage, client name.
2. **Read `knowledge/index.md`** — load existing knowledge so you can detect contradictions.
3. **If `raw/` or `knowledge/` directories don't exist** — create them (with `comms/`, `docs/`, `feedback/` under `raw/` and `entries/` under `knowledge/`). Seed `knowledge/index.md` with the empty template from the scaffold. This handles projects scaffolded before the knowledge system existed.

## Step 1 — Classify the source

Determine the source type and file it:

| Type | Save to | Examples |
|------|---------|----------|
| `comms` | `raw/comms/` | Slack messages, emails, meeting notes, voice transcripts |
| `docs` | `raw/docs/` | Brand guides, PDFs, Word docs, spreadsheets, briefs |
| `feedback` | `raw/feedback/` | Revision requests, review notes, design comments, approval emails |

If the source is pasted text (not already a file), save it as a markdown file in the appropriate `raw/` subdirectory. Name it: `YYYY-MM-DD-short-description.md`.

If the source is already in `raw/`, do not move it — process it in place.

## Step 2 — Read and extract

Read the full source. Extract the following into structured sections:

- **Key decisions** — anything the client has decided or confirmed
- **Preferences** — style, tone, feature, or content preferences expressed
- **Content facts** — specific information about the business, products, services, people
- **Action items** — things the client is asking us to do or change
- **Open questions** — things that are unclear, ambiguous, or need follow-up

For each extracted item, note the exact quote or passage it came from (for traceability).

**Flag anything confusing, unclear, or seemingly incorrect** with an Obsidian callout:

```markdown
> [!question] Unclear
> Client said "[exact quote]" — this is ambiguous because [reason]. Needs clarification.
```

## Step 3 — Check for contradictions

Compare every extracted item against existing entries in `knowledge/entries/`. Look for:

- **Direct contradictions** — client previously said X, now says not-X
- **Preference shifts** — client expressed preference for A before, now leans toward B
- **Scope changes** — new requests that conflict with agreed scope or discovery brief
- **Factual conflicts** — different numbers, dates, names across sources

Flag each contradiction with an Obsidian callout:

```markdown
> [!warning] Contradiction
> Client previously said "[exact quote]" (source: [[entry-filename]])
> but now says "[exact quote]".
> **Resolution needed:** [describe what needs clarifying]
```

If the new information clearly supersedes the old (e.g., client explicitly changing their mind), note it as a supersession rather than a contradiction:

```markdown
> [!info] Updated
> Client changed position from "[old]" to "[new]" (supersedes [[entry-filename]]).
```

## Step 4 — Create knowledge entry

Create a new file in `knowledge/entries/` named: `YYYY-MM-DD-short-description.md`

Use this schema:

```markdown
---
title: Short descriptive title
source_type: comms | docs | feedback
source_file: relative path to file in raw/ (or "pasted text")
date_received: YYYY-MM-DD
date_processed: YYYY-MM-DD
from: who sent it (client name, or specific person for TAT e.g. "Greg Apps")
stage: current pipeline stage when ingested
tags: [relevant, tags]
---

## Summary
2-3 sentence overview of what this source contains and why it matters.

## Key Decisions
- Decision 1 — context and exact quote
- Decision 2 — context and exact quote

## Preferences
- Preference 1 — what they want and why
- Preference 2

## Content Facts
- Fact 1 — specific information extracted
- Fact 2

## Action Items
- [ ] Action 1 — what needs doing, for whom
- [ ] Action 2

## Open Questions
- Question 1 — what's unclear and why it matters
- Question 2

## Contradictions
(any contradictions flagged in Step 3, or "None detected.")

## Raw Quotes
> "Exact quote 1" — context
> "Exact quote 2" — context
```

## Step 5 — Update the index

Update `knowledge/index.md`:
- Add the new entry to **Recent Entries** (newest first)
- Add it under the appropriate **By Type** subsection (Comms / Docs / Feedback)
- If any contradictions were flagged, add them to **Unresolved Contradictions**
- If any open questions were found, add them to **Unresolved Questions**
- Update the `total_entries` count and `updated` date in frontmatter

Each entry in the index looks like:
```markdown
- [[YYYY-MM-DD-short-description]] — one-line summary (from: Client Name, type: comms)
```

## Step 6 — Cross-reference

Check if any extracted information should update other project files:
- **brand.md** — if the source contains brand decisions (colors, fonts, tone)
- **project.md** — if the source contains scope changes, timeline updates, or blocker resolutions
- **discovery-brief.md** — if the source adds or corrects discovery information

Do not auto-update these files. Instead, suggest them:

```
Cross-reference suggestions:
- brand.md — client confirmed primary color is #1E3A5F (currently placeholder)
- project.md — client approved Gate 1, update Approvals table
```

The user decides whether to apply these updates.

## Step 7 — Report

Print a summary:

```
Ingested: [title]
Source: [file path or "pasted text"]
Type: [comms/docs/feedback]
Entry: knowledge/entries/YYYY-MM-DD-short-description.md

Extracted:
  - X key decisions
  - X preferences
  - X content facts
  - X action items
  - X open questions
  - X contradictions flagged

Cross-reference suggestions: [list or "none"]
```

## Batch mode

When pointed at a directory, process each file individually (one entry per source). After all files are processed, print a batch summary showing total entries created and any contradictions across the batch.
