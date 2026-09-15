# mVolt+

mVolt+ is a Windows utility for NVIDIA GPU tuning and monitoring. It supports
core and fabric voltage limits, clock offsets, power limits, V/F and fan curves,
and saved profiles.

RTX 50 series is the primary target. Support for earlier GeForce generations is
experimental; available controls depend on the GPU, VBIOS and driver.

## Download

**[Latest release](https://github.com/b00nz/mVolt/releases/latest)** ·
**[Download EXE](https://github.com/b00nz/mVolt/releases/latest/download/mVolt+.exe)** ·
**[User guide](docs/guide.md)** ·
**[Report an issue](https://github.com/b00nz/mVolt/issues)**

Run the executable; no installer is needed. Tuning requires administrator
privileges. Read-only commands and the `--read-only` dashboard do not.

This README and the guide cover **mVolt+ v0.43**. Check the release page for the
currently downloadable version.

## In v0.43

- **Power cap in watts:** set an additional watt limit, compare Applied and Live
  readings, and use Reset to return to percentage control.
- **Greater driver compatibility:** support for different power-control and
  telemetry formats across the R591, R595, R596, R610 and R616 driver families.
  Individual features still depend on the GPU and driver.
- **Profile fixes:** ordinary percentage profiles no longer require an unrelated
  watt-cap read to succeed. Snapshots captured without a cap can be applied after
  the cap has been reset.
- **Range validation:** core, memory and other supported controls use current
  driver bounds consistently through inputs, profiles and Apply. Fixed driver
  ranges are accepted; missing bounds are not replaced with guessed ranges.
- **Window and input fixes:** saved narrow window sizes are restored, with fixes
  for slider/input redraw and startup window placement.
- **Startup timing:** a 10-second logon delay and 10 seconds between readiness
  checks, retaining two successful checks and the 60-second readiness timeout.

[Watt-cap guide](docs/guide.md#power-cap-in-watts) ·
[Power controls in profiles](docs/guide.md#power-controls-in-profiles)

## Features

- **Voltage limits:** NVVDD/core and MSVDD/fabric cards with a range slider and
  Min/Max fields, or individual VMIN, REL, ALT/OP and supported OV offsets.
  Both views edit offsets; evaluated voltage limits remain visible.
- **Clocks:** core, memory, XBAR, SYS and video offsets; per-domain voltage
  demand; core/fabric clock propagation ratio; GPU clock range and Boost lock.
- **V/F editor:** wheel zoom, drag to pan when zoomed, keyboard point editing,
  Flatten above, undo/redo, a live operating-point marker, and immediate
  voltage-point or maximum-clock locks.
- **Power and cooling:** percentage power limit and an additional watt cap,
  Voltage Boost, NVVDD/MSVDD OCP, shared or individual fan-channel duty within
  the driver's reported limits, and temperature-based fan curves.
- **Monitoring:** rail and ADC readings, clock graphs, power, P-states,
  temperatures, boost-limit reasons, memory pressure and PCIe traffic.
- **Dashboard:** collapsible sections, optional Quick tuning pins, tile
  visibility, themes, interface sizing and explanatory tooltips.
- **Multiple GPUs:** adapter selection with separate profiles and preferences
  for each GPU and VBIOS.

See the [control reference](docs/guide.md#dashboard-control-reference) for what
each setting changes and what can limit its effect.

## Profiles and automation

Profiles use the enabled switches **saved in the profile**, regardless of the
dashboard's current switches.

| Mode | What applying it does |
| --- | --- |
| **Normal / Only enabled settings** (default) | Applies saved-enabled targets, including edits that were pending when saved. Saved-disabled and absent settings stay untouched. |
| **Full snapshot** | Restores captured applied values, including controls whose switches were off. Pending edits are not saved. Absent settings stay untouched. |

The first new-profile save asks which mode to use, including after upgrading
from v0.40. The choice is remembered for this GPU and can be changed in
**Settings → General → New profile mode** or overridden for one save. Existing
profiles keep their saved mode.

Saving does not apply anything. **Load for editing** stages targets;
**Apply profile**, a header selection or a global shortcut applies immediately.
Profiles can also be selected for application at Windows logon.

Applying a normal watt-cap profile leaves the existing percentage limit in place;
the lower limit governs. Applying a percentage profile releases a cap owned by
mVolt+ before setting the percentage. Full snapshots capture both applied
power requests. See [power controls in profiles](docs/guide.md#power-controls-in-profiles).

Boost lock and the V/F editor's point/clock locks are immediate actions, outside
both profile modes. Saved V/F curve edits remain part of profiles.

[Profile guide](docs/guide.md#profiles) · [Startup and tray](docs/guide.md#startup-and-tray)

## Tuning Overview

Overview shows current settings, including the configured power limit in watts,
alongside the profile and VBIOS identity. That limit is separate from measured
power consumption. **Copy summary** copies the readback; **Always on top** keeps
the window visible beside another application.

## Telemetry and RTSS

Telemetry groups readings into Rails, Clocks, Power, P-states, Temperatures,
Boost limits and Memory / PCIe. Clock graphs show values on hover. Hotspot,
firmware clock history and detailed limit reasons appear where supported.

RivaTuner Statistics Server is optional and only needed for its on-screen
overlay. Choose the readings in **Settings → Monitoring**.

[Telemetry reference](docs/guide.md#telemetry)

## Compatibility

- **RTX 50 / Blackwell:** primary target.
- **RTX 40 / Ada, RTX 30 / Ampere, RTX 20 / Turing and GTX 10 / Pascal:**
  experimental support, checked per control and sensor.

Each control checks for a supported interface and valid driver data. A working
clock or power control does not imply support for every voltage rail or sensor.
Power-control and detailed-telemetry readers support formats used across the
R591, R595, R596, R610 and R616 families. Selection follows the interface's
response, not a driver-version allowlist; this is not a guarantee for every
release or board in those families.
See [compatibility and multiple GPUs](docs/guide.md#compatibility-and-multiple-gpus).

## Safety and persistence

Slider and curve edits stay pending until **Apply**. **Reset**, **Reset all**,
Boost lock and the V/F lock buttons act immediately.

Applied settings are not reverted when mVolt+ exits. A driver reset or reboot
can clear them. **Software fan curves need mVolt+ running to follow temperature**;
the tray is sufficient. Fully exiting leaves the last fan duty fixed.
Resetting fans to auto returns control to the GPU firmware.

GPU tuning can cause instability or hardware damage. A setting accepted by the
driver is not proof of stability; a reported device limit is not a safe-voltage
rating.

## Command line

```powershell
.\mVolt+.exe --help | Out-Host
.\mVolt+.exe --list-gpus | Out-Host
.\mVolt+.exe --status | Out-Host
.\mVolt+.exe --read-only
```

Direct CLI tuning applies immediately. Rail commands accept signed offsets in
mV: `--nvvdd-offsets VMIN,REL,ALT[,OV]` and
`--msvdd-offsets VMIN,REL,ALT[,OV]`. ALT is the limit labelled **ALT/OP** in the UI.

Use `--power-cap-watts WATTS` for an additional watt cap, or
`--return-to-percentage` to release it without changing the percentage setting.
New watt targets start at 1 W, accept up to three decimal places, and cannot
exceed the reported maximum. This feature does not require a separate kernel driver.

[CLI reference and automation](docs/guide.md#command-line-and-automation)

## Screenshots

Screenshots from an RTX 5090. Some controls may differ in the current version;
the values shown are not recommended tuning settings.

### Dashboard

![mVolt+ dashboard](assets/mvolt-dashboard.png)

<details>
<summary><strong>Telemetry, V/F editor, Profiles and Overview</strong></summary>

![Telemetry](assets/mvolt-telemetry.png)

![V/F Curve Editor](assets/mvolt-vf-curve-editor.png)

![Profile Manager](assets/mvolt-profiles.png)

![Tuning Overview](assets/mvolt-overview.png)

</details>

## Requirements

- 64-bit Windows with an NVIDIA display driver.
- Administrator privileges for tuning.
- Working NVML support for GPU clock-range control and NVML telemetry.
- RivaTuner Statistics Server only for the optional overlay.

mVolt+ is an independent third-party project, not affiliated with or endorsed
by NVIDIA. NVIDIA, GeForce and RTX are trademarks of NVIDIA Corporation.

## Credits

Thanks to [Loong0x00](https://github.com/Loong0x00) for discovering the XBAR clock control.
