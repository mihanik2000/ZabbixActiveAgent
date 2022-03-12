Rem Отключаем вывод самих команд на экран
@echo off

Rem Включаем расширенную обработку команд
SetLocal
SetLocal EnableExtensions

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
	ECHO Этот скрипт необходимо запускать от имени администратора.
	ECHO .
	GOTO END
)

rem Удаляем службу агента v1

net stop "Zabbix Agent"
sc delete "Zabbix Agent"

rem Удаляем файлы агента v1

del "C:\zabbix\*.exe" /q

rem Модифицируем конфигурационный файл

powershell "(gc C:\zabbix\zabbix_agentd.win.conf) -replace '^EnableRemoteCommands=1$','AllowKey=system.run[*]' | sc C:\zabbix\zabbix_agentd2.win.conf"
powershell "(gc C:\zabbix\zabbix_agentd2.win.conf) -replace '^StartAgents=0$','#StartAgents=0' | sc C:\zabbix\zabbix_agentd2.win.conf"

rem Устанавливаем устанавливаем агента v2

If Exist "C:\Program Files (x86)" (
	copy /y C:\zabbix\bin_v2\win64\*.exe C:\zabbix\
) else ( 
	copy /y C:\zabbix\bin_v2\win32\*.exe C:\zabbix\
)

rem Устанавливаем заббикс
c:\zabbix\zabbix_agent2.exe --config c:\zabbix\zabbix_agentd2.win.conf --install
net start "Zabbix Agent 2"

:CONTINUE
	ECHO .
	ECHO Всё!
	
:END

TIMEOUT /T 5 /NOBREAK

EXIT /B
