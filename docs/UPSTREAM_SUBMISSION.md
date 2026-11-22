# Upstream RTLPlayground submission

This fork is intentionally complete so the firmware can be reproduced. For an
upstream PR, send **only the board support**, not the full fork diff, not
experimental machines and not firmware binaries.

## 1. Fork upstream

Fork:

```text
https://github.com/logicog/RTLPlayground
```

Create a branch from upstream `main`:

```sh
git checkout -b board/sw-106t-a-xm
```

## 2. Copy only board support

From this repository:

```text
machine/SW-106T-A_XM.c
machine/SW-106T-A_XM.h
machine/SW-106T-A_XM_init.c
docs/boards/SW-106T-A_XM.md
docs/validation/network-test-results.md
docs/validation/led-test-results.md
docs/validation/led-pad-map.csv
```

Place them in the upstream tree:

```text
machine/
doc/devices/SW-106T-A_XM.md
```

Validation files can go under the project's existing test/doc layout; if none
exists, keep them next to the device document.

## 3. Build and verify

```sh
make CI=1 MACHINE=SW-106T-A_XM CONFIG=config/default.txt VERSION=0.2.6
```

Verify:

- the image is 524288 bytes;
- it boots on SW-106T-A_XM;
- Web is reachable;
- 1–4 copper and SFP5/6 link;
- no link = all LEDs off;
- 1–4 and SFP5/6 activity LEDs follow the ports.

## 4. PR title

```text
machine: add Xiaomi SW-106T-A_XM (RTL8372N, 4x2.5G + 2xSFP+)
```

## 5. PR body

```markdown
Add board support for the Xiaomi SW-106T-A.

Hardware:
- RTL8372N
- 4x 2.5G RJ45 + 2x SFP+
- 32 Mbit SPI flash, DIO

Ports:
- physical 1-4 -> logical 4-7
- SFP5 -> logical 8 / SDS1 / GPIO38
- SFP6 -> logical 3 / SDS0 / GPIO37
- MDI reverse 0xa90 = 0x03

LEDs:
- LED_PORT_SET_SEL = 0x00030ac0
- LED_GLB_IO_EN = 0xffffffff
- LED_GLB_ACTIVE = 0x3fffffff
- no link = all off
- port 4 is amber on this unit; colour is board-specific

Tested:
- 1-4 copper link/ping
- SFP5/6 10G modules
- Web UI
- VLAN4000 management
- LED no-link/all-off and per-port activity
- reboot/config persistence

The full buildable fork and validation data are at:
https://github.com/tarly/rtlplayground-SW-106T-A_XM

Note: the Web firmware updater preserves the configuration sector. A
configured image needs factory-reset, restore-defaults, or a programmer
full-image write to apply the embedded config.
```

## 6. What not to include

- `machine/LED*` experimental candidates;
- `XIAOMI_*` test machines;
- firmware `.bin` files;
- local config files containing your own IP/MAC;
- the full fork diff if it contains unrelated local changes.

## 7. Keep the fork buildable

The fork's `.github/workflows/build-sw106.yml` builds the full image and uploads
a 512 KB artifact. It is for reproducibility, not for the upstream PR.
