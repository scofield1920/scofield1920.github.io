# WireShark监听QQ通信数据获取对方IP


WireShark监听QQ通信数据获取对方IP

<!--more-->

## 只是一个有趣的小把戏

#### 一、打开Wireshark对目前的网络接口进行监听

随后打开QQ，给你的朋友打QQ电话，当对方接听后即可挂断，顺便停止Wireshark的捕获

#### 二、在Wireshark中按组合键`Ctrl+F`调出控制菜单

查找`020048`，同时选择选择`“分组详情”——“字符串”`
![image-20230629231838081](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20230629231838081.png)

> 这里利用的原理： UDP是QQ传输使用的协议 020048为 QQ所使用UDP协议的报文头

可多次点击找符合条件的记录，一般会有两种ip地址记录，一种是自己的局域网ip，另一种是对方的公网ip

**打语音和视频是直接能和对方建立连接，如果发文件，是直接发给腾讯的，抓不到包**

#### 三、在ip定位网站进行定位

https://www.chaipip.com/ip.php

![image-20230629232449256](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20230629232449256.png)

经过测试发现，只要对方在线，即便是没接电话也能监听到对方IP，但移动网络定位精度比较差，目前没有找到更高精度的定位方法
