# LED validation results

Board: `SW-106T-A_XM`  
Firmware: `V0.2.6` (behaviour identical to V0.2.5)

## Final behaviour

| State | LED |
|---|---|
| No link | all off |
| Port 1 | 1 green blink |
| Port 2 | 2 green blink |
| Port 3 | 3 green blink |
| Port 4 | 4 amber blink |
| SFP5 | 5 blue blink |
| SFP6 | 6 blue blink |

Port 4 is amber on this unit. An earlier document draft incorrectly described
this as a problem; it is the measured, correct behaviour for this board. Other
PCB revisions may use a different colour.

## Register configuration

```text
LED_PORT_SET_SEL = 0x00030ac0
LED_GLB_IO_EN    = 0xffffffff
LED_GLB_ACTIVE   = 0x3fffffff
LED_MODE         = 0x0023e6b0 (runtime value)
```

`port_led_set`:

```c
{ 0, 0, 0, 3, 2, 2, 0, 0, 3 }
```

## Pad map

Measured with `ledpad 0..27`, one pad at a time, with a cable in port 1.

| Pad | Physical LED |
|---|---|
| 0 | 5 blue |
| 3 | 1 amber |
| 4 | 1 green |
| 6 | 2 amber |
| 8 | 2 green |
| 10 | 3 green |
| 12 | 3 green (duplicate path) |
| 18 | 4 amber |
| 21 | 4 amber (duplicate path) |
| 25 | 6 blue |

Pads 1, 2, 5, 7, 9, 11, 13–17, 19–20, 22–24, 26–27 did not light a port LED in
this probe. The probe only drives logical 4 / LED0, so this is not proof that a
pad is unused; 3 amber and 4 green were mapped by source value.

## Source map used by V0.2.6

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

## Bootstrap LED behaviour

The stock firmware lights all LEDs briefly at power-on. This is a
bootloader/early-init self-test. It is not `LED_MODE` bit 17:

- `regset 6520 0023e6b0` had no effect;
- `LED13_FORCEON` failed;
- the final firmware intentionally does not reproduce the self-test.

## Notes

- 1 amber is functional; `ledpad 3` lights it. Earlier “1 amber broken” was a
  misdiagnosis.
- V0.2.5 introduced the final `LED_GLB_ACTIVE=0x3fffffff`; V0.2.6 is the same
  behaviour with the final version string.
