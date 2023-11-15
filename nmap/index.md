# Nmap参数


# 基本操作

## 基本快速扫描

Nmap 默认发送一个 arp 的 ping 数据包，来探测一些常用端口是否开放。

```
CODE
nmap 10.130.1.43
```

## 快速扫描多个目标

```
BASHnmap <target ip1 address> <target ip2 address>
nmap 10.130.1.28 10.130.1.43
```



## 详细描述输出扫描

简单扫描，并对返回的结果详细描述输出，这个扫描是可以看到扫描的过程的，漫长的扫描的过程中可以看到百分比， 就不会显得那么枯燥，而且可以提升逼格。

```
CODE
nmap -vv 10.1.1.254
亲测，`-v` 和 `-vv` 扫描几乎是一样都，都是列出了详细的扫描过程。
```

## 指定端口和范围扫描

Nmap 默认扫描目标的常见端口号。我们可以通过参数 `-p` 来指定设置我们将要扫描的端口号：

```
BASHnmap -p(range) <target IP>
namp -p3389,20-100 10.130.1.43
```

## 扫描除过某一个 ip 外的所有子网主机

```
CODE
nmap 10.130.1.1/24 -exclude 10.130.1.1
```

## 扫描除过某一个文件中的 ip 外的子网主机

```
BASH
nmap 10.130.1.1/24 -excludefile gov.txt
```

## 显示扫描的所有主机的列表

```
BASH
nmap -sL 10.130.1.1/24
```

## sP ping 扫描

Nmap 可以利用类似 Window/Linux 系统下的 ping 方式进行扫描

```
BASH
nmap -sP <target ip>
```

一般来说 我们会用这个命令去扫描内网的一个 IP 范围，用来做内网的主机发现。

```
BASH
nmap -sP 10.130.1.1-255
```

PING 扫描不同于其它的扫描方式，因为它只用于找出主机是否是存在在网络中的。它不是用来发现是否开放端口的，PING 扫描需要 ROOT 权限。

## sS SYN 半开放扫描

```
BASH
nmap -sS 192.168.1.1
```

Tcp SYN Scan (sS) 这是一个基本的扫描方式，它被称为半开放扫描，因为这种技术使得 Nmap 不需要通过完整的握手，就能获得远程主机的信息。Nmap 发送 SYN 包到远程主机，但是它不会产生任何会话。因此**不会在目标主机上产生任何日志记录**，因为没有形成会话。这个就是 SYN 扫描的优势，如果 Nmap 命令中没有指出扫描类型，默认的就是 `Tcp SYN`。但是它同样也需要 `root/administrator` 权限。

## sT TCP 扫描

```
BASH
nmap -sT 192.168.1.1
```

不同于 Tcp SYN 扫描，Tcp connect () 扫描需要完成三次握手，并且要求调用系统的 connect ().Tcp connect () 扫描技术只适用于找出 TCP 和 UDP 端口。

## sU UDP 扫描

```
BASH
nmap -sU 192.168.1.1
```

这种扫描技术用来寻找目标主机打开的 UDP 端口，它不需要发送任何的 SYN 包，因为这种技术是针对 UDP 端口的。UDP 扫描发送 UDP 数据包到目标主机，并等待响应。如果返回 ICMP 不可达的错误消息，说明端口是关闭的，如果得到正确的适当的回应，说明端口是开放的。

## sF FIN 标志的数据包扫描

```
BASH
nmap -sF 110.130.1.43
```

可以看出这个扫描的话 会漏扫许多，FIN 扫描也不会在目标主机上创建日志（FIN 扫描的优势之一）。这个类型的扫描都是具有差异性的，FIN 扫描发送的包只包含 FIN 标识，NULL 扫描不发送数据包上的任何字节，XMAS 扫描发送 FIN、PSH 和 URG 标识的数据包。

## sV Version 版本检测扫描

```
BASH
nmap -sV 192.168.1.135
```

本检测是用来扫描目标主机和端口上**运行的软件的版本**。它不同于其它的扫描技术，它不是用来扫描目标主机上开放的端口，不过它需要从开放的端口获取信息来判断软件的版本。使用版本检测扫描之前需要先用 TCP SYN 扫描开放了哪些端口。这个扫描的话，速度会慢一些，`67.86` 秒扫一个 IP。

## O OS 操作系统类型的探测

```
BASH
nmap -O 10.130.1.43
```

远程检测操作系统和软件，Nmap 的 OS 检测技术在渗透测试中用来了解远程主机的操作系统和软件是非常有用的，通过获取的信息你可以知道已知的漏洞。Nmap 有一个名为的 nmap-OS-DB 数据库，该数据库包含超过 2600 种操作系统的信息。Nmap 把 TCP 和 UDP 数据包发送到目标机器上，然后检查结果和数据库对照。

## osscan-guess 猜测匹配操作系统

```
CODE
nmap -O --osscan-guess 192.168.1.134
```

通过 Nmap 准确的检测到远程操作系统是比较困难的，需要使用到 Nmap 的猜测功能选项，`–osscan-guess` 猜测认为最接近目标的匹配操作系统类型。

# PN No ping 扫描

```
BASH
nmap -O -PN 192.168.1.1/24
```

如果远程主机有防火墙，IDS 和 IPS 系统，你可以使用 -PN 命令来确保不 ping 远程主机，因为有时候防火墙会组织掉 ping 请求。`-PN` 命令告诉 Nmap 不用 ping 远程主机。有时候使用 `-PN` 参数可以绕过 PING 命令，但是不影响主机的系统的发现。

# T 设置时间模板

```
BASH
nmap -sS -T<0-5> 192.168.1.134
```

优化时间控制选项的功能很强大也很有效，但有些用户会被迷惑。此外， 往往选择合适参数的时间超过了所需优化的扫描时间。因此，Nmap 提供了一些简单的 方法，使用 6 个时间模板，使用时采用 - T 选项及数字 (0 - 5) 或名称。模板名称有 `paranoid (0)、sneaky (1)、polite (2)、normal(3)、 aggressive (4)和insane (5)`

- paranoid、sneaky 模式用于 IDS 躲避
- Polite 模式降低了扫描 速度以使用更少的带宽和目标主机资源。
- Normal 为默认模式，因此 - T3 实际上是未做任何优化。
- Aggressive 模式假设用户具有合适及可靠的网络从而加速扫描.
- nsane 模式假设用户具有特别快的网络或者愿意为获得速度而牺牲准确性。

## 网段扫描格式

```
BASH
nmap -sP <network address > </CIDR >  
```

解释：CIDR 为你设置的子网掩码 `(/24 , /16 ,/8 等)`

```
BASH10.1.1.0/24  =  10.1.1.1-10.1.1.255       # c段扫描
10.1.1.0/16  =  10.1.1.1-10.1.255.255     # b段扫描
10.1.1.0/8   =  10.1.1.1-10.255.255.255   # a段扫描
```

## 从文件中读取需要扫描的 IP 列表

```
BASH
nmap -iL ip-address.txt
```

## 路由跟踪扫描

路由器追踪功能，能够帮网络管理员了解网络通行情况，同时也是网络管理人员很好的辅助工具！通过路由器追踪可以轻松的查处从我们电脑所在地到目标地之间所经常的网络节点，并可以看到通过各个节点所花费的时间。

```
BASH
nmap -traceroute www.baidu.com
```

## A OS 识别 版本探测 脚本扫描和 traceroute 综合扫描

此选项设置包含了常见的端口 ping 扫描，操作系统扫描，脚本扫描，路由跟踪，服务探测。

```
BASH
nmap -A 10.130.1.43
```

## 命令混合式扫描

命令混合扫描，可以做到类似参数 `-A `所完成的功能，但又能细化到我们所需特殊要求。所以一般高手选择这个混合扫描：

```
BASH
nmap -vv -p1-100,3306,3389 -O -traceroute 10.130.1.43
```

这些参数都是可以灵活调用的，具体根据具体的扫描来使用各个参数。

```
BASH
nmap -p1-65535 -sV -sS -T4 10.130.1.134
```

使 `SYN` 扫描，并进行 Version 版本检测 使用 T4 (aggressive) 的时间模板对目标 IP 的全端口进行扫描。

## 输出格式

扫描的结果输出到屏幕，同时会存储一份到 grep-output.txt

```
BASH
nmap -sV -p 139,445 -oG grep-output.txt 10.0.1.0/24
```

输出 XML 格式：

```
S
nmap 10.0.1.0/24 -oX res.xml
```

扫描结果输出为 HTML 格式

```
BASH
nmap -sS -sV -T5 10.0.1.99 --webxml -oX - | xsltproc --output file.html
```

# Nmap 高级用法之脚本使用

## 按照脚本分类进行扫描

```
BASH
nmap --script 类别
```

nmap 官方脚本文档: https://nmap.org/nsedoc/
[![img](https://image.3001.net/2017/07/7822ed61bd955f648b1fae0408c09fa02.png)](https://image.3001.net/2017/07/7822ed61bd955f648b1fae0408c09fa02.png)

左侧列出了脚本的分类，点击分类可以看到每一个分类下有很多具体的脚本供我们使用。
`nmap --script=类别` 这里的类别，可以填写下面 14 大分类中的其中之一，也可以填写分类里面的具体漏洞扫描脚本。

Nmap 脚本分类:

```
VERILOG- auth: 负责处理鉴权证书（绕开鉴权）的脚本  
- broadcast: 在局域网内探查更多服务开启状况，如dhcp/dns/sqlserver等服务  
- brute: 提供暴力破解方式，针对常见的应用如http/snmp等  
- default: 使用-sC或-A选项扫描时候默认的脚本，提供基本脚本扫描能力  
- discovery: 对网络进行更多的信息，如SMB枚举、SNMP查询等  
- dos: 用于进行拒绝服务攻击  
- exploit: 利用已知的漏洞入侵系统  
- external: 利用第三方的数据库或资源，例如进行whois解析  
- fuzzer: 模糊测试的脚本，发送异常的包到目标机，探测出潜在漏洞
- intrusive: 入侵性的脚本，此类脚本可能引发对方的IDS/IPS的记录或屏蔽
- malware: 探测目标机是否感染了病毒、开启了后门等信息  
- safe: 此类与intrusive相反，属于安全性脚本  
- version: 负责增强服务与版本扫描（Version Detection）功能的脚本  
- vuln: 负责检查目标机是否有常见的漏洞（Vulnerability），如是否有MS08_067
```

## 使用具体脚本进行扫描

```
CODE
nmap --script 具体的脚本 www.baidu.com
```

## 常用脚本使用案例

### 扫描服务器的常见漏洞

```
BASH
nmap --script vuln <target>
```

### 检查 FTP 是否开启匿名登陆

```
BASHnmap --script ftp-anon <target>
PORT   STATE SERVICE
21/tcp open  ftp
| ftp-anon: Anonymous FTP login allowed (FTP code 230)
| -rw-r--r--   1 1170     924            31 Mar 28  2001 .banner
| d--x--x--x   2 root     root         1024 Jan 14  2002 bin
| d--x--x--x   2 root     root         1024 Aug 10  1999 etc
| drwxr-srwt   2 1170     924          2048 Jul 19 18:48 incoming [NSE: writeable]
| d--x--x--x   2 root     root         1024 Jan 14  2002 lib
| drwxr-sr-x   2 1170     924          1024 Aug  5  2004 pub
|_Only 6 shown. Use --script-args ftp-anon.maxlist=-1 to see all.
```

### 对 MySQL 进行暴破解

```
BASHnmap --script=mysql-brute <target>
3306/tcp open  mysql
| mysql-brute:
|   Accounts
|     root:root - Valid credentials
```

### 对 MSSQL 进行暴破解

```
BASHnmap -p 1433 --script ms-sql-brute --script-args userdb=customuser.txt,passdb=custompass.txt <host>
| ms-sql-brute:
|   [192.168.100.128\TEST]
|     No credentials found
|     Warnings:
|       sa: AccountLockedOut
|   [192.168.100.128\PROD]
|     Credentials found:
|       webshop_reader:secret => Login Success
|       testuser:secret1234 => PasswordMustChange
|_      lordvader:secret1234 => Login Success
```

### 对 Oracle 数据库进行暴破解

```
BASHnmap --script oracle-brute -p 1521 --script-args oracle-brute.sid=ORCL <host>
PORT     STATE  SERVICE REASON
1521/tcp open  oracle  syn-ack
| oracle-brute:
|   Accounts
|     system:powell => Account locked
|     haxxor:haxxor => Valid credentials
|   Statistics
|_    Perfomed 157 guesses in 8 seconds, average tps: 19
```

### 对 pgSQL 的暴力破解

```
BASHnmap -p 5432 --script pgsql-brute <host>
5432/tcp open  pgsql
| pgsql-brute:
|   root:<empty> => Valid credentials
|_  test:test => Valid credentials
```

### 对 SSH 进行暴力破解

```
BASHnmap -p 22 --script ssh-brute --script-args userdb=users.lst,passdb=pass.lst --script-args ssh-brute.timeout=4s <target>
22/ssh open  ssh
| ssh-brute:
|  Accounts
|    username:password
|  Statistics
|_   Performed 32 guesses in 25 seconds.
```

### 利用 DNS 进行子域名暴力破解

```
BASHnmap --script dns-brute www.baidu.com
λ nmap --script dns-brute www.baidu.com                      

Starting Nmap 7.50 ( https://nmap.org ) at 2017-07-25 13:12 ?
Nmap scan report for www.baidu.com (180.97.33.108)           
Host is up (0.018s latency).                                 
Other addresses for www.baidu.com (not scanned): 180.97.33.10
Not shown: 998 filtered ports                                
PORT    STATE SERVICE                                        
80/tcp  open  http                                           
443/tcp open  https                                          

Host script results:                                         
| dns-brute:                                                 
|   DNS Brute-force hostnames:                               
|     admin.baidu.com - 10.26.109.19                         
|     mx.baidu.com - 61.135.163.61                           
|     svn.baidu.com - 10.65.211.174                          
|     ads.baidu.com - 10.42.4.225                                                

Nmap done: 1 IP address (1 host up) scanned in 92.64 seconds
```

### 检查 VMWare ESX，ESXi 和服务器（CVE-2009-3733）中的路径遍历漏洞

```
BASHnmap --script http-vmware-path-vuln -p80,443,8222,8333 <host>
| http-vmware-path-vuln:
|   VMWare path traversal (CVE-2009-3733): VULNERABLE
|     /vmware/Windows 2003/Windows 2003.vmx
|     /vmware/Pentest/Pentest - Linux/Linux Pentest Bravo.vmx
|     /vmware/Pentest/Pentest - Windows/Windows 2003.vmx
|     /mnt/vmware/vmware/FreeBSD 7.2/FreeBSD 7.2.vmx
|     /mnt/vmware/vmware/FreeBSD 8.0/FreeBSD 8.0.vmx
|     /mnt/vmware/vmware/FreeBSD 8.0 64-bit/FreeBSD 8.0 64-bit.vmx
|_    /mnt/vmware/vmware/Slackware 13 32-bit/Slackware 13 32-bit.vmx
```

### 查询 VMware 服务器（vCenter，ESX，ESXi）SOAP API 以提取版本信息。

```
BASHλ nmap --script vmware-version -p443 10.0.1.4

Starting Nmap 7.50 ( https://nmap.org ) at 2017-07-25 12:26 ?D1ú±ê×?ê±??
Nmap scan report for 10.0.1.4
Host is up (0.0019s latency).

PORT    STATE SERVICE
443/tcp open  https
| vmware-version:
|   Server version: VMware ESXi 6.5.0
|   Build: 4887370
|   Locale version: INTL 000
|   OS type: vmnix-x86
|_  Product Line ID: embeddedEsx
Service Info: CPE: cpe:/o:vmware:ESXi:6.5.0

Nmap done: 1 IP address (1 host up) scanned in 6.28 seconds
```

# 参数详解

Nmap 支持主机名，网段的表示方式
例如:`blah.highon.coffee, namp.org/24, 192.168.0.1;10.0.0-25.1-254`

```
VERILOG-iL filename                    从文件中读取待检测的目标,文件中的表示方法支持机名,ip,网段
-iR hostnum                     随机选取,进行扫描.如果-iR指定为0,则是无休止的扫描
--exclude host1[, host2]        从扫描任务中需要排除的主机           
--exculdefile exclude_file      排除文件中的IP,格式和-iL指定扫描文件的格式相同
```

## 主机发现

```
VERILOG-sL                     仅仅是显示,扫描的IP数目,不会进行任何扫描
-sn                     ping扫描,即主机发现
-Pn                     不检测主机存活
-PS/PA/PU/PY[portlist]  TCP SYN Ping/TCP ACK Ping/UDP Ping发现
-PE/PP/PM               使用ICMP echo, timestamp and netmask 请求包发现主机
-PO[prococol list]      使用IP协议包探测对方主机是否开启   
-n/-R                   不对IP进行域名反向解析/为所有的IP都进行域名的反响解析
```

## 扫描技巧

```
VERILOG-sS/sT/sA/sW/sM                 TCP SYN/TCP connect()/ACK/TCP窗口扫描/TCP Maimon扫描
-sU                             UDP扫描
-sN/sF/sX                       TCP Null，FIN，and Xmas扫描
--scanflags                     自定义TCP包中的flags
-sI zombie host[:probeport]     Idlescan
-sY/sZ                          SCTP INIT/COOKIE-ECHO 扫描
-sO                             使用IP protocol 扫描确定目标机支持的协议类型
-b “FTP relay host”             使用FTP bounce scan
```

## 指定端口和扫描顺序

```
VERILOG-p                      特定的端口 -p80,443 或者 -p1-65535
-p U:PORT               扫描udp的某个端口, -p U:53
-F                      快速扫描模式,比默认的扫描端口还少
-r                      不随机扫描端口,默认是随机扫描的
--top-ports "number"    扫描开放概率最高的number个端口,出现的概率需要参考nmap-services文件,ubuntu中该文件位于/usr/share/nmap.nmap默认扫前1000个
--port-ratio "ratio"    扫描指定频率以上的端口
```

## 服务版本识别

```
VERILOG-sV                             开放版本探测,可以直接使用-A同时打开操作系统探测和版本探测
--version-intensity "level"     设置版本扫描强度,强度水平说明了应该使用哪些探测报文。数值越高，服务越有可能被正确识别。默认是7
--version-light                 打开轻量级模式,为--version-intensity 2的别名
--version-all                   尝试所有探测,为--version-intensity 9的别名
--version-trace                 显示出详细的版本侦测过程信息
```

## 脚本扫描

```
VERILOG-sC                             根据端口识别的服务,调用默认脚本
--script=”Lua scripts”          调用的脚本名
--script-args=n1=v1,[n2=v2]     调用的脚本传递的参数
--script-args-file=filename     使用文本传递参数
--script-trace                  显示所有发送和接收到的数据
--script-updatedb               更新脚本的数据库
--script-help=”Lua script”      显示指定脚本的帮助
```

## OS 识别

```
VERILOG-O              启用操作系统检测,-A来同时启用操作系统检测和版本检测
--osscan-limit  针对指定的目标进行操作系统检测(至少需确知该主机分别有一个open和closed的端口)
--osscan-guess  推测操作系统检测结果,当Nmap无法确定所检测的操作系统时，会尽可能地提供最相近的匹配，Nmap默认进行这种匹配
```

## 防火墙 / IDS 躲避和哄骗

```
VERILOG-f; --mtu value                 指定使用分片、指定数据包的MTU.
-D decoy1,decoy2,ME             使用诱饵隐蔽扫描
-S IP-ADDRESS                   源地址欺骗
-e interface                    使用指定的接口
-g/ --source-port PROTNUM       使用指定源端口  
--proxies url1,[url2],...       使用HTTP或者SOCKS4的代理

--data-length NUM               填充随机数据让数据包长度达到NUM
--ip-options OPTIONS            使用指定的IP选项来发送数据包
--ttl VALUE                     设置IP time-to-live域
--spoof-mac ADDR/PREFIX/VEBDOR  MAC地址伪装
--badsum                        使用错误的checksum来发送数据包
```

## Nmap 输出

```
VERILOG-oN                     将标准输出直接写入指定的文件
-oX                     输出xml文件
-oS                     将所有的输出都改为大写
-oG                     输出便于通过bash或者perl处理的格式,非xml
-oA BASENAME            可将扫描结果以标准格式、XML格式和Grep格式一次性输出
-v                      提高输出信息的详细度
-d level                设置debug级别,最高是9
--reason                显示端口处于带确认状态的原因
--open                  只输出端口状态为open的端口
--packet-trace          显示所有发送或者接收到的数据包
--iflist                显示路由信息和接口,便于调试
--log-errors            把日志等级为errors/warings的日志输出
--append-output         追加到指定的文件
--resume FILENAME       恢复已停止的扫描
--stylesheet PATH/URL   设置XSL样式表，转换XML输出
--webxml                从namp.org得到XML的样式
--no-sytlesheet         忽略XML声明的XSL样式表
```

## 其他 Nmap 选项

```
VERILOG-6                      开启IPv6
-A                      OS识别,版本探测,脚本扫描和traceroute
--datedir DIRNAME       说明用户Nmap数据文件位置
--send-eth / --send-ip  使用原以太网帧发送/在原IP层发送
--privileged            假定用户具有全部权限
--unprovoleged          假定用户不具有全部权限,创建原始套接字需要root权限
-V                      打印版本信息
-h                      输出帮助
```
