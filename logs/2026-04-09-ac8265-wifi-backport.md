# 2026-04-09 AC8265 Wi-Fi Backport

## Scope

- documented the working Intel `AC8265` Wi-Fi recovery path on this Jetson Nano
- stored a reproducible installer, status check, and rollback script
- captured the exact backport release and source edits that worked

## Machine State

- board: NVIDIA Jetson Nano Developer Kit
- l4t: `R32.7.6`
- kernel: `4.9.337-tegra`
- card: Intel `AC8265`
- pci id: `8086:24fd`
- subsystem id: `8086:1014`

## Triage Summary

- stock `iwlwifi`
  - card detected on PCIe
  - Bluetooth worked
  - Wi-Fi did not become usable
- `7906`
  - built and loaded after patching
  - `wlan0` existed but stayed unusable
- `8042`
  - built and loaded after patching
  - final bring-up still failed
- `8613`
  - first release that loaded, created a usable `wlan0`, and scanned SSIDs

## Working Release

- upstream package tag: `applied/8613-0ubuntu1`
- installed DKMS version: `8613`
- successful runtime marker: `iwlwifi-stack-public:master:8613:3ae69204`

## Source Changes Required

- `backport-include/linux/build_bug.h`
  - use `#include_next <linux/build_bug.h>`
- `backport-include/linux/random.h`
  - stop redefining `get_random_u32()` on kernel `4.9`
- `local-symbols`
  - set `BPAUTO_SYSTEM_DATA_VERIFICATION=n`
  - set `BPAUTO_BUILD_SYSTEM_DATA_VERIFICATION=n`
  - set `BPAUTO_PKCS7=n`
- `net/wireless/Kconfig`
  - set `CFG80211_REQUIRE_SIGNED_REGDB` default to `n`
  - remove `select BPAUTO_SYSTEM_DATA_VERIFICATION`
- add `dkms.conf`

## Why 8613 Needed Extra Work

The first `8613` build succeeded but failed to load:

```text
compat: Unknown symbol hash_algo_name
```

That failure came from the PKCS#7 and signed-regdb verification path added into
`compat`. Disabling that path allowed `compat`, `cfg80211`, `iwlwifi`, and
`iwlmvm` to load correctly on `4.9.337-tegra`.

## Validation At Capture Time

- `modprobe iwlwifi` succeeded
- `lsmod` showed:
  - `compat`
  - `cfg80211`
  - `iwlwifi`
  - `iwlmvm`
  - `mac80211`
- `nmcli device status` showed `wlan0` as `disconnected`
- `iw dev` showed both:
  - `wlan0`
  - `P2P-device`
- scan succeeded and saw nearby SSIDs such as:
  - `minchan_5G`
  - `U+Net18E8`
