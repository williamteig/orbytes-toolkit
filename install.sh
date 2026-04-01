#!/usr/bin/env bash
set -euo pipefail

TOOLKIT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CLAUDE_DIR="$HOME/.claude"
CLAUDE_COMMANDS_DIR="$CLAUDE_DIR/commands"

echo ""
echo "  orbytes-claude-toolkit installer"
echo "  ================================"
echo ""

mkdir -p "$CLAUDE_COMMANDS_DIR"

GLOBAL_CLAUDE="$CLAUDE_DIR/CLAUDE.md"
if [ -L "$GLOBAL_CLAUDE" ]; then
  echo "  ↻ Updating: global CLAUDE.md"
  rm "$GLOBAL_CLAUDE"
elif [ -f "$GLOBAL_CLAUDE" ]; then
  echo "  ⚠ Backing up existing CLAUDE.md → CLAUDE.md.pre-orbytes"
  cp "$GLOBAL_CLAUDE" "${GLOBAL_CLAUDE}.pre-orbytes"
fi
ln -s "$TOOLKIT_DIR/global/CLAUDE.md" "$GLOBAL_CLAUDE"
echo "  ✓ Global CLAUDE.md symlinked"

echo ""
echo "  Installing commands..."
for cmd_file in "$TOOLKIT_DIR/commands"/*.md; do
  cmd_name="$(basename "$cmd_file")"
  target="$CLAUDE_COMMANDS_DIR/$cmd_name"
  if [ -L "$target" ]; then
    rm "$target"
    echo "    ↻ $cmd_name"
  elif [ -f "$target" ]; then
    mv "$target" "${target}.backup"
    echo "    ⚠ Backed up existing: $cmd_name"
  else
    echo "    + $cmd_name"
  fi
  ln -s "$cmd_file" "$target"
done

echo ""
echo "  Installing global skills..."
CLAUDE_SKILLS_DIR="$CLAUDE_DIR/skills"
mkdir -p "$CLAUDE_SKILLS_DIR"
for skill_dir in "$TOOLKIT_DIR/global/skills"/*/; do
  skill_name="$(basename "$skill_dir")"
  target="$CLAUDE_SKILLS_DIR/$skill_name"
  if [ -L "$target" ]; then
    rm "$target"
    echo "    ↻ $skill_name"
  elif [ -d "$target" ]; then
    mv "$target" "${target}.backup"
    echo "    ⚠ Backed up existing: $skill_name"
  else
    echo "    + $skill_name"
  fi
  ln -s "$skill_dir" "$target"
done

ENV_FILE="$CLAUDE_DIR/.env"
if [ -f "$ENV_FILE" ]; then
  grep -v "ORBYTES_TOOLKIT_PATH" "$ENV_FILE" > "${ENV_FILE}.tmp" || true
  mv "${ENV_FILE}.tmp" "$ENV_FILE"
fi
echo "ORBYTES_TOOLKIT_PATH=$TOOLKIT_DIR" >> "$ENV_FILE"

echo ""
echo "  ================================================"
echo "  ✓ Installation complete"
echo "  ================================================"
echo ""
echo "  Everything is symlinked, not copied."
echo "  To update across all projects, just run:"
echo ""
echo "    cd $TOOLKIT_DIR && git pull"
echo ""
echo "  Available commands:"
echo "    /task <id>              — Execute a pipeline task"
echo "    /task <description>     — Create a new pipeline task"
echo "    /new-orbytes-website    — Scaffold a website project"
echo "    /new-orbytes-app        — Scaffold an app project"
echo ""
echo "  To uninstall: $TOOLKIT_DIR/uninstall.sh"
echo ""
