#!/usr/bin/env bash
set -euo pipefail

if [[ $# -lt 1 ]]; then
  echo "usage: $0 short-title" >&2
  exit 1
fi

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
DATE_STR="$(date +%F)"
SLUG="$(printf '%s' "$*" | tr '[:upper:]' '[:lower:]' | tr ' ' '-' | tr -cd 'a-z0-9-_')"
TARGET="${ROOT_DIR}/logs/${DATE_STR}-${SLUG}.md"

if [[ -e "${TARGET}" ]]; then
  echo "File already exists: ${TARGET}" >&2
  exit 1
fi

cat > "${TARGET}" <<EOF
# ${DATE_STR} $*

## Scope

- 

## Commands

\`\`\`bash
\`\`\`

## Validation

- 
EOF

echo "${TARGET}"
