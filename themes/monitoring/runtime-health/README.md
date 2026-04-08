# Runtime Health

This module adds runtime inspection scripts without installing any services.

## Scripts

- `status.sh`
  - one-shot summary of temperatures, fan state, memory, zram, power profile, and key services
- `health-check.sh`
  - threshold-based pass/warn/crit check for quick triage
- `live-watch.sh`
  - compact terminal dashboard loop
- `tegrastats-log.sh`
  - capture `tegrastats` output into a timestamped log file

## Usage

```bash
cd themes/monitoring/runtime-health
./status.sh
./health-check.sh
./live-watch.sh
./tegrastats-log.sh 30 1000
```

The `tegrastats-log.sh` arguments are:

- duration seconds
- interval milliseconds

## Thresholds

Current defaults in `health-check.sh`:

- CPU warn: `75C`
- CPU crit: `82C`
- GPU warn: `72C`
- GPU crit: `80C`
- available memory warn: `512 MB`
- root filesystem warn: `85%`

Adjust them in the script if your workload is different.
