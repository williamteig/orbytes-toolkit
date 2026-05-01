---
description: Orbytes coding standards — naming, commit style, formatting. Apply when writing or reviewing code.
alwaysApply: true
---

# Coding Standards

## Autonomy Slider

Match LLM autonomy to the task. This is non-negotiable — different work gets different leashes.

| Task type | Autonomy | How | Example |
|-----------|----------|-----|---------|
| Page scaffolds, boilerplate, file structure | **High** — let it rip | Agent mode, minimal review | Framer page scaffold, new component stubs |
| Framer code components, custom features | **Medium** — approaches first | Ask for 2-3 approaches with pros/cons before writing code | Code override, API integration |
| Auth, client data handling, payment flows | **Low** — you type the spec | Write exact spec, LLM types the code, review every line | Circle.so auth, Stripe, CMS sync |
| Client-facing copy, positioning, voice | **Low** — generate + curate | Generate 10-20 options, human picks and edits | Headlines, CTAs, brand messaging |
| Learning new tech (unfamiliar APIs, patterns) | **Tutor mode** — explain first | Ask LLM to explain, then implement yourself | New Framer API, unfamiliar CSS pattern |

**Default:** if unsure, start at Medium. You can always give more autonomy after the first pass. You can never un-ship bad code.

**Override:** when you're short on time and already know the domain well, say "just implement" to skip the explain/approach phase. The LLM should respect this without pushback.

## Code Quality

- Write clean, readable code with meaningful names — avoid abbreviations
- Commit messages should be concise and describe the "why" not just the "what"
- Use conventional commit format: `feat:`, `fix:`, `docs:`, `chore:`, `refactor:`
- All repos are private under the `williamteig` GitHub account
- Don't add comments unless the logic isn't self-evident
- Don't add error handling for scenarios that can't happen — only validate at system boundaries
- Don't create helpers or abstractions for one-time operations
- Prefer editing existing files over creating new ones
