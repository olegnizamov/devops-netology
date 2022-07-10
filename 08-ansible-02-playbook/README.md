# Домашнее задание к занятию "08.02 Работа с Playbook"

## Подготовка к выполнению
1. Создайте свой собственный (или используйте старый) публичный репозиторий на github с произвольным именем.
```
> Ответ: https://github.com/olegnizamov/ansible-playbook
```
2. Скачайте [playbook](./playbook/) из репозитория с домашним заданием и перенесите его в свой репозиторий.
```
> Ответ: DONE
```
3. Подготовьте хосты в соотвтествии с группами из предподготовленного playbook.
```
> Ответ:
version: '3.9'

services:
  elastic:
    image: pycontribs/ubuntu
    container_name: elastic
    restart: unless-stopped
    entrypoint: "sleep infinity"
  kibana:
    image: pycontribs/ubuntu
    container_name: kibana
    restart: unless-stopped
    entrypoint: "sleep infinity"


```
4. Скачайте дистрибутив [java](https://www.oracle.com/java/technologies/javase-jdk11-downloads.html) и положите его в директорию `playbook/files/`.
```
> Ответ: DONE 

```

## Основная часть
1. Приготовьте свой собственный inventory файл `prod.yml`.
```
> Ответ:
---
  elasticsearch:
    hosts:
      elastic:
        ansible_connection: docker
  kibana:
    hosts:
      kibana:
        ansible_connection: docker
```
2. Допишите playbook: нужно сделать ещё один play, который устанавливает и настраивает kibana.
```
> Ответ: DONE
```
3. При создании tasks рекомендую использовать модули: `get_url`, `template`, `unarchive`, `file`.
```
> Ответ: DONE
```
4. Tasks должны: скачать нужной версии дистрибутив, выполнить распаковку в выбранную директорию, сгенерировать конфигурацию с параметрами.
```
> Ответ: DONE
```
5. Запустите `ansible-lint site.yml` и исправьте ошибки, если они есть.
```
> Ответ:
olegnizamov@olegnizamov:~/projects/devops-netology/08-ansible-02-playbook/src$ ansible-lint site.yml

```
6. Попробуйте запустить playbook на этом окружении с флагом `--check`.
```
> Ответ:
olegnizamov@olegnizamov:~/projects/devops-netology/08-ansible-02-playbook/src$ ansible-playbook -i ./inventory/prod.yml site.yml --check

```
7. Запустите playbook на `prod.yml` окружении с флагом `--diff`. Убедитесь, что изменения на системе произведены.
```
> Ответ:
```
8. Повторно запустите playbook с флагом `--diff` и убедитесь, что playbook идемпотентен.
```
> Ответ:
```
9. Подготовьте README.md файл по своему playbook. В нём должно быть описано: что делает playbook, какие у него есть параметры и теги.
```
> Ответ:
```
10. Готовый playbook выложите в свой репозиторий, в ответ предоставьте ссылку на него.
```
> Ответ:
```

## Необязательная часть

1. Приготовьте дополнительный хост для установки logstash.
2. Пропишите данный хост в `prod.yml` в новую группу `logstash`.
3. Дополните playbook ещё одним play, который будет исполнять установку logstash только на выделенный для него хост.
4. Все переменные для нового play определите в отдельный файл `group_vars/logstash/vars.yml`.
5. Logstash конфиг должен конфигурироваться в части ссылки на elasticsearch (можно взять, например его IP из facts или определить через vars).
6. Дополните README.md, протестируйте playbook, выложите новую версию в github. В ответ предоставьте ссылку на репозиторий.

---

### Как оформить ДЗ?

Выполненное домашнее задание пришлите ссылкой на .md-файл в вашем репозитории.

---