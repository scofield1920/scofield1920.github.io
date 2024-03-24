# 记一次Linux挖矿木马应急响应


起因是服务器cpu占用过高，top得到陌生用户名和莫名其妙进程导致的高CPU占用，搜了一下进程名，发现是挖矿程序

<!--more-->

![image-20240317154254474](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20240317154254474.png)

查询此进程的网络连接情况，外连了矿池地址

![image-20240317154544645](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20240317154544645.png)

![image-20240317155717038](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20240317155717038.png)

/proc/目录下查找对应的pid号，找到kswapd0进程的详细信息

![image-20240317155953630](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20240317155953630.png)

查看进程工作空间

![image-20240317160044813](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20240317160044813.png)

检查test01定时任务

![image-20240317160528374](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20240317160528374.png)

先`crontab -e -u test01`把挖矿进程的定时任务清除

然后`find / -name kswapd0`将查询出来的可疑文件强制删除

直接将可疑用户删除，同时递归删除用户目录`userdel -rf test01`

最后将kswapd0进程杀掉`kill -9 136757`，同时监控其是否复活

以类似的方法清除blitz64，进入/proc目录的相应进程号

![image-20240317162131781](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20240317162131781.png)

进入/tmp/.X2k1-unix/，发现是.rsync文件夹和dota3.tar.gz文件

查了一下，rsync是挖矿木马的同步进程，dota3.tar.gz是亡命徒（Outlaw）挖矿僵尸网络第三版本的母体文件

> Outlaw挖矿僵尸网络自2018年11月开始首次出现第零版本和后续的第零版本变种，利用Shellshock(CVE-2014-7169)漏洞、Drupalgeddon2漏洞（CVE-2018-7600）漏洞和SSH暴力破解进行传播，使用的攻击武器为自研后门程序Shellbot、扫描暴力破解工具Haiduc和隐藏进程工具XHide，主要攻击平台为Linux，还有少量IoT设备，释放挖矿程序，主要挖取以太币和门罗币。在2019年3月出现第一版本，主要使用SSH暴力破解进行传播，攻击武器有自研后门程序Shellbot和扫描暴力破解工具tsm，主要攻击平台为Linux以及IoT设备。2019年6月出现第二版本，该版本周期时间短，可用性不高，在分析时发现很多脚本均未成功执行，故猜测该版本很有可能是测试版本，除扫描暴力破解工具换成ps外，其它均与第一版本一致。2020年7月至今，均使用第三版本进行攻击，该版本功能丰富，工具齐全，经过几个版本迭代，已经非常成熟，这个版本也是至今为止存活最久的一个版本，使用工具和传播方式等与之前几个版本并无明显变化。

统统删掉，然后杀死进程blitz64

最后重启服务器，监控test01用户的可疑进程是否复活

