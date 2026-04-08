# 2026-04-09 Runtime Monitoring

## Scope

- added runtime monitoring scripts without installing any background services
- added one-shot status, health-check, live-watch, and tegrastats capture tools
- validated the scripts on the current Jetson Nano setup

## Commands

```bash
cd themes/monitoring/runtime-health
./status.sh
./health-check.sh
./live-watch.sh
./tegrastats-log.sh 30 1000
```

## Notes

- this module is intentionally service-free
- it is meant to support the existing thermal, memory, and power modules
