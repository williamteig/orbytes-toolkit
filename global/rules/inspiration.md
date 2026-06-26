---
description: Inspiration ingestion and management for orbytes website projects. Apply when adding, reviewing, or referencing inspirational material.
alwaysApply: false
---

# Inspiration System

Every orbytes client project has a living inspiration library at `discovery/inspirational-material/`. This is one of the most important inputs to design and copy — it grows throughout the project.

## Library vs Moodboard

The inspiration **library** here is the *source*. The optional **Moodboard** (Stage M — see `workflow.md` and `figma.md`) is its consolidated visual *output*: one Figma canvas where the strongest references are splashed together **for the client** to agree a visual direction before Design. Material flows one way — gather into the library here, then pull selected references onto the moodboard. When a moodboard exists, its link is recorded in `project.md` as `moodboard_url`.

## Reference imagery sourcing (post-discovery) — STANDARD PROCEDURE

Once discovery is complete, proactively seed the inspiration library with reference photography pulled from the discovery + brand keywords. This is a standard step, not a bespoke one.

**Source: Yandex Images first.** Will's preferred engine — it returns a far broader, more characterful range of real-web/Pinterest imagery than stock libraries, and (as of 2026-06-26) serves full results to a plain desktop-UA request without a CAPTCHA, so no browser automation is needed.

Mechanics that work:
- Query `https://yandex.com/images/search?text=<url-encoded>&isize=large` with a desktop User-Agent via `curl`; parse `img_url=` params out of the HTML and double-URL-decode them to get direct source URLs (mostly `i.pinimg.com`, which downloads cleanly with a `yandex.com` referer).
- Run one query per moodboard category (interiors, texture/light, portraiture by audience segment, connection/care scenes, etc.), download a small pool each, then **visually review every candidate** before keeping it.
- **Always eyeball for watermarks** — Yandex surfaces a lot of paid-stock previews. Reject anything with baked-in marks (Alamy, Bigstock, Vecteezy, Unsplash+, Shutterstock, Yandex "y" tiles), promo/meme text overlays, brand logos, or off-brand styling. Also drop obvious AI-render artifacts unless the *mood* is what's wanted.
- Normalise files to true JPEG (Yandex serves WebP/PNG mislabeled `.jpg`; convert with `sips -s format jpeg`).
- Then file per the Ingestion Process below (folder-per-collection, `notes.md`, update `index.md`).

**Copyright stance — reference only, not final use.** For library/moodboard gathering, **do not gate on copyright or provenance** — these are *direction* references, used privately to set visual direction and to feed an AI image generator. This is a deliberate, Will-approved policy.
- **The boundary is what makes it OK:** these images are NEVER shipped to a live site. Record provenance as unverified and flag the library as direction-only.
- **Final/published assets** must be self-shot, properly licensed, or AI-generated from the direction. Carry that caveat into `index.md` and `project.md`.

Yandex **reverse-image search** is also useful — feed it a frame the client likes to find more in the same vein.

**Full pipeline:** the end-to-end procedure (discovery → keywords → Yandex research → curate → build the moodboard in Figma via `use_figma`) is documented as the **`orbytes-moodboard`** skill. Use it for the whole Stage-M build; this rule covers the library + sourcing details it relies on.

**Delivery format.** The moodboard's real home is the **client's Figma canvas** (Stage M) — place/curate references there when possible. For a portable hand-off or quick review, deliver a **lightweight PDF contact sheet** (e.g. built with Pillow from the library images, grouped by collection, on the brand ground). **Do not** deliver the moodboard as a standalone HTML page/artifact — it reads as heavy and is neither editable nor portable (Will's feedback, 2026-06-26). The individual image files always live in the repo so the client can drag them straight into Figma (Figma auto-tiles dropped images).

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
