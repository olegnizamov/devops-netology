# Домашнее задание к занятию "3.6. Компьютерные сети, лекция 1"

1. Работа c HTTP через телнет.

- Подключитесь утилитой телнет к сайту stackoverflow.com
  `telnet stackoverflow.com 80`
- отправьте HTTP запрос

```bash
GET /questions HTTP/1.0
HOST: stackoverflow.com
[press enter]
[press enter]
```
- В ответе укажите полученный HTTP код, что он означает?

>Ответ
```bash
vagrant@vagrant:~$ telnet stackoverflow.com 80
Trying 151.101.193.69...
Connected to stackoverflow.com.
Escape character is '^]'.
GET /questions HTTP/1.0
HOST: stackoverflow.com
HTTP/1.1 301 Moved Permanently
cache-control: no-cache, no-store, must-revalidate
location: https://stackoverflow.com/questions
x-request-guid: 2b24724a-5098-4563-b7be-f56494f5ece0
feature-policy: microphone 'none'; speaker 'none'
content-security-policy: upgrade-insecure-requests; frame-ancestors 'self' https://stackexchange.com
Accept-Ranges: bytes
Date: Fri, 17 Dec 2021 13:05:04 GMT
Via: 1.1 varnish
Connection: close
X-Served-By: cache-hel1410021-HEL
X-Cache: MISS
X-Cache-Hits: 0
X-Timer: S1639746304.057901,VS0,VE109
Vary: Fastly-SSL
X-DNS-Prefetch-Control: off
Set-Cookie: prov=426b74ae-5139-4891-8324-fc4f6cf5421b; domain=.stackoverflow.com; expires=Fri, 01-Jan-2055 00:00:00 GMT; path=/; HttpOnly

Connection closed by foreign host.

301 - Страница перемещена на https://stackoverflow.com/questions
```

2. Повторите задание 1 в браузере, используя консоль разработчика F12.

- откройте вкладку `Network`
- отправьте запрос http://stackoverflow.com
- найдите первый ответ HTTP сервера, откройте вкладку `Headers`
- укажите в ответе полученный HTTP код.
- проверьте время загрузки страницы, какой запрос обрабатывался дольше всего?
- приложите скриншот консоли браузера в ответ.
- 
>Ответ
Ответ 200 - картинка 
![image](1.png)
illo-about-right.png  - самая долгая обработка
![image](2.png)


3. Какой IP адрес у вас в интернете?
>Ответ
```bash
46.0.20.240
```

4. Какому провайдеру принадлежит ваш IP адрес? Какой автономной системе AS? Воспользуйтесь утилитой `whois`

>Ответ
```bash
vagrant@vagrant:~$ sudo apt install whois
vagrant@vagrant:~$ whois 46.0.20.240
% This is the RIPE Database query service.
% The objects are in RPSL format.
%
% The RIPE Database is subject to Terms and Conditions.
% See http://www.ripe.net/db/support/db-terms-conditions.pdf

% Note: this output has been filtered.
%       To receive output for a database update, use the "-B" flag.

% Information related to '46.0.0.0 - 46.0.31.255'

% Abuse contact for '46.0.0.0 - 46.0.31.255' is 'abuse@domru.ru'

inetnum:        46.0.0.0 - 46.0.31.255
netname:        ESAMARA-PPPOE-8-NET
descr:          CJSC "ER-Telecom" Company" Samara
descr:          Samara, Russia
descr:          PPPoE individual customers network
country:        RU
admin-c:        ESMR1-RIPE
org:            ORG-CHSB3-RIPE
tech-c:         ESMR1-RIPE
status:         ASSIGNED PA
mnt-by:         RAID-MNT
created:        2010-08-20T08:36:32Z
last-modified:  2011-01-19T19:02:20Z
source:         RIPE # Filtered

organisation:   ORG-CHSB3-RIPE
org-name:       JSC "ER-Telecom Holding" Samara Branch
org-type:       OTHER
descr:          TM DOM.RU, Samara ISP
address:        Partizanskaya str., 86
address:        Samara, Russia, 443070
phone:          +7 (846) 202-88-78
fax-no:         +7 (846) 202-88-78
admin-c:        ESMR1-RIPE
tech-c:         ESMR1-RIPE
abuse-c:        RAID1-RIPE
mnt-ref:        RAID-MNT
mnt-by:         RAID-MNT
created:        2011-01-13T12:24:42Z
last-modified:  2019-10-15T14:05:29Z
source:         RIPE # Filtered

role:           ER-Telecom Samara ISP Contact Role
address:        AO "ER-Telecom Holding" Samara Branch
address:        Nikitinskaya, 53
address:        443041 Samara
address:        Russian Federation
phone:          +7 846 277-88-98
fax-no:         +7 846 277-88-98
admin-c:        RAID1-RIPE
tech-c:         RAID1-RIPE
nic-hdl:        ESMR1-RIPE
mnt-by:         MNT-ERTHOLDING
created:        2008-07-30T06:06:39Z
last-modified:  2019-11-26T07:16:39Z
source:         RIPE # Filtered

% Information related to '46.0.20.0/22AS34533'

route:          46.0.20.0/22
origin:         AS34533
org:            ORG-CHSB3-RIPE
descr:          CJSC "ER-Telecom Holding" Samara branch
descr:          Samara, Russia
mnt-by:         RAID-MNT
created:        2010-08-20T08:41:18Z
last-modified:  2011-01-19T06:12:06Z
source:         RIPE # Filtered

organisation:   ORG-CHSB3-RIPE
org-name:       JSC "ER-Telecom Holding" Samara Branch
org-type:       OTHER
descr:          TM DOM.RU, Samara ISP
address:        Partizanskaya str., 86
address:        Samara, Russia, 443070
phone:          +7 (846) 202-88-78
fax-no:         +7 (846) 202-88-78
admin-c:        ESMR1-RIPE
tech-c:         ESMR1-RIPE
abuse-c:        RAID1-RIPE
mnt-ref:        RAID-MNT
mnt-by:         RAID-MNT
created:        2011-01-13T12:24:42Z
last-modified:  2019-10-15T14:05:29Z
source:         RIPE # Filtered

% This query was served by the RIPE Database Query Service version 1.102.1 (BLAARKOP)
Провайдер - MNT-ERTHOLDING
Автономная система AS - AS34533
```

5. Через какие сети проходит пакет, отправленный с вашего компьютера на адрес 8.8.8.8? Через какие AS? Воспользуйтесь
   утилитой `traceroute`

>Ответ
```bash
vagrant@vagrant:~$ traceroute -AIn 8.8.8.8
traceroute to 8.8.8.8 (8.8.8.8), 30 hops max, 60 byte packets
 1  10.0.2.2 [*]  0.195 ms  0.169 ms  0.845 ms
 2  192.168.1.1 [*]  3.210 ms  3.126 ms  3.110 ms
 3  46.0.248.125 [AS34533]  4.317 ms  4.298 ms  4.201 ms
 4  85.113.62.33 [AS34533]  8.744 ms  9.480 ms  9.459 ms
 5  72.14.215.165 [AS15169]  37.935 ms  38.622 ms  38.607 ms
 6  72.14.215.166 [AS15169]  37.067 ms  19.462 ms  21.128 ms
 7  142.251.53.67 [AS15169]  15.648 ms  16.757 ms  16.746 ms
 8  108.170.250.83 [AS15169]  18.717 ms  19.412 ms  19.395 ms
 9  209.85.249.158 [AS15169]  32.267 ms * *
10  216.239.57.222 [AS15169]  33.124 ms  33.092 ms  33.069 ms
11  216.239.58.65 [AS15169]  34.474 ms  34.426 ms  34.230 ms
12  * * *
13  * * *
14  * * *
15  * * *
16  * * *
17  * * *
18  * * *
19  * * *
20  * * *
21  8.8.8.8 [AS15169]  33.954 ms  33.939 ms  32.957 ms
```

6. Повторите задание 5 в утилите `mtr`. На каком участке наибольшая задержка - delay?

>Ответ
```bash
vagrant@vagrant:~$ mtr -z 8.8.8.8

vagrant (10.0.2.15)                                                                            2021-12-17T12:39:41+0000
Keys:  Help   Display mode   Restart statistics   Order of fields   quit
                                                                               Packets               Pings
 Host                                                                        Loss%   Snt   Last   Avg  Best  Wrst StDev
 1. AS???    _gateway                                                         0.0%     7    0.2   0.2   0.1   0.2   0.0
 2. AS???    192.168.1.1                                                      0.0%     7    0.7   0.9   0.7   1.0   0.1
 3. AS34533  46x0x248x125.static-customer.samara.ertelecom.ru                14.3%     7    2.1   1.9   1.6   2.6   0.4
 4. AS34533  war1.samara.ertelecom.ru                                         0.0%     7   29.3  25.6   4.4  62.2  21.2
 5. AS15169  72.14.215.165                                                    0.0%     7   55.4  45.3  28.5  61.6  12.2
 6. AS15169  72.14.215.166                                                    0.0%     7   19.9  38.7  18.1  53.2  14.1
 7. AS15169  142.251.53.67                                                    0.0%     7   33.7  39.5  29.5  65.6  12.8
 8. AS15169  108.170.250.83                                                   0.0%     6   61.4  47.1  20.6  61.4  13.9
 9. AS15169  209.85.249.158                                                  60.0%     6   61.7  47.6  33.5  61.7  20.0
10. AS15169  216.239.57.222                                                   0.0%     6   41.1  49.6  32.5  70.0  14.6
11. AS15169  216.239.58.65                                                    0.0%     6   47.9  50.2  34.0  86.4  19.9
12. (waiting for reply)
13. (waiting for reply)
14. (waiting for reply)
15. (waiting for reply)
16. (waiting for reply)
17. (waiting for reply)
18. (waiting for reply)
19. (waiting for reply)
20. (waiting for reply)
21. AS15169  dns.google                                                       0.0%     6   56.8  60.3  51.1  73.4   8.1


11. AS15169  216.239.58.65 имеет самую максимальную среднюю задержку
```

7. Какие DNS сервера отвечают за доменное имя dns.google? Какие A записи? воспользуйтесь утилитой `dig`

>Ответ
```bash
vagrant@vagrant:~$ dig dns.google ns

; <<>> DiG 9.16.1-Ubuntu <<>> dns.google ns
;; global options: +cmd
;; Got answer:
;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 1196
;; flags: qr rd ra; QUERY: 1, ANSWER: 4, AUTHORITY: 0, ADDITIONAL: 1

;; OPT PSEUDOSECTION:
; EDNS: version: 0, flags:; udp: 65494
;; QUESTION SECTION:
;dns.google.                    IN      NS

;; ANSWER SECTION:
dns.google.             21600   IN      NS      ns2.zdns.google.
dns.google.             21600   IN      NS      ns3.zdns.google.
dns.google.             21600   IN      NS      ns4.zdns.google.
dns.google.             21600   IN      NS      ns1.zdns.google.

;; Query time: 116 msec
;; SERVER: 127.0.0.53#53(127.0.0.53)
;; WHEN: Fri Dec 17 12:43:49 UTC 2021
;; MSG SIZE  rcvd: 116


DNS сервера:
dns.google.             21600   IN      NS      ns2.zdns.google.
dns.google.             21600   IN      NS      ns3.zdns.google.
dns.google.             21600   IN      NS      ns4.zdns.google.
dns.google.             21600   IN      NS      ns1.zdns.google.
```

8. Проверьте PTR записи для IP адресов из задания 7. Какое доменное имя привязано к IP? воспользуйтесь утилитой `dig`

>Ответ
```bash
vagrant@vagrant:~$ dig -x 8.8.8.8

; <<>> DiG 9.16.1-Ubuntu <<>> -x 8.8.8.8
;; global options: +cmd
;; Got answer:
;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 912
;; flags: qr rd ra; QUERY: 1, ANSWER: 1, AUTHORITY: 0, ADDITIONAL: 1

;; OPT PSEUDOSECTION:
; EDNS: version: 0, flags:; udp: 65494
;; QUESTION SECTION:
;8.8.8.8.in-addr.arpa.          IN      PTR

;; ANSWER SECTION:
8.8.8.8.in-addr.arpa.   6772    IN      PTR     dns.google.

;; Query time: 0 msec
;; SERVER: 127.0.0.53#53(127.0.0.53)
;; WHEN: Fri Dec 17 12:45:03 UTC 2021
;; MSG SIZE  rcvd: 73
```

В качестве ответов на вопросы можно приложите лог выполнения команд в консоли или скриншот полученных результатов.

