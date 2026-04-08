# 2026-04-09 Disable ModemManager

## Scope

- disabled `ModemManager` because LTE/WWAN is not in use on this machine
- kept Wi-Fi and Ethernet services untouched
- added install, verify, and rollback scripts for the change

## Why

- `ModemManager.service` was enabled and running
- it had a measurable boot cost in the earlier audit
- logs showed repeated unsupported-device probing

## Validation

- `ModemManager.service` masked
- `ModemManager.service` inactive
- network state still intact after the change
