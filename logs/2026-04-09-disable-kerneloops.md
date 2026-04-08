# 2026-04-09 Disable Kerneloops

## Scope

- disabled `kerneloops`, the kernel crash signature collection service
- kept network and runtime services unchanged
- added install, verify, and rollback scripts for the change

## Why

- `kerneloops.service` was enabled and running
- it had measurable boot cost in the earlier service audit
- kernel crash submission is not needed on this machine

## Validation

- `kerneloops.service` masked
- `kerneloops.service` inactive
- network state still intact after the change
