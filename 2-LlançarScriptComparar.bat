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


REM incremento la mida virtual de la pantalla cmd
powershell -command "$pshost = Get-Host;$pswindow = $pshost.UI.RawUI;$newsize = $pswindow.BufferSize;$newsize.width = 800;$pswindow.buffersize = $newsize;"

powershell -command ".\comparacio.ps1 %PENULTIM% %ULTIM%" > resultatCompara.txt

start resultatCompara.txt


pause
