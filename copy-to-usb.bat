@echo off
setlocal enabledelayedexpansion
title Copy drivers to Windows USB
color 0B

echo ==================================================
echo   Copy ThinkPad drivers to your Windows USB
echo ==================================================
echo.

set "SRC=%~dp0"
if "%SRC:~-1%"=="\" set "SRC=%SRC:~0,-1%"

if not exist "%SRC%\drivers" (
    echo ERROR: Could not find the "drivers" folder next to this script.
    echo.
    pause
    exit /b 1
)

set "COUNT=0"
for %%D in (D E F G H I J K L M N O P Q R S T U V W X Y Z) do (
    if exist "%%D:\sources\boot.wim" if exist "%%D:\setup.exe" (
        set /a COUNT+=1
        set "USB!COUNT!=%%D"
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

if "%COUNT%"=="1" (
    set "TARGET=!USB1!"
) else (
    echo Multiple Windows USBs found.
    set /p TARGET="Enter the drive letter to use ^(e.g. E^): "
)

echo.
echo Copying drivers to %TARGET%:\drivers ...
xcopy "%SRC%\drivers" "%TARGET%:\drivers\" /E /I /Y /Q >nul
copy /Y "%SRC%\install-drivers.bat" "%TARGET%:\" >nul
copy /Y "%SRC%\README.md" "%TARGET%:\" >nul

if errorlevel 1 (
    echo.
    echo Something went wrong during the copy.
) else (
    echo.
    echo ==================================================
    echo   DONE!
    echo.
    echo   The drivers are now on the USB ^(%TARGET%:\drivers^).
    echo   After reinstalling Windows: open the USB and
    echo   double-click "install-drivers.bat".
    echo ==================================================
)
echo.
pause
