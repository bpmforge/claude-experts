# Changelog

All notable changes to this project are documented here. Format follows [Keep a Changelog](https://keepachangelog.com/en/1.1.0/) and versioning follows [Semantic Versioning](https://semver.org/).

## [0.10.0] — 2026-04-13

Major security scanning expansion: 186 custom Semgrep rules across 11 languages, attack chain analysis Phase 5b in security-auditor, OpenAPI spec as required SDLC Phase 3 deliverable, personal store paths documented, and offline scanning support.

### Added
- **186 custom Semgrep gap-filler rules** across 11 languages (JS/TS, Python, Go, Java, Ruby, C#, Kotlin, Rust, PHP, Swift, C++) installed to `~/.claude/.semgrep/`
- **`scripts/cache-registry-packs.sh`** — Manages offline Semgrep registry pack cache for air-gapped scans
- **Phase 5b: Attack Chain Analysis** in `security-auditor` — After finding individual vulnerabilities, agent inventories pre/post conditions and hunts for 9 chain patterns (XSS→session hijack, SSRF→pivot, path traversal→cred theft, auth bypass→privilege escalation, etc.)
- **`docs/api/openapi.yaml`** required as SDLC Phase 3 deliverable in `sdlc-lead` — full OpenAPI 3.0 spec with swagger-cli validation gate
- **Personal store paths** documented in `security-auditor` preflight: `~/.claude/.semgrep/custom-rules/` (global) and `.claude/.semgrep/custom-rules/` (project)

### Changed
- `install.sh` now installs `.semgrep/` to `~/.claude/.semgrep/` and `scripts/` to `~/.claude/scripts/`
- `security-auditor` preflight checks for custom-rules personal store as 4th check
- `semgrep-full-audit.sh` case statement extended to load custom rules for JS/TS, Python, Go, Java, Ruby languages
- Rule count updated: 160 → 186 rules, 10 → 11 languages

## [0.3.0] — 2026-04-10

Major upgrade wave: new `git-expert` agent, three-mode `code-reviewer` rewrite, three-mode `ux-engineer` rewrite, deeper `security-auditor`, sdlc-lead discovery interviews, asymmetric confidence gates applied across every agent. Repository cleanup + new documentation.

### Added
- **`git-expert`** — New 6-mode agent (`--init`, `--feature`, `--release`, `--recover`, `--inspect`, `--sync`). Handles repo bootstrap, daily feature-branch flow with atomic commits and draft PRs, semver releases with Keep-a-Changelog, reflog-based recovery, history forensics (blame / pickaxe / bisect), and multi-remote sync (Gitea + GitHub). Includes secret-scanning, reflog backups before destructive ops, and explicit confirmation gates. Wired into `sdlc-lead` at Phase 0, Phase 4, Phase 5, and Mode 3.
- **`references/git-workflow-checklist.md`** — Canonical rules for conventional commits, SemVer 2.0, Keep-a-Changelog, language-aware `.gitignore` presets, recovery scenarios, report templates, and destructive-op confirmation templates.
- **`code-reviewer` four modes** — `--review` (7-dimension health pass), `--debt` (leverage-sorted tech-debt register), `--consolidate` (DRY + error-handling consolidation with Consolidation Catalog), `--patterns` (cross-codebase drift audit).
- **`references/code-health-checklist.md`** — 7 dimensions, silent-failure hunter, consolidation catalog, language thresholds, confidence scoring, report templates.
- **`ux-engineer` three modes** — `--design` (WCAG-aware component design), `--review` (Nielsen Norman heuristic pass), `--audit` (accessibility audit with live-environment methodology).
- **Discovery Interviews + Confidence Loops** on `sdlc-lead` — Mode 1 and Mode 3 now start with a mandatory interview protocol; every phase ends with a per-document confidence gate (asymmetric: < 5 = fail, 5-6 = revise max 3x, ≥ 7 = pass).
- **Inter-Phase Check-In + Research Findings Review protocols** — Prevents `sdlc-lead` from auto-advancing phases and forces it to reconcile research with prior decisions.
- **Semgrep deep upgrade** — Community rules integration, framework auto-detect, two-tier scans in `security-auditor`.
- **Skeleton-first security report format** — Rewritten to surface actionable intel first.
- **Verifier isolation + reader simulation + asymmetric gates** — Applied across all 12 agents.
- Repository cleanup: `.gitignore`, `CHANGELOG.md`, shortened `README.md`, `docs/FEATURES.md`, `docs/USERGUIDE.md`.

### Changed
- **`sdlc-lead` Phase 0 now calls `/git-expert --init` first** — so VISION.md is the first tracked artifact.
- **`sdlc-lead` Phase 4 calls `/git-expert --feature`** per completed feature for branch + atomic commits + draft PR.
- **`sdlc-lead` Phase 5 calls `/git-expert --release`** once reviews pass — semver bump + signed tag + GitHub/Gitea releases.
- Agent descriptions now use trigger-aware "pushy" language so they surface proactively.

## [0.2.0] — 2026-04-09

End-of-day state after a major expert-depth push. 11 experts upgraded with real per-phase iteration loops, instinct patterns, deep threat modeling, verbatim code snippet enforcement, and a Mode 2 (`sdlc onboard`) overhaul with high-level architecture + operation sequence diagrams.

### Added
- **Real expert behavior** across all 11 agents — per-phase iteration, instinct patterns, deeper threat modeling.
- **Semgrep integration** in `security-auditor` — auto-install, auto-detect language, guided setup.
- **Context7 MCP reference** — Live library documentation lookup available to all agents.
- **Micro-loop pattern** applied to all 11 agents (ThreatForge lessons absorbed).
- **Detailed security + code review reports** — verbatim code quotes, concrete exploitation explanations, file:line anchors.
- **Mode 2 (`sdlc onboard`) overhaul** — high-level architecture pass, operation sequence diagrams, confidence loop.
- **Session-start hook** for verifier isolation + reader simulation + asymmetric gates.

### Changed
- Phase agents consolidated into a single `sdlc-lead` program manager with 3 operating modes (init, onboard, feature).

## [0.1.0] — 2026-03-28

Initial release of the Claude Code Expert system.

### Added
- **11 specialist agents**: `sdlc-lead`, `security-auditor`, `researcher`, `test-engineer`, `db-architect`, `ux-engineer`, `sre-engineer`, `container-ops`, `code-reviewer`, `performance-engineer`, `api-designer`.
- **Slash-command skill triggers** for each agent: `/sdlc`, `/security`, `/research`, `/test-expert`, `/dba`, `/ux`, `/devops`, `/containers`, `/review-code`, `/perf`, `/api-design`, `/gate`, `/review`.
- **Reference documents** covering OWASP, engineering artifacts, REST APIs, Playwright, Semgrep, severity matrices.
- **Install scripts** that symlink agents, skills, references, and hooks into `~/.claude/`.
- **Interoperable** with the sibling `bpm-opencode-experts` project for OpenCode.

[0.3.0]: https://gitea.internal/bmatthews/claude-experts/compare/v0.2.0...v0.3.0
[0.2.0]: https://gitea.internal/bmatthews/claude-experts/compare/v0.1.0...v0.2.0
[0.1.0]: https://gitea.internal/bmatthews/claude-experts/releases/tag/v0.1.0
