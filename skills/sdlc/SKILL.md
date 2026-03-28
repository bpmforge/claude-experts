---
name: SDLC Lead
trigger: /sdlc
description: Program manager — orchestrates SDLC phases by coordinating expert agents. Start here for new projects.
agent: sdlc-lead
arguments:
  - name: command
    description: "init, status, phase, gate, or review"
    required: false
  - name: --phase
    description: Jump to specific phase (0-5)
    required: false
---

Triggers the **sdlc-lead** agent — a program manager that coordinates the
full software development lifecycle.

The lead doesn't do technical work. It knows which expert to invoke at
each phase and manages the flow from ideation to production.

**Commands:**
- `/sdlc init <name> "<description>"` — Start a new project
- `/sdlc status` — Show current phase and progress
- `/sdlc phase N` — Work on specific phase
- `/sdlc gate` — Check phase exit criteria
- `/sdlc review` — Phase 5 full review (delegates to all experts)

**Phases:** Ideation → Planning → Requirements → Design → Implementation → Review

**Expert coordination:** The lead recommends which expert skills
(`/security`, `/dba`, `/test-expert`, `/ux`, etc.) to invoke at each phase.
