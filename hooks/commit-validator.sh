#!/bin/bash
set -euo pipefail

# commit-validator.sh — PreToolUse hook (Bash tool, matching git commit)
#
# Enforces the Conventional Commits specification on every commit
# message Claude creates.  The format is:
#
#   type(scope): description
#
# Where "type" must be one of:
#   feat, fix, refactor, test, docs, chore, ci, style, perf, build
#
# The (scope) part is optional.  A trailing "!" before the colon
# (e.g. "feat!:") is allowed for breaking changes.
#
# Exit codes:
#   0  — commit message is valid (or command is not a git commit)
#   2  — commit message violates conventional commit format

# ── Valid commit types ───────────────────────────────────────────────
VALID_TYPES="feat|fix|refactor|test|docs|chore|ci|style|perf|build"

# ── Read the PreToolUse event from stdin ─────────────────────────────
input=$(cat)

# Extract the command.
command=$(echo "$input" | jq -r '.tool_input.command // empty')

if [[ -z "${command:-}" ]]; then
  exit 0
fi

# ── Only inspect git commit commands ─────────────────────────────────
# Match "git commit" but not "git commit --amend" without a message, etc.
if ! echo "$command" | grep -qE '^\s*git\s+commit\b'; then
  exit 0
fi

# ── Extract the commit message ───────────────────────────────────────
# Handle both single-quoted and double-quoted -m flags.
# Also handle the heredoc pattern: git commit -m "$(cat <<'EOF' ... EOF)"
commit_msg=""

# Try -m "message" or -m 'message' (greedy enough for typical usage).
if echo "$command" | grep -qE -- '-m\s'; then
  # Extract everything after -m, handling quotes.
  # First try double quotes.
  commit_msg=$(echo "$command" | sed -nE "s/.*-m[[:space:]]+\"([^\"]+)\".*/\1/p")

  # Fall back to single quotes.
  if [[ -z "$commit_msg" ]]; then
    commit_msg=$(echo "$command" | sed -nE "s/.*-m[[:space:]]+'([^']+)'.*/\1/p")
  fi

  # Fall back to unquoted (next whitespace-delimited token).
  if [[ -z "$commit_msg" ]]; then
    commit_msg=$(echo "$command" | sed -nE "s/.*-m[[:space:]]+([^[:space:]\"']+).*/\1/p")
  fi
fi

# If we couldn't extract a message, allow the command through.
# It might be an interactive commit or use a message file.
if [[ -z "$commit_msg" ]]; then
  exit 0
fi

# ── Validate against Conventional Commits ────────────────────────────
# Pattern: type(optional-scope)!?: description
pattern="^(${VALID_TYPES})(\([a-zA-Z0-9_. /-]+\))?!?:[[:space:]]+.+"

if echo "$commit_msg" | grep -qE "$pattern"; then
  # Valid conventional commit.
  exit 0
else
  # Invalid — block the commit and show a helpful message.
  cat >&2 <<ERRMSG
BLOCKED: Commit message does not follow Conventional Commits format.

  Got:      "$commit_msg"
  Expected: type(scope): description

Valid types: feat, fix, refactor, test, docs, chore, ci, style, perf, build

Examples:
  feat(auth): add OAuth2 login flow
  fix: resolve null pointer in parser
  docs(readme): update installation instructions
  refactor(api)!: rename endpoints for v2

Please rewrite the commit message and try again.
ERRMSG
  exit 2
fi
