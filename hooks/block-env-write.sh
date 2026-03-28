#!/bin/bash
# Block writes to .env files and files containing secret patterns.
# Hook type: PreToolUse (Write)

input=$(cat)
file_path=$(echo "$input" | jq -r '.tool_input.file_path // empty')

# Block .env files
if [[ "$file_path" =~ \.env($|\..*) ]]; then
  echo "BLOCKED: Writing to .env files is not allowed. Use environment variables or a secrets manager."
  exit 2
fi

# Block files that look like credential stores
basename=$(basename "$file_path" 2>/dev/null)
case "$basename" in
  credentials.json|secrets.json|*.key|*.pem|*.p12|id_rsa|id_ed25519)
    echo "BLOCKED: Writing to credential/key files is not allowed."
    exit 2
    ;;
esac

exit 0
