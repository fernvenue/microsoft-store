@echo off
title Uninstall Microsoft Store for LTSC
color 1f
setlocal enabledelayedexpansion

echo [1/4] Running as administrator...
cd.>%WINDIR%\GetAdmin
if exist %WINDIR%\GetAdmin (del /f /q "%WINDIR%\GetAdmin") else (
  echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\admin.vbs"
  echo UAC.ShellExecute "%~s0", "", "", "runas", 1 >> "%temp%\admin.vbs"
  "%temp%\admin.vbs"
  del "%temp%\admin.vbs"
  exit /b
)

echo [2/4] Removing Microsoft Store related AppX packages...
for %%A in (
  Microsoft.WindowsStore
  Microsoft.StorePurchaseApp
  Microsoft.XboxIdentityProvider
  Microsoft.Advertising.Xaml
  Microsoft.VCLibs.140.00
  Microsoft.NET.Native.Framework.1.6
  Microsoft.NET.Native.Runtime.1.6
) do (
  powershell -command "Get-AppxPackage -AllUsers -Name %%A | Remove-AppxPackage" >nul 2>&1
)

echo [3/4] Deleting copied WindowsApps folders...
set "WinAppsPath=%ProgramFiles%\WindowsApps"
takeown /f "%WinAppsPath%" /r /d y >nul
icacls "%WinAppsPath%" /grant:r Administrators:F /t /c /q >nul

for /d %%D in (
  Microsoft.WindowsStore_*
  Microsoft.StorePurchaseApp_*
  Microsoft.XboxIdentityProvider_*
  Microsoft.Advertising.Xaml_*
  Microsoft.VCLibs.140.00_*
  Microsoft.NET.Native.Framework.1.6_*
  Microsoft.NET.Native.Runtime.1.6_*
) do (
  rd /s /q "%WinAppsPath%\%%D"
)

echo [4/4] Restoring permissions of WindowsApps folder...
icacls "%WinAppsPath%" /setowner "NT SERVICE\TrustedInstaller" >nul
icacls "%WinAppsPath%" /reset /t /c /q >nul

echo.
echo Uninstallation complete. Press any key to exit...
pause >nul
exit
