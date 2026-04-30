# Claude Experts

Expert agent system for [Claude Code](https://claude.com/claude-code) — 14 specialist agents, 19 skills, a 4-mode SDLC workflow, and an MCP-driven research backbone with citation-grade web search.

Sibling project: [`bpm-opencode-experts`](https://github.com/bpmforge/bpm-opencode-experts) — same experts for OpenCode.

## Install

```bash
git clone https://github.com/bpmforge/claude-experts.git
cd claude-experts
./install.sh
```

The install script symlinks 14 agents + 9 references + skills + hooks + scripts into `~/.claude/`, clones and registers the `playwright-search` MCP, and installs a 186-rule Semgrep set across 11 languages.

Common flags: `--no-playwright-search` (skip the search MCP), `--uninstall`. Requires macOS, Linux, or WSL2; Node 20+ if you want playwright-search; the `claude` CLI on PATH for auto-MCP registration.

## First command

Inside a Claude Code session:

```
/sdlc init my-project "short description"
```

Or describe what you want in plain English — the SDLC lead detects intent and routes:

| You say | It runs |
|---------|---------|
| "build a new app" | `/sdlc init` |
| "understand this codebase" | `/sdlc onboard` |
| "add X feature" | `/sdlc feature` |
| "review / audit / find gaps / make it better" | `/sdlc improve` |

## Docs

- [docs/USERGUIDE.md](docs/USERGUIDE.md) — how to invoke and use each expert
- [docs/FEATURES.md](docs/FEATURES.md) — every agent, skill, validator, shared protocol
- [docs/SDLC_GUIDE.md](docs/SDLC_GUIDE.md) — full 4-mode SDLC workflow
- [docs/AGENT_PROCESS_FLOW.md](docs/AGENT_PROCESS_FLOW.md) — agent orchestration internals
- [docs/EXPERT_REVIEW_PROCESS.md](docs/EXPERT_REVIEW_PROCESS.md) — multi-expert review pipeline
- [CHANGELOG.md](CHANGELOG.md) — release notes

## License

See `LICENSE`.
