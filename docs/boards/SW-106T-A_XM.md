# Board: SW-106T-A_XM

## Identification

| Field | Value |
|---|---|
| Board / device | Xiaomi SW-106T-A |
| Board ID | `SW-106T-A_XM` |
| PCB ID (`MACHINE_PCB_INFO`) | `SW-106T-A_XM` |
| Machine model (`MACHINE_MODEL`) | `SW-106T-A_XM` |
| SoC | RTL8372N |
| Package | RTL8372N switch SoC with integrated 8051 CPU |
| Copper | 4 × 2.5G RJ45 |
| Uplink | 2 × SFP+ |
| Flash | 32 Mbit SPI, DIO |
| Power | 12 V DC |
| UART | none usable on the tested board |

The firmware uses `SW-106T-A_XM` for both the board ID and the PCB ID. If a
board revision has an additional silkscreen suffix, record it in the issue/PR
description, but do not change `MACHINE_PCB_INFO` until that revision has been
tested.

## Machine definition

Files:

```text
machine/SW-106T-A_XM.c
machine/SW-106T-A_XM.h
machine/SW-106T-A_XM_init.c
```

Key fields:

```c
.machine_name = "SW-106T-A_XM"
.led_mux_custom = 1
.port_led_set = { 0, 0, 0, 3, 2, 2, 0, 0, 3 }
```

Header:

```c
#define MACHINE_MODEL "SW-106T-A_XM"
#define MACHINE_CHIPSET RTL8372
#define MACHINE_PCB_INFO "SW-106T-A_XM"
```

## Port map

| Physical | Logical | Notes |
|---|---|---|
| 1 | 4 | 2.5G RJ45 |
| 2 | 5 | 2.5G RJ45 |
| 3 | 6 | 2.5G RJ45 |
| 4 | 7 | 2.5G RJ45 |
| SFP5 | 8 | SDS1, GPIO38, I²C 39/40 |
| SFP6 | 3 | SDS0, GPIO37, I²C 41/40 |

`log_to_phys_port` and `phys_to_log_port` in the machine file implement this
mapping. Do not copy it to another 8372N board without re-testing with
`regget 63f0`.

## MDI reverse

```text
RTL837X_CFG_PHY_MDI_REVERSE (0xa90) = 0x03
```

This is required for physical ports 1/2 to link on this board. Other boards may
use a different value.

## Flash

```text
32 Mbit SPI
DIO mode
flash_sio = 0
```

512 KB image only. Do not pad to 4 MB.

## LED configuration

Final V0.2.6 values:

```text
LED_PORT_SET_SEL = 0x00030ac0
LED_GLB_IO_EN    = 0xffffffff
LED_GLB_ACTIVE   = 0x3fffffff
```

Pad → source table:

| Physical LED | Pad | Source |
|---|---|---|
| 5 blue | 0 | `0x20` |
| 1 amber | 3 | `0x11` |
| 1 green | 4 | `0x10` |
| 2 amber | 6 | `0x15` |
| 2 green | 8 | `0x14` |
| 3 green | 10 | `0x18` |
| 3 amber | 12 | `0x19` |
| 4 amber | 18 | `0x1c` |
| 4 green | 21 | `0x1d` |
| 6 blue | 25 | `0x0c` |

Notes:

- Port 4 is amber on this unit; this is correct, not a fault.
- 1 amber is functional; `ledpad 3` lights it.
- Unused pads are `0x3f`.

## Hardware validation

| Test | Result |
|---|---|
| 1–4 copper link/ping | pass |
| SFP5 10G module + 2.5G peer | pass |
| SFP6 10G module + 2.5G peer | pass |
| Web UI | pass |
| VLAN4000 management | pass |
| No-link LEDs off | pass |
| Port LEDs follow activity | pass |
| Reboot/config persistence | pass |

## Upstream RTLPlayground submission checklist

1. Copy `machine/SW-106T-A_XM.c`, `.h`, `_init.c` to `machine/`.
2. Copy this document to `doc/devices/SW-106T-A_XM.md`.
3. Add validation results under `doc/devices/` or the project's test directory.
4. Confirm `make MACHINE=SW-106T-A_XM CONFIG=config/default.txt` builds.
5. Confirm the image is 512 KB and boots on hardware.
6. In the PR description include:
   - board/PCB ID `SW-106T-A_XM`;
   - SoC RTL8372N;
   - port/SFP map;
   - MDI `0xa90=0x03`;
   - DIO flash;
   - LED configuration and test results;
   - note that port 4 LED is amber on this revision.

## Config files

- `config/default.txt`: `192.168.10.247/24`, all ports VLAN1.
- `config/configured4000.txt`: VLAN4000 management, port 4 untagged,
  SFP5/6 tagged, `192.168.14.100/24`, gateway `192.168.14.254`.

## Recovery

Keep a full 4 MB stock dump before flashing. Web updates preserve the
configuration sector; after a configured image, run `factory-reset` or write the
full image with a programmer.
