# claude-experts

Expert system for Claude Code. 1 program manager + 10 specialist subagents that work like real professionals — they think, research, plan, execute, verify, and hand off to each other.

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

## SDLC Lead (Program Manager + Lead Architect)

The lead orchestrates the full lifecycle — delegates to experts, enforces
modular design, produces proper engineering artifacts (SRS, SAD, C4 diagrams,
sequence diagrams, ERDs, ADRs).

**Three operating modes:**

| Command | Mode | What It Does |
|---------|------|-------------|
| `/sdlc init <name> "<desc>"` | New Project | Phases 0-5 with SRS, SAD, C4 diagrams, modular design |
| `/sdlc onboard` | Existing Codebase | Reverse engineer: trace code, produce architecture docs, onboarding guide |
| `/sdlc feature "<desc>"` | Add Feature | Impact analysis → design → implement → test → document |
| `/sdlc status` | Any | Show current progress |
| `/sdlc gate` | Any | Check exit criteria |
| `/gate` | Any | Phase gate approvals |
| `/review` | Any | Multi-pass code review |

**Engineering artifacts produced:**
- SRS with requirement IDs (FR-001) and acceptance criteria
- SAD with C4 diagrams (Context, Container, Component) in Mermaid
- Sequence diagrams for critical user flows
- ERD for database schema
- API contracts (OpenAPI-style)
- Architecture Decision Records (ADRs)
- Onboarding guides for existing codebases

**Architecture enforced:** Feature-sliced structure, interface-driven design,
dependency injection, clear module boundaries.

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
agents/          1 sdlc-lead + 10 expert subagents
skills/          10 expert triggers + 4 SDLC triggers
references/      Supporting docs agents read at runtime
hooks/           Pre/post tool-use automation
install.sh       Symlink into ~/.claude/
uninstall.sh     Clean removal
```
