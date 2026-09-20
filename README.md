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

This README and the guide cover **mVolt+ v0.47.1**. Check the release page for
the currently downloadable version.

## v0.47.1 highlights

- **More V/F curves:** edit Core and supported MSVDD XBAR, SYS and Video curves
  in one editor. Each curve keeps its edits and view when you switch domains.
- **Profiles and CLI:** save the new curves in profiles or adjust them from the
  command line. Full snapshots capture the currently applied curves.
- **Clearer curve editing:** familiar point and region editing, Flatten and
  Undo/Redo, with help that stays out of the graph's way.
- **Flexible layout:** changing visible tiles preserves your window size and
  scroll position. Manage profiles stays reachable in long profile menus.
- **Smoother interface:** improved profile-list updates and Apply/Reset rendering,
  with more compact thermal controls and clearer clock labels.
- **Overview:** separate applied summaries for Core, XBAR, SYS and Video curves.
- **Startup:** faster detection when the GPU is ready for your logon profile.

[Preset table](docs/guide.md#first-start-and-tile-presets) ·
[V/F curves](docs/guide.md#vf-curve-editor) ·
[Thermal inputs](docs/guide.md#thermal-inputs) ·
[Profile guide](docs/guide.md#profiles)

## Features

- **Voltage limits:** NVVDD/core and MSVDD/fabric cards with a range slider and
  Min/Max fields, or individual VMIN, REL, ALT/OP and supported OV offsets.
  Both views edit offsets; evaluated voltage limits remain visible.
- **Clocks:** core, memory, XBAR, SYS and video offsets; per-domain voltage
  demand; core/fabric clock propagation ratio; GPU clock range and Boost lock.
- **V/F editor:** Core and supported XBAR/SYS/Video curves, point and region
  editing, wheel zoom, right-drag pan, keyboard selection, Flatten and Undo/Redo.
  Core also offers a live operating-point marker and immediate voltage-point
  or maximum-clock locks.
- **Power and cooling:** percentage power limit and an additional watt cap,
  Voltage Boost, NVVDD/MSVDD OCP, shared or individual fan-channel duty within
  the driver's reported limits, and temperature-based fan curves.
- **Monitoring:** rail and ADC readings, clock graphs, power, P-states,
  temperatures, boost-limit reasons, memory timings, memory pressure and PCIe traffic.
- **Thermal inputs:** independent fixed inputs for channels 1/3/4/5 feeding VFE,
  plus channel 2 for memory temperature. Default restores the GPU-provided input.
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

The first new-profile save asks which mode to use. The choice is remembered
for this GPU and can be changed in
**Profile Manager → New profile mode** or overridden for one save. Existing
profiles keep their saved mode.

Saving does not apply anything. **Load for editing** stages targets;
**Apply profile**, a header selection or a global shortcut applies immediately.
Profiles can also be selected for application at Windows logon.
Editing an existing profile's shortcut saves the binding immediately; it does
not recapture tuning values or require Overwrite selected.

Applying a normal watt-cap profile leaves the existing percentage limit in place;
the lower limit governs. Applying a percentage profile releases a cap owned by
mVolt+ before setting the percentage. Full snapshots capture both applied
power requests. See [power controls in profiles](docs/guide.md#power-controls-in-profiles).

Boost lock and the V/F editor's point/clock locks are immediate actions, outside
both profile modes. Core, XBAR, SYS and Video curves are saved separately.
A profile that does not contain a curve leaves that curve unchanged.

[Profile guide](docs/guide.md#profiles) · [Startup and tray](docs/guide.md#startup-and-tray)

## Tuning Overview

Overview provides a compact view of your applied tuning settings, including
separate curve summaries, thermal inputs and enforced/requested power limits,
alongside the profile and VBIOS identity. Power limits are separate from measured
power consumption.
**Copy summary** copies the readback; **Always on top** keeps
the window visible beside another application.

## Telemetry and RTSS

Telemetry groups readings into Rails, Clocks, Power, P-states, Temperatures,
Boost limits and Memory / PCIe, opening on Rails by default. Memory / PCIe
includes read-only memory timings on supported GB202 hardware.
Clock graphs show values on hover. Hotspot, firmware clock history and detailed
limit reasons appear where supported.

RivaTuner Statistics Server is optional and only needed for its on-screen
overlay. Choose the readings in **Settings → Monitoring**.

[Telemetry reference](docs/guide.md#telemetry)

## Compatibility

- **RTX 50 / Blackwell:** primary target.
- **RTX 40 / Ada, RTX 30 / Ampere, RTX 20 / Turing and GTX 10 / Pascal:**
  experimental support, checked per control and sensor.

Compatibility is checked separately for each control and sensor. Support
includes older NVIDIA driver interfaces; available features vary by GPU and
driver. Voltage boost may be available even when voltage-limit editing is not.

Readings the driver does not provide remain unavailable. Thermal temperatures
that cannot be verified are labelled unconfirmed.
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
.\mVolt+.exe --vf-curve xbar | Out-Host
.\mVolt+.exe --read-only
```

Use the command line to inspect GPU status, select an adapter, apply a saved
profile or set tuning values and domain curves directly. Direct CLI tuning
applies immediately. The guide covers all options, units and automation examples.

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
