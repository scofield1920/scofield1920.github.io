# 2024第四届全国网络空间取证竞赛


赛后完整复现

<!--more-->

检材密码：

```
2024Fic@杭州Powered~by~HL!
```

## 手机部分

### 1.嫌疑人李某的手机型号是？

```
Xiaomi MI 4
```

![image-20240429003147316](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20240429003147316.png?imageSlim)

### 2.嫌疑人李某是否可能有平板电脑设备，如有该设备型号是？

```
Xiaomi Pad 6s
```

![2](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/2.png?imageSlim)

### 3.嫌疑人李某手机开启热点设置的密码是?

```
5aada11bc1b5
```

![image-20240429003033202](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20240429003033202.png?imageSlim)

### 4.嫌疑人李某的微信内部ID是？

```
wxid_wnigmud8aj6j12
```

![4](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/4.png?imageSlim)

### 5.嫌疑人李某发送给技术人员的网站源码下载地址是什么

```
http://www.honglian7001.com/down
```

![5](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/5.png?imageSlim)

### 6.受害者微信用户ID是？

```
wxid_u6umc696cms422
```

![image-20240429000706553](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20240429000706553.png?imageSlim)

![image-20240429000727923](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20240429000727923.png?imageSlim)

### 7.嫌疑人李某第一次连接WIFI的时间是？

```
03-14 16:55:57
```

![image-20240429003012929](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20240429003012929.png?imageSlim)

### 8.分析嫌疑人李某的社交习惯，哪一个时间段消息收发最活跃？

```
16:00-18:00
```

![image-20240429002758856](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20240429002758856.png?imageSlim)

### 9.请分析嫌疑人手机，该案件团伙中，还有一名重要参与者警方未抓获，该嫌疑人所使用的微信账号ID为？

```
wxid_kolc5oaiap6z22
```

案件材料写了李某和赵某喜被抓获

![image-20240429002627358](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20240429002627358.png?imageSlim)

![image-20240429002644744](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20240429002644744.png?imageSlim)

### 10.请分析嫌疑人手机，嫌疑人老板组织人员参与赌博活动，所使用的国内访问入口地址为？

```
192.168.110.110:8000/login
```

![image-20240429002719532](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20240429002719532.png?imageSlim)

## 服务器集群题

### 1.esxi服务器的esxi版本为？

```
6.7.0
```

![image-20240429113036541](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20240429113036541.png?imageSlim)

### 2.请分析ESXi服务器，该系统的安装日期为：

```
2024 年 3 月 12 日 星期二 02:04:15 UTC
```

创建一个新的仅主机vm网卡，网段为192.168.8.0，空密码登录

![image-20240429114907572](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20240429114907572.png?imageSlim)

![image-20240429115010725](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20240429115010725.png?imageSlim)

### 3.请分析ESXi服务器数据存储“datastore”的UUID是？

```
65efb8a8-ddd817f6-04ff-000c297bd0e6
```

由于重写Raid造成ESXi6.7存储名称丢失数据文件不能访问

存储丢失了，要恢复一下

```
[root@localhost:~] esxcfg-volume -l
Scanning for VMFS-6 host activity (4096 bytes/HB, 1024 HBs).
VMFS UUID/label: 65efb8a8-ddd817f6-04ff-000c297bd0e6/datastore1
Can mount: Yes
Can resignature: Yes
Extent name: t10.ATA_____VMware_Virtual_IDE_Hard_Drive___________00000000000000000001:3 range: 0 - 197119 (MB)


[root@localhost:~] esxcfg-volume -m 65efb8a8-ddd817f6-04ff-000c297bd0e6
Mounting volume 65efb8a8-ddd817f6-04ff-000c297bd0e6
```

![image-20240429115425857](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20240429115425857.png?imageSlim)

![image-20240429115515623](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20240429115515623.png?imageSlim)

![image-20240429115740329](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20240429115740329.png?imageSlim)

### 4.ESXI服务器的原IP地址？

```
192.168.8.112
```

![image-20240429113803287](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20240429113803287.png?imageSlim)

### 5.EXSI服务器中共创建了几个虚拟机？

```
4
```

![image-20240429115840592](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20240429115840592.png?imageSlim)

### 6.网站服务器绑定的IP地址为？

```
192.168.8.89
```

![image-20240507234710522](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20240507234710522.png?imageSlim)

fscan扫描，结合超级弱口令扫描，确定服务信息

![image-20240507234903816](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20240507234903816.png?imageSlim)

192.168.8.89 是 web 服务器对应 www 这台虚拟机，密码为 qqqqqq
192.168.8.16 是聊天服务器，对应 rocketchat 这台虚拟机，密码未知
192.168.8.142 对应为 data 这台虚拟机，密码为 hl@7001

### 7.网站服务器的登录密码为？

```
qqqqqq
```

根据题目信息，在Windows镜像中找到一个Commonpwd.txt，如上题爆破，得到密码

若出现该问题：

[VMware Workstation 在此主机上不支持嵌套虚拟化](http://blog.chinaunix.net/uid-20182470-id-5876873.html)

管理员权限power shell执行：

```
bcdedit /set hypervisorlaunchtype off
```

### 8.网站服务器所使用的管理面板登陆入口地址对应的端口号为

```
14131
```

![image-20240508003610520](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20240508003610520.png?imageSlim)

![image-20240508004644180](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20240508004644180.png?imageSlim)

### 9.网站服务器的web目录是？

```
/webapp
```

在根目录的/webapp下发现网站信息

### 10.网站配置中Redis的连接超时时间为多少秒

```
10s
```

![image-20240508010336498](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20240508010336498.png?imageSlim)

![image-20240508010252668](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20240508010252668.png?imageSlim)

### 11.网站普通用户密码中使用的盐值为

```
!@#qaaxcfvghhjllj788+)_)((
```

![image-20240508010021741](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20240508010021741.png?imageSlim)

### 12.网站管理员用户密码的加密算法名称是什么

```
bcrypt
```

![image-20240508084016443](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20240508084016443.png?imageSlim)

### 13.网站超级管理员用户账号创建的时间是？

```
2022-05-09 14:44:41
```

exsi中data是数据库虚拟机，跟网站实行站库分离

登录data，发现docker中有mysql镜像，启动一下

![image-20240508085020564](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20240508085020564.png?imageSlim)

宝塔处可以连接，随后用navicat连接到服务器的数据库

数据库账号密码在宝塔面板可查看

在sys_user表中可看到超级管理员账户创建的时间

![image-20240508085228656](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20240508085228656.png?imageSlim)

### 14.重构进入网站之后，用户管理下的用户列表页面默认有多少页数据

```
877
```

根据Windows镜像中获取的运维笔记

![image-20240508090412796](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20240508090412796.png?imageSlim)

对ruoyi的jar包进行修改

```
jar xf ruoyi-admin.jar BOOT-INF/classes/application-druid.yml
```

```
vim BOOT-INF/classes/application-druid.yml
```

改成data虚拟机的IP，password要改成宝塔中数据库对应用户的密码

![image-20240508090856904](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20240508090856904.png?imageSlim)

更新jar包配置

```
jar uf ruoyi-admin.jar BOOT-INF/classes/application-druid.yml
```

![image-20240508091936759](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20240508091936759.png?imageSlim)

随后

```bash
[root@localhost webapp]# chmod 777 restart.sh 
[root@localhost webapp]# ls
BOOT-INF  dist0906  index.html  luck-prize  qz          ruoyi-admin.jar      ruoyi-admin.jar0827   ruoyi-admin.jar0904  ruoyi-admin.jar 7.19  ruoyi-admin.jar8.15   ruoyi-admin.jarbak  test
dist      down      kill.sh     nohup.out   qz 7.11     ruoyi-admin.jar0818  ruoyi-admin.jar0828   ruoyi-admin.jar0907  ruoyi-admin.jar 7.26  ruoyi-admin.jar8.151  ruoyi-admin.pid
dist0826  group     logs        profile     restart.sh  ruoyi-admin.jar0826  ruoyi-admin.jar08281  ruoyi-admin.jar0915  ruoyi-admin.jar8.14   ruoyi-admin.jar8.16   start.sh
[root@localhost webapp]# ./restart.sh 
32099
```

还是不行，根据报错进一步修复

添加一条127.0.0.1 localhost映射到hosts中

```
echo '127.0.0.1 localhost' > /etc/hosts
```

 sys_job表

![image-20240510090432732](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20240510090432732.png?imageSlim)

修改后

![image-20240510090455104](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20240510090455104.png?imageSlim)

启动：

```
java -jar ruoyi-admin.jar
```

![image-20240510094200512](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20240510094200512.png?imageSlim)

```
chmod 777 restart.sh
./restart.sh start
```

替换一个密码进去

[在线Bcrypt密码生成工具-Bejson.com](https://www.bejson.com/encrypt/bcrpyt_encode/)

![image-20240510090626125](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20240510090626125.png?imageSlim)

![image-20240510094221800](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20240510094221800.png?imageSlim)

进入192.168.8.89网站页面

![image-20240510094306894](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20240510094306894.png?imageSlim)

![image-20240510094400427](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20240510094400427.png?imageSlim)

### 15.该网站的系统接口文档版本号为

```
3.8.2
```

![image-20240510090712865](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20240510090712865.png?imageSlim)

### 16.该网站获取订单列表的接口

```
/api/shopOrder
```

![image-20240510094545488](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20240510094545488.png?imageSlim)

### 17.受害人卢某的用户ID

```
10044888
```

![image-20240510094614266](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20240510094614266.png?imageSlim)

根据手机聊天记录得知其账号

![image-20240510094722449](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20240510094722449.png?imageSlim)

### 18.受害人卢某一共充值了多少钱

```
465222
```

![image-20240510094953068](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20240510094953068.png?imageSlim)

### 19.网站设置的单次抽奖价格为多少元

```
10
```

![image-20240510095103836](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20240510095103836.png?imageSlim)

### 20.网站显示的总余额数是

```
7354468.56
```

![image-20240510095206217](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20240510095206217.png?imageSlim)

### 21.网站数据库的root密码

```
my-secret-pw"
```

docker inspect 9b

![image-20240510095733134](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20240510095733134.png?imageSlim)

### 22.数据库服务器的操作系统版本是

```
7.9.2009
```

![image-20240510095931175](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20240510095931175.png?imageSlim)

### 23.数据库服务器的Docker Server版本是

```
1.13.1
```

![image-20240510100026378](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20240510100026378.png?imageSlim)

### 24.数据库服务器中数据库容器的完整ID是

```
9bf1cecec3957a5cd23c24c0915b7d3dd9be5238322ca5646e3d9e708371b765
```

![image-20240510110711380](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20240510110711380.png?imageSlim)

### 25.数据库服务器中数据库容器使用的镜像ID

```
66c0e7ca4921e941cbdbda9e92242f07fe37c2bcbbaac4af701b4934dfc41d8a
```

![image-20240510110915003](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20240510110915003.png?imageSlim)

### 26.数据库服务器中数据库容器创建的北京时间

```
2024/3/13 20:15:23
```

![image-20240510110959943](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20240510110959943.png?imageSlim)

### 27.数据库服务器中数据库容器的ip是

```
172.17.0.2
```

![image-20240510112415599](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20240510112415599.png?imageSlim)

### 28.分析数据库数据，在该平台邀请用户进群最多的用户的登录IP是

```
182.33.2.250
```

![image-20240510113223608](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20240510113223608.png?imageSlim)

![image-20240510113319137](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20240510113319137.png?imageSlim)

### 29.分析数据库数据，在该平台抢得最多红包金额的用户的登录IP是

```
43.139.0.193
```

![image-20240510113417524](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20240510113417524.png?imageSlim)

回查该id的登录id即可

### 30.数据库中记录的提现成功的金额总记是多少（不考虑手续费）

```
35821148.48
```

![image-20240510113523086](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20240510113523086.png?imageSlim)

### 31.rocketchat服务器中，有几个真实用户？

```
3
```

esxi得到ip，然后默认端口是3000

rocketchat:http://192.168.8.130:3000/home

账号密码在解密的容器里

```
admin@admin.com
Zhao
```

![image-20240510113833547](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20240510113833547.png?imageSlim)
![image-20240510114636446](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20240510114636446.png?imageSlim)

![image-20240510114900487](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20240510114900487.png?imageSlim)

### 32.rocketchat服务器中，聊天服务的端口号是？

```
3000
```

### 33.rocketchat服务器中，聊天服务的管理员的邮箱是？

```
admin@admin.com
```

![image-20240510115312352](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20240510115312352.png?imageSlim)

### 34.rocketchat服务器中，聊天服务使用的数据库的版本号是？

```
5.0.24
```

![image-20240510120631407](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20240510120631407.png?imageSlim)

### 35.rocketchat服务器中，最大的文件上传大小是？（以字节为单位）

```
104857600
```

![image-20240510120653480](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20240510120653480.png?imageSlim)

### 36.rocketchat服务器中，管理员账号的创建时间为？

```
2024/3/14 8:19:54
```

重置密码https://cn.linux-console.net/?p=1538

在启动系统时按e进入编辑模式

![image-20240510135016080](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20240510135016080.png?imageSlim)

在此处

![image-20240510135256041](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20240510135256041.png?imageSlim)

修改为`rw single init=/bin/bash`

![image-20240510135422473](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20240510135422473.png?imageSlim)

随后按CTRL+x，进入命令行模式

输入mount -a ，之后passwd root进行密码更新，然后重启即可登录

![image-20240510140419971](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20240510140419971.png?imageSlim)

开启**ssh**允许**root**用户密码登录

```
vi /etc/ssh/sshd_config
```

![image-20240510140622473](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20240510140622473.png?imageSlim)

去掉注释

![image-20240510140756755](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20240510140756755.png?imageSlim)

开启允许root用户登录

![image-20240510143332719](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20240510143332719.png?imageSlim)

保存，重启sshd `systemctl restart sshd`

![image-20240510141059370](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20240510141059370.png?imageSlim)

`docker inspect 92 | more`

![image-20240510142137059](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20240510142137059.png?imageSlim)

使用ssh隧道连接容器内的MongoDB

![image-20240510142555799](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20240510142555799.png?imageSlim)

![image-20240510143321806](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20240510143321806.png?imageSlim)

![image-20240510143637652](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20240510143637652.png?imageSlim)

### 37.rocketchat服务器中，技术员提供的涉诈网站地址是？

```
http://172.16.80.47
```

![](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20240510120850366.png?imageSlim)

### 38.综合分析服务器，该团伙的利润分配方案中，老李的利润占比是多少

```
35%
```

![image-20240510120850366](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20240510120850366.png?imageSlim)

### 39.综合分析服务器，该团队“杀猪盘”收网的可能时间段为

```
2024/3/15 16:00:00-17:00:00
```

![image-20240510120922267](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20240510120922267.png?imageSlim)

### 40.请综合分析，警方未抓获的重要嫌疑人，其使用聊天平台时注册邮箱号为？

```
lao@su.com
```

![image-20240510121042998](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20240510121042998.png?imageSlim)

### 41.分析openwrt镜像，该系统的主机名为

```
iStoreOS
```

![image-20240510143924829](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20240510143924829.png?imageSlim)

访问http://192.168.8.131/，root/hl@7001

![image-20240510144156806](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20240510144156806.png?imageSlim)

### 42.分析openwrt镜像，该系统的内核版本为

```
5.10.201
```

图见上题

### 43.分析openwrt镜像，该静态ip地址为

```
192.168.8.5
```

在Windows的访问记录里

![image-20240510144316921](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20240510144316921.png?imageSlim)

### 44.分析openwrt镜像，所用网卡的名称为

```
br-lan
```

![image-20240510144421770](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20240510144421770.png?imageSlim)

### 45.分析openwrt镜像，该系统中装的docker的版本号为、

```
20.10.22
```

![image-20240510144454345](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20240510144454345.png?imageSlim)

### 46.分析openwrt镜像，nastools的配置文件路径为

```
/root/Configs/NasTools
```

![image-20240510144610283](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20240510144610283.png?imageSlim)

### 47.分析openwrt镜像，使用的vpn代理软件为

```
PassWall2
```

![image-20240510144717786](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20240510144717786.png?imageSlim)

### 48.分析openwrt镜像，vpn实际有多少个可用节点

```
54
```

![image-20240510144751551](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20240510144751551.png?imageSlim)

### 49.分析openwrt镜像，节点socks的监听端口是多少

```
1070
```

![image-20240510144815501](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20240510144815501.png?imageSlim)

### 50.分析openwrt镜像，vpn的订阅链接是

```
https://pqjc.site/api/v1/client/subscribe?token=243d7bf31ca985f8d496ce078333196a
```

![image-20240510144854299](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20240510144854299.png?imageSlim)

## windows镜像

### 1.分析技术员赵某的windows镜像，并计算赵某计算机的原始镜像的SHA1值为？

```
FFD2777C0B966D5FC07F2BAED1DA5782F8DE5AD6
```

![image-20240429000840777](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20240429000840777.png?imageSlim)

### 2.分析技术员赵某的windows镜像，疑似VeraCrypt加密容器的文件的SHA1值为？

```
b25e2804b586394778c800d410ed7bcdc05a19c8
```

![image-20240429000941939](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20240429000941939.png?imageSlim)

### 3.据赵某供述，他会将常用的密码放置在一个文档内，分析技术员赵某的windows镜像，找到技术员赵某的密码字典，并计算该文件的SHA1值?

```
E6EB3D28C53E903A71880961ABB553EF09089007
```

![image-20240429001011517](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20240429001011517.png?imageSlim)

### 4.据赵某供述，他将加密容器的密码隐写在一张图片内，隐写在图片中的容器密码是?

```
qwerasdfzxcv
```

![image-20240429001033679](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20240429001033679.png?imageSlim)

![image-20240429001109319](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20240429001109319.png?imageSlim)

### 5.分析技术员赵某的windows镜像，bitlocker的恢复密钥是什么

```
404052-011088-453090-291500-377751-349536-330429-257235
```

用veracrypt将2024.fic解开，密码如上题

![image-20240429001220516](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20240429001220516.png?imageSlim)

### 6.分析技术员赵某的windows镜像，bitlocker分区的起始扇区数是

```
146794496
```

![image-20240429001313373](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20240429001313373.png?imageSlim)

### 7.分析技术员赵某的windows镜像，默认的浏览器是

```
Chrome
```

![7](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/7.png?imageSlim)

### 8.分析技术员赵某的windows镜像，私有聊天服务器的密码为

```
Zhao
```

![image-20240429001417440](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20240429001417440.png?imageSlim)

9.分析技术员赵某的windows镜像，嫌疑人计算机中有疑似使用AI技术生成的进行赌博宣传的图片，该图片中，宣传的赌博网站地址为？

```
https://www.585975.com/
```

![9](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/9.png?imageSlim)

### 10.分析技术员赵某的windows镜像，赵某使用的AI换脸工具名称为？

```
ROOP
```

![image-20240429001654155](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20240429001654155.png?imageSlim)

### 11.分析技术员赵某的windows镜像，使用AI换脸功能生成了一张图片，该图片的名称为

```
db.jpg
```

![image-20240429001747797](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20240429001747797.png?imageSlim)

### 12.分析技术员赵某的windows镜像，ai换脸生成图片的参数中--similar-face-distance值为

```
0.85
```

![image-20240429001801913](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20240429001801913.png?imageSlim)

### 13.分析技术员赵某的windows镜像，嫌疑人使用AI换脸功能所使用的原始图片名称为

```
dst01.jpeg
```

![image-20240429001814476](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20240429001814476.png?imageSlim)

### 14.分析技术员赵某的windows镜像，赵某与李某沟通中提到的“二维码”解密所用的网站url地址为？

```
http://hi.pcmoe.net/buddha.html
```

![image-20240429001937486](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20240429001937486.png?imageSlim)

### 15.分析技术员赵某的windows镜像，赵某架设聊天服务器的原始IP地址为？

```
192.168.8.17
```

![image-20240429002004082](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20240429002004082.png?imageSlim)

### 16.分析技术员赵某的windows镜像，据赵某交代，其在窝点中直接操作服务器进行部署，环境搭建好了之后，使用个人计算机登录聊天室进行沟通，请分析赵某第一次访问聊天室的时间为？

```
2024-03-14 20:32:08
```

![image-20240429002045864](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20240429002045864.png?imageSlim)

### 17.分析技术员赵某的windows镜像，openwrt的后台管理密码是

```
hl@7001
```

![image-20240429002116105](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20240429002116105.png?imageSlim)

### 18.分析技术员赵某的windows镜像，嫌疑人可能使用什么云来进行文件存储？

```
易有云
```

![18](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/18.png?imageSlim)

### 19.分析技术员赵某的windows镜像，工资表密码是多少

```
aa123456
```

![image-20240429002210558](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20240429002210558.png?imageSlim)

![image-20240429002246254](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20240429002246254.png?imageSlim)

![image-20240429002258794](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20240429002258794.png?imageSlim)

![image-20240429002308104](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20240429002308104.png?imageSlim)

### 20.分析技术员赵某的windows镜像，张伟的工资是多少

```
28300
```

![image-20240429002336254](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20240429002336254.png?imageSlim)

