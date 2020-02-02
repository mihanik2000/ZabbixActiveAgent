# -*- coding: utf-8 -*-
import os
import sys
import ctypes
import errno
import _winreg
import codecs
import wmi

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
# Функция удаления дубликатов из списка
# Вход: список
# Выход: список без дубликатов
#
def DuplicateRemoval ( InboundList ):
    OutboundList = []
    for i in InboundList:
        if i not in OutboundList:
            OutboundList.append(i)
    return OutboundList

# 
# Функция загрузки списка из файла
# Вход: путь к файлу со списком
# Выход: список
#
def ListLoad ( InboundFileName ):
    OutboundList = []
    
    # Если указанного файла не существует возвращаем пустой список
    if not os.path.exists( InboundFileName ):
        return OutboundList
    
    if not os.path.isfile( InboundFileName ):
        return OutboundList
    
    # Читаем файл построчно
    f = open( InboundFileName,'r')
    try:
        OutboundList = f.read().splitlines()
    except Exception:
        pass
    finally:
        f.close()

    return OutboundList

# 
# Функция сохранения списка в файл
# Вход: список, путь к файлу
# Выход: true - успешная запись, false - ошибка при записи
#
def ListSave ( OutboundList, OutboundFileName ):
    
    # Записываем файл построчно
   f = open( OutboundFileName,'w')
   try:
     for line in OutboundList:
           f.write(line + '\n')
   except Exception:
       MyResult = False
   else:
       MyResult = True
   finally:
      f.close()
    
   return MyResult

# 
# Функция получения списка установленных служб Windows
# Вход: нет
# Выход: список установленных служб Windows
#
def StopedServicesList():
    
   List = []
   
   c = wmi.WMI ()

   stopped_services = c.Win32_Service (StartMode="Auto", State="Stopped")
   
   for Service in stopped_services:
         List.append (Service.Name + ' - ' + Service.Caption + ' - ' + Service.State)

   stopped_services = c.Win32_Service (StartMode="Delayed-auto", State="Stopped")

   for Service in stopped_services:
         List.append (Service.Name + ' - ' + Service.Caption + ' - ' + Service.State)
   
   List.sort()
   
   return List

# 
# Функция получения списка установленных служб Windows имеющих способ запуска auto, но не работающих
# Вход: нет
# Выход: список установленных служб Windows имеющих способ запуска auto, но не работающих
#
def ServicesList():
    
   List = []
   
   c = wmi.WMI ()
   Services = c.Win32_Service ()

   for Service in Services:
         List.append (Service.Name + ' - ' + Service.Caption)
   
   List.sort()
   
   return List

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
   
   # Зададим имена файлам, которые будем использовать
   MySoftListFile=r'C:\Zabbix\scripts\soft_list\service_list.lst'
   MySoftDiffFile=r'C:\Zabbix\scripts\soft_list\service_diff.lst'
   MySoftStopedFile=r'C:\Zabbix\scripts\soft_list\service_stoped.lst'
   
   # Получаем список установленных служб Windows
   List = ServicesList()
   
   # Получаем прежний список из файла
   OldList = ListLoad ( MySoftListFile )
   
   # Ищем установленные/удалённые службы Windows
   DeletedList = []
   InstalledList = []
   
   # Получаем список свежеустановленных служб Windows
   for i in List:
       if i not in OldList:
            InstalledList.append(i)
   
   # Получаем список удалённых служб Windows
   for i in OldList:
       if i not in List:
            DeletedList.append(i)
   
   # Сохраняем список изменений в diff-файл построчно
   f = open( MySoftDiffFile,'w')
   try:
      f.write('Deleted:'+ '\n')
      for line in DeletedList:
         f.write(line + '\n')
      f.write('\n')
      f.write('Installed:'+ '\n')
      for line in InstalledList:
         f.write(line + '\n')
   except Exception:
      pass
   finally:
      f.close()
   
   # Сохраняем текущий список установленных служб Windows в файл
   if not ListSave (List, MySoftListFile):
      sys.exit ('Unable to save installed services list!!!')
   
   # Сохраняем текущий список установленных служб Windows  имеющих способ запуска auto, но не работающих в файл
   List = StopedServicesList()
   if not ListSave (List, MySoftStopedFile):
      sys.exit ('Unable to save stoped services list!!!')

if __name__ == "__main__":
    sys.exit(main())
