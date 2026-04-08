#!/usr/bin/env bash
set -euo pipefail

CPU_WARN_C=75
CPU_CRIT_C=82
GPU_WARN_C=72
GPU_CRIT_C=80
MEM_AVAILABLE_WARN_MB=512
ROOT_USE_WARN_PCT=85

status=0

temp_c() {
  local zone_type=$1
  local zone
  for zone in /sys/class/thermal/thermal_zone*; do
    [[ -r "${zone}/type" && -r "${zone}/temp" ]] || continue
    if [[ "$(<"${zone}/type")" == "${zone_type}" ]]; then
      printf '%s' "$(( $(<"${zone}/temp") / 1000 ))"
      return 0
    fi
  done
  return 1
}

check_service() {
  local svc=$1
  if systemctl is-active --quiet "${svc}"; then
    printf 'PASS service %-28s active\n' "${svc}"
  elif [[ "${svc}" == "nvzramconfig.service" ]] && systemctl is-enabled --quiet "${svc}"; then
    printf 'PASS service %-28s oneshot-configured\n' "${svc}"
  else
    printf 'WARN service %-28s inactive\n' "${svc}"
    (( status < 1 )) && status=1
  fi
}

cpu_temp="$(temp_c CPU-therm || echo 0)"
gpu_temp="$(temp_c GPU-therm || echo 0)"
mem_available_mb="$(free -m | awk '/^Mem:/ {print $7}')"
root_use_pct="$(df -P / | awk 'NR==2 {gsub(/%/,"",$5); print $5}')"

if (( cpu_temp >= CPU_CRIT_C )); then
  printf 'CRIT cpu_temp %sC\n' "${cpu_temp}"
  status=2
elif (( cpu_temp >= CPU_WARN_C )); then
  printf 'WARN cpu_temp %sC\n' "${cpu_temp}"
  (( status < 1 )) && status=1
else
  printf 'PASS cpu_temp %sC\n' "${cpu_temp}"
fi

if (( gpu_temp >= GPU_CRIT_C )); then
  printf 'CRIT gpu_temp %sC\n' "${gpu_temp}"
  status=2
elif (( gpu_temp >= GPU_WARN_C )); then
  printf 'WARN gpu_temp %sC\n' "${gpu_temp}"
  (( status < 1 )) && status=1
else
  printf 'PASS gpu_temp %sC\n' "${gpu_temp}"
fi

if (( mem_available_mb < MEM_AVAILABLE_WARN_MB )); then
  printf 'WARN mem_available %sMB\n' "${mem_available_mb}"
  (( status < 1 )) && status=1
else
  printf 'PASS mem_available %sMB\n' "${mem_available_mb}"
fi

if (( root_use_pct >= ROOT_USE_WARN_PCT )); then
  printf 'WARN root_fs %s%%\n' "${root_use_pct}"
  (( status < 1 )) && status=1
else
  printf 'PASS root_fs %s%%\n' "${root_use_pct}"
fi

check_service jetson-fan-control.service
check_service jetson-performance-profile.service
check_service nvzramconfig.service

if [[ -r /sys/devices/pwm-fan/target_pwm ]]; then
  printf 'INFO target_pwm %s\n' "$(< /sys/devices/pwm-fan/target_pwm)"
fi

if [[ -r /sys/devices/pwm-fan/cur_pwm ]]; then
  printf 'INFO cur_pwm %s\n' "$(< /sys/devices/pwm-fan/cur_pwm)"
fi

exit "${status}"
