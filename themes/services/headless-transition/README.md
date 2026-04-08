# Headless Transition

This module is documentation-only.
It does not change the system by itself.

Use it later when you want to switch the Jetson Nano from a desktop-oriented
setup to a headless setup.

## Why

On Jetson Nano, removing the GUI stack is one of the biggest practical wins for:

- RAM headroom
- disk usage
- boot noise
- background service load

This is especially useful for:

- inference appliances
- camera boxes
- edge gateways
- SSH-first development

## What Headless Means Here

For this repository, "headless" means:

- booting to `multi-user.target` instead of `graphical.target`
- not starting GDM/GNOME by default
- optionally removing desktop packages later

## Recommended Sequence

1. Confirm you have working SSH or serial access first.
2. Switch the default target to `multi-user.target`.
3. Disable the display manager.
4. Reboot and verify remote access still works.
5. Only after that, decide whether to remove GUI packages to reclaim storage.

Do not remove the GUI first.

## Pre-Check

Run:

```bash
cd themes/services/headless-transition
./status.sh
```

Recommended checks before switching:

- `ssh.service` is active
- your board is reachable over the network or serial
- you have another way back in if the display manager does not come up

## Minimal Reversible Switch

This is the lowest-risk path:

```bash
sudo systemctl set-default multi-user.target
sudo systemctl disable gdm.service
```

If your image uses another display manager, check:

```bash
systemctl list-unit-files | rg 'gdm|lightdm|sddm'
```

On many Jetson Nano Ubuntu desktop images, `gdm.service` is the one in use.

## Verify After Reboot

After reboot, verify:

```bash
systemctl get-default
systemctl is-enabled gdm.service 2>/dev/null || true
systemctl is-active ssh.service
free -h
```

Expected signs:

- default target is `multi-user.target`
- `gdm.service` is disabled or inactive
- SSH is still active

## Rollback

If you want the desktop back:

```bash
sudo systemctl set-default graphical.target
sudo systemctl enable gdm.service
sudo reboot
```

## Optional Later Cleanup

Only do this after you are comfortable running headless.

Possible later steps:

- remove desktop packages
- remove desktop samples and docs
- remove GUI-only helper services

That is a separate phase because it is less reversible than just changing the
default target.

## Notes

- This guide intentionally avoids package removal.
- This repository has not applied headless mode yet.
- If you still need local monitor login sometimes, stop here and do not remove GUI packages.
