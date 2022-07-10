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
[sudo] пароль для olegnizamov: 
[WARNING]: Found both group and host with same name: kibana
[WARNING]: Found both group and host with same name: logstash

PLAY [Install Java] **************************************************************************************************************************************************************************************************************************************

TASK [Gathering Facts] ***********************************************************************************************************************************************************************************************************************************
fatal: [logstash]: UNREACHABLE! => {"changed": false, "msg": "Authentication or permission failure. In some cases, you may have been able to authenticate and did not have permissions on the target directory. Consider changing the remote tmp path in ansible.cfg to a path rooted in \"/tmp\". Failed command was: ( umask 77 && mkdir -p \"` echo ~/.ansible/tmp/ansible-tmp-1657458815.3651323-177009470547729 `\" && echo ansible-tmp-1657458815.3651323-177009470547729=\"` echo ~/.ansible/tmp/ansible-tmp-1657458815.3651323-177009470547729 `\" ), exited with result 1", "unreachable": true}
ok: [localhost]
[DEPRECATION WARNING]: Distribution Ubuntu 18.04 on host kibana should use /usr/bin/python3, but is using /usr/bin/python for backward compatibility with prior Ansible releases. A future Ansible release will default to using the discovered platform 
python for this host. See https://docs.ansible.com/ansible/2.9/reference_appendices/interpreter_discovery.html for more information. This feature will be removed in version 2.12. Deprecation warnings can be disabled by setting 
deprecation_warnings=False in ansible.cfg.
ok: [kibana]
[DEPRECATION WARNING]: Distribution Ubuntu 18.04 on host elastic should use /usr/bin/python3, but is using /usr/bin/python for backward compatibility with prior Ansible releases. A future Ansible release will default to using the discovered platform
 python for this host. See https://docs.ansible.com/ansible/2.9/reference_appendices/interpreter_discovery.html for more information. This feature will be removed in version 2.12. Deprecation warnings can be disabled by setting 
deprecation_warnings=False in ansible.cfg.
ok: [elastic]

TASK [Set facts for Java 11 vars] ************************************************************************************************************************************************************************************************************************
ok: [localhost]
ok: [elastic]
ok: [kibana]

TASK [Upload .tar.gz file containing binaries from local storage] ****************************************************************************************************************************************************************************************
changed: [localhost]
changed: [elastic]
changed: [kibana]

TASK [Ensure installation dir exists] ********************************************************************************************************************************************************************************************************************
changed: [localhost]
changed: [kibana]
changed: [elastic]

TASK [Extract java in the installation directory] ********************************************************************************************************************************************************************************************************
fatal: [localhost]: FAILED! => {"changed": false, "msg": "dest '/opt/jdk/11.0.11' must be an existing dir"}
fatal: [elastic]: FAILED! => {"changed": false, "msg": "dest '/opt/jdk/11.0.11' must be an existing dir"}
fatal: [kibana]: FAILED! => {"changed": false, "msg": "dest '/opt/jdk/11.0.11' must be an existing dir"}

PLAY RECAP ***********************************************************************************************************************************************************************************************************************************************
elastic                    : ok=4    changed=2    unreachable=0    failed=1    skipped=0    rescued=0    ignored=0   
kibana                     : ok=4    changed=2    unreachable=0    failed=1    skipped=0    rescued=0    ignored=0   
localhost                  : ok=4    changed=2    unreachable=0    failed=1    skipped=0    rescued=0    ignored=0   
logstash                   : ok=0    changed=0    unreachable=1    failed=0    skipped=0    rescued=0    ignored=0
```
7. Запустите playbook на `prod.yml` окружении с флагом `--diff`. Убедитесь, что изменения на системе произведены.
```
> Ответ:
olegnizamov@olegnizamov:~/projects/devops-netology/08-ansible-02-playbook/src$ sudo ansible-playbook -i ./inventory/prod.yml site.yml --diff
[WARNING]: Found both group and host with same name: logstash
[WARNING]: Found both group and host with same name: kibana

PLAY [Install Java] **************************************************************************************************************************************************************************************************************************************

TASK [Gathering Facts] ***********************************************************************************************************************************************************************************************************************************
fatal: [logstash]: UNREACHABLE! => {"changed": false, "msg": "Authentication or permission failure. In some cases, you may have been able to authenticate and did not have permissions on the target directory. Consider changing the remote tmp path in ansible.cfg to a path rooted in \"/tmp\". Failed command was: ( umask 77 && mkdir -p \"` echo ~/.ansible/tmp/ansible-tmp-1657458842.663212-133466484137235 `\" && echo ansible-tmp-1657458842.663212-133466484137235=\"` echo ~/.ansible/tmp/ansible-tmp-1657458842.663212-133466484137235 `\" ), exited with result 1", "unreachable": true}
ok: [localhost]
[DEPRECATION WARNING]: Distribution Ubuntu 18.04 on host elastic should use /usr/bin/python3, but is using /usr/bin/python for backward compatibility with prior Ansible releases. A future Ansible release will default to using the discovered platform
 python for this host. See https://docs.ansible.com/ansible/2.9/reference_appendices/interpreter_discovery.html for more information. This feature will be removed in version 2.12. Deprecation warnings can be disabled by setting 
deprecation_warnings=False in ansible.cfg.
ok: [elastic]
[DEPRECATION WARNING]: Distribution Ubuntu 18.04 on host kibana should use /usr/bin/python3, but is using /usr/bin/python for backward compatibility with prior Ansible releases. A future Ansible release will default to using the discovered platform 
python for this host. See https://docs.ansible.com/ansible/2.9/reference_appendices/interpreter_discovery.html for more information. This feature will be removed in version 2.12. Deprecation warnings can be disabled by setting 
deprecation_warnings=False in ansible.cfg.
ok: [kibana]

TASK [Set facts for Java 11 vars] ************************************************************************************************************************************************************************************************************************
ok: [localhost]
ok: [elastic]
ok: [kibana]

TASK [Upload .tar.gz file containing binaries from local storage] ****************************************************************************************************************************************************************************************
diff skipped: source file size is greater than 104448
changed: [localhost]
diff skipped: source file size is greater than 104448
changed: [elastic]
diff skipped: source file size is greater than 104448
changed: [kibana]

TASK [Ensure installation dir exists] ********************************************************************************************************************************************************************************************************************
--- before
+++ after
@@ -1,4 +1,4 @@
 {
     "path": "/opt/jdk/11.0.11",
-    "state": "absent"
+    "state": "directory"
 }

changed: [localhost]
--- before
+++ after
@@ -1,4 +1,4 @@
 {
     "path": "/opt/jdk/11.0.11",
-    "state": "absent"
+    "state": "directory"
 }

changed: [kibana]
--- before
+++ after
@@ -1,4 +1,4 @@
 {
     "path": "/opt/jdk/11.0.11",
-    "state": "absent"
+    "state": "directory"
 }

changed: [elastic]

TASK [Extract java in the installation directory] ********************************************************************************************************************************************************************************************************
changed: [localhost]
changed: [kibana]
changed: [elastic]

TASK [Export environment variables] **********************************************************************************************************************************************************************************************************************
--- before
+++ after: /root/.ansible/tmp/ansible-local-172831o1pg9th/tmpauegsjjs/jdk.sh.j2
@@ -0,0 +1,5 @@
+# Warning: This file is Ansible Managed, manual changes will be overwritten on next playbook run.
+#!/usr/bin/env bash
+
+export JAVA_HOME=/opt/jdk/11.0.11
+export PATH=$PATH:$JAVA_HOME/bin
\ No newline at end of file

changed: [localhost]
--- before
+++ after: /root/.ansible/tmp/ansible-local-172831o1pg9th/tmp0s3qhvum/jdk.sh.j2
@@ -0,0 +1,5 @@
+# Warning: This file is Ansible Managed, manual changes will be overwritten on next playbook run.
+#!/usr/bin/env bash
+
+export JAVA_HOME=/opt/jdk/11.0.11
+export PATH=$PATH:$JAVA_HOME/bin
\ No newline at end of file

changed: [elastic]
--- before
+++ after: /root/.ansible/tmp/ansible-local-172831o1pg9th/tmpojroanbd/jdk.sh.j2
@@ -0,0 +1,5 @@
+# Warning: This file is Ansible Managed, manual changes will be overwritten on next playbook run.
+#!/usr/bin/env bash
+
+export JAVA_HOME=/opt/jdk/11.0.11
+export PATH=$PATH:$JAVA_HOME/bin
\ No newline at end of file

changed: [kibana]

PLAY [Install Elasticsearch] *****************************************************************************************************************************************************************************************************************************

TASK [Gathering Facts] ***********************************************************************************************************************************************************************************************************************************
ok: [elastic]

TASK [Upload tar.gz Elasticsearch from remote URL] *******************************************************************************************************************************************************************************************************
FAILED - RETRYING: Upload tar.gz Elasticsearch from remote URL (3 retries left).
FAILED - RETRYING: Upload tar.gz Elasticsearch from remote URL (2 retries left).
FAILED - RETRYING: Upload tar.gz Elasticsearch from remote URL (1 retries left).
fatal: [elastic]: FAILED! => {"attempts": 3, "changed": false, "dest": "/tmp/elasticsearch-7.10.1-linux-x86_64.tar.gz", "elapsed": 0, "msg": "Request failed", "response": "HTTP Error 403: Forbidden", "status_code": 403, "url": "https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-7.10.1-linux-x86_64.tar.gz"}

PLAY RECAP ***********************************************************************************************************************************************************************************************************************************************
elastic                    : ok=7    changed=4    unreachable=0    failed=1    skipped=0    rescued=0    ignored=0   
kibana                     : ok=6    changed=4    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
localhost                  : ok=6    changed=4    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
logstash                   : ok=0    changed=0    unreachable=1    failed=0    skipped=0    rescued=0    ignored=0   

```
8. Повторно запустите playbook с флагом `--diff` и убедитесь, что playbook идемпотентен.
```
> Ответ: DONE
```
9. Подготовьте README.md файл по своему playbook. В нём должно быть описано: что делает playbook, какие у него есть параметры и теги.
```
> Ответ: DONE
```
10. Готовый playbook выложите в свой репозиторий, в ответ предоставьте ссылку на него.
```
> Ответ: https://github.com/olegnizamov/ansible-playbook
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