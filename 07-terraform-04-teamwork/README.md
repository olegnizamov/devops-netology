# Домашнее задание к занятию "7.4. Средства командной работы над инфраструктурой."

## Задача 1. Настроить terraform cloud (необязательно, но крайне желательно).

В это задании предлагается познакомиться со средством командой работы над инфраструктурой предоставляемым
разработчиками терраформа.

1. Зарегистрируйтесь на [https://app.terraform.io/](https://app.terraform.io/).  (регистрация бесплатная и не требует использования платежных инструментов).
2. Создайте в своем github аккаунте (или другом хранилище репозиториев) отдельный репозиторий с
   конфигурационными файлами прошлых занятий (или воспользуйтесь любым простым конфигом).
   [https://github.com/olegnizamov/terraform](https://github.com/olegnizamov/terraform)
3. Зарегистрируйте этот репозиторий в [https://app.terraform.io/](https://app.terraform.io/).
4. Выполните plan и apply.

```
> Ответ:
1 В resource "yandex_compute_instance" "instance", в ssh-keys, меняем использование файла на переменную в неё мы будем передавать открытый ключ.
2 В terraform cloud создаём organization, а в ней workspace. Имена как в backend "remote"!!! При создании workspace, выбираем Version control folder.
3. После авторизации, подтянется проект и попробует собраться, упадёт с ошибкой. Ничего страшного, нужно заполнить переменные и ключи. 
4. Переходим на закладку Variables
5. Добавляем переменные, тип выбираем terraform. имена должны быть как в файле vars.tf. 
6. Для переменной id_rsa_pub значение берём из файла ~/.ssh/id_rsa.pub.
Выполняем сборку
```


В качестве результата задания приложите снимок экрана с успешным применением конфигурации.

## Задача 2. Написать серверный конфиг для атлантиса.

Смысл задания – познакомиться с документацией
о [серверной](https://www.runatlantis.io/docs/server-side-repo-config.html) конфигурации и конфигурации уровня
[репозитория](https://www.runatlantis.io/docs/repo-level-atlantis-yaml.html).

Создай `server.yaml` который скажет атлантису:
1. Укажите, что атлантис должен работать только для репозиториев в вашем github (или любом другом) аккаунте.
1. На стороне клиентского конфига разрешите изменять `workflow`, то есть для каждого репозитория можно
   будет указать свои дополнительные команды.
1. В `workflow` используемом по-умолчанию сделайте так, что бы во время планирования не происходил `lock` состояния.

Создай `atlantis.yaml` который, если поместить в корень terraform проекта, скажет атлантису:
1. Надо запускать планирование и аплай для двух воркспейсов `stage` и `prod`.
1. Необходимо включить автопланирование при изменении любых файлов `*.tf`.

В качестве результата приложите ссылку на файлы `server.yaml` и `atlantis.yaml`.

## Задача 3. Знакомство с каталогом модулей.

1. В [каталоге модулей](https://registry.terraform.io/browse/modules) найдите официальный модуль от aws для создания
   `ec2` инстансов.
2. Изучите как устроен модуль. Задумайтесь, будете ли в своем проекте использовать этот модуль или непосредственно
   ресурс `aws_instance` без помощи модуля?
3. В рамках предпоследнего задания был создан ec2 при помощи ресурса `aws_instance`.
   Создайте аналогичный инстанс при помощи найденного модуля.

В качестве результата задания приложите ссылку на созданный блок конфигураций.

Для себя
https://www.terraform.io/language/settings/backends/remote
