#!/bin/bash
set -euo pipefail

# type-check-on-edit.sh — PostToolUse hook
#
# Runs the TypeScript compiler in type-check-only mode (--noEmit) after
# Claude edits a .ts or .tsx file.  Output is truncated to 30 lines so
# it stays readable inside the conversation context.
#
# Always exits 0 — type errors inform Claude but never block the flow.

# ── Read the PostToolUse event from stdin ────────────────────────────
input=$(cat)

file_path=$(echo "$input" | jq -r '.tool_input.file_path // .tool_input.path // empty')

if [[ -z "${file_path:-}" ]]; then
  exit 0
fi

if [[ ! -f "$file_path" ]]; then
  exit 0
fi

# ── Only type-check TypeScript files ────────────────────────────────
extension="${file_path##*.}"

case "$extension" in
  ts|tsx)
    # Continue to type checking below.
    ;;
  *)
    exit 0
    ;;
esac

# ── Locate tsconfig.json ────────────────────────────────────────────
# Walk up from the edited file to find the nearest tsconfig.json.
dir=$(dirname "$file_path")
tsconfig=""
while [[ "$dir" != "/" ]]; do
  if [[ -f "$dir/tsconfig.json" ]]; then
    tsconfig="$dir/tsconfig.json"
    break
  fi
  dir=$(dirname "$dir")
done

# ── Run tsc --noEmit ────────────────────────────────────────────────
MAX_LINES=30

if command -v tsc &>/dev/null; then
  tsc_cmd="tsc"
elif command -v npx &>/dev/null; then
  tsc_cmd="npx tsc"
else
  echo "tsc: not found — skipping type check"
  exit 0
fi

if [[ -n "$tsconfig" ]]; then
  output=$($tsc_cmd --noEmit --project "$tsconfig" 2>&1 || true)
else
  output=$($tsc_cmd --noEmit "$file_path" 2>&1 || true)
fi

# ── Truncate and display ────────────────────────────────────────────
line_count=$(echo "$output" | wc -l)

if [[ "$line_count" -gt "$MAX_LINES" ]]; then
  echo "$output" | head -n "$MAX_LINES"
  echo "... ($(( line_count - MAX_LINES )) more lines truncated)"
else
  echo "$output"
fi

exit 0
