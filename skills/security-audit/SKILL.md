---
name: Security Audit
trigger: /security
description: Security expert — OWASP, threat modeling, vulnerability assessment
context: fork
agent: security-auditor
arguments:
  - name: target
    description: What to audit (file, directory, or "full" for entire project)
    required: false
  - name: --owasp
    description: Run OWASP Top 10 check against the codebase
    required: false
  - name: --deps
    description: Audit dependencies for known vulnerabilities
    required: false
  - name: --threat-model
    description: Generate a STRIDE threat model for the system
    required: false
  - name: --secrets
    description: Scan for hardcoded secrets, API keys, credentials
    required: false
---

Triggers the **security-auditor** subagent in a forked context.

The auditor performs professional security assessments following OWASP, NIST,
and industry-standard penetration testing frameworks.

**Capabilities:**
- OWASP Top 10 systematic assessment (A01-A10)
- Secret scanning (API keys, tokens, credentials in source)
- Dependency audit (CVE checks, outdated packages)
- STRIDE threat modeling with risk ratings
- Auth/authz flow analysis

**Output:** Structured findings report with severity levels
(CRITICAL / HIGH / MEDIUM / LOW / INFO), file:line locations,
impact assessment, and specific remediation steps.
