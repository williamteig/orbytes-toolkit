#!/usr/bin/env bash
set -euo pipefail

TOOLKIT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TEMPLATE_DIR="$TOOLKIT_DIR/website/templates/project-lint"
TARGET_DIR="${1:-$(pwd)}"

usage() {
  echo "Usage: $0 [target-project-dir]"
  echo "Installs project lint protocol into an existing project repo."
}

if [[ "${1:-}" == "-h" || "${1:-}" == "--help" ]]; then
  usage
  exit 0
fi

if [[ ! -d "$TARGET_DIR" ]]; then
  echo "Target directory does not exist: $TARGET_DIR" >&2
  exit 1
fi

install_file() {
  local src="$1"
  local dst="$2"
  local dst_dir
  dst_dir="$(dirname "$dst")"
  mkdir -p "$dst_dir"

  if [[ -f "$dst" ]]; then
    local backup="${dst}.pre-project-lint-$(date +%Y%m%d%H%M%S)"
    cp "$dst" "$backup"
    echo "  ⚠ Backed up existing: $dst -> $backup"
  fi

  cp "$src" "$dst"
  echo "  + Installed: $dst"
}

echo ""
echo "Installing project lint protocol"
echo "Template: $TEMPLATE_DIR"
echo "Target:   $TARGET_DIR"
echo ""

install_file "$TEMPLATE_DIR/.project-lint.json" "$TARGET_DIR/.project-lint.json"
install_file "$TEMPLATE_DIR/.markdownlint-cli2.jsonc" "$TARGET_DIR/.markdownlint-cli2.jsonc"
install_file "$TEMPLATE_DIR/ops/lint-project.sh" "$TARGET_DIR/ops/lint-project.sh"
install_file "$TEMPLATE_DIR/ops/lint-project.py" "$TARGET_DIR/ops/lint-project.py"

chmod +x "$TARGET_DIR/ops/lint-project.sh" "$TARGET_DIR/ops/lint-project.py"
echo "  ✓ Marked ops scripts executable"

echo ""
echo "Next steps:"
echo "  1) Review .project-lint.json purpose_keywords for this client"
echo "  2) Run: ./ops/lint-project.sh semantic-only"
echo "  3) Add a note in CLAUDE.md pointing to ./ops/lint-project.sh"
echo ""
