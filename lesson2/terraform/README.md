Из отслеживания будут удалены следующие файлы:
1) Все папки .terraform и файлы внутри них. (**/.terraform/*)
2) *.tfstate    *.tfstate.* - файлы содержащие *.tfstate или *.tfstate.* как расширения
3) crash.log - файл в корне
4) все файлы формата *.tfvars
5) override.tf и override.tf.json - файлы в корне и *_override.tf и*_override.tf.json - файлы содержащие данные названия в корне
6) .terraformrc и terraform.rc файлы в корнке
