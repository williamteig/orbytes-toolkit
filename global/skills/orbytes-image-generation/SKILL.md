---
name: orbytes-image-generation
description: Generate hyper-realistic, premium, on-brand photography for an orbytes client from the moodboard — select references from the inspiration library, build a structured prompt spec against design.md, and generate via Pixa (Nano Banana 2). Use when the user says "generate an image", "make a hero image", "create photography", "AI image", "Pixa", or wants to turn the moodboard into shippable imagery.
alwaysApply: false
---

# orbytes-image-generation — Moodboard-to-Imagery SOP

End-to-end process for turning a locked moodboard into **shippable** photography (heroes, section imagery, portraits) using AI image generation. This is the **downstream half** of the moodboard pipeline. Follow it literally; don't improvise.

**Pipeline:** locked moodboard + library → select references → build the prompt spec → generate (gate) → upscale + crop → ship.

Related: `orbytes-moodboard` (the upstream SOP that builds the reference pool), `inspiration.md` (library + copyright stance), `design.md` (the per-client constraint layer), `workflow.md` (Stage 3 Design).

---

## How this connects to the moodboard (read this first)

The moodboard is the **spec**; this skill is the **execution**. The connection is direct and two-way:

| Moodboard artifact | Role in generation |
|---|---|
| `discovery/inspirational-material/raw/<Collection>/*.jpg` | The **reference pool** — 2–3 are passed to the model as image attachments per shot |
| Each collection's `notes.md` ("what to take / NOT to take") | Source of the prompt's environment, treatment, and **hard-avoid** language |
| The three keyword sets from `orbytes-moodboard` Step 1 | Become the prompt's subject + aesthetic + negative layers |
| `design.md` (palette, type, do/don'ts) | The **constraint layer** — colour mapping and the "never spa/folksy/saturated" guardrails |

> **The provenance flip — the most important connection.** Library/Yandex references are **direction-only, never shipped** (unverified provenance). A **generated** image *is* cleared for live use, because under `inspiration.md` final assets may be "self-shot, properly licensed, **or AI-generated from the direction**." So this skill is exactly the bridge that converts un-shippable references into shippable assets. Generate *from* the references; never ship the references themselves.

Do not run this before a moodboard/library exists — without the reference pool and `design.md` you'd be inventing direction, which is the thing the moodboard process exists to prevent.

---

## Platforms

- **Pixa — primary, MCP-native.** Credit-based, already used across orbytes/TAT. For photoreal stills the default model is **Nano Banana 2** (Google). Confirm live choice with `models recommend` (it ranks Nano Banana 2 top for "professional photograph"). See [[pixa]] / the `Pixa MCP` memory. The connector UUID is **not stable across sessions** — it re-registers under a new `mcp__<uuid>__*` prefix each time, so load the tool schemas fresh via ToolSearch rather than assuming the old id.
- **Kling AI — complementary, no MCP.** Stronger filmic/emotive single-shot realism; weaker precise control. **No connector exists** (not in the registry, no official MCP as of 2026-06). Drive it manually in the web app or via a Kling API key if the client wants a side-by-side. Use the same prompt spec below; Kling has a real negative-prompt field, so split the avoids out instead of folding them in.

Run both on the same brief only when a comparison is wanted — they fail in opposite directions (Pixa = controllable/reference-faithful, Kling = filmic/less controllable). The winner becomes the template engine for the client's set.

---

## Step 1 — Select references from the library
Pick **2–3** images from the moodboard library and assign each a role. Nano Banana 2 exposes exactly three attachment slots (`image_0`, `image_1`, `image_2`). A reliable mapping:
- `image_0` → **pose / composition / emotional mood** (the closest on-theme scene)
- `image_1` → **skin + wardrobe treatment** (an Editorial Portraiture frame)
- `image_2` → **environment / architecture / quality of light** (an Interiors & Light frame)

Always instruct the model to use references as **direction only, do not copy faces** — otherwise it clones the (unverified-provenance) reference subject.

## Step 2 — Build the prompt spec (four locked layers)
Compress the moodboard + `design.md` into one prompt with four layers. This is the part that earns "picture-perfect / pro-photography / premium":

1. **Creative direction** — the one real decision: who the subject is and what they're doing, framed by the page's copy/intent. Decide the emotional register from `voice.md` (e.g. "quiet, tired, steady — not distressed, not smiling at camera"). Reserve negative space on one side for the headline overlay.
2. **Environment** — from Interiors & Light: materials, wall tone, single light source, negative space.
3. **Human treatment** — from Portraiture + Connection & Care: real unretouched skin, restrained wardrobe in brand-adjacent tones, emotional steadiness over intensity, no eye-contact-to-camera, no spa glow.
4. **Realism + premium levers** (the technical anchors):
   - **Camera:** medium-format look, 85mm, f/2.0–2.2, shallow-but-natural DOF
   - **Light:** single soft window light, gentle falloff
   - **Colour/film:** Kodak Portra 400, muted warm-neutral, low saturation, fine grain → map to the `design.md` hexes
   - **Texture:** natural skin texture, visible pores, no retouching, candid editorial
   - **Hard avoids** (from the keyword set 3 + `design.md` don'ts): plastic/waxy/over-smoothed skin, CGI/3D, HDR, over-saturation, deformed/extra fingers, text/watermark/logo, pastel, soft-focus spa glow, stock-photo smile, direct eye contact.

**Nano Banana 2 has no separate negative-prompt field** — fold the avoids into the prompt as an explicit `Avoid entirely: …` instruction sentence. (Kling *does* have a negative field — split them out there.)

## Step 3 — Confirm model + check credits (cost gate)
- `account credits` first. Nano Banana 2 is **30 credits/image**; upscale and extra variations cost more. Never batch.
- `models recommend` with the use case to confirm the current best photoreal model and its slots/aspect ratios.

## Step 4 — Upload references
`upload method:"upload_url"` returns a one-time curl-able URL per file (token expires ~900s). `curl -X POST -F 'file=@<path>' '<upload_url>'` each reference; capture the returned `asset_id`. If curl fails with a network error, the sandbox is blocking `*.pixelcut.ai` — tell the user to allowlist it (Settings → Capabilities → Network Egress).

## Step 5 — Generate ONE (gate), then poll
- `generate_media` with `model:"nano-banana-2"`, `media_type:"image"`, `aspect_ratio` (16:9 desktop hero; 4:5 or 9:16 mobile), `output_format:"jpg"`, **`num_variations:1`**, and the three `attachments` with their slot keys + asset_ids.
- **Cost discipline (hard rule):** one image at a time, **human gate before any revision or upscale**. Do not auto-iterate. ([[pixa]] cost rules.)
- Poll `get_job_status` with `sync:true` (blocks ~25s) until `completed`. Note `credits_consumed`.

## Step 6 — Download, save, review
- The generation's `url` field can come back empty — get the real file via `get_download_url` (asset_id) or curl the signed `assets.pixelcut.app` URL.
- **Save to `~/Downloads`** with a descriptive name: `<Client> - <Use> - Pixa NanoBanana v1.png` (output-handling rule).
- `Read` the file to view it. Evaluate honestly against the four stated requirements (realism / pro-photography / premium / style-guide) before presenting. Present the verdict + the saved path, and offer next steps — don't silently iterate.

## Step 7 — On approval only: finish for production
- **Upscale:** `edit_image action:"upscale" scale:"4"` (Nano Banana 2 generates ~1K, e.g. 1376×768 at 16:9; `resolution` is a model param **not** exposed through `generate_media`, so upscale is how you reach hero resolution — ~5500px wide at 4x).
- **Mobile crop:** regenerate the *same prompt* at `4:5` (or `9:16`) — a 16:9 hero crops badly on phones.
- File the approved asset into the client repo (e.g. `content/assets/` or the design folder), record it in `project.md`, and it's cleared for the Framer/Astro build.

---

## Gotchas (learned)
- **Connector UUID is per-session** — re-load Pixa tool schemas via ToolSearch each session; don't reuse a remembered `mcp__<uuid>` prefix.
- **No negative field on Nano Banana 2** — fold avoids into the prompt.
- **`resolution` (1K/2K/4K) isn't passed through `generate_media`** — it generates ~1K; reach hero res with `edit_image upscale`.
- **Empty `url` in the job result** is normal — resolve with `get_download_url`/`asset_id`.
- **References clone faces** unless you say "direction only, do not copy faces."
- **AI-generated ≠ reference** on provenance — generated is shippable, the Yandex refs are not (see the provenance flip above).

## Worked example — Nina Van Sant postpartum hero (2026-06-26)
- Input: locked 25-image moodboard + `design.md` (off-white `#FFFFF4` / charcoal `#494949` / sage `#AAC0AB`, Manrope; "high-trust clinical elegance, never spa/folksy").
- Refs (library → slots): `Connection & Care/postpartum-knit-by-window.jpg` → `image_0`; `Editorial Portraiture/woman-cream-shirt-sunlit.jpg` → `image_1`; `Scandinavian Interiors & Light/scandi-living-room-bright-daylight.jpg` → `image_2`.
- Creative call: **mother as subject, newborn's face turned away**, expression quiet/tired/steady — reads the page hook ("You are not failing. You are carrying a lot."); large soft-lit wall left of frame for the headline.
- `nano-banana-2`, 16:9, jpg, 1 variation, avoids folded in → **30 credits**, one pass, approved as-is. Output 1376×768 → upscale 4x for production + 4:5 mobile regen.
- Saved: `~/Downloads/Nina Van Sant - Postpartum Hero - Pixa NanoBanana v1.png`.
