# AC8265 Wi-Fi Backport

This module records the working recovery path for an Intel `AC8265` Wi-Fi card
on a Jetson Nano running JetPack `R32.7.6` with kernel `4.9.337-tegra`.

## Why

On this machine:

- Bluetooth worked
- the `AC8265` PCIe card was detected
- stock `iwlwifi` did not produce a usable `wlan0`
- newer backport releases either failed to build or failed at runtime
- `8613-0ubuntu1` became the first release that both loaded and scanned after
  a small compatibility patch set

## Hardware And Software

- board: NVIDIA Jetson Nano Developer Kit
- l4t: `R32.7.6`
- kernel: `4.9.337-tegra`
- card: Intel Dual Band Wireless AC 8265
- pci id: `8086:24fd`
- subsystem id: `8086:1014`
- firmware used at capture time: `iwlwifi-8265-36.ucode`

## Working Release

- source tag: `applied/8613-0ubuntu1`
- repository: `https://git.launchpad.net/ubuntu/+source/backport-iwlwifi-dkms`
- installed DKMS version: `8613`

## Compatibility Changes Applied

The successful path used these source edits before building:

- `backport-include/linux/build_bug.h`
  - always include `linux/build_bug.h` via `#include_next`
- `backport-include/linux/random.h`
  - stop redefining `get_random_u32()` on kernel `4.9`
- `local-symbols`
  - force `BPAUTO_SYSTEM_DATA_VERIFICATION=n`
  - force `BPAUTO_BUILD_SYSTEM_DATA_VERIFICATION=n`
  - force `BPAUTO_PKCS7=n`
- `net/wireless/Kconfig`
  - set `CFG80211_REQUIRE_SIGNED_REGDB` default to `n`
  - remove `select BPAUTO_SYSTEM_DATA_VERIFICATION`
- add `dkms.conf`
  - build `compat`, `cfg80211`, `iwlwifi`, `iwlmvm`, `iwlxvt`, `mac80211`

The important runtime fix was disabling the PKCS#7 and signed-regdb backport
path in `compat`. Without that, `compat.ko` failed to load with:

```text
Unknown symbol hash_algo_name
```

## Install

```bash
cd themes/services/ac8265-wifi-backport
sudo ./install.sh
```

What the installer does:

- fetches `applied/8613-0ubuntu1` from Launchpad git
- writes the source tree to `/usr/src/backport-iwlwifi-8613`
- applies the compatibility patches above
- rebuilds DKMS for kernel `4.9.337-tegra`
- installs the new modules into `/lib/modules/4.9.337-tegra/updates/dkms/`
- attempts `modprobe iwlwifi`

## Verify

```bash
cd themes/services/ac8265-wifi-backport
./status.sh
```

Expected signs:

- `modinfo -n iwlwifi` points at `updates/dkms/iwlwifi.ko`
- live module version contains `8613`
- `lsmod` shows `iwlwifi`, `iwlmvm`, `mac80211`, `cfg80211`, `compat`
- `nmcli device status` shows `wlan0` as `disconnected` or `connected`
- `nmcli dev wifi list ifname wlan0` returns scan results

## Rollback

```bash
cd themes/services/ac8265-wifi-backport
sudo ./rollback.sh
```

Rollback removes the custom `8613` DKMS tree and installed modules.

Note:

- this only removes the custom recovery path
- it does not guarantee that the stock Jetson Nano `iwlwifi` driver will work
  again for this card
- reboot is recommended after rollback

## Known Results During Triage

- `7906`
  - built and loaded after patching
  - `wlan0` existed but stayed unusable
- `8042`
  - built and loaded after patching
  - `wlan0` existed but still failed the final bring-up path
- `8613`
  - first release that loaded `iwlwifi` and `iwlmvm`, brought `wlan0` up, and
    scanned nearby SSIDs
