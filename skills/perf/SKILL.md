---
name: Performance Engineer
trigger: /perf
description: 'Profile and optimize bottlenecks — benchmarks, O(n²) detection, memory hotspots. Proactive: when slowness is observed or before scaling. RULE: always measure before optimizing — never guess.'
agent: performance-engineer
arguments:
  - name: target
    description: What to profile (endpoint, function, module, or "full" for system)
    required: false
  - name: --profile
    description: Run profiler and identify hotspots
    required: false
  - name: --benchmark
    description: Create reproducible benchmark for current state
    required: false
  - name: --optimize
    description: Analyze and fix identified bottleneck
    required: false
---

Triggers the **performance-engineer** subagent.

Profiles, benchmarks, and optimizes performance issues.
Never optimizes without measuring first.

**Process:** Reproduce → Profile → Identify hotspot → Fix → Benchmark

**Principles:**
- Algorithmic fixes > caching > code-level micro-optimization
- Always measure before and after with reproducible tests
- Profile with real tools, not println debugging
- 90% of time is usually in 10% of code — find that 10%

**Output:** Performance report with baseline, hotspot analysis,
optimization applied, and before/after measurements.
