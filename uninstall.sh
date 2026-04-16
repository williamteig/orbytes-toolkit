#!/usr/bin/env bash
set -euo pipefail

TOOLKIT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CLAUDE_DIR="$HOME/.claude"
CLAUDE_COMMANDS_DIR="$CLAUDE_DIR/commands"
CLAUDE_SKILLS_DIR="$CLAUDE_DIR/skills"
CURSOR_DIR="$HOME/.cursor"
CURSOR_COMMANDS_DIR="$CURSOR_DIR/commands"
CURSOR_RULES_DIR="$CURSOR_DIR/rules"
CURSOR_SKILLS_DIR="$CURSOR_DIR/skills"

TARGET="claude"

usage() {
  echo "Usage: $0 [--target claude|cursor|all]"
  echo "  claude (default) — Remove ~/.claude/ symlinks from this toolkit"
  echo "  cursor           — Remove ~/.cursor/ symlinks from this toolkit"
  echo "  all              — Both"
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --target)
      shift
      TARGET="${1:-}"
      if [[ -z "$TARGET" ]]; then
        usage >&2
        exit 1
      fi
      shift
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      echo "Unknown option: $1" >&2
      usage >&2
      exit 1
      ;;
  esac
done

case "$TARGET" in
  claude|cursor|all) ;;
  *) echo "Invalid --target: $TARGET (use claude, cursor, or all)" >&2; exit 1 ;;
esac

echo ""
echo "  orbytes-toolkit uninstaller"
echo "  ==================================="
echo ""
echo "  Target: $TARGET"
echo ""

uninstall_claude() {
  echo "  [Claude Code] ~/.claude/"
  echo ""

  local GLOBAL_CLAUDE="$CLAUDE_DIR/CLAUDE.md"
  if [ -L "$GLOBAL_CLAUDE" ]; then
    rm "$GLOBAL_CLAUDE"
    echo "  - Removed global CLAUDE.md"
    if [ -f "${GLOBAL_CLAUDE}.pre-orbytes" ]; then
      mv "${GLOBAL_CLAUDE}.pre-orbytes" "$GLOBAL_CLAUDE"
      echo "    ↻ Restored previous CLAUDE.md"
    fi
  fi

  for cmd_file in "$TOOLKIT_DIR/global/commands"/*.md; do
    cmd_name="$(basename "$cmd_file")"
    target="$CLAUDE_COMMANDS_DIR/$cmd_name"
    if [ -L "$target" ]; then
      rm "$target"
      echo "  - Removed command: $cmd_name"
      [ -f "${target}.backup" ] && mv "${target}.backup" "$target" && echo "    ↻ Restored backup"
    fi
  done

  local CLAUDE_RULES_DIR="$CLAUDE_DIR/rules"
  for rule_file in "$TOOLKIT_DIR/global/rules"/*.md; do
    rule_name="$(basename "$rule_file")"
    target="$CLAUDE_RULES_DIR/$rule_name"
    if [ -L "$target" ]; then
      rm "$target"
      echo "  - Removed rule: $rule_name"
      [ -f "${target}.backup" ] && mv "${target}.backup" "$target" && echo "    ↻ Restored backup"
    fi
  done

  for skill_dir in "$TOOLKIT_DIR/global/skills"/*/; do
    skill_name="$(basename "$skill_dir")"
    target="$CLAUDE_SKILLS_DIR/$skill_name"
    if [ -L "$target" ]; then
      rm "$target"
      echo "  - Removed skill: $skill_name"
      [ -d "${target}.backup" ] && mv "${target}.backup" "$target" && echo "    ↻ Restored backup"
    fi
  done

  local CLAUDE_AGENTS_DIR="$CLAUDE_DIR/agents"
  for agent_file in "$TOOLKIT_DIR/global/agents"/*.md; do
    agent_name="$(basename "$agent_file")"
    target="$CLAUDE_AGENTS_DIR/$agent_name"
    if [ -L "$target" ]; then
      rm "$target"
      echo "  - Removed agent: $agent_name"
      [ -f "${target}.backup" ] && mv "${target}.backup" "$target" && echo "    ↻ Restored backup"
    fi
  done

  local CLAUDE_HOOKS_DIR="$CLAUDE_DIR/hooks"
  (
    shopt -s nullglob
    for hook_file in "$TOOLKIT_DIR/global/hooks"/*.sh "$TOOLKIT_DIR/global/hooks"/*.py; do
      [ -e "$hook_file" ] || continue
      hook_name="$(basename "$hook_file")"
      target="$CLAUDE_HOOKS_DIR/$hook_name"
      if [ -L "$target" ]; then
        rm "$target"
        echo "  - Removed hook: $hook_name"
        [ -f "${target}.backup" ] && mv "${target}.backup" "$target" && echo "    ↻ Restored backup"
      fi
    done
  )

  local ENV_FILE="$CLAUDE_DIR/.env"
  if [ -f "$ENV_FILE" ]; then
    grep -v "ORBYTES_TOOLKIT_PATH" "$ENV_FILE" > "${ENV_FILE}.tmp" || true
    mv "${ENV_FILE}.tmp" "$ENV_FILE"
  fi
}

uninstall_cursor() {
  echo "  [Cursor] ~/.cursor/"
  echo ""

  for cmd_file in "$TOOLKIT_DIR/global/commands"/*.md; do
    cmd_name="$(basename "$cmd_file")"
    target="$CURSOR_COMMANDS_DIR/$cmd_name"
    if [ -L "$target" ]; then
      rm "$target"
      echo "  - Removed command: $cmd_name"
      [ -f "${target}.backup" ] && mv "${target}.backup" "$target" && echo "    ↻ Restored backup"
    fi
  done

  for rule_file in "$TOOLKIT_DIR/global/rules"/*.md; do
    base="$(basename "$rule_file" .md)"
    rule_link_name="${base}.mdc"
    target="$CURSOR_RULES_DIR/$rule_link_name"
    if [ -L "$target" ]; then
      rm "$target"
      echo "  - Removed rule: $rule_link_name"
      [ -f "${target}.backup" ] && mv "${target}.backup" "$target" && echo "    ↻ Restored backup"
    fi
  done

  for skill_dir in "$TOOLKIT_DIR/global/skills"/*/; do
    skill_name="$(basename "$skill_dir")"
    target="$CURSOR_SKILLS_DIR/$skill_name"
    if [ -L "$target" ]; then
      rm "$target"
      echo "  - Removed skill: $skill_name"
      [ -d "${target}.backup" ] && mv "${target}.backup" "$target" && echo "    ↻ Restored backup"
    fi
  done
}

case "$TARGET" in
  claude) uninstall_claude ;;
  cursor) uninstall_cursor ;;
  all) uninstall_claude; uninstall_cursor ;;
esac

echo ""
echo "  ✓ orbytes-toolkit removed (target: $TARGET)"
echo ""
