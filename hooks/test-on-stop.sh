#!/bin/bash
set -euo pipefail

# test-on-stop.sh — Stop hook
#
# Runs the project's test suite when Claude finishes a task.  If tests
# fail, outputs JSON that tells Claude to keep going (so it can fix them).
# If tests pass, Claude stops normally.
#
# Detects the test runner automatically:
#   package.json   →  npm test
#   pytest.ini / pyproject.toml / setup.cfg with [tool:pytest]  →  pytest
#   Cargo.toml     →  cargo test
#   go.mod         →  go test ./...
#
# Always exits 0 — the block/stop decision is communicated via JSON.

# ── Detect the project root ─────────────────────────────────────────
project_root="${PWD}"

# ── Detect and run tests ────────────────────────────────────────────
test_output=""
test_exit_code=0

run_tests() {
  # Node.js / npm
  if [[ -f "$project_root/package.json" ]]; then
    echo "Running: npm test" >&2
    test_output=$(npm test 2>&1) || test_exit_code=$?
    return
  fi

  # Python / pytest
  if [[ -f "$project_root/pytest.ini" ]] \
     || [[ -f "$project_root/setup.cfg" ]] \
     || (command -v python3 &>/dev/null && [[ -f "$project_root/pyproject.toml" ]]); then
    # Prefer venv pytest if available
    if [[ -x "$project_root/.venv/bin/pytest" ]]; then
      echo "Running: .venv/bin/pytest" >&2
      test_output=$("$project_root/.venv/bin/pytest" 2>&1) || test_exit_code=$?
      return
    elif command -v pytest &>/dev/null; then
      echo "Running: pytest" >&2
      test_output=$(pytest 2>&1) || test_exit_code=$?
      return
    elif command -v python3 &>/dev/null; then
      echo "Running: python3 -m pytest" >&2
      test_output=$(python3 -m pytest 2>&1) || test_exit_code=$?
      return
    fi
  fi

  # Rust / cargo
  if [[ -f "$project_root/Cargo.toml" ]]; then
    echo "Running: cargo test" >&2
    test_output=$(cargo test 2>&1) || test_exit_code=$?
    return
  fi

  # Go
  if [[ -f "$project_root/go.mod" ]]; then
    echo "Running: go test ./..." >&2
    test_output=$(go test ./... 2>&1) || test_exit_code=$?
    return
  fi

  # No test runner found — nothing to do.
  echo "No test runner detected — skipping." >&2
  test_exit_code=-1
}

run_tests

# ── Decide whether Claude should continue ────────────────────────────
if [[ "$test_exit_code" -eq -1 ]]; then
  # No test runner found; let Claude stop normally (no output needed).
  :
elif [[ "$test_exit_code" -eq 0 ]]; then
  # Tests passed — let Claude stop.
  echo "All tests passed." >&2
else
  # Tests failed — block Claude from stopping so it can fix them.
  # Include the tail of the test output so Claude has context.
  truncated=$(echo "$test_output" | tail -n 40 | jq -Rs '.')
  cat <<EOF
{
  "decision": "block",
  "reason": "Tests failed (exit code $test_exit_code). Please fix the failing tests.",
  "test_output": $truncated
}
EOF
fi

exit 0
