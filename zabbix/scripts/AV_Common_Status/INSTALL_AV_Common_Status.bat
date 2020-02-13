@echo off

rem Скрипт за пускается на Windows XP?
ver | find "5.1."

If %errorlevel%==0  (
	rem Windows XP
	SCHTASKS /Create /RU "NT AUTHORITY\SYSTEM" /SC HOURLY /ST 09:00:00 /TN "AV_Common_Status_00" /TR "\"C:\zabbix\scripts\AV_Common_Status\AV_Common_Status.bat\""
	SCHTASKS /Create /RU "NT AUTHORITY\SYSTEM" /SC HOURLY /ST 09:15:00 /TN "AV_Common_Status_15" /TR "\"C:\zabbix\scripts\AV_Common_Status\AV_Common_Status.bat\""
	SCHTASKS /Create /RU "NT AUTHORITY\SYSTEM" /SC HOURLY /ST 09:30:00 /TN "AV_Common_Status_30" /TR "\"C:\zabbix\scripts\AV_Common_Status\AV_Common_Status.bat\""
	SCHTASKS /Create /RU "NT AUTHORITY\SYSTEM" /SC HOURLY /ST 09:45:00 /TN "AV_Common_Status_45" /TR "\"C:\zabbix\scripts\AV_Common_Status\AV_Common_Status.bat\""
 ) else (
	rem НЕ Windows XP
	SCHTASKS /Create /RU "NT AUTHORITY\SYSTEM" /SC DAILY /ST 09:00 /RI 10 /DU 12:00 /TN "AV_Common_Status" /TR "\"C:\zabbix\scripts\AV_Common_Status\AV_Common_Status.bat\"" /RL HIGHEST /F
 )

EXIT /B
