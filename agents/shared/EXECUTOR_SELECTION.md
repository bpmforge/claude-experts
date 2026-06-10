---
description: 'Reference document — read on demand, not an agent.'
disable: true
mode: "all"
---

# Executor Selection — how a HANDOFF actually runs

The HANDOFF document is the delegation contract everywhere. What varies by
runtime and version is the **executor** — the mechanism that runs it. Pick by
capability flags, not by assumptions baked into prose.

> **Claude Code:** the Task tool is native and subagents have full tool access —
> `has_task_tool=true`, `mcp_in_subagents=true`, always. Executor A is the
> default; Executor C is the fallback after two failed dispatches or when the
> user asks to run a specialist interactively. The probing below applies to
> OpenCode-style runtimes.

## The flags

`docs/work/.model-context` (written by `scripts/detect-model-context.sh`):

```
has_task_tool=true|false       # runtime has a blocking Task/subagent tool
mcp_in_subagents=true|false    # Task-tool subagents can execute MCP tools
```

Env overrides: `OPENCODE_HAS_TASK_TOOL`, `OPENCODE_MCP_IN_SUBAGENTS`.
If `.model-context` is missing, run the detect script; if you cannot, assume
`has_task_tool=false` and use Executor C.

## The three executors

| | Executor | When |
|---|---|---|
| **A** | **Native Task tool** — dispatch the full HANDOFF block as the subagent prompt; block until the Completion Manifest returns | `has_task_tool=true` AND the specialist needs no MCP tools (or `mcp_in_subagents=true`) |
| **B** | **Subprocess** — `tools/task.ts` spawns `opencode run --agent <x>` with the HANDOFF as prompt | `has_task_tool=true` but the specialist needs MCP tools (memory, code-search, playwright-search, context7) and `mcp_in_subagents=false`. A fresh process is a primary session with full MCP access. Also the only programmatic path with timeout protection. |
| **C** | **Manual HANDOFF paste** — print the HANDOFF block as text; the user opens a new session, types the skill, pastes | `has_task_tool=false`, or A/B failed twice, or the user asked to run specialists interactively |

## Which specialists need MCP

Needs MCP (route to B or C while `mcp_in_subagents=false`): **researcher**
(playwright-search), anything calling **memory** tools mid-task, **coding-agent**
when Context7 verification is required.

Native-tools only (A is fine): all security/code-review/performance/onboard
micro-agents — they read files, run bash, write findings.

## Rules regardless of executor

1. The HANDOFF block content is IDENTICAL in all three — same `════` delimiters, ROLE, CONTEXT, WRITE-SCOPE, PRODUCE, VERIFY, Completion Manifest, completion phrase.
2. Score the returned manifest the same way (GATE_SCORING_PROTOCOL) whether it came from a tool result or a pasted reply.
3. A dispatch that hangs or errors twice → drop to the next executor down (A → B → C), note it in DELEGATION_LOG.md.
4. Announce every dispatch (specialist + one-line task) and report its verdict — subagents must not reduce user visibility.

## Known upstream issues (recheck when updating defaults)

- anomalyco/opencode#16491 — MCP tools unavailable in Task-tool subagents (open; the reason `mcp_in_subagents` defaults false)
- anomalyco/opencode#6573 — native Task awaits have no timeout (the reason B is preferred for long specialists)
- anomalyco/opencode#15069 — async dispatch (feature request; would let the runner parallelize natively)
