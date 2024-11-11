# 2024 第十届美亚杯资格赛内存取证和 U 盘取证


2024 第十届美亚杯资格赛内存取证和 U 盘取证

<!--more-->

容器密码

```
eS2%u@q#hake2#Z@6LWpQ8^T(R7cg95m\Bv+y;$=/dqxYnEusFf)tb>:HKHwy+e%cR\r=9j:GsK)AV52/3hXfdv8#u7a6JQ^pz><YPNkq*!&
```

59.[单选题] 你根据易失性(Volatility Level)优先次序, 进行内存取证分析 David 的笔记本电脑 ｡ 参考 RAM_Capture_David_Laptop.RAW, 以下哪一个不是程序 "firefox.exe" 的 PID? (2 分)

A. 9240

B. 8732

C. 5260

D. 3108

```
C
```

![image-20241111134917787](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20241111134917787.png?imageSlim)

60.[填空题] 参考RAM_Capture_David_Laptop.RAW，汇出PID：724的程序，其哈希值(SHA-256)是？(2分)

```
fee23ebcba02987e70d81ca1924c2e9c69d79ac2afea5bbde4fb335a57d4b30c
```

![image-20241111141115510](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20241111141115510.png?imageSlim)

找到其中PID为724的lsass.exe程序，计算SHA256哈希值

```
certutil -hashfile ffff818a2adf6520-lsass.exe SHA256
```

![image-20241111141442818](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20241111141442818.png?imageSlim)

61.[单选题] 参考RAM_Capture_David_Laptop.RAW，哪一个是执行PID：724程序的SID？(1分)

A. S-1-1-0

B. S-1-2-0

C. S-1-5-21-1103701427-1706751984-2965915307-1001

D. S-1-5-21-1103701427-1706751984-2965915307-513

```
A. S-1-1-0
```

可以使用vol3的windows.getsids模块

![image-20241111141920150](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20241111141920150.png?imageSlim)

62.[填空题] 参考RAM_Capture_David_Laptop.RAW，账户David Tenth的NT LAN Manager的哈希值(NTLM Hash)？(答案格式:只需使用全部小写及阿拉伯数字回答) (1分)

```
e14a21fefc5dd81275bb87228586cffc
```

使用vol3的windows.hashdump模块

![image-20241111142728891](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20241111142728891.png?imageSlim)

63.[单选题] 在取证中，你发现D盘被BitLocker加密。U盘上可能有一些线索，你对U盘进行了取证。参考David_USB_8GB.e01，David 的U盘文件系统的格式？(2分)

A. NTFS

B. FAT32

C. exFAT

D. ReFS

```
A. NTFS
```

![image-20241111143913564](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20241111143913564.png?imageSlim)

64.[单选题] 参考David_USB_8GB.e01，David的U盘文件系统中，每簇(Cluster)定义了多少字节(Byte)？(2分)

A. 128

B. 256

C. 512

D. 1024

```
C. 512
```

题解同上

65.[单选题] 参考David_USB_8GB.e01，David的U盘中有多少个已删除的文件？(2分)

A. 1

B. 2

C. 3

D. 4

```
A. 1
```

![image-20241111144031300](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20241111144031300.png?imageSlim)

66.[单选题] 承上题,参考David_USB_8GB.e01,已删除的文件的运行列表(Run List)的运行偏移量(Run Offset)数量是多少? (2分)

A. 16

B. 32

C. 64

D. 128

```
C. 64
```

找到80属性数据，80属性头部长度为0x40，后为DataRun数据

跳转到文件INODE

![image-20241111145759877](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20241111145759877.png?imageSlim)

![image-20241111145514457](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20241111145514457.png?imageSlim)

67.[单选题] 承上题,参考David_USB_8GB.e01,已删除文件的第一个运行的十六进制值(低端字节序 Little-Endian)是多少? (3分)

A. 0x4C3F0DB522

B. 0x4C3F0D22B5

C. 0x224C3F0DB5

D. 0x3F4C0DB522

```
C. 0x224C3F0DB5
```

![image-20241111145726403](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20241111145726403.png?imageSlim)

68.[填空题] 承上题,参考David_USB_8GB.e01,已删除的文件的实际大小(单位:字节 Byte)是多少? 答案格式:只需使用阿拉伯数字回答 (2分)

```
1796178
```

![image-20241111150014829](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20241111150014829.png?imageSlim)

69.[填空题] 承上题,参考David_USB_8GB.e01,已删除文件的第一个运行偏移量(Run Offset)是多少? (答案格式:只需使用阿拉伯数字回答) (2分)

```
19519
```

分别是长度和起始簇号的长度，运行偏移为0x4C3F

![image-20241111150154088](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20241111150154088.png?imageSlim)

转10进制：19519

70.[单选题] 承上题,参考David_USB_8GB.e01,已删除的文件的第一个运行的簇运行长度(Run Length)是多少? (2分) 

A. 2408

B. 3509

C. 3128

D. 4021

```
B. 3509
```

![image-20241111150425938](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20241111150425938.png?imageSlim)

第一个字节分别是长度和起始簇号的长度，长度为0x0DB5

转10进制为：3509

71.[单选题] 承上题,参考David_USB_8GB.e01,已删除文件的图像文件像素值(Pixel)是多少? (2分) 

A. 1000 x 2000

B. 2000 x 3000

C. 3000 x 4000

D. 4000 x 5000

```
C. 3000 x 4000
```

查看文件EXIF信息

![image-20241111150620595](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20241111150620595.png?imageSlim)

72.[单选题] 承上题,参考David_USB_8GB.e01,已删除图像文件是用哪个品牌和型号的手机拍摄? (2分) 

A. SAMSUNG SM-A425

B. SAMSUNG SM-A4580

C. SAMSUNG SM-A4260

D. SAMSUNG SM-A5G

```
C. SAMSUNG SM-A4260
```

题解同上

73.在U盘中,你还发现了一个exe文件,但它被锁定,可能需要进行反编译以便进一步检查。参考David_USB_8GB.e01,使用x64dbg的字符串搜索(String Search)功能,在Bitlocker.exe中查找哪个字符串最有可能与显示的登录状态有关? (1分)



![image-20241111150846340](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20241111150846340.png?imageSlim)

导出并用IDA64进行分析，查看字符串

74.承上題,当找到控制登录成功的逻辑代码时,如何修改汇编代码(Assembly Code)来绕过检查,达到任意输入，都成功登录的效果? (2分)

![image-20241111160427748](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20241111160427748.png?imageSlim)

通过分析逻辑可以看到，Bitlocker.exe通过TEST和JNE指令配合实现登入成功和失败的提示

75.参考David_USB_8GB.e01,Bitlocker.exe的正确用户登录名称是? (1分)

```
david1337
```

查找字串，并跳转到代码

![image-20241111160601299](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20241111160601299.png?imageSlim)

根据代码可以判断，字符串:” david1337”作为用户登入名称

76.参考David_USB_8GB.e01,Bitlocker.exe的正确登录密码是? (2分)

```
1337david
```

题解同上，字符串:” 1337david”作为登入密码进行登入

77.参考David_USB_8GB.e01,当Bitlocker.exe程序尝试显示登录结果（成功或失败）时,使用了哪一种途径来决定显示的消息? (2分)

![image-20241111160737572](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20241111160737572.png?imageSlim)

显示成功或者失败是通过test eax,eax决定跳转到执行显示信息的代码中

78.参考David_USB_8GB.e01,决定能否解密Bitlocker Key 的字节的内存偏移量(Memory Offset)（相对于基址"bitlocker.exe"）是什么? (3分)

![image-20241111160920851](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20241111160920851.png?imageSlim)

校验登入用户名密码之后会继续判断rva = 0x808C处的数据，当该处值为1时会显示The Bitlocker key 的窗口提示，并且显示相关数据

79.参考David_USB_8GB.e01,决定能否解密Bitlocker Key 的内存偏移量(Memory Offset)后,应该如何利用它来进行解密? (2分)
A. 将该偏移量处的值改为 1 (true),以启用解密过程
B. 将该偏移量处的值改为 0 (false),以重新初始化加密过程
C. 将该偏移量的内容保存到档中以作解密过程中的key
D. 清空该偏移量的内存并强制退出程序

```
A. 将该偏移量处的值改为 1 (true),以启用解密过程
```

题解同上

80.[单选题] 参考David_USB_8GB.e01，解密后的Bitlocker Key是？(3分)
A. 299255-418649-198198-616891-099682-482306-642609-483527
B. 745823-918273-564738-290183-475920-182736-594827-162839
C. 539823-847291-094857-194756-382910-472918-482937-120984
D. 829384-192837-475910-298374-019283-847362-564738-293847

```
A. 299255-418649-198198-616891-099682-482306-642609-483527
```

![image-20241111161106085](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20241111161106085.png?imageSlim)

恢复U盘中删除的图片得到恢复密钥

