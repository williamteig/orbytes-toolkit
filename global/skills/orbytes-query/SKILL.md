---
name: orbytes-query
description: Search the project knowledge base to answer questions about what the client said, decided, or requested. Use when the user asks "what did the client say about X?" or needs to look up prior client input.
---

Answer a question by searching the project's ingested knowledge base.

## How it works

1. **Read `knowledge/index.md`** — scan the entry list for relevant entries based on the question.
2. **Read relevant entries** from `knowledge/entries/` — prioritize entries whose title, tags, or summary relate to the question. Read the full entry, not just the summary.
3. **Also check** `discovery-brief.md`, `brand.md`, and `project.md` — these contain structured knowledge that may answer the question without needing raw entries.
4. **Synthesize an answer** — cite specific entries and quote the client where possible.

## Output format

```
Question: [the user's question]

Answer:
[synthesized answer with citations]

Sources consulted:
- [[entry-1]] — what it contributed
- [[entry-2]] — what it contributed
- discovery-brief.md — what it contributed (if used)

Confidence: high | medium | low
[If low, explain what's missing or uncertain]
```

## If nothing is found

If the knowledge base has no relevant entries:
1. Say so clearly — "No client input found on this topic."
2. Check if the topic is covered in `discovery-brief.md` or `brand.md` (these predate the ingestion system).
3. Suggest: "You may want to ask the client about this and ingest their response."

## Contradiction awareness

If the knowledge base contains contradictory information on the queried topic, surface both sides and flag it:

```
> [!warning] Conflicting information
> Entry [[A]] says X, but entry [[B]] says Y. This has not been resolved.
```

## Special queries

These queries have shortcut behavior:

- **"Any unresolved contradictions?"** — read the Unresolved Contradictions section of `knowledge/index.md` and list them.
- **"What action items are open?"** — scan all entries for unchecked action items (`- [ ]`) and list them.
- **"What questions need answering?"** — read the Unresolved Questions section of `knowledge/index.md` and list them.
- **"Summarize all knowledge"** — read the index and provide a high-level overview of what's been ingested, organized by type.
