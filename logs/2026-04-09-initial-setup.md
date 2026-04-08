# 2026-04-09 Initial Setup

## Scope

- created a dedicated Jetson Nano optimization repository layout
- added thermal fan control as the first tracked optimization
- stored install, verify, and rollback paths

## Machine State At Capture

- board: NVIDIA Jetson Nano Developer Kit
- l4t: R32.7.6
- kernel: 4.9.337-tegra
- nvpmodel: MAXN

## Applied Thermal Change

A custom service now controls `/sys/devices/pwm-fan/target_pwm` using CPU/GPU temperature.

Curve at capture time:

- `0:0`
- `52:120`
- `57:160`
- `62:200`
- `67:230`
- `72:255`

## Validation

- `jetson-fan-control.service` enabled
- `jetson-fan-control.service` active
- `temp_control=0` after service start

## Extra Setup Note

- on the stock OS image, use `nvm use 16`
- newer Node.js versions may fail because the stock userspace is too old for the required `glibc` level
