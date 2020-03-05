# -*- coding: utf-8 -*-
import os
import sys
import ctypes
import errno
import _winreg
import codecs

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
# Функция получения списка установленных программ
# Вход: нет
# Выход: список установленных программ
#
def ProgramList():
    
    # Определим разрядность системы
    try:
        os.environ["PROGRAMFILES(X86)"]
        proc_arch = 64
    except:
        proc_arch = 32
    
    # Зададим режимы просмотра реестра
    if proc_arch == 32:
        arch_keys = []
    elif proc_arch == 64:
        arch_keys = [ _winreg.KEY_WOW64_32KEY, _winreg.KEY_WOW64_64KEY ]
    
    # Зададим ветки реестра, где нужно искать информацию об установленных программах
    keys = [ r'hklm\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall',
             r'hklm\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall',
             r'hkcu\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall']
    
    List = []
    
    for arch_key in arch_keys:
        for MyKey in keys:
            # ветки hkcu\...\Uninstall может не быть. Предусмотрим вероятность срабатывания исключения
            try:
               if 'hkcu' not in MyKey:
                  key = _winreg.OpenKey(_winreg.HKEY_LOCAL_MACHINE, MyKey[5:], 0, _winreg.KEY_READ | arch_key)
               else:
                  key = _winreg.OpenKey(_winreg.HKEY_CURRENT_USER, MyKey[5:], 0, _winreg.KEY_READ | arch_key)
            except Exception:
               pass
            else:
               for i in xrange(0, _winreg.QueryInfoKey(key)[0]):
                   skey_name = _winreg.EnumKey(key, i)
                   skey = _winreg.OpenKey(key, skey_name)
                   try:
                       List.append ( _winreg.QueryValueEx(skey, 'DisplayName')[0] )
                   except OSError as e:
                       if e.errno == errno.ENOENT:
                           # DisplayName не существует в этом разделе
                           pass
                   finally:
                       skey.Close()
    
    List.sort()
    NewList = DuplicateRemoval (List)
    return NewList

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
   MySoftListFile=r'C:\Zabbix\scripts\soft_list\soft_list.lst'
   MySoftDiffFile=r'C:\Zabbix\scripts\soft_list\soft_diff.lst'
   
   # Получаем список установленных программ
   List = ProgramList()
   
   # Получаем прежний список из файла
   OldList = ListLoad ( MySoftListFile )
   
   # Ищем установленные/удалённые программы
   DeletedList = []
   InstalledList = []
   
   # Получаем список свежеустановленных программ
   for i in List:
       if i not in OldList:
            InstalledList.append(i)
   
   # Получаем список удалённых программ
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
   
   # Сохраняем текущий список установленных программ в файл
   if not ListSave (List, MySoftListFile):
      sys.exit ('Unable to save installed program list!!!')

if __name__ == "__main__":
    sys.exit(main())
