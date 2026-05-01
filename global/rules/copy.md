---
description: Copy process for orbytes website projects — voice, page strategy, drafting, and review. Apply when writing or reviewing website copy.
alwaysApply: false
---

# Copy Process

## Prerequisites

Before writing any copy, these must exist in the project:
- `voice.md` — tone, principles, references, what NOT to do
- `brand.md` — visual identity
- `brief.md` — business context, audience, goals, page list

If any of these are missing or thin, go back to discovery first. Copy without voice direction is guesswork.

## Step 1: Voice & Positioning

Create `voice.md` in the project root. This defines:
- Core positioning (what we're selling, what we're NOT selling)
- Voice references (real people/brands the client wants to sound like)
- Copy principles (person before product, one idea per section, emotion before logic, etc.)
- What NOT to do (generic language, soft punches, over-explaining)
- Key phrases from the client that should appear on the site
- Tone by page (different pages can have different emphasis)
- Visual copy rules (headline length, body copy length, white space)

**Source:** Client input — ask for tone references, writing styles they admire, phrases they use, language they hate. This is collaborative, not prescriptive.

## Step 1b: Perspective Testing

After discovery answers are in and before writing copy, stress-test the positioning by running the brief through three hostile lenses. Save the output in `discovery/perspective-test.md`:

1. **The Skeptical Customer** — *"You are a potential customer visiting this website for the first time. You're busy, you've seen a hundred sites like this, and you're looking for a reason to leave. What would make you bounce? What's missing? What feels generic?"*
2. **The Competitor** — *"You are a direct competitor analysing this positioning. Where is the weakness? What claim could you undercut? What's the real differentiator — or is there none?"*
3. **The Confused Outsider** — *"You are a first-time visitor who knows nothing about this industry. Read this positioning. What's confusing? What jargon makes no sense? What would you click — and what would you skip?"*

Run all three through the LLM. Then synthesise: what surfaced that you hadn't considered? Update `brief.md` and `voice.md` with anything that changed your thinking.

**This is not optional.** Perspective testing catches blind spots that no amount of internal brainstorming will find. It takes 10 minutes and saves weeks of revision.

## Step 2: Page Strategy

For each page, define the strategy BEFORE writing a single word. Save in the page's content file (`content/<page>.md`):

| Field | Question it answers |
|---|---|
| **Who lands here** | Traffic source — ad, social, internal link, SEO, direct? |
| **Their assumption** | What do they believe when they arrive? |
| **The shift** | What do we want them to believe when they leave? |
| **One action** | The single thing we want them to do |
| **The hook** | The first line they see — must stop the scroll |

No copy is written until the strategy is defined and feels right.

## Step 3: Section-by-Section Wireframe

Each page gets a section breakdown:
- Section name
- One-line purpose
- Headline (draft)
- Body intent (2-3 sentences — what this communicates, NOT full copy)
- CTA if applicable

This is a content wireframe, not design. The designer (usually William in Framer) handles layout and visual hierarchy later.

## Step 4: Draft Copy

Write actual copy section by section. Check every line against `voice.md`.

**Tests:**
- Would the client's voice references say this with a straight face?
- Is this the hardest, simplest version of this sentence?
- Could a competitor put this on their site unchanged? If yes, it's too generic.
- Is the biggest claim at the top of the page, not buried mid-scroll?

## Step 5: Review & Approval

Client reviews tone and messaging. This maps to **Approval Gate 1** (Content → Design) in the pipeline.

## Gap Protocol

If at any point during copy work you discover missing information — audience detail, product specifics, competitor positioning, pricing, tone direction — **stop and go back to discovery**. Flag the gap, ask the question, update `brief.md`, then resume.

Do not invent answers to fill gaps. Copy built on assumptions gets rewritten.
