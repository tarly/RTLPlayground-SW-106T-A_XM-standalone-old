# RTLPlayground board support: SW-106T-A_XM

Board support and validated firmware for the Xiaomi SW-106T-A switch
(RTL8372N, 4 脳 2.5G RJ45 + 2 脳 SFP+, 32 Mbit SPI flash).

This repository contains the board definition, two iteration records, and the
validation data needed for an upstream RTLPlayground submission.

## Status

| Item | Value |
|---|---|
| Board ID | `SW-106T-A_XM` |
| PCB ID | `SW-106T-A_XM` |
| SoC | RTL8372N |
| Ports | 4 脳 2.5G RJ45 + 2 脳 SFP+ |
| Flash | 32 Mbit SPI, DIO |
| Final firmware | `V0.2.6` |
| Network baseline | `V0.1.2_NOLED` |
| Image size | 512 KB, no 4 MB padding |

## Two key milestones

### 1. Network baseline: V0.1.2_NOLED

The first usable milestone. It established:

- REF copper port map: physical 1鈥? 鈫?logical 4鈥?;
- MDI reverse `0xa90 = 0x03` for physical 1/2;
- SFP5 / SFP6 pin mapping;
- DIO flash mode;
- Web UI, VLAN, management access, configuration save;
- default config `192.168.10.247/24`.

Details: [docs/iterations/V0.1.2-network-baseline.md](docs/iterations/V0.1.2-network-baseline.md)

### 2. LED fix: V0.2.6

The final milestone. It established:

- LED engine `leds_setup()` must actually run;
- `LED_PORT_SET_SEL = 0x00030ac0`;
- pad-based custom `led_mux`;
- `LED_GLB_IO_EN = 0xffffffff`;
- `LED_GLB_ACTIVE = 0x3fffffff`;
- no link = all LEDs off;
- 1/2/3/4 and SFP5/6 map one-to-one to their activity LEDs.

Details: [docs/iterations/V0.2.6-led.md](docs/iterations/V0.2.6-led.md)

## LED behavior (measured on this unit)

| State | LED |
|---|---|
| No link | all off |
| Port 1 | 1 green blink |
| Port 2 | 2 green blink |
| Port 3 | 3 green blink |
| Port 4 | 4 amber blink |
| SFP5 | 5 blue blink |
| SFP6 | 6 blue blink |

**Correction:** an earlier document draft treated the port 4 LED colour as a
problem. That was a documentation error. Port 4 is amber on this unit and the
behaviour is correct. Other PCB revisions may use a different colour; the
colour is board-specific, not a fault.

## Port and pin map

| Function | Mapping |
|---|---|
| Physical 1鈥? | logical 4鈥? |
| SFP5 | logical 8, SDS1, GPIO38, I虏C 39/40 |
| SFP6 | logical 3, SDS0, GPIO37, I虏C 41/40 |
| MDI reverse | `0xa90 = 0x03` |
| Flash | DIO, `flash_sio = 0` |

Board file: [docs/boards/SW-106T-A_XM.md](docs/boards/SW-106T-A_XM.md)

## Repository layout

```text
machine/                 RTLPlayground board definition
config/default.txt       default VLAN1 / 192.168.10.247 config
config/configured4000.txt  VLAN4000 management config
docs/boards/             board ID, pin map, upstream notes
docs/iterations/         V0.1.2 and V0.2.6 iteration records
docs/validation/         network and LED validation data
firmware/                512 KB test images
build.sh                 build helper
```

## Build

This board definition is intended to be copied into an RTLPlayground checkout.

```sh
cp machine/SW-106T-A_XM.c machine/SW-106T-A_XM.h \
   machine/SW-106T-A_XM_init.c <rtlplayground>/machine/

make MACHINE=SW-106T-A_XM \
     CONFIG=config/default.txt \
     VERSION=0.2.6
```

The build produces a 512 KB image. Do not pad it to 4 MB.

## Flashing and configuration

- Default firmware config: `192.168.10.247/24`, all ports VLAN1.
- `config/configured4000.txt` is the author's VLAN4000 config:
  - 1鈥?: VLAN1 untagged
  - 4: VLAN4000 untagged, PVID 4000
  - SFP5/6: VLAN4000 tagged
  - management VLAN 4000, `192.168.14.100/24`, gateway `192.168.14.254`

**Important:** the Web firmware updater deliberately does not copy the flash
configuration area. After a Web update of a configured image, run:

```text
factory-reset
```

or restore defaults, or write the full 512 KB image with a programmer.
Otherwise the old IP/VLAN configuration remains active.

## Validation

- [Network test results](docs/validation/network-test-results.md)
- [LED test results](docs/validation/led-test-results.md)
- [LED pad map CSV](docs/validation/led-pad-map.csv)

Key network checks:

- all four copper ports link and ping;
- SFP5 and SFP6 link with 10G modules;
- Web UI reachable;
- VLAN 4000 management works on port 4 untagged and SFP5/6 tagged;
- reboot and configuration persistence verified.

Key LED checks:

- no link: all off;
- port 1鈥?: corresponding LED activity;
- SFP5/6: blue activity;
- `LED_PORT_SET_SEL = 0x00030ac0`;
- `LED_GLB_ACTIVE = 0x3fffffff`.

## Upstream RTLPlayground submission

Copy:

```text
machine/SW-106T-A_XM.c
machine/SW-106T-A_XM.h
machine/SW-106T-A_XM_init.c
docs/boards/SW-106T-A_XM.md
docs/validation/*
```

into the corresponding RTLPlayground directories and open a PR. The board ID
and PCB ID are both `SW-106T-A_XM`.

See [docs/boards/SW-106T-A_XM.md](docs/boards/SW-106T-A_XM.md) for the full
submission checklist.

## Known notes

- Port 4 is amber on this unit; this is correct.
- 1 amber LED was previously thought dead; `ledpad 3` proved it works.
- Stock boot "all LEDs on, then off" is a bootloader/early-init self-test, not
  `LED_MODE` bit 17. The final firmware does not reproduce the self-test.
- A 10GBASE-T SFP+ module with a 2.5G peer may report 10G in the UI; that is the
  host-side SerDes rate, not a link failure.
- No usable UART was found on this board; keep a full flash backup.


## Build in GitHub Actions

This repository is a fork of
[`logicog/RTLPlayground`](https://github.com/logicog/RTLPlayground) with the
`SW-106T-A_XM` board support and a dedicated workflow.

The workflow `.github/workflows/build-sw106.yml`:

1. checks out this fork;
2. installs the Debian build dependencies;
3. runs `make` for `MACHINE=SW-106T-A_XM`;
4. enforces a 524288-byte image;
5. uploads the image as a workflow artifact.

Run it from **Actions → Build SW-106T-A_XM → Run workflow**.  
The artifact contains `SW-106T-A_XM-V0.2.6.bin`.

## Reproduce from a fork

```sh
git clone https://github.com/tarly/rtlplayground-SW-106T-A_XM.git
cd rtlplayground-SW-106T-A_XM
make MACHINE=SW-106T-A_XM CONFIG=config/default.txt VERSION=0.2.6
```

The resulting image is 512 KB. Use `config/configured4000.txt` for the
VLAN4000 management configuration.

### Fork from upstream instead

If you prefer to start from upstream:

1. fork `logicog/RTLPlayground`;
2. copy `machine/SW-106T-A_XM.c`, `.h`, `_init.c` into `machine/`;
3. copy `config/` and `docs/` as needed;
4. build with the command above.

The full fork is provided so the build is reproducible without extra patches.

## Upstream PR

For a board-support PR, use only the machine files, board document and
validation data. Do not send the experimental candidate machines or firmware
binaries upstream.

See [docs/UPSTREAM_SUBMISSION.md](docs/UPSTREAM_SUBMISSION.md).
## Chinese documentation

[README.zh-CN.md](README.zh-CN.md)

## Credits

RTLPlayground upstream project, SDCC, and the RTL837x community.

