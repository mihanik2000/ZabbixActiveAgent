@echo off

rem "C:\Program Files\smartmontools\bin\smartctl.exe" -s on -T permissive -d sat --all %systemdrive% > C:\zabbix\scripts\WinSmartInfo\WinSmartInfo_sda.txt

"C:\Program Files\smartmontools\bin\smartctl.exe" -s on -T permissive --all /dev/sda > C:\zabbix\scripts\WinSmartInfo\WinSmartInfo_sda.txt

exit /b
