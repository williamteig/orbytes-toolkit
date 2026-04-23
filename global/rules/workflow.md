---
description: Orbytes client project workflow — approval gates, stage order, service tiers. Apply when managing or discussing client project progress.
alwaysApply: false
---

# Client Workflow Rules

## Process Discipline (applies to all orbytes work — not just clients)

**No freelancing.** If a strict process exists for the task — a Claude Code skill, a rule file, a documented workflow in this toolkit — follow it literally.

If no strict process exists for a sustained, multi-step task, **stop and tell Will** rather than improvising. Then either: (a) find an existing process, (b) adapt an existing one together, or (c) build a new skill/rule before proceeding.

Where to check before starting a non-trivial task:

- `.agents/skills/` in the project root (Claude Code skills — e.g. `cloudcannon-agent-skills` on Astro projects)
- `.claude/skills/` (symlinks into the above)
- `orbytes-toolkit/global/skills/` for orbytes-specific skills (`orbytes-scaffold`, `orbytes-ingest`, `orbytes-query`, `orbytes-qualify`, `orbytes-discovery`)
- This file and the other `rules/*.md`
- The user-invocable skills list surfaced by the harness each session

Small mechanical tasks (one-file edits, simple fixes, answering questions) don't need a formal process. This rule targets sustained workflows — migrations, scaffolds, audits, multi-file architectural changes. When in doubt, surface it to Will before proceeding.

## Stage Order

Never skip stages or begin a later stage before the prior approval gate is passed:

- **Stage X — Branding** (optional, runs in parallel, must complete before Design)
- **Stage 1 — Research & Discovery**
- **Stage 2 — Content Writeup + Sitemap** → ✅ Approval Gate 1
- **Stage 3 — Design** (Figma — lightweight, homepage + one page max) → ✅ Approval Gate 2
- **Stage 4 — Development** (implementation — typically **Astro + Tailwind** for sites; **Webflow** only when that engagement includes a Webflow build) → ✅ Approval Gate 3
- **Stage 5 — Launch & Handover**

## Key Rules

- Three approval gates only — after copy, after design, after development
- `project.md` is the source of truth — always read it before starting work
- Branding (Softriver) is always whitelabeled — never mention Softriver to clients
- Figma design is intentionally lightweight — site implementation defaults to the stack chosen in `project.md` (Astro, Framer, or Webflow)
- The qualification form lives on external platforms — project repo is only created once a client is qualified

## Service Tiers

- **Landing Page** — Fixed price, single page
- **Full Website** — Multi-page + CMS, fixed price
- **Custom Build** — Enterprise, technical integrations, custom scope

## Handover: Vault as Deliverable

At project completion, the client receives the **project vault** alongside the website. The vault contains:
- `project.md` — full project record
- `brand.md` — brand kit (colours, fonts, voice)
- `voice.md` — tone and positioning
- `brief.md` — business context and audience
- `discovery/` — all discovery material, inspiration, perspective tests
- `content/` — page strategies and approved copy
- `knowledge/` — knowledge base entries (if applicable)

**Why:** The vault is the blueprint for the client's ongoing AI assistant. They can feed it to any LLM and get context-aware help with their site, their brand, and their content — long after the project ends. This is not documentation; it is a **malleable tool** that keeps working.

## Security: Lethal Trifecta Check

Before deploying any agent or automation that touches client data, check for all three conditions:

1. ⚠️ Does it access **private client data**? (discovery answers, financials, credentials)
2. ⚠️ Does it process **untrusted input**? (user questions, pasted content, form submissions)
3. ⚠️ Can it **communicate externally**? (send emails, call APIs, trigger webhooks)

If all three are present → **raise a warning.** Inform the client of the risk and document the decision. This is an alert, not a hard gate — unless the client specifically requests a gate.

If only 1-2 are present → proceed with awareness. Log which conditions apply in `project.md`.

## Learning Protocol

When working with unfamiliar technology, the default is **explain first, then implement:**

1. LLM explains the approach, the API, the pattern — in plain language
2. William reviews, asks questions, builds understanding
3. Then implementation proceeds

**Override:** If William says "just implement" or "I'm short on time," skip the explanation and go straight to code. No pushback, no "are you sure" — respect the override immediately. The learning phase can happen later via code review.
