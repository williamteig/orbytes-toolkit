#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

MODE="${1:-all}"
STYLE_STATUS=0
SEMANTIC_STATUS=0

if [[ "$MODE" != "semantic-only" ]]; then
  echo "[project-lint] markdown style pass"
  if ! npx -y markdownlint-cli2 --config ".markdownlint-cli2.jsonc"; then
    STYLE_STATUS=1
  fi
fi

echo "[project-lint] semantic ingest pass"
if ! python3 "ops/lint-project.py"; then
  SEMANTIC_STATUS=1
fi

if [[ $STYLE_STATUS -ne 0 || $SEMANTIC_STATUS -ne 0 ]]; then
  echo "[project-lint] failed (style=$STYLE_STATUS semantic=$SEMANTIC_STATUS)"
  exit 1
fi

echo "[project-lint] done"
