@echo off

rem Скрипт за пускается на Windows XP?
ver | find "5.1."

If %errorlevel%==0  (
	rem Windows XP
	SCHTASKS /Create /RU "NT AUTHORITY\SYSTEM" /SC HOURLY /ST 00:00:00 /TN "OHMR" /TR "\"C:\Windows\System32\cscript.exe\" C:\Zabbix\scripts\OHMR\OHMR.vbs"
 ) else (
	rem НЕ Windows XP
	SCHTASKS /Create /RU "NT AUTHORITY\SYSTEM" /SC DAILY /ST 00:00 /RI 5 /DU 24:00 /TN "OHMR" /TR "\"C:\Windows\System32\cscript.exe\" C:\Zabbix\scripts\OHMR\OHMR.vbs" /RL HIGHEST /F
 )

del /f /q C:\zabbix\scripts\OHMR\cpu0.txt
del /f /q C:\zabbix\scripts\OHMR\cpu1.txt
 
CALL C:\zabbix\scripts\OHMR\ohmr.bat

EXIT
