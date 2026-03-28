#!/bin/bash
set -euo pipefail

# lint-on-edit.sh — PostToolUse hook
#
# Runs ESLint on JavaScript / TypeScript files after Claude edits them.
# Lint output is written to stdout so Claude receives it as feedback and
# can fix any issues in the same conversation turn.
#
# For Python files, runs ruff (or flake8 as fallback).
#
# The hook always exits 0 — lint warnings should inform Claude, not
# block the workflow.

# ── Read the PostToolUse event from stdin ────────────────────────────
input=$(cat)

# Extract the file path from the tool event.
file_path=$(echo "$input" | jq -r '.tool_input.file_path // .tool_input.path // empty')

if [[ -z "${file_path:-}" ]]; then
  exit 0
fi

if [[ ! -f "$file_path" ]]; then
  exit 0
fi

# ── Detect file type and lint accordingly ────────────────────────────
extension="${file_path##*.}"

case "$extension" in
  ts|js|tsx|jsx)
    if command -v eslint &>/dev/null; then
      eslint --format compact "$file_path" 2>/dev/null || true
    elif command -v npx &>/dev/null; then
      npx eslint --format compact "$file_path" 2>/dev/null || true
    fi
    ;;

  py)
    if command -v ruff &>/dev/null; then
      ruff check "$file_path" 2>/dev/null || true
    elif command -v flake8 &>/dev/null; then
      flake8 "$file_path" 2>/dev/null || true
    fi
    ;;

  *)
    # Not a lintable file type — skip silently.
    exit 0
    ;;
esac

# Always succeed so we never block Claude.
exit 0
