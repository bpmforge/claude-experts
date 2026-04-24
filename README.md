# Claude Experts

Expert agent system for [Claude Code](https://claude.com/claude-code). 14 specialist agents, 18 skills, 9 validators, a full SDLC workflow.

Sibling project: [`bpm-opencode-experts`](https://github.com/bpmforge/bpm-opencode-experts) — same experts for OpenCode.

## Install

```bash
git clone https://github.com/bpmforge/claude-experts.git
cd claude-experts
./install.sh                  # symlinks into ~/.claude/
```

Requires macOS, Linux, or Windows with WSL2. Uninstall with `./uninstall.sh`.

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
- [CHANGELOG.md](CHANGELOG.md) — release notes (current: v0.15.0 strict-refactor)

## License

See `LICENSE`.
