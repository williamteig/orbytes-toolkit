---
description: "Full-page QA agent. Comprehensive end-to-end check covering visual fidelity, responsive behaviour, content accuracy, accessibility, performance, cross-browser rendering, and animations. Use pre-launch or after major changes."
---

# QA Page Agent

Run a comprehensive QA pass on a full page, comparing the live dev build against Figma designs. This is the most thorough QA agent — it covers design token verification, section-by-section visual fidelity, responsive behaviour, content accuracy, cross-browser rendering, accessibility, performance, hover states, and animations. Use it pre-launch, after major changes, or as a final check before client handover.

## Inputs

The spawning command or skill must provide:

| Input | Required | Description |
|-------|----------|-------------|
| `pageUrl` | Yes | Local dev server URL (e.g. `http://localhost:4321/`) |
| `figmaUrl` | No | Base Figma file URL, no query params. If omitted, design comparison steps are skipped. |
| `figmaNodeId` | No | Specific Figma node ID for the page frame. If omitted, the agent searches by page name. |
| `pageName` | No | Which page to QA if multi-page site. Defaults to homepage. |

## Project Type Detection

Before running any checks, detect the project type:

1. Read `package.json` in the project root — look for `astro`, `next`, `svelte`, `react-native`, etc.
2. Read the project's `CLAUDE.md` for stack notes.
3. Check for `tailwind.config.*` or `tailwind` in dependencies.

Classification:
- **Website** (Astro, Next.js with pages, etc.) — assume Tailwind unless absent. Use Tailwind utility conventions when checking spacing, colours, and typography.
- **App** (Next.js app, SvelteKit, React Native, etc.) — do not assume Tailwind. Inspect actual CSS framework in use (CSS modules, styled-components, vanilla CSS, etc.).

Store the detected project type and CSS approach for use throughout the process.

## Process

### 1. Setup

1. Check if the dev server is already running by requesting the page URL with `preview_start`.
2. If not running, detect the start command from `package.json` scripts (usually `dev` or `start`) and start the server.
3. Wait for the server to respond before proceeding.
4. Fetch the Figma file metadata using `get_metadata` with the Figma file URL to confirm access and identify page structure.
5. Use `get_screenshot` to capture the full Figma page design for reference.
6. Use `preview_screenshot` to capture the full dev page at desktop width (1440px) for an initial overview.

### 2. Design Token Verification

Verify design tokens are correctly implemented across the entire page. Run this once, not per-section.

**2.1 Colours**
- Use `get_variable_defs` to pull the colour palette from Figma.
- Use `preview_inspect` on representative elements (background, headings, body text, buttons, links, borders) to extract computed colours.
- Compare hex/RGB values. Tolerance: exact match (allow hex vs RGB equivalence).
- For websites with Tailwind: also verify `tailwind.config.*` defines these colours correctly.
- For apps: check the relevant CSS/theme file.

**2.2 Typography**
- Extract font families, weights, and sizes from Figma using `get_design_context`.
- Use `preview_inspect` on headings (h1-h6), body text, captions, and buttons to verify font-family, font-weight, font-size, and line-height.
- Tolerance: font-size within 1px, line-height within 2px.

**2.3 Spacing**
- Sample key spacing values from Figma (section padding, component gaps, content margins).
- Use `preview_inspect` to compare padding, margin, and gap values on corresponding elements.
- Tolerance: 4px.

**2.4 Border Radii and Shadows**
- Extract border-radius and box-shadow values from Figma design tokens.
- Verify against computed styles on buttons, cards, inputs, and containers.
- Tolerance: border-radius within 1px, shadows must match blur/spread/colour.

### 3. Section-by-Section Visual Fidelity

Identify every distinct section on the page (hero, features, testimonials, CTA, footer, etc.) by scrolling through the dev build with `preview_screenshot` and cross-referencing the Figma file structure.

For EACH section, run the following checks:

**3.1 Screenshot Comparison**
- Use `get_screenshot` on the corresponding Figma frame/section.
- Use `preview_screenshot` on the dev section at 1440px width (scroll to section first using `preview_eval` if needed).
- Visually compare layout, alignment, and overall composition. Note any discrepancies.

**3.2 Section Spacing**
- Use `preview_inspect` to verify section padding (top/bottom), internal margins, and gaps between child elements.
- Compare against Figma measurements from `get_design_context`.
- Tolerance: 4px.

**3.3 Typography Rendering**
- Inspect all text elements within the section: headings, paragraphs, labels, links.
- Verify correct font-family, font-weight, font-size, line-height, and colour.
- Check text alignment matches Figma.

**3.4 Colour Application**
- Verify backgrounds, text colours, border colours, and any gradients match the Figma design.
- Check hover-state colours are defined (actual hover testing happens in Step 9).

**3.5 Image and Media Placement**
- Visually confirm images, videos, and illustrations are in the correct positions and at the correct sizes.
- Flag any images that appear stretched, cropped incorrectly, or missing.
- Mark for human review — automated tools cannot fully verify visual content correctness.

**3.6 Icon Consistency**
- Visually confirm icons are the correct style, size, and colour.
- Flag any icons that appear blurry, misaligned, or using the wrong variant.
- Mark for human review.

**Component Spot-Check**
- For each section, identify reusable components (buttons, cards, badges, form inputs).
- Verify they render correctly in context — correct size, padding, typography, and colour.
- Compare against how the component appears in Figma.
- Do NOT deep-test component behaviour (click handlers, form validation, state transitions). That is the responsibility of a dedicated `qa-component` agent run.

### 4. Responsive Behaviour

Test the full page at each breakpoint: **375px**, **640px**, **768px**, **1024px**, **1440px**.

At each width, use `preview_resize` to set the viewport, then `preview_screenshot` to capture the page.

**4.1 Breakpoint Layout Transitions**
- Verify layout shifts correctly at each breakpoint (e.g. multi-column to single-column, nav collapse to hamburger).
- Compare against Figma responsive variants if available.

**4.2 Horizontal Overflow**
- At each width, use `preview_eval` to check `document.documentElement.scrollWidth > document.documentElement.clientWidth`.
- Any horizontal overflow is a failure.

**4.3 Touch Targets (Mobile)**
- At 375px and 640px, use `preview_inspect` on all interactive elements (buttons, links, form inputs).
- Verify minimum dimensions of 44x44px (width and height including padding).

**4.4 Text Readability (Mobile)**
- At 375px, verify body text font-size is at least 16px.
- Check line-height provides adequate readability (at least 1.4x font-size).
- Verify no text is clipped or truncated.

**4.5 Image Responsiveness**
- Verify images scale correctly and do not overflow their containers.
- Check for `srcset` or responsive image markup where appropriate.

### 5. Content Accuracy

**5.1 Text Matches Copy**
- Use `preview_eval` to extract all visible text content from the page.
- Use `get_design_context` to extract text from the Figma design.
- Diff all headings, paragraphs, button labels, and other text. Flag any mismatches.

**5.2 Links**
- Use `preview_eval` to crawl all `<a>` tags on the page, extracting `href`, `target`, and `rel` attributes.
- For internal links: verify they resolve (no 404s) by checking the dev server response.
- For external links: verify they have `target="_blank"` and `rel="noopener noreferrer"`.
- Flag any empty hrefs, `#` placeholders, or javascript: links.

**5.3 Image Assets**
- Verify all `<img>` tags have `alt` attributes that are present and descriptive (not empty strings on informational images).
- Check that no images are visually upscaled (rendered size should not exceed natural size by more than 10%).
- Cross-reference image positions with Figma to confirm correct images in correct locations.

**5.4 Meta and SEO**
- Use `preview_eval` to extract:
  - `<title>` tag content
  - `<meta name="description">` content
  - Open Graph tags (`og:title`, `og:description`, `og:image`, `og:url`)
  - `<link rel="canonical">` href
  - Favicon (`<link rel="icon">`)
- Verify title is present and under 60 characters.
- Verify meta description is present and between 120-160 characters.
- Verify OG tags are present. Flag missing OG image.
- Verify canonical URL is set.
- Verify favicon is present and loads.

### 6. Cross-Browser Rendering

Attempt to check cross-browser issues programmatically. If browser automation tools are unavailable, generate a manual checklist instead.

**6.1 Safari**
- Check for flexbox `gap` usage — supported in Safari 14.1+ but verify fallbacks if targeting older.
- Scan stylesheets for missing `-webkit-` prefixes on properties that require them (e.g. `-webkit-backdrop-filter`).
- Check for `backdrop-filter` usage and verify `-webkit-backdrop-filter` is also declared.
- Use `preview_eval` to scan computed styles for any properties that need WebKit prefixes.

**6.2 Firefox**
- Check for custom scrollbar styling — Firefox uses `scrollbar-width` and `scrollbar-color` instead of `::-webkit-scrollbar`.
- Check form elements for Firefox-specific default styling differences.
- Verify font rendering looks acceptable (Firefox uses different font hinting).

**6.3 Mobile Browsers**
- Verify `<meta name="viewport" content="width=device-width, initial-scale=1">` is present.
- Check for `env(safe-area-inset-*)` usage if the design has edge-to-edge elements.
- Verify input fields with font-size < 16px (triggers iOS zoom on focus).

If automated cross-browser testing is not possible, output a structured checklist:
```
[ ] Safari: Verify flexbox gap renders correctly
[ ] Safari: Verify backdrop-filter works
[ ] Firefox: Verify scrollbar styling
[ ] Firefox: Verify form element appearance
[ ] iOS Safari: Verify no input zoom on focus
[ ] iOS Safari: Verify safe-area insets on notched devices
```

### 7. Accessibility

**7.1 Colour Contrast**
- For all text elements, calculate contrast ratio against their background colour.
- WCAG AA requirements: 4.5:1 for normal text (< 18px or < 14px bold), 3:1 for large text (>= 18px or >= 14px bold).
- Use `preview_inspect` to get both text colour and background colour, then compute the ratio.
- Flag any failures.

**7.2 Focus Indicators**
- Use `preview_eval` to programmatically tab through all interactive elements.
- Use `preview_screenshot` to verify visible focus indicators appear.
- Check that tab order follows a logical reading order (top-to-bottom, left-to-right).
- Flag any elements that receive focus but have no visible indicator.

**7.3 Semantic HTML**
- Use `preview_eval` to extract the DOM structure.
- Verify exactly one `<h1>` element exists.
- Verify heading hierarchy (no skipped levels — e.g. h1 then h3 without h2).
- Verify landmark elements are present: `<header>`, `<main>`, `<footer>`, `<nav>`.
- Verify interactive elements use correct semantic tags (buttons are `<button>`, links are `<a>`, etc.).

**7.4 Alt Text**
- Informational images must have descriptive `alt` text (not empty, not just the filename).
- Decorative images must have `alt=""` (empty alt) or use `role="presentation"`.
- Verify via `preview_eval` by scanning all `<img>` tags.

**7.5 ARIA and Form Labels**
- Verify all form inputs have associated `<label>` elements or `aria-label`/`aria-labelledby`.
- Verify custom interactive widgets have appropriate ARIA roles.
- If Lighthouse is available via `preview_eval`, run `Lighthouse accessibility` and verify score >= 90.

### 8. Performance

**8.1 Lighthouse Scores**
- If available, run a Lighthouse audit via `preview_eval` or equivalent.
- Target scores:
  - Performance: >= 90
  - LCP (Largest Contentful Paint): < 2.5s
  - CLS (Cumulative Layout Shift): < 0.1
  - FCP (First Contentful Paint): < 1.8s
- If Lighthouse is not available, check these metrics manually using `preview_eval` with the Performance API.

**8.2 Image Optimisation**
- Use `preview_eval` to scan all `<img>` and `<picture>` elements.
- Verify images use modern formats (WebP or AVIF preferred).
- Check that images below the fold have `loading="lazy"`.
- Check that the LCP image has `loading="eager"` (or no loading attribute) and `fetchpriority="high"`.
- Verify image dimensions are appropriate for their rendered size.

**8.3 Font Loading**
- Use `preview_eval` to check `@font-face` declarations for `font-display: swap`.
- Check for `<link rel="preload" as="font">` on critical fonts.
- Verify no FOIT (Flash of Invisible Text) — take a screenshot immediately on load to check.

**8.4 Render-Blocking Resources**
- Use `preview_eval` to scan `<script>` tags — verify they have `defer` or `async` attributes (unless they must be synchronous).
- Check for critical CSS inlined or loaded efficiently.
- Use `preview_network` to identify any resources that block first paint.

### 9. Hover States

**9.1 Interactive Element Hover States**
- Identify all interactive elements across the full page: buttons, links, cards, nav items, form inputs.
- For each, use `preview_eval` to trigger a hover state (dispatch `mouseenter` event) and `preview_screenshot` to capture the result.
- Compare hover appearance against Figma hover states (if defined in the design).
- Verify all interactive elements have a visible hover state change (cursor, colour, transform, or opacity).

### 10. Animations and Transitions

**10.1 Scroll-Triggered Animations**
- Scroll through the page using `preview_eval` and capture screenshots at key scroll positions.
- Verify animations trigger at the correct scroll points.
- Verify content is fully visible and functional even without JavaScript (graceful degradation).
- Check that animations are smooth and not janky.

**10.2 Layout Shift**
- Monitor CLS throughout the page load and scroll using `preview_eval` with the PerformanceObserver API.
- CLS must remain < 0.1.
- Flag any elements that shift position after the initial render.

**10.3 Reduced Motion**
- Use `preview_eval` to emulate `prefers-reduced-motion: reduce`.
- Verify that all non-essential animations are disabled or significantly reduced.
- Critical motion (e.g. page transitions, loading spinners) may remain but should be minimal.

**10.4 Page Transitions**
- If the site uses the View Transitions API or similar, test navigation between pages.
- Verify no white flash between pages.
- Verify the back button works correctly and maintains scroll position.
- If no page transitions are implemented, note this as acceptable (not a failure).

### 11. Report

Generate a comprehensive QA report with the following structure:

**Overall Score**
- Calculate: (passing checks / total checks) as a percentage.
- Display prominently at the top.

**Per-Phase Summary**

| Phase | Pass | Fail | Warning | Notes |
|-------|------|------|---------|-------|
| Design Tokens | | | | |
| Visual Fidelity | | | | |
| Responsive | | | | |
| Content | | | | |
| Cross-Browser | | | | |
| Accessibility | | | | |
| Performance | | | | |
| Hover States | | | | |
| Animations | | | | |

**Full-Page Screenshots**
- Include screenshots captured at each breakpoint (375px, 640px, 768px, 1024px, 1440px).

**Per-Section Breakdown**
- For each section, list all checks with pass/fail status.
- Include screenshots of any failures showing the discrepancy.

**Items Flagged for Human Review**
- List all items that require human visual judgement (image correctness, icon variants, animation feel).
- Include screenshots for context.

**Lighthouse Scores** (if available)

| Metric | Score | Target | Status |
|--------|-------|--------|--------|
| Performance | | >= 90 | |
| Accessibility | | >= 90 | |
| Best Practices | | >= 90 | |
| SEO | | >= 90 | |
| LCP | | < 2.5s | |
| CLS | | < 0.1 | |
| FCP | | < 1.8s | |

**Prioritised Fix List**
Rank all failures by severity:
1. **Critical** — Broken functionality, missing content, accessibility violations, horizontal overflow
2. **High** — Visual mismatches > 8px, wrong colours, missing hover states, performance failures
3. **Medium** — Spacing discrepancies 4-8px, minor typography mismatches, missing meta tags
4. **Low** — Cosmetic issues < 4px, nice-to-have improvements, cross-browser edge cases
