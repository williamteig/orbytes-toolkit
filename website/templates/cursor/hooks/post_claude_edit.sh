#!/usr/bin/env bash
# Mirrors CLAUDE.md → .cursor/rules/project-context.mdc whenever CLAUDE.md is edited.
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
cd "$ROOT"

payload="$(cat)"

should_sync="$(
python3 - "$payload" <<'PY'
import json, re, sys
raw = sys.argv[1]
try:
    data = json.loads(raw) if raw.strip() else {}
except Exception:
    data = {"_raw": raw}
match = False
pattern = re.compile(r"(^|/)CLAUDE\.md$", re.IGNORECASE)
def walk(value):
    global match
    if isinstance(value, dict):
        for v in value.values(): walk(v)
    elif isinstance(value, list):
        for item in value: walk(item)
    elif isinstance(value, str):
        if pattern.search(value.strip()): match = True
walk(data)
print("sync" if match else "skip")
PY
)"

if [[ "$should_sync" == "skip" ]]; then
  exit 0
fi

target=".cursor/rules/project-context.mdc"
tmp="$(mktemp)"

{
  echo "---"
  echo "description: Auto-mirror of this project's CLAUDE.md. Do not hand-edit — updated by post_claude_edit.sh."
  echo "alwaysApply: true"
  echo "---"
  echo
  cat "CLAUDE.md"
} > "$tmp"

mv "$tmp" "$target"
exit 0
