#!/usr/bin/env python3
"""
security-scanner.py -- PostToolUse hook

Scans files after Claude edits them for hardcoded secrets, API keys,
passwords, and other sensitive material.  When a potential secret is
found the warning is printed to stdout so Claude receives it as
feedback and can remediate (e.g., move the value to an env var).

Detected patterns:
  - Generic API keys (api_key, apiKey, api-key assignments)
  - AWS access key IDs  (AKIA...)
  - AWS secret access keys (40-char base64)
  - RSA / EC / generic private keys (PEM headers)
  - Passwords in string assignments
  - Bearer / auth tokens
  - Database connection strings with embedded credentials
  - Generic secret / token assignments

Exit code is always 0 — this hook is purely informational.
"""

import json
import re
import sys
from pathlib import Path


# Each rule is (compiled regex, human-readable label).
SECRET_PATTERNS: list[tuple[re.Pattern, str]] = [
    # ── API keys ─────────────────────────────────────────────────────
    (
        re.compile(
            r"""(?:api[_-]?key|apikey|api[_-]?secret)\s*[:=]\s*["'][A-Za-z0-9_\-]{16,}["']""",
            re.IGNORECASE,
        ),
        "Possible hardcoded API key",
    ),
    # ── AWS access key ID ────────────────────────────────────────────
    (
        re.compile(r"\bAKIA[0-9A-Z]{16}\b"),
        "AWS Access Key ID",
    ),
    # ── AWS secret access key (40-char base64-ish string) ────────────
    (
        re.compile(
            r"""(?:aws[_-]?secret[_-]?access[_-]?key|secret[_-]?key)\s*[:=]\s*["'][A-Za-z0-9/+=]{40}["']""",
            re.IGNORECASE,
        ),
        "Possible AWS Secret Access Key",
    ),
    # ── Private keys (PEM format) ────────────────────────────────────
    (
        re.compile(r"-----BEGIN\s+(?:RSA |EC |DSA |OPENSSH )?PRIVATE KEY-----"),
        "Private key (PEM format)",
    ),
    # ── Passwords in string assignments ──────────────────────────────
    (
        re.compile(
            r"""(?:password|passwd|pwd)\s*[:=]\s*["'][^"']{4,}["']""",
            re.IGNORECASE,
        ),
        "Possible hardcoded password",
    ),
    # ── Bearer / auth tokens ─────────────────────────────────────────
    (
        re.compile(
            r"""(?:bearer|token|auth[_-]?token|access[_-]?token)\s*[:=]\s*["'][A-Za-z0-9_\-.]{20,}["']""",
            re.IGNORECASE,
        ),
        "Possible hardcoded auth/bearer token",
    ),
    # ── Database connection strings with credentials ─────────────────
    (
        re.compile(
            r"""(?:postgres|mysql|mongodb|redis|amqp)(?:ql)?://[^:]+:[^@]+@""",
            re.IGNORECASE,
        ),
        "Database connection string with embedded credentials",
    ),
    # ── Generic secret / token in env-style assignment ───────────────
    (
        re.compile(
            r"""(?:SECRET|TOKEN|PRIVATE[_-]KEY)\s*=\s*["'][A-Za-z0-9_\-/+=]{16,}["']""",
        ),
        "Possible hardcoded secret or token",
    ),
]

# File extensions to skip (binary, images, lock files, etc.)
SKIP_EXTENSIONS = {
    ".png", ".jpg", ".jpeg", ".gif", ".ico", ".svg", ".webp",
    ".woff", ".woff2", ".ttf", ".eot",
    ".zip", ".tar", ".gz", ".bz2",
    ".lock", ".min.js", ".min.css",
    ".pyc", ".pyo", ".so", ".dylib", ".dll",
}


def main() -> None:
    # Read the PostToolUse event from stdin.
    try:
        event = json.load(sys.stdin)
    except (json.JSONDecodeError, ValueError):
        sys.exit(0)

    # Extract the file path.
    tool_input = event.get("tool_input", {})
    file_path = tool_input.get("file_path") or tool_input.get("path") or ""

    if not file_path:
        sys.exit(0)

    path = Path(file_path)

    if not path.is_file():
        sys.exit(0)

    # Skip binary / non-text files.
    if path.suffix.lower() in SKIP_EXTENSIONS:
        sys.exit(0)

    # Read the file content.
    try:
        content = path.read_text(errors="replace")
    except OSError:
        sys.exit(0)

    # Scan each line for secret patterns.
    findings: list[str] = []

    for line_num, line in enumerate(content.splitlines(), start=1):
        for pattern, label in SECRET_PATTERNS:
            if pattern.search(line):
                # Truncate the matching line to avoid leaking the full
                # secret into conversation context.
                snippet = line.strip()
                if len(snippet) > 80:
                    snippet = snippet[:77] + "..."
                findings.append(f"  Line {line_num}: {label}")
                findings.append(f"    {snippet}")

    # Report findings.
    if findings:
        print(f"WARNING: Potential secrets detected in {file_path}")
        print()
        for finding in findings:
            print(finding)
        print()
        print(
            "Consider moving these values to environment variables or "
            "a .env file (and ensure .env is in .gitignore)."
        )

    # Always exit 0 — this is purely informational.
    sys.exit(0)


if __name__ == "__main__":
    main()
