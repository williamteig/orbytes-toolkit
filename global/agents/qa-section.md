---
description: "QA agent for individual page sections. Compares a specific section against its Figma design, checks responsive behaviour, content accuracy, and visual fidelity. Use during development to verify the section you just built or modified."
---

# QA Section Agent

Performs focused QA on a single page section by comparing the running dev server against the Figma design. Checks design tokens, visual fidelity, responsive behaviour, content accuracy, and hover states — then produces a structured report with pass/fail results and screenshots.

## Inputs

The spawning command or skill must provide:

| Input | Required | Description |
|-------|----------|-------------|
| `section` | Yes | CSS selector, section name, or page + section index (e.g. `#hero`, `Hero`, `homepage:0`) |
| `figmaUrl` | No | Figma file URL (base URL, no query params). If omitted, design comparison steps are skipped and only functional/responsive checks run. |
| `figmaNodeId` | No | Specific Figma node ID for the section (e.g. `123:456`). If omitted, the agent will attempt to locate the section by name in the Figma file. |
| `devServerUrl` | No | URL of the running dev server. Defaults to `http://localhost:4321` for Astro projects or `http://localhost:3000` otherwise. |
| `projectType` | No | `website` or `app`. Auto-detected from `package.json` or project `CLAUDE.md` if omitted. |

## Process

### 1. Setup

1. **Detect project type.** Read `package.json` and the project `CLAUDE.md` to determine whether this is a website (Astro + Tailwind) or app project. This affects token verification in step 2.
2. **Start the dev server if not running.** Use `preview_start` to launch the dev server. If a `devServerUrl` was provided, use that. Otherwise detect the dev command from `package.json` scripts (`dev`, `start`, or `preview`).
3. **Resolve the section.** Navigate to the page containing the section. Use `preview_eval` to confirm the section element exists in the DOM using the provided selector or name. If the section cannot be found, report an error and stop.
4. **Fetch the Figma design.** Use `get_screenshot` to capture the target section from Figma. Use `get_design_context` to pull layout, spacing, and style data. If a `figmaNodeId` was provided, use it directly. Otherwise search the Figma file for a frame matching the section name.

### 2. Design Token Verification

#### 1.1 Colour palette

Extract all colours used in the section via `preview_eval` (computed styles on key elements). Compare against Figma variables fetched with `get_variable_defs`.

- **Website projects:** Also verify colours match the Tailwind config (`tailwind.config.*` or `theme` in `astro.config.*`). Check that elements use Tailwind colour classes rather than hard-coded values where possible.
- **App projects:** Check whatever token system is in use (CSS custom properties, theme file, styled-components theme, etc.).

#### 1.2 Typography

For every text element in the section, verify:
- Font family (correct font loaded, not falling back to system font)
- Font weight
- Font size
- Line height
- Letter spacing

Compare against values from Figma `get_design_context`. Use `preview_eval` to read `getComputedStyle()` on each text element.

#### 1.3 Spacing

Check padding, margins, and gaps within the section. Compare against Figma auto-layout values where available via `get_design_context`.

**Note:** Figma designs are sometimes mocked up without auto-layout, so spacing may be approximate. Flag discrepancies but do not hard-fail on non-auto-layout sections. Mark these as warnings rather than failures.

#### 1.4 Border radii and shadows

Extract `border-radius` and `box-shadow` values from key elements. Compare against Figma design values.

- **Website projects:** Verify values come from Tailwind utility classes.
- **App projects:** Verify values come from the project's token system.

### 3. Visual Fidelity

#### 2.1 Screenshot comparison

Capture the section at desktop width (1440px) from both sources:
- **Figma:** Use `get_screenshot` targeting the section node.
- **Dev server:** Use `preview_resize` to set viewport to 1440px wide, then `preview_screenshot` targeting the section element.

Compare structure, layout, and proportions — not pixel-perfect matching. Flag significant structural differences.

#### 2.2 Section spacing

Verify padding, margins, and gaps match the Figma design within a **4px tolerance**. Use `preview_eval` to measure computed box model values and compare against Figma `get_design_context` data.

#### 2.3 Typography rendering

Confirm the correct font is actually loaded (not a fallback). Use `preview_eval` to check `document.fonts.check()` for each font family used in the section. Verify weight, size, and colour match the design.

#### 2.4 Colour application

Verify backgrounds, text colours, border colours, and gradients match the Figma design. Use `preview_eval` to read computed colours and compare against Figma values. Allow minor rounding differences in RGB values (tolerance of 1 per channel).

#### 2.5 Image and media placement

Visually confirm that images are in correct positions with correct aspect ratios and are not stretched or cropped incorrectly. Use `preview_screenshot` to capture the section and compare against the Figma screenshot.

**Flag for human review** — automated comparison cannot reliably verify image content. Add to the report's human review section with screenshots from both sources.

#### 2.6 Icon consistency

Visually confirm that the correct icons are used and that they have the correct size and colour.

**Flag for human review** — icon verification requires visual judgement. Add to the report's human review section with screenshots.

### 4. Responsive Behaviour

Test at these breakpoints by using `preview_resize` for each width:

| Breakpoint | Width |
|------------|-------|
| Mobile | 375px |
| sm | 640px |
| md | 768px |
| lg | 1024px |
| Desktop | 1440px |

At each breakpoint, run the following checks:

#### 3.1 Layout transitions

Verify columns stack correctly and elements reflow as expected. Use `preview_screenshot` at each breakpoint and compare the structural layout against the Figma design (if responsive variants exist in Figma) or against reasonable responsive behaviour.

#### 3.2 Horizontal overflow

Use `preview_eval` to check whether `document.documentElement.scrollWidth > document.documentElement.clientWidth` at each breakpoint. Any horizontal overflow is a failure.

#### 3.3 Touch targets

At the mobile breakpoint (375px), use `preview_eval` to measure the bounding box of all interactive elements (`a`, `button`, `input`, `select`, `textarea`, `[role="button"]`) within the section. All interactive elements must be at least **44x44px**.

#### 3.4 Text readability

At the mobile breakpoint, verify:
- Body text is at least **16px** font size.
- Line length is reasonable (no single-line paragraphs spanning the full viewport).

Use `preview_eval` to read computed font sizes and measure text container widths.

#### 3.5 Image responsiveness

Verify images scale appropriately at each breakpoint. Check for:
- `srcset` attribute present on `<img>` elements.
- Appropriate `sizes` attribute.
- Images not overflowing their containers.

Use `preview_eval` to inspect image element attributes and computed dimensions.

### 5. Content Accuracy

#### 5.1 Text matches copy

Extract all visible text from the section using `preview_eval`. Extract text layers from the Figma section using `get_design_context`. Compare the two, flagging any differences in wording, spelling, or punctuation. Minor formatting differences (e.g. line breaks) are acceptable.

#### 5.2 Links

Use `preview_eval` to collect all `<a>` elements within the section and their `href` values. Verify:
- No empty `href` attributes.
- No links pointing to `#` (placeholder links) unless intentional.
- Internal links resolve (no 404s). Use `preview_eval` with `fetch()` to check status codes for internal links.

### 6. Component Spot-Check

For any interactive components within the section (buttons, forms, navigation elements, dropdowns, modals), perform a **visual check only**:

- Confirm the component renders correctly within the section context.
- Verify it matches the Figma design visually.
- Do NOT deep-test component behaviour (click handlers, form validation, state transitions). That is the responsibility of a dedicated `qa-component` agent.

Use `preview_screenshot` to capture components and compare against Figma.

### 7. Hover States

#### 9.1 Interactive element hover states

For each interactive element in the section (`a`, `button`, `[role="button"]`, elements with cursor pointer):

1. Use `preview_screenshot` to capture the element in its default state.
2. Use `preview_eval` to dispatch a `mouseenter` event, then capture again.
3. Verify a visible hover state exists (colour change, underline, scale, opacity shift, etc.).
4. If Figma hover variants are available (check via `get_design_context`), compare the hover state against the design.
5. Use `preview_eval` to check that `transition-duration` on the element is between **150ms and 300ms**. Values outside this range are a warning, not a failure.

### 8. Report

Generate a structured QA report with the following format:

```
## QA Report: [Section Name]

**Project type:** website | app
**Dev server:** [URL]
**Figma source:** [URL + node]
**Date:** [timestamp]

### Screenshots

[Screenshot at each breakpoint: 375px, 640px, 768px, 1024px, 1440px]

### Results

| # | Check | Status | Notes |
|---|-------|--------|-------|
| 1.1 | Colour palette | PASS / FAIL / WARN | ... |
| 1.2 | Typography tokens | PASS / FAIL / WARN | ... |
| 1.3 | Spacing tokens | PASS / FAIL / WARN | ... |
| 1.4 | Border radii & shadows | PASS / FAIL / WARN | ... |
| 2.1 | Screenshot comparison | PASS / FAIL / WARN | ... |
| 2.2 | Section spacing | PASS / FAIL / WARN | ... |
| 2.3 | Typography rendering | PASS / FAIL / WARN | ... |
| 2.4 | Colour application | PASS / FAIL / WARN | ... |
| 2.5 | Image/media placement | REVIEW | ... |
| 2.6 | Icon consistency | REVIEW | ... |
| 3.1 | Layout transitions | PASS / FAIL / WARN | ... |
| 3.2 | Horizontal overflow | PASS / FAIL | ... |
| 3.3 | Touch targets (≥44px) | PASS / FAIL | ... |
| 3.4 | Text readability | PASS / FAIL / WARN | ... |
| 3.5 | Image responsiveness | PASS / FAIL / WARN | ... |
| 5.1 | Text matches copy | PASS / FAIL | ... |
| 5.2 | Links | PASS / FAIL | ... |
| 6 | Component spot-check | PASS / FAIL / WARN | ... |
| 9.1 | Hover states | PASS / FAIL / WARN | ... |

### Failures

[For each FAIL, include:]
- Check number and name
- Expected value (from Figma)
- Actual value (from dev server)
- Screenshot showing the issue

### Items for Human Review

[For checks 2.5 and 2.6, include:]
- Side-by-side screenshots (Figma vs dev server)
- What to look for
- Any concerns noted by the agent

### Design Deviation Notes

[Intentional differences from Figma that should be discussed with the team:]
- Description of the deviation
- Why it may have been intentional (e.g. responsive adaptation, content change)
- Recommendation: keep, revert, or discuss

### Summary

- **Total checks:** [count]
- **Passed:** [count]
- **Failed:** [count]
- **Warnings:** [count]
- **Needs human review:** [count]
```

Present the report directly in the conversation. If any checks failed, summarize the most critical failures at the top of the report so the developer can prioritize fixes.
