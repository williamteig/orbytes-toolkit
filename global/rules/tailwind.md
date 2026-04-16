---
description: >-
  Tailwind CSS conventions for orbytes — utilities, config tokens, breakpoints aligned with Figma.
  Apply when styling website or design-system work that maps to Tailwind.
alwaysApply: false
---

# Tailwind CSS

## When this applies

Primarily **orbytes website** projects (Astro + Tailwind). App projects may use Tailwind too; follow the project’s config when it diverges.

## Conventions

- Prefer **utility classes** in markup; avoid `@apply` except for base layers or rare shared primitives.
- Define **brand colours, fonts, spacing, and radii** in `tailwind.config.*` from design tokens—not one-off hex in components.
- **Breakpoints** default to the Tailwind scale and align with **`figma-file-structure.md`** for design handoff:

| Token | Width |
|-------|-------|
| `sm` | 640px |
| `md` | 768px |
| `lg` | 1024px |
| `xl` | 1280px |
| `2xl` | 1536px |

- Use **mobile-first** modifiers (`sm:`, `md:`, …).
- Long-form CMS content: use `@tailwindcss/typography` **`prose`** where the project enables it.

## Figma alignment

Designers annotate **Tailwind-aligned** breakpoints unless a task specifies otherwise. When implementing, match tokens to `tailwind.config` theme—not arbitrary pixel values.

## Related rules

- **Website vs app path:** `dev-workflow.md`
- **Astro:** `astro.md`
- **Figma structure:** `figma-file-structure.md`
