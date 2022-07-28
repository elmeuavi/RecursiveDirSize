@echo off
SETLOCAL EnableDelayedExpansion

set ULTIM=
set PENULTIM=

REM search for the last modified 2 txt files to compare them
for /F %%x in ('dir /B /O:D 20*.txt') do (
	rem echo %%x
	set PENULTIM=!ULTIM!
	set ULTIM=%%x
)


echo %ULTIM%
echo %PENULTIM%


powershell -command ".\comparacio.ps1 %PENULTIM% %ULTIM%"


pause
