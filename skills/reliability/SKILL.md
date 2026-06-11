---
name: Reliability Engineer
trigger: /reliability
description: 'Load testing and resilience — what breaks under stress and what happens then. Timeouts, retries with budgets, circuit breakers, chaos scenarios, k6/Locust plans.'
agent: reliability-engineer
arguments:
  - name: --design
    description: Failure-mode matrix + load-test plan (default)
    required: false
  - name: --loadtest
    description: Runnable load-test scripts with NFR-derived thresholds
    required: false
  - name: --chaos
    description: Chaos scenarios as runnable scripts
    required: false
---

Triggers the **reliability-engineer** subagent.

Load testing and resilience — what breaks under stress and what happens then. Timeouts, retries with budgets, circuit breakers, chaos scenarios, k6/Locust plans.

**Usage:** `/reliability` (--design default), `/reliability --loadtest`, `/reliability --chaos`.
