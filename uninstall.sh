#!/usr/bin/env bash
set -euo pipefail

TOOLKIT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CLAUDE_DIR="$HOME/.claude"
CLAUDE_COMMANDS_DIR="$CLAUDE_DIR/commands"
CLAUDE_SKILLS_DIR="$CLAUDE_DIR/skills"

echo ""
echo "  orbytes-claude-toolkit uninstaller"
echo "  ==================================="
echo ""

# Remove global CLAUDE.md
GLOBAL_CLAUDE="$CLAUDE_DIR/CLAUDE.md"
if [ -L "$GLOBAL_CLAUDE" ]; then
  rm "$GLOBAL_CLAUDE"
  echo "  - Removed global CLAUDE.md"
  if [ -f "${GLOBAL_CLAUDE}.pre-orbytes" ]; then
    mv "${GLOBAL_CLAUDE}.pre-orbytes" "$GLOBAL_CLAUDE"
    echo "    ↻ Restored previous CLAUDE.md"
  fi
fi

# Remove commands
for cmd_file in "$TOOLKIT_DIR/commands"/*.md; do  cmd_name="$(basename "$cmd_file")"
  target="$CLAUDE_COMMANDS_DIR/$cmd_name"
  if [ -L "$target" ]; then
    rm "$target"
    echo "  - Removed command: $cmd_name"
    [ -f "${target}.backup" ] && mv "${target}.backup" "$target" && echo "    ↻ Restored backup"
  fi
done

# Remove skills
for skill_dir in "$TOOLKIT_DIR/global/skills"/*/; do
  skill_name="$(basename "$skill_dir")"
  target="$CLAUDE_SKILLS_DIR/$skill_name"
  if [ -L "$target" ]; then
    rm "$target"
    echo "  - Removed skill: $skill_name"
    [ -d "${target}.backup" ] && mv "${target}.backup" "$target" && echo "    ↻ Restored backup"
  fi
done

# Remove env var
ENV_FILE="$CLAUDE_DIR/.env"
if [ -f "$ENV_FILE" ]; then
  grep -v "ORBYTES_TOOLKIT_PATH" "$ENV_FILE" > "${ENV_FILE}.tmp" || true
  mv "${ENV_FILE}.tmp" "$ENV_FILE"
fi

echo ""
echo "  ✓ orbytes-claude-toolkit removed"
echo ""