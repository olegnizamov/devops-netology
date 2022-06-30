# Домашнее задание к занятию "7.2. Облачные провайдеры и синтаксис Terraform."

Зачастую разбираться в новых инструментах гораздо интересней понимая то, как они работают изнутри.
Поэтому в рамках первого *необязательного* задания предлагается завести свою учетную запись в AWS (Amazon Web Services) или Yandex.Cloud.
Идеально будет познакомится с обоими облаками, потому что они отличаются.

## Задача 1 (Вариант с Yandex.Cloud). Регистрация в ЯО и знакомство с основами (необязательно, но крайне желательно).

1. Подробная инструкция на русском языке содержится [здесь](https://cloud.yandex.ru/docs/solutions/infrastructure-management/terraform-quickstart).
2. Обратите внимание на период бесплатного использования после регистрации аккаунта.
3. Используйте раздел "Подготовьте облако к работе" для регистрации аккаунта. Далее раздел "Настройте провайдер" для подготовки
   базового терраформ конфига.
4. Воспользуйтесь [инструкцией](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs) на сайте терраформа, что бы
   не указывать авторизационный токен в коде, а терраформ провайдер брал его из переменных окружений.

## Задача 2. Создание aws ec2 или yandex_compute_instance через терраформ.

1. В каталоге `terraform` вашего основного репозитория, который был создан в начале курсе, создайте файл `main.tf` и `versions.tf`.
2. Зарегистрируйте провайдер
   1. либо для [yandex.cloud](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs). Подробную инструкцию можно найти
      [здесь](https://cloud.yandex.ru/docs/solutions/infrastructure-management/terraform-quickstart).
3. Внимание! В гит репозиторий нельзя пушить ваши личные ключи доступа к аккаунту. Поэтому в предыдущем задании мы указывали
   их в виде переменных окружения.
4. В файле `main.tf` воспользуйтесь блоком `data "aws_ami` для поиска ami образа последнего Ubuntu.
5. В файле `main.tf` создайте рессурс
    2. либо [yandex_compute_image](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/compute_image).
6. Также в случае использования aws:
   1. Добавьте data-блоки `aws_caller_identity` и `aws_region`.
   2. В файл `outputs.tf` поместить блоки `output` с данными об используемых в данный момент:
      * AWS account ID,
      * AWS user ID,
      * AWS регион, который используется в данный момент,
      * Приватный IP ec2 инстансы,
      * Идентификатор подсети в которой создан инстанс.
7. Если вы выполнили первый пункт, то добейтесь того, что бы команда `terraform plan` выполнялась без ошибок.

```
> Ответ:
Packer
```

В качестве результата задания предоставьте:
1. Ответ на вопрос: при помощи какого инструмента (из разобранных на прошлом занятии) можно создать свой образ ami?
```
> Ответ:
Packer
```
2. Ссылку на репозиторий с исходной конфигурацией терраформа.
[terraform](/terraform)
---

```
> Ответ:
olegnizamov@olegnizamov:~/projects/devops-netology/07-terraform-02-syntax/terraform$ terraform plan
data.yandex_compute_image.ubuntu: Reading...
data.yandex_compute_image.ubuntu: Read complete after 2s [id=fd8qps171vp141hl7g9l]

Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following symbols:
+ create

Terraform will perform the following actions:

# yandex_compute_instance.vm will be created
+ resource "yandex_compute_instance" "vm" {
   + created_at                = (known after apply)
   + folder_id                 = (known after apply)
   + fqdn                      = (known after apply)
   + hostname                  = "netology_virt_11_72.local"
   + id                        = (known after apply)
   + name                      = "netology-virt-11-72"
   + network_acceleration_type = "standard"
   + platform_id               = "standard-v1"
   + service_account_id        = (known after apply)
   + status                    = (known after apply)
   + zone                      = (known after apply)

   + boot_disk {
      + auto_delete = true
      + device_name = (known after apply)
      + disk_id     = (known after apply)
      + mode        = (known after apply)

      + initialize_params {
         + block_size  = (known after apply)
         + description = (known after apply)
         + image_id    = "fd8qps171vp141hl7g9l"
         + name        = (known after apply)
         + size        = 20
         + snapshot_id = (known after apply)
         + type        = "network-hdd"
           }
           }

   + network_interface {
      + index              = (known after apply)
      + ip_address         = (known after apply)
      + ipv4               = true
      + ipv6               = false
      + ipv6_address       = (known after apply)
      + mac_address        = (known after apply)
      + nat                = true
      + nat_ip_address     = (known after apply)
      + nat_ip_version     = (known after apply)
      + security_group_ids = (known after apply)
      + subnet_id          = (known after apply)
        }

   + placement_policy {
      + host_affinity_rules = (known after apply)
      + placement_group_id  = (known after apply)
        }

   + resources {
      + core_fraction = 100
      + cores         = 2
      + memory        = 2
        }

   + scheduling_policy {
      + preemptible = (known after apply)
        }
        }

# yandex_vpc_network.net will be created
+ resource "yandex_vpc_network" "net" {
   + created_at                = (known after apply)
   + default_security_group_id = (known after apply)
   + folder_id                 = (known after apply)
   + id                        = (known after apply)
   + labels                    = (known after apply)
   + name                      = "net"
   + subnet_ids                = (known after apply)
     }

# yandex_vpc_subnet.subnet will be created
+ resource "yandex_vpc_subnet" "subnet" {
   + created_at     = (known after apply)
   + folder_id      = (known after apply)
   + id             = (known after apply)
   + labels         = (known after apply)
   + name           = "subnet"
   + network_id     = (known after apply)
   + v4_cidr_blocks = [
      + "10.2.0.0/16",
        ]
   + v6_cidr_blocks = (known after apply)
   + zone           = "ru-central1-a"
     }

Plan: 3 to add, 0 to change, 0 to destroy.

Changes to Outputs:
+ yandex_ip_private = (known after apply)
+ yandex_vpc_subnet = (known after apply)
+ yandex_zone       = (known after apply)

──────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────

Note: You didn't use the -out option to save this plan, so Terraform can't guarantee to take exactly these actions if you run "terraform apply" now.
olegnizamov@olegnizamov:~/projects/devops-netology/07-terraform-02-syntax/terraform$ terraform apply -auto-approve
data.yandex_compute_image.ubuntu: Reading...
data.yandex_compute_image.ubuntu: Read complete after 2s [id=fd8qps171vp141hl7g9l]

Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following symbols:
+ create

Terraform will perform the following actions:

# yandex_compute_instance.vm will be created
+ resource "yandex_compute_instance" "vm" {
   + created_at                = (known after apply)
   + folder_id                 = (known after apply)
   + fqdn                      = (known after apply)
   + hostname                  = "netology_virt_11_72.local"
   + id                        = (known after apply)
   + metadata                  = {
      + "ssh-keys" = <<-EOT
        ubuntu:ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDlAWle5iLia1jAt1mCc0qGm5PSpuqMCNhG+nPVw/2UKbGxvg7mkz2grUEIhnGC5eTKaVM0nwSv8ZqT1To05zRm0jEjqfs0XYayjvmV49V+tGs5qfH/Kq0+w9J61RFeAsBVr1aQPBdJ246kWWPJlmt2w9gnx4MKvi00CHggmJeYL9aTOklzkkOv9xiLoiEZCmbehGRQNhuoNpEEoji9aXwUVSb888azVsyhqVJ5dvo/FyaaGWUI/9OmWMxhSoKhNw3sYNLnOAdbvFOYTRaJnhniuQSosDTxZ2v78DL4IaKahrYcHXMAV9fjkdjOZAQE8gOvK6CFT0xmiZLzqQC7tq3fD1DPT9b24l7/ZOrvsJaf2vQrdL2NQH6c8c8S76Yl2BEdMCot1zg3fxhzbnMOGG8IzxLSeVMJ4n/3IEFiGBCclDEYaDjWv4sWUDyAsCNbCt6vHKy4zTKT9DZ9PCubclwRdLaEs+rO4ybjiAzM/6rzMw86of5Mi7J60vUB42tcNEs= olegnizamov@olegnizamov
        EOT
        }
   + name                      = "netology-virt-11-72"
   + network_acceleration_type = "standard"
   + platform_id               = "standard-v1"
   + service_account_id        = (known after apply)
   + status                    = (known after apply)
   + zone                      = (known after apply)

   + boot_disk {
      + auto_delete = true
      + device_name = (known after apply)
      + disk_id     = (known after apply)
      + mode        = (known after apply)

      + initialize_params {
         + block_size  = (known after apply)
         + description = (known after apply)
         + image_id    = "fd8qps171vp141hl7g9l"
         + name        = (known after apply)
         + size        = 20
         + snapshot_id = (known after apply)
         + type        = "network-hdd"
           }
           }

   + network_interface {
      + index              = (known after apply)
      + ip_address         = (known after apply)
      + ipv4               = true
      + ipv6               = false
      + ipv6_address       = (known after apply)
      + mac_address        = (known after apply)
      + nat                = true
      + nat_ip_address     = (known after apply)
      + nat_ip_version     = (known after apply)
      + security_group_ids = (known after apply)
      + subnet_id          = (known after apply)
        }

   + placement_policy {
      + host_affinity_rules = (known after apply)
      + placement_group_id  = (known after apply)
        }

   + resources {
      + core_fraction = 100
      + cores         = 2
      + memory        = 2
        }

   + scheduling_policy {
      + preemptible = (known after apply)
        }
        }

# yandex_vpc_network.net will be created
+ resource "yandex_vpc_network" "net" {
   + created_at                = (known after apply)
   + default_security_group_id = (known after apply)
   + folder_id                 = (known after apply)
   + id                        = (known after apply)
   + labels                    = (known after apply)
   + name                      = "net"
   + subnet_ids                = (known after apply)
     }

# yandex_vpc_subnet.subnet will be created
+ resource "yandex_vpc_subnet" "subnet" {
   + created_at     = (known after apply)
   + folder_id      = (known after apply)
   + id             = (known after apply)
   + labels         = (known after apply)
   + name           = "subnet"
   + network_id     = (known after apply)
   + v4_cidr_blocks = [
      + "10.2.0.0/16",
        ]
   + v6_cidr_blocks = (known after apply)
   + zone           = "ru-central1-a"
     }

Plan: 3 to add, 0 to change, 0 to destroy.

Changes to Outputs:
+ yandex_ip_private = (known after apply)
+ yandex_vpc_subnet = (known after apply)
+ yandex_zone       = (known after apply)
  yandex_vpc_network.net: Creating...
  ╷
  │ Error: Error while requesting API to create network: server-request-id = ba10a3fc-9b90-4a27-a0fa-0be451a47e25 server-trace-id = 1afda0ab21b164fa:fa4fc87e5e0101aa:1afda0ab21b164fa:1 client-request-id = 0dbb9d4c-3451-4666-be6d-c759cdc34b75 client-trace-id = 2da7acc1-9f2b-43f0-990d-174979dd3b7c rpc error: code = PermissionDenied desc = Permission denied
  │
  │   with yandex_vpc_network.net,
  │   on main.tf line 12, in resource "yandex_vpc_network" "net":
  │   12: resource "yandex_vpc_network" "net" {
  │
  ╵
  olegnizamov@olegnizamov:~/projects/devops-netology/07-terraform-02-syntax/terraform$ terraform apply -auto-approve
  data.yandex_compute_image.ubuntu: Reading...
  data.yandex_compute_image.ubuntu: Read complete after 2s [id=fd8qps171vp141hl7g9l]

Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following symbols:
+ create

Terraform will perform the following actions:

# yandex_compute_instance.vm will be created
+ resource "yandex_compute_instance" "vm" {
   + created_at                = (known after apply)
   + folder_id                 = (known after apply)
   + fqdn                      = (known after apply)
   + hostname                  = "netology_virt_11_72.local"
   + id                        = (known after apply)
   + metadata                  = {
      + "ssh-keys" = <<-EOT
        ubuntu:ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDlAWle5iLia1jAt1mCc0qGm5PSpuqMCNhG+nPVw/2UKbGxvg7mkz2grUEIhnGC5eTKaVM0nwSv8ZqT1To05zRm0jEjqfs0XYayjvmV49V+tGs5qfH/Kq0+w9J61RFeAsBVr1aQPBdJ246kWWPJlmt2w9gnx4MKvi00CHggmJeYL9aTOklzkkOv9xiLoiEZCmbehGRQNhuoNpEEoji9aXwUVSb888azVsyhqVJ5dvo/FyaaGWUI/9OmWMxhSoKhNw3sYNLnOAdbvFOYTRaJnhniuQSosDTxZ2v78DL4IaKahrYcHXMAV9fjkdjOZAQE8gOvK6CFT0xmiZLzqQC7tq3fD1DPT9b24l7/ZOrvsJaf2vQrdL2NQH6c8c8S76Yl2BEdMCot1zg3fxhzbnMOGG8IzxLSeVMJ4n/3IEFiGBCclDEYaDjWv4sWUDyAsCNbCt6vHKy4zTKT9DZ9PCubclwRdLaEs+rO4ybjiAzM/6rzMw86of5Mi7J60vUB42tcNEs= olegnizamov@olegnizamov
        EOT
        }
   + name                      = "netology-virt-11-72"
   + network_acceleration_type = "standard"
   + platform_id               = "standard-v1"
   + service_account_id        = (known after apply)
   + status                    = (known after apply)
   + zone                      = (known after apply)

   + boot_disk {
      + auto_delete = true
      + device_name = (known after apply)
      + disk_id     = (known after apply)
      + mode        = (known after apply)

      + initialize_params {
         + block_size  = (known after apply)
         + description = (known after apply)
         + image_id    = "fd8qps171vp141hl7g9l"
         + name        = (known after apply)
         + size        = 20
         + snapshot_id = (known after apply)
         + type        = "network-hdd"
           }
           }

   + network_interface {
      + index              = (known after apply)
      + ip_address         = (known after apply)
      + ipv4               = true
      + ipv6               = false
      + ipv6_address       = (known after apply)
      + mac_address        = (known after apply)
      + nat                = true
      + nat_ip_address     = (known after apply)
      + nat_ip_version     = (known after apply)
      + security_group_ids = (known after apply)
      + subnet_id          = (known after apply)
        }

   + placement_policy {
      + host_affinity_rules = (known after apply)
      + placement_group_id  = (known after apply)
        }

   + resources {
      + core_fraction = 100
      + cores         = 2
      + memory        = 2
        }

   + scheduling_policy {
      + preemptible = (known after apply)
        }
        }

# yandex_vpc_network.net will be created
+ resource "yandex_vpc_network" "net" {
   + created_at                = (known after apply)
   + default_security_group_id = (known after apply)
   + folder_id                 = (known after apply)
   + id                        = (known after apply)
   + labels                    = (known after apply)
   + name                      = "net"
   + subnet_ids                = (known after apply)
     }

# yandex_vpc_subnet.subnet will be created
+ resource "yandex_vpc_subnet" "subnet" {
   + created_at     = (known after apply)
   + folder_id      = (known after apply)
   + id             = (known after apply)
   + labels         = (known after apply)
   + name           = "subnet"
   + network_id     = (known after apply)
   + v4_cidr_blocks = [
      + "10.2.0.0/16",
        ]
   + v6_cidr_blocks = (known after apply)
   + zone           = "ru-central1-a"
     }

Plan: 3 to add, 0 to change, 0 to destroy.

Changes to Outputs:
+ yandex_ip_private = (known after apply)
+ yandex_vpc_subnet = (known after apply)
+ yandex_zone       = (known after apply)
  yandex_vpc_network.net: Creating...
  yandex_vpc_network.net: Creation complete after 3s [id=enpno198a1m7h9frj1ap]
  yandex_vpc_subnet.subnet: Creating...
  yandex_vpc_subnet.subnet: Creation complete after 1s [id=e9bu7pi96ok3gt6l8i91]
  yandex_compute_instance.vm: Creating...
  yandex_compute_instance.vm: Still creating... [10s elapsed]
  yandex_compute_instance.vm: Still creating... [20s elapsed]
  yandex_compute_instance.vm: Creation complete after 28s [id=fhm2902n9shtsna1fgle]

Apply complete! Resources: 3 added, 0 changed, 0 destroyed.

Outputs:

yandex_ip_private = "10.2.0.23"
yandex_vpc_subnet = "e9bu7pi96ok3gt6l8i91"
yandex_zone = "ru-central1-a"
olegnizamov@olegnizamov:~/projects/devops-netology/07-terraform-02-syntax/terraform$ terraform destroy
data.yandex_compute_image.ubuntu: Reading...
yandex_vpc_network.net: Refreshing state... [id=enpno198a1m7h9frj1ap]
data.yandex_compute_image.ubuntu: Read complete after 2s [id=fd8qps171vp141hl7g9l]
yandex_vpc_subnet.subnet: Refreshing state... [id=e9bu7pi96ok3gt6l8i91]
yandex_compute_instance.vm: Refreshing state... [id=fhm2902n9shtsna1fgle]

Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following symbols:
- destroy

Terraform will perform the following actions:

# yandex_compute_instance.vm will be destroyed
- resource "yandex_compute_instance" "vm" {
   - created_at                = "2022-06-30T16:15:59Z" -> null
   - folder_id                 = "b1gvcj5c7qi25j81c8ob" -> null
   - fqdn                      = "netology_virt_11_72.local" -> null
   - hostname                  = "netology_virt_11_72" -> null
   - id                        = "fhm2902n9shtsna1fgle" -> null
   - labels                    = {} -> null
   - metadata                  = {
      - "ssh-keys" = <<-EOT
        ubuntu:ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDlAWle5iLia1jAt1mCc0qGm5PSpuqMCNhG+nPVw/2UKbGxvg7mkz2grUEIhnGC5eTKaVM0nwSv8ZqT1To05zRm0jEjqfs0XYayjvmV49V+tGs5qfH/Kq0+w9J61RFeAsBVr1aQPBdJ246kWWPJlmt2w9gnx4MKvi00CHggmJeYL9aTOklzkkOv9xiLoiEZCmbehGRQNhuoNpEEoji9aXwUVSb888azVsyhqVJ5dvo/FyaaGWUI/9OmWMxhSoKhNw3sYNLnOAdbvFOYTRaJnhniuQSosDTxZ2v78DL4IaKahrYcHXMAV9fjkdjOZAQE8gOvK6CFT0xmiZLzqQC7tq3fD1DPT9b24l7/ZOrvsJaf2vQrdL2NQH6c8c8S76Yl2BEdMCot1zg3fxhzbnMOGG8IzxLSeVMJ4n/3IEFiGBCclDEYaDjWv4sWUDyAsCNbCt6vHKy4zTKT9DZ9PCubclwRdLaEs+rO4ybjiAzM/6rzMw86of5Mi7J60vUB42tcNEs= olegnizamov@olegnizamov
        EOT
        } -> null
   - name                      = "netology-virt-11-72" -> null
   - network_acceleration_type = "standard" -> null
   - platform_id               = "standard-v1" -> null
   - status                    = "running" -> null
   - zone                      = "ru-central1-a" -> null

   - boot_disk {
      - auto_delete = true -> null
      - device_name = "fhms6b1dg9bh6s13emm5" -> null
      - disk_id     = "fhms6b1dg9bh6s13emm5" -> null
      - mode        = "READ_WRITE" -> null

      - initialize_params {
         - block_size = 4096 -> null
         - image_id   = "fd8qps171vp141hl7g9l" -> null
         - size       = 20 -> null
         - type       = "network-hdd" -> null
           }
           }

   - network_interface {
      - index              = 0 -> null
      - ip_address         = "10.2.0.23" -> null
      - ipv4               = true -> null
      - ipv6               = false -> null
      - mac_address        = "d0:0d:24:80:57:4f" -> null
      - nat                = true -> null
      - nat_ip_address     = "51.250.81.2" -> null
      - nat_ip_version     = "IPV4" -> null
      - security_group_ids = [] -> null
      - subnet_id          = "e9bu7pi96ok3gt6l8i91" -> null
        }

   - placement_policy {
      - host_affinity_rules = [] -> null
        }

   - resources {
      - core_fraction = 100 -> null
      - cores         = 2 -> null
      - gpus          = 0 -> null
      - memory        = 2 -> null
        }

   - scheduling_policy {
      - preemptible = false -> null
        }
        }

# yandex_vpc_network.net will be destroyed
- resource "yandex_vpc_network" "net" {
   - created_at = "2022-06-30T16:15:55Z" -> null
   - folder_id  = "b1gvcj5c7qi25j81c8ob" -> null
   - id         = "enpno198a1m7h9frj1ap" -> null
   - labels     = {} -> null
   - name       = "net" -> null
   - subnet_ids = [
      - "e9bu7pi96ok3gt6l8i91",
        ] -> null
        }

# yandex_vpc_subnet.subnet will be destroyed
- resource "yandex_vpc_subnet" "subnet" {
   - created_at     = "2022-06-30T16:15:57Z" -> null
   - folder_id      = "b1gvcj5c7qi25j81c8ob" -> null
   - id             = "e9bu7pi96ok3gt6l8i91" -> null
   - labels         = {} -> null
   - name           = "subnet" -> null
   - network_id     = "enpno198a1m7h9frj1ap" -> null
   - v4_cidr_blocks = [
      - "10.2.0.0/16",
        ] -> null
   - v6_cidr_blocks = [] -> null
   - zone           = "ru-central1-a" -> null
     }

Plan: 0 to add, 0 to change, 3 to destroy.

Changes to Outputs:
- yandex_ip_private = "10.2.0.23" -> null
- yandex_vpc_subnet = "e9bu7pi96ok3gt6l8i91" -> null
- yandex_zone       = "ru-central1-a" -> null

Do you really want to destroy all resources?
Terraform will destroy all your managed infrastructure, as shown above.
There is no undo. Only 'yes' will be accepted to confirm.

Enter a value: yes

yandex_compute_instance.vm: Destroying... [id=fhm2902n9shtsna1fgle]
yandex_compute_instance.vm: Still destroying... [id=fhm2902n9shtsna1fgle, 10s elapsed]
yandex_compute_instance.vm: Still destroying... [id=fhm2902n9shtsna1fgle, 20s elapsed]
yandex_compute_instance.vm: Destruction complete after 21s
yandex_vpc_subnet.subnet: Destroying... [id=e9bu7pi96ok3gt6l8i91]
yandex_vpc_subnet.subnet: Destruction complete after 5s
yandex_vpc_network.net: Destroying... [id=enpno198a1m7h9frj1ap]
yandex_vpc_network.net: Destruction complete after 1s

Destroy complete! Resources: 3 destroyed.
olegnizamov@olegnizamov:~/projects/devops-netology/07-terraform-02-syntax/terraform$ 
```