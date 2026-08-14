# mVolt+

Windows tuning utility for Blackwell GPUs.

## Download

Download the latest `mVolt+.exe` from [GitHub Releases](../../releases/latest) 
or click here: [mVolt+.exe](https://github.com/b00nz/mVolt/releases/download/v0.31/mVolt+.exe)

Current release: **0.31**

## Features

- NVVDD/MSVDD minimum and maximum voltage control
- XBAR clock control
- Core and memory clock offsets, power limit and Voltage Boost
- V/F curve editing with regional offsets and flattening
- Named tuning profiles with full-setting restore and optional automatic
  application at Windows logon
- Live rail, ADC and P-state telemetry

## Compatibility

Tested on GeForce RTX 5090, RTX 5080, and RTX 5070 Ti.

## Screenshots

![mVolt+ dashboard](assets/mvolt-dashboard.png)

![mVolt+ V/F curve editor](assets/mvolt-vf-curve-editor.png)

![mVolt+ profile manager](assets/mvolt-profiles.png)

Administrator privileges are required. Hardware support varies by GPU,
driver, and VBIOS. GPU tuning can cause crashes or hardware damage; use it
at your own risk.

mVolt+ is not affiliated with or endorsed by any GPU manufacturer.

## Credits

- [Loong0x00](https://github.com/Loong0x00) for discovering the XBAR clock
  control.
