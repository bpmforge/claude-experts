---
name: SDLC
trigger: /sdlc
description: Manage SDLC workflow phases for software development
---

# SDLC Skill

Manage the Software Development Lifecycle workflow with phase-based document generation.

## Memory Integration

SDLC projects benefit greatly from persistent memory due to:
- **Multi-phase work** spanning days/weeks with frequent compaction
- **Decision chains** where Phase 1 choices affect Phase 4
- **Context loss** from compaction that memory recovers

### Automatic Memory Behavior

**On Phase Start:**
```
memory_recall({ query: "phase [N] decisions constraints requirements" })
```
Recalls relevant context from previous phases before starting work.

**During Phase Work:**
- Store all decisions with reasoning (not just what, but WHY)
- Store rejected alternatives ("Considered X, rejected because Y")
- Store cross-phase dependencies ("This affects FR-007 from Phase 2")

**On Phase Completion:**
```
memory_store({
  content: "Phase [N] complete: [summary of key decisions]",
  type: "decision",
  confidence: 1.0
})
```

### What to Store Per Phase

| Phase | Store | Examples |
|-------|-------|----------|
| 0 (Ideation) | Vision decisions, competitor learnings | "Mobile-first based on persona P-001" |
| 1 (Planning) | Scope decisions, risk mitigations | "Excluded admin panel - revisit v2 (R-003)" |
| 2 (Requirements) | Requirement rationale, priority reasons | "FR-012 is P0 due to CONSTRAINT-002" |
| 3 (Design) | Architecture decisions, rejected alternatives | "Chose PostgreSQL over MongoDB for ACID (T-005)" |
| 4 (Implementation) | Error patterns, code decisions | "Redis must start before app (ECONNREFUSED)" |

### Memory Commands for SDLC

**Recall phase context:**
```
memory_recall({ query: "phase 2 requirements decisions", limit: 10 })
```

**Store decision with cross-reference:**
```
memory_store({
  content: "Chose JWT over sessions: stateless for horizontal scaling (NFR-003)",
  type: "decision",
  confidence: 1.0,
  citation: "docs/3-design/ARCHITECTURE.md:45-60"
})
```

**Store rejected alternative:**
```
memory_store({
  content: "REJECTED: MongoDB for main DB. Reason: Need ACID for payments (FR-022)",
  type: "decision",
  confidence: 1.0
})
```

---

## Commands

### `/sdlc init <project-name> "<description>"`

Initialize a new project with SDLC structure.

**Example:**
```
/sdlc init TaskTracker "A CLI task tracker app with priorities, due dates, and tags"
```

**Actions:**
1. Create project directory structure:
   ```
   docs/
   ├── 0-ideation/
   ├── 1-planning/
   ├── 2-requirements/
   ├── 3-design/
   └── 4-implementation/tasks/
   ```

2. Create/update CLAUDE.md with project info:
   ```markdown
   # Project: [project-name]

   ## Description
   [description]

   ## SDLC State
   - Current Phase: 0 (Ideation)
   - Phases Completed: []
   - Last Updated: [date]

   ## Phase Approvals
   | Phase | Status | Approved By | Date |
   |-------|--------|-------------|------|
   | 0 | Pending | - | - |
   | 1 | Pending | - | - |
   | 2 | Pending | - | - |
   | 3 | Pending | - | - |
   | 4 | Pending | - | - |
   ```

3. Report initialization complete

---

### `/sdlc run [--phase N]`

Run SDLC phases to generate documents.

**Examples:**
```
/sdlc run              # Run next incomplete phase
/sdlc run --phase 0    # Run specific phase
/sdlc run --phase 0-3  # Run phases 0 through 3
```

**Actions:**
1. Check gate requirements for target phase
2. If gate not satisfied, report missing prerequisites
3. If gate satisfied:
   - Launch the appropriate phase agent
   - Agent generates required documents
   - Update CLAUDE.md with progress
4. Report results

**Phase Agents:**
- Phase 0: `.claude/agents/phase-0-ideation.md`
- Phase 1: `.claude/agents/phase-1-planning.md`
- Phase 2: `.claude/agents/phase-2-requirements.md`
- Phase 3: `.claude/agents/phase-3-design.md`
- Phase 4: `.claude/agents/phase-4-implementation.md`

---

### `/sdlc status`

Show current SDLC progress and document status.

**Output:**
```
SDLC Status: [Project Name]

Current Phase: 2 (Requirements)
Phases Completed: [0, 1]

Phase 0 (Ideation): Approved
  VISION.md (78 lines)
  COMPETITIVE_ANALYSIS.md (87 lines)

Phase 1 (Planning): Approved
  SCOPE.md (44 lines)
  RISKS.md (50 lines)
  CONSTRAINTS.md (26 lines)
  USER_PERSONAS.md (78 lines)

Phase 2 (Requirements): In Progress
  SRS.md (not started)
  USER_STORIES.md (not started)

Phase 3 (Design): Locked
  TECH_STACK.md
  ARCHITECTURE.md
  DATABASE.md
  THREAT_MODEL.md
  SECURITY_CONTROLS.md

Phase 4 (Implementation): Locked
  Code generation

Next: Run `/sdlc run --phase 2` to continue.
```

---

### `/sdlc validate [--phase N]`

Validate documents for completeness and quality.

**Examples:**
```
/sdlc validate           # Validate all phases
/sdlc validate --phase 2 # Validate specific phase
```

**Validation Checks:**
- Document exists
- Minimum line count met
- Required sections present
- Identifiers follow pattern (FR-XXX, US-XXX)
- Mermaid diagrams render (for design docs)
- No LLM artifacts

**Output:**
```
Validation Report: Phase 2

SRS.md:
  Exists (148 lines)
  Min lines (80) met
  Required sections present
  FR-XXX identifiers found (12)
  NFR-XXX identifiers found (6)
  No artifacts detected

USER_STORIES.md:
  Exists (157 lines)
  Min lines (80) met
  Required sections present
  US-XXX identifiers found (8)
  Missing epic for US-007

Summary: 2/2 valid, 1 warning
```

---

## Phase Overview

| Phase | Name | Documents | Gate Requirement |
|-------|------|-----------|------------------|
| 0 | Ideation | VISION.md, COMPETITIVE_ANALYSIS.md | None |
| 1 | Planning | SCOPE.md, RISKS.md, CONSTRAINTS.md, USER_PERSONAS.md | Phase 0 approved |
| 2 | Requirements | SRS.md, USER_STORIES.md | Phase 1 approved |
| 3 | Design | TECH_STACK.md, ARCHITECTURE.md, DATABASE.md, THREAT_MODEL.md, SECURITY_CONTROLS.md | Phase 2 approved |
| 4 | Implementation | Code + TASKS.md | Phase 3 approved |

## Document Requirements

| Document | Phase | Min Lines | Required Patterns |
|----------|-------|-----------|-------------------|
| VISION.md | 0 | 40 | - |
| COMPETITIVE_ANALYSIS.md | 0 | 40 | Competitor sections |
| SCOPE.md | 1 | 25 | In Scope, Out of Scope |
| RISKS.md | 1 | 30 | R-XXX |
| CONSTRAINTS.md | 1 | 15 | - |
| USER_PERSONAS.md | 1 | 40 | 2+ personas |
| SRS.md | 2 | 80 | FR-XXX, NFR-XXX |
| USER_STORIES.md | 2 | 80 | US-XXX |
| TECH_STACK.md | 3 | 50 | - |
| ARCHITECTURE.md | 3 | 80 | Mermaid diagrams |
| DATABASE.md | 3 | 50 | erDiagram |
| THREAT_MODEL.md | 3 | 60 | T-XXX |
| SECURITY_CONTROLS.md | 3 | 40 | SC-XXX |

---

## Phase 4 Work Session Commands (Added 2026-01-16)

### `/sdlc work --task TASK-XXX`

Declare which task you're working on. Creates audit trail and enforces tracking.

**Example:**
```
/sdlc work --task TASK-019
```

**Output:**
```
Work Session Started

Task: TASK-019 - Dashboard & Navigation
Requirements: FR-001, FR-002
Status: In Progress
Time: 2026-01-16 10:30

Deliverables to complete:
  - [ ] Dashboard component with stats
  - [ ] Sidebar navigation
  - [ ] Layout wrapper
  - [ ] Routing configuration

Remember:
  - Reference ARCHITECTURE.md for structure
  - Add FR-XXX comments to code
  - Run /gate verify --task TASK-019 when done
```

---

### `/sdlc log "description"`

Log ad-hoc work that isn't part of a defined task.

**Example:**
```
/sdlc log "Added Tooltip component for better UX"
```

**Output:**
```
Ad-Hoc Work Logged

Description: Added Tooltip component for better UX
Time: 2026-01-16 11:45
Session: TASK-019

Added to PROGRESS.md > Unplanned Enhancements

Action Required:
  This work needs to be linked to a task before Phase 4 approval.
  Options:
    1. Link to existing task (add as sub-deliverable)
    2. Create new TASK-XXX in TASKS.md
    3. Create US-XXX for UX enhancements
```

---

### `/sdlc progress`

Regenerate PROGRESS.md from TASKS.md (single source of truth).

**Output:**
```
Progress Report Generated

Source: docs/4-implementation/tasks/TASKS.md
Output: docs/4-implementation/tasks/PROGRESS.md

Summary:
  - Total Tasks: 54
  - Completed: 24 (44%)
  - Partial: 2 (4%)
  - Pending: 28 (52%)

Confidence Distribution:
  High:   8 tasks
  Medium: 14 tasks
  Low:    2 tasks
  Unscored: 2 tasks

PROGRESS.md updated with current status.
```

---

### `/sdlc session-end`

End current work session with proper status updates.

**Output:**
```
Session Summary

Session Duration: 2h 15m
Tasks Touched: TASK-019, TASK-020

TASK-019: Dashboard & Navigation
  Previous: In Progress
  Current: Done
  Confidence: 75% (builds, no tests)
  → Update status? [y/n]: y
  → TASKS.md updated

TASK-020: Proxy History View
  Previous: Pending
  Current: In Progress
  → Update status? [y/n]: y
  → TASKS.md updated

Ad-Hoc Work:
  - Added Tooltip component (unlinked)
  - Added SearchInput component (unlinked)

2 items need task linkage before Phase 4 approval

PROGRESS.md regenerated.

Next session recommendations:
  1. Continue TASK-020
  2. Link ad-hoc components to tasks
  3. Run /gate verify on completed tasks
```

---

### `/sdlc traceability`

Check requirement-to-code traceability.

**Output:**
```
Traceability Report

Functional Requirements (FR-XXX):
  Implemented: 45/63 (71%)

  Missing:
    FR-012: Match and Replace Rules
    FR-017: JavaScript Analysis
    FR-025: Exploiter Agent
    ... (15 more)

User Stories (US-XXX):
  Implemented: 38/63 (60%)

Non-Functional (NFR-XXX):
  Implemented: 12/21 (57%)

Orphan Code (no requirement linkage):
  frontend/src/components/Tooltip.tsx
  frontend/src/components/SearchInput.tsx
  frontend/src/pages/Decoder.tsx

Recommendations:
  1. Link orphan code to existing US-XXX or create new
  2. Prioritize missing P0 requirements
  3. Target 80% coverage for Phase 4 approval
```

---

## Phase 4 Automation Layer

Phase 4 now includes an automated verification loop powered by hooks, review skills, CI templates, and agent patterns.

### Verification Loop

When hooks are active (configured in `~/.claude/settings.json`), every code edit triggers:

```
Edit/Write → format-on-edit.sh → lint-on-edit.sh → type-check-on-edit.sh → security-scanner.py
                                                                                    │
Stop ────────────────────────────────────────────────────────────────── test-on-stop.sh
                                                                                    │
                                                                        If tests fail → Claude continues fixing
```

**PreToolUse hooks** (run before Bash commands):
- `block-dangerous.py` — blocks `rm -rf /`, `DROP TABLE`, `git push --force`, etc.
- `commit-validator.sh` — enforces Conventional Commits format on all `git commit` messages

**PostToolUse hooks** (run after Edit/Write):
- `format-on-edit.sh` — auto-formats (prettier, black, gofmt, rustfmt)
- `lint-on-edit.sh` — ESLint for JS/TS, ruff for Python
- `type-check-on-edit.sh` — `tsc --noEmit` for TypeScript
- `security-scanner.py` — detects 8 secret patterns (API keys, AWS, PEM, passwords, tokens, DB URLs)

**Stop hook**:
- `test-on-stop.sh` — auto-detects test runner, blocks Claude from stopping if tests fail

### `/sdlc review [target]`

Delegates to the `/review` skill with SDLC context. Automatically includes:
- Current task context (which TASK-XXX is being worked on)
- Requirements being implemented (FR-XXX, US-XXX from TASKS.md)
- Architecture constraints from ARCHITECTURE.md

**Examples:**
```
/sdlc review src/auth/         # Review auth module with SDLC context
/sdlc review                   # Review staged changes
```

---

### `/sdlc scaffold-ci`

Copies GitHub Actions workflow templates from `~/.claude/templates/github-actions/` into the project's `.github/workflows/` directory.

**Available templates:**

| Template | Purpose |
|----------|---------|
| `claude-pr-review.yml` | Auto-review every PR (multi-point checklist) |
| `claude-security-review.yml` | Dedicated security pass on every PR |
| `claude-auto-fix.yml` | Fix lint errors automatically |
| `claude-issue-to-pr.yml` | Auto-implement labeled issues |
| `claude-flaky-tests.yml` | Detect flaky vs real test failures |
| `claude-categorize-pr.yml` | Auto-label PRs by type and risk |
| `claude-self-healing-ci.yml` | Auto-fix CI failures (2 attempts) |

**Usage:**
```
/sdlc scaffold-ci                          # Copy all templates
/sdlc scaffold-ci --only pr-review,auto-fix  # Copy specific templates
```

**Actions:**
1. Create `.github/workflows/` if it doesn't exist
2. Copy selected templates (or all 7)
3. Warn about any existing files that would be overwritten
4. Remind user to add `ANTHROPIC_API_KEY` to repository secrets

---

### `/sdlc parallel --tasks TASK-001,TASK-002,...`

Guidance for running parallel agents via git worktrees. Each task gets its own worktree and Claude session.

**Actions:**
1. Validate all specified tasks exist in TASKS.md and are not blocked
2. Print step-by-step instructions:

```
Parallel Agent Setup

Tasks: TASK-001, TASK-002, TASK-003

Step 1: Create worktrees
  git worktree add ../project-wt-TASK-001 -b task/TASK-001
  git worktree add ../project-wt-TASK-002 -b task/TASK-002
  git worktree add ../project-wt-TASK-003 -b task/TASK-003

Step 2: Launch Claude sessions (one terminal per task)
  cd ../project-wt-TASK-001 && claude -p "Implement TASK-001: <description>" --max-turns 50
  cd ../project-wt-TASK-002 && claude -p "Implement TASK-002: <description>" --max-turns 50
  cd ../project-wt-TASK-003 && claude -p "Implement TASK-003: <description>" --max-turns 50

Step 3: After all agents finish, merge results
  git merge task/TASK-001
  git merge task/TASK-002
  git merge task/TASK-003

Step 4: Run integration tests
  npm test  # or pytest, cargo test, etc.

Step 5: Clean up worktrees
  git worktree remove ../project-wt-TASK-001
  git worktree remove ../project-wt-TASK-002
  git worktree remove ../project-wt-TASK-003
```

Or use the feature-sprint template:
```
~/.claude/templates/agents/feature-sprint.sh --repo . --feature <name> --spec spec.md
```

---

### `/sdlc autonomous --task TASK-XXX [--max-turns N]`

Guidance for launching a Ralph Wiggum autonomous loop on a specific task.

**Actions:**
1. Read TASK-XXX from TASKS.md
2. Determine if TDD or API build template is appropriate
3. Print launch command:

```
Autonomous Agent Setup

Task: TASK-XXX - <description>
Template: ralph-wiggum-tdd.md
Max turns: 25 (default, override with --max-turns)

Launch command:
  claude -p "$(cat ~/.claude/templates/agents/ralph-wiggum-tdd.md \
    | sed 's/\[TASK_DESCRIPTION\]/<task description>/')" \
    --max-turns 25 \
    --output-format json

Safety limits:
  - Max 25 iterations (switch to stabilization at 20)
  - All tests must pass before completion
  - Progress tracked in claude-progress.txt

Available templates:
  - ralph-wiggum-tdd.md   — TDD cycle (red/green/refactor)
  - ralph-wiggum-api.md   — REST API builder (8 steps)
  - coding-agent.md       — Sequential feature-per-session
  - swarm-agent.md        — Multi-agent coordination
```

---

### Updated `/sdlc init` Options

`/sdlc init` now supports scaffolding the automation layer:

```
/sdlc init <project-name> "<description>" [--with-hooks] [--with-ci] [--with-all]
```

| Flag | Effect |
|------|--------|
| `--with-hooks` | Copy hooks from `~/.claude/hooks/` into project `.claude/hooks/` |
| `--with-ci` | Run `scaffold-ci` to add GitHub Actions templates |
| `--with-all` | Both `--with-hooks` and `--with-ci` |

When `--with-hooks` is used, also creates a project-level `.claude/settings.json` with hook configuration.
