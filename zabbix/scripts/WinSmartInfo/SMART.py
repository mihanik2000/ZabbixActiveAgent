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
      
#
# Функция получения STDOUT команды DOS
# Вход: командная строка
# Выход: список строк из STDOUT
#
def get_stdout( MyCmdLine ):
   MySTDOUT=[]
   try:
      MySTDOUT = os.popen(MyCmdLine).read().splitlines()
   except Exception:
      pass
   finally:
      return MySTDOUT

#
# Функция получения списка устройств /dev/sdХ
# Вход: список строк из STDOUT smartctl
# Выход: список устройств /dev/sdХ
#
def get_sdx_list( MyFullList ):
   MyList=[]

   for MyLine in MyFullList:
      if ('/dev/sd' in MyLine) and (' -d sat #' in MyLine):
         MyList.append(MyLine.split()[0])

   return MyList

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
   
   # Получаем список всех дисковых устройств
   MyFullAtaList = get_stdout('smartctl.exe --scan')

   # Получаем список устройств sdX
   MySDXList = get_sdx_list(MyFullAtaList)
   
   for MyLine in MySDXList:
      print MyLine

if __name__ == "__main__":
    sys.exit(main())
