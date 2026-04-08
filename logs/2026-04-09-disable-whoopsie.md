# 2026-04-09 Disable Whoopsie

## Scope

- disabled `whoopsie`, Ubuntu's crash report submission daemon
- kept networking, camera, and other runtime services unchanged
- added install, verify, and rollback scripts for the change

## Why

- `whoopsie.service` was enabled and running
- crash report submission is not needed on this machine
- background endpoint checks were unnecessary overhead

## Validation

- `whoopsie.service` masked
- `whoopsie.service` inactive
- network state still intact after the change
