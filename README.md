# claude-experts

Expert agent system for [Claude Code](https://claude.ai/code) — 33 primary expert agents + 30 cluster specialists (security, code-review, performance, onboarding, game dev), 21 skills, a 4-mode SDLC workflow, full git lifecycle management, and 40 automated validators that enforce quality gates at every phase.

Sibling project: [`bpm-opencode-experts`](https://github.com/bpmforge/bpm-opencode-experts) — same experts for OpenCode (any LLM).

## Install

```bash
git clone https://github.com/bpmforge/claude-experts.git
cd claude-experts
./install.sh
```

`install.sh` clones and builds all MCPs automatically (bpm-memory-mcp, bpm-code-search-mcp, playwright-search) and registers them with Claude Code. Pass `--no-playwright-search` or `--no-playwright-mcp` to skip individual MCPs. Requires macOS, Linux, or WSL2.

**Verify the install:**

```bash
~/.claude/scripts/doctor.sh
```

Checks structure, symlink integrity, runtime deps, and MCP registration — `Status: HEALTHY` means everything works.

**Update:** `git pull && ./install.sh --yes` (idempotent — agents are symlinks, so most updates apply instantly; re-run install for new files), then `doctor.sh` again.

## First command

```
/sdlc init my-project "short description"
```

Or plain English — the SDLC lead detects intent and routes automatically:

| You say | Runs |
|---------|------|
| "build a new app" | `/sdlc init` |
| "understand this codebase" | `/sdlc onboard` |
| "add X feature" | `/sdlc feature` |
| "review / audit / find gaps / make it better" | `/sdlc improve` |
| "verify the UI at localhost:3000" | `/ui-verify` |

## What's included

| Category | Count |
|----------|-------|
| Primary agents | 16 |
| Security micro-agents | 9 |
| Code-review micro-agents | 7 |
| Performance micro-agents | 6 |
| SDLC onboard specialists | 4 |
| SDLC mode agents | 8 |
| **Total agents** | **47** |
| Skills | 25 |
| Shared protocols | 17 |
| Validators | 38 |
| MCPs (auto-installed) | 4 |

## Docs

- [docs/SETUP.md](docs/SETUP.md) — **start here**: prerequisites, embedding models, env vars, troubleshooting
- [docs/USERGUIDE.md](docs/USERGUIDE.md) — how to invoke each expert
- [docs/FEATURES.md](docs/FEATURES.md) — full agent, skill, validator, and protocol catalog
- [docs/MCP_GUIDE.md](docs/MCP_GUIDE.md) — MCP configuration and usage
- [docs/SDLC_GUIDE.md](docs/SDLC_GUIDE.md) — SDLC workflow, phases, git model
- [CHANGELOG.md](CHANGELOG.md) — release notes

## License

See `LICENSE`.
