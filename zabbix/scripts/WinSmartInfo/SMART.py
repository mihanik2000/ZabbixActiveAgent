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
# Функция проверки наличия подстроки в любой из строк списка
# Вход: подстрока, список
# Выход: 0 - подстрока не встречается в списке, 1 - подстрока есть в списке
#
def in_list(MyStr, MyList):

   for Line in MyList:
      if MyStr in Line:
         return 1

   return 0

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

#
# Функция проверки включен ли SMART у диска
# Вход: имя диска в виде /dev/sdX
# Выход: 1 - SMART включен, 0 - SMART выключен
#
def smart_is_on(MyDisk):
   MyRes = get_stdout ('smartctl -i ' + MyDisk)
   if in_list('SMART support is: Disabled',MyRes)==1:
      return 0
   else:
      return 1

#
# Функция включения SMART у диска
# Вход: имя диска в виде /dev/sdX
# Выход: 0 - SMART включен успено, 1 - при включении SMART произошли ошибки
#
def smart_on(MyDisk):
   MyRes = get_stdout ('smartctl --smart=on --offlineauto=on --saveauto=on ' + MyDisk)
   if in_list('SMART Enabled',MyRes)==1:
      return 0
   else:
      return 1

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
   # Замечание!
   # Получаем весь список устройств, но в дальнейшем будем использовать только SATA
   # Это на будущее ;-)
   MyFullAtaList = get_stdout('smartctl.exe --scan')

   # Получаем список устройств /dev/sdX
   MySDXList = get_sdx_list(MyFullAtaList)
   
   # Если у какого-то из устройств SMART отключен, включаем.
   for MysdX in MySDXList:
      if smart_is_on(MysdX)==0 :
         smart_on(MysdX)

   # Получаем SMART для каждого устройства /dev/sdX и записываем в файлы
   for MysdX in MySDXList:
      get_stdout ( r'smartctl.exe -s on -T permissive --all ' + MysdX + r' > C:\zabbix\scripts\WinSmartInfo\WinSmart_' + MysdX.split('/')[2] + r'.txt')
      
if __name__ == "__main__":
    sys.exit(main())
