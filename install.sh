#!/bin/bash
#
# Install claude-experts globally for all Claude Code sessions
#
# Symlinks agents, skills, hooks, and references into ~/.claude/
# so they're available in every project. Edits to this repo
# automatically update the installed files (symlinks).
#

set -e

# Platform preflight — supported: macOS, Linux, WSL. NOT supported: native Windows.
case "$(uname -s)" in
  Darwin|Linux) ;;  # supported
  MINGW*|MSYS*|CYGWIN*)
    echo "ERROR: Native Windows (Git Bash / MSYS / Cygwin) is not supported." >&2
    echo "" >&2
    echo "Please install WSL2 and run the installer from inside your WSL shell:" >&2
    echo "  https://learn.microsoft.com/en-us/windows/wsl/install" >&2
    echo "" >&2
    echo "Then from inside WSL:" >&2
    echo "  git clone https://github.com/bpmforge/claude-experts.git" >&2
    echo "  cd claude-experts && ./install.sh" >&2
    exit 2
    ;;
  *)
    echo "WARNING: unrecognized platform $(uname -s). Proceeding anyway." >&2
    ;;
esac

if grep -qi microsoft /proc/version 2>/dev/null; then
  echo "Detected: Windows Subsystem for Linux (WSL). Proceeding."
fi

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CLAUDE_HOME="$HOME/.claude"

echo ""
echo "Installing claude-experts..."
echo "Source: $SCRIPT_DIR"
echo "Target: $CLAUDE_HOME"
echo ""

# Create directories
mkdir -p "$CLAUDE_HOME/agents"
mkdir -p "$CLAUDE_HOME/hooks"

# ─── 1. Symlink agents ───
echo "Installing agents..."
count=0
for agent in "$SCRIPT_DIR/agents/"*.md; do
  [ -f "$agent" ] || continue
  ln -sf "$agent" "$CLAUDE_HOME/agents/$(basename "$agent")"
  count=$((count + 1))
done
echo "  $count agents installed"

# ─── 2. Symlink skills ───
echo "Installing skills..."
count=0
for skill_dir in "$SCRIPT_DIR/skills/"*/; do
  [ -d "$skill_dir" ] || continue
  skill_name=$(basename "$skill_dir")
  mkdir -p "$CLAUDE_HOME/skills/$skill_name"
  if [ -f "$skill_dir/SKILL.md" ]; then
    ln -sf "$skill_dir/SKILL.md" "$CLAUDE_HOME/skills/$skill_name/SKILL.md"
    count=$((count + 1))
  fi
done
echo "  $count skills installed"

# ─── 3. Symlink references into agents dir ───
# Agents Read files from ~/.claude/agents/ — references go there too
echo "Installing references..."
count=0
for ref in "$SCRIPT_DIR/references/"*.md; do
  [ -f "$ref" ] || continue
  ln -sf "$ref" "$CLAUDE_HOME/agents/$(basename "$ref")"
  count=$((count + 1))
done
echo "  $count reference files installed"

# ─── 4. Symlink scripts ───
echo "Installing scripts..."
mkdir -p "$CLAUDE_HOME/scripts"
count=0
for script in "$SCRIPT_DIR/scripts/"*.sh; do
  [ -f "$script" ] || continue
  ln -sf "$script" "$CLAUDE_HOME/scripts/$(basename "$script")"
  chmod +x "$script"
  count=$((count + 1))
done
echo "  $count scripts installed"

# ─── 4b. Install Semgrep custom rules ───
echo "Installing Semgrep custom rules..."
if [ -d "$SCRIPT_DIR/.semgrep" ]; then
  rm -rf "$CLAUDE_HOME/.semgrep"
  ln -sf "$SCRIPT_DIR/.semgrep" "$CLAUDE_HOME/.semgrep"
  rule_count=$(grep -r '^\s*- id:' "$SCRIPT_DIR/.semgrep/" 2>/dev/null | wc -l | tr -d ' ')
  file_count=$(find "$SCRIPT_DIR/.semgrep" -name '*.yml' | wc -l | tr -d ' ')
  echo "  $rule_count rules in $file_count rulesets linked → $CLAUDE_HOME/.semgrep/"
else
  echo "  No .semgrep/ directory found — skipping"
fi

# ─── 5. Copy hooks (scripts need to be executable, not symlinks) ───
echo "Installing hooks..."
count=0
for hook in "$SCRIPT_DIR/hooks/"*; do
  [ -f "$hook" ] || continue
  cp "$hook" "$CLAUDE_HOME/hooks/$(basename "$hook")"
  chmod +x "$CLAUDE_HOME/hooks/$(basename "$hook")"
  count=$((count + 1))
done
echo "  $count hooks installed"

# ─── 5. Update settings.json with hook configuration ───
SETTINGS="$CLAUDE_HOME/settings.json"
if [ -f "$SETTINGS" ]; then
  # Check if our hooks are already configured
  if grep -q "block-env-write" "$SETTINGS" 2>/dev/null; then
    echo "  Hook configuration already present in settings.json"
  else
    echo "  NOTE: You may need to manually add hook entries to $SETTINGS"
    echo "  See the hooks/ directory for available hook scripts"
  fi
else
  echo "  WARNING: $SETTINGS not found — create it to configure hooks"
fi

# ─── 6. Update CLAUDE.md ───
CLAUDE_MD="$CLAUDE_HOME/CLAUDE.md"
if grep -q "## Expert System" "$CLAUDE_MD" 2>/dev/null; then
  echo "  Expert System section already exists in CLAUDE.md"
else
  cat >> "$CLAUDE_MD" << 'EXPERT_SECTION'

---

## Expert System

This Claude Code installation includes the expert system with 10 specialist agents.

### Available Experts

| Command | Expert | Domain |
|---------|--------|--------|
| `/security` | Security Auditor | OWASP, threat modeling, vulnerability scanning |
| `/research` | Researcher | Investigation, source evaluation, comparison |
| `/test-expert` | Test Engineer | Playwright, vitest, test strategy, coverage |
| `/dba` | Database Architect | Schema, migrations, query optimization |
| `/ux` | UX Engineer | Workflows, components, WCAG accessibility |
| `/devops` | SRE | Runbooks, CI/CD, monitoring, incident response |
| `/containers` | Container Ops | Podman/Docker, compose, debugging |
| `/review-code` | Code Reviewer | Quality, patterns, tech debt |
| `/perf` | Performance Engineer | Profiling, benchmarks, optimization |
| `/api-design` | API Designer | REST/GraphQL, contracts, versioning |

### How Experts Work

Each expert: Understands → Researches → Plans → Executes → Verifies → Reports.
Experts use `memory: project` to build institutional knowledge across sessions.
EXPERT_SECTION
  echo "  Added Expert System section to CLAUDE.md"
fi

# ─── 7. Store install path ───
echo "$SCRIPT_DIR" > "$CLAUDE_HOME/.experts-install-path"

echo ""
echo "Installation complete!"
echo ""
echo "Files installed:"
echo "  ~/.claude/agents/*.md          (agents + references)"
echo "  ~/.claude/skills/*/SKILL.md    (skill triggers)"
echo "  ~/.claude/scripts/*.sh         (audit + utility scripts)"
echo "  ~/.claude/.semgrep/            (186 custom rules, 11 languages)"
echo "  ~/.claude/hooks/*              (automation scripts)"
echo "  ~/.claude/CLAUDE.md            (updated with expert docs)"
echo ""
echo "All expert commands are now available in Claude Code sessions."
echo ""
echo "Optional: Install community Semgrep rule sources for deep security audits:"
echo "  $SCRIPT_DIR/scripts/update-semgrep-rules.sh              Clone Trail of Bits, elttam, GitLab, 0xdea rules"
echo "  $SCRIPT_DIR/scripts/update-semgrep-rules.sh --bump       Pull latest + write .semgrep/community-rules.lock"
echo "  $SCRIPT_DIR/scripts/update-semgrep-rules.sh --verify     Verify cached rules match pinned commits"
echo "  $SCRIPT_DIR/scripts/semgrep-full-audit.sh                Run full audit with all community + framework rules"
echo "  $SCRIPT_DIR/scripts/semgrep-full-audit.sh --fast         CI-tier scan (< 60s)"
echo "  $SCRIPT_DIR/scripts/semgrep-full-audit.sh --autofix      OPT-IN autofix (LOW/WARNING only, refuses HIGH/CRITICAL)"
echo "  Custom gap-filler rules: ~/.claude/.semgrep/ (186 rules, 11 languages)"
echo "  Community rules cache:   ~/.semgrep/rules/"
echo ""
