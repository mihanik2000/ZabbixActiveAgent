Rem Отключаем вывод самих команд на экран
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
	ECHO Этот скрипт необходимо запускать от имени администратора.
	ECHO .
	GOTO END
)

:SKIPADMIN

rem Добавляем утилиту certutil.exe в исключения брандмауера Windows
netsh advfirewall firewall del rule name="Certutil"
netsh firewall add allowedprogram "C:\Windows\System32\certutil.exe" Certutil
netsh advfirewall firewall add rule name="Certutil" dir=in action=allow program="C:\Windows\System32\certutil.exe"

rem ****************************************************************************************
rem Начинаем устанавливать все программы по очереди
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

rem Ассоциируем файлы .py с интерпретатором Python и настраиваем PATH
setx PATH "C:\Python27\;C:\Python27\Scripts;%Path%"
assoc .py=Python.File
ftype Python.File=C:\Python27\python.exe "%1" %*

rem Устанавливаем дополнительные модули
C:\Python27\Scripts\pip.exe install pywin32
C:\Python27\Scripts\pip.exe install WMI

ECHO .
ECHO Всё!
ECHO .
	
:END

PAUSE

EXIT /B