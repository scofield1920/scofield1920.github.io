# VMware虚拟机通过物理机的vpn代理实现科学上网


接上一篇文章，先把原理搞通，实践起来会顺畅一些
这种方法相对简单很多，免去了部分繁琐的参数配置，随开随用，不影响其他进程的上网

- 环境：VMware中运行的Kali Linux
- 工具：proxychains4（kali）、v2ray（物理机）

### 首先在物理机中配置v2ray

<img src="https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20230222183306590.png" alt="image-20230222183306590" style="zoom: 80%;" />

设置-->参数设置

<img src="https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20230222183421455.png" alt="image-20230222183421455" style="zoom:80%;" />

本地监听端口10808，勾选划线部分

### 然后进行vmware的配置

<img src="https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20230222183710716.png" alt="image-20230222183710716" style="zoom:80%;" />

勾选，同时知悉VMware网络NAT模式走的网卡在物理机的终端中名为VMware8，同时在物理机终端输入ipconfig查询该虚拟网卡的ip地址

<img src="https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20230222183901000.png" alt="image-20230222183901000" style="zoom:80%;" />

### 接下来是VMware虚拟机中kali的配置

#### proxychains

> ### 0x1简介与安装
>
> ProxyChains是Linux和其他Unix下的代理工具。 它可以使任何程序通过代理上网， 允许TCP和DNS通过代理隧道， 支持HTTP、 SOCKS4和SOCKS5类型的代理服务器， 并且可配置多个代理。ProxyChains 只会将当前应用的 TCP 连接转发至代理，而非全局代理。
>
> ```text
> git clone https://github.com/rofl0r/proxychains-ng
> cd proxychains-ng
> ./configure
> sudo make && make install
> ```
>
> ### 0x2配置与使用
>
> ProxyChains 的配置文件位于 /etc/proxychains.conf ，打开后在末尾添加的代理。
>
> ```text
> [ProxyList]
> # add proxy here ...
> # meanwile
> # defaults set to "tor"
> #socks4    127.0.0.1 9050
> 
> # example
> socks5  127.0.0.1 8888
> ```
>
> proxychains 使用命令形式为：
>
> ```
> proxychains <运行的命令> <命令参数>
> ```
>
> ProxyChains 的使用方式非常简单，直接在应用程序前加上 proxychains4 即可。例如：
>
> ```text
> proxychains4 git clone https://github.com/rofl0r/proxychains-ng
> ```
>
> 除此之外也可以在任何应用上使用：
>
> ```text
> sudo proxychains4 apt-get update
> proxychains4 npm install
> ```
>
> 
>
> 然而，不能这样使用
>
> ```text
> proxychains4 ping google.com
> 
> [proxychains] config file found: /etc/proxychains.conf
> [proxychains] preloading /usr/local/lib/libproxychains4.dylib
> PING google.com (172.217.27.142): 56 data bytes
> Request timeout for icmp_seq 0
> Request timeout for icmp_seq 1
> Request timeout for icmp_seq 2
> Request timeout for icmp_seq 3
> Request timeout for icmp_seq 4
> ```
>
> **因为 proxychains 只会代理 TCP 连接，而 ping 使用的是 ICMP。**
>
> #### [其他配置]
>
> **dynamic_chain：**该配置项能够通过 ProxyList 中的每个代理运行流量，如果其中一
>
> 个代理关闭或者没有响应，它能够自动选择 ProxyList 中的下一个代理；
>
> **strict_chain：**改配置为 ProxyChains 的默认配置，不同于 dynamic_chain，也能够通
>
> 过 ProxyList 中的每个代理运行流量，但是如果 ProxyList 中的代理出现故障，不会自动
>
> 切换到下一个。
>
> **random_chain：**该配置项会从 ProxyList 中随机选择代理 IP 来运行流量，如果
>
> ProxyList 中有多个代理 IP，在使用 proxychains 的时候会使用不同的代理访问目标主机，
>
> 从而使主机端探测流量更加困难。

特别注意的是

![image-20230222184449956](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20230222184449956.png)

v2ray对局域网进行监听的端口是10810(socks协议)，在proxychains的配置文件中**不要写成10808**

![image-20230222184614602](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20230222184614602.png)

保存退出，就可以直接使用了，注意，由于新版kali的权限安全限制，使用proxychains不能是root用户

![image-20230222185005189](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20230222185005189.png)
