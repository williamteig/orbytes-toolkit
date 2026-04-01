---
description: Rules and gotchas for working with Figma — URLs, design context, branding assets. Apply when handling Figma links or design files.
alwaysApply: false
---

# Figma Rules

## URL Handling

**Gotcha — strip query params from Figma URLs.**
When a user pastes a Figma URL, it often includes node-specific params that point to a single frame rather than the whole file. Only store the base URL up to the file name slug.

```
# Raw (do not store)
https://www.figma.com/design/R5PLf3RJErDKIXqGLIswlM/My-Project?node-id=0-1&p=f&t=KLtFCmyHrlPZKtSD-0

# Clean (store this)
https://www.figma.com/design/R5PLf3RJErDKIXqGLIswlM/My-Project
```

URL pattern: `https://www.figma.com/design/{fileKey}/{fileName}`
- `fileKey` = the segment after `/design/`
- When using MCP tools, `nodeId` = `{int1}:{int2}` (replace `-` with `:` from the URL param)

## Design Philosophy

- Figma is the main source of truth when it comes to lightweight design mockups, design variables, and branding direction.
- The design that is live should always be reflected in Figma.
- Responsiveness and pixel-perfect accuracy is not the priority above getting the design right.
- The Figma URL for each client is stored in their Notion project page (`Figma URL` field)
