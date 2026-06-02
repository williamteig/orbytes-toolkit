---
title: "{{CLIENT_NAME}} — Style Reference"
client: "{{CLIENT_NAME}}"
branding_source: "{{BRANDING_SOURCE}}"
updated: "{{DATE}}"
---

# {{CLIENT_NAME}} — Style Reference
> One-sentence aesthetic direction for the brand. Example: "Calm, high-trust modern minimalism with editorial whitespace and restrained contrast."

**Theme:** light

## Tokens — Colors

| Name | Value | Token | Role |
|------|-------|-------|------|
| Primary | `#000000` | `--color-primary` | Primary CTA, key accents |
| Secondary | `#222222` | `--color-secondary` | Supporting UI accents |
| Background | `#ffffff` | `--color-background` | Page background |
| Surface | `#f7f7f7` | `--color-surface` | Cards and section blocks |
| Text Primary | `#111111` | `--color-text-primary` | Headings and body |
| Text Secondary | `#666666` | `--color-text-secondary` | Captions and helper text |
| Border | `#e5e5e5` | `--color-border` | Dividers and outlines |
| Accent | `#000000` | `--color-accent` | Highlighted interactive states |

## Tokens — Typography

### Display
- **Family:** (required)
- **Substitute:** (required fallback)
- **Weights:** (e.g. 300, 400)
- **Role:** Large headlines only

### Body
- **Family:** (required)
- **Substitute:** (required fallback)
- **Weights:** (e.g. 400, 500)
- **Role:** Body copy, UI labels, buttons

### Optional Utility Face (mono / label / accent)
- **Family:** (optional)
- **Substitute:** (optional fallback)
- **Weights:** (optional)
- **Role:** Code, labels, metadata, or decorative usage only

### Type Scale

| Role | Size | Line Height | Letter Spacing | Token |
|------|------|-------------|----------------|-------|
| caption | 12px | 1.40 | 0 | `--text-caption` |
| body | 16px | 1.50 | 0 | `--text-body` |
| subheading | 20px | 1.35 | 0 | `--text-subheading` |
| heading | 32px | 1.20 | 0 | `--text-heading` |
| display | 48px | 1.10 | 0 | `--text-display` |

## Tokens — Spacing & Shapes

**Base unit:** 4px  
**Density:** comfortable

### Spacing Scale

| Name | Value | Token |
|------|-------|-------|
| 4 | 4px | `--spacing-4` |
| 8 | 8px | `--spacing-8` |
| 12 | 12px | `--spacing-12` |
| 16 | 16px | `--spacing-16` |
| 24 | 24px | `--spacing-24` |
| 32 | 32px | `--spacing-32` |
| 48 | 48px | `--spacing-48` |
| 64 | 64px | `--spacing-64` |

### Border Radius

| Element | Value |
|---------|-------|
| buttons | 9999px |
| cards | 16px |
| inputs | 8px |
| badges | 9999px |

### Shadows

| Name | Value | Token |
|------|-------|-------|
| subtle | `0 1px 2px rgba(0, 0, 0, 0.08)` | `--shadow-subtle` |
| card | `0 8px 24px rgba(0, 0, 0, 0.10)` | `--shadow-card` |

### Layout

- **Page max-width:** 1200px
- **Section gap:** 80px
- **Card padding:** 24px
- **Element gap:** 12px

## Components

### Primary Button
**Role:** Primary conversion action  
Describe exact background, text, radius, border, padding, and hover behavior.

### Secondary Button
**Role:** Secondary action  
Describe exact style and when to use it.

### Input Field
**Role:** Forms and lead capture  
Describe default, focus, and error states.

### Card
**Role:** Grouped content block  
Describe surface, border, radius, and spacing.

## Do's and Don'ts

### Do
- Use the approved token names in all implementation work.
- Keep CTA hierarchy consistent (one visual primary per section).
- Maintain whitespace rhythm from the spacing scale.

### Don't
- Do not introduce ad-hoc colors outside token definitions.
- Do not substitute typography without an explicit fallback mapping.
- Do not mix multiple elevation styles in one component family.

## Surfaces

| Level | Name | Value | Purpose |
|-------|------|-------|---------|
| 0 | Ground | `--color-background` | Page base |
| 1 | Surface | `--color-surface` | Cards and contained areas |
| 2 | Elevated | (token) | Priority modules and overlays |

## Elevation

Describe how depth is created (e.g. border-only, hairline shadows, layered shadows) and where each level is allowed.

## Imagery

Describe approved imagery style, texture, tone, and usage density (e.g. editorial photos, abstract illustrations, no stock clichés).

## Layout

Describe section flow, content density, hero composition, and common grid behavior.

## Agent Prompt Guide

### Quick Color Reference
- **Text (primary):** (value)
- **Background (primary):** (value)
- **CTA (primary):** (value)
- **Border (default):** (value)
- **Accent:** (value)

### Example Component Prompts
1. Create a hero section using the defined display scale, primary CTA, and surface rules.
2. Build a two-column feature block with card component spacing and typography tokens.
3. Build a contact form using the input component states and button hierarchy.

## Quick Start

### CSS Custom Properties

```css
:root {
  --color-primary: #000000;
  --color-secondary: #222222;
  --color-background: #ffffff;
  --color-surface: #f7f7f7;
  --color-text-primary: #111111;
  --color-text-secondary: #666666;
  --color-border: #e5e5e5;
  --color-accent: #000000;

  --font-display: "Display Font", "Times New Roman", serif;
  --font-body: "Body Font", "Inter", sans-serif;

  --text-caption: 12px;
  --text-body: 16px;
  --text-subheading: 20px;
  --text-heading: 32px;
  --text-display: 48px;

  --spacing-4: 4px;
  --spacing-8: 8px;
  --spacing-12: 12px;
  --spacing-16: 16px;
  --spacing-24: 24px;
  --spacing-32: 32px;
  --spacing-48: 48px;
  --spacing-64: 64px;
}
```

### Tailwind v4

Map the tokens above into your Tailwind theme layer (or equivalent) before component build starts.
