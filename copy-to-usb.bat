@echo off
setlocal EnableExtensions DisableDelayedExpansion
title Copy drivers to Windows USB
color 0B

echo ==================================================
echo   Copy ThinkPad drivers to your Windows USB
echo ==================================================
echo.

set "SRC=%~dp0"

if not exist "%SRC%drivers" (
    echo ERROR: Could not find the "drivers" folder next to this script.
    echo.
    pause
    exit /b 1
)

set "COUNT=0"
set "TARGET="
set "DRIVE_LETTERS=DEFGHIJKLMNOPQRSTUVWXYZ"
for %%D in (D E F G H I J K L M N O P Q R S T U V W X Y Z) do (
    if exist "%%D:\sources\boot.wim" if exist "%%D:\setup.exe" (
        set /a COUNT+=1 >nul
        set "TARGET=%%D"
        set "USB_%%D=1"
        echo   Found Windows USB: drive %%D:
    )
)
echo.

if "%COUNT%"=="0" (
    echo No Windows installation USB was found.
    echo.
    echo Insert the USB stick you use to reinstall Windows
    echo ^(the one that contains setup.exe and the "sources" folder^)
    echo and run this script again.
    echo.
    pause
    exit /b 1
)

if "%COUNT%"=="1" goto :copy_files

echo Multiple Windows USBs found.

:choose_usb
choice /C DEFGHIJKLMNOPQRSTUVWXYZ /N /M "Press the drive letter to use: "
set "CHOICE_RESULT=%errorlevel%"
if "%CHOICE_RESULT%"=="0" goto :selection_failed
set /a "CHOICE_INDEX=CHOICE_RESULT-1"
call set "TARGET=%%DRIVE_LETTERS:~%CHOICE_INDEX%,1%%"
if not defined USB_%TARGET% goto :invalid_usb

:copy_files
if not exist "%TARGET%:\sources\boot.wim" goto :usb_unavailable
if not exist "%TARGET%:\setup.exe" goto :usb_unavailable

set "COPY_FAILED=0"
echo.
echo Copying drivers to %TARGET%:\drivers ...
xcopy "%SRC%drivers" "%TARGET%:\drivers\" /E /I /Y /Q >nul
if errorlevel 1 (
    echo ERROR: Failed to copy the driver files.
    set "COPY_FAILED=1"
)

copy /Y "%SRC%install-drivers.bat" "%TARGET%:\" >nul
if errorlevel 1 (
    echo ERROR: Failed to copy install-drivers.bat.
    set "COPY_FAILED=1"
)

copy /Y "%SRC%README.md" "%TARGET%:\" >nul
if errorlevel 1 (
    echo ERROR: Failed to copy README.md.
    set "COPY_FAILED=1"
)

if "%COPY_FAILED%"=="1" goto :copy_failed

echo.
echo ==================================================
echo   DONE!
echo.
echo   The drivers are now on the USB ^(%TARGET%:\drivers^).
echo   After reinstalling Windows: open the USB and
echo   double-click "install-drivers.bat".
echo ==================================================
echo.
pause
exit /b 0

:invalid_usb
echo.
echo Drive %TARGET%: is not one of the Windows USBs listed above.
echo.
goto :choose_usb

:selection_failed
echo.
echo ERROR: Could not read the selected drive.
echo.
pause
exit /b 1

:usb_unavailable
echo.
echo ERROR: The selected Windows USB is no longer available.
echo.
pause
exit /b 1

:copy_failed
echo.
echo One or more files could not be copied.
echo.
pause
exit /b 1
