# Claude Experts

Expert agent system for [Claude Code](https://claude.com/claude-code). 12 specialist agents, 15 skill triggers, curated reference docs, event hooks, and a full SDLC workflow.

Sibling project: [`bpm-opencode-experts`](https://github.com/bpmforge/bpm-opencode-experts) — same experts for OpenCode.

## Quick start

```bash
git clone <repo-url> claude-experts
cd claude-experts
./install.sh                  # symlinks into ~/.claude/
```

Verify with `/sdlc init my-project "short description"` inside a Claude Code session.

Uninstall with `./uninstall.sh`.

## What's in this repo

| Path | Purpose |
|---|---|
| `agents/` | 12 specialist agent definitions (markdown + YAML frontmatter) |
| `skills/` | 15 thin skill triggers that invoke agents |
| `references/` | Canonical checklists the agents read at runtime |
| `hooks/` | Event hooks (session start, pre-tool, stop, etc.) |
| `scripts/` | Helper scripts (deploy, semgrep audits) |

## Documentation

- **[CHANGELOG.md](CHANGELOG.md)** — What changed in every release
- **[docs/FEATURES.md](docs/FEATURES.md)** — What each agent, skill, and reference does
- **[docs/USERGUIDE.md](docs/USERGUIDE.md)** — How to invoke and use each expert

## License

See `LICENSE` (or ask the maintainer). Interoperable with OpenCode — use freely.
