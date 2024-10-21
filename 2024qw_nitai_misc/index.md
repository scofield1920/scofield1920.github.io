# 2024强网拟态预赛misc


第七届“强网”拟态防御国际精英挑战赛线上预选赛misc

<!--more-->

### pvz

算1-1000的md5作为密码字典然后爆破压缩包

```python
import hashlib

def generate_md5(number):
    # 将数字转换为字符串，然后编码为字节
    number_str = str(number).encode('utf-8')
    # 创建md5对象
    md5 = hashlib.md5()
    # 更新md5对象，传入需要计算md5的字节数据
    md5.update(number_str)
    # 获取16进制格式的md5值
    return md5.hexdigest()

# 打开文件准备写入
with open('dict.txt', 'w', encoding='utf-8') as file:
    # 循环1到1000
    for i in range(1, 1001):
        # 生成md5值
        md5_value = generate_md5(i)
        # 写入文件，并添加换行符
        file.write(md5_value + '\n')

print("MD5值已生成并写入dict.txt文件。")
```

进行压缩包爆破

![image-20241020160431436](C:\Users\scofi\AppData\Roaming\Typora\typora-user-images\image-20241020160431436.png)

将得到的二维码用ps调整一下

```
Ctrl+T
Ctrl+Shift+Alt
```

![image-20241020160529594](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20241020160529594.png?imageSlim)

填上定位符和给的码块

![](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20241020160616008.png?imageSlim)

扫描二维码

![image-20241020160634493](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20241020160634493.png?imageSlim)

根据文件名提示得知为Malbolge代码，运行得到flag

https://malbolge.doleczek.pl/

![image-20241020160718409](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20241020160718409.png?imageSlim)

### ezflag

追踪tcp流发现是zip压缩包（PK），导出原始数据

![image-20241020161613764](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20241020161613764.png?imageSlim)

存为zip文件

删除尾部冗余数据，解压后得到flag.zip，分析为png文件

![image-20241020163039956](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20241020163039956.png?imageSlim)

得到flag

![image-20241020163152454](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20241020163152454.png?imageSlim)

### Streaming

![image-20241020171033351](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20241020171033351.png?imageSlim)

根据信息可判断为h.264流

![image-20241020174209240](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20241020174209240.png?imageSlim)

![image-20241020174253116](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20241020174253116.png?imageSlim)

![image-20241020174300656](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20241020174300656.png?imageSlim)

利用插件，从RTP流中提取h.264

https://www.cnblogs.com/liushui-sky/p/13671360.html

![image-20241020174333752](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20241020174333752.png?imageSlim)

![image-20241020174340142](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20241020174340142.png?imageSlim)

播放h.264得到

![image-20241020174516722](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20241020174516722.png?imageSlim)

异或ff并用`'flag{3b3a9c08-'`作为密钥进行aes解密

![image-20241020174854920](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20241020174854920.png?imageSlim)

得到压缩包

![image-20241020174848946](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20241020174848946.png?imageSlim)

分析badapple为png

苹果图片解析差异

https://www.fotoforensics.com/

![image-20241020175206683](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20241020175206683.png?imageSlim)

对s4cret文件补齐文件头

![image-20241020175727843](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20241020175727843.png?imageSlim)

播放得到闪烁的视频

写一个脚本，来分析mp4视频，当画面为黑色代表0，画面为白色代表1，输出01字符串

```py
import cv2
import numpy as np

# 视频文件路径
video_path = 'your_video.mp4'

# 打开视频文件
cap = cv2.VideoCapture(video_path)

# 初始化输出字符串
output_string = ''

# 读取视频帧
while cap.isOpened():
    ret, frame = cap.read()
    if not ret:
        break

    # 将BGR转换为灰度图像
    gray = cv2.cvtColor(frame, cv2.COLOR_BGR2GRAY)

    # 阈值处理，将灰度图像转换为二值图像
    _, binary = cv2.threshold(gray, 127, 255, cv2.THRESH_BINARY)

    # 检查二值图像是否全黑或全白
    if np.all(binary == 0):
        output_string += '0'
    elif np.all(binary == 255):
        output_string += '1'
    else:
        # 如果不是全黑或全白，可以在这里添加其他逻辑
        output_string += '?'

# 释放视频捕获对象
cap.release()

# 打印输出字符串
print(output_string)
```

得到的二进制串转ascii，得到乱码，考虑到可能01逻辑搞反，将01字符互换，得到

```
0111010001101000011001010010000001100110011011000110000101100111001100110010000001101001011100110010000000101101001100010011001100111000001110010011000101100010011000010011001100110010001101000110010001100001011111011111111111111111111111111111111111111111111
```

转ascii

```
the flag3 is -13891ba324da}ÿÿÿÿÿ
```

### Find way to read video

根据文本hint，收缩到在gitcode有marco1763的文件

![image-20241021105740284](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20241021105740284.png?imageSlim)

下载md文件，复制内容进行spam解密

https://spammimic.com/

得到

```
BV1P62EYHEZd eyJ2IjozLCJuIjoiZmw0ZyIsInMiOiIiLCJoIjoiZGExMTcyNSIsIm0iOjkwLCJrIjo4MSwibWciOjIwMCwia2ciOjEzMCwibCI6NDMsInNsIjoxLCJmaGwiOlsiMjUyZjEwYyIsImFjYWM4NmMiLCJjYTk3ODExIiwiY2QwYWE5OCIsIjAyMWZiNTkiLCIyYzYyNDIzIiwiY2E5NzgxMSIsIjRlMDc0MDgiLCJlN2Y2YzAxIiwiMmM2MjQyMyIsIjI1MmYxMGMiLCI1ZmVjZWI2IiwiZWYyZDEyNyIsIjM5NzNlMDIiLCJjYTk3ODExIiwiNGIyMjc3NyIsImU3ZjZjMDEiLCI3OTAyNjk5IiwiMzk3M2UwMiIsIjRiMjI3NzciLCI3OTAyNjk5IiwiZWYyZDEyNyIsIjI1MmYxMGMiLCIzOTczZTAyIiwiY2E5NzgxMSIsImVmMmQxMjciLCJkNDczNWUzIiwiMjUyZjEwYyIsIjM5NzNlMDIiLCI2Yjg2YjI3IiwiM2UyM2U4MSIsImQ0NzM1ZTMiLCJlN2Y2YzAxIiwiMmU3ZDJjMCIsIjJlN2QyYzAiLCI0YjIyNzc3IiwiNWZlY2ViNiIsIjI1MmYxMGMiLCIyZTdkMmMwIiwiNGIyMjc3NyIsIjNmNzliYjciLCJkMTBiMzZhIiwiMDFiYTQ3MSIsIjZlMzQwYjkiLCI2ZTM0MGI5IiwiNmUzNDBiOSIsIjZlMzQwYjkiLCI2ZTM0MGI5IiwiNmUzNDBiOSIsIjZlMzQwYjkiLCI2ZTM0MGI5IiwiNmUzNDBiOSIsIjZlMzQwYjkiLCI2ZTM0MGI5IiwiNmUzNDBiOSIsIjZlMzQwYjkiLCI2ZTM0MGI5IiwiNmUzNDBiOSIsIjZlMzQwYjkiLCI2ZTM0MGI5IiwiNmUzNDBiOSIsIjZlMzQwYjkiLCI2ZTM0MGI5IiwiNmUzNDBiOSIsIjZlMzQwYjkiLCI2ZTM0MGI5IiwiNmUzNDBiOSIsIjZlMzQwYjkiLCI2ZTM0MGI5IiwiNmUzNDBiOSIsIjZlMzQwYjkiLCI2ZTM0MGI5IiwiNmUzNDBiOSIsIjZlMzQwYjkiLCI2ZTM0MGI5IiwiNmUzNDBiOSIsIjZlMzQwYjkiLCI2ZTM0MGI5IiwiNmUzNDBiOSIsIjZlMzQwYjkiLCI2ZTM0MGI5IiwiMDg0ZmVkMCIsIjE4ZjUzODQiLCIxODlmNDAwIiwiZWY2Y2JkMiIsIjI3OTUyMTciLCJhOTI1M2RjIiwiNGM5NDQ4NSIsIjI1MmYxMGMiLCI4NWY5N2UwIl19
```

将第二段字符串base64解码

```
{"v":3,"n":"fl4g","s":"","h":"da11725","m":90,"k":81,"mg":200,"kg":130,"l":43,"sl":1,"fhl":["252f10c","acac86c","ca97811","cd0aa98","021fb59","2c62423","ca97811","4e07408","e7f6c01","2c62423","252f10c","5feceb6","ef2d127","3973e02","ca97811","4b22777","e7f6c01","7902699","3973e02","4b22777","7902699","ef2d127","252f10c","3973e02","ca97811","ef2d127","d4735e3","252f10c","3973e02","6b86b27","3e23e81","d4735e3","e7f6c01","2e7d2c0","2e7d2c0","4b22777","5feceb6","252f10c","2e7d2c0","4b22777","3f79bb7","d10b36a","01ba471","6e340b9","6e340b9","6e340b9","6e340b9","6e340b9","6e340b9","6e340b9","6e340b9","6e340b9","6e340b9","6e340b9","6e340b9","6e340b9","6e340b9","6e340b9","6e340b9","6e340b9","6e340b9","6e340b9","6e340b9","6e340b9","6e340b9","6e340b9","6e340b9","6e340b9","6e340b9","6e340b9","6e340b9","6e340b9","6e340b9","6e340b9","6e340b9","6e340b9","6e340b9","6e340b9","6e340b9","6e340b9","6e340b9","084fed0","18f5384","189f400","ef6cbd2","2795217","a9253dc","4c94485","252f10c","85f97e0"]}
```

第一段文本是b站的BV号BV1P62EYHEZd

![image-20241021110440199](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20241021110440199.png?imageSlim)

但并没得到什么有效信息，经过观察与验证发现后面的数组字符串是f，l，a，g字母字样的sha256前7位

![image-20241021111358575](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20241021111358575.png?imageSlim)

写脚本进行爆破

```python
import hashlib
import string

# 获取所有可能的字符
possible_chars = string.printable  # 包含所有可打印字符

# 建立哈希前缀到字符的映射
hash_prefix_to_char = {}
for char in possible_chars:
    sha256_hash = hashlib.sha256(char.encode()).hexdigest()
    prefix = sha256_hash[:7]
    hash_prefix_to_char[prefix] = char

# 给定的哈希前缀列表
fhl = [
    "252f10c", "acac86c", "ca97811", "cd0aa98", "021fb59", "2c62423", "4e07408", "4e07408",
    "ca97811", "2e7d2c0", "6b86b27", "3f79bb7", "4e07408", "3973e02", "d4735e3", "4b22777",
    "7902699", "e7f6c01", "3973e02", "4b22777", "4b22777", "6b86b27", "2e7d2c0", "3973e02",
    "ca97811", "3f79bb7", "4e07408", "d4735e3", "3973e02", "3f79bb7", "3f79bb7", "252f10c",
    "3f79bb7", "6b86b27", "18ac3e7", "5feceb6", "4e07408", "18ac3e7", "18ac3e7", "19581e2",
    "3f79bb7", "d10b36a", "01ba471", "6e340b9", "6e340b9", "6e340b9", "6e340b9", "6e340b9",
    "6e340b9", "6e340b9", "6e340b9", "6e340b9", "6e340b9", "6e340b9", "6e340b9", "6e340b9",
    "6e340b9", "6e340b9", "6e340b9", "6e340b9", "6e340b9", "6e340b9", "6e340b9", "6e340b9",
    "6e340b9", "6e340b9", "6e340b9", "6e340b9", "6e340b9", "6e340b9", "6e340b9", "6e340b9",
    "6e340b9", "6e340b9", "6e340b9", "6e340b9", "6e340b9", "77adfc9", "de7d1b7", "44bd7ae",
    "bb7208b", "83891d7", "2a0ab73", "fe1dcd3", "559aead", "f031efa"
]

# 重建消息
message = ''
for prefix in fhl:
    char = hash_prefix_to_char.get(prefix)
    if char:
        message += char
    else:
        message += '?'

print("重建的消息：", message)
```

![image-20241021113034280](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20241021113034280.png?imageSlim)

