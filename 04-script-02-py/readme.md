### Как сдавать задания

Вы уже изучили блок «Системы управления версиями», и начиная с этого занятия все ваши работы будут приниматься ссылками
на .md-файлы, размещённые в вашем публичном репозитории.

Скопируйте в свой .md-файл содержимое этого файла; исходники можно
посмотреть [здесь](https://raw.githubusercontent.com/netology-code/sysadm-homeworks/devsys10/04-script-02-py/README.md).
Заполните недостающие части документа решением задач (заменяйте `???`, ОСТАЛЬНОЕ В ШАБЛОНЕ НЕ ТРОГАЙТЕ чтобы не сломать
форматирование текста, подсветку синтаксиса и прочее, иначе можно отправиться на доработку) и отправляйте на проверку.
Вместо логов можно вставить скриншоты по желани.

# Домашнее задание к занятию "4.2. Использование Python для решения типовых DevOps задач"

## Обязательная задача 1

Есть скрипт:

```python
#!/usr/bin/env python3
a = 1
b = '2'
c = a + b
```

### Вопросы:

| Вопрос  | Ответ                                                                         |
| ------------- |-------------------------------------------------------------------------------|
| Какое значение будет присвоено переменной `c`?  | Никакое - TypeError: unsupported operand type(s) for +: 'int' and 'str'       |
| Как получить для переменной `c` значение 12?  | изменить значение а на строковое - a = '1' или привести к строковому значению |
| Как получить для переменной `c` значение 3?  | изменить значение b на числовое - b = 2 или привести к числовому значению     |

## Обязательная задача 2

Мы устроились на работу в компанию, где раньше уже был DevOps Engineer. Он написал скрипт, позволяющий узнать, какие
файлы модифицированы в репозитории, относительно локальных изменений. Этим скриптом недовольно начальство, потому что в
его выводе есть не все изменённые файлы, а также непонятен полный путь к директории, где они находятся. Как можно
доработать скрипт ниже, чтобы он исполнял требования вашего руководителя?

```python
#!/usr/bin/env python3

import os

bash_command = ["cd ~/netology/sysadm-homeworks", "git status"]
result_os = os.popen(' && '.join(bash_command)).read()
is_change = False
for result in result_os.split('\n'):
    if result.find('modified') != -1:
        prepare_result = result.replace('\tmodified:   ', '')
        print(prepare_result)
        break
```

### Ваш скрипт:

```python
#!/usr/bin/env python3

import os

bash_command = ["cd /home/vagrant/netology/sysadm-homeworks", "git status"]
result_os = os.popen(' && '.join(bash_command)).read()
for result in result_os.split('\n'):
    if result.find('modified') != -1:
        prepare_result = result.replace('\tmodified:   ', '')
        print(prepare_result)
```

### Вывод скрипта при запуске при тестировании:

```
vagrant@vagrant:~/netology/sysadm-homeworks$ git status
On branch master
Changes not staged for commit:
  (use "git add <file>..." to update what will be committed)
  (use "git restore <file>..." to discard changes in working directory)
        modified:   1.txt

Untracked files:
  (use "git add <file>..." to include in what will be committed)
        1.py

no changes added to commit (use "git add" and/or "git commit -a")
vagrant@vagrant:~/netology/sysadm-homeworks$ python3 1.py
1.txt
```

## Обязательная задача 3

1. Доработать скрипт выше так, чтобы он мог проверять не только локальный репозиторий в текущей директории, а также умел
   воспринимать путь к репозиторию, который мы передаём как входной параметр. Мы точно знаем, что начальство коварное и
   будет проверять работу этого скрипта в директориях, которые не являются локальными репозиториями.

### Ваш скрипт:

```python
#!/usr/bin/env python3

import os
import sys

path = sys.argv[1]
if not os.path.exists(f'{path}.git'):
    print('Данная директория не является репозиторием')
    exit()

bash_command = [f"cd {path}", "git status"]
result_os = os.popen(' && '.join(bash_command)).read()
for result in result_os.split('\n'):
    if result.find('modified') != -1:
        prepare_result = result.replace('\tmodified:   ', '')
        print(prepare_result)
```

### Вывод скрипта при запуске при тестировании:

```
vagrant@vagrant:~/netology/sysadm-homeworks$ python3 1.py /home/vagrant/netology/sysadm-homewo6456rks/
Данная директория не является репозиторием
vagrant@vagrant:~/netology/sysadm-homeworks$ python3 1.py /home/vagrant/netology/sysadm-homeworks/
1.txt
```

## Обязательная задача 4

1. Наша команда разрабатывает несколько веб-сервисов, доступных по http. Мы точно знаем, что на их стенде нет никакой
   балансировки, кластеризации, за DNS прячется конкретный IP сервера, где установлен сервис. Проблема в том, что отдел,
   занимающийся нашей инфраструктурой очень часто меняет нам сервера, поэтому IP меняются примерно раз в неделю, при
   этом сервисы сохраняют за собой DNS имена. Это бы совсем никого не беспокоило, если бы несколько раз сервера не
   уезжали в такой сегмент сети нашей компании, который недоступен для разработчиков. Мы хотим написать скрипт, который
   опрашивает веб-сервисы, получает их IP, выводит информацию в стандартный вывод в виде: <URL сервиса> - <его IP>.
   Также, должна быть реализована возможность проверки текущего IP сервиса c его IP из предыдущей проверки. Если
   проверка будет провалена - оповестить об этом в стандартный вывод сообщением: [ERROR] <URL сервиса> IP mismatch: <
   старый IP> <Новый IP>. Будем считать, что наша разработка реализовала сервисы: `drive.google.com`, `mail.google.com`
   , `google.com`.

### Ваш скрипт:

```python
#!/usr/bin/env python3

import socket
import time

# Задаем IP адреса по умолчанию пустыми значениями
service = {
    "drive.google.com": '',
    'mail.google.com': '',
    'google.com': ''
}

while (True):
    for domen,ip in service.items():
        get_current_ip = socket.gethostbyname(domen)
        if get_current_ip != ip:
            service[domen] = get_current_ip
            print(f'[ERROR] {domen} IP mismatch: {ip} New IP: {get_current_ip}')
        else:
            print(f'{domen} -{ip}')
```

### Вывод скрипта при запуске при тестировании:

```
[ERROR] drive.google.com IP mismatch:  New IP: 74.125.131.194
[ERROR] mail.google.com IP mismatch:  New IP: 64.233.162.17
[ERROR] google.com IP mismatch:  New IP: 64.233.164.139
drive.google.com -74.125.131.194
mail.google.com -64.233.162.17
[ERROR] google.com IP mismatch: 64.233.164.139 New IP: 64.233.164.100
drive.google.com -74.125.131.194
mail.google.com -64.233.162.17
google.com -64.233.164.100
drive.google.com -74.125.131.194
mail.google.com -64.233.162.17
google.com -64.233.164.100
```
