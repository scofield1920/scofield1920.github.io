# [转载]一句话木马


一句话木马de一些姿势

<!--more-->

# [做一个图片马的四种方法(详细步骤) ](https://www.cnblogs.com/1ink/p/15101706.html)

笔记转载自：

本文作者：1ink

本文链接：https://www.cnblogs.com/1ink/p/15101706.html



### 简介

图片马:就是在图片中隐藏一句话木马。利用.htaccess等**解析图片为PHP或者asp文件**。达到执行图片内代码目的

制作方法:

1. 文本方式打开,末尾粘贴一句话木马
2. cmd中 copy 1.jpg/b+2.php 3.jpg
   - /b是二进制形式打开
   - /a是ascii方式打开
   - 看到有人说一定要把图片放前面,木马放后面才能成功,我亲自试了这两种制作方式(另一种图片放后面),均能成功连接,但是后者的一句话木马在文件开头,不推荐
3. 16进制打开图片在末尾添加一句话木马。
4. ps

注意以下几点:

- 单纯的图片马并不能直接和蚁剑连接，
- 因为该文件依然是以image格式进行解析，
- 只有利用**文件包含漏洞**，才能成功利用该木马
- 所谓文件包含漏洞，是指在代码中引入其他文件作为php文件执行时，未对文件进行严格过滤，导致用户指定任意文件，都作为php文件解析执行。

### 1.文本方式打开图片直接粘贴一句话木马

将一个图片以文本格式打开(这里用的notepad++.以记事本方式打开修改也能连接成功,不过修改后图片无法正常显示了),
后面粘贴上一句话木马

![image-20210805083136737](https://gitee.com/AlucardLink/picgo/raw/master/img/20210805083136.png)

上传图片

![image-20210804185037899](https://gitee.com/AlucardLink/picgo/raw/master/img/20210804185037.png)

连接蚁剑,嗯,很好,连接成功

![image-20210805082417491](https://gitee.com/AlucardLink/picgo/raw/master/img/20210805082417.png)

### 2.cmd命令行执行

在windows的cmd中执行

![image-20210804190007284](https://gitee.com/AlucardLink/picgo/raw/master/img/20210804190007.png)

可以看到末尾已经有一句话木马了

![image-20210804190120185](https://gitee.com/AlucardLink/picgo/raw/master/img/20210804190120.png)

上传之后连接试试,成功

![image-20210805082902006](https://gitee.com/AlucardLink/picgo/raw/master/img/20210805082902.png)

### 3.用16进制编辑器打开,末尾添加

用winhex打开图片,添加一句话木马

![image-20210805083735267](https://gitee.com/AlucardLink/picgo/raw/master/img/20210805083735.png)

上传,连接成功

![image-20210805084149501](https://gitee.com/AlucardLink/picgo/raw/master/img/20210805084149.png)

### 4.用PhotoShop制作

先打开图片

![image-20210805085050633](https://gitee.com/AlucardLink/picgo/raw/master/img/20210805085050.png)

点击文件->文件简介

![image-20210805085352052](https://gitee.com/AlucardLink/picgo/raw/master/img/20210805085352.png)

添加木马

![image-20210805085521364](https://gitee.com/AlucardLink/picgo/raw/master/img/20210805085521.png)

上传,连接成功

![image-20210805085625923](https://gitee.com/AlucardLink/picgo/raw/master/img/20210805085625.png)
