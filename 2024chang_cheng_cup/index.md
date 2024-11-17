# 2024 第一届长城杯铁人三项初赛


第五场比赛

<!--more-->

## misc

### [clocked]

![image-20240331194446706](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20240331194446706.png?imageSlim)

发现压缩包损坏

用010Editor打开进行文件头修复

添加`50 4B 03 04`文件头

解压得到

![image-20240331194748958](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20240331194748958.png?imageSlim)

发现是base64编码的图片，直接拖进赛博厨子

![image-20240401220700806](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20240401220700806.png?imageSlim)

导出png图片，进行cloacked解密

![image-20240402090935708](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20240402090935708.png?imageSlim)

得到输出文件，发现为zip压缩文件，解压得到flag

![image-20240402091113372](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20240402091113372.png?imageSlim)

### [ctfer]

爆破加密的压缩包，得到密码123321

![image-20240402091655832](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20240402091655832.png?imageSlim)

根据secret提示内容，进行wav提取

![image-20240402091755404](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20240402091755404.png?imageSlim)

查找wav文件头`57 41 56 45`

![image-20240402092038372](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20240402092038372.png?imageSlim)

随后进行stegpy解密`stegpy out.wav -p`

<img src="https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20240402153803916.png?imageSlim" alt="image-20240402153803916" style="zoom:150%;" />

### [Pcap-keep_going]

过滤器：`http.response==200`

得到RSA私钥和一张图片，其余流量全是加密过的，应该是TLS加密

![image-20240402154331138](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20240402154331138.png?imageSlim)

将`server.key`导出，并添加到`wireshark`

![image-20240402155500452](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20240402155500452.png?imageSlim)

![image-20240402155534685](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20240402155534685.png?imageSlim)

随后追踪TLS流即可得到解密流量

在3132流得到哥斯拉流量的key

![image-20240402184821139](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20240402184821139.png?imageSlim)

经过计算得解密key为`45e329feb5d925be`

拿来解密3149流中的请求体

![image-20240402184747991](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20240402184747991.png?imageSlim)

![image-20240402185050234](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20240402185050234.png?imageSlim)

![image-20240402185109913](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20240402185109913.png?imageSlim)

导出流量中的图片

![image-20240402185214237](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20240402185214237.png?imageSlim)

用steghide进行解密

`└─$ steghide extract -sf keep_going.jpg -p 053700357621`

![image-20240402185452407](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20240402185452407.png?imageSlim)

## web

web是wanan打的

### [dabaojian]

2019国赛华东北赛区线下赛几乎原题

[2019国赛华东北赛区线下 · Ywc's blog (yinwc.github.io)](https://yinwc.github.io/2019/06/02/2019国赛华东北赛区线下/#/DABAOJIAN)

![image-20240408223426693](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20240408223426693.png?imageSlim)

### [xff]

![image-20240408224127205](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20240408224127205.png?imageSlim)

Smarty模板注入

![image-20240408223707077](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20240408223707077.png?imageSlim)

### [api]

![](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20240408234431425.png?imageSlim)
