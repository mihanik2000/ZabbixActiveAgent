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
	SCHTASKS /Create /RU "NT AUTHORITY\SYSTEM" /SC HOURLY /ST 00:00:00 /TN "InstalledSoftware" /TR "C:\Python27\python.exe \"C:\zabbix\scripts\soft_list\programmlist.py\""
 ) else (
	rem НЕ Windows XP
	SCHTASKS /Create /RU "NT AUTHORITY\SYSTEM" /SC DAILY /ST 00:00 /RI 60 /DU 24:00 /TN "InstalledSoftware" /TR "C:\Python27\python.exe \"C:\zabbix\scripts\soft_list\programmlist.py\"" /RL HIGHEST /F
 )

cd "C:\Zabbix\scripts\soft_list"

C:\Python27\python.exe "C:\zabbix\scripts\soft_list\programmlist.py"

:END

EXIT /B
