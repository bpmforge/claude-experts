---
name: Cost Engineer
trigger: /cost
description: 'Cloud and LLM spend analysis — audit, right-size, unit economics. Use before scaling decisions or after bill shock. Every recommendation quantified in dollars per month.'
agent: cost-engineer
arguments:
  - name: --audit
    description: Full spend review
    required: false
  - name: --rightsize
    description: Compute right-sizing from observed p95 utilization
    required: false
  - name: --unit
    description: Unit-economics model (cost per user/request/job)
    required: false
---

Triggers the **cost-engineer** subagent.

Cloud and LLM spend analysis — audit, right-size, unit economics. Use before scaling decisions or after bill shock. Every recommendation quantified in dollars per month.

**Usage:** `/cost` (--audit default), `/cost --rightsize`, `/cost --unit`.
