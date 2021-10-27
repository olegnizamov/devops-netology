# Домашнее задание к занятию «1.1. Введение в DevOps»

## Задание №1 - Подготовка рабочей среды

Вы пришли на новое место работы или приобрели новый компьютер. Первым делом надо настроить окружение для дальнейшей работы.

1. Установить Py Charm Community Edition: [https://www.jetbrains.com/ru-ru/pycharm/download/](https://www.jetbrains.com/ru-ru/pycharm/download/) - это бесплатная версия IDE. Если у вас уже установлен любой другой продукт от JetBrains,то можно использовать его.
   **SOLUTION - Вместо Pycharm использую Phpstorm.**
2. Установить плагины:

   * Terraform,
   * MarkDown,
   * Yaml/Ansible Support,
   * Jsonnet.
     **SOLUTION - Плагины установлены. Добавлю, что есть крутой плагин Markdown Editor - который позволяет упростить создание md файлов.**
3. Склонировать текущий репозиторий или просто создать файлы для проверки плагинов:

   * [netology.tf](https://github.com/netology-code/sysadm-homeworks/blob/devsys10/01-intro-01/netology.tf) – терраформ,
   * [netology.sh](https://github.com/netology-code/sysadm-homeworks/blob/devsys10/01-intro-01/netology.sh) – bash,
   * [netology.md](https://github.com/netology-code/sysadm-homeworks/blob/devsys10/01-intro-01/netology.md) – markdown,
   * [netology.yaml](https://github.com/netology-code/sysadm-homeworks/blob/devsys10/01-intro-01/netology.yaml) – yaml,
   * [netology.jsonnet](https://github.com/netology-code/sysadm-homeworks/blob/devsys10/01-intro-01/netology.jsonnet) – jsonnet.
     **SOLUTION - Скопированны в файлы.**
4. Убедитесь, что работает подсветка синтаксиса, файлы должны выглядеть вот так:

   * Terraform: [![Терраформ](https://github.com/netology-code/sysadm-homeworks/raw/devsys10/01-intro-01/img/terraform.png)](https://github.com/netology-code/sysadm-homeworks/blob/devsys10/01-intro-01/img/terraform.png)
   * Bash: [![bahs](https://github.com/netology-code/sysadm-homeworks/raw/devsys10/01-intro-01/img/bash.png)](https://github.com/netology-code/sysadm-homeworks/blob/devsys10/01-intro-01/img/bash.png)
   * Markdown: [![markdown](https://github.com/netology-code/sysadm-homeworks/raw/devsys10/01-intro-01/img/markdown.png)](https://github.com/netology-code/sysadm-homeworks/blob/devsys10/01-intro-01/img/markdown.png)
   * Yaml: [![Yaml](https://github.com/netology-code/sysadm-homeworks/raw/devsys10/01-intro-01/img/yaml.png)](https://github.com/netology-code/sysadm-homeworks/blob/devsys10/01-intro-01/img/yaml.png)
   * Jsonnet: [![Jsonnet](https://github.com/netology-code/sysadm-homeworks/raw/devsys10/01-intro-01/img/jsonnet.png)](https://github.com/netology-code/sysadm-homeworks/blob/devsys10/01-intro-01/img/jsonnet.png)
     **SOLUTION - DONE.**
5. Добавьте свое имя в каждый файл, сделайте снимок экран и загрузите его на любой сервис обмена картинками.

   * Terraform: [![Терраформ](https://github.com/olegnizamov/devops-netology/blob/master/lesson1/files/1.PNG)](https://github.com/olegnizamov/devops-netology/blob/master/lesson1/files/1.PNG)
   * Bash: [![bahs](https://github.com/olegnizamov/devops-netology/blob/master/lesson1/files/3.PNG)](https://github.com/olegnizamov/devops-netology/blob/master/lesson1/files/3.PNG)
   * Markdown: [![markdown](https://github.com/olegnizamov/devops-netology/blob/master/lesson1/files/4.PNG)](https://github.com/olegnizamov/devops-netology/blob/master/lesson1/files/4.PNG)
   * Yaml: [![Yaml](https://github.com/olegnizamov/devops-netology/blob/master/lesson1/files/2.PNG)](https://github.com/olegnizamov/devops-netology/blob/master/lesson1/files/2.PNG)
   * Jsonnet: [![Jsonnet](https://github.com/olegnizamov/devops-netology/blob/master/lesson1/files/5.PNG)](https://github.com/olegnizamov/devops-netology/blob/master/lesson1/files/5.PNG)
     **SOLUTION - DONE.**
6. Ссылки на картинки укажите в личном кабинете как решение домашнего задания.
   **SOLUTION - DONE.**

## Задание №2 - Описание жизненного цикла задачи (разработки нового функционала)

Чтобы лучше понимать предназначение дальнейших инструментов, с которыми нам предстоит работать, давайте составим схему жизненного цикла задачи в идеальном для вас случае.

### Описание истории

Представьте, что вы работаете в стартапе, который запустил интернет-магазин. Ваш интернет-магазин достаточно успешно развивался, и вот пришло время налаживать процессы: у вас стало больше конечных клиентов, менеджеров и разработчиков.Сейчас от клиентов вам приходят задачи, связанные с разработкой нового функционала. Задач много, и все они требуют выкладки на тестовые среды, одобрения тестировщика, проверки менеджером перед показом клиенту. В случае необходимости, вам будет необходим откат изменений.

### Решение задачи

Вам необходимо описать процесс решения задачи в соответствии с жизненным циклом разработки программного обеспечения. Использование какого-либо конкретного метода разработки не обязательно. Для решения главное - прописать по пунктам шаги решения задачи (релизации в конечный результат) с участием менеджера, разработчика (или команды разработчиков), тестировщика (или команды тестировщиков) и себя как DevOps-инженера.

### **Описание решения**

Менеджер-ПродуктОунер и т.д:

1) Получения задачи от бизнеса.
2) Общение с тимлидом на счет эстимации задачи(времени выполнения).Менеджер-ПродуктОунер и т.д:

Тимлид:

3. Описание задачи.
4. Постановка задачи разработчику.
5. Получения дизайн-ревью задачи, оценка его
6. Создание фичи ветки в git для реализации данной задачи
7. После уточнения всех вопросов - задача переводится в разработку.

Разработчик:

8. Переключение на фича-ветку
9. Выполнение задачи.
10. Написание тестов на задачу.
11. Прохождения статического анализатора кода и код-стайла (к примеру gitlab.ci)
12. В случае успешного прохождения предкоммитных действий - пуш в фича ветку
13. Запуск автотестов на проверку корректности фичи в системе. (автоматически)
14. В случае успешного выполнения тестов - перевод на тестировщика и в тест. В случае неуспеха - доработка фичи.

Тестировщик:

15. Создание площадки для тестирования фичи (автоматически).
16. Выполнение тестирование фичи.
17. В случае успеха - апрув фичи.

18 Деплой задачи на бой (автоматически).

Devops

Цель devops - обновление площадок(версия php, mysql) , настройка автоматизации настройки и разворачивания систем, настройка систем мониторинга продукта.
