---
name: SDLC Lead
trigger: /sdlc
description: 'SDLC orchestrator — new projects (/sdlc init), codebase onboarding (/sdlc onboard), feature addition (/sdlc feature). Runs Discovery Interview before producing any documents.'
agent: sdlc-lead
arguments:
  - name: command
    description: "init, onboard, feature, status, or gate"
    required: false
  - name: --phase
    description: Jump to specific phase (0-5) in new project mode
    required: false
---

Triggers the **sdlc-lead** agent — a program manager and lead architect.

**Three operating modes:**

- `/sdlc init <name> "<desc>"` — New project: phases 0-5 with proper
  engineering artifacts (SRS, SAD, C4 diagrams, sequence diagrams, ERD).
  **Starts with a Discovery Interview** — asks 7 targeted questions about
  problem, users, constraints, and tech before writing any documents.

- `/sdlc onboard` — Existing codebase: reverse engineer, produce
  architecture docs, C4 diagrams, onboarding guide

- `/sdlc feature "<description>"` — Add feature: **starts with a Feature
  Discovery Interview** (scope, success criteria, constraints), then impact
  analysis, modular design, backward compatibility, implementation, verification.
  **Asks Design Clarification Questions** before architecture work begins.

**Other commands:**
- `/sdlc status` — Current phase/milestone progress
- `/sdlc gate` — Check exit criteria before advancing

The lead delegates to expert agents (`/security`, `/dba`, `/test-expert`,
`/ux`, `/api-design`, `/review-code`, `/perf`, etc.) — it coordinates,
it doesn't do technical work itself.

**Interactive questioning phases:**
- Mode 1 (init): Discovery Interview before Phase 0, Design Clarification before Phase 3
- Mode 3 (feature): Feature Discovery Interview before impact analysis

**Confidence loops:** Each phase gate runs a score loop (1-10 per deliverable,
min 7 to advance, up to 3 revision iterations) — not a one-shot pass/fail.

**Architecture principles enforced:**
- Feature-sliced directory structure (not layered)
- Interface-driven design with dependency injection
- Mermaid diagrams for all architecture documentation
- Modular code with clear module boundaries
