---
name: API Designer
trigger: /api-design
description: 'API design expert — REST/GraphQL endpoints, contracts, versioning, OpenAPI docs. Use when adding/changing routes or request/response shapes. NOT for implementation — design only.'
agent: api-designer
arguments:
  - name: task
    description: What to design (e.g., "design user API", "review endpoint contracts")
    required: true
  - name: --rest
    description: REST API design with OpenAPI spec
    required: false
  - name: --graphql
    description: GraphQL schema design
    required: false
  - name: --review
    description: Review existing API for consistency and best practices
    required: false
---

Triggers the **api-designer** subagent.

Designs APIs with developer experience as the primary goal.

**Focus areas:**
- Resource-first REST design with proper HTTP semantics
- Versioning strategy and backward compatibility
- OpenAPI/Swagger documentation with examples
- Error catalog with consistent response format
- Pagination, filtering, and rate limiting

**Output:** API specification with endpoint definitions,
request/response examples, error catalog, and versioning policy.
