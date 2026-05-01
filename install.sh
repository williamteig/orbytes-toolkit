#!/usr/bin/env bash
set -euo pipefail

TOOLKIT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CLAUDE_DIR="$HOME/.claude"
CURSOR_DIR="$HOME/.cursor"

TARGET="claude"

usage() {
  echo "Usage: $0 [--target claude|cursor|all]"
  echo "  claude (default) — Symlink into ~/.claude/ (Claude Code)"
  echo "  cursor           — Symlink into ~/.cursor/ (Cursor IDE)"
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

install_claude() {
  local CLAUDE_COMMANDS_DIR="$CLAUDE_DIR/commands"

  echo ""
  echo "  [Claude Code] ~/.claude/"
  echo "  -------------------------"
  echo ""

  mkdir -p "$CLAUDE_COMMANDS_DIR"

  local GLOBAL_CLAUDE="$CLAUDE_DIR/CLAUDE.md"
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
  for cmd_file in "$TOOLKIT_DIR/global/commands"/*.md; do
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
  echo "  Installing global rules..."
  local CLAUDE_RULES_DIR="$CLAUDE_DIR/rules"
  mkdir -p "$CLAUDE_RULES_DIR"
  for rule_file in "$TOOLKIT_DIR/global/rules"/*.md; do
    rule_name="$(basename "$rule_file")"
    target="$CLAUDE_RULES_DIR/$rule_name"
    if [ -L "$target" ]; then
      rm "$target"
      echo "    ↻ $rule_name"
    elif [ -f "$target" ]; then
      mv "$target" "${target}.backup"
      echo "    ⚠ Backed up existing: $rule_name"
    else
      echo "    + $rule_name"
    fi
    ln -s "$rule_file" "$target"
  done

  echo ""
  echo "  Installing global skills..."
  local CLAUDE_SKILLS_DIR="$CLAUDE_DIR/skills"
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

  echo ""
  echo "  Installing global agents..."
  local CLAUDE_AGENTS_DIR="$CLAUDE_DIR/agents"
  mkdir -p "$CLAUDE_AGENTS_DIR"
  for agent_file in "$TOOLKIT_DIR/global/agents"/*.md; do
    agent_name="$(basename "$agent_file")"
    target="$CLAUDE_AGENTS_DIR/$agent_name"
    if [ -L "$target" ]; then
      rm "$target"
      echo "    ↻ $agent_name"
    elif [ -f "$target" ]; then
      mv "$target" "${target}.backup"
      echo "    ⚠ Backed up existing: $agent_name"
    else
      echo "    + $agent_name"
    fi
    ln -s "$agent_file" "$target"
  done

  echo ""
  echo "  Installing global hooks..."
  local CLAUDE_HOOKS_DIR="$CLAUDE_DIR/hooks"
  mkdir -p "$CLAUDE_HOOKS_DIR"
  (
    shopt -s nullglob
    for hook_file in "$TOOLKIT_DIR/global/hooks"/*.sh "$TOOLKIT_DIR/global/hooks"/*.py; do
      [ -e "$hook_file" ] || continue
      hook_name="$(basename "$hook_file")"
      target="$CLAUDE_HOOKS_DIR/$hook_name"
      if [ -L "$target" ]; then
        rm "$target"
        echo "    ↻ $hook_name"
      elif [ -f "$target" ]; then
        mv "$target" "${target}.backup"
        echo "    ⚠ Backed up existing: $hook_name"
      else
        echo "    + $hook_name"
      fi
      ln -s "$hook_file" "$target"
    done
  )

  local ENV_FILE="$CLAUDE_DIR/.env"
  if [ -f "$ENV_FILE" ]; then
    grep -v "ORBYTES_TOOLKIT_PATH" "$ENV_FILE" > "${ENV_FILE}.tmp" || true
    mv "${ENV_FILE}.tmp" "$ENV_FILE"
  fi
  echo "ORBYTES_TOOLKIT_PATH=$TOOLKIT_DIR" >> "$ENV_FILE"
}

install_cursor() {
  local CURSOR_COMMANDS_DIR="$CURSOR_DIR/commands"
  local CURSOR_RULES_DIR="$CURSOR_DIR/rules"
  local CURSOR_SKILLS_DIR="$CURSOR_DIR/skills"

  echo ""
  echo "  [Cursor] ~/.cursor/"
  echo "  --------------------"
  echo ""

  mkdir -p "$CURSOR_COMMANDS_DIR" "$CURSOR_RULES_DIR" "$CURSOR_SKILLS_DIR"

  echo "  Installing commands..."
  for cmd_file in "$TOOLKIT_DIR/global/commands"/*.md; do
    cmd_name="$(basename "$cmd_file")"
    target="$CURSOR_COMMANDS_DIR/$cmd_name"
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
  echo "  Installing rules (as .mdc)..."
  for rule_file in "$TOOLKIT_DIR/global/rules"/*.md; do
    base="$(basename "$rule_file" .md)"
    rule_link_name="${base}.mdc"
    target="$CURSOR_RULES_DIR/$rule_link_name"
    if [ -L "$target" ]; then
      rm "$target"
      echo "    ↻ $rule_link_name"
    elif [ -f "$target" ]; then
      mv "$target" "${target}.backup"
      echo "    ⚠ Backed up existing: $rule_link_name"
    else
      echo "    + $rule_link_name"
    fi
    ln -s "$rule_file" "$target"
  done

  echo ""
  echo "  Installing skills..."
  for skill_dir in "$TOOLKIT_DIR/global/skills"/*/; do
    skill_name="$(basename "$skill_dir")"
    target="$CURSOR_SKILLS_DIR/$skill_name"
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

  # Link frontend-design skills from ~/.agents/skills/ (installed by the impeccable/frontend-design plugin)
  if [ -d "$HOME/.agents/skills" ]; then
    echo ""
    echo "  Linking frontend-design skills from ~/.agents/skills/..."
    for skill_dir in "$HOME/.agents/skills"/*/; do
      skill_name="$(basename "$skill_dir")"
      target="$CURSOR_SKILLS_DIR/$skill_name"
      if [ -L "$target" ]; then
        rm "$target"
        echo "    ↻ $skill_name"
      elif [ -d "$target" ]; then
        echo "    ~ $skill_name (real dir, skipping)"
      else
        echo "    + $skill_name"
        ln -s "$skill_dir" "$target"
      fi
    done
  fi
}

echo ""
echo "  orbytes-toolkit installer"
echo "  ================================"
echo ""
echo "  Target: $TARGET"
echo ""

case "$TARGET" in
  claude) install_claude ;;
  cursor) install_cursor ;;
  all) install_claude; install_cursor ;;
esac

echo ""
echo "  ================================================"
echo "  ✓ Installation complete"
echo "  ================================================"
echo ""
echo "  Everything installed is symlinked, not copied."
echo "  To update across all projects, run:"
echo ""
echo "    cd $TOOLKIT_DIR && git pull"
echo ""
if [[ "$TARGET" == "claude" || "$TARGET" == "all" ]]; then
  echo "  Claude Code commands:"
  echo "    /task <id>              — Execute a pipeline task"
  echo "    /task <description>     — Create a new pipeline task"
  echo "    /new-orbytes-website    — Scaffold a website project"
  echo "    /task-done              — Complete current task session"
  echo ""
fi
if [[ "$TARGET" == "cursor" ]]; then
  echo "  Cursor: project rules also live in this repo under .cursor/ (for Cloud Agents)."
  echo "  For user-wide Cursor config, this install symlinked into ~/.cursor/"
  echo ""
fi
if [[ "$TARGET" == "all" ]]; then
  echo "  Cursor: see committed .cursor/ in the repo and ~/.cursor/ symlinks from this install."
  echo ""
fi
echo "  Uninstall: $TOOLKIT_DIR/uninstall.sh [--target claude|cursor|all]"
echo ""
