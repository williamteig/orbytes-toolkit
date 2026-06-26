---
description: Client knowledge base ingestion and retrieval rules. Apply when processing client input, querying the knowledge base, or checking for contradictions.
alwaysApply: false
---

# Knowledge Base Rules

## Ingestion

- **One entry per source.** Each ingested file, email, or pasted message gets its own knowledge entry. Do not merge multiple sources into one entry.
- **Preserve exact quotes.** Always include the client's actual words, not just a paraphrase. Quotes are how contradictions get detected and resolved.
- **Flag, don't fix.** When a contradiction is detected, flag it with a callout. Do not silently resolve it by choosing one version. The user decides.
- **Chronological truth.** When a client clearly supersedes a prior statement ("actually, change it to green"), mark it as an update, not a contradiction. But only if the supersession is explicit.
- **Save raw first.** Always ensure the source material is saved in `raw/` before creating the knowledge entry. The entry references the raw file; if the raw file is missing, the entry has no provenance.

## Querying

- **Check knowledge before assuming.** Before writing copy, making design decisions, or answering questions about client preferences, check the knowledge base first.
- **Cite entries.** When using knowledge base information, reference the entry filename so the user can verify.
- **Surface conflicts.** If the knowledge base contains contradictory information on the queried topic, always surface both sides.

## Contradiction Detection

Contradictions are detected by comparing extracted items against existing entries. The comparison checks:

1. **Semantic opposition** — "we want a dark theme" vs "keep it light and airy"
2. **Factual conflict** — "our revenue is $2M" vs "we're a $5M company"
3. **Preference reversal** — "blue is our brand color" vs "we're thinking green now"
4. **Scope conflict** — "we only need 3 pages" vs "can you also add a blog and shop?"

When checking, read ALL existing entries in `knowledge/entries/` and scan for items in the same domain. The knowledge index helps narrow the search, but the entries themselves contain the detail.

## Cross-vault Context

- Williams 2nd Brain is at `/Users/williamteig/Documents/AppDev/Williams 2nd Brain/`
- Access it via the `orbytes-context-bridge` skill — never automatically
- Never modify the 2nd Brain from a client vault
- Never copy client-specific information into the 2nd Brain (it flows the other direction)

### TAT is now a standard orbytes client (retired 2026-06-26)

The former TAT bidirectional-knowledge exception was **retired** when the TAT business wound down. TAT is now maintained as a normal orbytes client — the one-way rule above applies to it like any other client. Historical TAT domain knowledge already in Williams 2nd Brain was archived under `archive/tat/`.
