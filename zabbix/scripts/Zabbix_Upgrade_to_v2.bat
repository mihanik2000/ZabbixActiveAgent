Rem �⪫�砥� �뢮� ᠬ�� ������ �� �࠭
@echo off

Rem ����砥� ���७��� ��ࠡ��� ������
SetLocal
SetLocal EnableExtensions

Rem �।��������, �� �� Windows XP �ਯ� ����᪠���� ����������஬.
Rem ��� ����� ����� ��⥬ �� ����୮.

rem ����砥� ����� ��
ver | find "5.1."

rem Windows XP ?
If %errorlevel%==0  (
	rem �ய�᪠�� �஢��� �����᪨� �ࠢ
	GOTO SKIPADMIN
 )
 
SET HasAdminRights=0

FOR /F %%i IN ('WHOAMI /PRIV /NH') DO (
	IF "%%i"=="SeTakeOwnershipPrivilege" SET HasAdminRights=1
)

IF NOT %HasAdminRights%==1 (
	ECHO .
	ECHO ��� �ਯ� ����室��� ����᪠�� �� ����� �����������.
	ECHO .
	GOTO END
)

rem ����塞 �㦡� ����� v1

net stop "Zabbix Agent"
sc delete "Zabbix Agent"

rem ����塞 䠩�� ����� v1

del "C:\zabbix\*.exe" /q

rem �������㥬 ���䨣��樮��� 䠩�

powershell "(gc C:\zabbix\zabbix_agentd.win.conf) -replace '^EnableRemoteCommands=1$','AllowKey=system.run[*]' | sc C:\zabbix\zabbix_agentd2.win.conf"
powershell "(gc C:\zabbix\zabbix_agentd2.win.conf) -replace '^StartAgents=0$','#StartAgents=0' | sc C:\zabbix\zabbix_agentd2.win.conf"

rem ��⠭�������� ��⠭�������� ����� v2

If Exist "C:\Program Files (x86)" (
	copy /y C:\zabbix\bin_v2\win64\*.exe C:\zabbix\
) else ( 
	copy /y C:\zabbix\bin_v2\win32\*.exe C:\zabbix\
)

rem ��⠭�������� �������
c:\zabbix\zabbix_agent2.exe --config c:\zabbix\zabbix_agentd2.win.conf --install
net start "Zabbix Agent 2"

:CONTINUE
	ECHO .
	ECHO ���!
	
:END

TIMEOUT /T 5 /NOBREAK

EXIT /B
