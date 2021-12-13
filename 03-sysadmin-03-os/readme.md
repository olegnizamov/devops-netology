# Домашнее задание к занятию "3.3. Операционные системы, лекция 1"

1. Какой системный вызов делает команда `cd`? В прошлом ДЗ мы выяснили, что `cd` не является самостоятельной программой,
   это `shell builtin`, поэтому запустить `strace` непосредственно на `cd` не получится. Тем не менее, вы можете
   запустить `strace` на `/bin/bash -c 'cd /tmp'`. В этом случае вы увидите полный список системных вызовов, которые
   делает сам `bash` при старте. Вам нужно найти тот единственный, который относится именно к `cd`. Обратите внимание,
   что `strace` выдаёт результат своей работы в поток stderr, а не в stdout.

> Ответ: strace /bin/bash -c 'cd /tmp' 2>&1 | grep /tmp
> execve("/bin/bash", ["/bin/bash", "-c", "cd /tmp"], 0x7ffd453af490 /* 24 vars */) = 0
> stat("/tmp", {st_mode=S_IFDIR|S_ISVTX|0777, st_size=4096, ...}) = 0
> chdir("/tmp")

2. Попробуйте использовать команду `file` на объекты разных типов на файловой системе. Например:

   ```shell position-relative overflow-auto
   vagrant@netology1:~$ file /dev/tty
   /dev/tty: character special (5/0)
   vagrant@netology1:~$ file /dev/sda
   /dev/sda: block special (8/0)
   vagrant@netology1:~$ file /bin/bash
   /bin/bash: ELF 64-bit LSB shared object, x86-64
   ```

   Используя `strace` выясните, где находится база данных `file` на основании которой она делает свои догадки.

> Ответ: Файл /usr/lib/file/magic.mgc
>
> ```bash
> $ strace file /dev/sda 2>&1
> $ strace file /dev/tty 2>&1
> ...
> openat(AT_FDCWD, "/usr/share/misc/magic.mgc", O_RDONLY) = 3
> ...
> $ ls -l /usr/share/misc/magic.mgc
> lrwxrwxrwx 1 root root 24 мая 27 09:47 /usr/share/misc/magic.mgc -> ../../lib/file/magic.mgc
> $ ls -l /usr/lib/file/magic.mgc
> -rw-r--r-- 1 root root 5811536 янв 17  2020 /usr/lib/file/magic.mgc
> ```

3. Предположим, приложение пишет лог в текстовый файл. Этот файл оказался удален (deleted в lsof), однако возможности
   сигналом сказать приложению переоткрыть файлы или просто перезапустить приложение – нет. Так как приложение
   продолжает писать в удаленный файл, место на диске постепенно заканчивается. Основываясь на знаниях о перенаправлении
   потоков предложите способ обнуления открытого удаленного файла (чтобы освободить место на файловой системе).

> Ответ:
> Запустил команду ping с выводом в текстовый файл:
> vagrant@vagrant:~$ ping google.com >1.txt
> Узнаем PID процесса ping:
> vagrant@vagrant:~$ top | grep ping
> Tasks: 123 total,   1 running, 122 sleeping,   0 stopped,   0 zombie
> 2374 vagrant   20   0    9808   2672   2488 S   0.3   0.1   0:00.01 ping
> Удаляем файл 1.txt куда выводится результаты ping
> vagrant@vagrant:~$ rm 1.txt
> Узнаем файловый дескриптор процесса:
> vagrant@vagrant:~$  sudo lsof -p 2374
> ping    2374 vagrant  cwd    DIR  253,0     4096 268889 /home/vagrant/test
> ping    2374 vagrant  rtd    DIR  253,0     4096      2 /
> ping    2374 vagrant  txt    REG  253,0    72776 524524 /usr/bin/ping
> ping    2374 vagrant  mem    REG  253,0    31176 527441 /usr/lib/x86_64-linux-gnu/libnss_dns-2.31.so
> ping    2374 vagrant  mem    REG  253,0    51832 527442 /usr/lib/x86_64-linux-gnu/libnss_files-2.31.so
> ping    2374 vagrant  mem    REG  253,0  5699248 535133 /usr/lib/locale/locale-archive
> ping    2374 vagrant  mem    REG  253,0   137584 527268 /usr/lib/x86_64-linux-gnu/libgpg-error.so.0.28.0
> ping    2374 vagrant  mem    REG  253,0  2029224 527432 /usr/lib/x86_64-linux-gnu/libc-2.31.so
> ping    2374 vagrant  mem    REG  253,0   101320 527451 /usr/lib/x86_64-linux-gnu/libresolv-2.31.so
> ping    2374 vagrant  mem    REG  253,0  1168056 527252 /usr/lib/x86_64-linux-gnu/libgcrypt.so.20.2.5
> ping    2374 vagrant  mem    REG  253,0    31120 527208 /usr/lib/x86_64-linux-gnu/libcap.so.2.32
> ping    2374 vagrant  mem    REG  253,0   191472 527389 /usr/lib/x86_64-linux-gnu/ld-2.31.so
> ping    2374 vagrant    0u   CHR  136,1      0t0      4 /dev/pts/1
> ping    2374 vagrant    1w   REG  253,0     3916 268890 /home/vagrant/test/1.txt (deleted)
> ping    2374 vagrant    2u   CHR  136,1      0t0      4 /dev/pts/1
> ping    2374 vagrant    3u  icmp             0t0  37012 00000000:0005->00000000:0000
> ping    2374 vagrant    4u  sock    0,9      0t0  37013 protocol: PINGv6
> Пробую вывести пустую строчку в файловый дескриптор:
> vagrant@vagrant:~$ echo '' >/proc/2374/fd/1
> -bash: /proc/2374/fd/1: Permission denied
> Захожу с правами root:
> sudo su
> root@vagrant:/home/vagrant# echo '' >/proc/2374/fd/1

4. Занимают ли зомби-процессы какие-то ресурсы в ОС (CPU, RAM, IO)?

> Ответ: Проце́сс-зо́мби, зо́мби (англ. zombie process, англ. defunct process) — дочерний процесс в Unix-системе, завершивший своё выполнение, но ещё присутствующий в списке процессов операционной системы, чтобы дать родительскому процессу считать код завершения.
> Зомби не занимают памяти (как процессы-сироты), но блокируют записи в таблице процессов, размер которой ограничен для каждого пользователя и системы в целом.

5. В iovisor BCC есть утилита `opensnoop`:

   ```shell position-relative overflow-auto
   root@vagrant:~# dpkg -L bpfcc-tools | grep sbin/opensnoop
   /usr/sbin/opensnoop-bpfcc
   ```

   На какие файлы вы увидели вызовы группы `open` за первую секунду работы утилиты? Воспользуйтесь пакетом `bpfcc-tools`
   для Ubuntu 20.04. Дополнительные [сведения по установке](https://github.com/iovisor/bcc/blob/master/INSTALL.md).о

> Ответ:
> sudo apt-get install bpfcc-tools
> strace opensnoop-bpfcc 2>&1 | grep openat
> openat(AT_FDCWD, "/etc/ld.so.cache", O_RDONLY|O_CLOEXEC) = 3
> openat(AT_FDCWD, "/lib/x86_64-linux-gnu/libc.so.6", O_RDONLY|O_CLOEXEC) = 3
> openat(AT_FDCWD, "/lib/x86_64-linux-gnu/libpthread.so.0", O_RDONLY|O_CLOEXEC) = 3
> openat(AT_FDCWD, "/lib/x86_64-linux-gnu/libdl.so.2", O_RDONLY|O_CLOEXEC) = 3
> openat(AT_FDCWD, "/lib/x86_64-linux-gnu/libutil.so.1", O_RDONLY|O_CLOEXEC) = 3
> openat(AT_FDCWD, "/lib/x86_64-linux-gnu/libm.so.6", O_RDONLY|O_CLOEXEC) = 3
> openat(AT_FDCWD, "/lib/x86_64-linux-gnu/libexpat.so.1", O_RDONLY|O_CLOEXEC) = 3
> openat(AT_FDCWD, "/lib/x86_64-linux-gnu/libz.so.1", O_RDONLY|O_CLOEXEC) = 3
> openat(AT_FDCWD, "/usr/lib/locale/locale-archive", O_RDONLY|O_CLOEXEC) = 3
> openat(AT_FDCWD, "/usr/lib/x86_64-linux-gnu/gconv/gconv-modules.cache", O_RDONLY) = 3
> openat(AT_FDCWD, "/usr/bin/pyvenv.cfg", O_RDONLY) = -1 ENOENT (No such file or directory)
> openat(AT_FDCWD, "/usr/pyvenv.cfg", O_RDONLY) = -1 ENOENT (No such file or directory)
> openat(AT_FDCWD, "/etc/localtime", O_RDONLY|O_CLOEXEC) = 3
> openat(AT_FDCWD, "/usr/lib/python3.8", O_RDONLY|O_NONBLOCK|O_CLOEXEC|O_DIRECTORY) = 3
> openat(AT_FDCWD, "/usr/lib/python3.8/encodings/__pycache__/__init__.cpython-38.pyc", O_RDONLY|O_CLOEXEC) = 3
> openat(AT_FDCWD, "/usr/lib/python3.8/__pycache__/codecs.cpython-38.pyc", O_RDONLY|O_CLOEXEC) = 3
> openat(AT_FDCWD, "/usr/lib/python3.8/encodings", O_RDONLY|O_NONBLOCK|O_CLOEXEC|O_DIRECTORY) = 3
> openat(AT_FDCWD, "/usr/lib/python3.8/encodings/__pycache__/aliases.cpython-38.pyc", O_RDONLY|O_CLOEXEC) = 3
> openat(AT_FDCWD, "/usr/lib/python3.8/encodings/__pycache__/utf_8.cpython-38.pyc", O_RDONLY|O_CLOEXEC) = 3
> openat(AT_FDCWD, "/usr/lib/python3.8/encodings/__pycache__/latin_1.cpython-38.pyc", O_RDONLY|O_CLOEXEC) = 3
> openat(AT_FDCWD, "/usr/lib/python3.8/__pycache__/io.cpython-38.pyc", O_RDONLY|O_CLOEXEC) = 3
> openat(AT_FDCWD, "/usr/lib/python3.8/__pycache__/abc.cpython-38.pyc", O_RDONLY|O_CLOEXEC) = 3
> openat(AT_FDCWD, "/usr/lib/python3.8/__pycache__/site.cpython-38.pyc", O_RDONLY|O_CLOEXEC) = 3
> openat(AT_FDCWD, "/usr/lib/python3.8/__pycache__/os.cpython-38.pyc", O_RDONLY|O_CLOEXEC) = 3
> openat(AT_FDCWD, "/usr/lib/python3.8/__pycache__/stat.cpython-38.pyc", O_RDONLY|O_CLOEXEC) = 3
> openat(AT_FDCWD, "/usr/lib/python3.8/__pycache__/_collections_abc.cpython-38.pyc", O_RDONLY|O_CLOEXEC) = 3
> openat(AT_FDCWD, "/usr/lib/python3.8/__pycache__/posixpath.cpython-38.pyc", O_RDONLY|O_CLOEXEC) = 3
> openat(AT_FDCWD, "/usr/lib/python3.8/__pycache__/genericpath.cpython-38.pyc", O_RDONLY|O_CLOEXEC) = 3
> openat(AT_FDCWD, "/usr/lib/python3.8/__pycache__/_sitebuiltins.cpython-38.pyc", O_RDONLY|O_CLOEXEC) = 3
> openat(AT_FDCWD, "/usr/local/lib/python3.8/dist-packages", O_RDONLY|O_NONBLOCK|O_CLOEXEC|O_DIRECTORY) = 3
> openat(AT_FDCWD, "/usr/lib/python3/dist-packages", O_RDONLY|O_NONBLOCK|O_CLOEXEC|O_DIRECTORY) = 3
> openat(AT_FDCWD, "/usr/lib/python3/dist-packages/zope.interface-4.7.1-nspkg.pth", O_RDONLY|O_CLOEXEC) = 3
> openat(AT_FDCWD, "/usr/lib/python3.8/__pycache__/_bootlocale.cpython-38.pyc", O_RDONLY|O_CLOEXEC) = 4
> openat(AT_FDCWD, "/usr/lib/python3.8/__pycache__/types.cpython-38.pyc", O_RDONLY|O_CLOEXEC) = 4
> openat(AT_FDCWD, "/usr/lib/python3.8/importlib/__pycache__/__init__.cpython-38.pyc", O_RDONLY|O_CLOEXEC) = 4
> openat(AT_FDCWD, "/usr/lib/python3.8/__pycache__/warnings.cpython-38.pyc", O_RDONLY|O_CLOEXEC) = 4
> openat(AT_FDCWD, "/usr/lib/python3.8/importlib", O_RDONLY|O_NONBLOCK|O_CLOEXEC|O_DIRECTORY) = 4
> openat(AT_FDCWD, "/usr/lib/python3.8/importlib/__pycache__/util.cpython-38.pyc", O_RDONLY|O_CLOEXEC) = 4
> openat(AT_FDCWD, "/usr/lib/python3.8/importlib/__pycache__/abc.cpython-38.pyc", O_RDONLY|O_CLOEXEC) = 4
> openat(AT_FDCWD, "/usr/lib/python3.8/importlib/__pycache__/machinery.cpython-38.pyc", O_RDONLY|O_CLOEXEC) = 4
> openat(AT_FDCWD, "/usr/lib/python3.8/__pycache__/contextlib.cpython-38.pyc", O_RDONLY|O_CLOEXEC) = 4
> openat(AT_FDCWD, "/usr/lib/python3.8/collections/__pycache__/__init__.cpython-38.pyc", O_RDONLY|O_CLOEXEC) = 4
> openat(AT_FDCWD, "/usr/lib/python3.8/__pycache__/operator.cpython-38.pyc", O_RDONLY|O_CLOEXEC) = 4
> openat(AT_FDCWD, "/usr/lib/python3.8/__pycache__/keyword.cpython-38.pyc", O_RDONLY|O_CLOEXEC) = 4
> openat(AT_FDCWD, "/usr/lib/python3.8/__pycache__/heapq.cpython-38.pyc", O_RDONLY|O_CLOEXEC) = 4
> openat(AT_FDCWD, "/usr/lib/python3.8/__pycache__/reprlib.cpython-38.pyc", O_RDONLY|O_CLOEXEC) = 4
> openat(AT_FDCWD, "/usr/lib/python3.8/__pycache__/functools.cpython-38.pyc", O_RDONLY|O_CLOEXEC) = 4
> openat(AT_FDCWD, "/usr/lib/python3/dist-packages", O_RDONLY|O_NONBLOCK|O_CLOEXEC|O_DIRECTORY) = 4
> openat(AT_FDCWD, "/usr/lib/python3.8/__pycache__/sitecustomize.cpython-38.pyc", O_RDONLY|O_CLOEXEC) = 3
> openat(AT_FDCWD, "/usr/lib/python3.8/lib-dynload", O_RDONLY|O_NONBLOCK|O_CLOEXEC|O_DIRECTORY) = 3
> openat(AT_FDCWD, "/usr/local/lib/python3.8/dist-packages", O_RDONLY|O_NONBLOCK|O_CLOEXEC|O_DIRECTORY) = 3
> openat(AT_FDCWD, "/usr/lib/python3/dist-packages/__pycache__/apport_python_hook.cpython-38.pyc", O_RDONLY|O_CLOEXEC) = 3
> openat(AT_FDCWD, "/usr/sbin/opensnoop-bpfcc", O_RDONLY|O_CLOEXEC) = 3
> openat(AT_FDCWD, "/usr/sbin/opensnoop-bpfcc", O_RDONLY) = 3
> openat(AT_FDCWD, "/usr/sbin", O_RDONLY|O_NONBLOCK|O_CLOEXEC|O_DIRECTORY) = 3
> openat(AT_FDCWD, "/usr/lib/python3.8/__pycache__/__future__.cpython-38.pyc", O_RDONLY|O_CLOEXEC) = 3
> openat(AT_FDCWD, "/usr/lib/python3/dist-packages/bcc/__pycache__/__init__.cpython-38.pyc", O_RDONLY|O_CLOEXEC) = 3
> openat(AT_FDCWD, "/usr/lib/python3.8/ctypes/__pycache__/__init__.cpython-38.pyc", O_RDONLY|O_CLOEXEC) = 3
> openat(AT_FDCWD, "/usr/lib/python3.8/lib-dynload/_ctypes.cpython-38-x86_64-linux-gnu.so", O_RDONLY|O_CLOEXEC) = 3
> openat(AT_FDCWD, "/etc/ld.so.cache", O_RDONLY|O_CLOEXEC) = 3
> openat(AT_FDCWD, "/lib/x86_64-linux-gnu/libffi.so.7", O_RDONLY|O_CLOEXEC) = 3
> openat(AT_FDCWD, "/usr/lib/python3.8/__pycache__/struct.cpython-38.pyc", O_RDONLY|O_CLOEXEC) = 3
> openat(AT_FDCWD, "/usr/lib/python3.8/ctypes", O_RDONLY|O_NONBLOCK|O_CLOEXEC|O_DIRECTORY) = 3
> openat(AT_FDCWD, "/usr/lib/python3.8/ctypes/__pycache__/_endian.cpython-38.pyc", O_RDONLY|O_CLOEXEC) = 3
> openat(AT_FDCWD, "/usr/lib/python3.8/json/__pycache__/__init__.cpython-38.pyc", O_RDONLY|O_CLOEXEC) = 3
> openat(AT_FDCWD, "/usr/lib/python3.8/json", O_RDONLY|O_NONBLOCK|O_CLOEXEC|O_DIRECTORY) = 3
> openat(AT_FDCWD, "/usr/lib/python3.8/json/__pycache__/decoder.cpython-38.pyc", O_RDONLY|O_CLOEXEC) = 3
> openat(AT_FDCWD, "/usr/lib/python3.8/__pycache__/re.cpython-38.pyc", O_RDONLY|O_CLOEXEC) = 3
> openat(AT_FDCWD, "/usr/lib/python3.8/__pycache__/enum.cpython-38.pyc", O_RDONLY|O_CLOEXEC) = 3
> openat(AT_FDCWD, "/usr/lib/python3.8/__pycache__/sre_compile.cpython-38.pyc", O_RDONLY|O_CLOEXEC) = 3
> openat(AT_FDCWD, "/usr/lib/python3.8/__pycache__/sre_parse.cpython-38.pyc", O_RDONLY|O_CLOEXEC) = 3
> openat(AT_FDCWD, "/usr/lib/python3.8/__pycache__/sre_constants.cpython-38.pyc", O_RDONLY|O_CLOEXEC) = 3
> openat(AT_FDCWD, "/usr/lib/python3.8/__pycache__/copyreg.cpython-38.pyc", O_RDONLY|O_CLOEXEC) = 3
> openat(AT_FDCWD, "/usr/lib/python3.8/json/__pycache__/scanner.cpython-38.pyc", O_RDONLY|O_CLOEXEC) = 3
> openat(AT_FDCWD, "/usr/lib/python3.8/lib-dynload/_json.cpython-38-x86_64-linux-gnu.so", O_RDONLY|O_CLOEXEC) = 3
> openat(AT_FDCWD, "/usr/lib/python3.8/json/__pycache__/encoder.cpython-38.pyc", O_RDONLY|O_CLOEXEC) = 3
> openat(AT_FDCWD, "/usr/lib/python3/dist-packages/bcc", O_RDONLY|O_NONBLOCK|O_CLOEXEC|O_DIRECTORY) = 3
> openat(AT_FDCWD, "/usr/lib/python3/dist-packages/bcc/__pycache__/libbcc.cpython-38.pyc", O_RDONLY|O_CLOEXEC) = 3
> openat(AT_FDCWD, "/etc/ld.so.cache", O_RDONLY|O_CLOEXEC) = 3
> openat(AT_FDCWD, "/lib/x86_64-linux-gnu/libbcc.so.0", O_RDONLY|O_CLOEXEC) = 3
> openat(AT_FDCWD, "/lib/x86_64-linux-gnu/libelf.so.1", O_RDONLY|O_CLOEXEC) = 3
> openat(AT_FDCWD, "/lib/x86_64-linux-gnu/libtinfo.so.6", O_RDONLY|O_CLOEXEC) = 3
> openat(AT_FDCWD, "/lib/x86_64-linux-gnu/libgcc_s.so.1", O_RDONLY|O_CLOEXEC) = 3
> openat(AT_FDCWD, "/proc/cpuinfo", O_RDONLY|O_CLOEXEC) = 3
> openat(AT_FDCWD, "/usr/lib/python3/dist-packages/bcc/__pycache__/table.cpython-38.pyc", O_RDONLY|O_CLOEXEC) = 3
> openat(AT_FDCWD, "/usr/lib/python3.8/multiprocessing/__pycache__/__init__.cpython-38.pyc", O_RDONLY|O_CLOEXEC) = 3
> openat(AT_FDCWD, "/usr/lib/python3.8/multiprocessing", O_RDONLY|O_NONBLOCK|O_CLOEXEC|O_DIRECTORY) = 3
> openat(AT_FDCWD, "/usr/lib/python3.8/multiprocessing/__pycache__/context.cpython-38.pyc", O_RDONLY|O_CLOEXEC) = 3
> openat(AT_FDCWD, "/usr/lib/python3.8/__pycache__/threading.cpython-38.pyc", O_RDONLY|O_CLOEXEC) = 3
> openat(AT_FDCWD, "/usr/lib/python3.8/__pycache__/_weakrefset.cpython-38.pyc", O_RDONLY|O_CLOEXEC) = 3
> openat(AT_FDCWD, "/usr/lib/python3.8/multiprocessing/__pycache__/process.cpython-38.pyc", O_RDONLY|O_CLOEXEC) = 3
> openat(AT_FDCWD, "/usr/lib/python3.8/__pycache__/signal.cpython-38.pyc", O_RDONLY|O_CLOEXEC) = 3
> openat(AT_FDCWD, "/usr/lib/python3.8/multiprocessing/__pycache__/reduction.cpython-38.pyc", O_RDONLY|O_CLOEXEC) = 3
> openat(AT_FDCWD, "/usr/lib/python3.8/__pycache__/pickle.cpython-38.pyc", O_RDONLY|O_CLOEXEC) = 3
> openat(AT_FDCWD, "/usr/lib/python3.8/__pycache__/_compat_pickle.cpython-38.pyc", O_RDONLY|O_CLOEXEC) = 3
> openat(AT_FDCWD, "/usr/lib/python3.8/__pycache__/socket.cpython-38.pyc", O_RDONLY|O_CLOEXEC) = 3
> openat(AT_FDCWD, "/usr/lib/python3.8/__pycache__/selectors.cpython-38.pyc", O_RDONLY|O_CLOEXEC) = 3
> openat(AT_FDCWD, "/usr/lib/python3.8/collections", O_RDONLY|O_NONBLOCK|O_CLOEXEC|O_DIRECTORY) = 3
> openat(AT_FDCWD, "/usr/lib/python3.8/collections/__pycache__/abc.cpython-38.pyc", O_RDONLY|O_CLOEXEC) = 3
> openat(AT_FDCWD, "/usr/lib/python3/dist-packages/bcc/__pycache__/perf.cpython-38.pyc", O_RDONLY|O_CLOEXEC) = 3
> openat(AT_FDCWD, "/usr/lib/python3/dist-packages/bcc/__pycache__/utils.cpython-38.pyc", O_RDONLY|O_CLOEXEC) = 3
> openat(AT_FDCWD, "/usr/lib/python3.8/__pycache__/traceback.cpython-38.pyc", O_RDONLY|O_CLOEXEC) = 3
> openat(AT_FDCWD, "/usr/lib/python3.8/__pycache__/linecache.cpython-38.pyc", O_RDONLY|O_CLOEXEC) = 3
> openat(AT_FDCWD, "/usr/lib/python3.8/__pycache__/tokenize.cpython-38.pyc", O_RDONLY|O_CLOEXEC) = 3
> openat(AT_FDCWD, "/usr/lib/python3.8/__pycache__/token.cpython-38.pyc", O_RDONLY|O_CLOEXEC) = 3
> openat(AT_FDCWD, "/usr/lib/python3.8/__pycache__/subprocess.cpython-38.pyc", O_RDONLY|O_CLOEXEC) = 3
> openat(AT_FDCWD, "/usr/lib/python3/dist-packages/bcc/__pycache__/version.cpython-38.pyc", O_RDONLY|O_CLOEXEC) = 3
> openat(AT_FDCWD, "/usr/lib/python3/dist-packages/bcc/__pycache__/disassembler.cpython-38.pyc", O_RDONLY|O_CLOEXEC) = 3
> openat(AT_FDCWD, "/etc/ld.so.cache", O_RDONLY|O_CLOEXEC) = 3
> openat(AT_FDCWD, "/lib/x86_64-linux-gnu/librt.so.1", O_RDONLY|O_CLOEXEC) = 3
> openat(AT_FDCWD, "/usr/lib/python3/dist-packages/bcc/__pycache__/usdt.cpython-38.pyc", O_RDONLY|O_CLOEXEC) = 3
> openat(AT_FDCWD, "/usr/lib/python3.8/__pycache__/argparse.cpython-38.pyc", O_RDONLY|O_CLOEXEC) = 3
> openat(AT_FDCWD, "/usr/lib/python3.8/__pycache__/gettext.cpython-38.pyc", O_RDONLY|O_CLOEXEC) = 3
> openat(AT_FDCWD, "/usr/lib/python3.8/__pycache__/locale.cpython-38.pyc", O_RDONLY|O_CLOEXEC) = 3
> openat(AT_FDCWD, "/usr/lib/python3.8/__pycache__/datetime.cpython-38.pyc", O_RDONLY|O_CLOEXEC) = 3
> openat(AT_FDCWD, "/usr/lib/python3.8/__pycache__/shutil.cpython-38.pyc", O_RDONLY|O_CLOEXEC) = 3
> openat(AT_FDCWD, "/usr/lib/python3.8/__pycache__/fnmatch.cpython-38.pyc", O_RDONLY|O_CLOEXEC) = 3
> openat(AT_FDCWD, "/usr/lib/python3.8/__pycache__/bz2.cpython-38.pyc", O_RDONLY|O_CLOEXEC) = 3
> openat(AT_FDCWD, "/usr/lib/python3.8/__pycache__/_compression.cpython-38.pyc", O_RDONLY|O_CLOEXEC) = 3
> openat(AT_FDCWD, "/usr/lib/python3.8/lib-dynload/_bz2.cpython-38-x86_64-linux-gnu.so", O_RDONLY|O_CLOEXEC) = 3
> openat(AT_FDCWD, "/etc/ld.so.cache", O_RDONLY|O_CLOEXEC) = 3
> openat(AT_FDCWD, "/lib/x86_64-linux-gnu/libbz2.so.1.0", O_RDONLY|O_CLOEXEC) = 3
> openat(AT_FDCWD, "/usr/lib/python3.8/__pycache__/lzma.cpython-38.pyc", O_RDONLY|O_CLOEXEC) = 3
> openat(AT_FDCWD, "/usr/lib/python3.8/lib-dynload/_lzma.cpython-38-x86_64-linux-gnu.so", O_RDONLY|O_CLOEXEC) = 3
> openat(AT_FDCWD, "/etc/ld.so.cache", O_RDONLY|O_CLOEXEC) = 3
> openat(AT_FDCWD, "/lib/x86_64-linux-gnu/liblzma.so.5", O_RDONLY|O_CLOEXEC) = 3
> openat(AT_FDCWD, "/usr/lib/python3/dist-packages/apt_pkg.cpython-38-x86_64-linux-gnu.so", O_RDONLY|O_CLOEXEC) = 3
> openat(AT_FDCWD, "/etc/ld.so.cache", O_RDONLY|O_CLOEXEC) = 3
> openat(AT_FDCWD, "/lib/x86_64-linux-gnu/libapt-pkg.so.6.0", O_RDONLY|O_CLOEXEC) = 3
> openat(AT_FDCWD, "/lib/x86_64-linux-gnu/libstdc++.so.6", O_RDONLY|O_CLOEXEC) = 3
> openat(AT_FDCWD, "/lib/x86_64-linux-gnu/libresolv.so.2", O_RDONLY|O_CLOEXEC) = 3
> openat(AT_FDCWD, "/lib/x86_64-linux-gnu/liblz4.so.1", O_RDONLY|O_CLOEXEC) = 3
> openat(AT_FDCWD, "/lib/x86_64-linux-gnu/libzstd.so.1", O_RDONLY|O_CLOEXEC) = 3
> openat(AT_FDCWD, "/lib/x86_64-linux-gnu/libudev.so.1", O_RDONLY|O_CLOEXEC) = 3
> openat(AT_FDCWD, "/lib/x86_64-linux-gnu/libsystemd.so.0", O_RDONLY|O_CLOEXEC) = 3
> openat(AT_FDCWD, "/lib/x86_64-linux-gnu/libgcrypt.so.20", O_RDONLY|O_CLOEXEC) = 3
> openat(AT_FDCWD, "/lib/x86_64-linux-gnu/libgpg-error.so.0", O_RDONLY|O_CLOEXEC) = 3
> openat(AT_FDCWD, "/etc/default/apport", O_RDONLY|O_CLOEXEC) = 3
> openat(AT_FDCWD, "/usr/lib/python3/dist-packages/apport/__pycache__/__init__.cpython-38.pyc", O_RDONLY|O_CLOEXEC) = 3
> openat(AT_FDCWD, "/usr/lib/python3/dist-packages/apport", O_RDONLY|O_NONBLOCK|O_CLOEXEC|O_DIRECTORY) = 3
> openat(AT_FDCWD, "/usr/lib/python3/dist-packages/apport/__pycache__/report.cpython-38.pyc", O_RDONLY|O_CLOEXEC) = 3
> openat(AT_FDCWD, "/usr/lib/python3.8/__pycache__/tempfile.cpython-38.pyc", O_RDONLY|O_CLOEXEC) = 3
> openat(AT_FDCWD, "/usr/lib/python3.8/__pycache__/random.cpython-38.pyc", O_RDONLY|O_CLOEXEC) = 3
> openat(AT_FDCWD, "/usr/lib/python3.8/__pycache__/bisect.cpython-38.pyc", O_RDONLY|O_CLOEXEC) = 3
> openat(AT_FDCWD, "/usr/lib/python3.8/__pycache__/weakref.cpython-38.pyc", O_RDONLY|O_CLOEXEC) = 3
> openat(AT_FDCWD, "/usr/lib/python3.8/__pycache__/glob.cpython-38.pyc", O_RDONLY|O_CLOEXEC) = 3
> openat(AT_FDCWD, "/usr/lib/python3.8/__pycache__/imp.cpython-38.pyc", O_RDONLY|O_CLOEXEC) = 3
> openat(AT_FDCWD, "/usr/lib/python3.8/xml/__pycache__/__init__.cpython-38.pyc", O_RDONLY|O_CLOEXEC) = 3
> openat(AT_FDCWD, "/usr/lib/python3.8/xml", O_RDONLY|O_NONBLOCK|O_CLOEXEC|O_DIRECTORY) = 3
> openat(AT_FDCWD, "/usr/lib/python3.8/xml/dom/__pycache__/__init__.cpython-38.pyc", O_RDONLY|O_CLOEXEC) = 3
> openat(AT_FDCWD, "/usr/lib/python3.8/xml/dom", O_RDONLY|O_NONBLOCK|O_CLOEXEC|O_DIRECTORY) = 3
> openat(AT_FDCWD, "/usr/lib/python3.8/xml/dom/__pycache__/domreg.cpython-38.pyc", O_RDONLY|O_CLOEXEC) = 3
> openat(AT_FDCWD, "/usr/lib/python3.8/xml/dom/__pycache__/minidom.cpython-38.pyc", O_RDONLY|O_CLOEXEC) = 3
> openat(AT_FDCWD, "/usr/lib/python3.8/xml/dom/__pycache__/minicompat.cpython-38.pyc", O_RDONLY|O_CLOEXEC) = 3
> openat(AT_FDCWD, "/usr/lib/python3.8/xml/dom/__pycache__/xmlbuilder.cpython-38.pyc", O_RDONLY|O_CLOEXEC) = 3
> openat(AT_FDCWD, "/usr/lib/python3.8/__pycache__/copy.cpython-38.pyc", O_RDONLY|O_CLOEXEC) = 3
> openat(AT_FDCWD, "/usr/lib/python3.8/xml/dom/__pycache__/NodeFilter.cpython-38.pyc", O_RDONLY|O_CLOEXEC) = 3
> openat(AT_FDCWD, "/usr/lib/python3.8/xml/parsers/__pycache__/__init__.cpython-38.pyc", O_RDONLY|O_CLOEXEC) = 3
> openat(AT_FDCWD, "/usr/lib/python3.8/xml/parsers", O_RDONLY|O_NONBLOCK|O_CLOEXEC|O_DIRECTORY) = 3
> openat(AT_FDCWD, "/usr/lib/python3.8/xml/parsers/__pycache__/expat.cpython-38.pyc", O_RDONLY|O_CLOEXEC) = 3
> openat(AT_FDCWD, "/usr/lib/python3.8/urllib/__pycache__/__init__.cpython-38.pyc", O_RDONLY|O_CLOEXEC) = 3
> openat(AT_FDCWD, "/usr/lib/python3.8/urllib", O_RDONLY|O_NONBLOCK|O_CLOEXEC|O_DIRECTORY) = 3
> openat(AT_FDCWD, "/usr/lib/python3.8/urllib/__pycache__/error.cpython-38.pyc", O_RDONLY|O_CLOEXEC) = 3
> openat(AT_FDCWD, "/usr/lib/python3.8/urllib/__pycache__/response.cpython-38.pyc", O_RDONLY|O_CLOEXEC) = 3
> openat(AT_FDCWD, "/usr/lib/python3.8/urllib/__pycache__/request.cpython-38.pyc", O_RDONLY|O_CLOEXEC) = 3
> openat(AT_FDCWD, "/usr/lib/python3.8/__pycache__/base64.cpython-38.pyc", O_RDONLY|O_CLOEXEC) = 3
> openat(AT_FDCWD, "/usr/lib/python3.8/email/__pycache__/__init__.cpython-38.pyc", O_RDONLY|O_CLOEXEC) = 3
> openat(AT_FDCWD, "/usr/lib/python3.8/__pycache__/hashlib.cpython-38.pyc", O_RDONLY|O_CLOEXEC) = 3
> openat(AT_FDCWD, "/usr/lib/python3.8/lib-dynload/_hashlib.cpython-38-x86_64-linux-gnu.so", O_RDONLY|O_CLOEXEC) = 3
> openat(AT_FDCWD, "/etc/ld.so.cache", O_RDONLY|O_CLOEXEC) = 3
> openat(AT_FDCWD, "/lib/x86_64-linux-gnu/libcrypto.so.1.1", O_RDONLY|O_CLOEXEC) = 3
> openat(AT_FDCWD, "/usr/lib/python3.8/http/__pycache__/__init__.cpython-38.pyc", O_RDONLY|O_CLOEXEC) = 3
> openat(AT_FDCWD, "/usr/lib/python3.8/http", O_RDONLY|O_NONBLOCK|O_CLOEXEC|O_DIRECTORY) = 3
> openat(AT_FDCWD, "/usr/lib/python3.8/http/__pycache__/client.cpython-38.pyc", O_RDONLY|O_CLOEXEC) = 3
> openat(AT_FDCWD, "/usr/lib/python3.8/email", O_RDONLY|O_NONBLOCK|O_CLOEXEC|O_DIRECTORY) = 3
> openat(AT_FDCWD, "/usr/lib/python3.8/email/__pycache__/parser.cpython-38.pyc", O_RDONLY|O_CLOEXEC) = 3
> openat(AT_FDCWD, "/usr/lib/python3.8/email/__pycache__/feedparser.cpython-38.pyc", O_RDONLY|O_CLOEXEC) = 3
> openat(AT_FDCWD, "/usr/lib/python3.8/email/__pycache__/errors.cpython-38.pyc", O_RDONLY|O_CLOEXEC) = 3
> openat(AT_FDCWD, "/usr/lib/python3.8/email/__pycache__/_policybase.cpython-38.pyc", O_RDONLY|O_CLOEXEC) = 3
> openat(AT_FDCWD, "/usr/lib/python3.8/email/__pycache__/header.cpython-38.pyc", O_RDONLY|O_CLOEXEC) = 3
> openat(AT_FDCWD, "/usr/lib/python3.8/email/__pycache__/quoprimime.cpython-38.pyc", O_RDONLY|O_CLOEXEC) = 3
> openat(AT_FDCWD, "/usr/lib/python3.8/__pycache__/string.cpython-38.pyc", O_RDONLY|O_CLOEXEC) = 3
> openat(AT_FDCWD, "/usr/lib/python3.8/email/__pycache__/base64mime.cpython-38.pyc", O_RDONLY|O_CLOEXEC) = 3
> openat(AT_FDCWD, "/usr/lib/python3.8/email/__pycache__/charset.cpython-38.pyc", O_RDONLY|O_CLOEXEC) = 3
> openat(AT_FDCWD, "/usr/lib/python3.8/email/__pycache__/encoders.cpython-38.pyc", O_RDONLY|O_CLOEXEC) = 3
> openat(AT_FDCWD, "/usr/lib/python3.8/__pycache__/quopri.cpython-38.pyc", O_RDONLY|O_CLOEXEC) = 3
> openat(AT_FDCWD, "/usr/lib/python3.8/email/__pycache__/utils.cpython-38.pyc", O_RDONLY|O_CLOEXEC) = 3
> openat(AT_FDCWD, "/usr/lib/python3.8/urllib/__pycache__/parse.cpython-38.pyc", O_RDONLY|O_CLOEXEC) = 3
> openat(AT_FDCWD, "/usr/lib/python3.8/email/__pycache__/_parseaddr.cpython-38.pyc", O_RDONLY|O_CLOEXEC) = 3
> openat(AT_FDCWD, "/usr/lib/python3.8/__pycache__/calendar.cpython-38.pyc", O_RDONLY|O_CLOEXEC) = 3
> openat(AT_FDCWD, "/usr/lib/python3.8/email/__pycache__/message.cpython-38.pyc", O_RDONLY|O_CLOEXEC) = 3
> openat(AT_FDCWD, "/usr/lib/python3.8/__pycache__/uu.cpython-38.pyc", O_RDONLY|O_CLOEXEC) = 3
> openat(AT_FDCWD, "/usr/lib/python3.8/email/__pycache__/_encoded_words.cpython-38.pyc", O_RDONLY|O_CLOEXEC) = 3
> openat(AT_FDCWD, "/usr/lib/python3.8/email/__pycache__/iterators.cpython-38.pyc", O_RDONLY|O_CLOEXEC) = 3
> openat(AT_FDCWD, "/usr/lib/python3.8/__pycache__/ssl.cpython-38.pyc", O_RDONLY|O_CLOEXEC) = 3
> openat(AT_FDCWD, "/usr/lib/python3.8/lib-dynload/_ssl.cpython-38-x86_64-linux-gnu.so", O_RDONLY|O_CLOEXEC) = 3
> openat(AT_FDCWD, "/etc/ld.so.cache", O_RDONLY|O_CLOEXEC) = 3
> openat(AT_FDCWD, "/lib/x86_64-linux-gnu/libssl.so.1.1", O_RDONLY|O_CLOEXEC) = 3
> openat(AT_FDCWD, "/usr/lib/python3/dist-packages/__pycache__/problem_report.cpython-38.pyc", O_RDONLY|O_CLOEXEC) = 3
> openat(AT_FDCWD, "/usr/lib/python3.8/__pycache__/gzip.cpython-38.pyc", O_RDONLY|O_CLOEXEC) = 3
> openat(AT_FDCWD, "/usr/lib/python3.8/email/mime/__pycache__/__init__.cpython-38.pyc", O_RDONLY|O_CLOEXEC) = 3
> openat(AT_FDCWD, "/usr/lib/python3.8/email/mime", O_RDONLY|O_NONBLOCK|O_CLOEXEC|O_DIRECTORY) = 3
> openat(AT_FDCWD, "/usr/lib/python3.8/email/mime/__pycache__/multipart.cpython-38.pyc", O_RDONLY|O_CLOEXEC) = 3
> openat(AT_FDCWD, "/usr/lib/python3.8/email/mime/__pycache__/base.cpython-38.pyc", O_RDONLY|O_CLOEXEC) = 3
> openat(AT_FDCWD, "/usr/lib/python3.8/email/__pycache__/policy.cpython-38.pyc", O_RDONLY|O_CLOEXEC) = 3
> openat(AT_FDCWD, "/usr/lib/python3.8/email/__pycache__/headerregistry.cpython-38.pyc", O_RDONLY|O_CLOEXEC) = 3
> openat(AT_FDCWD, "/usr/lib/python3.8/email/__pycache__/_header_value_parser.cpython-38.pyc", O_RDONLY|O_CLOEXEC) = 3
> openat(AT_FDCWD, "/usr/lib/python3.8/email/__pycache__/contentmanager.cpython-38.pyc", O_RDONLY|O_CLOEXEC) = 3
> openat(AT_FDCWD, "/usr/lib/python3.8/email/mime/__pycache__/text.cpython-38.pyc", O_RDONLY|O_CLOEXEC) = 3
> openat(AT_FDCWD, "/usr/lib/python3.8/email/mime/__pycache__/nonmultipart.cpython-38.pyc", O_RDONLY|O_CLOEXEC) = 3
> openat(AT_FDCWD, "/usr/lib/python3/dist-packages/apport/__pycache__/fileutils.cpython-38.pyc", O_RDONLY|O_CLOEXEC) = 3
> openat(AT_FDCWD, "/usr/lib/python3/dist-packages/requests_unixsocket/__pycache__/__init__.cpython-38.pyc", O_RDONLY|O_CLOEXEC) = 3
> openat(AT_FDCWD, "/usr/lib/python3/dist-packages/requests/__pycache__/__init__.cpython-38.pyc", O_RDONLY|O_CLOEXEC) = 3
> openat(AT_FDCWD, "/usr/lib/python3/dist-packages/urllib3/__pycache__/__init__.cpython-38.pyc", O_RDONLY|O_CLOEXEC) = 3
> openat(AT_FDCWD, "/usr/lib/python3/dist-packages/urllib3", O_RDONLY|O_NONBLOCK|O_CLOEXEC|O_DIRECTORY) = 3
> openat(AT_FDCWD, "/usr/lib/python3/dist-packages/urllib3/__pycache__/connectionpool.cpython-38.pyc", O_RDONLY|O_CLOEXEC) = 3
> openat(AT_FDCWD, "/usr/lib/python3.8/logging/__pycache__/__init__.cpython-38.pyc", O_RDONLY|O_CLOEXEC) = 3
> openat(AT_FDCWD, "/usr/lib/python3/dist-packages/urllib3/__pycache__/exceptions.cpython-38.pyc", O_RDONLY|O_CLOEXEC) = 3
> openat(AT_FDCWD, "/usr/lib/python3/dist-packages/__pycache__/six.cpython-38.pyc", O_RDONLY|O_CLOEXEC) = 3
> openat(AT_FDCWD, "/usr/lib/python3/dist-packages/urllib3/packages/__pycache__/__init__.cpython-38.pyc", O_RDONLY|O_CLOEXEC) = 3
> openat(AT_FDCWD, "/usr/lib/python3/dist-packages/urllib3/packages", O_RDONLY|O_NONBLOCK|O_CLOEXEC|O_DIRECTORY) = 3
> openat(AT_FDCWD, "/usr/lib/python3/dist-packages/urllib3/packages/ssl_match_hostname/__pycache__/__init__.cpython-38.pyc", O_RDONLY|O_CLOEXEC) = 3
> openat(AT_FDCWD, "/usr/lib/python3.8/__pycache__/queue.cpython-38.pyc", O_RDONLY|O_CLOEXEC) = 3
> openat(AT_FDCWD, "/usr/lib/python3.8/lib-dynload/_queue.cpython-38-x86_64-linux-gnu.so", O_RDONLY|O_CLOEXEC) = 3
> openat(AT_FDCWD, "/usr/lib/python3/dist-packages/urllib3/__pycache__/connection.cpython-38.pyc", O_RDONLY|O_CLOEXEC) = 3
> openat(AT_FDCWD, "/usr/lib/python3/dist-packages/urllib3/util/__pycache__/__init__.cpython-38.pyc", O_RDONLY|O_CLOEXEC) = 3
> openat(AT_FDCWD, "/usr/lib/python3/dist-packages/urllib3/util", O_RDONLY|O_NONBLOCK|O_CLOEXEC|O_DIRECTORY) = 3
> openat(AT_FDCWD, "/usr/lib/python3/dist-packages/urllib3/util/__pycache__/connection.cpython-38.pyc", O_RDONLY|O_CLOEXEC) = 3
> openat(AT_FDCWD, "/usr/lib/python3/dist-packages/urllib3/util/__pycache__/wait.cpython-38.pyc", O_RDONLY|O_CLOEXEC) = 3
> openat(AT_FDCWD, "/usr/lib/python3/dist-packages/urllib3/contrib/__pycache__/__init__.cpython-38.pyc", O_RDONLY|O_CLOEXEC) = 3
> openat(AT_FDCWD, "/usr/lib/python3/dist-packages/urllib3/contrib", O_RDONLY|O_NONBLOCK|O_CLOEXEC|O_DIRECTORY) = 3
> openat(AT_FDCWD, "/usr/lib/python3/dist-packages/urllib3/contrib/__pycache__/_appengine_environ.cpython-38.pyc", O_RDONLY|O_CLOEXEC) = 3
> openat(AT_FDCWD, "/usr/lib/python3/dist-packages/urllib3/util/__pycache__/request.cpython-38.pyc", O_RDONLY|O_CLOEXEC) = 3
> openat(AT_FDCWD, "/usr/lib/python3/dist-packages/urllib3/util/__pycache__/response.cpython-38.pyc", O_RDONLY|O_CLOEXEC) = 3
> openat(AT_FDCWD, "/usr/lib/python3/dist-packages/urllib3/util/__pycache__/ssl_.cpython-38.pyc", O_RDONLY|O_CLOEXEC) = 3
> openat(AT_FDCWD, "/usr/lib/python3.8/__pycache__/hmac.cpython-38.pyc", O_RDONLY|O_CLOEXEC) = 3
> openat(AT_FDCWD, "/usr/lib/python3/dist-packages/urllib3/util/__pycache__/url.cpython-38.pyc", O_RDONLY|O_CLOEXEC) = 3
> openat(AT_FDCWD, "/usr/lib/python3/dist-packages/urllib3/util/__pycache__/timeout.cpython-38.pyc", O_RDONLY|O_CLOEXEC) = 3
> openat(AT_FDCWD, "/usr/lib/python3/dist-packages/urllib3/util/__pycache__/retry.cpython-38.pyc", O_RDONLY|O_CLOEXEC) = 3
> openat(AT_FDCWD, "/usr/lib/python3/dist-packages/urllib3/__pycache__/_collections.cpython-38.pyc", O_RDONLY|O_CLOEXEC) = 3
> openat(AT_FDCWD, "/usr/lib/python3/dist-packages/urllib3/__pycache__/request.cpython-38.pyc", O_RDONLY|O_CLOEXEC) = 3
> openat(AT_FDCWD, "/usr/lib/python3/dist-packages/urllib3/__pycache__/filepost.cpython-38.pyc", O_RDONLY|O_CLOEXEC) = 3
> openat(AT_FDCWD, "/usr/lib/python3/dist-packages/urllib3/__pycache__/fields.cpython-38.pyc", O_RDONLY|O_CLOEXEC) = 3
> openat(AT_FDCWD, "/usr/lib/python3.8/__pycache__/mimetypes.cpython-38.pyc", O_RDONLY|O_CLOEXEC) = 3
> openat(AT_FDCWD, "/usr/lib/python3/dist-packages/urllib3/__pycache__/response.cpython-38.pyc", O_RDONLY|O_CLOEXEC) = 3
> openat(AT_FDCWD, "/usr/lib/python3/dist-packages/urllib3/util/__pycache__/queue.cpython-38.pyc", O_RDONLY|O_CLOEXEC) = 3
> openat(AT_FDCWD, "/usr/lib/python3/dist-packages/urllib3/__pycache__/poolmanager.cpython-38.pyc", O_RDONLY|O_CLOEXEC) = 3
> openat(AT_FDCWD, "/usr/lib/python3/dist-packages/chardet/__pycache__/__init__.cpython-38.pyc", O_RDONLY|O_CLOEXEC) = 3
> openat(AT_FDCWD, "/usr/lib/python3/dist-packages/chardet", O_RDONLY|O_NONBLOCK|O_CLOEXEC|O_DIRECTORY) = 3
> openat(AT_FDCWD, "/usr/lib/python3/dist-packages/chardet/__pycache__/compat.cpython-38.pyc", O_RDONLY|O_CLOEXEC) = 3
> openat(AT_FDCWD, "/usr/lib/python3/dist-packages/chardet/__pycache__/universaldetector.cpython-38.pyc", O_RDONLY|O_CLOEXEC) = 3
> openat(AT_FDCWD, "/usr/lib/python3/dist-packages/chardet/__pycache__/charsetgroupprober.cpython-38.pyc", O_RDONLY|O_CLOEXEC) = 3
> openat(AT_FDCWD, "/usr/lib/python3/dist-packages/chardet/__pycache__/enums.cpython-38.pyc", O_RDONLY|O_CLOEXEC) = 3
> openat(AT_FDCWD, "/usr/lib/python3/dist-packages/chardet/__pycache__/charsetprober.cpython-38.pyc", O_RDONLY|O_CLOEXEC) = 3
> openat(AT_FDCWD, "/usr/lib/python3/dist-packages/chardet/__pycache__/escprober.cpython-38.pyc", O_RDONLY|O_CLOEXEC) = 3
> openat(AT_FDCWD, "/usr/lib/python3/dist-packages/chardet/__pycache__/codingstatemachine.cpython-38.pyc", O_RDONLY|O_CLOEXEC) = 3
> openat(AT_FDCWD, "/usr/lib/python3/dist-packages/chardet/__pycache__/escsm.cpython-38.pyc", O_RDONLY|O_CLOEXEC) = 3
> openat(AT_FDCWD, "/usr/lib/python3/dist-packages/chardet/__pycache__/latin1prober.cpython-38.pyc", O_RDONLY|O_CLOEXEC) = 3
> openat(AT_FDCWD, "/usr/lib/python3/dist-packages/chardet/__pycache__/mbcsgroupprober.cpython-38.pyc", O_RDONLY|O_CLOEXEC) = 3
> openat(AT_FDCWD, "/usr/lib/python3/dist-packages/chardet/__pycache__/utf8prober.cpython-38.pyc", O_RDONLY|O_CLOEXEC) = 3
> openat(AT_FDCWD, "/usr/lib/python3/dist-packages/chardet/__pycache__/mbcssm.cpython-38.pyc", O_RDONLY|O_CLOEXEC) = 3
> openat(AT_FDCWD, "/usr/lib/python3/dist-packages/chardet/__pycache__/sjisprober.cpython-38.pyc", O_RDONLY|O_CLOEXEC) = 3
> openat(AT_FDCWD, "/usr/lib/python3/dist-packages/chardet/__pycache__/mbcharsetprober.cpython-38.pyc", O_RDONLY|O_CLOEXEC) = 3
> openat(AT_FDCWD, "/usr/lib/python3/dist-packages/chardet/__pycache__/chardistribution.cpython-38.pyc", O_RDONLY|O_CLOEXEC) = 3
> openat(AT_FDCWD, "/usr/lib/python3/dist-packages/chardet/__pycache__/euctwfreq.cpython-38.pyc", O_RDONLY|O_CLOEXEC) = 3
> openat(AT_FDCWD, "/usr/lib/python3/dist-packages/chardet/__pycache__/euckrfreq.cpython-38.pyc", O_RDONLY|O_CLOEXEC) = 3
> openat(AT_FDCWD, "/usr/lib/python3/dist-packages/chardet/__pycache__/gb2312freq.cpython-38.pyc", O_RDONLY|O_CLOEXEC) = 3
> openat(AT_FDCWD, "/usr/lib/python3/dist-packages/chardet/__pycache__/big5freq.cpython-38.pyc", O_RDONLY|O_CLOEXEC) = 3
> openat(AT_FDCWD, "/usr/lib/python3/dist-packages/chardet/__pycache__/jisfreq.cpython-38.pyc", O_RDONLY|O_CLOEXEC) = 3
> openat(AT_FDCWD, "/usr/lib/python3/dist-packages/chardet/__pycache__/jpcntx.cpython-38.pyc", O_RDONLY|O_CLOEXEC) = 3
> openat(AT_FDCWD, "/usr/lib/python3/dist-packages/chardet/__pycache__/eucjpprober.cpython-38.pyc", O_RDONLY|O_CLOEXEC) = 3
> openat(AT_FDCWD, "/usr/lib/python3/dist-packages/chardet/__pycache__/gb2312prober.cpython-38.pyc", O_RDONLY|O_CLOEXEC) = 3
> openat(AT_FDCWD, "/usr/lib/python3/dist-packages/chardet/__pycache__/euckrprober.cpython-38.pyc", O_RDONLY|O_CLOEXEC) = 3
> openat(AT_FDCWD, "/usr/lib/python3/dist-packages/chardet/__pycache__/cp949prober.cpython-38.pyc", O_RDONLY|O_CLOEXEC) = 3
> openat(AT_FDCWD, "/usr/lib/python3/dist-packages/chardet/__pycache__/big5prober.cpython-38.pyc", O_RDONLY|O_CLOEXEC) = 3
> openat(AT_FDCWD, "/usr/lib/python3/dist-packages/chardet/__pycache__/euctwprober.cpython-38.pyc", O_RDONLY|O_CLOEXEC) = 3
> openat(AT_FDCWD, "/usr/lib/python3/dist-packages/chardet/__pycache__/sbcsgroupprober.cpython-38.pyc", O_RDONLY|O_CLOEXEC) = 3
> openat(AT_FDCWD, "/usr/lib/python3/dist-packages/chardet/__pycache__/sbcharsetprober.cpython-38.pyc", O_RDONLY|O_CLOEXEC) = 3
> openat(AT_FDCWD, "/usr/lib/python3/dist-packages/chardet/__pycache__/langcyrillicmodel.cpython-38.pyc", O_RDONLY|O_CLOEXEC) = 3
> openat(AT_FDCWD, "/usr/lib/python3/dist-packages/chardet/__pycache__/langgreekmodel.cpython-38.pyc", O_RDONLY|O_CLOEXEC) = 3
> openat(AT_FDCWD, "/usr/lib/python3/dist-packages/chardet/__pycache__/langbulgarianmodel.cpython-38.pyc", O_RDONLY|O_CLOEXEC) = 3
> openat(AT_FDCWD, "/usr/lib/python3/dist-packages/chardet/__pycache__/langthaimodel.cpython-38.pyc", O_RDONLY|O_CLOEXEC) = 3
> openat(AT_FDCWD, "/usr/lib/python3/dist-packages/chardet/__pycache__/langhebrewmodel.cpython-38.pyc", O_RDONLY|O_CLOEXEC) = 3
> openat(AT_FDCWD, "/usr/lib/python3/dist-packages/chardet/__pycache__/hebrewprober.cpython-38.pyc", O_RDONLY|O_CLOEXEC) = 3
> openat(AT_FDCWD, "/usr/lib/python3/dist-packages/chardet/__pycache__/langturkishmodel.cpython-38.pyc", O_RDONLY|O_CLOEXEC) = 3
> openat(AT_FDCWD, "/usr/lib/python3/dist-packages/chardet/__pycache__/version.cpython-38.pyc", O_RDONLY|O_CLOEXEC) = 3
> openat(AT_FDCWD, "/usr/lib/python3/dist-packages/requests", O_RDONLY|O_NONBLOCK|O_CLOEXEC|O_DIRECTORY) = 3
> openat(AT_FDCWD, "/usr/lib/python3/dist-packages/requests/__pycache__/exceptions.cpython-38.pyc", O_RDONLY|O_CLOEXEC) = 3
> openat(AT_FDCWD, "/usr/lib/python3/dist-packages/urllib3/contrib/__pycache__/pyopenssl.cpython-38.pyc", O_RDONLY|O_CLOEXEC) = 3
> openat(AT_FDCWD, "/usr/lib/python3/dist-packages/OpenSSL/__pycache__/__init__.cpython-38.pyc", O_RDONLY|O_CLOEXEC) = 3
> openat(AT_FDCWD, "/usr/lib/python3/dist-packages/OpenSSL", O_RDONLY|O_NONBLOCK|O_CLOEXEC|O_DIRECTORY) = 3
> openat(AT_FDCWD, "/usr/lib/python3/dist-packages/OpenSSL/__pycache__/crypto.cpython-38.pyc", O_RDONLY|O_CLOEXEC) = 3
> openat(AT_FDCWD, "/usr/lib/python3/dist-packages/cryptography/__pycache__/__init__.cpython-38.pyc", O_RDONLY|O_CLOEXEC) = 3
> openat(AT_FDCWD, "/usr/lib/python3/dist-packages/cryptography", O_RDONLY|O_NONBLOCK|O_CLOEXEC|O_DIRECTORY) = 3
> openat(AT_FDCWD, "/usr/lib/python3/dist-packages/cryptography/__pycache__/__about__.cpython-38.pyc", O_RDONLY|O_CLOEXEC) = 3
> openat(AT_FDCWD, "/usr/lib/python3/dist-packages/cryptography/x509/__pycache__/__init__.cpython-38.pyc", O_RDONLY|O_CLOEXEC) = 3
> openat(AT_FDCWD, "/usr/lib/python3/dist-packages/cryptography/x509", O_RDONLY|O_NONBLOCK|O_CLOEXEC|O_DIRECTORY) = 3
> openat(AT_FDCWD, "/usr/lib/python3/dist-packages/cryptography/x509/__pycache__/certificate_transparency.cpython-38.pyc", O_RDONLY|O_CLOEXEC) = 3
> openat(AT_FDCWD, "/usr/lib/python3/dist-packages/cryptography/x509/__pycache__/base.cpython-38.pyc", O_RDONLY|O_CLOEXEC) = 3
> openat(AT_FDCWD, "/usr/lib/python3/dist-packages/cryptography/__pycache__/utils.cpython-38.pyc", O_RDONLY|O_CLOEXEC) = 3
> openat(AT_FDCWD, "/usr/lib/python3.8/__pycache__/inspect.cpython-38.pyc", O_RDONLY|O_CLOEXEC) = 3
> openat(AT_FDCWD, "/usr/lib/python3.8/__pycache__/dis.cpython-38.pyc", O_RDONLY|O_CLOEXEC) = 3
> openat(AT_FDCWD, "/usr/lib/python3.8/__pycache__/opcode.cpython-38.pyc", O_RDONLY|O_CLOEXEC) = 3
> openat(AT_FDCWD, "/usr/lib/python3.8/lib-dynload/_opcode.cpython-38-x86_64-linux-gnu.so", O_RDONLY|O_CLOEXEC) = 3
> openat(AT_FDCWD, "/usr/lib/python3/dist-packages/cryptography/hazmat/__pycache__/__init__.cpython-38.pyc", O_RDONLY|O_CLOEXEC) = 3
> openat(AT_FDCWD, "/usr/lib/python3/dist-packages/cryptography/hazmat", O_RDONLY|O_NONBLOCK|O_CLOEXEC|O_DIRECTORY) = 3
> openat(AT_FDCWD, "/usr/lib/python3/dist-packages/cryptography/hazmat/primitives/__pycache__/__init__.cpython-38.pyc", O_RDONLY|O_CLOEXEC) = 3
> openat(AT_FDCWD, "/usr/lib/python3/dist-packages/cryptography/hazmat/primitives", O_RDONLY|O_NONBLOCK|O_CLOEXEC|O_DIRECTORY) = 3
> openat(AT_FDCWD, "/usr/lib/python3/dist-packages/cryptography/hazmat/primitives/asymmetric/__pycache__/__init__.cpython-38.pyc", O_RDONLY|O_CLOEXEC) = 3
> openat(AT_FDCWD, "/usr/lib/python3/dist-packages/cryptography/hazmat/primitives/asymmetric", O_RDONLY|O_NONBLOCK|O_CLOEXEC|O_DIRECTORY) = 3
> openat(AT_FDCWD, "/usr/lib/python3/dist-packages/cryptography/hazmat/primitives/asymmetric/__pycache__/dsa.cpython-38.pyc", O_RDONLY|O_CLOEXEC) = 3
> openat(AT_FDCWD, "/usr/lib/python3/dist-packages/cryptography/hazmat/primitives/asymmetric/__pycache__/ec.cpython-38.pyc", O_RDONLY|O_CLOEXEC) = 3
> openat(AT_FDCWD, "/usr/lib/python3/dist-packages/cryptography/hazmat/__pycache__/_oid.cpython-38.pyc", O_RDONLY|O_CLOEXEC) = 3
> openat(AT_FDCWD, "/usr/lib/python3/dist-packages/cryptography/hazmat/primitives/asymmetric/__pycache__/ed25519.cpython-38.pyc", O_RDONLY|O_CLOEXEC) = 3
> openat(AT_FDCWD, "/usr/lib/python3/dist-packages/cryptography/__pycache__/exceptions.cpython-38.pyc", O_RDONLY|O_CLOEXEC) = 3
> openat(AT_FDCWD, "/usr/lib/python3/dist-packages/cryptography/hazmat/primitives/asymmetric/__pycache__/ed448.cpython-38.pyc", O_RDONLY|O_CLOEXEC) = 3
> openat(AT_FDCWD, "/usr/lib/python3/dist-packages/cryptography/hazmat/primitives/asymmetric/__pycache__/rsa.cpython-38.pyc", O_RDONLY|O_CLOEXEC) = 3
> openat(AT_FDCWD, "/usr/lib/python3/dist-packages/cryptography/hazmat/backends/__pycache__/__init__.cpython-38.pyc", O_RDONLY|O_CLOEXEC) = 3
> openat(AT_FDCWD, "/usr/lib/python3/dist-packages/cryptography/hazmat/backends", O_RDONLY|O_NONBLOCK|O_CLOEXEC|O_DIRECTORY) = 3
> openat(AT_FDCWD, "/usr/lib/python3/dist-packages/cryptography/hazmat/backends/__pycache__/interfaces.cpython-38.pyc", O_RDONLY|O_CLOEXEC) = 3
> openat(AT_FDCWD, "/usr/lib/python3/dist-packages/cryptography/x509/__pycache__/extensions.cpython-38.pyc", O_RDONLY|O_CLOEXEC) = 3
> openat(AT_FDCWD, "/usr/lib/python3.8/__pycache__/ipaddress.cpython-38.pyc", O_RDONLY|O_CLOEXEC) = 3
> openat(AT_FDCWD, "/usr/lib/python3/dist-packages/cryptography/hazmat/__pycache__/_der.cpython-38.pyc", O_RDONLY|O_CLOEXEC) = 3
> openat(AT_FDCWD, "/usr/lib/python3/dist-packages/cryptography/hazmat/primitives/__pycache__/constant_time.cpython-38.pyc", O_RDONLY|O_CLOEXEC) = 3
> openat(AT_FDCWD, "/usr/lib/python3/dist-packages/cryptography/hazmat/bindings/__pycache__/__init__.cpython-38.pyc", O_RDONLY|O_CLOEXEC) = 3
> openat(AT_FDCWD, "/usr/lib/python3/dist-packages/cryptography/hazmat/bindings", O_RDONLY|O_NONBLOCK|O_CLOEXEC|O_DIRECTORY) = 3
> openat(AT_FDCWD, "/usr/lib/python3/dist-packages/cryptography/hazmat/bindings/_constant_time.abi3.so", O_RDONLY|O_CLOEXEC) = 3
> openat(AT_FDCWD, "/usr/lib/python3/dist-packages/_cffi_backend.cpython-38-x86_64-linux-gnu.so", O_RDONLY|O_CLOEXEC) = 3
> openat(AT_FDCWD, "/usr/lib/python3/dist-packages/cryptography/hazmat/primitives/serialization/__pycache__/__init__.cpython-38.pyc", O_RDONLY|O_CLOEXEC) = 3
> openat(AT_FDCWD, "/usr/lib/python3/dist-packages/cryptography/hazmat/primitives/serialization", O_RDONLY|O_NONBLOCK|O_CLOEXEC|O_DIRECTORY) = 3
> openat(AT_FDCWD, "/usr/lib/python3/dist-packages/cryptography/hazmat/primitives/serialization/__pycache__/base.cpython-38.pyc", O_RDONLY|O_CLOEXEC) = 3
> openat(AT_FDCWD, "/usr/lib/python3/dist-packages/cryptography/hazmat/primitives/serialization/__pycache__/ssh.cpython-38.pyc", O_RDONLY|O_CLOEXEC) = 3
> openat(AT_FDCWD, "/usr/lib/python3/dist-packages/cryptography/x509/__pycache__/general_name.cpython-38.pyc", O_RDONLY|O_CLOEXEC) = 3
> openat(AT_FDCWD, "/usr/lib/python3/dist-packages/cryptography/x509/__pycache__/name.cpython-38.pyc", O_RDONLY|O_CLOEXEC) = 3
> openat(AT_FDCWD, "/usr/lib/python3/dist-packages/cryptography/x509/__pycache__/oid.cpython-38.pyc", O_RDONLY|O_CLOEXEC) = 3
> openat(AT_FDCWD, "/usr/lib/python3/dist-packages/cryptography/hazmat/primitives/__pycache__/hashes.cpython-38.pyc", O_RDONLY|O_CLOEXEC) = 3
> openat(AT_FDCWD, "/usr/lib/python3/dist-packages/OpenSSL/__pycache__/_util.cpython-38.pyc", O_RDONLY|O_CLOEXEC) = 3
> openat(AT_FDCWD, "/usr/lib/python3/dist-packages/cryptography/hazmat/bindings/openssl/__pycache__/__init__.cpython-38.pyc", O_RDONLY|O_CLOEXEC) = 3
> openat(AT_FDCWD, "/usr/lib/python3/dist-packages/cryptography/hazmat/bindings/openssl", O_RDONLY|O_NONBLOCK|O_CLOEXEC|O_DIRECTORY) = 3
> openat(AT_FDCWD, "/usr/lib/python3/dist-packages/cryptography/hazmat/bindings/openssl/__pycache__/binding.cpython-38.pyc", O_RDONLY|O_CLOEXEC) = 3
> openat(AT_FDCWD, "/usr/lib/python3/dist-packages/cryptography/hazmat/bindings/_openssl.abi3.so", O_RDONLY|O_CLOEXEC) = 3
> openat(AT_FDCWD, "/usr/lib/python3/dist-packages/cryptography/hazmat/bindings/openssl/__pycache__/_conditional.cpython-38.pyc", O_RDONLY|O_CLOEXEC) = 3
> openat(AT_FDCWD, "/usr/lib/ssl/openssl.cnf", O_RDONLY) = 3
> openat(AT_FDCWD, "/usr/lib/x86_64-linux-gnu/engines-1.1/osrandom.so", O_RDONLY|O_CLOEXEC) = -1 ENOENT (No such file or directory)
> openat(AT_FDCWD, "/usr/lib/python3/dist-packages/OpenSSL/__pycache__/SSL.cpython-38.pyc", O_RDONLY|O_CLOEXEC) = 3
> openat(AT_FDCWD, "/usr/lib/python3/dist-packages/OpenSSL/__pycache__/version.cpython-38.pyc", O_RDONLY|O_CLOEXEC) = 3
> openat(AT_FDCWD, "/usr/lib/python3/dist-packages/cryptography/hazmat/backends/openssl/__pycache__/__init__.cpython-38.pyc", O_RDONLY|O_CLOEXEC) = 3
> openat(AT_FDCWD, "/usr/lib/python3/dist-packages/cryptography/hazmat/backends/openssl", O_RDONLY|O_NONBLOCK|O_CLOEXEC|O_DIRECTORY) = 3
> openat(AT_FDCWD, "/usr/lib/python3/dist-packages/cryptography/hazmat/backends/openssl/__pycache__/backend.cpython-38.pyc", O_RDONLY|O_CLOEXEC) = 3
> openat(AT_FDCWD, "/usr/lib/python3/dist-packages/cryptography/hazmat/backends/openssl/__pycache__/aead.cpython-38.pyc", O_RDONLY|O_CLOEXEC) = 3
> openat(AT_FDCWD, "/usr/lib/python3/dist-packages/cryptography/hazmat/backends/openssl/__pycache__/ciphers.cpython-38.pyc", O_RDONLY|O_CLOEXEC) = 3
> openat(AT_FDCWD, "/usr/lib/python3/dist-packages/cryptography/hazmat/primitives/ciphers/__pycache__/__init__.cpython-38.pyc", O_RDONLY|O_CLOEXEC) = 3
> openat(AT_FDCWD, "/usr/lib/python3/dist-packages/cryptography/hazmat/primitives/ciphers", O_RDONLY|O_NONBLOCK|O_CLOEXEC|O_DIRECTORY) = 3
> openat(AT_FDCWD, "/usr/lib/python3/dist-packages/cryptography/hazmat/primitives/ciphers/__pycache__/base.cpython-38.pyc", O_RDONLY|O_CLOEXEC) = 3
> openat(AT_FDCWD, "/usr/lib/python3/dist-packages/cryptography/hazmat/primitives/ciphers/__pycache__/modes.cpython-38.pyc", O_RDONLY|O_CLOEXEC) = 3
> openat(AT_FDCWD, "/usr/lib/python3/dist-packages/cryptography/hazmat/backends/openssl/__pycache__/cmac.cpython-38.pyc", O_RDONLY|O_CLOEXEC) = 3
> openat(AT_FDCWD, "/usr/lib/python3/dist-packages/cryptography/hazmat/backends/openssl/__pycache__/decode_asn1.cpython-38.pyc", O_RDONLY|O_CLOEXEC) = 3
> openat(AT_FDCWD, "/usr/lib/python3/dist-packages/cryptography/hazmat/backends/openssl/__pycache__/dh.cpython-38.pyc", O_RDONLY|O_CLOEXEC) = 3
> openat(AT_FDCWD, "/usr/lib/python3/dist-packages/cryptography/hazmat/primitives/asymmetric/__pycache__/dh.cpython-38.pyc", O_RDONLY|O_CLOEXEC) = 3
> openat(AT_FDCWD, "/usr/lib/python3/dist-packages/cryptography/hazmat/backends/openssl/__pycache__/dsa.cpython-38.pyc", O_RDONLY|O_CLOEXEC) = 3
> openat(AT_FDCWD, "/usr/lib/python3/dist-packages/cryptography/hazmat/backends/openssl/__pycache__/utils.cpython-38.pyc", O_RDONLY|O_CLOEXEC) = 3
> openat(AT_FDCWD, "/usr/lib/python3/dist-packages/cryptography/hazmat/primitives/asymmetric/__pycache__/utils.cpython-38.pyc", O_RDONLY|O_CLOEXEC) = 3
> openat(AT_FDCWD, "/usr/lib/python3/dist-packages/cryptography/hazmat/backends/openssl/__pycache__/ec.cpython-38.pyc", O_RDONLY|O_CLOEXEC) = 3
> openat(AT_FDCWD, "/usr/lib/python3/dist-packages/cryptography/hazmat/backends/openssl/__pycache__/ed25519.cpython-38.pyc", O_RDONLY|O_CLOEXEC) = 3
> openat(AT_FDCWD, "/usr/lib/python3/dist-packages/cryptography/hazmat/backends/openssl/__pycache__/ed448.cpython-38.pyc", O_RDONLY|O_CLOEXEC) = 3
> openat(AT_FDCWD, "/usr/lib/python3/dist-packages/cryptography/hazmat/backends/openssl/__pycache__/encode_asn1.cpython-38.pyc", O_RDONLY|O_CLOEXEC) = 3
> openat(AT_FDCWD, "/usr/lib/python3/dist-packages/cryptography/hazmat/backends/openssl/__pycache__/hashes.cpython-38.pyc", O_RDONLY|O_CLOEXEC) = 3
> openat(AT_FDCWD, "/usr/lib/python3/dist-packages/cryptography/hazmat/backends/openssl/__pycache__/hmac.cpython-38.pyc", O_RDONLY|O_CLOEXEC) = 3
> openat(AT_FDCWD, "/usr/lib/python3/dist-packages/cryptography/hazmat/backends/openssl/__pycache__/ocsp.cpython-38.pyc", O_RDONLY|O_CLOEXEC) = 3
> openat(AT_FDCWD, "/usr/lib/python3/dist-packages/cryptography/hazmat/backends/openssl/__pycache__/x509.cpython-38.pyc", O_RDONLY|O_CLOEXEC) = 3
> openat(AT_FDCWD, "/usr/lib/python3/dist-packages/cryptography/x509/__pycache__/ocsp.cpython-38.pyc", O_RDONLY|O_CLOEXEC) = 3
> openat(AT_FDCWD, "/usr/lib/python3/dist-packages/cryptography/hazmat/backends/openssl/__pycache__/poly1305.cpython-38.pyc", O_RDONLY|O_CLOEXEC) = 3
> openat(AT_FDCWD, "/usr/lib/python3/dist-packages/cryptography/hazmat/backends/openssl/__pycache__/rsa.cpython-38.pyc", O_RDONLY|O_CLOEXEC) = 3
> openat(AT_FDCWD, "/usr/lib/python3/dist-packages/cryptography/hazmat/primitives/asymmetric/__pycache__/padding.cpython-38.pyc", O_RDONLY|O_CLOEXEC) = 3
> openat(AT_FDCWD, "/usr/lib/python3/dist-packages/cryptography/hazmat/backends/openssl/__pycache__/x25519.cpython-38.pyc", O_RDONLY|O_CLOEXEC) = 3
> openat(AT_FDCWD, "/usr/lib/python3/dist-packages/cryptography/hazmat/primitives/asymmetric/__pycache__/x25519.cpython-38.pyc", O_RDONLY|O_CLOEXEC) = 3
> openat(AT_FDCWD, "/usr/lib/python3/dist-packages/cryptography/hazmat/backends/openssl/__pycache__/x448.cpython-38.pyc", O_RDONLY|O_CLOEXEC) = 3
> openat(AT_FDCWD, "/usr/lib/python3/dist-packages/cryptography/hazmat/primitives/asymmetric/__pycache__/x448.cpython-38.pyc", O_RDONLY|O_CLOEXEC) = 3
> openat(AT_FDCWD, "/usr/lib/python3/dist-packages/cryptography/hazmat/primitives/ciphers/__pycache__/algorithms.cpython-38.pyc", O_RDONLY|O_CLOEXEC) = 3
> openat(AT_FDCWD, "/usr/lib/python3/dist-packages/cryptography/hazmat/primitives/kdf/__pycache__/__init__.cpython-38.pyc", O_RDONLY|O_CLOEXEC) = 3
> openat(AT_FDCWD, "/usr/lib/python3/dist-packages/cryptography/hazmat/primitives/kdf", O_RDONLY|O_NONBLOCK|O_CLOEXEC|O_DIRECTORY) = 3
> openat(AT_FDCWD, "/usr/lib/python3/dist-packages/cryptography/hazmat/primitives/kdf/__pycache__/scrypt.cpython-38.pyc", O_RDONLY|O_CLOEXEC) = 3
> openat(AT_FDCWD, "/usr/lib/python3/dist-packages/urllib3/packages/backports/__pycache__/__init__.cpython-38.pyc", O_RDONLY|O_CLOEXEC) = 3
> openat(AT_FDCWD, "/usr/lib/python3/dist-packages/urllib3/packages/backports", O_RDONLY|O_NONBLOCK|O_CLOEXEC|O_DIRECTORY) = 3
> openat(AT_FDCWD, "/usr/lib/python3/dist-packages/urllib3/packages/backports/__pycache__/makefile.cpython-38.pyc", O_RDONLY|O_CLOEXEC) = 3
> openat(AT_FDCWD, "/usr/lib/python3/dist-packages/requests/__pycache__/__version__.cpython-38.pyc", O_RDONLY|O_CLOEXEC) = 3
> openat(AT_FDCWD, "/usr/lib/python3/dist-packages/requests/__pycache__/utils.cpython-38.pyc", O_RDONLY|O_CLOEXEC) = 3
> openat(AT_FDCWD, "/usr/lib/python3.8/__pycache__/zipfile.cpython-38.pyc", O_RDONLY|O_CLOEXEC) = 3
> openat(AT_FDCWD, "/usr/lib/python3/dist-packages/requests/__pycache__/certs.cpython-38.pyc", O_RDONLY|O_CLOEXEC) = 3
> openat(AT_FDCWD, "/usr/lib/python3/dist-packages/certifi/__pycache__/__init__.cpython-38.pyc", O_RDONLY|O_CLOEXEC) = 3
> openat(AT_FDCWD, "/usr/lib/python3/dist-packages/certifi", O_RDONLY|O_NONBLOCK|O_CLOEXEC|O_DIRECTORY) = 3
> openat(AT_FDCWD, "/usr/lib/python3/dist-packages/certifi/__pycache__/core.cpython-38.pyc", O_RDONLY|O_CLOEXEC) = 3
> openat(AT_FDCWD, "/usr/lib/python3/dist-packages/requests/__pycache__/_internal_utils.cpython-38.pyc", O_RDONLY|O_CLOEXEC) = 3
> openat(AT_FDCWD, "/usr/lib/python3/dist-packages/requests/__pycache__/compat.cpython-38.pyc", O_RDONLY|O_CLOEXEC) = 3
> openat(AT_FDCWD, "/usr/lib/python3/dist-packages/simplejson/__pycache__/__init__.cpython-38.pyc", O_RDONLY|O_CLOEXEC) = 3
> openat(AT_FDCWD, "/usr/lib/python3.8/__pycache__/decimal.cpython-38.pyc", O_RDONLY|O_CLOEXEC) = 3
> openat(AT_FDCWD, "/usr/lib/python3.8/lib-dynload/_decimal.cpython-38-x86_64-linux-gnu.so", O_RDONLY|O_CLOEXEC) = 3
> openat(AT_FDCWD, "/etc/ld.so.cache", O_RDONLY|O_CLOEXEC) = 3
> openat(AT_FDCWD, "/lib/x86_64-linux-gnu/libmpdec.so.2", O_RDONLY|O_CLOEXEC) = 3
> openat(AT_FDCWD, "/usr/lib/python3.8/__pycache__/numbers.cpython-38.pyc", O_RDONLY|O_CLOEXEC) = 3
> openat(AT_FDCWD, "/usr/lib/python3/dist-packages/simplejson", O_RDONLY|O_NONBLOCK|O_CLOEXEC|O_DIRECTORY) = 3
> openat(AT_FDCWD, "/usr/lib/python3/dist-packages/simplejson/__pycache__/errors.cpython-38.pyc", O_RDONLY|O_CLOEXEC) = 3
> openat(AT_FDCWD, "/usr/lib/python3/dist-packages/simplejson/__pycache__/raw_json.cpython-38.pyc", O_RDONLY|O_CLOEXEC) = 3
> openat(AT_FDCWD, "/usr/lib/python3/dist-packages/simplejson/__pycache__/decoder.cpython-38.pyc", O_RDONLY|O_CLOEXEC) = 3
> openat(AT_FDCWD, "/usr/lib/python3/dist-packages/simplejson/__pycache__/compat.cpython-38.pyc", O_RDONLY|O_CLOEXEC) = 3
> openat(AT_FDCWD, "/usr/lib/python3/dist-packages/simplejson/__pycache__/scanner.cpython-38.pyc", O_RDONLY|O_CLOEXEC) = 3
> openat(AT_FDCWD, "/usr/lib/python3/dist-packages/simplejson/_speedups.cpython-38-x86_64-linux-gnu.so", O_RDONLY|O_CLOEXEC) = 3
> openat(AT_FDCWD, "/usr/lib/python3/dist-packages/simplejson/__pycache__/encoder.cpython-38.pyc", O_RDONLY|O_CLOEXEC) = 3
> openat(AT_FDCWD, "/usr/lib/python3.8/http/__pycache__/cookiejar.cpython-38.pyc", O_RDONLY|O_CLOEXEC) = 3
> openat(AT_FDCWD, "/usr/lib/python3.8/http/__pycache__/cookies.cpython-38.pyc", O_RDONLY|O_CLOEXEC) = 3
> openat(AT_FDCWD, "/usr/lib/python3/dist-packages/requests/__pycache__/cookies.cpython-38.pyc", O_RDONLY|O_CLOEXEC) = 3
> openat(AT_FDCWD, "/usr/lib/python3/dist-packages/requests/__pycache__/structures.cpython-38.pyc", O_RDONLY|O_CLOEXEC) = 3
> openat(AT_FDCWD, "/usr/lib/python3/dist-packages/requests/__pycache__/packages.cpython-38.pyc", O_RDONLY|O_CLOEXEC) = 3
> openat(AT_FDCWD, "/usr/lib/python3/dist-packages/idna/__pycache__/__init__.cpython-38.pyc", O_RDONLY|O_CLOEXEC) = 3
> openat(AT_FDCWD, "/usr/lib/python3/dist-packages/idna", O_RDONLY|O_NONBLOCK|O_CLOEXEC|O_DIRECTORY) = 3
> openat(AT_FDCWD, "/usr/lib/python3/dist-packages/idna/__pycache__/package_data.cpython-38.pyc", O_RDONLY|O_CLOEXEC) = 3
> openat(AT_FDCWD, "/usr/lib/python3/dist-packages/idna/__pycache__/core.cpython-38.pyc", O_RDONLY|O_CLOEXEC) = 3
> openat(AT_FDCWD, "/usr/lib/python3/dist-packages/idna/__pycache__/idnadata.cpython-38.pyc", O_RDONLY|O_CLOEXEC) = 3
> openat(AT_FDCWD, "/usr/lib/python3/dist-packages/idna/__pycache__/intranges.cpython-38.pyc", O_RDONLY|O_CLOEXEC) = 3
> openat(AT_FDCWD, "/usr/lib/python3/dist-packages/requests/__pycache__/models.cpython-38.pyc", O_RDONLY|O_CLOEXEC) = 3
> openat(AT_FDCWD, "/usr/lib/python3.8/encodings/__pycache__/idna.cpython-38.pyc", O_RDONLY|O_CLOEXEC) = 3
> openat(AT_FDCWD, "/usr/lib/python3.8/__pycache__/stringprep.cpython-38.pyc", O_RDONLY|O_CLOEXEC) = 3
> openat(AT_FDCWD, "/usr/lib/python3/dist-packages/requests/__pycache__/hooks.cpython-38.pyc", O_RDONLY|O_CLOEXEC) = 3
> openat(AT_FDCWD, "/usr/lib/python3/dist-packages/requests/__pycache__/auth.cpython-38.pyc", O_RDONLY|O_CLOEXEC) = 3
> openat(AT_FDCWD, "/usr/lib/python3/dist-packages/requests/__pycache__/status_codes.cpython-38.pyc", O_RDONLY|O_CLOEXEC) = 3
> openat(AT_FDCWD, "/usr/lib/python3/dist-packages/requests/__pycache__/api.cpython-38.pyc", O_RDONLY|O_CLOEXEC) = 3
> openat(AT_FDCWD, "/usr/lib/python3/dist-packages/requests/__pycache__/sessions.cpython-38.pyc", O_RDONLY|O_CLOEXEC) = 3
> openat(AT_FDCWD, "/usr/lib/python3/dist-packages/requests/__pycache__/adapters.cpython-38.pyc", O_RDONLY|O_CLOEXEC) = 3
> openat(AT_FDCWD, "/usr/lib/python3/dist-packages/urllib3/contrib/__pycache__/socks.cpython-38.pyc", O_RDONLY|O_CLOEXEC) = 3
> openat(AT_FDCWD, "/usr/lib/python3/dist-packages/requests_unixsocket", O_RDONLY|O_NONBLOCK|O_CLOEXEC|O_DIRECTORY) = 3
> openat(AT_FDCWD, "/usr/lib/python3/dist-packages/requests_unixsocket/__pycache__/adapters.cpython-38.pyc", O_RDONLY|O_CLOEXEC) = 3
> openat(AT_FDCWD, "/usr/lib/python3.8/__pycache__/configparser.cpython-38.pyc", O_RDONLY|O_CLOEXEC) = 3
> openat(AT_FDCWD, "/usr/lib/python3/dist-packages/apport/__pycache__/packaging_impl.cpython-38.pyc", O_RDONLY|O_CLOEXEC) = 3
> openat(AT_FDCWD, "/usr/lib/python3/dist-packages/apt/__pycache__/__init__.cpython-38.pyc", O_RDONLY|O_CLOEXEC) = 3
> openat(AT_FDCWD, "/usr/lib/python3/dist-packages/apt", O_RDONLY|O_NONBLOCK|O_CLOEXEC|O_DIRECTORY) = 3
> openat(AT_FDCWD, "/usr/lib/python3/dist-packages/apt/__pycache__/package.cpython-38.pyc", O_RDONLY|O_CLOEXEC) = 3
> openat(AT_FDCWD, "/usr/lib/python3.8/__pycache__/typing.cpython-38.pyc", O_RDONLY|O_CLOEXEC) = 3
> openat(AT_FDCWD, "/usr/lib/python3/dist-packages/apt/progress/__pycache__/__init__.cpython-38.pyc", O_RDONLY|O_CLOEXEC) = 3
> openat(AT_FDCWD, "/usr/lib/python3/dist-packages/apt/progress", O_RDONLY|O_NONBLOCK|O_CLOEXEC|O_DIRECTORY) = 3
> openat(AT_FDCWD, "/usr/lib/python3/dist-packages/apt/progress/__pycache__/text.cpython-38.pyc", O_RDONLY|O_CLOEXEC) = 3
> openat(AT_FDCWD, "/usr/lib/python3/dist-packages/apt/progress/__pycache__/base.cpython-38.pyc", O_RDONLY|O_CLOEXEC) = 3
> openat(AT_FDCWD, "/usr/lib/python3/dist-packages/apt/__pycache__/cache.cpython-38.pyc", O_RDONLY|O_CLOEXEC) = 3
> openat(AT_FDCWD, "/usr/lib/python3/dist-packages/apt/__pycache__/cdrom.cpython-38.pyc", O_RDONLY|O_CLOEXEC) = 3
> openat(AT_FDCWD, "/etc/apt/apt.conf.d/", O_RDONLY|O_NONBLOCK|O_CLOEXEC|O_DIRECTORY) = 3
> openat(AT_FDCWD, "/etc/apt/apt.conf.d/00CDMountPoint", O_RDONLY|O_NOCTTY|O_CLOEXEC) = 3
> openat(AT_FDCWD, "/etc/apt/apt.conf.d/00aptitude", O_RDONLY|O_NOCTTY|O_CLOEXEC) = 3
> openat(AT_FDCWD, "/etc/apt/apt.conf.d/00trustcdrom", O_RDONLY|O_NOCTTY|O_CLOEXEC) = 3
> openat(AT_FDCWD, "/etc/apt/apt.conf.d/01-vendor-ubuntu", O_RDONLY|O_NOCTTY|O_CLOEXEC) = 3
> openat(AT_FDCWD, "/etc/apt/apt.conf.d/01autoremove", O_RDONLY|O_NOCTTY|O_CLOEXEC) = 3
> openat(AT_FDCWD, "/etc/apt/apt.conf.d/01autoremove-kernels", O_RDONLY|O_NOCTTY|O_CLOEXEC) = 3
> openat(AT_FDCWD, "/etc/apt/apt.conf.d/20apt-esm-hook.conf", O_RDONLY|O_NOCTTY|O_CLOEXEC) = 3
> openat(AT_FDCWD, "/etc/apt/apt.conf.d/20packagekit", O_RDONLY|O_NOCTTY|O_CLOEXEC) = 3
> openat(AT_FDCWD, "/etc/apt/apt.conf.d/20snapd.conf", O_RDONLY|O_NOCTTY|O_CLOEXEC) = 3
> openat(AT_FDCWD, "/etc/apt/apt.conf.d/70debconf", O_RDONLY|O_NOCTTY|O_CLOEXEC) = 3
> openat(AT_FDCWD, "/usr/share/dpkg/cputable", O_RDONLY) = 3
> openat(AT_FDCWD, "/usr/share/dpkg/tupletable", O_RDONLY) = 4
> openat(AT_FDCWD, "/usr/lib/python3/dist-packages/apport/__pycache__/packaging.cpython-38.pyc", O_RDONLY|O_CLOEXEC) = 3
> openat(AT_FDCWD, "/usr/lib/python3/dist-packages/apport/__pycache__/hookutils.cpython-38.pyc", O_RDONLY|O_CLOEXEC) = 3
> openat(AT_FDCWD, "/usr/sbin/opensnoop-bpfcc", O_RDONLY|O_CLOEXEC) = 3
> openat(AT_FDCWD, "/usr/lib/python3/dist-packages/bcc/__init__.py", O_RDONLY|O_CLOEXEC) = 3
> openat(AT_FDCWD, "/proc/2155", O_RDONLY|O_CLOEXEC|O_PATH|O_DIRECTORY) = 3
> openat(3, "environ", O_RDONLY|O_CLOEXEC) = 4
> openat(3, "status", O_RDONLY|O_CLOEXEC) = 4
> openat(3, "cmdline", O_RDONLY|O_CLOEXEC) = 4
> openat(3, "maps", O_RDONLY|O_CLOEXEC)   = 4
> openat(3, "cgroup", O_RDONLY|O_CLOEXEC) = 4
> openat(AT_FDCWD, "/etc/nsswitch.conf", O_RDONLY|O_CLOEXEC) = 4
> openat(AT_FDCWD, "/etc/ld.so.cache", O_RDONLY|O_CLOEXEC) = 4
> openat(AT_FDCWD, "/lib/x86_64-linux-gnu/libnss_files.so.2", O_RDONLY|O_CLOEXEC) = 4
> openat(AT_FDCWD, "/etc/passwd", O_RDONLY|O_CLOEXEC) = 4
> openat(AT_FDCWD, "/etc/group", O_RDONLY|O_CLOEXEC) = 4
> openat(AT_FDCWD, "/etc/ld.so.cache", O_RDONLY|O_CLOEXEC) = 5
> openat(AT_FDCWD, "/lib/x86_64-linux-gnu/libnss_systemd.so.2", O_RDONLY|O_CLOEXEC) = 5
> openat(AT_FDCWD, "/run/systemd/userdb/", O_RDONLY|O_NONBLOCK|O_CLOEXEC|O_DIRECTORY) = 5
> openat(AT_FDCWD, "/proc/sys/kernel/random/boot_id", O_RDONLY|O_NOCTTY|O_CLOEXEC) = 5
> openat(AT_FDCWD, "/run/systemd/userdb/", O_RDONLY|O_NONBLOCK|O_CLOEXEC|O_DIRECTORY) = 5
> openat(AT_FDCWD, "/etc/apport/blacklist.d", O_RDONLY|O_NONBLOCK|O_CLOEXEC|O_DIRECTORY) = 4
> openat(AT_FDCWD, "/etc/apport/blacklist.d/README.blacklist", O_RDONLY|O_CLOEXEC) = 4
> openat(AT_FDCWD, "/etc/apport/blacklist.d/apport", O_RDONLY|O_CLOEXEC) = 4
> openat(AT_FDCWD, "/etc/apport/whitelist.d", O_RDONLY|O_NONBLOCK|O_CLOEXEC|O_DIRECTORY) = -1 ENOENT (No such file or directory)
> openat(AT_FDCWD, "/etc/passwd", O_RDONLY|O_CLOEXEC) = 4
> openat(AT_FDCWD, "/home/vagrant/.apport-ignore.xml", O_RDONLY|O_NOFOLLOW|O_CLOEXEC) = -1 ENOENT (No such file or directory)
> openat(AT_FDCWD, "/usr/sbin/opensnoop-bpfcc", O_RDONLY|O_CLOEXEC) = 4
> openat(AT_FDCWD, "/usr/lib/python3/dist-packages/bcc/__init__.py", O_RDONLY|O_CLOEXEC) = 4

6. Какой системный вызов использует `uname -a`? Приведите цитату из man по этому системному вызову, где описывается
   альтернативное местоположение в `/proc`, где можно узнать версию ядра и релиз ОС.

> Ответ:
> uname -a
> Linux vagrant 5.4.0-80-generic #90-Ubuntu SMP Fri Jul 9 22:49:44 UTC 2021 x86_64 x86_64 x86_64 GNU/Linux
> strace uname -a
> uname({sysname="Linux", nodename="vagrant", ...}) = 0
> sudo apt install manpages-dev
> Part  of  the  utsname information is also accessible via /proc/sys/kernel/{ostype, hostname, osre‐
> lease, version, domainname}.
> cat /proc/sys/kernel/{ostype,hostname,osrelease,version,domainname}
> Linux
> vagrant
> 5.4.0-80-generic
> 90-Ubuntu SMP Fri Jul 9 22:49:44 UTC 2021
> (none)

7. Чем отличается последовательность команд через `;` и через `&&` в bash? Например:
   ```shell position-relative overflow-auto
   root@netology1:~# test -d /tmp/some_dir; echo Hi
   Hi
   root@netology1:~# test -d /tmp/some_dir && echo Hi
   root@netology1:~#
   ```
   Есть ли смысл использовать в bash `&&`, если применить `set -e`?
> Ответ: && - логичесий оператор, ;; - последовательность
При && последующая команда выполняется только при успешном выполнении предыдущей команды.
Использовать set -e с && не имеет смысла поскольку команда set -e указывает оболочке выйти в случае когда команда дает ненулевой статус выполнения(то есть ошибку)


8. Из каких опций состоит режим bash `set -euxo pipefail` и почему его хорошо было бы использовать в сценариях?
> Ответ:
- Указав `set -e`, скрипт немедленно завершит работу, если любая команда выйдет с ошибкой. По-умолчанию же, игнорируются любые неудачи и сценарий продолжит выполняться.
- Указав `set -u`, оболочка проверяет инициализацию использующихся переменных в скрипте. Если определения переменной не будет, скрипт немедленно завершится.
- Указав `set -x`, bash печатает в стандартный вывод все команды перед их исполнением.
- Указав `set -o pipefail`, bash будет проверять успешность выполнения всех команд в конвейере |, а не только самой последней как происходит по умолчанию. При ошибке в любом месте конвейера pipe эта ошибка конкретной команды будет выведена на экран, и скрипт остановит свое выполнение по строкам.
- Собственно поэтому параметры `set -euxo pipefail` полезно использовать в скриптах.

9. Используя `-o stat` для `ps`, определите, какой наиболее часто встречающийся статус у процессов в системе. В `man ps`
   ознакомьтесь (`/PROCESS STATE CODES`) что значат дополнительные к основной заглавной буквы статуса процессов. Его
   можно не учитывать при расчете (считать S, Ss или Ssl равнозначными).
> Ответ:
> ps -o stat
> STAT
> Ss  Процесс ожидает выполнение (спит)
> R+  Процесс выполняется в данный момент

> PROCESS STATE CODES
> Here are the different values that the s, stat and state output specifiers (header "STAT" or "S") will display to describe the state of a process:
> D    uninterruptible sleep (usually IO)
> I    Idle kernel thread
> R    running or runnable (on run queue)
> S    interruptible sleep (waiting for an event to complete)
> T    stopped by job control signal
> t    stopped by debugger during the tracing
> W    paging (not valid since the 2.6.xx kernel)
> X    dead (should never be seen)
> Z    defunct ("zombie") process, terminated but not reaped by its parent
> For BSD formats and when the stat keyword is used, additional characters may be displayed:
> <    high-priority (not nice to other users)
> N    low-priority (nice to other users)
> L    has pages locked into memory (for real-time and custom IO)
> s    is a session leader
> l    is multi-threaded (using CLONE_THREAD, like NPTL pthreads do)
> +    is in the foreground process group
