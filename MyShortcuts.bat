taskkill /F /IM "MyShortcuts.exe"
start "MyShortcuts" "MyShortcuts.exe"

if exist "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Startup\%~nx0" EXIT
::Add link to autostart if hasn't been there already

@ECHO OFF
setlocal EnableDelayedExpansion

NET FILE 1>NUL 2>NUL
if '%errorlevel%' == '0' ( goto START ) else ( goto getPrivileges ) 

:getPrivileges
if '%1'=='ELEV' ( goto START )

set "linkDestination=C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Startup\%~nx0"
set "linkTargets=%~f0"

::Add quotes to the batch path, if needed
set "script=%0"
set script=%script:"=%
IF '%0'=='!script!' ( GOTO PathQuotesDone )
    set "linkDestination=""%linkDestination%"""
:PathQuotesDone

::Add quotes to the arguments, if needed.
:ArgLoop
IF '%1'=='' ( GOTO EndArgLoop ) else ( GOTO AddArg )
    :AddArg
    set "arg=%1"
    set arg=%arg:"=%
    IF '%1'=='!arg!' ( GOTO NoQuotes )
        set "linkTargets=%linkTargets% "%1""
        GOTO QuotesDone
        :NoQuotes
        set "linkTargets=%linkTargets% %1"
    :QuotesDone
    shift
    GOTO ArgLoop
:EndArgLoop

::Create and run the vb script to elevate the batch file
ECHO Set UAC = CreateObject^("Shell.Application"^) > "%temp%\OEgetPrivileges.vbs"
ECHO UAC.ShellExecute "cmd", "/c mklink !linkDestination! !linkTargets!", "", "runas", 1 >> "%temp%\OEgetPrivileges.vbs"
"%temp%\OEgetPrivileges.vbs" 
exit /B

:START
::Remove the elevation tag and set the correct working directory
IF '%1'=='ELEV' ( shift /1 )
cd /d %~dp0

EXIT