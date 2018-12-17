taskkill /F /IM "MyShortcuts.exe"
start "MyShortcuts" "MyShortcuts.exe"

if exist "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Startup\%~nx0" EXIT
::Add link to autostart if hasn't been there already

@ECHO OFF
setlocal EnableDelayedExpansion

set "linkDestination=""C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Startup\%~nx0"""
set "linkTarget=""%~f0"""
set "cd=cd ""%cd%"""

::Create and run the vb script to elevate the batch file
ECHO Set UAC = CreateObject^("Shell.Application"^) > "%temp%\OEgetPrivileges.vbs"
ECHO UAC.ShellExecute "cmd", "/c echo !cd! > !linkDestination! & echo !linkTarget! >> !linkDestination! >> !linkDestination!", "", "runas", 1 >> "%temp%\OEgetPrivileges.vbs"
"%temp%\OEgetPrivileges.vbs" 
EXIT