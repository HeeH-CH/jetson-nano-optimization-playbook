#!/usr/bin/env bash
set -euo pipefail

unit_state() {
  local mode=$1
  local unit=$2
  local out
  out="$(systemctl "${mode}" "${unit}" 2>/dev/null || true)"
  if [[ -n "${out}" ]]; then
    printf '%s' "${out}"
  else
    printf 'unknown'
  fi
}

printf 'ModemManager.service active=%s enabled=%s\n' \
  "$(unit_state is-active ModemManager.service)" \
  "$(unit_state is-enabled ModemManager.service)"

echo
nmcli device status || true
