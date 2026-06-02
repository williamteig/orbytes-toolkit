---
title: "{{CLIENT_NAME}} — Brand Kit (Legacy)"
client: "{{CLIENT_NAME}}"
branding_source: "{{BRANDING_SOURCE}}"
updated: "{{DATE}}"
---

# Brand Kit (Legacy)

Use `design.md` as the canonical branding source for all new projects.

This file is kept only for backwards compatibility with older repos.

## Migration Map

- `brand.md` "Logo" -> `design.md` logo details in component + usage sections
- `brand.md` "Colour Palette" -> `design.md` `## Tokens — Colors`
- `brand.md` "Typography" -> `design.md` `## Tokens — Typography`
- `brand.md` "Assets" -> `design.md` `## Imagery`
- `brand.md` freeform notes -> `design.md` `## Do's and Don'ts`, `## Layout`, and `## Agent Prompt Guide`

## Rule

When both files exist, always treat `design.md` as source of truth.
