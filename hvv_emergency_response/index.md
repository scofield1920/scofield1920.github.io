# hvv_应急响应


HVV专题--应急响应

<!--more-->

常见的应急响应事件分类：

**Web入侵：**网页挂马、主页篡改、Webshell
**系统入侵：**病毒木马、勒索软件、远控后门
**网络攻击：**DDOS攻击、DNS劫持、ARP欺骗

基本思路流程：

**收集信息：**收集客户信息和中毒主机信息，包括样本
**判断类型：**判断是否是安全事件，何种安全事件，勒索、挖矿、断网、DoS 等等
**抑制范围：**隔离使受害⾯不继续扩⼤
**深入分析：**日志分析、进程分析、启动项分析、样本分析方便后期溯源
**清理处置：**杀掉进程，删除文件，打补丁，删除异常系统服务，清除后门账号防止事件扩大，处理完毕后恢复生产
**产出报告：**整理并输出完整的安全事件报告

# 入侵排查

被入侵主机的排查流程：

1. 定位被入侵的主机并且立即对该主机进行断网隔离
2. 确定攻击类型
3. 确定被入侵的时间范围
4. 定位恶意文件和入侵痕迹
5. 溯源入侵来源
6. 清理恶意文件/修复漏洞
7. 事件复盘

## Windows入侵排查

### 检查系统账号安全

查看服务器是否有弱口令，远程管理端口3389，22等端口是否对公网开放

```
可以问服务器管理人员，或者自行扫描测试
```

查看服务器是否存在可疑账号

```text
Win+R->lusrmgr.msc
```

<img src="https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20230714200224126.png" alt="image-20230714200224126" style="zoom: 67%;" />

#### 看**隐藏账号**、克隆账号

> 创建用户时，在用户名后面加上$，就会创建成隐藏账号。
>
> 隐藏用户不能在 `net user` 和控制面板中看到，需要用其他的方式。
>
> 1、lusrmgr.msc
> 2、注册表HKEY_LOCAL_MACHINE/SAM/SAM/Domains/Account/Users/Names/

```
在cmd中输入：net user 看看有没有陌生用户

在cmd中输入：regedit 找到注册表分支 “HKEY_LOCAL_MACHINE/SAM/SAM/Domains/Account/Users/Names/”看看有没有克隆用户（可以看到系统中的所有用户，包括隐藏用户）

关于克隆账号，看账号注册表中的F值和其他账号的F值是否相同
使用D盾_web查杀工具，集成了对克隆账号检测的功能
```

结合日志，查看管理员登录时间、用户名是否存在异常

```text
Win+R->eventvwr.msc
导出Windows的安全日志，利用LogParser进行分析
```

同时也要注意查看administrators组中是否存在赋权异常的账号。比如正常情况下guest用户处于禁用状态、普通应用账户(weblogic、apache、mysql)不需要在administrators组中。如下图，执行命令net user guest查看guest账号的信息，如果guest账号被启用，且在管理员组成员中有guest用户，需要询问客户运维人员该guest账户启用的必要性以及加入管理组是否有必要，否则可认为攻击者将系统自带用户guest启用并提权至管理员组后作为后门账号使用。

### 检查异常端口、进程

检查端口连接情况，是否有远程连接、可疑连接

```text
netstat -ano
tasklist | find "PID"
```

进程

```text
开始--运行--输入msinfo32，依次点击“软件环境→正在运行任务”就可以查看到进程的详细信息，比如进程路径、进程ID、文件创建日期、启动时间等。

使用D盾，查看可以进程，查看有没有签名信息，或者可以使用Process Explorer等工具查看
```

### 检查启动项、计划任务、服务

检查服务器是否有异常的启动项

```
火绒等安全软件查看
Win+R->regedit，打开注册表，查看开机启动项是否正常，特别注意一下三个注册表项
HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\run
HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\Run
HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\Runonce
```

检查计划任务

```text
控制面板->计划任务
Win+R->cmd->schtasks/at
```

服务自启动

```text
Win+R->services.msc
```

查看组策略

在无法使用工具、只能手工排查的情况下，可查看常见的自启项手否有异常文件。打开gpedit.msc--计算机配置/用户配置--Windows设置--脚本，在此处可设置服务器启动/关机或者用户登录/注销时执行的脚本。

![image-20230715085738072](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20230715085738072.png)

### 检查系统相关信息

查看系统版本以及补丁信息

```text
Win+R->cmd->systeminfo
```

查看可以目录及文件

```text
查看用户目录，新建账号会生成一个用户目录
Win+R->cmd->%UserProfile%\Recent：查看最近打开的文件进行分析
文件夹/文件可以根据时间排序，可以看看最近有没有什么可疑的文件夹/文件
```

### 自动化查杀

病毒查杀

```text
下载安全软件，更新病毒库，进行全盘扫描
```

Webshell查杀

```text
选择具体站点路径进行webshell查杀，建议最少选择两款查杀工具，可以互相补充规则库的不足
```

### 日志分析

系统日志

```text
前提：开启审核策略
Win+R->eventvwr.msc->导出安全日志->LogParser进行分析
```

Web访问日志

```text
找到中间件的web日志，打包到本地进行分析
Linux下可以使用Shell命令组合查询分析
```

### Windows安全事件ID

```
系统：
1074，通过这个事件ID查看计算机的开机、关机、重启的时间以及原因和注释。
6005，表示计算机日志服务已启动，如果出现了事件ID为6005，则表示这天正常启动了系统。
104，这个时间ID记录所有审计日志清除事件，当有日志被清除时，出现此事件ID。
安全：
4624，这个事件ID表示成功登陆的用户，用来筛选该系统的用户登陆成功情况。
4625，这个事件ID表示登陆失败的用户。
4720,4722,4723,4724,4725,4726,4738,4740,事件ID表示当用户帐号发生创建，删除，改变密码时的事件记录。
4727,4737,4739,4762,事件ID表示当用户组发生添加、删除时或组内添加成员时生成该事件。
```

## Linux入侵排查

### 账号安全

```text
用户信息文件/etc/passwd
影子文件/etc/shadow
```

命令：

`who`查看当前登录用户(tty本地登陆pts远程登录)
`w`查看系统信息，想知道某一时刻用户的行为
`uptime`查看登陆多久、多少用户，负载

入侵排查

```text
查询特权用户：awk -F: ‘$3==0{print $1}’ /etc/passwd
查询可以远程登录的账号：awk ‘/\$1|\$6/{print $1}’ /etc/shadow
查询具有sudo权限的账号：more /etc/sudoers | grep -v “^#\|^$” grep “ALL=(ALL)”
禁用或删除多余及可疑的帐号：
usermod -L user 禁用帐号，帐号无法登录，/etc/shadow第二栏为!开头
userdel user 删除user用户
userdel -r user 将删除user用户，并且将/home目录下的user目录一并删除
```

### 历史命令

> 必会命令：history
> 入侵排查：cat .bash_history >>history.txt

### 检查异常端口

```text
netstat -antlp|more

查看下pid所对应的进程文件路径，

运行ls -l /proc/$PID/exe或file /proc/$PID/exe（$PID 为对应的pid 号）
```

### 检查异常进程

```text
#查看当前开放端口
netstat -tnlp 

#查看当前系统上运行的所有进程
ps -ef

#查看进程
ps aux | grep pid

#可以直接看到进程实时情况
top

#查看cpu占用率前十的进程，互补top命令
ps aux --sort=pcpu | head -10
```

### 检查开机启动项

当我们需要开机启动自己的脚本时，只需要将可执行脚本丢在/etc/init.d目录下，然后在/etc/rc.d/rc*.d中建立软链  接即可

```text
more /etc/rc.local
	 /etc/rc.d/rc[0-6].d
ls -l /etc/rc.d/rc3.d/
```

### 检查定时任务

检查以下目录下是否有可疑文件

```text
/var/spool/cron/* 
/etc/crontab
/etc/cron.d/*
/etc/cron.daily/* 
/etc/cron.hourly/* 
/etc/cron.monthly/*
/etc/cron.weekly/
/etc/anacrontab
/var/spool/anacron/*
/etc/cron.daily/*
```

### 检查服务

```text
chkconfig
修改/etc/re.d/rc.local文件，加入/etc/init.d/httpd start
使用nesysv命令管理自启动
```

### 检查异常文件

```text
查看敏感目录，如tmp目录下的文件，同时注意隐藏文件夹，以”..”为名的文件夹具有隐藏属性
```

**得到发现WEBSHELL、远控木马的创建时间，如何找出同一时间范围内创建的文件？**

```
可以使用ﬁnd命令来查找，如 ﬁnd /opt -iname "*" -atime 1 -type f 找出 /opt 下一天前访问过的文件
```

### 检查系统日志

![image-20230715094745384](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20230715094745384.png)

日志默认存放位置：**/var/log**

日志分析技巧

```text
1、定位有多少IP在爆破主机的root帐号：
grep "Failed password for root" /var/log/secure | awk '{print $11}' | sort | uniq -c | sort -nr | more
定位有哪些IP在爆破：
grep "Failed password" /var/log/secure|grep -E -o "(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)"|uniq -c
爆破用户名字典是什么？
grep "Failed password" /var/log/secure|perl -e 'while($_=<>){ /for(.*?) from/; print "$1\n";}'|uniq -c|sort -nr
 
2、登录成功的IP有哪些： 	
grep "Accepted " /var/log/secure | awk '{print $11}' | sort | uniq -c | sort -nr | more
登录成功的日期、用户名、IP：
grep "Accepted " /var/log/secure | awk '{print $1,$2,$3,$9,$11}' 
3、增加一个用户kali日志：
Jul 10 00:12:15 localhost useradd[2382]: new group: name=kali, GID=1001
Jul 10 00:12:15 localhost useradd[2382]: new user: name=kali, UID=1001, GID=1001, home=/home/kali
, shell=/bin/bash
Jul 10 00:12:58 localhost passwd: pam_unix(passwd:chauthtok): password changed for kali
#grep "useradd" /var/log/secure 
4、删除用户kali日志：
Jul 10 00:14:17 localhost userdel[2393]: delete user 'kali'
Jul 10 00:14:17 localhost userdel[2393]: removed group 'kali' owned by 'kali'
Jul 10 00:14:17 localhost userdel[2393]: removed shadow group 'kali' owned by 'kali'
# grep "userdel" /var/log/secure
5、su切换用户：
Jul 10 00:38:13 localhost su: pam_unix(su-l:session): session opened for user good by root(uid=0)
sudo授权执行:
sudo -l
Jul 10 00:43:09 localhost sudo:    good : TTY=pts/4 ; PWD=/home/good ; USER=root ; COMMAND=/sbin/shutdown -
```

### 动态链接库 

> 遇到挖矿病毒，往往用ps，top等命令是看不到异常的，且即使kill掉进程和计划任务项往往过一会进程就会重新起来。这种情况往往是存在预加载恶意动态链接库的后门

使用 `readelf -Ws /bin/ls` 查看ls命令调用的库函数

![image-20230720122434031](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20230720122434031.png)

[警惕利用Linux预加载型恶意动态链接库的后门](https://www.freebuf.com/column/162604.html)

[应急响应系列之Linux库文件劫持技术分析](https://www.freebuf.com/articles/system/223311.html)

## Windows加固思路

1. 在 win ser2016 中如何管理重命名 administrator, 禁用 GUEST
2. 系统不显示上次登录的账户名。
3. 清理系统无效账户.
4. 按用户类型分配账号
5. 配置密码策略
6. 账户锁定策略
7. 远端系统强制关机设置,只指派给Administrators组
8. 本地关机设置,只指派给Administrators组
9. 用户权限指派
10. 授权账户本地登录
11. 授权账户从网络访问

## Windows命令

```
netstat -ano
查看开放端口

systeminfo
查看系统信息

net user 用户名/delete. 
删除用户

ipconfig/all
查看网络信息

shell whoami/all
查看所有用户信息

wmic process list brief
查询进程信息

wmic startup get command,caption
查看启动程序信息

shell tasklist
查看常见的杀毒软件进程

hostname
获取dns信息

net view
查看当前局域网中的计算机列表

net user
查看当前计算机中的用户

systeminfo | findstr /B /C:"OS Name" /C:"OS Version"
systeminfo | findstr /B /C:"OS 名称" /C:"OS 版本"
查询操作系统及软件信息

echo %PROCESSOR_ARCHITECTURE%
查看系统体系结构

powershell "Get-WmiObject -class Win32_Product |Select-Object -Property name, version"
使用PowerShell收集软件的版本信息

whoami && whoami /priv
查看当前权限

wmic service list brief
查询本机服务信息

wmic product get name, version 
查看安装的软件的版本、路径等


shell net view /domain
查看主域信息

shell net time /domain
查看时间服务器

shell net config workstation
查看当前的登录域与用户信息

nslookup god.org
寻找域dns服务器ip
```

## Linux加固思路

1. 删除无用账号
2. 检查特殊账号
3. 添加口令策略
4. 限制su
5. 进制root直接登录
6. 设置隐藏文件属性(先最小,后加)
7. 关闭不必要服务
8. 更改ssh端口号 防爆破
9. 记录日志

## webshell 流量信息

### Webshell流量监测思路

**1、特征分析：**分析流量特征中的关键特征，判断是否存在webshell流量特征；

**2、请求模式：**分析webshell流量的请求模式，可以通过分析URL，参数和头部信息来判断是否存在webshell流量；

**3、检测内容：**通过分析流量中的关键字等特征，判断是否存在webshell流量特征；

**4、字符集：**分析流量中的字符集是否webshell流量关联；

**5、加密算法：**分析流量中的加密算法，判断是否存在webshell流量特征；

**6、文件上传：**分析流量中是否存在文件上传性质等性质，判断是否存在webshell流量特征；

**7、恶意脚本：**分析流量中是否存在恶意脚本，判断是否存在webshell流量特征；

### 菜刀

请求体中传递的payload为**base64编码**

请求体中存在eval，base64等**特征字符**

传给cmd的这些流量字符中有自己的特征：1、都是系统命令；2、必须以分号结尾；3、数据包源一般是ip

还有一段以QG开头，7J结尾的固定代码。

> **中国菜刀2011版本及2014版本各语言WebShell链接流量特征**
>
> **(1) PHP类WebShell链接流量**
>
> 其中特征主要在body中，将body中流量进行url解码后如下：
>
> 其中特征点有如下三部分，
>
> 第一：“eval”，eval函数用于执行传递的攻击payload，这是必不可少的；
>
> 第二：(base64_decode($_POST[z0]))，(base64_decode($_POST[z0]))将攻击payload进行Base64解码，因为菜刀默认是将攻击载荷使用Base64编码，以避免被检测；
>
> 第三：&z0=QGluaV9zZXQ...，该部分是传递攻击payload，此参数z0对应$_POST[z0]接收到的数据，该参数值是使用Base64编码的，所以可以利用base64解码可以看到攻击明文。
>
> 注：
>
> 1.有少数时候eval方法会被assert方法替代。
>
> 2.$_POST也会被$_GET、$_REQUEST替代。
>
> 3.z0是菜刀默认的参数，这个地方也有可能被修改为其他参数名。
>
> **(2) JSP类WebShell链接流量：**
>
> 该流量是WebShell链接流量的第一段链接流量，其中特征主要在i=A&z0=GB2312，菜刀链接JSP木马时，第一个参数定义操作，其中参数值为A-Q，如i=A，第二个参数指定编码，其参数值为编码，如z0=GB2312，有时候z0后面还会接着又z1=参数用来加入攻击载荷。
>
> 注：其中参数名i、z0、z1这种参数名是会变的，但是其参数值以及这种形式是不会变得，最主要就是第一个参数值在A-Q，这种是不变的。
>
> **(3) ASP类WebShell链接流量：**
>
> 其中body流量进行URL解码后
>
> 其中特征点有如下三部分，
>
> 第一：“Execute”，Execute函数用于执行传递的攻击payload，这是必不可少的，这个等同于php类中eval函数；
>
> 第二：OnError ResumeNext，这部分是大部分ASP客户端中必有的流量，能保证不管前面出任何错，继续执行以下代码。
>
> 第三：Response.Write和Response.End是必有的，是来完善整个操作的。
>
> 这种流量主要识别这几部分特征，在正常流量中基本没有。
>
> 注：OnError Resume Next这个特征在大部分流量中存在，极少数情况没有。
>
> **中国菜刀2016版本各语言WebShell链接流量特征：**
>
> **(1) PHP类WebShell链接流量：**
>
> 其中特征主要在body中，将body中部分如下：
>
> 这个版本中流量最大的改变就是将特征进行打断混淆，这也给我们识别特征提供一种思路。
>
> 其中特征点有如下三部分，
>
> 第一：“"Ba"."SE6"."4_dEc"."OdE”，这部分是将base64解码打断使用.来连接。
>
> 第二：@ev"."al，这部分也是将@eval这部分进行打断连接，可以识别这段代码即可。
>
> 第三：QGluaV9zZXQoImRpc3BsYXlf...，该部分是传递攻击payload，payload依旧使用Base64编码的，所以可以利用base64解码可以看到攻击明文来识别。
>
> 注：有少数时候eval方法会被assert方法替代。
>
> **(2) JSP类WebShell链接流量：**
>
> 该版本JSPwebshell流量与之前版本一样，
>
> 所以分析如上：该流量是WebShell链接流量的第一段链接流量，其中特征主要在i=A&z0=GB2312，菜刀链接JSP木马时，第一个参数定义操作，其中参数值为A-Q，如i=A，第二个参数指定编码，其参数值为编码，如z0=GB2312，有时候z0后面还会接着又z1=、z2=参数用来加入攻击载荷。
>
> 注：其中参数名i、z0、z1这种参数名是会变的，但是其参数值以及这种形式是不会变得，最主要就是第一个参数值在A-Q，这种是不变的。
>
> **(3) ASP类WebShell链接流量：**
>
> 其中body流量为：
>
> 2016版本流量这链接流量最大的变化在于body中部分字符被unicode编码替换混淆，所以这种特征需要提取出一种形式来，匹配这个混淆特征，比如“字符+%u0000+字符+%u0000”这种形式来判断该流量。
>
> 或者直接将这部分代码直接进行unicode解码，可以获取到如2011或2014版本的asp所示的流量。可以根据上一段特征来进行判断。
>
> 这种流量主要识别这几部分特征，在正常流量中基本没有。

### 蚁剑

可以对流量进行加密、混淆，但有些关键代码没有被加密，如：PHP中的`ini_set`；ASP中的`OnError`，`response`

加密后后的数据包里面的参数大多都是_0x开头

`payload`用`base64`进行编码，数据包存在base加密的eval命令执行，数据包的payload内容存在几个分段内容，分别都使用base加密

> （1）蚁剑PHP类WebShell链接流量
>
> 其中body流量进行URL解码后为：
>
> 其中流量最中明显的特征为@ini_set("display_errors","0");这段代码基本是所有WebShell客户端链接PHP类WebShell都有的一种代码，但是有的客户端会将这段编码或者加密，而蚁剑是明文，所以较好发现。
>
> （2）蚁剑ASP类WebShell链接流量
>
> 其中body流量进行URL解码后为：
>
> 我们可以看出蚁剑针对ASP类的WebShell流量与菜刀的流量很像，其中特征也是相同，如OnError ResumeNext、Response.End、Response.Write，其中execute在蚁剑中被打断混淆了，变成了拼接形式Ex"&cHr(101)&"cute，同时该流量中也使用了eval参数，可以被认为明显特征。

### 冰蝎 3.0

一款动态二进制加密网站管理客户端。主要用于配合服务端shell的动态二进制加密通信，适用于WAF拦截回显等场景，客户端的流量无法检测

最大特点是交互流量进行AES对称加密，且加密秘钥是由随机数函数动态生成,因此该客户端的流量几乎无法检测

功能比较全，webshell本体容易被查杀，需要做webshell本体的免杀

请求数据包中的content-type字段常见为application/octet-stream；

PHP代码中可能存在eval、assert等关键词；

jsp代码中可能会有get class(),get class loader()等字符特征

### 冰蝎 4.0

增加了webshell生成功能，可以完全自定义流量加密方法，对流量加密的灵活性又大大增加

内置10个user-agent ,每次连接shell时会随机选择一个进行使用.

冰蝎4.0建立连接的同时，javaw也与目的主机建立tcp连接，每次连接使用本地端口在49700左右

冰蝎通讯默认使用长连接，请求头和响应头里会带有 Connection且Connection为 Keep-Alive

Accep和Content-Type为弱特征且Content-type:一般为Application/x-www-form-urlencoded，这里可作为辅助特征

有固定的请求头和响应头：

```
请求字节头：dFAXQV1LORcHRQtLRlwMAhwFTAg/M

响应字节头：TxcWR1NNExZAD0ZaAWMIPAZjH1BFBFtHThcJSlUXWEd
```

### 哥斯拉

是基于流量、HTTP全加密的webshell工具

全部类型的shell 能绕过市面所有静态查杀

哥斯拉流量加密能绕过市面全部流量waf

user-agent,如果不修改的话会返回使用的jdk信息

在请求包的Cookie中有一个非常致命的特征是会**在最后出现分号**

请求Accept和响应中Cache-Control字段（辅助认证）

响应包中的数据前16位为MD5+base64+后16位为MD5。

### Weevely

信息 payload 放于 accetp 头中，采用 gzip 压缩传输，使用异或加密。进行 base64 加密

## Webshell查杀工具

### D盾：

```text
http://www.d99net.net
```

### 百度WEBDIR+

```text
https://scanner.baidu.com
```

### 河马

```text
https://www.shellpub.com
```

### Web Shell Detector

```text
http://www.shelldetector.com
```

### CloudWalker(牧云)

```text
https://webshellchop.chaitin.cn
```

### 深度学习模型检测PHP Webshell

```text
http://webshell.cdxy.me
```

### PHP Malware Finder

```text
https://github.com/jvoisin/php-malware-finder
```

### findWebshell

```text
https://github.com/he1m4n6a/findWebshell
```

### 在线Webshell查杀工具

```text
http://tools.bugscaner.com/killwebshell
```

## Rootkit查杀

chkrootkit

网址：[http://www.chkrootkit.org](http://www.chkrootkit.org/)

rkhunter

[http://rkhunter.sourceforge.net](http://rkhunter.sourceforge.net/)

## 病毒查杀

Clamav

ClamAV的官方下载地址为：http://www.clamav.net/download.html

## 如何发现隐藏的Webshell后门

那么多代码里不可能我们一点点去找后门，另外，即使最好的Webshell查杀软件也不可能完全检测出来所有的后门，这个时候我们可以通过检测文件的完整性来寻找代码中隐藏的后门。

### 文件MD5校验

绝大部分软件，我们下载时都会有MD5文件，这个文件就是软件开发者通过md5算法计算出该如软件的“特征值”，下载下来后，我们可以对比md5的值，如果一样则表明这个软件是安全的，如果不一样则反之。

Linux中有一个命令：`md5sum`可以查看文件的md5值，同理，Windows也有命令或者工具可以查看文件的md5值

### Diff命令

```text
Linux中的命令，可以查看两个文本文件的差异
```

### 文件对比工具

```text
Beyond Compare
WinMerge
```

## 勒索病毒

### 勒索病毒搜索引擎

```text
360：http://lesuobingdu.360.cn
腾讯：https://guanjia.qq.com/pr/ls
启明：https://lesuo.venuseye.com.cn
奇安信：https://lesuobingdu.qianxin.com
深信服：https://edr.sangfor.com.cn/#/information/ransom_search
```

### 勒索软件解密工具集

```text
腾讯哈勃：https://habo.qq.com/tool
金山毒霸：http://www.duba.net/dbt/wannacry.html
火绒：http://bbs.huorong.cn/forum-55-1.html
瑞星：http://it.rising.com.cn/fanglesuo/index.html
Nomoreransom：https://www.nomoreransom.org/zh/index.html
MalwareHunterTeam：https://id-ransomware.malwarehunterteam.com
卡巴斯基：https://noransom.kaspersky.com
Avast：https://www.avast.com/zh-cn/ransomware-decryption-tools
Emsisoft：https://www.emsisoft.com/ransomware-decryption-tools/free-download
Github勒索病毒解密工具收集汇总：https://github.com/jiansiting/Decryption-Tools
```

# 免杀，病毒分析

免杀的话主要分为两种,一种是静态文件免杀,另一种是动态行为免杀

也有些师傅喜欢分为

1. 二进制免杀(无源码),只能通过修改asm代码 二进制数据 其他数据来完成免杀
2. 有源码的免杀,可以通过修改源代码来完成免杀,也可以结合二进制免杀的技术

### 静态文件免杀

a.特征码识别(病毒库在本地,模糊哈希匹配

b.云查杀(病毒库在云服务器

c.校验和法(本质还是特征码)

d.启发式扫描,通过机械学系把家族病毒特征归纳,聚类

**MYCCL查找特征码修改** 

找到杀软查杀的特征码，修改，替换，编码等等在不影响程序运行的情况下，把特征码改的面目全非，删掉也可以

**加花指令**

这是最有效也是最常用的方式，要点在于如何加话指令

**对shellcode进行加密编码**

比如在特定位置添加垃圾字符,

用硬编码的单字节密钥对字节进行异或加减法运算

把字节移位某些特定位置

交换连字节

### 动态行为免杀

某些敏感操作监控

注册表	组策略	防火墙	敏感程序	各种win32api	文件夹

绕过方法的话就是

**白加黑**

让win的一些白文件去执行敏感操作

**替换/找未导出的/重写/寻找底层api**

**替换调用顺序**

**通过调用其它进行功能来完成 API 的功能**

比较经典的如，通过 rundll32.exe 来完成 dll 加载，通过 COM 来操作文件等等。

### 分离免杀

```
shellcode从文本提取 
shellcode与加载器分离
远程加载shellcode（shellcode放在另一台主机上，走http协议下载）
管道运输
隐写在图片上，powershell加载
```

# 网站验证码利用点

### 验证码无效

有验证码模块,但是验证模块与业务功能没有关联性,此为无效验证,无论输入什么都正确

### 验证码由客户端生成 验证

验证码由客户端js生成并且仅仅在客户端用js验证,通过抓包查看是否有验证码字段或者是关闭js看能否通过验证.

### 验证码有回显

验证码在html或者cookie中显示,或者输出到response headers的其他字段,可被直接查看

### 验证码固定

也叫验证码重复使用,是指验证码没有设置使用期限,在验证码首次认证成功后没有删除在session中的验证码,使得验证码可以被多次成功验证,从而造成危害.

### 验证码可以爆破

服务端未对验证时间 次数做出限制,存在爆破的可能性,简单的系统存在可以直接爆破的可能性,但是做过一些防护的系统还得进行一些绕过才能进行爆破

### 验证码可猜解

验证码比较简单,可以通过推测猜到有哪些验证吗

### 可绕过

### 图片验证吗

 burpsuite插件推荐：    

        xp_captcha：https://github.com/smxiazi/NEW_xp_CAPTCHA
    
        captcha-kiler：https://github.com/c0ny1/captcha-killer/tags
    
        reCAPTCHA：https://github.com/bit4woo/reCAPTCHA/releases/tag/v1.0

## 短信验证码

### 短信轰炸

没有对发送短信验证码的发送时间 用户 ip做出限制

### 任意用户密码重置

https://blog.csdn.net/m0_47418965/article/details/121613640

https://www.freebuf.com/vuls/253833.html

# **hvv日记：**

https://blog.csdn.net/m0_61101264/article/details/130811974?spm=1001.2101.3001.6650.9&utm_medium=distribute.pc_relevant.none-task-blog-2%7Edefault%7EBlogCommendFromBaidu%7ERate-9-130811974-blog-131134229.235%5Ev38%5Epc_relevant_anti_vip_base&depth_1-utm_source=distribute.pc_relevant.none-task-blog-2%7Edefault%7EBlogCommendFromBaidu%7ERate-9-130811974-blog-131134229.235%5Ev38%5Epc_relevant_anti_vip_base&utm_relevant_index=10

# **参考资料：**

REEBUF《应急响应1入侵排查篇》

CN-SEC《【2022HVV系列】|7-Windows主机入侵痕迹排查办法》




