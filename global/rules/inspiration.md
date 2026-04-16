---
description: Inspiration ingestion and management for orbytes website projects. Apply when adding, reviewing, or referencing inspirational material.
alwaysApply: false
---

# Inspiration System

Every orbytes client project has a living inspiration library at `discovery/inspirational-material/`. This is one of the most important inputs to design and copy — it grows throughout the project.

## Structure

```
discovery/inspirational-material/
  index.md              # Master catalog — every inspiration summarised here
  raw/                  # One folder per inspiration
    <Name>/
      notes.md          # What it is, URL (if applicable), why it matters, what to take
      *.png / *.jpg     # Screenshots, renamed to descriptive names
    <Another Name>/
      notes.md
      *.png / *.jpg
```

## Ingestion Process

When the user sends new inspiration (images, links, notes, screenshots, or raw text):

1. **Create a folder** in `raw/` named after the inspiration (Title Case, spaces ok)
2. **Save images** into the folder with descriptive filenames:
   - `hero-section.jpg` not `nO8jkIop...XrJXk.jpeg`
   - `navigation-bar.png` not `Screenshot 2026-04-14.png`
   - Name describes what the image shows, not where it came from
3. **Create `notes.md`** in the folder with this template:

```markdown
# <Name>

**URL:** <link if applicable>
**Type:** website | brand | layout | animation | typography | photography | video | campaign | other
**Date added:** YYYY-MM-DD

## Why this matters
<1-3 sentences on why this was saved — what feeling, technique, or idea it represents>

## What to take
<Bullet points — specific, actionable things to learn from this>
- e.g. "Hero video autoplays on scroll, no sound — creates cinema feel without being intrusive"
- e.g. "Orange accent on dark background — similar energy to TAT brand"

## What NOT to take
<Optional — anything that doesn't fit the project>

## Screenshots
<Brief description of each image in the folder>
- `hero-section.jpg` — full-width hero with video background
- `pricing-cards.jpg` — 3-tier pricing layout with toggle
```

4. **Update `index.md`** — add an entry to the catalog table and update the relevant reference section (website, voice, video, etc.)
5. **Cross-reference** — if the inspiration directly informs a specific page's design or copy, note it in the relevant `content/<page>.md` file

## Reading Inspiration

When working on design, copy, or strategy:
- Read `index.md` first for the overview
- Read individual `notes.md` files for specific references
- Look at the images — they carry information that text cannot

## Principles

- **Never delete inspiration.** Even if it stops being relevant, it's part of the project history.
- **Rename images immediately.** Hash filenames are useless. Descriptive names mean the folder is scannable without opening every file.
- **Be specific in notes.** "Nice design" is worthless. "Section divider uses a single horizontal rule with 120px padding — creates breathing room without visual noise" is useful.
- **Flag contradictions.** If two inspirations pull in opposite directions, note it. That's a design decision waiting to happen.
