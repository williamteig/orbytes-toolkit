---
description: Reference guide for creating sub-agents. Apply when designing or building new agent files.
alwaysApply: false
---

# Creating Sub-Agents

Sub-agents are autonomous AI sub-processes spawned via the `Agent` tool. Each runs in its own context window with a custom system prompt, specific tool access, and independent permissions. They work independently and return results to the caller.

Official documentation: https://code.claude.com/docs/en/sub-agents

## File conventions

- **Location:** `global/agents/{name}.md` (project-level agents go in `.claude/agents/`)
- **Naming:** kebab-case, descriptive of the agent's purpose (e.g. `qa-component.md`, `deploy-check.md`)
- **One file per agent** — agents are single `.md` files, not directories
- Sub-agents in `.claude/agents/` are loaded at session start. In the orbytes toolkit, global agents live in `global/agents/` and are symlinked into `~/.claude/agents/` by `install.sh`. After creating a new global agent, re-run `install.sh` or restart the session to load it.

## Required file structure

Every agent file is a Markdown file with YAML frontmatter. The frontmatter defines metadata and configuration. The body becomes the system prompt.

Sub-agents receive only their own system prompt (plus basic environment details like working directory), NOT the full Claude Code system prompt.

```markdown
---
name: my-agent
description: "When Claude should delegate to this agent. Be specific — Claude uses this to decide."
tools: Read, Grep, Glob, Bash
model: sonnet
---

You are a {role}. When invoked, {what you do}.

## Inputs

| Input | Required | Description |
|-------|----------|-------------|
| `inputName` | Yes | What this input is |

## Process

### 1. Step name
{What to do}

## Output

{What the agent returns to the caller — keep it focused}
```

## Frontmatter fields

| Field | Required | Description |
|-------|----------|-------------|
| `name` | Yes | Unique identifier, lowercase letters and hyphens |
| `description` | Yes | When Claude should delegate to this agent. Include "use proactively" to encourage auto-delegation |
| `tools` | No | Comma-separated tool names the agent can use. Inherits all tools if omitted |
| `disallowedTools` | No | Tools to deny, removed from inherited or specified list |
| `model` | No | `sonnet`, `opus`, `haiku`, a full model ID (e.g. `claude-opus-4-6`), or `inherit` (default) |
| `permissionMode` | No | `default`, `acceptEdits`, `dontAsk`, `bypassPermissions`, or `plan` |
| `maxTurns` | No | Maximum agentic turns before the agent stops |
| `skills` | No | Skills to inject into the agent's context at startup (full content, not just availability) |
| `mcpServers` | No | MCP servers available to this agent (inline definition or reference by name) |
| `hooks` | No | Lifecycle hooks scoped to this agent (`PreToolUse`, `PostToolUse`, `Stop`) |
| `memory` | No | Persistent memory scope: `user`, `project`, or `local` |
| `background` | No | `true` to always run as a background task |
| `effort` | No | Effort level: `low`, `medium`, `high`, `max` |
| `isolation` | No | `worktree` to run in a temporary git worktree |

## Tool access

By default, agents inherit all tools from the main conversation. Restrict with either:

- `tools` (allowlist): only these tools are available
- `disallowedTools` (denylist): inherit everything except these

For read-only agents, use: `tools: Read, Grep, Glob, Bash`
To block file writes: `disallowedTools: Write, Edit`

If both are set, `disallowedTools` is applied first, then `tools` is resolved against the remaining pool.

## Key rules

- **Design focused agents** — each agent should excel at one specific task. Prefer two small agents over one large one.
- **Write detailed descriptions** — the `description` field is critical. Claude uses it to decide when to delegate. Be specific about trigger conditions.
- **Limit tool access** — grant only necessary permissions for security and focus
- **Agents cannot spawn other agents** — sub-agents cannot nest. If a workflow requires nested delegation, chain agents from the main conversation. An agent can advise the caller to spawn another agent (e.g. qa-page can recommend running qa-component for specific components), but it cannot do so itself.
- **Agents handle missing optional inputs gracefully** with sensible defaults
- **Keep output focused** — when agents complete, their results return to the main conversation and consume context. Return summaries, not raw data.
- After creating a new agent, update `install.sh` and `uninstall.sh` to include it in the symlink loop (for global agents)

## MCP servers

Scope MCP servers to an agent to keep their tool descriptions out of the main conversation context:

```yaml
mcpServers:
  - playwright:
      type: stdio
      command: npx
      args: ["-y", "@playwright/mcp@latest"]
  - github  # reference an already-configured server by name
```

## Hooks

Define hooks in frontmatter for conditional tool validation:

```yaml
hooks:
  PreToolUse:
    - matcher: "Bash"
      hooks:
        - type: command
          command: "./scripts/validate-command.sh"
  PostToolUse:
    - matcher: "Edit|Write"
      hooks:
        - type: command
          command: "./scripts/run-linter.sh"
```

Hook events for agents: `PreToolUse` (before tool use), `PostToolUse` (after tool use), `Stop` (when agent finishes).

## Persistent memory

Enable cross-session learning with the `memory` field:

| Scope | Location | Use when |
|-------|----------|----------|
| `user` | `~/.claude/agent-memory/<name>/` | Knowledge applies across all projects |
| `project` | `.claude/agent-memory/<name>/` | Knowledge is project-specific, shareable via git |
| `local` | `.claude/agent-memory-local/<name>/` | Project-specific, not checked into git |

## When to use agents vs alternatives

| Use | When |
|-----|------|
| **Sub-agent** | Task is self-contained, produces verbose output, needs tool restrictions, or should run in parallel |
| **Skill** | Reusable prompt/workflow that should run in the main conversation context |
| **Command** | User-invoked action that needs `$ARGUMENTS` and runs inline |
| **Main conversation** | Frequent back-and-forth, iterative refinement, or quick targeted changes |

**Gotcha — sub-agents start fresh.**
Each invocation creates a new instance with fresh context. They don't inherit the main conversation's history. Include all necessary context in the agent's system prompt or pass it when spawning.

**Gotcha — background agents auto-deny unpermitted tools.**
Background agents get permission approvals upfront before launching. Once running, anything not pre-approved is auto-denied. If a background agent fails due to missing permissions, retry as a foreground agent.
