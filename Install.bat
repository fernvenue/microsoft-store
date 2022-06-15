@ECHO OFF&PUSHD %~DP0 &TITLE Microsoft Store for Windows LTSC
setlocal enabledelayedexpansion
mode con cols=60 lines=30
color 87
cd.>%WINDIR%\GetAdmin
if exist %WINDIR%\GetAdmin (del /f /q "%WINDIR%\GetAdmin") else (
echo CreateObject^("Shell.Application"^).ShellExecute "%~s0", "%*", "", "runas", 1 >> "%temp%\Admin.vbs"
"%temp%\Admin.vbs"
del /s /q "%temp%\Admin.vbs"
exit /b 2)
cls
if not exist "%ProgramFiles%\WindowsApps" goto error_exit
if not exist "%WINDIR%\SysWOW64" goto error_exit
TAKEOWN /F "%ProgramFiles%\WindowsApps" /A >NUL
ICACLS "%ProgramFiles%\WindowsApps" /grant:r "Administrators:F" /Q >NUL
ICACLS "%ProgramFiles%\WindowsApps" /grant:r "All Application Packages:RX" /setintegritylevel L:I /inheritance:e /Q >NUL
XCOPY /Q/Y/E/H/O "%~DP0WindowsApps\*" "%ProgramFiles%\WindowsApps\" >NUL 2>NUL
ICACLS "%ProgramFiles%\WindowsApps" /setowner "NT Service\TrustedInstaller" /Q >NUL 
ICACLS "%ProgramFiles%\WindowsApps" /grant:r "Administrators:RX" /Q >NUL 
ICACLS "%ProgramFiles%\WindowsApps" /reset >NUL
FOR /F "delims=" %%i IN (Package.txt) DO (PowerShell -Command "& {Add-AppXPackage -Path '%ProgramFiles%\WindowsApps\%%i\AppXManifest.xml' -Register -DisableDevelopmentMode}")
:success_exit
ECHO.
ECHO Install finish.
TIMEOUT /T 3 /NOBREAK >NUL 2>NUL
exit 0
:error_exit
ECHO.
ECHO Not support this device.
TIMEOUT /T 5 /NOBREAK >NUL 2>NUL
exit 1
Get-AppxPackage Microsoft.XboxIdentityProvider |Remove-AppxPackage
Get-AppxPackage Microsoft.StorePurchaseApp |Remove-AppxPackage
Get-AppxPackage Microsoft.WindowsStore |Remove-AppxPackage
Get-AppxPackage Microsoft.Advertising.Xaml |Remove-AppxPackage
Get-AppxPackage Microsoft.VCLibs.140.00 |Remove-AppxPackage
Get-AppxPackage Microsoft.NET.Native.Framework.1.6 |Remove-AppxPackage
Get-AppxPackage Microsoft.NET.Native.Runtime.1.6 |Remove-AppxPackage
