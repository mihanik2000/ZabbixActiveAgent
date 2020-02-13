@echo off

rem Скрипт за пускается на Windows XP?
ver | find "5.1."

If %errorlevel%==0  (
	rem Windows XP
	SCHTASKS /Create /RU "NT AUTHORITY\SYSTEM" /SC HOURLY /ST 09:00:00 /TN "RAID_Status" /TR "\"C:\zabbix\scripts\RAID_Status\RAID_Status.bat\""
 ) else (
	rem НЕ Windows XP
	SCHTASKS /Create /RU "NT AUTHORITY\SYSTEM" /SC DAILY /ST 00:00 /RI 60 /DU 24:00 /TN "RAID_Status" /TR "\"C:\zabbix\scripts\RAID_Status\RAID_Status.bat\"" /RL HIGHEST /F
 )

EXIT /B

CALL C:\zabbix\scripts\RAID_Status\RAID_Status.bat

EXIT /B