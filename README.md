# mVolt+

**NVIDIA GPU tuning, monitoring and profiles — in one native Windows executable.**

mVolt+ brings core and fabric voltage controls, clock offsets, curve editing,
power limits and detailed telemetry into one dashboard. RTX 50 series is the
primary target; selected controls are also available experimentally on earlier
GeForce generations. Availability depends on the GPU, VBIOS and driver.

**[Download releases](https://github.com/b00nz/mVolt/releases/latest)** ·
**[User guide](docs/guide.md)** ·
**[Upgrading from v0.38](docs/guide.md#upgrading-old-profiles)** ·
**[Report an issue](https://github.com/b00nz/mVolt/issues)**

This README and the guide describe **v0.39**. Check the release page for the
version of the downloadable build.

![mVolt+ v0.39 core controls, including the new voltage-limit offset card](assets/mvolt-dashboard.png)

*Screenshots are live captures of v0.39 running on an RTX 5090. The displayed values illustrate the
interface; they are not recommended tuning settings.*

## Start here

| I want to… | Read this |
| --- | --- |
| Understand Enabled, Target, Applied and Reset | [How the dashboard works](docs/guide.md#how-the-dashboard-works) |
| Learn what every tile does | [Dashboard control reference](docs/guide.md#dashboard-control-reference) |
| Understand VMIN, REL, ALT, OV and effective maximum | [Voltage limits and measured voltage](docs/guide.md#voltage-limits-and-measured-voltage) |
| Edit a V/F curve | [V/F Curve Editor](docs/guide.md#vf-curve-editor) |
| Choose fixed fans, a fan curve or firmware control | [Fan control and persistence](docs/guide.md#fan-control-and-persistence) |
| Save, apply or automate profiles | [Profiles](docs/guide.md#profiles) · [Startup and tray](docs/guide.md#startup-and-tray) |
| Find out what is limiting boost | [Telemetry](docs/guide.md#telemetry) |
| Fix a confusing reading or behavior | [Troubleshooting](docs/guide.md#troubleshooting) |

The guide has expandable explanations for individual controls and common
questions. It works directly on GitHub; no separate viewer is needed.

## What changed in v0.39

- **Two redesigned rail cards:** VMIN, REL, ALT and supported OV offsets replace
  absolute voltage-range sliders. REL and ALT can be edited together or separately.
- **Clearer tuning workflow:** visible participation switches, live slider targets,
  pending-change review and immediate per-card Reset.
- **Normal profiles and optional full snapshots:** normal profiles apply the
  controls enabled when saved; snapshots also restore captured disabled controls.
- **Expanded telemetry:** absolute hotspot where supported, firmware clock history,
  boost-limit reasons and timelines, rail power, memory pressure and PCIe traffic.
- **A more flexible interface:** Quick tuning pins, collapsible sections, hover help,
  interface scaling, Appearance settings and a compact two-column Overview.
- **Improved integration:** profile participation, power reapplication, fan
  transactions, startup readiness, recovery and repainting fixes.

## Quick start

1. Download the executable or ZIP from [Releases](https://github.com/b00nz/mVolt/releases/latest).
   The app needs 64-bit Windows and an NVIDIA driver. Administrator privileges
   are required to apply tuning.
2. Confirm the selected GPU in the header. Open **Telemetry** to inspect its
   readings, or launch with `--read-only` to explore with tuning writes disabled.
3. Enable a control you want mVolt+ to manage, then adjust its target. Slider and
   input edits stay pending. Use **Review…** and **Apply changes** to commit them.
4. Once you have checked the result under your own workloads, use
   **Profiles → Save current settings as…** to save the configuration.

<details>
<summary><strong>Which actions change the GPU immediately?</strong></summary>

| Action | What happens |
| --- | --- |
| Move a slider, type a target, edit curve points | Stages an edit; does not apply it |
| Enable or disable a dashboard tile | Changes participation; disabling leaves the applied value in place |
| Apply changes / Reapply enabled | Writes enabled dashboard targets |
| Apply fans | Writes the fan tile's pending targets in one step |
| Reset / Reset all | Immediately applies the relevant defaults; no second Apply |
| Boost lock | Immediately toggles boost performance mode |
| Choose a profile in the header / Apply profile / profile shortcut | Immediately applies that profile |
| Select a row in Profile Manager / Load for editing | Previews or stages the profile; does not apply it |
| Discard pending | Restores editing targets from readback; does not reset hardware |

Turning off advanced ranges can also apply narrower limits.
See [Advanced tuning](docs/guide.md#advanced-tuning).

</details>

## How profiles work

Profiles belong to the selected GPU and VBIOS. They save values and the
Enabled/Disabled switches **as they were when saved**; the dashboard's current
switches do not override those choices when you load a profile.

| Mode | What applying the profile does |
| --- | --- |
| **Normal** (default) | Applies saved-enabled settings, including zero or stock values. Saved-disabled and absent settings stay untouched. |
| **Full snapshot** (opt-in when saving) | Also restores captured disabled settings. Enabled controls use their targets, including pending edits; disabled controls use current GPU readback. Absent settings stay untouched. |

Saving a profile does not apply it. **Load for editing** stages its targets and
switches for review; **Apply profile**, choosing a profile in the header, or its
global shortcut applies it immediately. Shortcuts require mVolt+ to be running,
including in the tray. **Apply selected profile at logon** enables automatic
application when you sign in.

The guide explains [saving, snapshots, previews, shortcuts and profile matching](docs/guide.md#profiles),
plus [startup and tray behavior](docs/guide.md#startup-and-tray).

## Upgrading old profiles

**Older supported profile files can be read, but some require review before
they can be applied.** v0.39 changes both rail editing and profile behavior:

- An enabled old **absolute NVVDD/MSVDD range** cannot be applied directly,
  including at logon. Use **Load for editing**, review the offsets seeded from
  the GPU's **current readback**, then save an updated profile. This does not
  recreate the old absolute range automatically.
- In a normal profile, controls **enabled when saved** are applied. Saved-disabled
  or absent controls are left untouched; disabled no longer means reset to stock.
- **Full snapshot** is opt-in. It restores all captured controls, including
  disabled ones. Existing profiles are not silently converted to this mode.

Keep a copy of `%LOCALAPPDATA%\mVolt+` before upgrading if you need to return to
v0.38. Review the saved switches and test a migrated profile before selecting it
for automatic logon application. [Full migration instructions](docs/guide.md#upgrading-old-profiles).

## Controls and monitoring

| Area | Available functions |
| --- | --- |
| NVVDD / Core | Core rail limits, core voltage demand, core clock offset, GPU clock range and NVVDD OCP |
| MSVDD / Fabric | Fabric rail limits, XBAR/SYS/video voltage demands and clocks, MSVDD OCP |
| Memory / VRAM | Memory clock offset |
| Power / Boost / Cooling | Board power limit, Voltage Boost, bidirectional core/fabric clock propagation ratio and fan duties |
| Curve editors | Core V/F points, region editing, Flatten above, undo/redo and temperature-based fan control |
| Telemetry | Rails/ADCs, clocks, power, P-states, temperatures, boost limits, memory pressure and PCIe |
| Overview | All current settings in two columns, profile/VBIOS identity, Copy summary and Always on top |
| Profiles and preferences | Per-GPU/VBIOS profiles, full snapshots, shortcuts, logon application, RTSS overlay, scaling and themes |

Features are enabled only where the relevant hardware and driver interfaces
are supported. Some private monitoring features have narrower compatibility
than the rest of the application. [Compatibility details](docs/guide.md#compatibility-and-multiple-gpus).

## What stays applied after closing?

Applied clocks, rail offsets, power/current limits, V/F edits, locks and fixed
fan duty are not reverted when mVolt+ exits. The driver can clear settings on
a reset or reboot; configured startup and recovery handle reapplication.

**A software fan curve needs mVolt+ running to keep following temperature.**
The tray is sufficient. Fully exiting leaves the last fan duty fixed;
**Reset to auto** returns temperature control to the GPU firmware.

GPU tuning can cause instability or hardware damage. An accepted setting is
not proof of stability, and a reported device limit is not a safe-voltage rating.

## Command line

```powershell
.\mVolt+.exe --help | Out-Host
.\mVolt+.exe --list-gpus | Out-Host
.\mVolt+.exe --status | Out-Host
.\mVolt+.exe --read-only
```

Direct CLI tuning is applied immediately. Rail options now use
`--nvvdd-offsets VMIN,REL,ALT[,OV]` and `--msvdd-offsets VMIN,REL,ALT[,OV]`.
[CLI reference and automation](docs/guide.md#command-line-and-automation).

## More screenshots

<details>
<summary>Telemetry, V/F editing, Profiles and Overview</summary>

![Telemetry with measured clocks and firmware clock history](assets/mvolt-telemetry.png)

![V/F Curve Editor with labelled voltage and frequency axes](assets/mvolt-vf-curve-editor.png)

![Profile Manager with saved values and separate apply/edit actions](assets/mvolt-profiles.png)

![Compact Tuning Overview with every setting visible](assets/mvolt-overview.png)

</details>

## Requirements and project information

- 64-bit Windows and an NVIDIA display driver.
- Administrator privileges for tuning; read-only commands do not require elevation.
- Working NVML support for GPU clock-range control and relevant NVML telemetry.
- RivaTuner Statistics Server only if you want its on-screen overlay.

RTX 50 / Blackwell is the primary target. RTX 40 / Ada, RTX 30 / Ampere,
RTX 20 / Turing and GTX 10 / Pascal have experimental, feature-dependent support.
Support for one function does not imply support for every rail, curve or sensor.

mVolt+ is an independent third-party project. It is not affiliated with,
sponsored by, approved by, or endorsed by NVIDIA Corporation. NVIDIA, GeForce,
RTX and related product names belong to their respective owners.

Thanks to [Loong0x00](https://github.com/Loong0x00) for discovering the XBAR clock control.
