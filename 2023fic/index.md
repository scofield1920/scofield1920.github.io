# 2023全国网络空间取证竞赛


除了两个程序分析

<!--more-->

## 涉案苹果手机日志备份检验

VC容器密码：

```
2023FIC@HeFei~wecomeback
```

### 1.请分析苹果手机导出日志，airdrop所使用的扫描模式（Scanning Mode）为？

```
Contacts Only
```

#### 2.AirDrop服务计划监听端口号是多少？

```
8770
```

#### 3.AirDrop中接收到图片的uuid格式的识别码是多少？（标准格式:12345678-1234-5678-1234-567812345678）

```
DC305C27-CB72-4786-8E0A-5346CD7B0D6A
```

#### 4.AirDrop日志中可以看到几条接收记录？

```
1
```

#### 5.AirDrop日志中可以分析出图片发送人是谁？（标准格式:中文名）

```
卢冠华
```

#### 6.AirDrop日志中可以分析出发送图片的设备名称是什么？（标准格式:Ipad 11）

```
MatePad Pro 12.9
```

#### 7.AirDrop日志中可以分析出发送人AppleID邮箱是什么？(标准格式:12345@qq.com)

```
4979ecbb-5312-4801-851d-a959ec847463@inbox.appleid.apple.com
```

#### 8.AirDrop日志中可以分析出发送的图片文件名是什么？(标准格式：1.txt)

```
IMG_3204.pvt
```

#### 9.AirDrop日志中可以分析投送嫌疑人的手机号的SHA256后五位是？

```
2d99d
```

#### 10.请结合工具分析日志，找出Airdrop投送方的手机号码？（答案格式：18877776666）

```
8618697928485
```

> 得知的嫌疑人手机号 sha256 值的前后五位 可以爆破出完整的手机号 在爆破的时候记得中国大陆手机号前面需要加上 86
>
> ```python
> import hashlib
> 
> # 常见手机号前三位
> dict = ["186","131","132","145","155","166","185","130","134","135","136","137","138","139","147","150","151","152","157","158","159","182","183","184","187","188","130","131","132","145","155","166","185","186","133","149","153","173","177","180","181","189","191","199"]
> 
> found = False
> for phone_prefix in dict:
>     for i in range(0, 100000000):
>         num_str = str(i).zfill(8)
>         phone_num = '86' + str(phone_prefix) + str(num_str)
>         hash_start = hashlib.sha256(str(phone_num).encode('UTF-8')).hexdigest() [:5]
>         hash_end = hashlib.sha256(str(phone_num).encode('UTF-8')).hexdigest() [-5:]
>         if hash_start == "eeb48" and hash_end == "2d99d":
>             print("找到手机号：", phone_num)
>             Found = True
>             break
> 
>     if found:
>         break
> ```
>
> 

## 涉案个人PC镜像检验

### 1.请计算计算机检材的原始磁盘的SHA256值(不区分大小写)

```
FDD3ED3893E31D6E9A363A83969AA701D06E0E3E3628B7DC97A8A23C13FF027D
```

### ![image-20240409092949322](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20240409092949322.png?imageSlim)2.检材2023FIC-PC.E01的计算机开机密码为

```
1qaz@WSX3edczhaohong
```

### ![image-20240409092418542](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20240409092418542.png?imageSlim)3.请根据笔录交代，分析计算机检材，找出airdrop投递的图片内容中，违法网站的域名为？（答案格式：www.baidu.com)

```
www.HLHL.com
```

![image-20240409094958595](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20240409094958595.png?imageSlim)

### 4.请计算嫌疑人计算机中名为“测试模拟器.ldbk”的文件的SHA256值

仿真，导出，算SHA256

```
053950850ec6200c1a06a84b6374bd62242064780f7f680ca23932ee53dc0110
```

![image-20240409095535009](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20240409095535009.png?imageSlim)

### 5."请根据笔录交代，分析计算机检材，钱包对应的密钥计算过程中，调用了以下哪种算法？（多选）

A、AES   B、DES  C、BASE58  D、BASE64  E、HKDF"

```
CE
```

E:\手机app测试\server\KeyPoolGenerator\src\main\java\org\example

![image-20240426143055914](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20240426143055914.png?imageSlim)

### 6."请分析2023FIC-PC.E01检材，并回答，发现嫌疑人计算机中使用了哪种远程工具？（单选）

A、ToDesk   B、Xshell  C、向日葵   D、网探  E、RayLink"

```
C
```

![image-20240409113246078](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20240409113246078.png?imageSlim)

### 7.请综合分析检材,嫌疑人于2023年8月22日进行远程控制时，控制对端的公网IP为

```
116.192.174.254
```

![image-20240409113442641](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20240409113442641.png?imageSlim)

### 8.请综合分析检材,嫌疑人于2023年8月22日进行远程控制时，控制对端的内网IP为

```
172.19.0.128
```

![image-20240426135520941](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20240426135520941.png?imageSlim)

### 9.请综合分析检材,嫌疑人于2023年8月22日进行远程控制时，控制对端通过连接远程工具的中转服务器实现的P2P连接，该中转服务器的IP为

```
58.215.100.83
```

![image-20240426140427215](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20240426140427215.png?imageSlim)

### 10.请综合分析检材,嫌疑人于2023年8月22日进行远程控制时，于什么时间释放远控行为？（答案各位为：23:59:59）

```
18:39:17
```

![image-20240409113628160](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20240409113628160.png?imageSlim)

### 11.请计算APK勒索样本程序的SHA256值？(不区分大小写)

```
99c8af2df71e80a30f9fe33e73706fb11fde024517d228d606326bba14466988
```

![image-20240426143651644](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20240426143651644.png?imageSlim)

导出来算sha256

12.APK程序在勒索的时候会向服务器申请钱包地址，请问申请后台IP地址为？



13.APK从服务器端申请的包含钱包地址的配置文件的文件名为？  



14.APK程序在嫌疑人测试环境中，申请到的钱包地址为？



15.嫌疑人模拟器中，有测试文件被加密，该文件被加密后文件名为？ 



16."APK程序勒索过程中，对于勒索文件使用的加密算法为？ 

A、AES   B、DES  C、BASE58  D、BASE64  E、HKDF"



17.请综合分析检材,嫌疑人模拟器环境中，申请的钱包地址对应的加密密钥为？



18.嫌疑人模拟器中，有测试文件被加密，被加密文件的文件内容为？



19.请综合分析检材,嫌疑人的密钥库文件的sha256值为？(不区分大小写)



20.如果嫌疑人使用的勒索钱包为74Vmx83bYvuhffEHnxVNnbbq9d1AAfJhXZ，那么该钱包对应的AES加密KEY为？

## 涉案服务器镜像检验

### 1.请分析服务器中嫌疑人用于赚钱的sql程序，数据库中的用户记录总共有多少条？

```
68307
```

![image-20240426203530965](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20240426203530965.png?imageSlim)

### 2.请分析服务器中嫌疑人用于赚钱的sql程序，用户最早的注册日期是什么？(标准格式：2020-01-01 12:00:00)

A、2019-12-30 19:21:19
B、2019-12-30 19:22:19
C、2019-12-30 19:23:19
D、2019-12-30 19:24:19
E、2019-12-30 19:25:19"

```
B
```

![image-20240426205526270](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20240426205526270.png?imageSlim)

![image-20240426205438800](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20240426205438800.png?imageSlim)

![image-20240426205417664](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20240426205417664.png?imageSlim)

### 3.请分析服务器中嫌疑人用于赚钱的sql程序，用户数据中的最深层级的用户名为？[组织架构中最大层数]（标准格式：中文名）

```
胡艳红
```

把离线数据库文件放到网钜里，导出excl表格，导出列name,username,pid(上级)

![image-20240426230825132](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20240426230825132.png?imageSlim)

然后将该exel文件放到网钜里构建组织架构

![image-20240426231015579](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20240426231015579.png?imageSlim)

pid设置为邀请人id

![image-20240426231221510](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20240426231221510.png?imageSlim)

分析完后得到最深层级会员

![image-20240426230522733](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20240426230522733.png?imageSlim)

### 4.请分析服务器中嫌疑人用于赚钱的sql程序，直接奖励的总金额是多少？（标准格式：100.00）

```
1142590
```

![image-20240426212445909](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20240426212445909.png?imageSlim)

### 5.请分析服务器中嫌疑人用于赚钱的sql程序，间接奖励的总金额是多少？（标准格式：100.00）

```
2293600
```

![image-20240426212544487](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20240426212544487.png?imageSlim)

### 6.请分析服务器中嫌疑人用于赚钱的sql程序，贡献奖的总金额是多少？（标准格式：100.00）

```
2431042
```

![image-20240426212813000](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20240426212813000.png?imageSlim)

### 7.请分析服务器中嫌疑人用于赚钱的sql程序，全球分红奖励的总金额是多少？（标准格式：100.00）

```
2036114.90
```

![image-20240426213359911](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20240426213359911.png?imageSlim)

### 8.请分析服务器中嫌疑人用于赚钱的sql程序，个人投资的总金额是多少？（标准格式：100.00）

```
25043200
```

![image-20240426213856155](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20240426213856155.png?imageSlim)

### 9.请分析服务器中嫌疑人用于赚钱的sql程序，没有上线也没有下线的用户数量是多少？

```
272
```

![image-20240426231630818](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20240426231630818.png?imageSlim)

### 10.请分析服务器中嫌疑人用于赚钱的sql程序，没有上线但有下线的用户数量有多少？

```
8
```

![image-20240426231725910](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20240426231725910.png?imageSlim)

### 11.请分析服务器中嫌疑人用于赚钱的exe程序，并计算其md5值？(不区分大小写)

```
E8B1C00DCA13B5CA83BD7C5623A80F07
```

![image-20240409154345995](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20240409154345995.png?imageSlim)

### 12.请分析服务器中嫌疑人用于赚钱的exe程序，编译此程序的计算机用户名是什么？

```
MBRE
```

![image-20240409155111528](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20240409155111528.png?imageSlim)

### 13.请分p析服务器中嫌疑人用于赚钱的exe程序，本程序一共创建了几个窗口？

```
3
```

14.请分析服务器中嫌疑人用于赚钱的exe程序，窗口1中所显示的内容是什么？



### 15.请分析服务器中嫌疑人用于赚钱的exe程序，窗口1中所显示的内容使用了什么字体？

```
Microsoft YaHei Light
```

![image-20240409160042862](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20240409160042862.png?imageSlim)

16.请分析服务器中嫌疑人用于赚钱的exe程序，窗口1中显示的字符串第一笔的长度为多少像素（答案格式只需填写数字)



17.请分析服务器中嫌疑人用于赚钱的exe程序，窗口2中解密字符串所使用的密钥为？



18."请分析服务器中嫌疑人用于赚钱的exe程序，窗口2中使用了解密算法为？ 
 A. RC4  B.AES C.DES D.SHA256 E.ECC"



### 19.请分析服务器中嫌疑人用于赚钱的exe程序，在俄罗斯方块游戏中，在键盘上依次按下哪些键可以进入窗口2？

```
SSADWWSWAADDSS
```

![image-20240409164530158](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20240409164530158.png?imageSlim)

### 20.请分析服务器中嫌疑人用于赚钱的exe程序，窗口2植入的广告中，赌博网站的域名为？

```
www.abcd.com
```

![image-20240409161610491](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20240409161610491.png?imageSlim)
