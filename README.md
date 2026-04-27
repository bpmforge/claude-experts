# Claude Experts

Expert agent system for [Claude Code](https://claude.com/claude-code). 14 specialist agents, 18 skills, 9 validators, a full SDLC workflow.

Sibling project: [`bpm-opencode-experts`](https://github.com/bpmforge/bpm-opencode-experts) — same experts for OpenCode.

## Install

```bash
git clone https://github.com/bpmforge/claude-experts.git
cd claude-experts
./install.sh                  # symlinks into ~/.claude/
```

The install script:
- Symlinks 14 agents + 9 references into `~/.claude/agents/`
- Symlinks skills, hooks, scripts, and a Semgrep ruleset (186 rules across 11 languages)
- Clones, builds, and registers **playwright-search MCP** (`web_research` / `web_search` / `web_fetch`) at `~/.local/share/playwright-search` — multi-engine web research with paragraph-level relevance ranking, available to every agent

### Install flags

| Flag | Effect |
|------|--------|
| `--no-playwright-search` | Skip cloning/building the playwright-search MCP |

Override the playwright-search install location: `PLAYWRIGHT_SEARCH_DIR=~/code/pws ./install.sh`

Requires macOS, Linux, or Windows with WSL2. Node 20+ on PATH if you want playwright-search. Uninstall with `./uninstall.sh`.

### What others need

```bash
git clone https://github.com/bpmforge/claude-experts.git
cd claude-experts
./install.sh
```

…and the Claude Code CLI (`claude`) on PATH. If `claude` is found, the script auto-registers the MCP via `claude mcp add`. If not, it prints the exact command to run manually.

## First command

Inside a Claude Code session:

```
/sdlc init my-project "short description"
```

Or describe what you want in plain English — the SDLC lead detects intent and routes.

## Docs

- [docs/USERGUIDE.md](docs/USERGUIDE.md) — how to invoke and use each expert
- [docs/FEATURES.md](docs/FEATURES.md) — every agent, skill, validator, and shared protocol
- [docs/SDLC_GUIDE.md](docs/SDLC_GUIDE.md) — full SDLC workflow
- [CHANGELOG.md](CHANGELOG.md) — release notes (current: v0.16.0 research + loop-prevention)

## License

See `LICENSE`.
