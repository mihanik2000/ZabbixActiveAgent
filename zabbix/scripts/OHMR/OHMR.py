# -*- coding: utf-8 -*-

import os
import sys
import ctypes

#
# Функция проверки наличия прав администратора
# Вход: нет
# Выход: true - есть права администратора,
#        false - нет прав администратора
#
def is_admin():
    try:
        return ctypes.windll.shell32.IsUserAnAdmin()
    except:
        return False

################################################################################
#   Начало программы
################################################################################
def main(argv=None):

   # Проверяем наличие прав админа.
   if not is_admin ():
      sys.exit ('Not enough permissions to run the script !!!')
   
   # Устанавливаем кодировку по умолчанию.
   reload(sys)
   sys.setdefaultencoding('utf8')

   # Получаем результат работы OHMR
   OHMR = []
   OHMR = os.popen("C:\zabbix\scripts\OHMR\OpenHardwareMonitorReport.exe").read().splitlines()

   # Высчитываем температуру 0-го процесора
   
   n0 = 0
   sum0 = 0
   
   for i in OHMR:
      if (':' in i) and ('(/intelcpu/0/temperature/' in i):
         tmp = i.split()
         print tmp
         

if __name__ == "__main__":
    sys.exit(main())
