# 2022 SkyNICO三校联赛


2022.11 SkyNICO CTF三校联赛wp

<!--more-->

![image-20221107122611272](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20221107122611272.png)

## 【Misc福利题】sign sign sign

签到题不必多说了，扫描二维码复制字符串，放进[随波逐流]一键base
**但一定要注意，要把字符串复制全，别漏了末尾的等号(可能三个)**

## [Misc]幸亏开着wireshark

**tips:Wanna有个HID键盘和Cisco交换机**
下载附件之后，解压发现有个txt后缀的文件和png文件，都显然不是既定后缀文件，放进010edits，查看文件头和ASCII转码显示的字符，发现那个那个所谓的txt文件是一个7z压缩包，而那个png文件

<img src="https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20221107123628459.png" alt="image-20221107123628459" style="zoom:67%;" />

其实题目名称已经有暗示了，直接拖进wireshark

![image-20221107123853288](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20221107123853288.png)

同时我也对该题进行了百度，数据协议:USB，是抓取的键盘流量，下载相关脚本，但怎么也跑不出来，经过了许久地反复横跳，我发现了问题所在，本次题目文件中有些许冗杂的数据，阻碍了脚本的运行

![image-20221107124126442](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20221107124126442.png)

删掉他们重新导出pcapng数据，只保留一下信息

![image-20221107124201458](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20221107124201458.png)

重新跑脚本，得到了压缩包密码：where is you
解压后得到了一个文本文件，系Cisco交换机配置文件

![image-20221107124421452](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20221107124421452.png)

好骚的题，复制那堆emoji表情进行解码，得到hint，解码password7可得flag
随后去搜索，Cisco交换机加密方式，

![image-20221107124807083](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20221107124807083.png)

看到了7！一眼丁真，在线网站直接解密

## 【Misc福利题】啊吧啊吧

也算是签到题吧，发送到foremost进行分解，然后OCR提取flag，同时遇到了一个问题，flag死活不对，原因系相似字符混淆注意。一定要注意形似字符区分(好丢nian)

   `lI|`    lI|

不同字体会有不一样的显示

## [Misc]Pixels In Picture

放大仔细看，有隐写的像素点，就叫他像素点隐写吧，也没啥太好的办法，拉进ps或者lr，

<img src="https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20221107125722888.png" alt="image-20221107125722888" style="zoom: 50%;" />

我的办法是，能直接读的就读，看不清就拉参数，结合lr和Stegsolve多生成几张对比着看

![image-20221107125917376](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20221107125917376.png)

愣看，不知道师傅们有什么更好的方法。

## [Misc]希尔伯特的微笑

当你跳跃维度，希尔伯特在向你微笑，从alpha的角度看去，在希尔伯特曲线中领悟真谛，上下颠倒，在Quine中，发现隐藏在空白之下的秘密

真不好意思，这个题被我做成社工题了，

摘自：https://www.anquanke.com/post/id/244533

![img](https://nimg.ws.126.net/?url=http%3A%2F%2Fdingyue.ws.126.net%2F2021%2F0618%2Fbb6cdb17j00quvwyl005dc000u000iom.jpg&thumbnail=660x2147483647&quality=80&type=jpg)

题目描述：“三体人要入侵地球了，听说他们要使出最厉害的武器”

打开图片，发现有三个重复的图形，下面有”DIFOIL”字样，再下面好像还有一串字，但看不清楚。

![img](https://nimg.ws.126.net/?url=http%3A%2F%2Fdingyue.ws.126.net%2F2021%2F0618%2Faa5db943p00quvwym0028c000jk00jgm.png&thumbnail=660x2147483647&quality=80&type=jpg)

图片看起来很奇怪，三个图形也呼应了“ThreeBody”的题目名称。

对于图片题目常规操作，使用StegSolve查看各图层，能发现两张隐藏的图片，其他图层再没有什么可疑的东西了：

![img](https://nimg.ws.126.net/?url=http%3A%2F%2Fdingyue.ws.126.net%2F2021%2F0618%2Fb7bf6964p00quvwyl000fc000gb00fhm.png&thumbnail=660x2147483647&quality=80&type=jpg)

![img](https://nimg.ws.126.net/?url=http%3A%2F%2Fdingyue.ws.126.net%2F2021%2F0618%2F425c45b0p00quvwyl000lc000g900ffm.png&thumbnail=660x2147483647&quality=80&type=jpg)

图片上能认出半个星球、一个宇航员、一只手，以及《三体》中经典的一句话“你们都是虫子”。

对三体比较熟悉的同学可能可以猜出这张图以及原始图片是三体人使用二向箔对地球进行降维打击的场景。

这里也是小小地调侃了一下选手。如果不能找到通往下一步的方法，便只能停留在这里，被三体人嘲讽为“虫子”。

![img](https://nimg.ws.126.net/?url=http%3A%2F%2Fdingyue.ws.126.net%2F2021%2F0618%2F0bb43c6aj00quvwyl001lc000u000f0m.jpg&thumbnail=660x2147483647&quality=80&type=jpg)

让我们再回到原始图片，放大看其中的细节：

![img](https://nimg.ws.126.net/?url=http%3A%2F%2Fdingyue.ws.126.net%2F2021%2F0618%2Fee013925p00quvwyl001bc000jl00jhm.png&thumbnail=660x2147483647&quality=80&type=jpg)

可见图片中红黄蓝绿交错，有老式电视像素点的感觉。

通过010Editor查看像素点数值：

![img](https://nimg.ws.126.net/?url=http%3A%2F%2Fdingyue.ws.126.net%2F2021%2F0618%2F4815bed7p00quvwyl0017c000ka00jnm.png&thumbnail=660x2147483647&quality=80&type=jpg)

可见相邻像素点的RGB值都差异巨大，正常情况下相邻像素点的RGB值应该差不多才对。

再仔细观察可以发现，如果以4为周期的话相邻像素的数值就差不多了，考虑正常情况下该图片的像素点应该是每4个一组。相当于原始图片是四维的，这里被“降维打击”成了三维。我们这里需要做的，便是对图片进行升维处理。

BMP格式的头部有个字节是控制每个像素点所占的比特数，现在为24，也就是3个字节，我们将这个字段改为4个字节对应的32：

biBitCount

![img](https://nimg.ws.126.net/?url=http%3A%2F%2Fdingyue.ws.126.net%2F2021%2F0618%2F02000830p00quvwyl0014c000jy00iqm.png&thumbnail=660x2147483647&quality=80&type=jpg)

保存后重新打开图片，便可以看到正常的图形了：

![img](https://nimg.ws.126.net/?url=http%3A%2F%2Fdingyue.ws.126.net%2F2021%2F0618%2Fd6bea0bdp00quvwym0037c000jk00jfm.png&thumbnail=660x2147483647&quality=80&type=jpg)

再次通过StegSolve进行查看，可以发现隐藏图片：

![img](https://nimg.ws.126.net/?url=http%3A%2F%2Fdingyue.ws.126.net%2F2021%2F0618%2F224dd4a2p00quvwyl000bc000ga00fgm.png&thumbnail=660x2147483647&quality=80&type=jpg)

很多人看到“Welcome to QWB”可能就放松了警惕，以为这是一张随便放的没啥用的图片，便去找其他线索了。在CTF题目中忽视作者所给的线索是大忌，其实这里是非常关键的，所以在比赛过程中我有提示“所有图片的内容都是有意义的”。

其实细心的话可以看到左上角有一些小白点，代表着那里隐藏着一些信息。使用StegSolve的Data Extract功能查看该空间：

![img](https://nimg.ws.126.net/?url=http%3A%2F%2Fdingyue.ws.126.net%2F2021%2F0618%2Fc3fc19a3p00quvwym000bc000k300glm.png&thumbnail=660x2147483647&quality=80&type=jpg)

可以看到有“Who am I?”的字样。

再以列为方式查看：

![img](https://nimg.ws.126.net/?url=http%3A%2F%2Fdingyue.ws.126.net%2F2021%2F0618%2Fc5b9b2a5p00quvwym0009c000k300gkm.png&thumbnail=660x2147483647&quality=80&type=jpg)

可以看到有“David”字样。

根据这张照片和“David”的提示，通过一番搜索可得知这一位是知名的数学家大卫·希尔伯特：

![img](https://nimg.ws.126.net/?url=http%3A%2F%2Fdingyue.ws.126.net%2F2021%2F0618%2Fd0d8dbd4j00quvwym0021c000k000gom.jpg&thumbnail=660x2147483647&quality=80&type=jpg)

不过除此之外我们得不到更多的信息了。Flag在哪呢？

让我们再用010Editor查看修改后的图片：

![img](https://nimg.ws.126.net/?url=http%3A%2F%2Fdingyue.ws.126.net%2F2021%2F0618%2F56fde64fp00quvwym001ic000l500oqm.png&thumbnail=660x2147483647&quality=80&type=jpg)

可以看到每个像素除了有RGB三个字段外还有一个字段，代表图片还有另一个通道。

rgbReserved

这个字段有些跟是一样的，但也有一些有细微差异。

rgbBlue

信息会不会就隐藏在字段呢？

rgbReserved

字段是有数值的，所以该通道肯定有对应的图形，不过刚才通过StegSolve并没有看到该通道。

rgbReserved

这里一个方法是修改BMP的文件头，使得StegSolve把该通道识别为Alpha通道。

不过这个可能需要了解一些BMP头相关的知识。这里采用一个更为暴力的方法，通过一个Python脚本解析BMP文件结构，把的数值复制给：

rgbReserved

rgbBlue

with open('threebody.bmp', 'rb') as f: d = f.read()w = 580h = 435b = 4l = bytearray(d)off = l[10]for i in range(h): for j in range(w): l[off+j*b+i*b*w] = l[off+j*b+i*b*w+3]with open('threebody_new.bmp', 'wb') as f: f.write(l)

再通过StegSolve进行查看，可以发现另一个隐藏的图形：

可见中间是一个黑白相间的正方形，其中左上角部分比其他部分颜色要深一些。

大家肯定能想到这里的黑白便是01序列，所以这是一个二维的二进制数组。考虑将这些二进制数组逐行保存成二进制文件，无果，并且如果是逐行保存的话不应该出现左上角的区域与其他区域密度明显不同的情况。

那这个二维数组里的信息是如何储存的呢？

这又要回到刚才提到的数学家希尔伯特了。希尔伯特提出过一种希尔伯特曲线，是一个高维到低维的映射。我们现在得到的二维二进制数组，可以通过这种方式进行降维处理转化成一串一维的二进制流。

并且，希尔伯特曲线的一个特性便是如果从低维还原成高维，则低维中相邻的点在高维中也是相邻的。这就解释了为什么会出现某一块区域密度与其他区域密度不同的情况。

不过从希尔伯特想到希尔伯特曲线可能并不十分容易，希尔伯特作为一位伟大的数学家一生的成就太多了，希尔伯特曲线可能只是其中不起眼的一个成就。

为了防止大家卡在这里，我在比赛中放出了另一个提示“不要埋头做，根据已有信息合理使用搜索引擎”。

这其实是一个大家都明白的道理，做CTF题目，尤其是做Misc题目的时候，善用搜索引擎是非常关键的一步。

但如果单纯搜索“希尔伯特”的话可能需要翻阅大量的网页，这里就需要大家有一些更加跳跃性的思维了。还记得这个题目的主体是什么吗？没错，是“三体”。那三体与希尔伯特这两个看似风马牛不相及的名词，会不会有某种联系呢？事实上，如果尝试以“三体 希尔伯特”作为关键词进行搜索， 很容易搜索引发这道题的出题思路的文章：

https://mp.weixin.qq.com/s/IOSGOJnGyiGoD8J1ITQJlg

这篇文章用文字和图片介绍了三个月前B站的一期关于降维打击的视频，视频当时还小火了一把。没错，降维打击！这不正是题目里的图片所讲述的故事。如果你看了文章会发现两张隐藏的图片都能在文章中的视频截图里找到。当发现这一点之后便可以确定，这个视频肯定跟这个题目有着密切的关系。而这个视频，讲的恰恰就是希尔伯特曲线。

下面要做的就是如何利用希尔伯特曲线把这里的二维数据转化成一维数据了。

不同维度的希尔伯特曲线是这样的：

![img](https://nimg.ws.126.net/?url=http%3A%2F%2Fdingyue.ws.126.net%2F2021%2F0618%2Fc8efdf1cp00quvwym002sc000u000k1m.png&thumbnail=660x2147483647&quality=80&type=jpg)

因为这里我们得到的是128128的矩阵，128=2*7，所以我们应该使用7维的希尔伯特矩阵。

然后通过希尔伯特曲线的排列方式抽取各像素点的值，视频里已经给我们展示了，类似这样：

![img](https://nimg.ws.126.net/?url=http%3A%2F%2Fdingyue.ws.126.net%2F2021%2F0618%2F87350811p00quvwym002yc000b600b4m.png&thumbnail=660x2147483647&quality=80&type=jpg)

我们可以使用脚本把二维的01矩阵降维成一维的二进制流，便可以得到隐藏的文件。我在写脚本处理图片的时候用到了 https://github.com/galtay/hilbertcurve 这个库，实现的代码为：

```
import numpy as npfrom PIL import Imagefrom hilbertcurve.hilbertcurve import HilbertCurvewith Image.open('threebody_new.bmp') as img: arr = np.asarray(img)arr = np.vectorize(lambda x: x&1)(arr[:,:,2])for x1 in range(np.size(arr,0)): if sum(arr[x1])>0: breakfor x2 in reversed(range(np.size(arr,0))): if sum(arr[x2])>0: breakfor y1 in range(np.size(arr,1)): if sum(arr[:,y1])>0: breakfor y2 in reversed(range(np.size(arr,1))): if sum(arr[:,y2])>0: breakarr = arr[x1:x2+1, y1:y2+1]hilbert_curve = HilbertCurve(7, 2)s = ''for i in range(np.size(arr)): [x,y] = hilbert_curve.point_from_distance(i) s += str(arr[127-y][x])with open('output', 'wb') as f: f.write(int(s,2).to_bytes(2048, 'big'))
```

这里的便是最后得到的文件，打开可以发现是一个C语言程序。编译并执行这个C语言程序，发的输出结果便为该C语言程序本身。

output

其实这种可以打印自身的程序学名叫Quine，2015年第一届强网杯的NESTING DOLL题目便是关于Qunie的，这里也是小小地纪念一下当年打CTF的时光。

不过如果对原始代码和程序输出的代码进行仔细比对的话可以发现，两者并不是完全相同的，在output的第11行后面多出了大片的空白字符，由空格和Tab构成。

通过把空格替换成0、Tab替换成1，可得到字符串

```
01100110011011000110000101100111011110110100010000110001011011010100010101101110001101010110100100110000011011100100000101101100010111110101000001110010001100000011011000110001011001010110110101111101
```

这段二进制串还原便可得到Flag：flag{D1mEn5i0nAl_Pr061em}

## [Pwn]真的nc上去就有flag了

算是pwn签到题吧，直接nc

![image-20221107134414324](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20221107134414324.png)

## 【Web福利题】某真实渗透场景

我真的会谢！

![image-20221107134646865](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20221107134646865.png)

我以为会是SQL注入，直到hint放出。。。。。
<img src="https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20221107134918771.png" alt="image-20221107134918771" style="zoom:50%;" />

我真的会谢。。。。

## [Reverse]what_is_pyc

先百度啥叫pyc，**什么是pyc文件**

```
pyc是一种二进制文件，是由Python文件经过编译后所生成的文件，它是一种byte code，Python文件变成pyc文件后，加载的速度有所提高，而且pyc还是一种跨平台的字节码，由python的虚拟机来执行的，就类似于JAVA或者.NET的虚拟机的概念。pyc的内容与python的版本是相关的，不同版本编译后的pyc文件是不同的，例如2.5版本编译的是pyc文件，而2.4版本编译的python是无法执行的
```

就知道他是经过.py编译过来的就行，百度pyc反编译

发现python反编译在线网站https://tool.lu/pyc/

生成然后复制，对脚本稍加修改，get flag

## [Forensic]芝麻开门！

解开附件压缩包得到`Windows7_research-cl1.vmdk`是VM虚拟机磁盘镜像，用AXIOM Process进行取证，选择磁盘镜像取证，等软件读完数据直接检索pas，flag等关键词，直接get flag

## [Web]Intranet！

![image-20221107135827801](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20221107135827801.png)

放到浏览器，没查到啥，直接扫目录

![image-20221107140128615](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20221107140128615.png)

dirsearch结果：

![image-20221107141805329](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20221107141805329.png)

![image-20221107141852657](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20221107141852657.png)

![image-20221107142013708](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20221107142013708.png)

![image-20221107142116711](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20221107142116711.png)

get shell
![image-20221107142403462](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20221107142403462.png)

![image-20221107143112582](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20221107143112582.png)

![image-20221107143708420](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20221107143708420.png)
