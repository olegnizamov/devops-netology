# Домашнее задание к занятию "08.01 Введение в Ansible"

## Подготовка к выполнению
1. Установите ansible версии 2.10 или выше.
```
> Ответ:
olegnizamov@olegnizamov:~/projects/devops-netology/07-terraform-06-providers/src$ ansible --version
ansible 2.9.6
  config file = /etc/ansible/ansible.cfg
  configured module search path = ['/home/olegnizamov/.ansible/plugins/modules', '/usr/share/ansible/plugins/modules']
  ansible python module location = /usr/lib/python3/dist-packages/ansible
  executable location = /usr/bin/ansible
  python version = 3.8.10 (default, Mar 15 2022, 12:22:08) [GCC 9.4.0]

```
3. Создайте свой собственный публичный репозиторий на github с произвольным именем.
```
> Ответ: https://github.com/olegnizamov/ansible-test
```
4. Скачайте [playbook](./playbook/) из репозитория с домашним заданием и перенесите его в свой репозиторий.
```
> Ответ: done
```


## Основная часть
1. Попробуйте запустить playbook на окружении из `test.yml`, зафиксируйте какое значение имеет факт `some_fact` для указанного хоста при выполнении playbook'a.
```
> Ответ: 
olegnizamov@olegnizamov:~/projects/devops-netology/08-ansible-01-base/src$ ansible-playbook site.yml -i inventory/test.yml 

PLAY [Print os facts] ************************************************************************************************************************************************************************************************************************************

TASK [Gathering Facts] ***********************************************************************************************************************************************************************************************************************************
ok: [localhost]

TASK [Print OS] ******************************************************************************************************************************************************************************************************************************************
ok: [localhost] => {
    "msg": "Ubuntu"
}

TASK [Print fact] ****************************************************************************************************************************************************************************************************************************************
ok: [localhost] => {
    "msg": 12
}

PLAY RECAP ***********************************************************************************************************************************************************************************************************************************************
localhost                  : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0  
```
2. Найдите файл с переменными (group_vars) в котором задаётся найденное в первом пункте значение и поменяйте его на 'all default fact'.
```
> Ответ:
group_vars/all/examp.yml - изменен
```
3. Воспользуйтесь подготовленным (используется `docker`) или создайте собственное окружение для проведения дальнейших испытаний.
```
> Ответ: https://github.com/olegnizamov/ansible-test/blob/master/docker-compose.yml
olegnizamov@olegnizamov:~/projects/devops-netology/08-ansible-01-base/src$ docker ps
CONTAINER ID   IMAGE                      COMMAND       CREATED         STATUS         PORTS     NAMES
14760fcf7d27   centos:7                   "/bin/bash"   5 seconds ago   Up 4 seconds             centos7
3765ea8c9d82   pycontribs/fedora:latest   "/bin/bash"   5 seconds ago   Up 4 seconds             fedora
b90c81afadbd   ubuntu2004py3              "bash"        5 seconds ago   Up 4 seconds             ubuntu

```
4. Проведите запуск playbook на окружении из `prod.yml`. Зафиксируйте полученные значения `some_fact` для каждого из `managed host`.
```
> Ответ: 
olegnizamov@olegnizamov:~/projects/devops-netology/08-ansible-01-base/src$ ansible-playbook site.yml -i inventory/prod.yml 

PLAY [Print os facts] ************************************************************************************************************************************************************************************************************************************

TASK [Gathering Facts] ***********************************************************************************************************************************************************************************************************************************
ok: [ubuntu]
ok: [centos7]

TASK [Print OS] ******************************************************************************************************************************************************************************************************************************************
ok: [centos7] => {
    "msg": "CentOS"
}
ok: [ubuntu] => {
    "msg": "Ubuntu"
}

TASK [Print fact] ****************************************************************************************************************************************************************************************************************************************
ok: [centos7] => {
    "msg": "el"
}
ok: [ubuntu] => {
    "msg": "deb"
}

PLAY RECAP ***********************************************************************************************************************************************************************************************************************************************
centos7                    : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
ubuntu                     : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   

```
5. Добавьте факты в `group_vars` каждой из групп хостов так, чтобы для `some_fact` получились следующие значения: для `deb` - 'deb default fact', для `el` - 'el default fact'.\
```
> Ответ:
DONE

```
6. Повторите запуск playbook на окружении `prod.yml`. Убедитесь, что выдаются корректные значения для всех хостов.
```
> Ответ:
olegnizamov@olegnizamov:~/projects/devops-netology/08-ansible-01-base/src$ ansible-playbook site.yml -i inventory/prod.yml 

PLAY [Print os facts] ************************************************************************************************************************************************************************************************************************************

TASK [Gathering Facts] ***********************************************************************************************************************************************************************************************************************************
ok: [ubuntu]
ok: [centos7]

TASK [Print OS] ******************************************************************************************************************************************************************************************************************************************
ok: [centos7] => {
    "msg": "CentOS"
}
ok: [ubuntu] => {
    "msg": "Ubuntu"
}

TASK [Print fact] ****************************************************************************************************************************************************************************************************************************************
ok: [centos7] => {
    "msg": "el default fact"
}
ok: [ubuntu] => {
    "msg": "deb default fact"
}

PLAY RECAP ***********************************************************************************************************************************************************************************************************************************************
centos7                    : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
ubuntu                     : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   

```
8. При помощи `ansible-vault` зашифруйте факты в `group_vars/deb` и `group_vars/el` с паролем `netology`.
```
> Ответ:
olegnizamov@olegnizamov:~/projects/devops-netology/08-ansible-01-base/src$ cat group_vars/{deb,el}/*
---
  some_fact: "deb default fact"---
  some_fact: "el default fact"
olegnizamov@olegnizamov:~/projects/devops-netology/08-ansible-01-base/src$ ansible-vault encrypt group_vars/{deb,el}/*
New Vault password: 
Confirm New Vault password: 
Encryption successful
olegnizamov@olegnizamov:~/projects/devops-netology/08-ansible-01-base/src$ cat group_vars/{deb,el}/*
$ANSIBLE_VAULT;1.1;AES256
39363535346466656362323763633264366230383532613663336665646530646637633836373561
3835666235373466303665613630353263636631373938330a323138313664303961383466343538
64353464616133666366343739376336313234653131633037393431303531643733373962303738
3635363832613064330a343733363930326664363436306464386438363637333264616164623339
39303435633731313934363039373832373561633664396531333562363333323635313237636535
3732383833373765323863326339653762393133396566386465
$ANSIBLE_VAULT;1.1;AES256
35653531386331663933643433656636323166343430623735396532663637303937313865386565
3730643363653333396632383731656131366530373237650a346437333762343965383130383164
65613030626530663462373563363232326533643634653366616537643435356131653231623136
3765663661333965660a313331333366343833616437313432663130306238653137613261393831
31616432383335323438666662636533326363636630623931643561653565353732356138353735
6566613065303233363633306465646132666635376638366233
```
9. Запустите playbook на окружении `prod.yml`. При запуске `ansible` должен запросить у вас пароль. Убедитесь в работоспособности.
```
> Ответ:
olegnizamov@olegnizamov:~/projects/devops-netology/08-ansible-01-base/src$ ansible-playbook site.yml -i inventory/prod.yml 

PLAY [Print os facts] ************************************************************************************************************************************************************************************************************************************
ERROR! Attempting to decrypt but no vault secrets found
olegnizamov@olegnizamov:~/projects/devops-netology/08-ansible-01-base/src$ ansible-playbook site.yml -i inventory/prod.yml --ask-vault-pass
Vault password: 

PLAY [Print os facts] ************************************************************************************************************************************************************************************************************************************

TASK [Gathering Facts] ***********************************************************************************************************************************************************************************************************************************
ok: [ubuntu]
ok: [centos7]

TASK [Print OS] ******************************************************************************************************************************************************************************************************************************************
ok: [centos7] => {
    "msg": "CentOS"
}
ok: [ubuntu] => {
    "msg": "Ubuntu"
}

TASK [Print fact] ****************************************************************************************************************************************************************************************************************************************
ok: [centos7] => {
    "msg": "el default fact"
}
ok: [ubuntu] => {
    "msg": "deb default fact"
}

PLAY RECAP ***********************************************************************************************************************************************************************************************************************************************
centos7                    : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
ubuntu                     : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   

olegnizamov@olegnizamov:~/projects/devops-netology/08-ansible-01-base/src$ 

```
10. Посмотрите при помощи `ansible-doc` список плагинов для подключения. Выберите подходящий для работы на `control node`.
```
> Ответ:
olegnizamov@olegnizamov:~/projects/devops-netology/08-ansible-01-base/src$ ansible-doc -t connection -l
buildah      Interact with an existing buildah container                                                                                                                                                                                             
chroot       Interact with local chroot                                                                                                                                                                                                              
docker       Run tasks in docker containers                                                                                                                                                                                                          
funcd        Use funcd to connect to target                                                                                                                                                                                                          
httpapi      Use httpapi to run command on network appliances                                                                                                                                                                                        
iocage       Run tasks in iocage jails                                                                                                                                                                                                               
jail         Run tasks in jails                                                                                                                                                                                                                      
kubectl      Execute tasks in pods running on Kubernetes                                                                                                                                                                                             
libvirt_lxc  Run tasks in lxc containers via libvirt                                                                                                                                                                                                 
local        execute on controller                                                                                                                                                                                                                   
lxc          Run tasks in lxc containers via lxc python library                                                                                                                                                                                      
lxd          Run tasks in lxc containers via lxc CLI                                                                                                                                                                                                 
napalm       Provides persistent connection using NAPALM                                                                                                                                                                                             
netconf      Provides a persistent connection using the netconf protocol                                                                                                                                                                             
network_cli  Use network_cli to run command on network appliances                                                                                                                                                                                    
oc           Execute tasks in pods running on OpenShift                                                                                                                                                                                              
paramiko_ssh Run tasks via python ssh (paramiko)                                                                                                                                                                                                     
persistent   Use a persistent unix socket for connection                                                                                                                                                                                             
podman       Interact with an existing podman container                                                                                                                                                                                              
psrp         Run tasks over Microsoft PowerShell Remoting Protocol                                                                                                                                                                                   
qubes        Interact with an existing QubesOS AppVM                                                                                                                                                                                                 
saltstack    Allow ansible to piggyback on salt minions                                                                                                                                                                                              
ssh          connect via ssh client binary                                                                                                                                                                                                           
vmware_tools Execute tasks inside a VM via VMware Tools                                                                                                                                                                                              
winrm        Run tasks over Microsoft's WinRM                                                                                                                                                                                                        
zone         Run tasks in a zone instance         
```
11. В `prod.yml` добавьте новую группу хостов с именем  `local`, в ней разместите localhost с необходимым типом подключения.
```
> Ответ:
---
  el:
    hosts:
      centos7:
        ansible_connection: docker
  deb:
    hosts:
      ubuntu:
        ansible_connection: docker
  localhost:
   hosts:
      localhost:
        ansible_connection: local
```
12. Запустите playbook на окружении `prod.yml`. При запуске `ansible` должен запросить у вас пароль. Убедитесь что факты `some_fact` для каждого из хостов определены из верных `group_vars`.
```
> Ответ:
olegnizamov@olegnizamov:~/projects/devops-netology/08-ansible-01-base/src$ ansible-playbook site.yml -i inventory/prod.yml --ask-vault-pass
Vault password: 
[WARNING]: Found both group and host with same name: localhost

PLAY [Print os facts] ************************************************************************************************************************************************************************************************************************************

TASK [Gathering Facts] ***********************************************************************************************************************************************************************************************************************************
ok: [ubuntu]
ok: [localhost]
ok: [centos7]

TASK [Print OS] ******************************************************************************************************************************************************************************************************************************************
ok: [localhost] => {
    "msg": "Ubuntu"
}
ok: [centos7] => {
    "msg": "CentOS"
}
ok: [ubuntu] => {
    "msg": "Ubuntu"
}

TASK [Print fact] ****************************************************************************************************************************************************************************************************************************************
ok: [localhost] => {
    "msg": "all default fact"
}
ok: [centos7] => {
    "msg": "el default fact"
}
ok: [ubuntu] => {
    "msg": "deb default fact"
}

PLAY RECAP ***********************************************************************************************************************************************************************************************************************************************
centos7                    : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
localhost                  : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
ubuntu                     : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   


```
14. Заполните `README.md` ответами на вопросы. Сделайте `git push` в ветку `master`. В ответе отправьте ссылку на ваш открытый репозиторий с изменённым `playbook` и заполненным `README.md`.
```
> Ответ:
```
## Необязательная часть

1. При помощи `ansible-vault` расшифруйте все зашифрованные файлы с переменными.
```
> Ответ:

```
2. Зашифруйте отдельное значение `PaSSw0rd` для переменной `some_fact` паролем `netology`. Добавьте полученное значение в `group_vars/all/exmp.yml`.
```
> Ответ:
olegnizamov@olegnizamov:~/projects/devops-netology/08-ansible-01-base/src$ ansible-vault decrypt group_vars/{deb,el}/*
Vault password: 
Decryption successful

```
3. Запустите `playbook`, убедитесь, что для нужных хостов применился новый `fact`.
```
> Ответ:
olegnizamov@olegnizamov:~/projects/devops-netology/08-ansible-01-base/src$ ansible-playbook site.yml -i inventory/prod.yml --ask-vault-pass
Vault password: 
[WARNING]: Found both group and host with same name: localhost

PLAY [Print os facts] ************************************************************************************************************************************************************************************************************************************

TASK [Gathering Facts] ***********************************************************************************************************************************************************************************************************************************
ok: [localhost]
ok: [ubuntu]
ok: [centos7]

TASK [Print OS] ******************************************************************************************************************************************************************************************************************************************
ok: [localhost] => {
    "msg": "Ubuntu"
}
ok: [centos7] => {
    "msg": "CentOS"
}
ok: [ubuntu] => {
    "msg": "Ubuntu"
}

TASK [Print fact] ****************************************************************************************************************************************************************************************************************************************
ok: [localhost] => {
    "msg": "PaSSw0rd"
}
ok: [centos7] => {
    "msg": "el default fact"
}
ok: [ubuntu] => {
    "msg": "deb default fact"
}

PLAY RECAP ***********************************************************************************************************************************************************************************************************************************************
centos7                    : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
localhost                  : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
ubuntu                     : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
```
4. Добавьте новую группу хостов `fedora`, самостоятельно придумайте для неё переменную. В качестве образа можно использовать [этот](https://hub.docker.com/r/pycontribs/fedora).
```
> Ответ:
olegnizamov@olegnizamov:~/projects/devops-netology/08-ansible-01-base/src$ ansible-playbook site.yml -i inventory/prod.yml --ask-vault-pass
Vault password: 
[WARNING]: Found both group and host with same name: localhost

PLAY [Print os facts] ************************************************************************************************************************************************************************************************************************************

TASK [Gathering Facts] ***********************************************************************************************************************************************************************************************************************************
ok: [localhost]
ok: [fedora]
ok: [ubuntu]
ok: [centos7]

TASK [Print OS] ******************************************************************************************************************************************************************************************************************************************
ok: [localhost] => {
    "msg": "Ubuntu"
}
ok: [centos7] => {
    "msg": "CentOS"
}
ok: [ubuntu] => {
    "msg": "Ubuntu"
}
ok: [fedora] => {
    "msg": "Fedora"
}

TASK [Print fact] ****************************************************************************************************************************************************************************************************************************************
ok: [localhost] => {
    "msg": "PaSSw0rd"
}
ok: [centos7] => {
    "msg": "el default fact"
}
ok: [ubuntu] => {
    "msg": "deb default fact"
}
ok: [fedora] => {
    "msg": "fed default fact"
}

PLAY RECAP ***********************************************************************************************************************************************************************************************************************************************
centos7                    : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
fedora                     : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
localhost                  : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
ubuntu                     : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   

```
6. Напишите скрипт на bash: автоматизируйте поднятие необходимых контейнеров, запуск ansible-playbook и остановку контейнеров.
```
> Ответ:
```
7. Все изменения должны быть зафиксированы и отправлены в вашей личный репозиторий.
```
> Ответ:
```
