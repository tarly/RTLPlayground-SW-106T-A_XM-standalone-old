# Network validation results

Board: `SW-106T-A_XM`  
Firmware: `V0.1.2_NOLED` / final network section of V0.2.6  
Default config: `192.168.10.247/24`, all ports VLAN1

## Test matrix

| Test | Command / method | Result |
|---|---|---|
| Boot | power on | pass |
| Web UI | `http://192.168.10.247` | pass |
| Login | `admin/admin` | pass |
| Port 1 link + ping | cable + `ping` | pass |
| Port 2 link + ping | cable + `ping` | pass |
| Port 3 link + ping | cable + `ping` | pass |
| Port 4 link + ping | cable + `ping` | pass |
| SFP5 10G module | module + 2.5G peer | pass |
| SFP6 10G module | module + 2.5G peer | pass |
| Web port order | compare labels | pass |
| Reboot | power cycle | pass |
| Config persistence | reboot after save | pass |

## Port map proof

With one cable at a time:

```text
regget 63f0
```

| Cable in | Value | Logical port |
|---|---|---|
| physical 1 | `0x00050000` | 4 |
| physical 2 | `0x00500000` | 5 |
| physical 3 | `0x05000000` | 6 |
| physical 4 | `0x50000000` | 7 |
| SFP6 | `0x00004000` | 3 |

## MDI test

```text
regset a90 0c
regset a90 00
regset a90 03
```

| Value | Result |
|---|---|
| `0x0c` | physical 1/2 no link |
| `0x00` | physical 4 works, labels wrong |
| `0x03` | ports 1–4 work, Web order correct |

Final: `.mdi_reverse = 0x03`.

## SFP

| Cage | Logical | SDS | GPIO | I²C |
|---|---|---|---|---|
| SFP5 | 8 | 1 | 38 | 39/40 |
| SFP6 | 3 | 0 | 37 | 41/40 |

SFP pin variant P2 worked: left GPIO38, right GPIO37.

## VLAN / management test

Configured4000 test:

```text
vlan 1 1 2 3
vlan 4000 4 5t 6t
pvid 4 4000
vlan 4000 mgmt
ip 192.168.14.100
gw 192.168.14.254
netmask 255.255.255.0
```

| Path | Result |
|---|---|
| Port 4 untagged VLAN4000 | Web reachable at 192.168.14.100 |
| SFP5 tagged VLAN4000 | Web reachable with trunk |
| SFP6 tagged VLAN4000 | Web reachable with trunk |

## Configuration update note

Web firmware update does not copy the flash configuration area. After flashing a
configured image, run:

```text
factory-reset
```

or restore defaults, or write the full image with a programmer.

## Known issue

A 10GBASE-T SFP+ module with a 2.5G peer may show 10G in the Web UI. This is the
host-side SerDes rate; the media side is 2.5G inside the module.
