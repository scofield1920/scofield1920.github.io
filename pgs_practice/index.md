# 盘古石取证练习wp


2022盘古石电子取证大赛的样题wp

<!--more-->

每道题5分，共计200分

### ***一、请检查窝点中的手机检材，回答以下问题***

1、 该OPPO手机的IMEI是： 

A. 860370043989014,860370049389006

**B. 860370049389014,860370049389006**

C. 860370049389014,860370043989006

D. 860370049839014,860370049839006

![img](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/wps1.jpg) 

2、 该涉案人所使用的的微信ID和关联的手机号是： 

A. wxid_rn6kc87f1mb354 16521330311

**B. wxid_rn5mjxpw1mb922 17721103461**

C. wxid_wi8nf67f1lmd54 15528880561

D. wxid_kshn457f1lm123 15847880501

![image-20230503150838623](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20230503150838623.png)

3、 涉案团伙的最后线 下犯罪窝点地址是：

A. 闵行区古美西路86弄44号

B. 田林路1036号科技绿洲三期16号楼101室

C. 上海市合川路科技绿洲3期5-3号楼

**D. 闵行区合川路2555号**

![image-20230503151617611](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20230503151617611.png)

4、 犯罪团伙所用的诈骗应用apk的sha256值是

A. 71064939606EE601F2F5A888C75F3949CB82A8DF472D15D77EE2A3DF663FC8E9

B. DC0909D078AC1B692836BB0526E52633DDE49D1286631FA0EF9C744925DF545E

**C. F67F61057828F57EA663CEBEDD638EE9A4BAF36F69DA7E002CBA54C9F8EAAF85**

D. 96B1258E64DA18C323DE8ECE0F89D88B0F0B99F459F209B514F7F500D72B7D1B

要从文件系统里面找，然后导出，通过hash计算软件可算出sha256的值

![image-20230503153440187](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20230503153440187.png)

5、 该涉案人手机在3月7日除了上海还可能去过哪个城市？ 

**A. 长春**

B. 成都

C. 武汉

D. 北京 

![image-20230503153830609](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20230503153830609.png)

6、 该涉案人可能用的输入法是和版本号： 

A. 10.9.4

**B. 8.32.22.2010171749**

C. 10.94

D. 8.32.22.201071749

![image-20230503153929550](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20230503153929550.png)

7、 该输入法没有哪项权限：

A. 照相

B. 连接网络

C. 修改型号

D. 读取文件

其他三种权限都有
没有修改型号的权限

![image-20230503154235201](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20230503154235201.png)

```
1.android.permission.WRITE_USER_DICTIONARY允许应用程序向用户词典中写入新词
2.android.permission.WRITE_SYNC_SETTINGS写入Google在线同步设置
3.android.permission.WRITE_SOCIAL_STREAM读取用户的社交信息流
4.android.permission.WRITE_SMS允许程序写短信
5.android.permission.WRITE_SETTINGS允许程序读取或写入系统设置
6.android.permission.WRITE_SECURE_SETTINGS允许应用程序读取或写入安全系统设置
7.android.permission.WRITE_PROFILE允许程序写入个人资料数据
8.com.android.browser.permission.WRITE_HISTORY_BOOKMARKS允许一个应用程序写(但不可读)用户的浏览历史和书签
9.android.permission.WRITE_GSERVICES允许程序修改Google服务地图
10.android.permission.WRITE_EXTERNAL_STORAGE允许程序写入外部存储,如SD卡上写文件
11.android.permission.WRITE_CONTACTS写入联系人,但不可读取
12.android.permission.WRITE_CALL_LOG允许程序写入（但是不能读）用户的联系人数据
13.android.permission.WRITE_CALENDAR允许程序写入日程，但不可读取
14.android.permission.WRITE_APN_SETTINGS允许程序写入网络GPRS接入点设置
15.android.permission.WAKE_LOCK允许程序在手机屏幕关闭后后台进程仍然运行
16.android.permission.VIBRATE允许程序振动
17.android.permission.USE_SIP允许程序使用SIP视频服务
18.android.permission.USE_CREDENTIALS允许程序请求验证从AccountManager
19.android.permission.UPDATE_DEVICE_STATS允许程序更新设备状态
20.com.android.launcher.permission.UNINSTALL_SHORTCUT删除快捷方式
21.android.permission.TRANSMIT_IR允许使用设备的红外发射器，如果可用
22.android.permission.SYSTEM_ALERT_WINDOW允许程序显示系统窗口
23.android.permission.SUBSCRIBED_FEEDS_WRITE允许程序写入或修改订阅内容的数据库
24.android.permission.SUBSCRIBED_FEEDS_READ允许程序访问订阅信息的数据库
22.android.permission.STATUS_BAR允许程序打开、关闭、禁用状态栏
23.android.permission.SIGNAL_PERSISTENT_PROCESSES允许程序发送一个永久的进程信号
24.android.permission.SET_WALLPAPER_HINTS允许程序设置壁纸建议
25.android.permission.SET_WALLPAPER允许程序设置桌面壁纸
26.android.permission.SET_TIME_ZONE允许程序设置系统时区
27.android.permission.SET_TIME允许程序设置系统时间
28.android.permission.SET_PROCESS_LIMIT允许程序设置最大的进程数量的限制
29.android.permission.SET_PREFERRED_APPLICATIONS允许程序设置应用的参数，已不再工作具体查看addPackageToPreferred(String) 介绍
30.android.permission.SET_POINTER_SPEED无法被第三方应用获得，系统权限
31.android.permission.SET_ORIENTATION允许程序设置屏幕方向为横屏或标准方式显示，不用于普通应用
32.android.permission.SET_DEBUG_APP允许程序设置调试程序，一般用于开发
33.android.permission.SET_ANIMATION_SCALE允许程序设置全局动画缩放
34.android.permission.SET_ALWAYS_FINISH允许程序设置程序在后台是否总是退出
36.com.android.alarm.permission.SET_ALARM允许程序设置闹铃提醒
37.android.permission.SET_ACTIVITY_WATCHER允许程序设置Activity观察器一般用于monkey测试
38.android.permission.SEND_SMS允许程序发送短信
39.android.permission.SEND_RESPOND_VIA_MESSAGE允许用户在来电的时候用你的应用进行即时的短信息回复。
40.android.permission.RESTART_PACKAGES允许程序结束任务通过restartPackage(String)方法，该方式将在外来放弃
41.android.permission.REORDER_TASKS允许程序重新排序系统Z轴运行中的任务
42.android.permission.RECORD_AUDIO允许程序录制声音通过手机或耳机的麦克
43.android.permission.RECEIVE_WAP_PUSH允许程序接收WAP PUSH信息
44.android.permission.RECEIVE_SMS允许程序接收短信
45.android.permission.RECEIVE_MMS允许程序接收彩信
46.android.permission.RECEIVE_BOOT_COMPLETED允许程序开机自动运行
47.android.permission.REBOOT允许程序重新启动设备
48.android.permission.READ_USER_DICTIONARY从一个提供器中获取数据，针对对应的提供器，应用程序需要“读访问权限”
49.android.permission.READ_SYNC_STATS允许程序读取同步状态，获得Google在线同步状态
50.android.permission.READ_SYNC_SETTINGS允许程序读取同步设置，读取Google在线同步设置
51.android.permission.READ_SOCIAL_STREAM读取用户的社交信息流
52.android.permission.READ_SMS允许程序读取短信内容
53.android.permission.READ_PROFILE访问用户个人资料
54.android.permission.READ_PHONE_STATE允许程序访问电话状态
55.android.permission.READ_LOGS允许程序读取系统底层日志
56.android.permission.READ_INPUT_STATE允许程序读取当前键的输入状态，仅用于系统
57.com.android.browser.permission.READ_HISTORY_BOOKMARKS允许程序读取浏览器收藏夹和历史记录
58.android.permission.READ_FRAME_BUFFER允许程序读取帧缓存用于屏幕截图
59.android.permission.READ_EXTERNAL_STORAGE程序可以读取设备外部存储空间（内置SDcard和外置SDCard）的文件，如果您的App已经添加了“WRITE_EXTERNAL_STORAGE ”权限 ，则就没必要添加读的权限了，写权限已经包含了读权限了。
60.android.permission.READ_CONTACTS允许程序访问联系人通讯录信息
61.android.permission.READ_CALL_LOG读取通话记录
62.android.permission.READ_CALENDAR允许程序读取用户的日程信息
63.android.permission.PROCESS_OUTGOING_CALLS允许程序监视，修改或放弃播出电话
64.android.permission.PERSISTENT_ACTIVITY允许程序创建一个永久的Activity，该功能标记为将来将被移除
65.android.permission.NFC允许程序执行NFC近距离通讯操作，用于移动支持
66.android.permission.MOUNT_UNMOUNT_FILESYSTEMS允许程序挂载、反挂载外部文件系统
67.android.permission.MOUNT_FORMAT_FILESYSTEMS允许程序格式化可移动文件系统，比如格式化清空SD卡
68.android.permission.MODIFY_PHONE_STATE允许程序修改电话状态，如飞行模式，但不包含替换系统拨号器界面
69.android.permission.MODIFY_AUDIO_SETTINGS允许程序修改声音设置信息
70.android.permission.MEDIA_CONTENT_CONTROL允许一个应用程序知道什么是播放和控制其内容。不被第三方应用使用。
71.android.permission.MASTER_CLEAR允许程序执行软格式化，删除系统配置信息
72.android.permission.MANAGE_DOCUMENTS允许一个应用程序来管理文档的访问，通常是一个文档选择器部分
73.android.permission.MANAGE_APP_TOKENS管理创建、摧毁、Z轴顺序，仅用于系统
74.android.permission.MANAGE_ACCOUNTS允许程序管理AccountManager中的账户列表
75.android.permission.LOCATION_HARDWARE允许一个应用程序中使用定位功能的硬件，不使用第三方应用
76.android.permission.KILL_BACKGROUND_PROCESSES允许程序调用killBackgroundProcesses(String).方法结束后台进程
77.android.permission.INTERNET允许程序访问网络连接，可能产生GPRS流量
78.android.permission.INTERNAL_SYSTEM_WINDOW允许程序打开内部窗口，不对第三方应用程序开放此权限
79.com.android.launcher.permission.INSTALL_SHORTCUT创建快捷方式
80.android.permission.INSTALL_PACKAGES允许程序安装应用
81.android.permission.INSTALL_LOCATION_PROVIDER允许程序安装定位提供
82.android.permission.INJECT_EVENTS允许程序访问本程序的底层事件，获取按键、轨迹球的事件流
83.android.permission.HARDWARE_TEST允许程序访问硬件辅助设备，用于硬件测试
84.android.permission.GLOBAL_SEARCH允许程序允许全局搜索
85.android.permission.GET_TOP_ACTIVITY_INFO允许一个应用程序检索私有信息是当前最顶级的活动，不被第三方应用使用
86.android.permission.GET_TASKS允许程序获取任务信息
87.android.permission.GET_PACKAGE_SIZE允许程序获取应用的文件大小
88.android.permission.GET_ACCOUNTS允许程序访问账户Gmail列表
89.android.permission.FORCE_BACK允许程序强制使用back后退按键，无论Activity是否在顶层
90.android.permission.FLASHLIGHT允许访问闪光灯
91.android.permission.FACTORY_TEST允许程序运行工厂测试模式
92.android.permission.EXPAND_STATUS_BAR允许程序扩展或收缩状态栏
93.android.permission.DUMP允许程序获取系统dump信息从系统服务
94.android.permission.DISABLE_KEYGUARD允许程序禁用键盘锁
95.android.permission.DIAGNOSTIC允许程序到RW到诊断资源
96.android.permission.DEVICE_POWER允许程序访问底层电源管理
97.android.permission.DELETE_PACKAGES允许程序删除应用
98.android.permission.DELETE_CACHE_FILES允许程序删除缓存文件
99.android.permission.CONTROL_LOCATION_UPDATES允许程序获得移动网络定位信息改变
100.android.permission.CLEAR_APP_USER_DATA允许程序清除用户数据
101.android.permission.CLEAR_APP_CACHE允许程序清除应用缓存
102.android.permission.CHANGE_WIFI_STATE允许程序改变WiFi状态
103.android.permission.CHANGE_WIFI_MULTICAST_STATE允许程序改变WiFi多播状态
104.android.permission.CHANGE_NETWORK_STATE允许程序改变网络状态,如是否联网
105.android.permission.CHANGE_CONFIGURATION允许当前应用改变配置，如定位
106.android.permission.CHANGE_COMPONENT_ENABLED_STATE改变组件是否启用状态
107.android.permission.CAPTURE_VIDEO_OUTPUT允许一个应用程序捕获视频输出，不被第三方应用使用
108.android.permission.CAPTURE_SECURE_VIDEO_OUTPUT允许一个应用程序捕获视频输出。不被第三方应用使用
109.android.permission.CAPTURE_AUDIO_OUTPUT允许一个应用程序捕获音频输出。不被第三方应用使用
110.android.permission.CAMERA允许程序访问摄像头进行拍照
111.android.permission.CALL_PRIVILEGED允许程序拨打电话，替换系统的拨号器界面
112.android.permission.CALL_PHONE允许程序从非系统拨号器里拨打电话
113.android.permission.BROADCAST_WAP_PUSHWAP PUSH服务收到后触发一个广播
114.android.permission.BROADCAST_STICKY允许程序收到广播后快速收到下一个广播
115.android.permission.BROADCAST_SMS允许程序当收到短信时触发一个广播
116.android.permission.BROADCAST_PACKAGE_REMOVED允许程序删除时广播
117.android.permission.BRICK能够禁用手机，非常危险，顾名思义就是让手机变成砖头
118.android.permission.BLUETOOTH_PRIVILEGED允许应用程序配对蓝牙设备，而无需用户交互。这不是第三方应用程序可用。
119.android.permission.BLUETOOTH_ADMIN允许程序进行发现和配对新的蓝牙设备
120.android.permission.BLUETOOTH允许程序连接配对过的蓝牙设备
121.android.permission.BIND_WALLPAPER必须通过WallpaperService服务来请求，只有系统才能用
122.android.permission.BIND_VPN_SERVICE绑定VPN服务必须通过VpnService服务来请求,只有系统才能用
123.android.permission.BIND_TEXT_SERVICE必须要求textservice(例如吗 spellcheckerservice)，以确保只有系统可以绑定到它。
124.android.permission.BIND_REMOTEVIEWS必须通过RemoteViewsService服务来请求，只有系统才能用
125.android.permission.BIND_PRINT_SERVICE必须要求由printservice，以确保只有系统可以绑定到它。
126.android.permission.BIND_NOTIFICATION_LISTENER_SERVICE必须要求由notificationlistenerservice，以确保只有系统可以绑定到它。
127.android.permission.BIND_NFC_SERVICE由hostapduservice或offhostapduservice必须确保只有系统可以绑定到它。
128.android.permission.BIND_INPUT_METHOD请求InputMethodService服务，只有系统才能使用
129.android.permission.BIND_DEVICE_ADMIN请求系统管理员接收者receiver，只有系统才能使用
130.android.permission.BIND_APPWIDGET允许程序告诉appWidget服务需要访问小插件的数据库，只有非常少的应用才用到此权限
131.android.permission.BIND_ACCESSIBILITY_SERVICE请求accessibilityservice服务，以确保只有系统可以绑定到它。
132.android.permission.AUTHENTICATE_ACCOUNTS允许程序通过账户验证方式访问账户管理ACCOUNT_MANAGER相关信息
133.com.android.voicemail.permission.ADD_VOICEMAIL允许一个应用程序添加语音邮件系统
134.android.permission.ACCOUNT_MANAGER允许程序获取账户验证信息，主要为GMail账户信息，只有系统级进程才能访问的权限
135.android.permission.ACCESS_WIFI_STATE允许程序获取当前WiFi接入的状态以及WLAN热点的信息
136.android.permission.ACCESS_SURFACE_FLINGERAndroid平台上底层的图形显示支持，一般用于游戏或照相机预览界面和底层模式的屏幕截图
137.android.permission.ACCESS_NETWORK_STATE允许程序获取网络信息状态，如当前的网络连接是否有效
138.android.permission.ACCESS_MOCK_LOCATION允许程序获取模拟定位信息，一般用于帮助开发者调试应用
139.android.permission.ACCESS_LOCATION_EXTRA_COMMANDS允许程序访问额外的定位提供者指令
140.android.permission.ACCESS_FINE_LOCATION允许程序通过GPS芯片接收卫星的定位信息
141.android.permission.ACCESS_COARSE_LOCATION允许程序通过WiFi或移动基站的方式获取用户错略的经纬度信息
142.android.permission.ACCESS_CHECKIN_PROPERTIES允许程序读取或写入登记check-in数据库属性表的权限
```

8、 该涉案人和被害人聊天使用skype软件的版本号是？

**A. 8.80.0.137**

B. 7.37.99.40

C. 6.65.12.11

D. 5.76.34.12

发现有俩

![image-20230503161328139](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20230503161328139.png)

![image-20230503161404264](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20230503161404264.png)

再根据聊天记录，可知为com.skype.raider

9、 哪个不是该涉案手机连接过其他手机的蓝牙物理地址:

A. E0:9D:FA:3A:BB:3C

**B. E0:64:FA:3A:8B:11**

C. 00:45:E2:02:50:BC

D. 00:1A:7D:DA:71:11

![image-20230503161803430](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20230503161803430.png)

10、 涉案APK的程序入口？

A. W2a.W2Ah5.jsgjzfx.org.cn

B. io.dcloud.PandoraEntryx

C. w2a.W2Ah5.jsgjzfx.org

**D. io.dcloud.PandoraEntry**

![image-20230503163841781](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20230503163841781.png)

APK的运行入口：ActivityThread类

11、 涉案APK连接的服务器地址是？

A.h5.gjzfx.org.cn		B.bspapp.com		C.yhjj.com		D.api.meiqia.com

答案是B，捣鼓了半天，我的办公本运行不了手机模拟器。。。。

12、 以下哪个是APK申请的权限？

**A. 测试对受保护存储空间的访问权限**

B. 申请系统管理权限

C. 修改手机状态和身份

D. 修改位置信息

根据前边的权限对照表进行对照

![image-20230503174538644](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20230503174538644.png)

13、 APK向服务器传送的数据中，包含一下哪个字段？

A. mc

B. address

C. number

D. dc

答案是A，这个也要通过模拟器进行抓包

### ***二、请检查窝点中的计算机检材，回答以下问题***

14、 涉案计算机的计算机全名是？ 

**A. DESKTOP-VC69QPB** 

B. DESKTOP-KDN38R5

C. DESKTOP-SLU384N

D. DESKTOP-I92E87D

![image-20230503174825712](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20230503174825712.png)

15、 涉案计算机有效账户最后一次登录时间是？ 

**A. 2022-03-15 09:43:04 +08**

B. 2022-03-15 09:43:04 +00

C. 2022-03-15 17:43:04 +08

D. 2022-03-15 17:48:04 +00

![image-20230503174932283](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20230503174932283.png)

16、 涉案计算机登录次数最多的账户是什么？登录了多少次？

A. admin 16

**B. admin 19**

C. administrator 16

D. administrator 19

![image-20230503175010121](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20230503175010121.png)

17、 涉案计算机是否连接过SanDisk优盘，该优盘的序列号是什么？

A. 4C530001180221100781

**B. 4C530001180221109491**

C. 5D7E0001180221100781

D. 5D7E 0001180221109491

![image-20230503175047879](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20230503175047879.png)

18、 涉案计算机以太网的Ip地址是？

A. 192.168.1.100

**B. 192.168.1.101**

C. 172.168.1.100

D. 172.168.1.101

![image-20230503175653041](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20230503175653041.png)

19、 涉案Windows计算机通过浏览器是否下载过哪个软件？ 

A. QQ

**B. Navicat**

C. Clash

D. wireshark

![image-20230503175748621](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20230503175748621.png)

20、 嫌疑人使用navicat远程连接数据的IP是？

A. 45.77.15.219

**B. 45.77.16.229**

C. 35.66.15.219

D. 35.66.16.229

![image-20230503175941339](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20230503175941339.png)

21、 涉案计算机是否存在加密分区，采用了什么加密方式？

**A. Bitlocker**

B. TrueCrypt

C. VeraCrypt

D. CnCrypt

22、 涉案计算机加密分区里面word文档文件最后访问时间是什么?

**A. 2022-03-14 19：14：45 +08**

B. 2022-03-14 19：14：45 +00

C. 2022-03-14 19：10：53 +08

D. 2022-03-14 19：10：53 +00

通过恢复秘钥进行解密

 ![image-20230503180038090](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20230503180038090.png)

![image-20230503180710231](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20230503180710231.png)

23、 涉案计算机加密分区中的txt文件SHA256值为？

计算hash值

A.da54693b5f04ea703e23065b53d01d89ca36e0444dee62ba01622e6d186e4712	

B.fa7a3b601325cfe85a9d6fff6514804d06754795175c87c3af162eac7dcf693a	

**C.972403b4b8fdfc211d5a14178be7e02e792cbe6a7bd6ff827ebb2c8909f4e2b8**	

D.b7254757595ce0228801bd53417895c2b6f28781d98bec8d854f4772c06aea29

![image-20230503180946208](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20230503180946208.png)

24、 涉案计算机使用的远程连接工具ToDesk的版本是？

**A. 4.2.6.03021556**

B. 12.5.1.44969

C. 14.28.2935.2

D. 11.0.61030

![image-20230503181024146](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20230503181024146.png)

25、 哪个设备的IP曾经通过向日葵连接到本地计算机？

A. 11.91.214.117

**B. 116.246.0.90**

C. 58.244.39.225

D. 10.91.215.14

![image-20230503181102118](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20230503181102118.png)

26、 嫌疑人使用的VPN使用了哪种加密算法

A. DES-128-CFB

**B. AES-256-cfb**

C. MD5

D. SHA

![image-20230503181345913](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20230503181345913.png)

27、 以下哪个地址不会被自动识别走代理通道？

A. carfax.com/index.html

B. api.expekt.com

C. huluim.com/login

**D. api.dns100.com**

使用盘古的计算机仿真软件打开镜像，去查看VPN软件Shadowsocket的文件，里面的pac.txt里有代理规则

28、 以下哪个IP会被代理软件识别为国内IP段进行直连。

A. 1.16.0.1

B. 1.205.0.1

C. 35.2.0.1

D. 56.11.0.1

***\*使用仿真系统进入，检索shadowsockets的\**chn_ip.txt**文件检索这4个选项

![image-20230503222857656](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20230503222857656.png)

![image-20230503222916338](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20230503222916338.png)

因为是ip段所以我在检索1.204时发现**B. 1.205.0.1**在ip段**1.204.0.0----1.207.255.255**里面

![image-20230503222950635](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20230503222950635.png)

29、 查看涉案计算机系统日志，判断该涉案计算机最后一次刷新时区信息是什么时间？ 

A. 2022-3-17	9:59:14

B. 2022-3-16 10:02:13

**C. 2022-3-15	12:54:44**

D. 2022-3-17	10:06:38

在仿真镜像后win+R输入eventvwr.msc,查看系统（但是里面有你仿真时的时间信息，需甄别）

### ***三、请检查窝点中的服务器检材，回答以下问题***

30、 Liunx服务器的系统内核版本 

A. 3.10.0-1127.el7.x86

**B. 3.10.0-1127.el7.x86_64**

C. 3.11.0-1127.el7.x86_64

D. 3.11.0-1127.el7.x86

![image-20230503221324632](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20230503221324632.png)

31、 该涉案服务器宝塔面板的访问限制域名是什么？

**A. h1.jsgjzfx.cn**

B. gjjszfx.cn

C. h5.jsgjzfx.cn

D. h5. gjjszfx.cn

![image-20230503221940752](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20230503221940752.png)

32、 涉诈网站目录中数据库连接配置文件的路径 

A./www/backup/file_history/www/wwwroot/h1.jsgjzfx.cn/Application/config.php	

B./www/backup/file_history/www/wwwroot/h1.jsgjzfx.cn/Application/Home/View/Qts/User/config.php		

**C./www/wwwroot/h1.jsgjzfx.cn/Application/Common/Conf/config.php**	

D./www/wwwroot/config.php

![image-20230503222003172](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20230503222003172.png)

接着查看/www/wwwroot/h1.jsgjzfx.cn/Application/Common/Conf/config.php

![image-20230503222049988](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20230503222049988.png)

33、 登录涉案网站后台，显示有多少用户 

A. 922

**B. 921**

C. 920

D. 919

![image-20230503222153062](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20230503222153062.png)

34、 受害人“好大哥”在涉案网站2022-03-04 14:39:26 充值金额状态

A.重置失败	  B.交易中	  **C.充值完成**	  D.已充值

登录网站后台检索充值记录，查询2022-03-04的充值记录可以发现目标

35、 涉案网站总成功提现金额

A. 33808154.28

B. **338081541.28**

C. 338081653.97

D. 33808165.97

登录网站后台检索提现申请。检索时间段（尽量往后时间），发现成功提现总金额为 **338081541.28**

36、 涉案网站的数据库中管理员登录次数最多的ip是哪个

A.112.114.103.205   B.13.124.79.70	

C.43.254.219.161	    **D.14.204.0.87** 

打开数据库里的wp_login_log发现登录ip最多的是14.204.0.87

![image-20230503222401974](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20230503222401974.png)

37、 涉案网站数据库中平仓时间在2020年1月1日-2020年12月31日的实盘交易订单数量

**A. 5159** 

B. 2567

C. 3536

D. 4684

进入网站数据库，使用sql语句进行检索

![image-20230503222456737](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20230503222456737.png)

38、 涉案网站数据库中购买"以太坊"交易产品的用户绑定银行名称为"中国工商银行"的用户有多少

**A. 4**

B. 3

C. 5

D. 7

sql语句：

```
SELECT COUNT(DISTINCT o.uid) from (SELECT * FROM wp_bankinfo WHERE bankname = '中国工商银行') as b,(SELECT uid FROM wp_order WHERE option_name = '以太坊') AS o WHERE b.uid = o.uid
```

![image-20230503222548889](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20230503222548889.png)

### ***四、请检查窝点中的路由器检材导出报告，回答以下问题***

39、 该窝点中使用路由器的WiFi密码是？

A. TPGuest_8D70

B. admin123

C. TPLink_TL

**D. 688561qi**

![image-20230503222633422](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20230503222633422.png)

40、 在该窝点中勘验时分配IP为192.168.1.102的设备mac地址是？

**A. 84-a9-38-28-f5-95**

B. 6c-4b-90-8c-87-8c

C. 80-b6-55-26-f4-4e

D. 00-25-90-83-af-f2

![image-20230503222653630](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20230503222653630.png)
