---
description: "QA agent for individual UI components. Tests interactive behaviour, visual states, and design fidelity for buttons, navigation, forms, cards, modals, and footers."
---

# QA Component Agent

Spawned by other commands and skills via the Agent tool to QA a single UI component in isolation. Tests interactive behaviour, visual states across breakpoints, and (when a Figma reference is provided) design fidelity against the approved mockup.

Use this agent any time you need to verify that a specific component works correctly before marking a task as done or moving on to the next component.

## Inputs

The spawning command/skill must provide:

| Input | Required | Description |
|-------|----------|-------------|
| `component` | Yes | Component name, CSS selector, or route path (e.g. `Navbar`, `.hero-cta`, `/components/modal`) |
| `componentType` | Yes | One of: `navigation`, `button`, `form`, `card`, `modal`, `footer` |
| `figmaUrl` | No | Base Figma file URL (no query params) |
| `figmaNodeId` | No | Node ID in `int1:int2` format pointing to the component frame |
| `breakpoints` | No | Array of widths to test. Defaults to `[375, 768, 1280]` |
| `devServerUrl` | No | URL if the dev server is already running. If omitted, the agent starts one. |

## Process

### 1. Setup

**Detect project type.** Read `package.json` at the project root. Determine the framework:

- `astro` in dependencies/devDependencies -> Astro (website project). Start with `npm run dev`.
- `next` in dependencies -> Next.js. Start with `npm run dev`.
- `svelte` or `@sveltejs/kit` in dependencies -> SvelteKit. Start with `npm run dev`.
- `expo` or `react-native` in dependencies -> React Native. Skip browser-based preview (report that this agent does not cover native components and stop).

Check whether Tailwind is present (`tailwindcss` in dependencies/devDependencies). Do not assume Tailwind is available in app projects.

**Start the dev server** if `devServerUrl` was not provided. Use `preview_start` with the appropriate dev command. Wait for the server to be ready by taking an initial `preview_screenshot` and confirming the page loads.

**Navigate to the component.** If the component input is a route path, navigate directly. Otherwise, navigate to the page where the component appears (usually `/` for navigation, footer, and hero components).

### 2. Visual States Check (Phase 4)

Test the component across each breakpoint using `preview_resize`. At each breakpoint, take a `preview_screenshot` and run `preview_inspect` on the component selector to verify computed styles.

#### 4.1 Navigation
- Logo is visible and links to `/` (verify with `preview_click` on the logo, confirm URL)
- Each nav link points to the correct destination (inspect `href` attributes with `preview_eval`)
- Active page indicator is present on the current page link
- Mobile menu (at 375px and 768px):
  - Hamburger/menu button is visible
  - `preview_click` on menu button -> menu opens, take screenshot
  - `preview_click` outside the menu -> menu closes
  - Reopen menu, then `preview_eval` to dispatch `Escape` keydown -> menu closes
  - Reopen menu, `preview_click` on a nav link -> menu closes and navigates

#### 4.2 Buttons
- Test every variant present (primary, secondary, ghost/outline) by locating them with `preview_eval`
- For each variant, verify with `preview_inspect`:
  - Default state: correct padding, border-radius, font-size, background-color
  - Hover state: `preview_eval` to dispatch `mouseenter`, take screenshot, confirm style change
  - Focus state: `preview_eval` to call `.focus()`, take screenshot, confirm visible focus ring
  - Active/pressed state (Phase 9.2): `preview_eval` to dispatch `mousedown`, take screenshot, confirm visual feedback distinct from hover
  - Disabled state (Phase 9.3): if a disabled variant exists, verify `opacity` is reduced or colour is muted, `cursor` is `not-allowed`, and `preview_click` does NOT trigger navigation or action
- Verify transition duration is between 150ms and 300ms via `preview_eval` reading `getComputedStyle(el).transitionDuration`

#### 4.3 Forms
- Each input field is present and matches expected sizing/styling
- Required fields are marked (check for `required` attribute or visual asterisk via `preview_inspect`)
- Validation states:
  - Submit the form empty -> error messages appear (Phase 9.4), take screenshot
  - Verify error styling (red border, error text colour)
  - `preview_fill` a required field with valid data -> error clears on that field (Phase 9.4)
- Submit with valid data:
  - `preview_fill` all fields with test data
  - `preview_click` submit button
  - Loading state (Phase 9.5): take rapid screenshots to capture spinner or disabled button during submission
  - Success state: confirm success message or redirect

#### 4.4 Cards
- Locate all cards in a row with `preview_eval` (`querySelectorAll`)
- Verify consistent heights across cards at each breakpoint (compare `offsetHeight` values)
- Check spacing between cards via `preview_inspect` (gap or margin)
- Verify content does not overflow (compare `scrollHeight` vs `clientHeight` with `preview_eval`)
- Hover effects: `preview_eval` to dispatch `mouseenter` on a card, take screenshot

#### 4.5 Footer
- All links are functional: `preview_eval` to collect every `<a>` in the footer, verify none have empty `href`
- Social media icons: verify `target="_blank"` and `rel="noopener noreferrer"` attributes via `preview_eval`
- Copyright year: `preview_eval` to read the footer text, confirm it contains the current year (2026)

#### 4.6 Modals
- Trigger the modal open action (`preview_click` on the trigger element), take screenshot
- Background scroll lock: `preview_eval` to check `document.body.style.overflow === 'hidden'` or equivalent
- Close on overlay click: `preview_click` on the overlay/backdrop area outside modal content -> modal closes
- Close on Escape: reopen modal, `preview_eval` to dispatch `Escape` keydown -> modal closes
- Focus trap: reopen modal, `preview_eval` to repeatedly call `document.activeElement` after Tab key dispatches, confirm focus stays within modal bounds

### 3. Interactive Behaviour Check (Phase 9)

These checks are woven into Phase 4 above but also run as a dedicated pass to catch anything missed:

#### 9.2 Active/Pressed States
- For every interactive element (buttons, links, cards with hover effects), verify `mousedown` produces a visual change distinct from the hover state.

#### 9.3 Disabled States
- Find all elements with `disabled` attribute or `.disabled` class via `preview_eval`.
- For each: verify visually muted appearance, `cursor: not-allowed`, and that `preview_click` produces no side effect.

#### 9.4 Error States
- For form components: already covered in 4.3. Additionally, verify that error messages disappear when the user corrects the input (fill valid data after triggering an error).

#### 9.5 Loading States
- For forms and buttons that trigger async actions: verify a loading indicator appears during submission and the trigger element is disabled until the action completes.

#### 9.6 Empty States
- For CMS-driven components (cards, lists, grids): use `preview_eval` to temporarily remove child content and take a screenshot. Verify the component handles the empty case gracefully (no layout collapse, shows a placeholder or informative message). Restore content after the check.

### 4. Design Comparison

Skip this section entirely if no `figmaUrl` was provided.

1. Use `get_screenshot` (Figma MCP) with the `figmaUrl` and `figmaNodeId` to capture the design reference.
2. Use `get_design_context` to pull spacing, colour, and typography tokens from the Figma node.
3. Take a `preview_screenshot` of the live component at the closest matching breakpoint.
4. Compare:
   - **Colours**: match background, text, and border colours against Figma tokens (allow minor rounding in hex values).
   - **Typography**: font-family, font-size, font-weight, line-height against Figma values.
   - **Spacing**: padding and margin within 2px tolerance of Figma values.
   - **Border radius**: within 1px tolerance.
   - **Layout**: element order and alignment match the design.
5. Flag any discrepancies as `warning` (within tolerance but not exact) or `fail` (outside tolerance or visually wrong).

### 5. Report

Output a structured report in this format:

```
## QA Report: {component} ({componentType})

**Project:** {project name from package.json}
**Framework:** {detected framework}
**Breakpoints tested:** {list}
**Figma comparison:** {Yes/No}

### Results

| # | Check | Status | Notes |
|---|-------|--------|-------|
| 4.1.1 | Logo links to homepage | PASS / FAIL / WARN | {details if not PASS} |
| 4.1.2 | Nav links correct | PASS / FAIL / WARN | |
| ... | ... | ... | ... |

### Summary

- **Pass:** {count}
- **Fail:** {count}
- **Warning:** {count}

### Failed Checks

{For each FAIL, include:}
- **{check number} — {check name}**
  - Expected: {what should happen}
  - Actual: {what happened}
  - Screenshot: {reference to the screenshot taken}

### Warnings

{For each WARN, include:}
- **{check number} — {check name}**
  - Detail: {what was slightly off}

### Design Discrepancies

{Only if Figma comparison was performed. List each discrepancy with the Figma value vs. live value.}
```

Only include the check rows relevant to the `componentType` being tested. For example, a `button` QA run should not include navigation or modal checks.

If all checks pass, end with: `All checks passed. Component is ready.`

If any checks fail, end with: `{count} check(s) failed. Review the failures above before proceeding.`
