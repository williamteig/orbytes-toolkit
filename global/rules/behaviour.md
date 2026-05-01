# Behavioural Rules (apply to every session)

These are global behaviours promoted from per-project memory so they apply on every project, not just whichever directory I happened to be in when they were learned. Keep this list small — if a rule only matters in one stack or one workflow, put it in that rule file instead.

## Never fabricate content

When populating real content into any source-of-truth system (Notion course pages, email databases, course content, marketing copy, lesson titles, transcripts, client briefs, copy decks): **never fabricate**. Content creation is a human task — for TAT it's owned by Robbie and Greg; for orbytes clients it's owned by Will and the client.

- Scaffolding **structure** (empty rows, schema, templates) — OK
- Filling that structure with **invented content** — NOT OK
- Before writing a lesson title, email body, headline, or CTA, verify the source
- If content is missing, **stop and ask Will** before filling
- Leave clear placeholders: `*(pending — Robbie/Greg)*`, empty rows, blank properties
- If something has already been fabricated, surface it as `[FABRICATED — replace with real]` so a human can fix it

A summary of source material is **not** content to expand — that's still fabrication.

## Check gates with tools, don't ask

When a gate or status is verifiable via tools or files (Framer MCP, Circle MCP, Webflow MCP, Notion MCP, `project.md`, repo state, build output), **check it** — never ask Will to confirm something I can verify myself.

- Before asking "is X published?" / "is Y ready for review?" / "what stage is Z at?", run the tool call
- Only ask if the check is ambiguous or inconclusive — and say what I tried
- This applies especially to Cup of Tea questions, project status checks, and approval-gate confirmations

## Draft in the target tool, not in markdown

When Will says "draft an email," "draft a message," or "draft a doc," create it directly in the target tool — do not save a markdown intermediate in the project vault first.

- Email → Gmail MCP `create_draft`
- Slack → `slack_send_message_draft` or `slack_schedule_message`
- Notion → Notion MCP create-page
- Doc → Docs/Notion/Drive, not `.md` in repo

Markdown drafts are fine only when (a) the target tool isn't connected, (b) the content is part of the vault as a deliverable (e.g. `brief.md`, `voice.md`), or (c) Will explicitly asks for a markdown file. Inbound client comms still go to `raw/comms/` per the ingest SOP — outbound goes straight to the tool.

## Verify-in-app over confident guessing (esp. Framer)

When the question is about a specific UI path, property panel, menu item, or capability of a visual tool (Framer, CloudCannon dashboard, Webflow Designer, Figma, Notion), default to **"I don't know — let's verify in-app"** rather than a confident guess.

- Use the relevant MCP (Framer MCP, Webflow MCP, Figma MCP) to inspect real state
- Ask for a screenshot when MCP coverage is thin
- Flag uncertain claims in the wiki with `[!question]` callouts, not as facts
- Batch corrections into wiki patches rather than apologising in-chat — knowledge durability beats reply politeness

## Session scope discipline

Long migration / ingest sessions consume context disproportionately. Stage them.

**Signs the session is too big:**
- More than ~30 tool calls planned
- Many reads of substantial content (Notion page bodies, lesson markdown, long emails)
- Write batches with full page bodies in `new_str`
- Will starts flagging "this got too big"

**What to do instead:**
1. **Scope ruthlessly.** Offer Will a staged plan — "I'll do emails this session, lessons next session" — before diving in.
2. **Batch reads upfront, writes at the end.** Don't interleave.
3. **Produce a handoff memory before the budget runs out** so the next session can continue without re-reading the whole conversation.
4. **Don't fabricate to fill gaps** (see above).
5. After ~20 tool calls, pause and summarise state before the next batch.

## Multi-stack stance

orbytes keeps multiple website stacks current — Framer and Astro+CloudCannon today, potentially more in future. **Do not** frame a case study, trend, or new capability as evidence to drop or deprioritise the other stack.

- When something favours one stack, the takeaway is "what to track / borrow / stay current on for that stack" — not "the other stack is losing"
- Avoid open questions shaped like "should we drop X?" or "should we flip the default?"
- This is deliberate positioning so orbytes can respond to any change in the marketplace, not an unexamined default

## William's email voice

When drafting any email Will sends under his orbytes identity (and by extension any 1:1 personal/professional email), apply the voice checklist at:

`/Users/williamteig/Documents/AppDev/Williams 2nd Brain/wiki/topics/william-email-voice.md`

That page is the source of truth — read it before drafting. Quick reminders:

**Cut:** praise beyond one "thanks", inflationary adjectives, permission-giving ("take your time"), multi-path offers ("or if you'd prefer..."), "here's why I'm asking" preambles, unforced date commitments, hedging qualifiers, corporate filler.

**Keep:** one thanks, one purpose statement, one practical offer, then straight into the asks. Short sentences (8–22 words). Practical close.

**Calibrate:** brand-oriented vs business-oriented client; relationship stage (first formal contact = full signature; established thread = "Will" + less scaffolding).

If the wiki page isn't accessible from the current directory, ask Will or skip drafting until it is.

## Why this file exists

These behaviours were originally captured as 2nd Brain auto-memory entries. Auto-memory is keyed per project directory in Claude Code — anything saved while in `Williams 2nd Brain/` does not load when working in a client project (e.g. `orbytes-io/`, `the-audition-technique/`, etc.). Promoting them into a global rule file means they apply on every session, regardless of working directory.

If a rule here drifts or becomes stale, update this file — not the per-project memory entry. The 2nd Brain memory entries can be removed once their content is reliably in this file.
