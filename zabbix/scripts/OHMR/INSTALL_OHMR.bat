@echo off

Rem Предполагаем, что на Windows XP скрипт запускается администратором.
Rem Для более старших систем это неверно.

rem Получаем версию ОС
ver | find "5.1."

rem Windows XP ?
If %errorlevel%==0  (
	rem Пропускаем проверку админских прав
	GOTO SKIPADMIN
 )
 
SET HasAdminRights=0

FOR /F %%i IN ('WHOAMI /PRIV /NH') DO (
	IF "%%i"=="SeTakeOwnershipPrivilege" SET HasAdminRights=1
)

IF NOT %HasAdminRights%==1 (
	ECHO .
	ECHO Not enough permissions to run the script !!!
	ECHO .
	GOTO END
)

:SKIPADMIN

rem Получаем версию ОС
rem Windows XP ?

ver | find "5.1."

If %errorlevel%==0  (
rem Windows XP
	SCHTASKS /Create /RU "NT AUTHORITY\SYSTEM" /SC HOURLY /ST 00:00:00 /TN "OHMR0" /TR "C:\zabbix\scripts\OHMR\ohmr.bat"
	SCHTASKS /Create /RU "NT AUTHORITY\SYSTEM" /SC HOURLY /ST 00:10:00 /TN "OHMR1" /TR "C:\zabbix\scripts\OHMR\ohmr.bat"
	SCHTASKS /Create /RU "NT AUTHORITY\SYSTEM" /SC HOURLY /ST 00:20:00 /TN "OHMR2" /TR "C:\zabbix\scripts\OHMR\ohmr.bat"
	SCHTASKS /Create /RU "NT AUTHORITY\SYSTEM" /SC HOURLY /ST 00:30:00 /TN "OHMR3" /TR "C:\zabbix\scripts\OHMR\ohmr.bat"
	SCHTASKS /Create /RU "NT AUTHORITY\SYSTEM" /SC HOURLY /ST 00:40:00 /TN "OHMR4" /TR "C:\zabbix\scripts\OHMR\ohmr.bat"
	SCHTASKS /Create /RU "NT AUTHORITY\SYSTEM" /SC HOURLY /ST 00:50:00 /TN "OHMR5" /TR "C:\zabbix\scripts\OHMR\ohmr.bat"
 ) else (
rem НЕ Windows XP
	SCHTASKS /Create /RU "NT AUTHORITY\SYSTEM" /SC DAILY /ST 00:00 /RI 10 /DU 24:00 /TN "OHMR" /TR "C:\zabbix\scripts\OHMR\ohmr.bat" /RL HIGHEST /F
 )

del /f /q C:\zabbix\scripts\OHMR\cpu0.txt
del /f /q C:\zabbix\scripts\OHMR\cpu1.txt
 
CALL C:\zabbix\scripts\OHMR\ohmr.bat

:END

EXIT /B
