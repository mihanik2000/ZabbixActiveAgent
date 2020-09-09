# -*- coding: UTF-8 -*-

#-------------------------------------------------------------------------------
# Name:        MyScript
# Purpose:
#
# Author:      mihanik
#
# Created:     05.09.2020
# Copyright:   (c) mihanik 2020
# Licence:     <your licence>
#-------------------------------------------------------------------------------

import os
import sys
import ctypes
import win32com.client
import urllib2

#import request

def Create_Log_Entry( MyList = 'APPLICATION', MyType = 'INFORMATION', MySource = 'eventcreate', MyID = 1, MyDef = 'Description not specified.' ):
    '''Cоздаёт событие в системном журнале

    Parameters
    ----------
    MyList : str
            Указывает имя журнала событий, в котором будет создано событие. Допустимые имена журналов — APPLICATION или SYSTEM.

    MyType : str
             Тип создаваемого события. Допустимые типы: SUCCESS, ERROR, WARNING, INFORMATION.

    MySource : str
               Источник для этого события (если не указан, по умолчанию используется "eventcreate").
               Допустимым источником является любая строка, представляющая приложение или компонент, создающий это событие.

    MyID : int
           Код события для этого события.
           Допустимым кодом события является любое число в диапазоне от 1 до 1000.

    MyDef : str
            Описание для создаваемого события.

    Returns
    -------
    bool
        true - событие создано успешно;
        false - при создании события произошла ошибка

    Warns
    -----
        Для работы функции часто требуются права администратора. Кириллицу в параметрах не использовать!!!

    '''

    MyCommandLine =  r'EVENTCREATE.EXE /L ' + MyList + r' /T ' + MyType + r' /SO "' + MySource + r'" /ID ' + str(MyID) + r' /D "' + MyDef + '"'
    MyResult = os.system(MyCommandLine)
    return MyResult == 0

def Simple_Log_Entry ( MyType=4, MyMessage = 'Событие'):
    '''Протоколирует событие в журнале WindowsNT

    Parameters
    ----------
    MyType : int
                тип сообщения.
                
                Код     Описание
                0	SUCCESS.
                1	ERROR.
                2	WARNING.
                4	INFORMATION.
                8	AUDIT_SUCCESS.
                16	AUDIT_FAILURE.

    MyMessage : str
                строка, текст сообщения.

    Returns
    -------
    bool
        true - событие создано успешно;
        false - при создании события произошла ошибка
    '''

    MyShell = win32com.client.Dispatch("WScript.Shell")
    return MyShell.LogEvent ( MyType, MyMessage.decode('utf-8'))

def Special_Folder_Name( SFName ):
    '''Возвращает полный путь к специальным папкам типа меню Пуск.

    Parameters
    ----------
    SFName : str
             Название специальной папки

    Примерный список доступных папок:
        AllUsersDesktop, AllUsersStartMenu, AllUsersPrograms, AllUsersStartup,
        Desktop, Favorites, Fonts, MyDocuments, NetHood, PrintHood, Programs,
        Recent, SendTo, StartMenu, Startup, Templates.

    Returns
    -------
    str
        Путь к указанной специальной папке.
    '''

    MyResult = None
    if len(SFName)<1:
        return MyResult
    MyShell = win32com.client.Dispatch("WScript.Shell")
    MyResult = MyShell.SpecialFolders( SFName )
    return MyResult

def Create_Shortcut( ShortcutName, TargetPath, Arguments=' ', Description='Описание ярлыка', WorkingDirectory= r'%USERPROFILE%', WindowStyle=4, IconLocation=r'%SystemRoot%\System32\SHELL32.dll,0', Hotkey='CTRL+ALT+S'):
    '''Функция создаёт в нужном месте ярлык на файл или папку.

    Parameters
    ----------
    ShortcutName : str
        Полный путь к расположению самого ярлыка
    TargetPath : str
        Местоположение файла/папки куда мы будем ссылаться.
    Arguments : str
        Данное свойство задает аргументы командной строки для приложения, на которое надо ссылаться.
    Description: str
        В это свойство мы можем прописать описание.
    WorkingDirectory : str
        Рабочая папка для ярлыка
    WindowStyle : int
        Определяет параметры окна для приложения при его запуске, может принимать только целые значения:
        4 – стандартный размер окна;
        3 – развернутый вид (максимизировано);
        7 – свернутое окно (минимизировано).
    IconLocation : str
        Хранит в себе местоположение иконки.
    Hotkey : str
        Данное свойство отвечает за "Горячую" клавишу, как правило, тут прописываются комбинации клавиш для запуска того приложения, на которое надо сослаться.
    '''

    MyShell = win32com.client.Dispatch("WScript.Shell")
    MyShortcut = MyShell.CreateShortcut( ShortcutName.decode('utf-8') )
    MyShortcut.TargetPath = TargetPath.decode('utf-8')
    MyShortcut.Arguments = Arguments.decode('utf-8')
    MyShortcut.Description = Description.decode('utf-8')
    MyShortcut.WorkingDirectory = WorkingDirectory.decode('utf-8')
    MyShortcut.WindowStyle = WindowStyle
    MyShortcut.IconLocation = IconLocation.decode('utf-8')
    MyShortcut.Hotkey = Hotkey.decode('utf-8')
    MyShortcut.Save()

def Is_Admin():
    '''
    Функция проверки наличия прав администратора

    Returns
    -------
    bool
         true - Права администратора имеются;
         false - Прав администратора нет.
    '''
    try:
        return ctypes.windll.shell32.IsUserAnAdmin()
    except:
        return False

def Url_Ok( url, timeout=5 ):
    '''
    Функция проверки доступности URL

    Parameters
    ----------
    url : str
          Проверяемый URL

    imeout : int
             timeout ожидания

    Returns
    -------
    bool
         true - URL доступен
         false - URL недоступен

    '''
    try:
        return urllib2.urlopen(url,timeout=timeout).getcode() == 200
    except urllib2.URLError as e:
        return False
    except socket.timeout as e:
        return False

def Download_File(myurl,mypath):
    '''
    Функция скачивания файла

    Parameters
    ----------
    myurl : str
           Откуда скачиваем файл

    mypath : str
            куда скачиваем файл

    Returns
    -------
    bool
        true  - успешное скачивание
        false - скачивание не удалось

    '''
    if not Url_Ok(myurl, 5):
        Create_Log_Entry(MyType='ERROR', MyDef='File not available: ' + myurl)
        return False
    Create_Log_Entry(MyType='SUCCESS', MyDef= 'File available: '+ myurl)

    try:
        mycontent = urllib2.urlopen(myurl)
        output = open(mypath,'wb')
        output.write(mycontent.read())
        output.close()
    except urllib2.HTTPError, error:
        Create_Log_Entry(MyType='ERROR', MyDef='Error: ' + error.read())
        Create_Log_Entry(MyType='ERROR', MyDef= 'File not downloaded: ' + myurl)
        return False
    except:
        Create_Log_Entry(MyType='ERROR', MyDef= 'Something went wrong while downloading the file: ' + myurl)
        return False
    else:
        Create_Log_Entry(MyType='SUCCESS', MyDef= 'The file has been downloaded: '+ myurl)
        return True

def Download_Page(myurl = 'http://zbx.mihanik.net/'):
    '''
    Функция скачивания страницы по URL в память ПК

    Parameters
    ----------
    myurl : str
           Откуда скачиваем файл

    Returns
    -------
    str
        Полный текст страницы

    '''
    if not Url_Ok(myurl, 5):
        Simple_Log_Entry (1, "Страница недоступна: " + myurl)
        return 'None'
    Simple_Log_Entry (0, "Страница доступна: " + myurl)

    try:
        mycontent = urllib2.urlopen(myurl)
        return mycontent.read()
    except urllib2.HTTPError, error:
        Simple_Log_Entry (1, 'Error: ' + error.read())
        Simple_Log_Entry (1, 'Страница не загружена: ' + myurl
        return 'None'
    except:
        Simple_Log_Entry (1, 'Что-то пошло не так при загрузке страницы: ' + myurl)
        return 'None'

def main():

    print Download_Page ()

if __name__ == '__main__':
    main()
