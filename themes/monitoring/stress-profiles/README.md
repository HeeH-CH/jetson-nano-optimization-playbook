# Stress Profiles

This module adds short-run stress and capture scripts for comparing the system
before and after tuning changes.

## Scripts

- `cpu-burn.sh`
  - simple CPU saturation using shell-built tools only
- `capture-run.sh`
  - captures baseline state, runs CPU stress, records `tegrastats`, and captures end state
- `summarize-run.sh <run-dir>`
  - prints a compact summary from one captured run directory

## Usage

```bash
cd themes/monitoring/stress-profiles
./capture-run.sh
./capture-run.sh 30 1000 ./runs
./summarize-run.sh ./runs/run-YYYY-MM-DD-HHMMSS
```

Arguments for `capture-run.sh`:

- duration seconds, default `20`
- tegrastats interval milliseconds, default `1000`
- output root directory, default `./runs`

## Notes

- this profile is CPU-oriented
- it does not install packages
- it should be enough to compare fan, temperature, memory, and power behavior
- avoid long runs if the board is in a closed enclosure or unstable power setup
