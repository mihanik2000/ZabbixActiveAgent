Rem �⪫�砥� �뢮� ᠬ�� ������ �� �࠭
@echo off

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

:SKIPADMIN

rem ������塞 �⨫��� certutil.exe � �᪫�祭�� �࠭����� Windows
netsh advfirewall firewall del rule name="Certutil"
netsh firewall add allowedprogram "C:\Windows\System32\certutil.exe" Certutil
netsh advfirewall firewall add rule name="Certutil" dir=in action=allow program="C:\Windows\System32\certutil.exe"

rem ****************************************************************************************
rem ��稭��� ��⠭�������� �� �ணࠬ�� �� ��।�
rem ****************************************************************************************
mkdir C:\Windows\Temp\Mihanikus
cd C:\Windows\Temp\Mihanikus

ECHO .
ECHO Install curl
ECHO .
mkdir  "C:\Program Files\curl\"

If exist "%programfiles(x86)%" (
	certutil -urlcache -split -f "http://repo.mihanik.net/curl-7.65.1/win64/libcurl-x64.dll" "C:\Program Files\curl\libcurl-x64.dll"
	certutil -urlcache -split -f "http://repo.mihanik.net/curl-7.65.1/win64/curl.exe" "C:\Program Files\curl\curl.exe"
	certutil -urlcache -split -f "http://repo.mihanik.net/curl-7.65.1/win64/curl-ca-bundle.crt" "C:\Program Files\curl\curl-ca-bundle.crt"
 ) else (
	certutil -urlcache -split -f "http://repo.mihanik.net/curl-7.65.1/win32/libcurl.dll" "C:\Program Files\curl\libcurl.dll"
	certutil -urlcache -split -f "http://repo.mihanik.net/curl-7.65.1/win32/curl.exe" "C:\Program Files\curl\curl.exe"
	certutil -urlcache -split -f "http://repo.mihanik.net/curl-7.65.1/win32/curl-ca-bundle.crt" "C:\Program Files\curl\curl-ca-bundle.crt"
)

ECHO .
ECHO Install Python
ECHO .

 If exist "%programfiles(x86)%" (
		"C:\Program Files\curl\curl.exe" -o "C:\Windows\Temp\Mihanikus\python-2.7.17.amd64.msi" "http://repo.mihanik.net/python/python-2.7.17.amd64.msi"
		start /wait python-2.7.17.amd64.msi  /passive /norestart ALLUSERS=1 ADDLOCAL=ALL
	) else (
		"C:\Program Files\curl\curl.exe" -o "C:\Windows\Temp\Mihanikus\python-2.7.17.msi" "http://repo.mihanik.net/python/python-2.7.17.msi"
		start /wait python-2.7.17.msi /passive /norestart ALLUSERS=1 ADDLOCAL=ALL
	)

rem ���樨�㥬 䠩�� .py � �������஬ Python � ����ࠨ���� PATH
setx PATH "C:\Python27\;C:\Python27\Scripts;%Path%"
assoc .py=Python.File
ftype Python.File=C:\Python27\python.exe "%1" %*

rem ��⠭�������� �������⥫�� ���㫨
C:\Python27\Scripts\pip.exe install pywin32
C:\Python27\Scripts\pip.exe install WMI

ECHO .
ECHO ���!
ECHO .
	
:END

PAUSE

EXIT /B