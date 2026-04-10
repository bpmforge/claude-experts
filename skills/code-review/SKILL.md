---
name: Code Review
trigger: /review-code
description: 'Code quality audit — maintainability, patterns, tech debt, naming, error handling. Use after implementing any feature. NOT for security vulns (/security) or phase docs (/sdlc). Proactive: suggest after every feature implementation.'
agent: code-reviewer
arguments:
  - name: target
    description: File, directory, or git diff to review
    required: false
  - name: --debt
    description: Focus on technical debt identification
    required: false
  - name: --patterns
    description: Check pattern consistency across codebase
    required: false
---

Triggers the **code-reviewer** subagent.

Reviews code for quality, maintainability, and technical debt —
distinct from security audit (vulnerabilities) and SDLC review (phase docs).

**Focus areas:**
- Complexity (functions >50 lines, deep nesting, god objects)
- Pattern consistency with existing codebase
- Tech debt (copy-paste, magic numbers, missing abstractions)
- Naming quality and error handling consistency
- Testability and dependency management

**Output:** Findings by severity (Pattern Violation / Complexity / Tech Debt)
with specific file:line references and fix recommendations.
