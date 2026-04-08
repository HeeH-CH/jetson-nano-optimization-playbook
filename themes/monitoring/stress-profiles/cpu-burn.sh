#!/usr/bin/env bash
set -euo pipefail

DURATION_SECONDS="${1:-20}"
WORKERS="${2:-$(nproc)}"

if [[ ! "${DURATION_SECONDS}" =~ ^[0-9]+$ || ! "${WORKERS}" =~ ^[0-9]+$ ]]; then
  echo "usage: $0 [duration_seconds] [workers]" >&2
  exit 1
fi

if (( WORKERS < 1 )); then
  WORKERS=1
fi

pids=()

cleanup() {
  local pid
  for pid in "${pids[@]:-}"; do
    kill "${pid}" 2>/dev/null || true
  done
  wait 2>/dev/null || true
}

trap cleanup EXIT INT TERM

for _ in $(seq 1 "${WORKERS}"); do
  bash -lc 'while :; do :; done' &
  pids+=("$!")
done

sleep "${DURATION_SECONDS}"
