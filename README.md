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

This README and the guide cover **mVolt+ v0.47.2**. Check the release page for
the currently downloadable version.

## v0.47.2 highlights

- **V/F curves:** independent switches for Core, XBAR, SYS and Video, plus
  Show original for a thin reference curve.
- **Profiles:** fixed unapplied edits being saved; double-click a profile to
  apply it, and see the current profile in the header and tray menus.
- **Startup:** choose whether mVolt+ opens visibly or starts in the tray.
- **Smoother controls:** fixed unwanted resizing, reset flicker and clock-range
  errors, with simpler tooltips and improved GPU reconnection.

[Preset table](docs/guide.md#first-start-and-tile-presets) ·
[V/F curves](docs/guide.md#vf-curve-editor) ·
[Thermal inputs](docs/guide.md#thermal-inputs) ·
[Profile guide](docs/guide.md#profiles)

## Features

- **Voltage limits:** NVVDD/core and MSVDD/fabric cards with a range slider and
  Min/Max fields, or individual VMIN, REL, ALT/OP and supported OV offsets.
  Both views edit offsets and show the current voltage limits.
- **Clocks:** core, memory, XBAR, SYS and video offsets; per-domain voltage
  demand; core/fabric clock propagation ratio; GPU clock range and Boost lock.
- **V/F editor:** Core and supported XBAR/SYS/Video curves, point and region
  editing, wheel zoom, right-drag pan, keyboard selection, Flatten and Undo/Redo.
  Each curve has its own Enabled switch and optional reference line. Core also
  offers a live operating-point marker and immediate voltage-point or maximum-clock locks.
- **Power and cooling:** percentage power limit and an additional watt cap,
  Voltage Boost, NVVDD/MSVDD OCP, shared or individual fan-channel duty within
  the driver's reported limits, and temperature-based fan curves.
- **Monitoring:** rail and ADC readings, clock graphs, power, P-states,
  temperatures, boost-limit reasons, memory timings, memory pressure and PCIe traffic.
- **Thermal inputs:** fixed temperatures for the GPU's voltage/frequency
  calculations, plus channel 2 for memory temperature. Default restores the
  GPU-provided input.
- **Dashboard:** collapsible sections, optional Quick tuning pins, tile
  visibility, themes, interface sizing and explanatory tooltips.
- **Multiple GPUs:** adapter selection with separate profiles and preferences
  for each GPU and VBIOS.

See the [control reference](docs/guide.md#dashboard-control-reference) for what
each setting changes and what can limit its effect.

## Profiles and automation

Profiles save applied settings and enabled/disabled switches. Loading a profile
restores its saved switches.

| Mode | What applying it does |
| --- | --- |
| **Normal / Only enabled settings** (default) | Applies settings enabled in the profile. Other GPU settings stay unchanged. |
| **Full snapshot** | Restores all settings saved in the profile, including disabled controls. Settings missing from the profile stay unchanged. |

The first new-profile save asks which mode to use. The choice is remembered
for this GPU and can be changed in
**Profile Manager → New profile mode** or overridden for one save. Existing
profiles keep their saved mode.

Saving or overwriting a profile saves applied settings in both modes. Unapplied
edits stay in the editor. Controls enabled only for an unapplied edit are not
saved as enabled. Switching a control off keeps it disabled in the profile.
Existing profiles keep their saved settings until overwritten.

**Load for editing** loads the profile for editing without applying it.
**Apply profile**, double-clicking a profile in the list, selecting one from the
header menu or using its global shortcut applies it immediately.
Profiles can also be selected for application at Windows logon.
Editing an existing profile's shortcut saves it immediately without changing
its tuning values or requiring Overwrite selected.

Applying a normal watt-cap profile leaves the existing percentage limit in place;
the lower limit governs. Applying a percentage profile releases a cap owned by
mVolt+ before setting the percentage. Full snapshots save both the applied
percentage limit and watt cap. See [power controls in profiles](docs/guide.md#power-controls-in-profiles).

Boost lock and the V/F editor's point/clock locks are immediate actions, outside
both profile modes. Core, XBAR, SYS and Video curves are saved separately.
Normal profiles save enabled curves that have already been applied. Disabled
curves are left out. Full snapshots save supported curves even when disabled.
A profile that does not contain a curve leaves it unchanged.

In **Settings → General**, enable **Start with Windows** and choose whether to
**Start minimized to tray**. A selected startup profile applies either way;
mVolt+ stays running for monitoring and software fan control.

[Profile guide](docs/guide.md#profiles) · [Startup and tray](docs/guide.md#startup-and-tray)

## Tuning Overview

Overview provides a compact view of your applied tuning settings, including
separate curve summaries, thermal inputs and enforced/requested power limits,
alongside the profile name and GPU BIOS. Power limits are separate from measured
power consumption.
**Copy summary** copies the current applied settings; **Always on top** keeps
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
New installations start with all tiles and V/F curves disabled. A successful
dashboard **Reset all** restores defaults, then disables them again.
Changing a tile or V/F switch alone does not create a pending tuning change.

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

Screenshots of v0.47.2 on an RTX 5090. The profiles and tuning values shown are
examples, not recommended settings.

### Dashboard

An example Quick tuning layout with the Min/Max voltage sliders.

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
