@echo off
setlocal EnableExtensions DisableDelayedExpansion

powershell.exe -NoProfile -Command "if (([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) { exit 0 } else { exit 1 }" >nul 2>&1
if not errorlevel 1 goto :elevated

set "ELEVATE_SCRIPT=%~f0"
powershell.exe -NoProfile -Command "try { Start-Process -FilePath $env:ELEVATE_SCRIPT -Verb RunAs -ErrorAction Stop; exit 0 } catch { exit 1 }" >nul 2>&1
if errorlevel 1 goto :elevation_failed
exit /b 0

:elevation_failed
echo ERROR: Administrator access was not granted.
echo.
pause
exit /b 1

:elevated
title Install WiFi and touchpad drivers
color 0A
set "DIR=%~dp0"

echo ==================================================
echo   Installing WiFi, touchpad and I2C drivers
echo   Lenovo ThinkPad (machine type 21B3)
echo ==================================================
echo.

if not exist "%DIR%drivers" (
    echo ERROR: Could not find the "drivers" folder next to this script.
    echo Make sure both this script and the "drivers" folder are present.
    echo.
    pause
    exit /b 1
)

echo Installing... this takes about a minute.
echo.
pnputil /add-driver "%DIR%drivers\*.inf" /subdirs /install
if errorlevel 1 goto :install_failed

echo.
echo ==================================================
echo   DONE!
echo.
echo   Restart the PC so WiFi and the touchpad start working.
echo   If the touchpad is still dead, run this script once
echo   more and reboot again.
echo ==================================================
echo.
pause
exit /b 0

:install_failed
echo.
echo ==================================================
echo   ERROR: One or more drivers could not be installed.
echo.
echo   Review the pnputil output above for details.
echo ==================================================
echo.
pause
exit /b 1
