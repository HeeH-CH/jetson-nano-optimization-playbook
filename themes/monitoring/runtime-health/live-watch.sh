#!/usr/bin/env bash
set -euo pipefail

INTERVAL_SECONDS="${1:-2}"

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
  printf 'n/a'
}

while true; do
  clear
  echo "Jetson Nano Live Watch"
  echo "timestamp: $(date '+%F %T %Z')"
  echo
  printf 'cpu_temp: %sC\n' "$(temp_c CPU-therm)"
  printf 'gpu_temp: %sC\n' "$(temp_c GPU-therm)"
  printf 'fan_target_pwm: %s\n' "$(cat /sys/devices/pwm-fan/target_pwm 2>/dev/null || echo n/a)"
  printf 'fan_cur_pwm: %s\n' "$(cat /sys/devices/pwm-fan/cur_pwm 2>/dev/null || echo n/a)"
  printf 'fan_mode: %s\n' "$(cat /sys/devices/pwm-fan/temp_control 2>/dev/null || echo n/a)"
  printf 'cpu0_cur_khz: %s\n' "$(cat /sys/devices/system/cpu/cpufreq/policy0/scaling_cur_freq 2>/dev/null || echo n/a)"
  printf 'gpu_cur_hz: %s\n' "$(cat /sys/devices/gpu.0/devfreq/57000000.gpu/cur_freq 2>/dev/null || echo n/a)"
  printf 'mem_available: %s\n' "$(free -h | awk '/^Mem:/ {print $7}')"
  printf 'swap_used: %s\n' "$(free -h | awk '/^Swap:/ {print $3}')"
  printf 'root_use: %s\n' "$(df -h / | awk 'NR==2 {print $5}')"
  echo
  echo "tegrastats:"
  timeout 2s tegrastats --interval 1000 2>/dev/null | head -n 1 || true
  sleep "${INTERVAL_SECONDS}"
done
