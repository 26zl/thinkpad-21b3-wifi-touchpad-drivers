# ThinkPad 21B3 — WiFi & Touchpad Drivers

Offline WiFi and touchpad drivers for reinstalling Windows on Lenovo ThinkPad
machine type `21B3`.

This repository is intended for the reinstallation process and initial setup before
Windows Update is available. It is not intended for driver maintenance during normal
use; once Windows is running and online, Windows Update normally installs these
drivers automatically.

## What's included

| Component | Device | Driver |
|-----------|--------|--------|
| **WiFi** | Intel Wi-Fi 6 AX201 | `netwtw08.inf` |
| **Touchpad** | ELAN pointing device / trackpad | `epd.inf`, `etdhsa.inf`, `hideventfilter.inf` |
| **I2C controller** *(touchpad depends on this)* | Intel Serial IO I2C + GPIO | `ialpss2_i2c_adl.inf`, `ialpss2_gpio2_adl.inf` |

The Intel Serial IO I2C and GPIO drivers are required for the ELAN touchpad.

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
may require different drivers.

## How to use it

**Before reinstalling:**

1. Plug in the USB stick you use to reinstall Windows.
2. Double-click **`copy-to-usb.bat`**. It finds the Windows install USB automatically
   and copies the drivers and installer onto it.

**Reinstall Windows** from that USB as usual.

**After reinstalling:**

3. Plug the same USB stick back in.
4. Open the USB and double-click **`install-drivers.bat`** (approve the Administrator
   prompt). It installs every driver automatically via `pnputil`.
5. Restart Windows.

### Manual install (alternative)

From an elevated terminal, pointed at this folder:

```
pnputil /add-driver drivers\*.inf /subdirs /install
```

## Troubleshooting

- **Touchpad still unavailable after restarting?** Run `install-drivers.bat` again
  and restart Windows.
- **Install a single driver manually:** right-click the `.inf` inside its subfolder and
  choose *Install*.

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
