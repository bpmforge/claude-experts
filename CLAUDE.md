# claude-experts

Expert system for Claude Code. Contains subagent definitions, skill triggers, reference documents, and hooks.

## Structure
- `agents/` — Subagent system prompts (markdown with YAML frontmatter)
- `skills/` — Thin skill triggers that invoke agents
- `references/` — Supporting documents agents Read at runtime
- `hooks/` — Shell/Python scripts for pre/post tool-use automation

## Conventions
- Agent frontmatter: name, description, tools, model, memory, maxTurns
- Skill frontmatter: name, trigger, description, agent, arguments
- Reference files: Plain markdown, no frontmatter
- Hooks: Executable scripts, receive JSON on stdin, exit 2 to block

## Installation
Run `./install.sh` to symlink into `~/.claude/`. Run `./uninstall.sh` to remove.
