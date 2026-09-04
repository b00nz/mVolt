# mVolt+

mVolt+ is a lightweight Windows utility for NVIDIA GPU tuning, monitoring,
and profiles. It is designed primarily for RTX 50 series GPUs and also offers
experimental support for RTX 40, RTX 30, RTX 20, and GTX 10 series cards.

It ships as a single native executable with no installer.

## Download

- [mVolt+ v0.37 release](https://github.com/b00nz/mVolt/releases/tag/v0.37)
- [Download mVolt+.exe](https://github.com/b00nz/mVolt/releases/download/v0.37/mVolt+.exe)

Administrator privileges are required for tuning.

## Features

- NVVDD and MSVDD voltage-range control
- Core, memory, XBAR, SYS, and video clock offsets
- V/F curve editing
- Core, XBAR, SYS, and video voltage-demand offsets
- Board power limit
- NVVDD and MSVDD OCP limits in amps
- Voltage Boost, Boost Lock, and GPU clock-range control
- Linked or individual fan control with live RPM
- Live voltage, clock, power, P-state, and ADC telemetry
- Optional RTSS overlay output for rail and clock readings
- Compact Applied Settings summary with driver and VBIOS information
- Multi-GPU support
- Hideable tiles, scrolling, and adjustable interface scaling

Only controls supported by the selected GPU and driver are made available.

## Profiles and automation

- Save and load complete tuning profiles
- Apply a profile immediately or load it as pending settings
- Assign global hotkeys to profiles
- Apply a selected profile automatically at Windows logon
- Minimize or close mVolt+ to the system tray
- Keep separate profiles for each GPU and VBIOS

Profiles are complete snapshots. Enabled controls use their saved values,
disabled controls return to their defaults, and controls missing from older
profiles are left unchanged.

Default-valued settings appear disabled after loading. Hidden tiles are still
saved and applied.

## Applied Settings

The **Summary** button opens a compact, always-on-top view of the current
settings. It includes:

- Clock, voltage, power, OCP, fan, and lock settings
- Active profile and current time
- NVIDIA driver and VBIOS versions
- A copyable text summary for benchmark submissions

## Telemetry and RTSS

The telemetry window shows available rail, ADC, power, P-state, fan, and clock
data. Polling speed can be adjusted or paused while mVolt+ is minimized.

mVolt+ can also publish selected rail and clock readings to the RivaTuner
Statistics Server overlay. RTSS is optional, and the master switch and all
individual overlay items are off by default.

## Compatibility

- **RTX 50 / Blackwell:** Primary support
- **RTX 40 / Ada:** Experimental support
- **RTX 30 / Ampere:** Experimental support
- **RTX 20 / Turing:** Experimental basic tuning support
- **GTX 10 / Pascal:** Experimental basic tuning support

Available controls vary by card, firmware, and driver. Unsupported features
remain hidden or disabled instead of using unverified write paths.

Primary testing has been performed on GeForce RTX 5090, RTX 5080, and
RTX 5070 Ti hardware.

## Safety and persistence

- Opening mVolt+ and moving controls do not change GPU settings
- Changes are written only when **Apply**, **Default**, or **Auto** is used

> **Settings are not reverted when mVolt+ closes.** Applied voltage, clock,
> power, OCP, V/F, lock, and fan settings remain active until they are changed,
> reset, or cleared by the driver or a reboot. Use **Default** or **Auto** when
> you want to return a control to stock behavior.

GPU tuning can cause instability, driver resets, data loss, or hardware
damage. Use conservative values and proceed at your own risk.

## Command line

mVolt+ provides read-only status, GPU listing, compatibility reporting,
profile loading, and direct tuning options from the command line.

```powershell
.\mVolt+.exe --help
.\mVolt+.exe --list-gpus
.\mVolt+.exe --status
.\mVolt+.exe --diagnostic
```

## Screenshots

<picture>
  <img src="https://raw.githubusercontent.com/b00nz/mVolt/main/assets/mvolt-dashboard.png"
       alt="mVolt+ 0.37 dashboard">
</picture>

<picture>
  <img src="https://raw.githubusercontent.com/b00nz/mVolt/main/assets/mvolt-telemetry.png"
       alt="mVolt+ telemetry">
</picture>

<picture>
  <img src="https://raw.githubusercontent.com/b00nz/mVolt/main/assets/mvolt-vf-curve-editor.png"
       alt="mVolt+ V/F curve editor">
</picture>

<picture>
  <img src="https://raw.githubusercontent.com/b00nz/mVolt/main/assets/mvolt-profiles.png"
       alt="mVolt+ profile manager and RTSS options">
</picture>

## Requirements

- 64-bit Windows
- NVIDIA display driver
- Administrator privileges for tuning
- NVML support for GPU Clock Range
- RTSS only when overlay output is wanted

mVolt+ is an independent third-party project. It is not affiliated with,
sponsored by, approved by, or endorsed by NVIDIA Corporation. NVIDIA,
GeForce, RTX, and related product names are trademarks of their respective
owners and are used only to describe compatibility.

## Credits

- [Loong0x00](https://github.com/Loong0x00) for discovering the XBAR clock
  control
