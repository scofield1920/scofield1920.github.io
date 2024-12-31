# 2024 第一届Solar杯应急响应挑战赛


2024 第一届Solar杯应急响应挑战赛数据库、内存取证、流量分析wp

<!--more-->

## 数据库

题目附件：mssql、mssql题-备份数据库

### 数据库-1

> 请找到攻击者创建隐藏账户的时间
>
> flag格式 如 flag{2024/01/01 00:00:00}

x-ways加载镜像，导出\Windows\System32\config

![image-20241231195826196](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20241231195826196.png?imageSlim)

使用passwarekit恢复密码

使用rockyou字典进行破解

![image-20241231200955100](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20241231200955100.png?imageSlim)

将ovf导入VMware

事件查看器——>安全

过滤事件ID： 4720

![image-20241231203826377](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20241231203826377.png?imageSlim)

flag{2024/12/16 15:24:21}

### 数据库-2

> 请找到恶意文件的名称
>
> flag格式 如 flag{\*.\*}

![image-20241231204059325](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20241231204059325.png?imageSlim)

可疑进程XMRig miner

![image-20241231204152103](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20241231204152103.png?imageSlim)

进一步查看

![image-20241231204322503](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20241231204322503.png?imageSlim)

![image-20241231204339515](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20241231204339515.png?imageSlim)

flag{xmrig.exe}

### 数据库-3

> 请找到恶意文件的外联地址
>
> flag格式 如 flag{1.1.1.1}

查看xmrig.exe进程

```
C:\Users\Administrator>tasklist | findstr xmrig.exe
xmrig.exe                     3784 Services                   0     11,032 K
```

查看进程网络连接信息

```
C:\Users\Administrator>netstat -ano | findstr 3784
  TCP    61.139.2.132:49995     203.107.45.167:3333    SYN_SENT        3784
```

flag{203.107.45.167}

### 数据库-4

> 请修复数据库
>
> flag格式 如 flag{xxxxx}

参考

[【成功案例】lockbit家族百万赎金不必付！技术手段修复被加密的数据库，附溯源分析报告](https://mp.weixin.qq.com/s/VS5RefkuLwmCxla7-6D7kw)

勒索病毒只加密了文件头部

使用FileLocatorPro进行搜索

![image-20241231213730290](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20241231213730290.png?imageSlim)

flag{E4r5t5y6mhgur89g}

### 数据库-5

> 请提交powershell命令中恶意文件的MD5
>
> flag格式 如 flag{xxxxx}

在应用程序和服务日志中找到powershell的操作日志

筛选出事件ID为4104 执行远程命令的事件

![image-20241231215231323](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20241231215231323.png?imageSlim)

将base64编码的文件导出gz文件，并解压

![image-20241231215401168](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20241231215401168.png?imageSlim)

得到js代码文件

将其中base64的string再次解码

![image-20241231215653479](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20241231215653479.png?imageSlim)

![image-20241231215854011](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20241231215854011.png?imageSlim)

flag{d72000ee7388d7d58960db277a91cc40}

## 内存取证

### 内存取证-1

> 题目文件：SERVER-2008-20241220-162057
> 请找到rdp连接的跳板地址
> flag格式 flag{1.1.1.1}

![img](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/wps1.jpg?imageSlim)

flag{192.168.60.220}

 

### 内存取证-2

> 题目文件：SERVER-2008-20241220-162057
> 请找到攻击者下载黑客工具的IP地址
> flag格式 flag{1.1.1.1}

![img](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/wps2.jpg?imageSlim)

flag{155.94.204.67}

### 内存取证-3

> 攻击者获取的“FusionManager节点操作系统帐户（业务帐户）”的密码是什么
>

filescan

![image-20241231185712297](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20241231185712297.png?imageSlim)

随后文件转储

 ![image-20241231185741217](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20241231185741217.png?imageSlim)

 flag{GalaxManager_2012}

### 内存取证-4

> 题目文件：SERVER-2008-20241220-162057
> 请找到攻击者创建的用户
> flag格式 flag{xxxx}

![img](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/wps3.jpg?imageSlim)

flag{ASP.NET}

###  内存取证-5

> 题目文件：SERVER-2008-20241220-162057
>
> 请找到攻击者利用跳板rdp登录的时间

pslist

要转换一下时区，他的是UTC时区，北京时间是UTC+8

flag{2024/12/21 00:15:34 }

![image-20241231184230424](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20241231184230424.png?imageSlim)

### 内存取证-6

> 题目文件：SERVER-2008-20241220-162057
> 请找到攻击者创建的用户的密码哈希值
> flag格式 flag{XXXX}

Vol3进行密码哈希转储

![img](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/wps4.jpg?imageSlim)

flag{5ffe97489cbec1e08d0c6339ec39416d}

### 签到

本题作为签到题,请给出邮服发件顺序。

 flag格式为flag{domain1|...|domainN}

```
Received: from mail.da4s8gag.com ([140.143.207.229])
by newxmmxszc6-1.qq.com (NewMX) with SMTP id 6010A8AD
for ; Thu, 17 Oct 2024 11:24:01 +0800
X-QQ-mid: xmmxszc6-1t1729135441tm9qrjq3k
X-QQ-XMRINFO: NgToQqU5s31XQ+vYT/V7+uk=
Authentication-Results: mx.qq.com; spf=none smtp.mailfrom=;
dkim=none; dmarc=none(permerror) header.from=solar.sec
Received: from mail.solar.sec (VM-20-3-centos [127.0.0.1])
by mail.da4s8gag.com (Postfix) with ESMTP id 2EF0A60264
for ; Thu, 17 Oct 2024 11:24:01 +0800 (CST)
Date: Thu, 17 Oct 2024 11:24:01 +0800
To: hellosolartest@qq.com
From: 鍏嬪競缃戜俊
Subject:xxxxxxxxxx
Message-Id: <20241017112401.032146@mail.solar.sec>
X-Mailer: QQMail 2.x

XXXXXXXXXX
```

GPT给出的答复：

> 邮件的发送顺序可以通过分析邮件头中的 `Received` 字段来确定。`Received` 字段按照从下到上的顺序记录了邮件经过的服务器。以下是该邮件的发送顺序：
>
> 1. **邮件发送服务器**：
>    - 邮件最初从 `mail.solar.sec`（IP 地址为 `127.0.0.1`）发送。
>    - 通过 `mail.da4s8gag.com`（Postfix）服务器进行转发，时间戳为 `Thu, 17 Oct 2024 11:24:01 +0800 (CST)`。
> 2. **邮件接收服务器**：
>    - 邮件被传递到 `newxmmxszc6-1.qq.com`（NewMX）服务器，时间戳为 `Thu, 17 Oct 2024 11:24:01 +0800`。
>    - 最终由 `mx.qq.com` 服务器接收并完成验证。

## 日志流量

题目文件：tomcat-wireshark.zip/web

### 日志流量-1

> 新手运维小王的Geoserver遭到了攻击：
>
> 黑客疑似删除了webshell后门，小王找到了可能是攻击痕迹的文件但不一定是正确的，请帮他排查一下。
>
> flag格式 flag{xxxx}

![image-20241231221201352](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20241231221201352.png?imageSlim)

base64解码字符串得到flag

![image-20241231221318687](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20241231221318687.png?imageSlim)

flag{A7b4_X9zK_2v8N_wL5q4}

### 日志流量-2

> 新手运维小王的Geoserver遭到了攻击：
>
> 小王拿到了当时被入侵时的流量，其中一个IP有访问webshell的流量，已提取部分放在了两个pcapng中了。请帮他解密该流量。
>
> flag格式 flag{xxxx}

![image-20241231221740248](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20241231221740248.png?imageSlim)

哥斯拉流量，一把梭工具真好用....

```
flag{dD7g_jk90_jnVm_aPkcs}
```

手动分析：

根据题目1得到密钥为`a2550eeab0724a69`，加密方法为AES-ECB

追踪并解码哥斯拉webshell流量

![image-20241231222927852](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20241231222927852.png?imageSlim)

![image-20241231223330449](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20241231223330449.png?imageSlim)

![image-20241231223233526](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20241231223233526.png?imageSlim)

flag{sA4hP_89dFh_x09tY_lL4SI4}

### 日志流量-3

> 新手运维小王的Geoserver遭到了攻击：
>
> 小王拿到了当时被入侵时的流量，黑客疑似通过webshell上传了文件，请看看里面是什么。
>
> flag格式 flag{xxxx}

![image-20241231223707174](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20241231223707174.png?imageSlim)

导出为gz并解压，得到的数据文件修改后缀为pdf，得到：

![image-20241231223731489](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20241231223731489.png?imageSlim)flag{dD7g_jk90_jnVm_aPkcs}
