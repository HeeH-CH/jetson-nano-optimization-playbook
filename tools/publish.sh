#!/usr/bin/env bash
set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
REPO_NAME="${1:-$(basename "${REPO_DIR}")}"

cd "${REPO_DIR}"

if ! command -v gh >/dev/null 2>&1; then
  echo "gh is required" >&2
  exit 1
fi

gh auth status >/dev/null 2>&1

if ! git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  echo "Not a git repository" >&2
  exit 1
fi

if git remote get-url origin >/dev/null 2>&1; then
  branch="$(git rev-parse --abbrev-ref HEAD)"
  git push -u origin "${branch}"
  exit 0
fi

gh repo create "${REPO_NAME}" \
  --public \
  --source=. \
  --remote=origin \
  --push
