# RTLPlayground board support: SW-106T-A_XM

Board support and validated firmware for the Xiaomi SW-106T-A switch
(RTL8372N, 4 x 2.5G RJ45 + 2 x SFP+, 32 Mbit SPI flash).

## Status

| Item | Value |
|---|---|
| Board ID | `SW-106T-A_XM` |
| PCB ID | `SW-106T-A_XM` |
| SoC | RTL8372N |
| Ports | 4 x 2.5G RJ45 + 2 x SFP+ |
| Flash | 32 Mbit SPI, DIO |
| Final firmware | `V0.2.6` |
| Network baseline | `V0.1.2_NOLED` |
| Image | 512 KB, no 4 MB padding |

## Milestones

### V0.1.2_NOLED - network baseline

- REF copper map: physical 1-4 -> logical 4-7
- MDI reverse `0xa90 = 0x03` for physical 1/2
- SFP5 / SFP6 pin mapping
- DIO flash
- Web, VLAN, management access, config save
- default `192.168.10.247/24`

### V0.2.6 - LED fix

- `LED_PORT_SET_SEL = 0x00030ac0`
- pad-based custom `led_mux`
- `LED_GLB_IO_EN = 0xffffffff`
- `LED_GLB_ACTIVE = 0x3fffffff`
- no link = all LEDs off

## LED behaviour

| State | LED |
|---|---|
| No link | all off |
| Port 1 | 1 green blink |
| Port 2 | 2 green blink |
| Port 3 | 3 green blink |
| Port 4 | 4 amber blink |
| SFP5 | 5 blue blink |
| SFP6 | 6 blue blink |

Port 4 is amber on this unit; this is the measured behaviour, not a fault.

## Port and pin map

| Function | Mapping |
|---|---|
| Physical 1-4 | logical 4-7 |
| SFP5 | logical 8 / SDS1 / GPIO38 / I2C 39/40 |
| SFP6 | logical 3 / SDS0 / GPIO37 / I2C 41/40 |
| MDI reverse | `0xa90 = 0x03` |
| Flash | DIO, `flash_sio = 0` |

## Repository layout

```text
machine/                 board definition
config/default.txt       default VLAN1 / 192.168.10.247
config/configured4000.txt
docs/boards/             board ID and pin map
docs/iterations/         V0.1.2 and V0.2.6 notes
docs/validation/         network and LED results
firmware/                512 KB images
ci/                      GitHub Actions workflow source
```

## Build

```sh
make MACHINE=SW-106T-A_XM \
     CONFIG=config/default.txt \
     VERSION=0.2.6
```

The output is a 512 KB image. Do not pad it to 4 MB.

## Flash

Default firmware:

```text
IP:      192.168.10.247
Netmask: 255.255.255.0
Gateway: 192.168.10.1
User:    admin
Pass:    admin
```

Web firmware update preserves the configuration sector. A configured image
needs `factory-reset`, restore-defaults, or a programmer full-image write.

## Validation

- [Network results](docs/validation/network-test-results.md)
- [LED results](docs/validation/led-test-results.md)
- [LED pad map](docs/validation/led-pad-map.csv)

## CI

The workflow source is `ci/build-sw106.yml`. If it is not active on GitHub,
copy it to `.github/workflows/build-sw106.yml` once. It builds the image,
checks 524288 bytes and uploads it as an artifact.

## Chinese

[README.zh-CN.md](README.zh-CN.md)

## Credits

RTLPlayground upstream, SDCC and the RTL837x community.
