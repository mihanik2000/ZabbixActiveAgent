# -*- coding: utf-8 -*-

import ctypes
import os

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
# Функция загрузки списка из файла
# Вход: путь к файлу со списком
# Выход: список
#
def FileToList ( InboundFileName ):
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
def ListToFile ( InboundList, InboundFileName ):
    
    # Записываем файл построчно
   f = open( OutboundFileName,'w')
   try:
     for line in InboundList:
           f.write(line + '\n')
   except Exception:
       MyResult = False
   else:
       MyResult = True
   finally:
      f.close()

   return MyResult

# 
# Функция удаления дубликатов из списка
# Вход: список
# Выход: список без дубликатов
#
def DeleteDuplicates ( InboundList ):
    OutboundList = []
    for i in InboundList:
        if i not in OutboundList:
            OutboundList.append(i)

    return OutboundList

