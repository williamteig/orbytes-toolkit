# Orbytes Claude Code hooks

Scripts live in this directory and are symlinked into **`~/.claude/hooks/`** by **`install.sh`** (Claude target). Wire them in **Claude Code settings** so they run for your sessions.

## Bundled scripts

| Script | Purpose |
|--------|---------|
| `orbytes-pre-tool-use.py` | **PreToolUse** — exits `2` to block `git push --force` when `main` is the ref (see `global/rules/git.md`). |

## Wiring (Claude Code)

1. Run **`./install.sh`** from the toolkit repo so `~/.claude/hooks/orbytes-*.py` exist and are executable.
2. Merge a **hooks** block into your Claude Code settings (user or project), pointing `command` at the symlinked paths under **`$HOME/.claude/hooks/`**.

Example fragment (adjust if your Claude Code version uses a different settings shape):

```json
{
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "Bash",
        "hooks": [
          {
            "type": "command",
            "command": "/Users/YOUR_USERNAME/.claude/hooks/orbytes-pre-tool-use.py"
          }
        ]
      }
    ]
  }
}
```

Use the exact schema from your **Claude Code** version; field names like `matcher` may differ.
