#!/bin/bash
#
# session-start.sh -- UserPromptSubmit hook
#
# Fires before each user message. When a project has SDLC docs, emits
# additionalContext JSON with project name, current phase, and open blockers.
# Silent (no output) when there's no SDLC state to report.
#
# Input (stdin): JSON with session_id, cwd, prompt, transcript_path
# Output (stdout): JSON { "additionalContext": "..." } or nothing
#

set -euo pipefail

# Parse cwd from stdin JSON
input=$(cat)
cwd=$(echo "$input" | python3 -c "import json,sys; d=json.load(sys.stdin); print(d.get('cwd',''))" 2>/dev/null || echo "")

# Only proceed if we're in a directory with SDLC docs
if [ -z "$cwd" ] || [ ! -d "$cwd/docs" ]; then
  exit 0
fi

# Determine project name from CLAUDE.md h1 or directory name
project_name=""
if [ -f "$cwd/CLAUDE.md" ]; then
  project_name=$(grep -m1 '^# ' "$cwd/CLAUDE.md" 2>/dev/null | sed 's/^# //' || echo "")
fi
if [ -z "$project_name" ]; then
  project_name=$(basename "$cwd")
fi

# Determine current SDLC phase by which docs exist
phase="Phase 0 (Ideation)"
if [ -f "$cwd/docs/SRS.md" ] || [ -f "$cwd/docs/USER_STORIES.md" ]; then
  phase="Phase 2 (Requirements)"
fi
if [ -f "$cwd/docs/ARCHITECTURE.md" ] || [ -f "$cwd/docs/TECH_STACK.md" ]; then
  phase="Phase 3 (Design)"
fi
if [ -f "$cwd/docs/SCOPE.md" ] || [ -f "$cwd/docs/RISKS.md" ]; then
  phase="Phase 1 (Planning)"
fi
# Re-check forward (phases can be skipped)
if [ -f "$cwd/docs/SRS.md" ] && [ -f "$cwd/docs/ARCHITECTURE.md" ]; then
  phase="Phase 3 (Design) — requirements done"
fi
# Check if we're in implementation
src_files=$(find "$cwd/src" -name "*.ts" -o -name "*.go" -o -name "*.py" -o -name "*.rs" 2>/dev/null | wc -l | tr -d ' ')
if [ "${src_files:-0}" -gt 5 ] && [ -f "$cwd/docs/ARCHITECTURE.md" ]; then
  phase="Phase 4 (Implementation)"
fi

# Collect open blockers from docs (lines with TODO, BLOCKED, or ⚠️)
blockers=""
if [ -f "$cwd/docs/RISKS.md" ]; then
  blockers=$(grep -i "TODO\|BLOCKED\|⚠️\|open risk" "$cwd/docs/RISKS.md" 2>/dev/null | head -3 | sed 's/^[[:space:]]*/  - /' || echo "")
fi

# Build context string — only emit if there's meaningful SDLC state
if [ ! -f "$cwd/docs/VISION.md" ] && [ ! -f "$cwd/docs/DISCOVERY.md" ] && [ ! -f "$cwd/docs/ARCHITECTURE.md" ]; then
  exit 0
fi

context="[Project: ${project_name} | SDLC: ${phase}]"
if [ -n "$blockers" ]; then
  context="${context}
Open blockers from RISKS.md:
${blockers}"
fi

# Emit additionalContext JSON
python3 -c "
import json, sys
ctx = sys.argv[1]
print(json.dumps({'additionalContext': ctx}))
" "$context"
