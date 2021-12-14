# devops-netology Низамов Олег


## Задание №1 – Ветвление, merge и rebase.

---

## 1. Подготовка

Для лучшей структуризации рабочего репозитория каталог `branching` был создан в каталоге `lesson4`. 
Внутри каталога созданы файлы `merge.sh` и `rebase.sh` с содержимым:

```shell position-relative overflow-auto
#!/bin/bash
# display command line options
count=1
for param in "$*"; do
    echo "\$* Parameter #$count = $param"
    count=$(( $count + 1 ))
done
```

Файлы отправлены в коммит с описанием `prepare for merge and rebase`

---

## 2. Подготовка файла `merge.sh`

* Создал ветку `git-merge` с помощью команды `checkout -b [name brach]`. Внес изменения в файл `merge.sh`, а именно заменил * на @. Создал коммит с названием `merge: @instead *` и запушил его в github c помощью команды `git push origin git-merge`.
* Внес изменения в файл `merge.sh` и создал коммит с названием `merge: use shift` и запушил его в github c помощью команды `git push origin git-merge`.

---

## 3. Изменение ветки `main`

* Переключился на ветку `main` и отредактировал файл `rebase.sh`. Добавил в коммит `main: edit rebase.sh` и запушил его с `git push origin main`.

---

## 4. Подготовка файла `rebase.sh`

* Переключился на коммит `prepare for merge and rebase` и создал ветку `git-rebase`. Использовал команду `git switch -c [name branch]`
* Внес изменения в `rebase.sh` и запушил коммит `git rebase 1`
* Внес изменения в `rebase.sh` и запушил коммит `git rebase 2`

---

## Промежуточный итог

[![](/img/1.PNG)](/img/1.PNG)
Так выглядит вкладка `network` в github после выполнения всех описанных действий. Ветка `fix` осталась после предыдущих домашних работ.

---

## 5. Rebase

* Переключаюсь на ветку `git-rebase` и выполняю `git rebase -i main` `-i` - интерактивный режим, где использую следующие комманды.

```shell position-relative overflow-auto
pick b6cc695 git-rebase 1
pick 34ecde4 git-rebase 2
```
*  и
```shell position-relative overflow-auto
error: could not apply b6cc695... git-rebase 1
Resolve all conflicts manually, mark them as resolved with
"git add/rm <conflicted_files>", then run "git rebase --continue".
You can instead skip this commit: run "git rebase --skip".
To abort and get back to the state before "git rebase", run "git rebase --abort".
Could not apply b6cc695... git-rebase 1
Auto-merging lesson4/branching/rebase.sh
CONFLICT (content): Merge conflict in lesson4/branching/rebase.sh
```

[![](/img/2.PNG)](/img/2PNG)
Так выглядит вкладка `network` в github после выполнения всех описанных действий. 
