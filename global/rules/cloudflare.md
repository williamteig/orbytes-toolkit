---
description: >-
  Cloudflare — Pages, Workers, env vars, secrets, and previews for orbytes deployments.
  Apply when deploying sites or edge code to Cloudflare.
alwaysApply: false
---

# Cloudflare

## When this applies

Projects deployed to **Cloudflare Pages**, **Workers**, or related edge products (D1, KV, R2, etc.) per client setup.

## Pages (static / SSR)

- Connect the **correct GitHub repo and branch**; production vs preview branches should match the client’s workflow (`main` + feature branches).
- **Preview deployments** are the default sanity check before promoting to production.
- **Custom domains** and **HTTPS** live in the Cloudflare dashboard—document canonical URLs in `project.md`, not only in dashboard UI.

## Workers and bindings

- **Secrets** (`wrangler secret`, dashboard secrets): never commit secret values; reference binding **names** in code only.
- **Bindings** (KV, D1, R2, etc.): declare in Wrangler config; verify in staging before relying in production.

## Environment

- **Vars** for non-secret config (public URLs, feature flags) can live in Wrangler or env-specific config—keep parity with how the project documents env in `README` / `project.md`.
- Prefer **separate** preview vs production values; never reuse production secrets in preview.

## Observability

- Use **Workers Logs / Observability** (or project-standard tooling) for debugging production issues; capture **request IDs** when escalating.

## Related rules

- **Git / PR:** `git.md`
- **Astro** (when built to Pages): `astro.md`
