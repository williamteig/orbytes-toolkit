#!/usr/bin/env python3
"""PreToolUse hook — block git push --force when ref is main. stdin: JSON tool payload."""
import json
import sys


def main() -> None:
    raw = sys.stdin.read()
    if not raw.strip():
        sys.exit(0)
    try:
        data = json.loads(raw)
    except json.JSONDecodeError:
        sys.exit(0)
    cmd = ""
    tool_input = data.get("tool_input") or data.get("input") or {}
    if isinstance(tool_input, dict):
        cmd = tool_input.get("command") or ""
    elif isinstance(tool_input, str):
        cmd = tool_input
    cmd_l = cmd.lower()
    if "git" not in cmd_l or "push" not in cmd_l:
        sys.exit(0)
    force = "--force" in cmd_l or " -f " in f" {cmd_l} " or cmd_l.strip().endswith(" -f")
    if not force:
        sys.exit(0)
    if "main" in cmd.split():
        print("orbytes: blocked git push --force to main", file=sys.stderr)
        sys.exit(2)
    sys.exit(0)


if __name__ == "__main__":
    main()
