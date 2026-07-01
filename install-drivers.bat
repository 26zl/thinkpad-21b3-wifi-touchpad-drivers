@echo off
REM Self-elevate to Administrator
net session >nul 2>&1
if %errorlevel% neq 0 (
    powershell -Command "Start-Process -FilePath '%~f0' -Verb RunAs"
    exit /b
)

setlocal
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
