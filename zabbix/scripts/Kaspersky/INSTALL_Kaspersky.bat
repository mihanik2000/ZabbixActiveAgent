@echo off

rem Скрипт за пускается на Windows XP?
ver | find "5.1."

If %errorlevel%==0  (
	rem Windows XP
	SCHTASKS /Create /RU "NT AUTHORITY\SYSTEM" /SC HOURLY /ST 08:00:00 /TN "KasperskyStatus_00" /TR "\"C:\zabbix\scripts\Kaspersky\KasperskyStatus.bat\""
	SCHTASKS /Create /RU "NT AUTHORITY\SYSTEM" /SC HOURLY /ST 08:15:00 /TN "KasperskyStatus_15" /TR "\"C:\zabbix\scripts\Kaspersky\KasperskyStatus.bat\""
	SCHTASKS /Create /RU "NT AUTHORITY\SYSTEM" /SC HOURLY /ST 08:30:00 /TN "KasperskyStatus_30" /TR "\"C:\zabbix\scripts\Kaspersky\KasperskyStatus.bat\""
	SCHTASKS /Create /RU "NT AUTHORITY\SYSTEM" /SC HOURLY /ST 08:45:00 /TN "KasperskyStatus_45" /TR "\"C:\zabbix\scripts\Kaspersky\KasperskyStatus.bat\""
 ) else (
	rem НЕ Windows XP
	SCHTASKS /Create /RU "NT AUTHORITY\SYSTEM" /SC DAILY /ST 08:00 /RI 15 /DU 12:00 /TN "KasperskyStatus" /TR "\"C:\zabbix\scripts\Kaspersky\KasperskyStatus.bat\"" /RL HIGHEST /F
 )

EXIT /B













