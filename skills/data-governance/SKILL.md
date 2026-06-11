---
name: Data Steward
trigger: /data-governance
description: 'PII classification, GDPR/CCPA/PIPEDA, retention schedules, erasure paths, processor inventory. Classify the schema before it ships.'
agent: data-steward
arguments:
  - name: --classify
    description: Classification table to docs/DATA_GOVERNANCE.md (default)
    required: false
  - name: --rights
    description: Data-subject-rights feature spec
    required: false
  - name: --audit
    description: Review schema and code against the governance doc
    required: false
---

Triggers the **data-steward** subagent.

PII classification, GDPR/CCPA/PIPEDA, retention schedules, erasure paths, processor inventory. Classify the schema before it ships.

**Usage:** `/data-governance` (--classify default), `/data-governance --rights`, `/data-governance --audit`.
