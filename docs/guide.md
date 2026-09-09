# mVolt+ user guide

**For v0.39** · [Back to the project](../README.md) · [Releases](https://github.com/b00nz/mVolt/releases/latest)

mVolt+ changes the requests and limits the NVIDIA driver uses to operate your
GPU. It also shows what the driver reports and what available sensors measure.
A requested clock, an evaluated voltage limit and a measured voltage describe
different things; this guide explains how to read them together.

Expand a control below to see what it does, what changing it affects, and what
can limit the result. Screenshots illustrate the interface, not a tuning preset.
They show the live v0.39 app running on an RTX 5090.

## Find your way

| Topic | What you will learn |
| --- | --- |
| [How the dashboard works](#how-the-dashboard-works) | Targets, switches, Apply, Reset and Discard |
| [Dashboard control reference](#dashboard-control-reference) | Every tile, grouped as it appears in the app |
| [Voltage limits and measured voltage](#voltage-limits-and-measured-voltage) | VMIN, REL, ALT, OV, linked editing and MAX |
| [V/F Curve Editor](#vf-curve-editor) | Point edits, regions, Flatten above and global offsets |
| [Fan control and persistence](#fan-control-and-persistence) | Fixed duty, firmware auto, curves and hysteresis |
| [Profiles](#profiles) | Saving, applying, full snapshots, comparisons and shortcuts |
| [Upgrading old profiles](#upgrading-old-profiles) | What carries forward and what needs review |
| [Startup and tray](#startup-and-tray) | Logon readiness, recovery and closing behavior |
| [Telemetry](#telemetry) | Sensors, graphs, boost reasons, memory pressure and PCIe |
| [Overview](#overview) | A compact view of current settings |
| [Settings and layout](#settings-and-layout) | Polling, RTSS, themes, sizing and tile visibility |
| [Advanced tuning](#advanced-tuning) | Extended demands, OCP unlock and XOC |
| [Compatibility and multiple GPUs](#compatibility-and-multiple-gpus) | Selecting hardware and understanding unavailable controls |
| [Command line and automation](#command-line-and-automation) | Read-only commands and immediate tuning requests |
| [Files and logging](#files-and-logging) | Profiles, backups and storage footprint |
| [Troubleshooting](#troubleshooting) | Common questions and useful issue reports |

## How the dashboard works

The header identifies the selected GPU, driver and VBIOS. Its live readings show
core clock, voltage, power, GPU temperature and supported hotspot temperature.
The profile selector shows the recognized saved profile or **Custom**.

| Label or action | Meaning |
| --- | --- |
| **Enabled** | Includes this control in normal Apply and recovery and allows editing |
| **Disabled** | Excludes this control from normal Apply; its existing applied value remains |
| **Target** | The value you are editing; moving a slider updates it immediately |
| **Applied** | The setting currently read back from the driver |
| **Live** | A changing measurement, such as clock, watts or RPM |
| **Allowed** | The editing range available in the current configuration |
| **Review…** | Lists pending changes before you apply them |
| **Apply changes** | Writes enabled targets and checks driver readback |
| **Reapply enabled** | Sends enabled targets again, even with no numeric edits pending |
| **Discard pending** | Returns editing targets to applied state without resetting hardware |
| **Reset** | Immediately restores that card's default and updates its targets |
| **Reset all** | Immediately restores defaults for all supported controls, including hidden and disabled tiles |

**Switches control participation, not stock status.** A disabled tile can show a
non-default applied value. Turning it off does not undo previous tuning or reset
a value written by another application. Use Reset when you want to reset it.

Slider, stepper and text edits are pending until Apply. A card-specific Apply
acts on that card; **Apply fans** acts on the fan tile. Other dashboard drafts
remain pending. Reset is immediate and needs no second Apply.

**Boost lock**, applying a saved profile and Reset actions are immediate.
Selecting a profile in the Profile Manager list only previews it, while selecting
one from the **header menu applies it**. Startup application and profile shortcuts
also write settings when configured. Narrowing advanced ranges can write limits;
see [Advanced tuning](#advanced-tuning).

An Apply success means the driver accepted and retained the checked settings.
It does not establish stability under load. Check your own workloads before
making a configuration your automatic startup profile.

## Dashboard control reference

Quick tuning contains cards you pin. The remaining sections are ordered
**NVVDD / Core → MSVDD / Fabric → Memory / VRAM → Power / Boost / Cooling**.
Pinned cards move; they are not duplicate controls.

### NVVDD / Core

NVVDD is the core voltage rail. These controls affect core voltage policy,
core clock requests, the clock-range lock and the rail's current limit.

<details>
<summary><strong>Core voltage limits</strong> — VMIN, REL, ALT and supported OV offsets</summary>

Adjusts offsets to the core rail's driver voltage limits. Negative offsets lower
the corresponding limit; positive offsets raise it. The driver baseline can move
with operating conditions, so the resulting limits can change while your offsets
stay fixed.

The card shows the **Current effective maximum** and evaluated limits separately
from its editable offsets. They describe voltage policy, not physical voltage.
REL and ALT can be linked for editing or adjusted separately.

[Read the voltage-limit explanation](#voltage-limits-and-measured-voltage) before
using these controls. Reset uses mVolt+'s mode-aware rail defaults; it does not
lock the rail to an absolute voltage.

</details>

<details>
<summary><strong>Core voltage offset</strong> — the core domain's voltage demand</summary>

Changes the voltage demand for the core clock domain. Positive values ask for
more voltage; negative values ask for less. Another domain sharing the rail or
an active voltage limit may still determine the voltage actually supplied.

This is separate from the **Core voltage limits** card. A voltage request can
change without producing the same change in measured voltage. Reset clears
the demand offset.

</details>

<details>
<summary><strong>Core clock offset</strong> — shift the core frequency request</summary>

Shifts the core frequency requested along the voltage/frequency curve. Positive
values request a higher clock at the same curve voltage; negative values request
a lower clock. Actual speed depends on workload and the GPU's voltage, power,
thermal and clock limits.

The global core offset stacks with regional V/F point offsets. Reset clears
the global offset while preserving the separate regional curve edits. A higher
request can reduce stability without increasing achieved performance.

</details>

<details>
<summary><strong>GPU clock range</strong> — request minimum and maximum core clocks</summary>

Requests a minimum and maximum core clock through the driver. A narrower range
constrains clock selection, but other GPU limits can still reduce achieved speed.
It does not set a voltage or guarantee that a requested clock will be held.

Reset releases the clock-range lock. Disabling the tile leaves an already-applied
lock in place. Boost lock can be enabled alongside it; the two controls request
different behaviors and their combined result depends on the GPU and driver.

</details>

<details>
<summary><strong>OCP limit</strong> — NVVDD output-current limit, in amperes</summary>

Sets the output-current limit for the NVVDD core rail. Lower values can make
current limiting reduce core boost sooner; higher values permit more current
within the other active limits. This is a protection threshold, not measured
current or the board's power budget.

The ordinary range is capped at the firmware default where available. **OCP
unlock** exposes the extended supported range. Reset returns this channel to
its firmware default. The OCP tile in Fabric controls a different rail.

</details>

### MSVDD / Fabric

MSVDD supplies the fabric side of the GPU. These controls are separate from the
VRAM clock offset in Memory. The MSVDD OCP setting is a fabric-rail current limit,
not a memory-clock control.

<details>
<summary><strong>MSVDD voltage limits</strong> — fabric-rail voltage-policy offsets</summary>

Adjusts VMIN, REL, ALT and supported OV offsets for MSVDD. Their meaning and
linked-edit behavior match the core rail card, but they affect the fabric
rail's own policy and use that rail's reported limits.

Changing fabric voltage limits can constrain fabric clocks; core/fabric clock
propagation and other limits can influence the result. This card does not directly
set VRAM voltage. See [Voltage limits and measured voltage](#voltage-limits-and-measured-voltage),
including the different MSVDD Reset default.

</details>

<details>
<summary><strong>XBAR voltage offset</strong> — crossbar voltage demand</summary>

Changes the voltage demand for the crossbar fabric domain. Positive values ask
for more voltage; negative values ask for less. Shared rail demands and active
voltage limits can keep actual voltage from following the request directly.

It is independent of the XBAR clock offset and MSVDD rail-limit offsets.
Reset clears this domain's voltage-demand offset.

</details>

<details>
<summary><strong>XBAR clock offset</strong> — crossbar fabric frequency</summary>

Shifts the crossbar fabric clock request. A higher offset requests a faster
fabric clock; a lower offset reduces the request. Core/fabric propagation, the
fabric V/F relationship and other GPU limits can prevent the requested change
from appearing in the measured clock.

Use the XBAR **Live** reading or Telemetry's measured clocks to inspect the result.
Reset clears this clock offset.

</details>

<details>
<summary><strong>SYS voltage offset</strong> — system-domain voltage demand</summary>

Changes the voltage demand for the GPU system domain. Positive values ask for
more voltage; negative values ask for less. Another domain sharing its rail,
or a voltage-policy limit, can determine the voltage actually supplied.

This is separate from SYS frequency and either rail's REL/ALT limits.
Reset clears the demand offset.

</details>

<details>
<summary><strong>SYS clock offset</strong> — system-domain frequency</summary>

Shifts the clock request for the GPU system domain. Positive values request a
higher frequency and negative values a lower one. Workload, driver clock steps
and voltage/power limits determine the measured result.

A requested offset may be normalized to a nearby supported clock step. Read
**Applied** and **Live** separately; Reset clears the offset.

</details>

<details>
<summary><strong>Video voltage offset</strong> — video-domain voltage demand</summary>

Changes the voltage demand for the GPU video domain. Positive values ask for
more voltage; negative values ask for less. Shared rail demands and active
voltage limits can restrict the resulting voltage.

It does not change video quality or choose an encoder preset. Reset clears this
domain's voltage-demand offset.

</details>

<details>
<summary><strong>Video clock offset</strong> — video-domain frequency</summary>

Shifts the clock request for the GPU video domain. Positive values request a
higher frequency and negative values a lower one. Whether this changes measured
speed or workload performance depends on the active task and other GPU limits.

It does not force constant video-engine activity. Reset clears the offset.

</details>

<details>
<summary><strong>OCP limit</strong> — MSVDD output-current limit, in amperes</summary>

Sets the output-current limit for the MSVDD fabric rail. Lower values can
constrain fabric boost sooner; higher values permit more current within other
active limits. It is a protection threshold, not measured current or a VRAM offset.

**OCP unlock** expands the editable range beyond the firmware default where
supported. Reset restores this rail's firmware current limit.

</details>

### Memory / VRAM

<details>
<summary><strong>Memory clock offset</strong> — shift the VRAM clock request</summary>

Shifts the memory clock request above or below its default. A higher offset can
increase available bandwidth, but excessive offsets can reduce stability or
performance. A successful Apply does not establish error-free operation.

Live memory clocks depend on the performance state. Clock frequency and effective
memory transfer rate can use different conventions, so numbers from different
tools are not always directly comparable. Reset clears the memory offset.

</details>

### Power / Boost / Cooling

<details>
<summary><strong>Power limit</strong> — board-power budget, as a percentage</summary>

Sets the board-power budget as a percentage of the driver default. Lowering it
can reduce power consumption and boost clocks under load; raising it permits
more power within the supported range. The GPU only draws what its workload
and active limits allow.

The range comes from the selected GPU. In Telemetry, compare **Requested limit**,
**Enforced limit** and measured board power: they are different readings, and
enforcement can lag a request. Reset restores the board's default limit.

</details>

<details>
<summary><strong>Voltage boost</strong> — additional voltage headroom for GPU Boost</summary>

Adjusts how much additional voltage headroom GPU Boost may use. A higher value
allows more of the available boost-voltage range; it does not force a particular
voltage or increase physical voltage by that percentage.

Workload, reliability, power and thermal limits still apply. Voltage Boost can
change the baseline used to evaluate rail limits, even when the rail offsets
themselves have not changed. Reset returns this control to its default.

</details>

<details>
<summary><strong>NVVDD / MSVDD clock propagation ratio</strong> — the core/fabric clock relationship</summary>

Sets the clock relationship between the NVVDD core and MSVDD fabric domains.
A lower ratio requests less fabric frequency relative to the core; a higher
ratio requests more. Because the relationship is bidirectional, constraints on
either domain can influence the other's clock request.

Actual frequencies remain subject to the GPU's clock, voltage and power limits.
This adjusts clock propagation, not either rail's voltage directly. A requested
ratio is also distinct from the **Live** ratio calculated from measured clocks.

To see the relationship in practice, use a low power limit under a steady load
and watch how XBAR, SYS and video clocks change relative to the core as you
adjust the ratio.

</details>

<details>
<summary><strong>Fan control</strong> — fixed duty for all fans or individual channels</summary>

Sets a fixed fan duty, in percent. **All fans** sets a shared pending target;
individual sliders change only their own fan. Different targets make the shared
control show **Mixed**. Moving All fans again replaces the individual targets.

**Apply fans** commits the tile in one step; global Apply can commit it too.
Applying fixed duty replaces an active software fan curve. RPM depends on fan
hardware and operating limits, so duty percent is not an RPM percentage.

**Reset to auto** immediately returns all channels to firmware control. Fixed
duty remains after exit. [Compare the fan modes](#fan-control-and-persistence).

</details>

### Header action: Boost lock

**Boost lock** immediately requests the GPU's boost performance mode instead of
normal idle downclocking. It can raise idle power consumption. It does not remove
voltage, power or thermal limits, nor guarantee a particular frequency.
Click it again to release the request.

It is separate from **Voltage boost** and **GPU clock range**. mVolt+ allows a
clock range and Boost lock together; evaluate their combined behavior on your
hardware. Disabling the clock-range tile does not release an applied lock.

## Voltage limits and measured voltage

**All controls in the two rail-limit cards adjust offsets to the driver's voltage
limits. The resulting limits can change with operating conditions, even when
your offsets stay unchanged.** Values are signed millivolts, not absolute targets.

| Control or reading | What it means | Effect of changing it |
| --- | --- | --- |
| **Minimum offset (VMIN)** | Offset to the minimum-voltage policy | Lowering reduces the minimum request; raising can hold the rail at a higher requested minimum. Other policy and operating constraints still apply. |
| **Reliability offset (REL)** | Offset to the reliability voltage limit | Raising permits a higher REL limit; lowering makes it more restrictive. It does not force the rail to use that voltage. |
| **Alternate limit offset (ALT)** | Offset to an alternate reliability limit | Changes the alternate limit. The driver determines when it applies; there is no universal rule that it is only a temperature or aging limit. |
| **Overvoltage offset (OV)** | Offset to the overvoltage policy ceiling | A sufficiently lower OV can constrain the effective maximum. Raising it may have no effect while another limit remains tighter. |
| **Current effective maximum / MAX** | The driver's evaluated upper limit now | Read-only. Reports the current policy result, not pending edits or measured rail voltage. |

The numerical range a control accepts is not a recommended operating range.
The voltage device's reported range is separate from the policy-offset ranges.
[How XOC affects the ceiling](#advanced-tuning).

<details>
<summary><strong>Why changing REL alone may do nothing</strong></summary>

Another applicable limit can still constrain the maximum. If REL rises while
ALT or OV remains more restrictive, MAX may stay unchanged. Even when MAX rises,
the workload may not request more voltage or another power/clock limit may intervene.

Watch the evaluated limits, then compare physical sensor readings under comparable
conditions. Do not assume every GPU or operating state requires both REL and ALT
to change.

</details>

<details>
<summary><strong>Linked versus separate REL/ALT editing</strong></summary>

**Linked** presents one REL + ALT offset control. A deliberate edit sets the
same offset in both pending fields. **Separate** exposes each offset on its own.
Profiles with unequal values retain them and open in separate mode.

Changing the editing mode alone does not apply or overwrite existing values.
If you link unequal targets, **Mixed** remains until you deliberately enter a
shared offset. Linking matches offsets, not absolute voltages: the driver
baselines can differ and move independently.

</details>

<details>
<summary><strong>What the header voltage measures</strong></summary>

The header averages valid current core/NVVDD ADC samples. It excludes the
SYS/MSVDD sensor. This is an average across available sensors in a snapshot,
not a time average.

Telemetry exposes individual ADC readings and separate rail policy readings.
Another tool may show a different sensor, sampling instant or averaging method.
Compare the sensor meaning as well as its label; MAX and voltage limits are not
physical voltage measurements.

</details>

<details>
<summary><strong>What Reset does on the rail cards</strong></summary>

NVVDD Reset clears VMIN, REL and ALT offsets. MSVDD Reset clears VMIN and ALT
and restores mVolt+'s established **−50 mV REL** default. Supported OV offsets
are cleared. If the default REL would exceed the current mode/device ceiling,
the reset request is limited to that ceiling.

These defaults do not produce the same absolute voltage across workloads or GPUs.
An ordinary saved zero offset is a literal zero; it does not mean “recalculate
this Reset behavior later.”

</details>

## V/F Curve Editor

The editor changes the core frequency requested at individual voltage bins.
The horizontal axis is voltage in **mV**; the vertical axis is frequency in
**MHz**. Hovering a point shows voltage and target frequency. The selection panel
separates global core offset, point offset and the effective shift.

![V/F Curve Editor](../assets/mvolt-vf-curve-editor.png)

| Action | Result |
| --- | --- |
| Click a point | Selects the point |
| Drag a point vertically | Stages a new frequency at that voltage bin |
| Drag empty graph space | Selects a region; dragging a selected point moves the selection |
| Selected MHz → Set point | Stages the entered frequency for the selected point |
| Point offset → Set offset | Stages the regional frequency offset for selected points |
| Flatten above | Stages a flat upper curve from the selected point through higher-voltage bins |
| Undo / Redo | Restores pending edits; a drag is one history step |
| Apply | Writes and verifies the pending curve |
| Discard | Returns to the currently applied curve without resetting it |
| Reset V/F curve | Immediately clears regional point offsets, preserving separate global settings |

Ctrl+Z and Ctrl+Y work when the graph has focus. Applying, discarding or refreshing
the curve starts a new edit history.

Global core clock offset and regional V/F offsets stack. Core voltage demand can
also affect the displayed voltage axis. Voltage bins are not moved by dragging;
the editor changes frequency offsets. Driver clock steps may normalize the result.

**Flatten above does not set an absolute voltage lock.** It shapes frequency at
higher-voltage points; the GPU still selects an operating point under its active
limits. Applied V/F edits remain after exit until changed or cleared by the driver.

## Fan control and persistence

Choose a mode based on who should adjust fan duty as temperature changes.

| Mode | Who changes duty? | In the tray | After fully exiting |
| --- | --- | --- | --- |
| **Firmware automatic** | GPU firmware | Firmware continues | Firmware continues |
| **Fixed duty**, from the fan tile | Your applied percent target | Duty remains fixed | Last duty remains fixed |
| **mVolt+ fan curve** | mVolt+, using GPU temperature | Curve tracks temperature | Tracking stops; last duty remains fixed |

**The custom fan curve is not uploaded to firmware.** Saving its points in a
profile does not make firmware execute them. Use **Close window to tray** to
hide the window while mVolt+ continues controlling the fans.

<details>
<summary><strong>Build and apply a fan curve</strong></summary>

1. Open **Fan Curve**. The graph maps GPU temperature to requested fan duty.
2. Drag points to reshape the curve. Double-click to add a point; right-click
   a point to remove it. The point list allows fine duty adjustments.
3. Set **Use fan curve** to On and choose the fall hysteresis.
4. Click **Apply**. Pending edits do not replace the running curve before Apply.

The software curve drives fans together within their supported duty ranges.
To return to firmware control, apply the curve with **Use fan curve: Off**, or
use the dashboard's immediate **Reset to auto**.

**Reset curve** restores and immediately applies the default points and hysteresis,
while keeping the curve's current applied enabled state. It differs from Reset
to auto.

</details>

<details>
<summary><strong>Why fall hysteresis defaults to 3 °C</strong></summary>

Fall hysteresis holds the higher fan duty until temperature has fallen enough.
This reduces repeated speed changes near a boundary. A larger value holds higher
duty longer; a smaller value lets the curve reduce duty sooner. Rising temperature
can still increase duty immediately.

The default is **3 °C**, and you can adjust it. This controls cooling response;
it is not a claim about temperature-sensor accuracy.

</details>

Pausing monitoring or hiding the dashboard does not stop an active curve's
required temperature checks. If a temperature read fails, the controller holds
the last duty until valid readings return. A driver reset can change fan state;
readback tells you what is currently applied.

## Profiles

Profiles store configuration for the selected physical GPU and VBIOS. They
record values and which controls were enabled when saved. Current dashboard
switches do not override a profile's saved participation when it is loaded.

### Normal profiles and full snapshots

| Saved control | Normal profile | Full snapshot |
| --- | --- | --- |
| Present and enabled | Applies its saved value, including zero/default values | Applies its captured value |
| Present and disabled | Leaves the current GPU setting untouched | Restores its captured readback value |
| Absent or unavailable at capture | Leaves it untouched | Leaves it untouched |

**Normal is the default.** Select **Full snapshot (include disabled settings)**
when saving if you want to restore captured disabled controls too. Disabled
controls are captured from applied readback; enabled controls use dashboard
targets, including pending edits. A snapshot therefore need not represent only
already-applied hardware settings.

A snapshot can restore a stock board-power limit even if that tile was disabled
at capture, provided that stock limit was actually read then. Disabling a tile
is not evidence that its value is stock.

### Save, preview and apply

| Profile Manager action | What it does |
| --- | --- |
| Select a profile in the list | Shows its saved values without applying |
| Save current settings as… | Captures a preview and opens the Save profile flow |
| Save profile | Stores the captured configuration; does not write to the GPU |
| Overwrite selected | Replaces the selected profile with current dashboard configuration |
| Differences from applied… | Compares participating saved settings with current readback |
| Apply profile | Immediately applies the saved configuration |
| Load for editing | Stages its targets and switches on the dashboard |
| Restore backup | Restores the saved profile document backup without applying it |
| Delete | Removes the selected profile after confirmation; applied settings stay in place |

The header profile menu applies immediately. The Profile Manager list only selects
a preview. After a successful apply, the profile name can be recognized on the
next launch if readback still matches; mVolt+ need not reapply it to display the
name. **Custom** means no saved profile is currently identified as active.

Stored V/F edits are part of the saved configuration. Fan curves use their
applied/pending mode separately from duty that changes during monitoring.
Loading a normal profile with fan control disabled leaves a running fan curve alone.

### Global profile shortcuts

Click **Global profile shortcut** and press a combination with Ctrl, Alt, Shift
or Win. Save it with the profile. Backspace or Delete clears the shortcut.
Shortcuts work while mVolt+ runs, including in the tray, and apply the same saved
configuration as **Apply profile**. Conflicts with another application's shortcut
are shown beside the field. A fully exited app cannot respond to shortcuts.

## Upgrading old profiles

v0.39 reads the supported earlier profile formats. Legacy VBIOS-only files can
be migrated to the per-adapter location. **Readable does not always mean ready
for immediate application.**

| Existing profile content | v0.39 behavior |
| --- | --- |
| Supported clock, power, OCP, fan and other current controls | Retained, then validated against current GPU capabilities/ranges |
| Enabled old absolute NVVDD/MSVDD range | Apply, startup and recovery refuse that legacy rail request until reviewed |
| Disabled old rail in a normal profile | Left untouched on Apply |
| Saved-disabled controls | Left untouched in normal mode; no automatic reset-to-stock behavior |
| Controls absent from an older file | Remain absent and untouched |
| Older file without full-snapshot mode | Remains a normal profile |

### Migration sequence

1. With the app closed, copy `%LOCALAPPDATA%\mVolt+` somewhere safe. Keep the
   original if you may return to v0.38; newly saved v0.39 files are not a promise
   of backward compatibility with an older executable.
2. Open v0.39 and select the correct GPU and VBIOS profile set.
3. In Profiles, select the old profile and choose **Load for editing**.
4. For legacy rail ranges, mVolt+ seeds the controls from **current driver
   offsets**, not a conversion of the old absolute targets. Review VMIN/REL/ALT/OV
   and set your intended values.
5. Check every Enabled/Disabled choice. Old files retain the flags they actually
   contain; a build that did not record your intended switch choice cannot
   reconstruct it from a zero or nonzero value.
6. Use **Save current settings as…** to save a new profile, or overwrite after
   preserving the original. Choose Full snapshot only if you want that behavior.
7. Apply the reviewed profile manually and verify it before enabling logon application.

Driver baselines move with operating conditions. Translating an old absolute
target into an offset using today's baseline would imply accuracy that the file
cannot provide. This is why rail migration requires review.

OV can also become unavailable after a GPU or driver change. **Load for editing**
excludes unsupported OV and shows a notice, leaving the original saved profile
and existing GPU OV offset unchanged. Review and save a new profile for the
remaining controls; automatic application of the unsupported request is refused.

## Startup and tray

**Apply selected profile at logon** chooses a profile for application when you
sign in. **Start in tray at Windows logon** controls resident startup. A startup
profile needing resident fan ownership also keeps mVolt+ in the tray.

Startup has no fixed 20-second delay. mVolt+ waits up to 60 seconds for the
NVIDIA display service when present/enabled and stable readbacks from the selected
GPU and required controls. The NVIDIA Control Panel window does not need to be
open. An unready driver times out without applying.

| Preference or action | Behavior |
| --- | --- |
| Minimize to tray | Minimizing keeps the process running in the notification area |
| Close window to tray | Closing the dashboard keeps the process running |
| Tray → Show | Restores the dashboard |
| Tray → Exit | Fully closes the app; applied settings are not reverted |
| Disable both logon options | Stops configured automatic launching for this GPU |

The logon task uses an elevated copy under `%ProgramFiles%\mVolt+`, scoped to
the user and adapter. A normal elevated launch refreshes an existing configured
task and executable. Resident tasks have no execution time limit; one-shot
startup application is bounded.

Recovery uses applied settings and participation, leaving pending edits alone.
The required driver interfaces must become available again; recovery cannot
guarantee restoration after every external driver reset. An incomplete startup
attempt can block further automatic writes. Review the profile and re-enable
startup explicitly after resolving the cause.

## Telemetry

Telemetry is read-only and does not apply dashboard edits. Availability depends
on the selected GPU and driver. Missing readings stay unavailable rather than
being presented as measured zeroes.

<details>
<summary><strong>Rails</strong> — rail voltages and local ADC sensors</summary>

Shows rail voltage readbacks and individual on-chip ADC sensors. REL, ALT, MAX
and OV lines describe voltage policy; individual ADC values describe sensor
readings. Differences can reflect sensor location, calibration, voltage drop
and sampling time.

The highlighted ADC is the selected largest current deviation. Its calculated
delta is a local voltage comparison, not a hotspot temperature. Fuse/gain fields
are calibration information, not tuning targets.

</details>

<details>
<summary><strong>Clocks</strong> — firmware history and measured clock domains</summary>

History graphs show programmed firmware clock samples, roughly 20 ms apart where
available. Separate measured-clock rows show current domain measurements.
Programmed clock history is not a measurement of effective work completed.

Hover a graph line to see the nearest recorded sample's MHz and time relative
to the latest sample. Hover works while monitoring is paused. Gaps remain gaps;
the graph does not invent values across a failed read or reset.

**Read-only domain / Unconfirmed** identifies domains whose interpretation is
not fully confirmed. A readable domain is not automatically an adjustable one.

</details>

<details>
<summary><strong>Power</strong> — limits, measured channels and energy</summary>

**Requested limit** is the requested board budget. **Enforced limit** is the
driver's reported active enforcement value. **Default limit** is the reference
for 100%. Enforcement can lag a request or reflect another constraint.

Channel cards show reported watts, amps and volts. They can describe different
points in the same power path, so do not add all cards together as independent
loads. Channel/type suffixes distinguish repeated rail names. Unknown rail IDs
remain explicit.

Session energy counts observed energy during this monitoring session. It is not
a persistent lifetime energy meter.

</details>

<details>
<summary><strong>P-States</strong> — configured performance-state clocks</summary>

Shows the driver's configured clock ranges for its performance states and marks
the active state. Current offsets are already included. These values describe
configuration, not instantaneous measured clocks; use Clocks for live measurements.

</details>

<details>
<summary><strong>Temperatures</strong> — GPU, hotspot and memory junction</summary>

Shows current GPU temperature, absolute GPU hotspot temperature and memory-junction
temperature where available. Hotspot is an absolute sensor temperature, not
hotspot minus GPU temperature. These readings do not provide a temperature-target
tuning slider.

The direct hotspot implementation is currently validated for the desktop RTX 5090
with driver 616.64. Other supported tuning features do not imply that this sensor
path is available on another card or driver.

</details>

<details>
<summary><strong>Boost limits</strong> — why boost is constrained</summary>

Shows reported boost reasons, a recent timeline, observed time spent limited and
supported domain/rail policy detail. A power or thermal reason can explain why a
higher clock request does not produce more frequency. Idle and reliability reasons
can be normal and do not alone establish instability.

Reasons can overlap. Time totals cover observed intervals; do not add percentages
as though they were exclusive portions of runtime. Policy frequencies are
constraints, separate from measured clocks. Unknown bits and domains remain
explicit. Detailed named-policy decoding has narrower support than general monitoring.

</details>

<details>
<summary><strong>Memory / PCIe</strong> — allocation pressure and bus activity</summary>

**Available VRAM** and **Used VRAM** describe allocation headroom. Evictions,
promotions and transferred-byte counters describe memory migration. They are
not memory-error counts or proof that a VRAM overclock is stable.

PCIe shows current/maximum link state and traffic in decimal **GB/s**. **TX**
means GPU to host; **RX** means host to GPU. These are PCIe transfer rates, not
internal VRAM bandwidth. Direct measured VRAM-bandwidth GB/s is not included
in this release.

Replay, error and recovery readings are counter changes. A lower idle link speed
is normal, and recovery transitions alone do not diagnose a failing link.
Examine errors and traffic together under comparable conditions.

</details>

Detailed monitoring runs at a nominal 250 ms cadence while Telemetry is open;
firmware can supply finer clock samples within those reads. Dashboard refresh
has its own configurable interval. The app retains bounded recent history in
memory; closing the process clears the monitoring session.

## Overview

![Tuning Overview](../assets/mvolt-overview.png)

Overview shows all settings in two columns, including stock values, unavailable
fields and values whose dashboard switches are disabled. Its header identifies
the GPU, recognized profile and VBIOS.

**Copy summary** copies current applied/readback settings. **Always on top** keeps
the window above other applications. Pending dashboard targets are not presented
as applied. Overview is a compact reference surface, not another tuning form.

## Settings and layout

### General

**Interface size** selects a preferred size from 50% to 200% in 25% steps. Display
DPI also affects sizing. The dashboard can temporarily fit to a narrower display
and restore your preference when it fits again; scrolling handles remaining overflow.

**Customize tiles…** restores hidden controls or hides ones you do not need.
**Manage profiles…** opens Profile Manager. Tray preferences are explained in
[Startup and tray](#startup-and-tray).

### Monitoring and RTSS

**Refresh interval** controls dashboard readback frequency, from 100 to 60,000 ms.
Enter it and click **Set interval**. Shorter intervals update more often and cost
more work; this does not change the separate firmware sample interval.

**Pause polling** freezes display monitoring at its last readings. An active fan
curve still performs the temperature checks it needs. **Pause when minimized or
in tray** pauses general monitoring unless a visible monitoring surface or overlay
needs it. **Toolbar polling button** controls whether the shortcut button is shown.

To use RTSS, run RivaTuner Statistics Server, enable **Show telemetry in the RTSS
overlay**, and select the metadata/rail/clock lines you want. RTSS must display
its overlay in the target application. The master option and individual lines
are off by default. This is not a built-in FPS measurement feature.

### Appearance and dashboard organization

Choose **mVolt+ Dark**, Graphite, Midnight or Violet, or customize the shared
colors. Changes update the app's windows and are saved for the selected GPU.
**Reset colors** restores the default palette without changing tuning.

Click a section heading to collapse or expand it. Use **Sections** to jump to
sections and manage tiles. Pinning moves a card to Quick tuning; hiding removes
it from view. **Hiding, collapsing and pinning do not change whether a setting
is applied or stored in a profile.** A hidden enabled card still participates.

## Advanced tuning

These options change the ranges mVolt+ permits you to edit. They do not establish
that higher values are appropriate for your hardware.

| Option | What enabling it changes | What disabling it can do |
| --- | --- | --- |
| **Extended offsets** | Expands per-domain voltage-demand editing from the ordinary −25…+50 mV window to the extended range | Caps out-of-range applied demands and pending targets back to the ordinary range through a transaction |
| **OCP unlock** | Allows output-current targets above the firmware default within the supported driver range | Restores above-default applied OCP limits to their defaults before closing the range |
| **XOC range** | Uses each rail's reported voltage-device maximum as the mode ceiling; without valid metadata, uses a 1.25 V fallback | Can apply a standard-mode cap to rails above the ordinary ceiling |

**Enabling these options alone does not apply new tuning values.** Disabling
them can write narrower limits and can fail if the driver cannot apply them;
the application reports the failure.

Standard voltage mode uses **1.15 V**, or a lower valid reported device maximum.
XOC follows the selected rail's reported device maximum where available. A device
range is not a measured voltage, a supported range for all policy offsets, or a
safe operating-voltage rating. The +250 mV upper REL/ALT/OV offset bounds remain
mVolt+ application limits. Apply checks current limits; moving driver baselines
mean this is not a permanent absolute-voltage lock.

**Debug report…** creates a local diagnostic report for investigating capability
and driver problems. It is not sent automatically. **Project / help** opens the
project's page.

## Compatibility and multiple GPUs

RTX 50 / Blackwell is the primary target. Earlier RTX 40 / Ada, RTX 30 / Ampere,
RTX 20 / Turing and GTX 10 / Pascal support is experimental and differs by feature.
Support for ordinary power and clock controls does not imply support for a
particular voltage rail or editor.

The app checks architecture information and probes the selected card. A missing
or rejected interface can leave one control unavailable while others continue
working. Direct hotspot and detailed boost-limit data have more specific
requirements. OV is also restricted to its supported GPU/driver path.

Select the intended adapter in the header and confirm its name and identity before
tuning. Monitoring and profiles then use that adapter. Settings applied to the
previous GPU remain in place. Profiles are scoped to the physical adapter and
VBIOS; a different BIOS or adapter can show a different profile set.

For scripts, prefer the stable identity from `--list-gpus` with `--gpu-id` over
relying only on an enumeration index. Missing or ambiguous identity is not
permission to tune a different card.

## Command line and automation

Run the read-only commands from PowerShell in the executable's directory:

```powershell
.\mVolt+.exe --version | Out-Host
.\mVolt+.exe --help | Out-Host
.\mVolt+.exe --list-gpus | Out-Host
.\mVolt+.exe --status | Out-Host
```

`--status` and `--list-gpus` return JSON. `| Out-Host` makes PowerShell wait for
console output from this Windows GUI executable. `--read-only` opens the
dashboard with writes disabled; it is different from a one-shot status query.

**Tuning options apply immediately and require administrator privileges.**
They do not create a dashboard draft. Unspecified controls are left untouched.

<details>
<summary><strong>Direct tuning options</strong></summary>

| Option | Argument and meaning |
| --- | --- |
| `--nvvdd-offsets` | `VMIN,REL,ALT[,OV]`, signed mV offsets for NVVDD |
| `--msvdd-offsets` | `VMIN,REL,ALT[,OV]`, signed mV offsets for MSVDD |
| `--core` / `--mem` | Core or memory offset in MHz |
| `--xbar-offset` / `--sys-offset` / `--video-offset` | Domain clock offset in MHz |
| `--core-vdemand` / `--xbar-vdemand` / `--sys-vdemand` / `--video-vdemand` | Domain voltage demand in mV |
| `--power` | Board power limit in percent of default |
| `--boost` | Voltage Boost percentage |
| `--msvdd-clock-ratio` | NVVDD/MSVDD clock propagation ratio; retains this historical option name |
| `--nvvdd-ocp` / `--msvdd-ocp` | Rail output-current limit in amps |
| `--boost-lock` | `on` or `off` |
| `--clock-range` | `MIN,MAX` in MHz, or `default` to release the lock |
| `--xoc` | Selects the extended voltage-ceiling mode for the request |
| `--profile` | Saved profile name or ID |
| `--gpu` | Adapter index; default 0 for CLI selection |
| `--gpu-id` | Stable adapter identity; takes precedence over the index |

Rail offset lists accept up to three decimal places in mV. Omitted OV is left
untouched; an explicit zero OV requests clearing the offset. The old absolute
`--nvvdd` and `--msvdd` options report a migration error instead of guessing a
conversion. Historical OCP aliases `--core-ocp` and `--mem-ocp` remain accepted
for compatibility but are omitted from help.

</details>

To apply an already reviewed profile, replace the name with one saved for the
selected GPU:

```powershell
.\mVolt+.exe --profile "Your saved profile" | Out-Host
```

Normal/full-snapshot behavior follows the saved profile. A one-shot CLI profile
can apply fixed fan duty or firmware auto, but refuses an active software fan
curve because it needs a resident process. Use the GUI/tray and configured logon
behavior for software curves. `--diagnostic` creates a local compatibility report.

## Files and logging

| Data | Where it lives / how it grows |
| --- | --- |
| Profiles and UI preferences | `%LOCALAPPDATA%\mVolt+\profiles\<VBIOS>-<adapter>.json`; up to 64 profiles per document |
| Profile backup | A previous atomic `.bak` copy, not an unlimited backup sequence |
| Startup/profile logs | Each bounded log is capped at 256 KiB; old content is cleared when the cap would be exceeded |
| Clock and boost-reason histories | Bounded in RAM, up to 60 seconds; discarded on process exit |
| Installed startup executable | Per-user/per-adapter directory under `%ProgramFiles%\mVolt+` |
| Diagnostic reports you explicitly create | Local files; keep or remove them as needed |

Normal monitoring does not write an endless CSV or disk history. User-created
reports, copied backups and retained executables can still accumulate; they are
separate from bounded monitoring history and logs. Reports are not uploaded
automatically.

The download is a single executable. Configuring elevated logon application
installs the protected startup copy described above.

## Troubleshooting

<details>
<summary><strong>The slider moves, but the GPU does not change</strong></summary>

Check whether the tile is Enabled and whether **Target** differs from **Applied**.
Moving a slider stages an edit. Apply it, then inspect readback and the relevant
live reading. A retained target can still be constrained by workload, power,
temperature, voltage limits or driver clock steps.

</details>

<details>
<summary><strong>A disabled tile still shows a non-default applied value</strong></summary>

Disabling stops the tile participating in Apply and recovery. It does not reset
a setting previously applied by mVolt+ or another tool. Use that card's Reset to
restore its default immediately. A normal saved profile with the tile disabled
also leaves its current value alone.

</details>

<details>
<summary><strong>REL and ALT changed, but measured voltage did not</strong></summary>

Inspect **Current effective maximum** and the other evaluated limits. A tighter
OV or another applicable policy can constrain the result. If MAX changed, the
workload may not need more voltage. Compare the same physical sensor under
comparable load; a voltage policy is not a measured rail value.

</details>

<details>
<summary><strong>The rail editor refuses a target that fitted earlier</strong></summary>

The driver baseline can move, especially after Voltage Boost or operating-state
changes. Apply validates against fresh readback. Review evaluated limits and
the active mode/device ceiling; an earlier editing range is not a promise that
the same request remains valid later.

</details>

<details>
<summary><strong>An old profile will not apply, or no longer resets a disabled control</strong></summary>

Enabled legacy absolute rail ranges need review and resaving. Normal profiles
now leave saved-disabled controls untouched; use an explicitly captured full
snapshot to restore those values too. Follow the [migration sequence](#upgrading-old-profiles)
and check saved switches before re-enabling automatic application.

</details>

<details>
<summary><strong>The profile selector says Custom after reopening</strong></summary>

mVolt+ identifies a profile when the relevant readback and saved participation
match. Another tuning tool, a driver reset, changed controls or an ambiguous
match can leave it as Custom. Check Overview against the profile preview.
The name alone is not an instruction to reapply or proof that nothing is tuned.

</details>

<details>
<summary><strong>Fans stop following temperature after Exit</strong></summary>

The custom curve runs in mVolt+, not GPU firmware. Keep the app in the tray for
temperature tracking. After a full exit, the last duty remains fixed. Use
**Reset to auto** before exiting if you want firmware-managed temperature response.

</details>

<details>
<summary><strong>Startup is delayed or the profile does not load</strong></summary>

Check the logon profile, saved control support and bounded startup log. Startup
waits for NVIDIA service/GPU readiness, not an open Control Panel window. Legacy
voltage ranges, an unsupported saved control or an incomplete previous attempt
can prevent application. Review the profile manually before re-enabling startup.

</details>

<details>
<summary><strong>A tile or sensor is missing</strong></summary>

Check **Settings → General → Customize tiles…**, collapsed sections and Quick
tuning pins, then confirm the selected GPU. An unavailable control usually means
the card or driver did not provide a supported interface. Different models in
one series can expose different capabilities.

</details>

<details>
<summary><strong>How to report a useful bug</strong></summary>

Include the mVolt+ version, GPU model, NVIDIA driver, VBIOS and exact steps.
Distinguish the edited Target, driver Applied value and Live measurement. For
rendering issues, include resolution, Windows display scaling, Interface size,
which window was active and a screenshot.

For profile problems, state normal versus full snapshot and which controls were
enabled when saved. If requested, generate a local **Debug report…** and share it
deliberately in your [issue report](https://github.com/b00nz/mVolt/issues).

</details>

[Back to the top](#mvolt-user-guide) · [Back to the project](../README.md)
