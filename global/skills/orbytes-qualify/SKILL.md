---
name: orbytes-qualify
description: Walk a prospective orbytes client through the qualification checklist to determine package fit, readiness, and scope. Use when qualifying a new client, assessing project readiness, or the user says "qualify" a client.
---

Walk me through the orbytes client qualification checklist, one question at a time. For each point, ask the question, wait for my answer, then flag any implications before moving to the next.

Here is the checklist:

1. **Which package?** — Understand scope and budget tier.
2. **Has website copy written up?** Yes / No — If no, flag that copy needs to be written before or during discovery. This significantly affects timeline.
3. **Has logo, colour palette & fonts?** Yes / No — If no, ask whether they need the Softriver branding add-on.
4. **Has existing website?** Yes / No — If yes, note the URL for later audit. Ask what they like and dislike about it.
5. **Has photography or imagery?** Yes / No — If no, flag that stock photography or a shoot may be needed.
6. **Branding add-on (Softriver)?** Yes / No — Only ask if they answered No to Q3, otherwise skip.
7. **Hosting after launch:** Orbytes-hosted / Full handover — Explain the trade-offs briefly.

After all questions are answered, output a structured **Qualification Summary** in markdown with:
- Client name
- Package
- Readiness status for each point (ready / needs work / blocked)
- Estimated blockers or dependencies
- Recommended next step (e.g. "Proceed to discovery" or "Needs branding first")

**Save the summary** as `qualification-summary.md` in the project directory. If no project directory exists yet, hold the summary in your response — the scaffold step will create the directory and you (or the orchestrator) should save it then.

If any qualification answers can be determined from files already in the project directory (like a brief or email), read those first and pre-fill what you can, confirming with me.
