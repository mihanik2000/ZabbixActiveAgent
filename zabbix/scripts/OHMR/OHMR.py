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
#def main(argv=None):

# Проверяем наличие прав админа.
if not is_admin ():
   sys.exit ('Not enough permissions to run the script !!!')

# Устанавливаем кодировку по умолчанию.
reload(sys)
sys.setdefaultencoding('utf8')

# Устанавливаем имена файлов, где будет храниться температура процесоров
cpu0 = r'C:\zabbix\scripts\OHMR\cpu0.txt'
cpu1 = r'C:\zabbix\scripts\OHMR\cpu1.txt'

# Получаем результат работы OHMR
OHMR = []
OHMR = os.popen("C:\zabbix\scripts\OHMR\OpenHardwareMonitorReport.exe").read().splitlines()

# Высчитываем температуру 0-го и, возможно, 1-го процесора

n0 = 0
sum0 = 0

n1 = 0
sum1 = 0

for i in OHMR:
   if (':' in i) and ('(/intelcpu/0/temperature/' in i):
      t = i.split()
      n0 = n0 + 1
      sum0 = sum0 + int(t[8])

   if (':' in i) and ('(/intelcpu/1/temperature/' in i):
      t = i.split()
      n1 = n1 + 1
      sum1 = sum1 + int(t[8])

if n0>0:
   sum0 = sum0 / n0

if n1>0:
   sum1 = sum1 / n1

print sum0
print sum1

# Сохраняем температуру 0-го процессора в файл
f = open(cpu0,'w')
try:
   f.write(sum0)
except Exception:
#      pass
   print 'Бля!'

finally:
   f.close()

# Сохраняем температуру 1-го процессора в файл
f = open(cpu1,'w')
try:
   f.write(sum1)
except Exception:
#      pass
   print 'Бля!'
finally:
   f.close()

#if __name__ == "__main__":
#    sys.exit(main())
