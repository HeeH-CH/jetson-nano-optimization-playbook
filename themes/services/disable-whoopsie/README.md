# Disable Whoopsie

This module disables `whoopsie`, Ubuntu's crash report submission daemon.

## What It Is

- `whoopsie` watches for crash reports and tries to submit them upstream
- it is mainly useful for Ubuntu-side error reporting and debugging workflows
- it is not required for normal networking, camera, or Jetson runtime operation

## Why Disable It

On this machine:

- `whoopsie.service` was enabled and running
- it was polling network state and trying to reach Ubuntu reporting endpoints
- crash report submission is not needed for the current usage pattern

## Install

```bash
cd themes/services/disable-whoopsie
sudo ./install.sh
```

## Verify

```bash
cd themes/services/disable-whoopsie
./status.sh
```

Expected state:

- `whoopsie.service` is `inactive`
- `whoopsie.service` is `masked`

## Rollback

```bash
cd themes/services/disable-whoopsie
sudo ./rollback.sh
```

Re-enable this if you want Ubuntu crash report submission again.
