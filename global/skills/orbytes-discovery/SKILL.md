---
name: orbytes-discovery
description: Process and analyse client discovery questionnaire responses for an orbytes web project. Use when a client has submitted their discovery answers, when starting discovery, or when the user mentions "discovery" for a client project.
---

This skill handles the orbytes client discovery process. The discovery questionnaire has 18 questions across 5 sections, delivered to clients via VideoAsk or Typeform. The client fills it out asynchronously — it takes them days, not minutes.

Your job is to **process the completed responses**, not administer the questionnaire live. Here's the workflow:

## Step 1 — Ingest responses
Look for the client's discovery responses in the project directory (could be a markdown file, PDF, pasted text, or raw export from VideoAsk/Typeform). Read everything available. If no responses are found, ask me to provide them.

Also read any qualification summary, emails, briefs, or existing website content that's been collected for this client.

## Step 2 — Analyse by section
Walk me through the responses section by section:

1. **Business Summary** (Q1-Q3) — Who they are, how clients find them, what differentiates them
2. **Business Goals** (Q4-Q6) — Why they need a site, desired visitor actions (primary/secondary/tertiary CTAs), success metrics
3. **Target Audience** (Q7-Q9) — Ideal customer profile, pain points, online behaviour
4. **Competitive Landscape** (Q10-Q12) — Competitors, strengths/weaknesses, inspiration sites
5. **Site Structure & Content** (Q13-Q18) — Pages needed, homepage messaging, social proof, brand tone, post-launch needs, asset inventory

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
