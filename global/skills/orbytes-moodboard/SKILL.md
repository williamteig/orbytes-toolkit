---
name: orbytes-moodboard
description: Build a photography moodboard for an orbytes client — derive image keywords from discovery + content writeup, research real references on Yandex Images, curate them into the inspiration library, and assemble a neat moodboard directly in the client's Figma file. Use post-discovery (Stage M), or when the user says "moodboard", "reference photography", or "research images".
alwaysApply: false
---

# orbytes-moodboard — Photography Moodboard SOP

End-to-end process for turning a finished discovery + content writeup into a real, client-facing photography moodboard in Figma. This is the standard procedure (Stage M). Follow it literally; don't improvise.

**Pipeline:** discovery & writeup → keyword sets → Yandex image research → curate & file in library → build the moodboard in Figma.

Related rules: `inspiration.md` (library structure + Yandex sourcing + delivery), `figma.md` (Figma = moodboard only), `workflow.md` (Stage M), `git.md`.

---

## When to run
- After discovery is processed and the content writeup / brief exists (`brief.md`, `voice.md`, `design.md`, discovery answers). Overlaps with Content/Branding; runs once enough direction exists.
- It is **not** an approval gate. The moodboard sets visual direction with the client before Design.

## Inputs (read first)
- `project.md` (always), `brief.md`, `voice.md`, `design.md`, and the discovery answers / knowledge entries.
- The point is to derive imagery direction from what the client actually said — never invent it.

---

## Step 1 — Extract three keyword sets
From discovery + brand, write down:
1. **Aesthetic / brand keywords** — the look (e.g. Scandinavian, editorial, restrained, premium, calm) + the palette hexes from `design.md` + brand touchstones the client named (fashion houses, sites they like).
2. **Subject keywords** — what the photos are *of* (audience segments, services, settings, location).
3. **Hard avoids** — what would be off-brand (e.g. spa softness, overt femininity, stocky energy, saturated colour).

Every later decision is checked against set 3.

## Step 2 — Define moodboard collections
Group the board into 3–5 themed collections so it reads as direction, not a dump. Typical set:
`Interiors & Light` · `Material & Still Life` · `Editorial Portraiture` (by audience segment) · `Connection & Care Scenes`. One Yandex query (or more) per collection.

## Step 3 — Research images on Yandex (primary engine)
Yandex returns a far broader, more characterful range of real-web/Pinterest imagery than stock libraries, and serves full results to a plain desktop-UA request (no CAPTCHA, as of 2026-06).

- Query: `https://yandex.com/images/search?text=<url-encoded>&isize=large` with a desktop User-Agent via `curl`.
- Parse `img_url=` params out of the HTML and **double-URL-decode** them → direct source URLs (mostly `i.pinimg.com`, which downloads cleanly with an `-e https://yandex.com/` referer).
- Run one query per collection (and per audience segment for people shots — young, old, intergenerational). Download a small pool each.
- **Reverse-image search** a frame the client likes to find more in the same vein.

## Step 4 — Curate (the part that matters)
- **Visually review every candidate.** Reject ruthlessly for:
  - Baked-in watermarks — Alamy, Bigstock, Vecteezy, Unsplash+, Shutterstock, Yandex "y" tiles, contributor tags.
  - Promo/meme text overlays, brand logos.
  - Off-brand styling (per the hard-avoids), and obvious AI-render artifacts unless the *mood* is the point.
  - Expect to reject ~50%+ of "people together / care" queries — those pull heavily from paid stock.
- **Normalise to true JPEG** — Yandex serves WebP/PNG mislabeled `.jpg`. Convert with `sips -s format jpeg in.jpg --out out.jpg` (also fixes WebP-as-jpg that breaks downstream tools).

## Step 5 — File in the library + commit
- Folder-per-collection under `discovery/inspirational-material/raw/<Collection>/`, descriptive filenames, a `notes.md` per collection (why it matters / what to take / what NOT to take / per-image source), and update `index.md`.
- Mark the locked set in `index.md` and check the inspiration item in `project.md`.
- Commit on a branch (never straight to main); scope the commit to the library — **never** sweep `.env`, `.mcp.json`, `Invoices/`, or `.DS_Store`.

> **Copyright stance — reference only, not final use.** Don't gate on provenance for the moodboard; these are *direction* references, used privately and to feed an AI image generator. The boundary that makes this OK: they are **never shipped to a live site**. Record provenance as unverified and flag the library direction-only. Final/published assets must be self-shot, properly licensed, or AI-generated from this direction.

## Step 6 — Build the moodboard in Figma
The moodboard's home is the client's Figma file (record the base URL in `project.md` as `moodboard_url`).

**Write capability — verify first.** Two different Figma MCPs exist:
- **Dev Mode server** (`127.0.0.1:3845/mcp`, tools `get_design_context`/`get_metadata`/`get_screenshot`/`get_variable_defs`/`get_figjam`) is **read-only** — it cannot create nodes or place images. Do not promise a build on this alone.
- The **write connector** exposes `use_figma` (runs Plugin API JS). This is the one that builds. Load the `figma-use` skill before calling it.

**If only Dev Mode is connected:** have the client multi-select-drag the image files onto the canvas (Figma auto-tiles), and paste a numbered key as a text layer. Then ask them to connect the write connector for an automated build.

**With `use_figma` (the build we standardised):**
1. Read the page with `get_metadata`; note the page id and any already-dropped image nodes (they're named by filename).
2. **Work incrementally — ≤ ~10 ops per call.** Build a skeleton first: a ground frame (brand off-white), title/subtitle, and the section-header text nodes at computed coordinates.
3. Place images in chunks of ~8: find each existing image node by name, move + `resize()` to a uniform cell (e.g. 320×400), set image fill `scaleMode:"FILL"` (uniform crop), `cornerRadius`, and create a numbered caption text node ("N · label") beneath. (If images aren't pre-dropped, `figma.createImageAsync(url)` from the source URLs — verify they're reachable first.)
4. Reparent every board node into the ground frame so it's one self-contained, movable unit.
5. **Verify with `get_screenshot`** and fix before finishing.

**Figma gotchas (learned):**
- Page context resets each `use_figma` call — `await figma.setCurrentPageAsync(page)` every time; `figma.currentPage = page` throws.
- Load `Inter` fonts before any text op. For Inter the styles are "Semi Bold"/"Extra Bold" (with a space), not "SemiBold".
- **`appendChild` does NOT preserve absolute position** — a node keeps its numeric x/y, now interpreted relative to the new parent. After reparenting into a frame at `(fx,fy)`, correct each child: `x += -fx; y += -fy` (i.e. subtract the frame's page origin). We hit this exactly: the grid jumped off-frame until we shifted children by the frame offset.
- Screenshotting a frame shows the frame + its children only — not unrelated siblings sitting on top. Reparent into the frame before screenshotting to verify the board.
- Colours are 0–1 range; fills are read-only arrays (clone + reassign).

## Output
A single self-contained moodboard frame on the client's Figma page: brand ground, four labelled sections, uniform image grid, numbered captions matching the library. Record `moodboard_url` in `project.md`.

---

## Worked example — Nina Van Sant (2026-06-26)
- Keywords: Scandinavian / editorial / restrained / premium / "top-tier care"; palette `#FFFFF4` / `#AAC0AB` / `#494949`; touchstones Loewe, Toteme, Strathberry, Westman Atelier, iittala. Avoids: spa, overt femininity, heart motifs, folksy/stocky.
- 25 references across 4 collections (Connection & Care expanded with 10 intergenerational young+old scenes); ~40 candidates rejected for watermarks/AI/off-brand.
- Built on the "Photography Moodboard" page, frame "Reference Moodboard v1 — Photography" (`10243:2`): 5-column grid, numbered captions, off-white ground.
- File: `https://www.figma.com/design/HaLsg4Pdl3iVDDaEgAFOHy/Nina-Van-Sant`.
