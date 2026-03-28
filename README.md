# claude-experts

Expert system for Claude Code. 10 specialist subagents that work like real professionals — they think, research, plan, execute, and verify instead of following checklists.

## Quick Start

```bash
./install.sh
```

This symlinks agents, skills, hooks, and references into `~/.claude/`. Edits to this repo auto-update the installed files.

## Available Experts

| Trigger | Agent | What It Does |
|---------|-------|-------------|
| `/security` | security-auditor | OWASP assessment, threat modeling, vulnerability scanning |
| `/research` | researcher | Structured investigation with citations and source evaluation |
| `/test-expert` | test-engineer | Playwright e2e, unit tests, test strategy, coverage analysis |
| `/dba` | db-architect | Schema design, migrations, query optimization, indexing |
| `/ux` | ux-engineer | User workflows, component architecture, WCAG accessibility |
| `/devops` | sre-engineer | Runbooks, CI/CD, monitoring, incident response |
| `/containers` | container-ops | Podman/Docker, Dockerfiles, compose, debugging |
| `/review-code` | code-reviewer | Code quality, patterns, tech debt, maintainability |
| `/perf` | performance-engineer | Profiling, benchmarking, targeted optimization |
| `/api-design` | api-designer | REST/GraphQL contracts, versioning, documentation |

## SDLC Workflow

Also includes structured software development lifecycle:

| Trigger | What It Does |
|---------|-------------|
| `/sdlc` | Manage SDLC phases (ideation through implementation) |
| `/gate` | Phase gate approvals and enforcement |
| `/review` | Multi-pass code review with severity levels |

## How Experts Work

Every expert follows the same professional workflow:

1. **Understand** — Read the codebase, check CLAUDE.md, identify existing patterns
2. **Research** — Search for current best practices, read project-specific docs
3. **Plan** — Break work into concrete steps, state approach before executing
4. **Execute** — Domain-specific methodology with real expertise
5. **Verify** — Self-check output, run validation, confirm quality
6. **Report** — Structured output with severity levels and actionable recommendations

Experts use `memory: project` to build institutional knowledge across sessions. They remember what they found, what patterns the codebase uses, and what decisions were made.

## What Makes These Different

| Aspect | Generic Agent | Expert Agent |
|--------|--------------|--------------|
| Thinking | "Understand the codebase" | "Think like an attacker — what's most valuable?" |
| Memory | Forgets between sessions | Builds institutional knowledge |
| Decisions | "Use your judgment" | Concrete decision trees (severity matrix, coverage priority) |
| Output | Lists findings | Recommends actions with reasoning |
| Tools | Everything | Restricted to what the expert needs |

## Installation

```bash
git clone <repo-url> ~/Code/claude-experts
cd ~/Code/claude-experts
./install.sh
```

### Uninstall

```bash
./uninstall.sh
```

## Project Structure

```
agents/          10 expert subagents + 5 SDLC phase agents
skills/          10 expert triggers + 4 SDLC triggers
references/      Supporting docs agents read at runtime
hooks/           Pre/post tool-use automation
install.sh       Symlink into ~/.claude/
uninstall.sh     Clean removal
```
