# ThinkPad 21B3 — WiFi & Touchpad Drivers

Offline WiFi and touchpad (trackpad) drivers for the **Lenovo ThinkPad, machine type `21B3`**
(Intel 12th Gen "Alder Lake" platform, Intel Wi-Fi 6 AX201, ELAN touchpad).

## Why this exists

After a clean reinstall of Windows, this laptop boots with **no WiFi and a dead
touchpad**, because Windows does not ship the required drivers in the box. Without
WiFi you can't download the drivers, and without a touchpad you can barely use the
machine — a classic chicken-and-egg problem.

This repo contains exactly those drivers so you can drop them on the same USB stick
you install Windows from, and get connectivity and the touchpad back in one step.

> The touchpad is an **I2C HID** device. It depends on the **Intel Serial IO I2C +
> GPIO** controllers. If you only copy the ELAN touchpad driver but forget the I2C
> controller, the touchpad still won't work — so both are included here.

## What's included

| Component | Device | Driver |
|-----------|--------|--------|
| **WiFi** | Intel Wi-Fi 6 AX201 | `netwtw08.inf` |
| **Touchpad** | ELAN pointing device / trackpad | `epd.inf`, `etdhsa.inf`, `hideventfilter.inf` |
| **I2C controller** *(touchpad depends on this)* | Intel Serial IO I2C + GPIO | `ialpss2_i2c_adl.inf`, `ialpss2_gpio2_adl.inf` |

All packages are the original, vendor-signed drivers (verified `Valid` signature).

```
drivers/
├── wifi-intel-ax201/     Intel Wi-Fi 6 AX201
├── touchpad-elan/        ELAN touchpad + HID filter
└── i2c-serial-io/        Intel Serial IO I2C + GPIO (required for touchpad)
```

## Is this the right laptop for me?

Check your machine type — it must be `21B3`:

```powershell
Get-CimInstance Win32_ComputerSystem | Select-Object Manufacturer, Model
```

The **first four characters** of the model are the machine type. Other configurations
that use the same **Intel AX201** WiFi card and **ELAN I2C touchpad** will very likely
work too, but this set was captured from a `21B3` machine.

## How to use it

**Before reinstalling (while everything still works):**

1. Plug in the USB stick you use to reinstall Windows.
2. Double-click **`copy-to-usb.bat`**. It finds the Windows install USB automatically
   and copies the drivers (plus the installer) onto it.

**Reinstall Windows** from that USB as usual.

**After reinstalling:**

3. Plug the same USB stick back in.
4. Open the USB and double-click **`install-drivers.bat`** (approve the Administrator
   prompt). It installs every driver automatically via `pnputil`.
5. Restart. WiFi and the touchpad now work.

### Manual install (alternative)

From an elevated terminal, pointed at this folder:

```
pnputil /add-driver drivers\*.inf /subdirs /install
```

## Troubleshooting

- **Touchpad still dead after the first reboot?** Run `install-drivers.bat` once more
  and reboot again. The I2C controller driver sometimes has to be present *before* the
  touchpad driver binds — a second pass fixes it.
- **Install a single driver manually:** right-click the `.inf` inside its subfolder and
  choose *Install*.

## How these drivers were captured

They were exported from a working installation on the same model, which guarantees an
exact hardware match:

```powershell
dism /online /export-driver /destination:C:\exported-drivers
```

You can reproduce your own set the same way before wiping any Lenovo machine.

## License / disclaimer

The **scripts and documentation** in this repository are released under the
[MIT License](LICENSE).

The **driver packages** under `drivers/` are the property of their respective vendors
(Intel Corporation, ELAN Microelectronics, Lenovo) and are redistributed here for
convenience under their own license terms. This repository is an unofficial community
convenience mirror and is **not affiliated with or endorsed by Lenovo or Intel**. If in
doubt, download the drivers from the official
[Lenovo Support](https://support.lenovo.com) and
[Intel Download Center](https://www.intel.com/content/www/us/en/download-center/home.html)
pages.
