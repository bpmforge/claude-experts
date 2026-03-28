---
name: Database Architect
trigger: /dba
description: Database expert — schema design, migrations, query optimization, indexing, ORM models
agent: db-architect
arguments:
  - name: task
    description: What to do (e.g., "design schema for user management", "optimize slow queries")
    required: true
  - name: --design
    description: Design a new schema from requirements
    required: false
  - name: --optimize
    description: Analyze and optimize existing queries/indexes
    required: false
  - name: --migrate
    description: Generate migration files (up and down)
    required: false
  - name: --audit
    description: Audit existing schema for normalization, indexing, and performance issues
    required: false
---

Triggers the **db-architect** subagent in a forked context.

Senior database architect that thinks in data models, relationships,
and query patterns before writing any SQL.

**Capabilities:**
- Schema design (3NF+, proper constraints, indexes, timestamps)
- Migration scripts (up.sql + down.sql, sequential numbering)
- Query optimization (EXPLAIN QUERY PLAN, index recommendations)
- Schema audit (missing indexes, orphaned records, naming consistency)
- ORM model generation with proper types and relationships

**Supports:** SQLite, PostgreSQL, and general SQL best practices.
Always uses parameterized queries — never concatenates SQL.
