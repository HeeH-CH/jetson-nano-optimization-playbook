#!/usr/bin/env bash
set -euo pipefail

RUN_DIR="${1:-}"

if [[ -z "${RUN_DIR}" || ! -d "${RUN_DIR}" ]]; then
  echo "usage: $0 <run-dir>" >&2
  exit 1
fi

extract_temp() {
  local label=$1
  local file=$2
  awk -v label="${label}" '$1==label {print $2}' "${file}" | tr -d 'C'
}

extract_value() {
  local label=$1
  local file=$2
  awk -v label="${label}" '$1==label {print $2}' "${file}"
}

cpu_before="$(extract_temp 'CPU-therm' "${RUN_DIR}/status-before.txt" 2>/dev/null || true)"
cpu_after="$(extract_temp 'CPU-therm' "${RUN_DIR}/status-after.txt" 2>/dev/null || true)"
gpu_before="$(extract_temp 'GPU-therm' "${RUN_DIR}/status-before.txt" 2>/dev/null || true)"
gpu_after="$(extract_temp 'GPU-therm' "${RUN_DIR}/status-after.txt" 2>/dev/null || true)"
fan_before="$(extract_value 'target_pwm' "${RUN_DIR}/status-before.txt" 2>/dev/null || true)"
fan_after="$(extract_value 'target_pwm' "${RUN_DIR}/status-after.txt" 2>/dev/null || true)"
tegrastats_lines="$(wc -l < "${RUN_DIR}/tegrastats.log" 2>/dev/null || echo 0)"

printf 'run_dir: %s\n' "${RUN_DIR}"
printf 'cpu_temp: %sC -> %sC\n' "${cpu_before:-n/a}" "${cpu_after:-n/a}"
printf 'gpu_temp: %sC -> %sC\n' "${gpu_before:-n/a}" "${gpu_after:-n/a}"
printf 'fan_target_pwm: %s -> %s\n' "${fan_before:-n/a}" "${fan_after:-n/a}"
printf 'tegrastats_lines: %s\n' "${tegrastats_lines}"

if [[ -f "${RUN_DIR}/meta.txt" ]]; then
  cat "${RUN_DIR}/meta.txt"
fi
