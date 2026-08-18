# mVolt+

Windows tuning utility for Blackwell GPUs.

## Download

Download the latest `mVolt+.exe` from [GitHub Releases](https://github.com/b00nz/mVolt/releases/tag/v0.35)
or click here: [mVolt+.exe](https://github.com/b00nz/mVolt/releases/download/v0.35/mVolt+.exe)

Current release: **0.35**

## Features

- NVVDD/MSVDD minimum and maximum voltage control
- XBAR clock control and an adjustable MSVDD clock ratio affecting XBAR, SYS,
  and video clocks
- Core, memory, SYS and video clock offsets
- Power limit and Voltage Boost
- Linked and per-fan control with live RPM monitoring
- V/F curve editing with regional offsets and flattening
- Named tuning profiles for every control, with full-setting restore and
  optional automatic application at Windows logon
- Multi-GPU selection with per-GPU profiles and startup settings
- Live clock, rail, ADC, power and P-state telemetry in separate tabs
- Command-line status, tuning and profile application

## Dashboard controls

Moving a slider only changes its pending target. **Enable** arms the control,
**Apply** writes it, and **Default** restores the driver-reported default.

| Control | What it does |
|---|---|
| NVVDD / Core Voltage Range | Sets the core rail's minimum voltage with the left handle and maximum voltage with the right handle; it does not lock a constant voltage. |
| MSVDD Voltage Range | Sets the separate MSVDD rail's minimum and maximum voltage limits. |
| MSVDD Clock Ratio | Adjusts the MSVDD-domain clock ceiling relative to the core clock, affecting XBAR, SYS, and Video clocks; each still follows its own V/F curve and clock limits. |
| Core Clock Offset | Adds a global core-clock offset that stacks with regional V/F point offsets. |
| Memory Clock Offset | Adds an offset to the driver-exposed VRAM clock. |
| XBAR Clock Offset | Adds an offset to the GPU crossbar/interconnect clock. |
| Power Limit | Sets the board-power ceiling as a percentage of the firmware default. |
| SYS Clock Offset | Adds an offset to the GPU's internal system clock domain. |
| Voltage Boost | Sets NVIDIA's Voltage Boost percentage; it does not directly set a rail voltage. |
| Video Clock Offset | Adds an offset to the driver-exposed video clock domain. |
| Fan Control | The linked slider sets every fan; the per-fan sliders set individual channels, and **Auto** returns control to firmware. |

**MSVDD Clock Ratio example:** The nominal relationship is approximately
`clock ceiling = core clock x ratio`. With the core at 3000 MHz, `0.90`
corresponds to a 2700 MHz ceiling for XBAR, SYS, and Video clocks, while `1.20`
corresponds to 3600 MHz. The ceiling moves as the core clock changes with GPU
Boost; it does not force any domain to run at that exact frequency. Actual
clocks can remain lower because each domain still follows its own V/F curve,
offset, hardware limit, and workload-dependent boost behavior.

## Compatibility

Tested on GeForce RTX 5090, RTX 5080, and RTX 5070 Ti.

## Screenshots

<picture>
  <img src="https://raw.githubusercontent.com/b00nz/mVolt/main/assets/mvolt-dashboard.png"
       alt="mVolt+ 0.34 dashboard">
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
       alt="mVolt+ profile manager">
</picture>

Administrator privileges are required. Hardware support varies by GPU,
driver, and VBIOS. GPU tuning can cause crashes or hardware damage; use it
at your own risk.

mVolt+ is not affiliated with or endorsed by any GPU manufacturer.

## Credits

- [Loong0x00](https://github.com/Loong0x00) for discovering the XBAR clock
  control.
