# 2026-04-09 Service Audit

## Scope

- inspected service candidates without disabling anything
- recorded boot cost, enable state, and exposed ports
- added a services audit module for later cleanup work

## Findings

- `ModemManager.service` is one of the larger avoidable boot costs at about `1.9s`
- `avahi-daemon.service` is enabled, running, and exposes UDP `5353`
- `rpcbind.service` is enabled, running, and exposes TCP/UDP `111`
- `bluetooth.service` should be treated as in-use hardware because Bluetooth is present and unblocked
- `nvgetty.service` and serial getty services should be preserved until serial recovery paths are no longer needed

## No Changes Applied

This step was audit-only.
