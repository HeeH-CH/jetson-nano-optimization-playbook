#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
STATUS_SCRIPT="${SCRIPT_DIR}/../runtime-health/status.sh"
HEALTH_SCRIPT="${SCRIPT_DIR}/../runtime-health/health-check.sh"
CPU_BURN_SCRIPT="${SCRIPT_DIR}/cpu-burn.sh"

DURATION_SECONDS="${1:-20}"
INTERVAL_MS="${2:-1000}"
OUTPUT_ROOT="${3:-./runs}"

timestamp="$(date '+%F-%H%M%S')"
run_dir="${OUTPUT_ROOT}/run-${timestamp}"

mkdir -p "${run_dir}"

echo "run_dir=${run_dir}"

"${STATUS_SCRIPT}" > "${run_dir}/status-before.txt"
"${HEALTH_SCRIPT}" > "${run_dir}/health-before.txt" || true

tegrastats --stop >/dev/null 2>&1 || true
tegrastats --interval "${INTERVAL_MS}" --logfile "${run_dir}/tegrastats.log" --start

stress_rc=0
if ! "${CPU_BURN_SCRIPT}" "${DURATION_SECONDS}" > "${run_dir}/cpu-burn.log" 2>&1; then
  stress_rc=$?
fi

tegrastats --stop >/dev/null 2>&1 || true

"${STATUS_SCRIPT}" > "${run_dir}/status-after.txt"
"${HEALTH_SCRIPT}" > "${run_dir}/health-after.txt" || true

{
  echo "duration_seconds=${DURATION_SECONDS}"
  echo "interval_ms=${INTERVAL_MS}"
  echo "stress_rc=${stress_rc}"
  echo "timestamp=${timestamp}"
} > "${run_dir}/meta.txt"

echo "done"
echo "summary:"
"${SCRIPT_DIR}/summarize-run.sh" "${run_dir}" || true
