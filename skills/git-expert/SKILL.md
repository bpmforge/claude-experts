---
name: Git Expert
trigger: /git-expert
description: 'Senior git & forge expert — repo bootstrap, feature branches, releases, recovery, forensics, multi-remote sync. Six modes: --init (bootstrap repo + remotes + hooks), --feature (branch + atomic commits + draft PR), --release (semver + changelog + signed tag), --recover (reflog rescue), --inspect (blame/pickaxe/bisect), --sync (multi-remote prune + mirror). Knows Gitea (tea) + GitHub (gh) + conventional commits + semver + Keep-a-Changelog.'
agent: git-expert
arguments:
  - name: --init
    description: Bootstrap a new repo — git init, .gitignore, initial commit, remotes, hooks → docs/git/INIT_<date>.md
    required: false
  - name: --feature
    description: Daily feature workflow — branch + atomic commits + draft PR on gitea + github → docs/git/FEATURE_<branch>.md
    required: false
  - name: --release
    description: Cut a release — semver bump + changelog + signed tag + release notes → docs/git/RELEASE_<version>.md
    required: false
  - name: --recover
    description: Rescue lost work via reflog — bad reset, rebase, detached HEAD, deleted branch → docs/git/RECOVERY_<date>.md
    required: false
  - name: --inspect
    description: History forensics — blame, pickaxe, bisect, log, divergence → docs/git/INSPECT_<topic>_<date>.md
    required: false
  - name: --sync
    description: Multi-remote sync — fetch, prune, clean gone branches, mirror gitea→github → docs/git/SYNC_<date>.md
    required: false
---

Triggers the **git-expert** subagent.

Handles **git operations safely** — repo bootstrap, feature-branch workflows, releases, recovery, forensics, multi-remote sync. Knows conventional commits, semver, Keep-a-Changelog, Gitea (`tea`) + GitHub (`gh`). Distinct from `sre-engineer` (CI/CD pipelines) and `container-ops` (image tagging).

**The 6 modes:**
1. `--init` — Repo bootstrap: `git init`, language-aware `.gitignore`, initial commit, remotes (gitea primary + github mirror by default), commitlint + lefthook/husky hooks, branch protection proposal
2. `--feature` — Daily flow: branch off main with semantic prefix, atomic commit split via `git add -p`, conventional-commit messages matching repo style, pre-commit hooks, draft PR on gitea + github
3. `--release` — Cut a release: compute next semver from commits since last tag, generate Keep-a-Changelog entry, signed annotated tag, push to all remotes, draft GitHub + Gitea releases
4. `--recover` — Rescue lost work: reflog inspection, undo bad reset/rebase, detached HEAD fix, deleted branch recovery, force-push rollback, lost stash, broken HEAD ref
5. `--inspect` — Forensics: log presets, blame with rename tracking, pickaxe (`-S`/`-G`), bisect harness, branch divergence, contributor stats
6. `--sync` — Multi-remote: fetch --all --prune, report divergence, delete `[gone]` branches + worktrees, mirror gitea → github, push tags

**Outputs:**
- `--init` → `docs/git/INIT_<date>.md`
- `--feature` → `docs/git/FEATURE_<branch>.md`
- `--release` → `docs/git/RELEASE_<version>.md`
- `--recover` → `docs/git/RECOVERY_<date>.md`
- `--inspect` → `docs/git/INSPECT_<topic>_<date>.md`
- `--sync` → `docs/git/SYNC_<date>.md`

**Safety rails (ALWAYS enforced):** NEVER force-push to main/release, NEVER `--no-verify`, NEVER commit secrets (scans staged files for .env/keys/tokens), NEVER `git add -A` blindly, NEVER add Claude attribution unless the project's log already uses it, ALWAYS save a reflog backup before destructive ops, ALWAYS verify with `git status` + `git log --all --oneline --graph` before AND after.

**Reference:** `references/git-workflow-checklist.md` (read at start of every invocation). Contains conventional-commit rules, semver logic, language-aware `.gitignore` presets, recovery scenarios, report templates, destructive-op confirmation template, multi-remote push config, hook scaffolding (commitlint + lefthook/husky). Distinct from `/sre` (pipelines) and `/containers` (images).
