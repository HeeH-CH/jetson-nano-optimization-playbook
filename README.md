# Jetson Nano Optimization Playbook

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
- `themes/monitoring/`: metrics, validation, watchdogs
- `tools/`: helper scripts for inspection and data capture
- `logs/`: dated change notes

## Workflow

1. Add or update one theme.
2. Store the exact files or scripts used.
3. Add a short `README.md` beside the change.
4. Add a dated note under `logs/`.
5. Commit with a narrow message.

## First Applied Change

The first tracked change is temperature-based fan control:

- path: `themes/thermal/fan-control/`
- install: `sudo ./install.sh`
- verify: `./status.sh`
- rollback: `sudo ./rollback.sh`

## Snapshot

To capture a quick machine snapshot:

```bash
./tools/collect-system-snapshot.sh
```
