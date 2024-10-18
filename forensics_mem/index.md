# Forensics_内存取证gimp分析进程图像


记一内存取证题目

<!--more-->

```
python vol.py -f C:\Users\scofi\Desktop\baby_misc.raw windows.filescan
```

![image-20241016165548853](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20241016165548853.png?imageSlim)

导出flag.zip，发现有密码，又找到hint.txt

![image-20241016195130201](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20241016195130201.png?imageSlim)

导出calc进程的内存，修改后缀为.data并放进gimp进行分析

![image-20241016195255392](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20241016195255392.png?imageSlim)

调试图像技巧：

> 先把载入图像的区域拉大

![image-20241016195348963](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20241016195348963.png?imageSlim)

图像类型建议选择RGB透明，对比比较明显，宽高设置成七百到一千多就行，根据自己需要可以选择常规的分辨率，最终还是取决于偏移。

```
1440 x 900
1400 x 1050
1366 x 768
1360 x 768
1280 x 960
1280 x 800
1280 x 768
1280 x 720
1280 x 600
1152 x 864
1024 x 768 
800 x 600
```

![image-20241018091400875](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20241018091400875.png?imageSlim)

calc.exe进程没拿到关键信息，随后在exprolor.exe进程中取到了calc的截图

![image-20241018093302078](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20241018093302078.png?imageSlim)

最终在Windows模块信息中搜索132424464得到了完整的十六进制字符串5E26473132424464，直接解密不对，十六进制转文本解压成功

![image-20241018100510698](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20241018100510698.png?imageSlim)

