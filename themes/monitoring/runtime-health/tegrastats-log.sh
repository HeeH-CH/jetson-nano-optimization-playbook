#!/usr/bin/env bash
set -euo pipefail

DURATION_SECONDS="${1:-30}"
INTERVAL_MS="${2:-1000}"
OUTPUT_DIR="${3:-./captures}"

mkdir -p "${OUTPUT_DIR}"

timestamp="$(date '+%F-%H%M%S')"
outfile="${OUTPUT_DIR}/tegrastats-${timestamp}.log"

echo "writing ${outfile}"
timeout "${DURATION_SECONDS}" tegrastats --interval "${INTERVAL_MS}" --logfile "${outfile}" || true
echo "done"
wc -l "${outfile}" 2>/dev/null || true
