Rem �⪫�砥� �뢮� ᠬ�� ������ �� ��࠭
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

rem ����稬 ०�� �����ய�⠭�� "��᮪�� �ந�����⥫쭮���"
powercfg /setactive 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c	

:SKIPADMIN

rem ����訬 �⢥��� �� ping 
netsh firewall set icmpsetting 8

rem ࠧ�蠥� �室�騥 ������ �� �ࢥ�
netsh advfirewall firewall add rule name="zabbix_in" protocol="TCP" localport=10050 action=allow dir=IN
netsh firewall set portopening tcp 10050 zabbix_in enable

If Exist "C:\Program Files (x86)" (
	copy /y C:\zabbix\bin\win64\*.exe C:\zabbix\
	)
else(
	copy /y C:\zabbix\bin\win32\*.exe C:\zabbix\
)

rem ��⠭�������� �������
c:/zabbix/zabbix_agentd.exe --config c:/zabbix/zabbix_agentd.win.conf --install
net start "Zabbix Agent"

:CONTINUE
	ECHO .
	ECHO ���!
	
:END

EXIT /B
