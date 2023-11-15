# kali linux 手动配网


kali linux 手动配网

## 0x1VMnet

打靶场的时候，方便起见，给kali配了静态

![image-20230519180130914](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20230519180130914.png)

kali是接入互联网且和win7处在统一内网段的主机，这边用的是NAT模式，同时把DHCP服务关掉了

![image-20230519180305725](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20230519180305725.png)

随后进kali手动配置，kali跟linux的通用配置并不一样

## 0x2kali linux

### 基本配置

```
nano /etc/network/interfaces
```

(vim或nano只是个人习惯问题，我习惯用nano)
手动添加以下内容：

```
auto eth0
iface eth0 inet static
address 192.168.126.111
netmask 255.255.255.0
gateway 192.168.126.1
```

![image-20230519180711307](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20230519180711307.png)

随后保存重启网络就ok

```
systemctl stop NetworkManager
```

随后重启网络

```
systemctl restart NetworkManager
```

![image-20230519180953722](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20230519180953722.png)

(如果不好用的话，重启一下就好了)

### 顺便写一下其他网络配置：

#### 临时IP配置：

```
ifconfig eth0:1 192.168.136.198
```

这样就可以给Kali Linux系统的eth0的网卡增加一个IP地址（Kali Linux系统允许一个网卡有两个IP地址）了，添加完成后的结果如下所示：

![image-20230519181207891](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20230519181207891.png)

但这种方式仅用于配置临时性的IP地址，当系统重启或者网络服务重启后，我们这样配置的IP地址即失效。

#### DNS配置：

```
nano /etc/resolv.conf
```

resolv.conf 的关键字主要有四个，分别是：

```
nameserver //定义DNS服务器的IP地址
domain //定义本地域名
search //定义域名的搜索列表
sortlist //对返回的域名进行排序
```

![image-20230519214450248](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20230519214450248.png)

然后重启网络服务

```
/etc/init.d/networking restart
```

看了网上许多师傅的博客，可能是因为版本差异，最后在配dns的resolv.conf文件里的写法可能并太一样，中途就遇到了dns死活不好用的情况，最终吧原来的网卡删了，重新开了个虚拟网卡，开启DHCP，win7和kali的网络就恢复正常了

