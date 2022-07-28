 @ECHO off
set FECHA=%date:~-4,4%-%date:~-7,2%-%date:~-10,2%_%time:~0,2%h%time:~3,2%m%time:~6,2%s
set FECHA=%FECHA: =0%
echo %FECHA%
 
powershell -command ".\scriptMida.ps1 -Directory c:\ -level 6  -HiddeErrors" > %FECHA%.txt
