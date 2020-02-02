@echo off

setlocal enabledelayedexpansion

rem Получим данные по 0-му процессору
set /a ssum=0
set /a n=0
set /a temper=0

for /F "usebackq tokens=1-10" %%a in (`C:\zabbix\scripts\OHMR\OpenHardwareMonitorReport.exe`) do (
		echo "%%a %%b %%c %%d %%e %%f %%g %%h %%i %%j" | findstr .*Core.*:.*\/0\/temperature>nul
		if  !errorlevel! == 0 (
			set /a ssum+=%%g
			set /a n+=1
		)
		)		

set /a temper=%ssum%/%n%

echo %temper%  > C:\zabbix\scripts\OHMR\cpu0.txt

rem Получим данные по 1-му процессору

set /a ssum=0
set /a n=0
set /a temper=0

for /F "usebackq tokens=1-10" %%a in (`C:\zabbix\scripts\OHMR\OpenHardwareMonitorReport.exe`) do (
		echo "%%a %%b %%c %%d %%e %%f %%g %%h %%i %%j" | findstr .*Core.*:.*\/1\/temperature>nul
		if  !errorlevel! == 0 (
			set /a ssum+=%%g
			set /a n+=1
		)
		)		
		
if %n% gtr 0 (
	set /a temper=!ssum!/!n!
	echo !temper! > C:\zabbix\scripts\OHMR\cpu1.txt 
)

exit /b
