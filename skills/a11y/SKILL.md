---
name: Accessibility Auditor
trigger: /a11y
description: 'WCAG 2.2 AA/AAA audit with axe/Lighthouse plus the manual checklist — every finding cites criterion, file'
agent: a11y-compliance
arguments:
  - name: line, remediation. EAA/508/EN 301 549 applicability.
    description: --audit
    required: false
  - name: Full WCAG audit (default)
    description: --spec
    required: false
  - name: Phase 3 design-time review of UX spec
    description: --quick:Automated-tools-only pass
    required: false
---

Triggers the **a11y-compliance** subagent.

WCAG 2.2 AA/AAA audit with axe/Lighthouse plus the manual checklist — every finding cites criterion, file

**Usage:** `/a11y` (line, remediation. EAA/508/EN 301 549 applicability. default), `/a11y Full WCAG audit (default)`, `/a11y Phase 3 design-time review of UX spec`.
