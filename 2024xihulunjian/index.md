# 第七届西湖论剑初赛_easy_rawraw


第七届西湖论剑初赛_easy_rawraw

<!--more-->

### misc- easy_rawraw

下载解压得到附件

```
mysecretfile.rar
rawraw.raw
```

mysecretfile.rar有密码

使用R-Studio扫描内存镜像

![image-20241129135755918](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20241129135755918.png?imageSlim)

直接提取文件损坏

使用vol3进行扫描提取文件

```
python3 vol.py" -f "C:/Users/xxx/Desktop/easy_rawraw/rawraw.raw" -r csv windows.filescan

python3 vol.py -f C:/Users/xxx/Desktop/easy_rawraw/rawraw.raw -o output windows.dumpfile --physaddr 0x3df8b650
```

![image-20241129141245341](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20241129141245341.png?imageSlim)

查看十六进制信息

![image-20241129141257056](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20241129141257056.png?imageSlim)

发现有zip，binwalk进行提取

得到加密的zip文件，有hint：`Have a good New Year!!!!!!!`

![image-20241129141505639](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20241129141505639.png?imageSlim)

查了下日历，春节时间是2月10日，尝试密码`20240210`，成功解压

![image-20241129141607949](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20241129141607949.png?imageSlim)

使用vol2提取剪切板，得到password:`DasrIa456sAdmIn987`

```
python2 vol.py -f C:/Users/xxx/Desktop/easy_rawraw/rawraw.raw --profile=Win7SP1x64 clipboard -v --output=text --output-file=output/output_vol2_clipboard_v.text
```

![image-20241129142028104](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20241129142028104.png?imageSlim)

解压得到容器mysecret，使用veracrypt进行挂载，导入密钥文件即前面得到的pass.txt

![image-20241129142653862](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20241129142653862.png?imageSlim)

得到data.xlsx，有密码

![image-20241129142824706](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20241129142824706.png?imageSlim)

使用Mimikatz提取一下用户的密码，得到`das123admin321`

```
python2 vol.py -f C:/Users/scofi/Desktop/easy_rawraw/rawraw.raw --profile=Win7SP1x64 mimikatz
```

打开xlsx文件，发现隐藏的列

![image-20241129143634610](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20241129143634610.png?imageSlim)

展开得到flag

![image-20241129143653179](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20241129143653179.png?imageSlim)

```
DASCTF{5476d4c4ade0918c151aa6dcac12d130}
```


