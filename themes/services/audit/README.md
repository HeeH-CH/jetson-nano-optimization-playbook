# Service Audit

This module does not change the system.
It documents which services are good candidates for later cleanup and which ones
should be treated cautiously on this Jetson Nano.

## Current Findings

### Safe candidates if you do not use the feature

- `whoopsie.service`
  - crash report submission
  - enabled and running
- `kerneloops.service`
  - kernel crash signature collection
  - enabled and running
- `ModemManager.service`
  - only useful for WWAN/LTE modem workflows
  - enabled and running
  - noticeable boot cost on this machine
- `avahi-daemon.service`
  - mDNS/DNS-SD discovery
  - enabled and running
  - opens UDP `5353`
- `rpcbind.service`
  - RPC/NFS support
  - enabled and running
  - opens TCP/UDP `111`
  - `nfs-common` is installed, so treat this as conditional rather than blindly safe

### Conditional candidates

- `packagekit.service`
  - static, usually D-Bus activated
  - low direct boot cost, but often unnecessary on appliance-style systems
- `fwupd.service`
  - static, firmware update daemon
  - if firmware updates are never managed from the box, it can be reviewed later
- `accounts-daemon.service`
  - useful for desktop login/session tooling
  - avoid disabling while GNOME/GDM is still in use
- `udisks2.service`
  - useful for GUI mounting and removable media handling
  - avoid disabling if desktop auto-mount matters
- `upower.service`
  - currently disabled as a unit file but active through activation
  - keep while desktop power integration matters
- `colord.service`
  - desktop color profile plumbing
  - low value on headless systems, but low payoff while GNOME is present

### Keep unless you are very sure

- `bluetooth.service`
  - Bluetooth hardware is present and not blocked
- `nvgetty.service`
  - NVIDIA serial console path on `ttyTHS0`
- `serial-getty@ttyS0.service`
  - regular serial console
- `serial-getty@ttyGS0.service`
  - USB gadget serial console

Serial services are often your easiest recovery path when networking breaks.

## Boot Cost Seen During Audit

- `ModemManager.service`: about `1.9s`
- `udisks2.service`: about `1.6s`
- `accounts-daemon.service`: about `1.1s`
- `fwupd.service`: about `376ms`
- `avahi-daemon.service`: about `370ms`
- `upower.service`: about `365ms`
- `kerneloops.service`: about `573ms`
- `bluetooth.service`: about `99ms`
- `packagekit.service`: about `98ms`
- `rpcbind.service`: about `65ms`

## Recommendation Order

When you decide to actually trim services later, this is the suggested order:

1. `whoopsie`
2. `kerneloops`
3. `ModemManager`
4. `avahi-daemon`
5. `rpcbind` only if NFS/RPC is not needed
6. desktop-related services only after switching to headless or a lighter session

## Verify

```bash
cd themes/services/audit
./status.sh
```
