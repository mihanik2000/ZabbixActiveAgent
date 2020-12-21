@echo off

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

SCHTASKS /Create /RU "%COMPUTERNAME%\Администратор" /RP "AdminPass" /SC DAILY /ST 00:00 /RI 10 /DU 24:00 /TN "Get_Cluster_Info" /TR "C:\zabbix\scripts\Cluster1C\Get_Cluster_Info.bat" /RL HIGHEST /F

echo 0 > C:\zabbix\scripts\Cluster1C\LicensesCount.txt

:END

EXIT /B
