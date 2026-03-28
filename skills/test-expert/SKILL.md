---
name: Test Expert
trigger: /test-expert
description: Testing expert — Playwright e2e, vitest/jest unit tests, integration tests, test strategy, coverage
context: fork
agent: test-engineer
arguments:
  - name: task
    description: What to test (e.g., "write e2e tests for login flow", "audit test coverage")
    required: true
  - name: --e2e
    description: Write Playwright end-to-end tests
    required: false
  - name: --unit
    description: Write unit tests (vitest/jest/cargo test)
    required: false
  - name: --coverage
    description: Analyze test coverage and identify gaps
    required: false
  - name: --strategy
    description: Design a test strategy for the project
    required: false
---

Triggers the **test-engineer** subagent in a forked context.

Senior test engineer that designs and implements tests catching real bugs,
not just tests that pass. Covers the full test pyramid.

**Capabilities:**
- Playwright e2e tests with data-testid selectors, page objects
- Unit tests (vitest/jest/cargo test/pytest) with Arrange-Act-Assert
- Integration tests with real dependencies
- Coverage analysis with gap prioritization
- Test strategy design (70% unit / 20% integration / 10% e2e)

**Principles:** Test behavior not implementation, meaningful assertions,
independent test state, no mocking the unit under test.
