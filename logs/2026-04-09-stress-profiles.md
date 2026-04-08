# 2026-04-09 Stress Profiles

## Scope

- added short-run stress and capture scripts for before/after comparisons
- kept the module package-free and service-free
- validated a short CPU stress capture on the current Jetson Nano

## Commands

```bash
cd themes/monitoring/stress-profiles
./capture-run.sh
./summarize-run.sh ./runs/run-YYYY-MM-DD-HHMMSS
```

## Notes

- intended for quick thermal and power comparisons
- current implementation is CPU-focused
- validated with a short `5s` capture run on the current machine
