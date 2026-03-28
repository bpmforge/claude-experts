#!/bin/bash
set -euo pipefail

# format-on-edit.sh — PostToolUse hook
#
# Automatically formats files after Claude edits them.  Detects the file
# type and invokes the appropriate formatter:
#
#   .ts / .js / .tsx / .jsx  →  prettier
#   .py                      →  black + isort
#   .go                      →  gofmt
#   .rs                      →  rustfmt
#
# Formatting failures are intentionally swallowed so they never block
# the main Claude workflow.

# ── Read the PostToolUse event from stdin ────────────────────────────
input=$(cat)

# Extract the file path that was just edited.  The path lives at
# tool_input.file_path for the Edit / Write tools.
file_path=$(echo "$input" | jq -r '.tool_input.file_path // .tool_input.path // empty')

# If we couldn't determine a file path, nothing to format.
if [[ -z "${file_path:-}" ]]; then
  exit 0
fi

# Only format files that actually exist on disk.
if [[ ! -f "$file_path" ]]; then
  exit 0
fi

# ── Detect file type and run the right formatter ────────────────────
extension="${file_path##*.}"

case "$extension" in
  ts|js|tsx|jsx)
    # Prettier — the standard formatter for JS/TS projects.
    if command -v prettier &>/dev/null; then
      prettier --write "$file_path" 2>/dev/null || true
    elif command -v npx &>/dev/null; then
      npx prettier --write "$file_path" 2>/dev/null || true
    fi
    ;;

  py)
    # Black — the opinionated Python formatter.
    if command -v black &>/dev/null; then
      black --quiet "$file_path" 2>/dev/null || true
    fi
    # isort — sort Python imports to keep them tidy.
    if command -v isort &>/dev/null; then
      isort --quiet "$file_path" 2>/dev/null || true
    fi
    ;;

  go)
    # gofmt — the canonical Go formatter.
    if command -v gofmt &>/dev/null; then
      gofmt -w "$file_path" 2>/dev/null || true
    fi
    ;;

  rs)
    # rustfmt — the standard Rust formatter.
    if command -v rustfmt &>/dev/null; then
      rustfmt "$file_path" 2>/dev/null || true
    fi
    ;;
esac

# Always succeed — formatting is best-effort.
exit 0
