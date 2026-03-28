#!/usr/bin/env python3
"""
block-dangerous.py -- PreToolUse hook

Inspects Bash commands before they run and blocks anything on the
dangerous-commands blocklist.  This acts as a safety net to prevent
destructive operations that are difficult or impossible to undo.

Blocked patterns:
  - rm -rf /              (wipe root filesystem)
  - DROP TABLE            (destroy database tables)
  - DELETE FROM w/o WHERE (delete all rows in a table)
  - git push --force      (rewrite remote history)
  - git reset --hard      (discard uncommitted work)
  - npm publish           (publish to public registry)
  - curl | bash           (execute untrusted remote code)

Exit codes:
  0  — allow the command
  2  — block the command (Claude will see the stderr message)
"""

import json
import re
import sys


# Each entry is (compiled regex, human-readable description).
BLOCKLIST: list[tuple[re.Pattern, str]] = [
    (
        re.compile(
            r"\brm\s+(-[a-zA-Z]*r[a-zA-Z]*f|--recursive\b.*--force|-[a-zA-Z]*f[a-zA-Z]*r)\s+/\s*$|rm\s+-rf\s+/\s*$",
            re.IGNORECASE,
        ),
        "rm -rf / — this would delete the entire filesystem",
    ),
    (
        re.compile(r"\bDROP\s+TABLE\b", re.IGNORECASE),
        "DROP TABLE — destructive database operation",
    ),
    (
        re.compile(
            r"\bDELETE\s+FROM\s+\S+\s*(?:;|$)(?!.*\bWHERE\b)", re.IGNORECASE
        ),
        "DELETE FROM without WHERE clause — would delete all rows",
    ),
    (
        re.compile(
            r"\bgit\s+push\s+.*--force\b|\bgit\s+push\s+-f\b", re.IGNORECASE
        ),
        "git push --force — would rewrite remote history",
    ),
    (
        re.compile(r"\bgit\s+reset\s+--hard\b", re.IGNORECASE),
        "git reset --hard — would discard all uncommitted changes",
    ),
    (
        re.compile(r"\bnpm\s+publish\b", re.IGNORECASE),
        "npm publish — would publish package to the public registry",
    ),
    (
        re.compile(
            r"\bcurl\s+.*\|\s*bash\b|\bwget\s+.*\|\s*bash\b", re.IGNORECASE
        ),
        "curl | bash — executing untrusted remote code",
    ),
]


def main() -> None:
    # Read the PreToolUse event from stdin.
    try:
        event = json.load(sys.stdin)
    except (json.JSONDecodeError, ValueError):
        # If we can't parse the input, allow the command to proceed
        # rather than blocking everything.
        sys.exit(0)

    # Extract the command string.  For the Bash tool the command lives
    # at tool_input.command.
    tool_input = event.get("tool_input", {})
    command = tool_input.get("command", "")

    if not command:
        sys.exit(0)

    # Check every pattern in the blocklist.
    for pattern, description in BLOCKLIST:
        if pattern.search(command):
            # Print a helpful message to stderr — Claude will see this.
            print(
                f"BLOCKED: {description}\n"
                f"Command: {command}\n"
                f"\n"
                f"If you truly need to run this command, ask the user to "
                f"run it manually outside of Claude Code.",
                file=sys.stderr,
            )
            # Exit 2 signals Claude Code to block the tool use.
            sys.exit(2)

    # No blocklist match — allow the command.
    sys.exit(0)


if __name__ == "__main__":
    main()
