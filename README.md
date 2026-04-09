# Jetson Nano Optimization Playbook

[English](README.md) | [한국어](README.ko.md)

This repository is a reproducible notebook for one Jetson Nano system.
Every applied tweak should live here as:

- code
- install or rollback steps
- verification steps
- rationale

## Current System

- Board: NVIDIA Jetson Nano Developer Kit
- JetPack/L4T: R32.7.6
- Kernel: `4.9.337-tegra`
- Power mode at capture time: `MAXN`

## Layout

- `themes/thermal/`: cooling and temperature control
- `themes/power/`: power mode and clocks
- `themes/memory/`: swap, zram, memory pressure control
- `themes/storage/`: SD card, SSD, I/O, cleanup
- `themes/services/`: systemd, boot trimming, disabled services
- `themes/deployment/`: inference runtime, containers, camera/data pipelines
- `themes/monitoring/`: metrics, validation, watchdogs
- `tools/`: helper scripts for inspection and data capture
- `logs/`: dated change notes

## Workflow

1. Add or update one theme.
2. Store the exact files or scripts used.
3. Add a short `README.md` beside the change.
4. Add a dated note under `logs/`.
5. Commit with a narrow message.

## Setup Notes

- On the stock Jetson Nano OS image, use Node.js `16` with `nvm use 16`.
- Newer Node.js releases may fail to install or run on the stock userspace due to
  an older `glibc` baseline.
- Keep this in mind before assuming that an npm or nvm failure is package-specific.

## Applied Changes

- thermal fan control:
  - path: `themes/thermal/fan-control/`
  - install: `sudo ./install.sh`
  - verify: `./status.sh`
  - rollback: `sudo ./rollback.sh`
- memory zram tuning:
  - path: `themes/memory/zram-tuning/`
  - install: `sudo ./install.sh`
  - verify: `./status.sh`
  - rollback: `sudo ./rollback.sh`
- storage log retention:
  - path: `themes/storage/log-retention/`
  - install: `sudo ./install.sh`
  - verify: `./status.sh`
  - rollback: `sudo ./rollback.sh`
- power performance profile:
  - path: `themes/power/performance-profile/`
  - install: `sudo ./install.sh`
  - verify: `./status.sh`
  - rollback: `sudo ./rollback.sh`
- runtime monitoring:
  - path: `themes/monitoring/runtime-health/`
  - quick status: `./status.sh`
  - health check: `./health-check.sh`
  - live watch: `./live-watch.sh`
  - tegrastats log: `./tegrastats-log.sh`
- stress profiling:
  - path: `themes/monitoring/stress-profiles/`
  - cpu burn: `./cpu-burn.sh`
  - capture run: `./capture-run.sh`
  - summary: `./summarize-run.sh <run-dir>`
- disable ModemManager:
  - path: `themes/services/disable-modemmanager/`
  - install: `sudo ./install.sh`
  - verify: `./status.sh`
  - rollback: `sudo ./rollback.sh`
- disable whoopsie:
  - path: `themes/services/disable-whoopsie/`
  - install: `sudo ./install.sh`
  - verify: `./status.sh`
  - rollback: `sudo ./rollback.sh`
- disable kerneloops:
  - path: `themes/services/disable-kerneloops/`
  - install: `sudo ./install.sh`
  - verify: `./status.sh`
  - rollback: `sudo ./rollback.sh`
- headless transition guide:
  - path: `themes/services/headless-transition/`
  - current state: `./status.sh`
  - apply later: follow `README.md`
  - rollback later: follow `README.md`
- AC8265 Wi-Fi backport:
  - path: `themes/services/ac8265-wifi-backport/`
  - install: `sudo ./install.sh`
  - verify: `./status.sh`
  - rollback: `sudo ./rollback.sh`
- ONNX/TensorRT deployment guide:
  - path: `themes/deployment/onnx-tensorrt-guide/`
  - current state: documentation only
  - apply later: follow `README.md`

## Snapshot

To capture a quick machine snapshot:

```bash
./tools/collect-system-snapshot.sh
```

## Publish

When `gh` authentication is valid:

```bash
./tools/publish.sh
```
