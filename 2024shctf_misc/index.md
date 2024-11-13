# 2024SHCTF_misc


赛题复现

<!--more-->

## Week1

### 签到题

扫码关注公众号回复

### 拜师之旅①

010editor打开补充png头尾的hex数据

![image-20241031104546028](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20241031104546028.png?imageSlim)

修复高度

![image-20241031104637711](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20241031104637711.png?imageSlim)

### 真真假假?遮遮掩掩!

伪加密和掩码攻击

![image-20241031104831829](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20241031104831829.png?imageSlim)

![image-20241031104904954](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20241031104904954.png?imageSlim)

掩码爆破

![image-20241031105618775](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20241031105618775.png?imageSlim)

### Rasterizing Traffic

导出流量中的png图片

![image-20241031105942512](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20241031105942512.png?imageSlim)

一张光栅图片

![image-20241031110209576](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20241031110209576.png?imageSlim)

网上搜的脚本稍微修一下就能用

![image-20241031110349984](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20241031110349984.png?imageSlim)

### 有WiFi干嘛不用呢？

把may中所有的数据提取出来做成字典：

```
cat ./* > output
```

删一下[]，aircrack-ng爆破即可：

```
aircrack-ng 01.cap -w output
```

![image-20241031111804546](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20241031111804546.png?imageSlim)

## Week2

### 练假成真

使用QRazyBox的Data Sequence Analysis功能

![image-20241031112327963](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20241031112327963.png?imageSlim)

从右下角开始，第一个块记载了模式，从第三个开始为数据块，将`SHCTF{`转为二进制，然后填进去

```
01010011 01001000 01000011 01010100 01000110 01111011
```

![image-20241031112719053](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20241031112719053.png?imageSlim)

随后使用Padding Bits Recovery功能补上部分像素

![image-20241031115058996](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20241031115058996.png?imageSlim)

最后通过 Reed-Solomon Decoder 还原出二维码所存数据

```
SHCTF{RjFhZ2Y0SzNyRjFhZ2Y0SzNy}
```

base64解码一下

![image-20241031115502824](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20241031115502824.png?imageSlim)

使用foremost又分离出一张图

![image-20241031115442198](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20241031115442198.png?imageSlim)

换表base64

![image-20241031115622411](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20241031115622411.png?imageSlim)

最终flag: SHCTF{THis_F14GTHis_F14G}

**参考文档**

https://www.cnblogs.com/luogi/p/15469106.html#%E4%BA%8C%E7%BB%B4%E7%A0%81%E5%9F%BA%E7%A1%80%E7%9F%A5%E8%AF%86

https://blog.csdn.net/Scalzdp/article/details/133927363

### Schneider

src-2020-0010，poc:

```
#!/usr/bin/env python3
"""
Schneider Electric EcoStruxure Operator Terminal Expert Hardcoded Cryptographic Key Information Disclosure Vulnerability
SRC ....: SRC-2020-0010
CVE ....: N/A
File ...: EcoStruxure Operator Terminal Expert V3.1.iso
SHA1 ...: 386312d68ba5e6a98df24258f2fbcfb2d8c8521b
Download: https://download.schneider-electric.com/files?p_File_Name=EcoStruxure+Operator+Terminal+Expert+V3.1.iso
"""
import os
import re
import sys
import glob
import zlib
import zipfile
from Crypto.Cipher import DES3

# hardcoded values
key  = [ 202, 20, 221, 52, 225, 154, 5, 123, 111, 219, 11, 199, 145, 27, 200, 129, 254, 222, 253, 119, 213, 134, 72, 78 ]
iv   = [ 95, 21, 44, 250, 112, 73, 114, 155 ]
des3 = [ 93, 51, 117, 85, 189, 76, 88, 200, 231, 127 ]
plen  = 8

def check_equal(iterator):
   # if all the values are the same then its padding...
   return len(set(iterator)) <= 1

def _inflate(decoded_data):
    return zlib.decompress(decoded_data, -15)

def _deflate(string_val):
    compressed = zlib.compress(string_val)
    return compressed[2:-4]

def delete_folder(top) :
    for root, dirs, files in os.walk(top, topdown=False):
        for name in files:
            os.remove(os.path.join(root, name))
        for name in dirs:
            os.rmdir(os.path.join(root, name))
    os.rmdir(top)

def decrypt_file(filename):
    print("(+) unpacking: %s" % filename)
    decr = DES3.new(bytes(key), DES3.MODE_CBC, bytes(iv))
    default_data = bytes([8, 8, 8, 8, 8, 8, 8, 8])
    with open(filename, "rb") as f:
        if list(f.read(10)) == des3:
            encrypted = f.read()
            raw_data = decr.decrypt(encrypted)
            if not check_equal(list(raw_data)):
                raw_data = _inflate(raw_data)
        else:
            f.seek(0)
            raw_data = f.read() 
    # now that we have the decrypted data, let's overwrite the file...
    with open(filename, "wb") as f:
        f.write(raw_data)

def encrypt_file(filename):
    print("(+) packing: %s" % filename)
    encr = DES3.new(bytes(key), DES3.MODE_CBC, bytes(iv))
    with open(filename, "rb") as f:
        packed_data = f.read()
        if not packed_data == bytes([8, 8, 8, 8, 8, 8, 8, 8]):
            packed_data = _deflate(packed_data)
        # padding for encryption, same as schneider
        pad = plen - (len(packed_data) % plen)
        # if we just have padding in there, then dont bother adding more padding now...
        if len(packed_data) != 8:
            for i in range(0, pad):
                packed_data += bytes([pad])
        encr_data = bytes(des3) + encr.encrypt(packed_data)
    with open(filename, "wb") as f:
        f.write(encr_data)

def unpack(project):
    z = os.path.abspath(project)
    output_dir = os.path.splitext(z)[0]
    print("(+) unpacking to %s" % output_dir)
    if os.path.exists(output_dir):
        print("(-) %s already exists!" % output_dir)
        return False
    zip_obj = zipfile.ZipFile(z, 'r')
    zip_obj.extractall(output_dir)
    zip_obj.close()
    # two levels deep, we can do more if we need to
    for file in list(set(glob.glob(output_dir + '/**/**/*.*', recursive=True))):
        decrypt_file(file)
    print("(+) unpacked and decrypted: %s" % project)

def pack(project):
    z = os.path.abspath(project)
    output_dir = os.path.splitext(z)[0]
    # two levels deep, we can do more if we need to
    for file in list(set(glob.glob(output_dir + '/**/**/*.*', recursive=True))):
        if os.path.basename(file) != "[Content_Types].xml":
            encrypt_file(file)

    zf = zipfile.ZipFile(project, "w")
    for file in list(set(glob.glob(os.path.basename(output_dir) + '/**/**/*.*', recursive=True))):
        zf.write(file, "/".join(file.strip("/").split('/')[1:]))

    zf.close()
    delete_folder(output_dir)
    print("(+) packed and encrypted: %s" % project)

def main():
    if len(sys.argv) != 3:
        print("(+) usage: %s[options]" % sys.argv[0])
        print("(+) eg: %s sample.vxdz unpack" % sys.argv[0])
        print("(+) eg: %s sample.vxdz pack" % sys.argv[0])
        sys.exit(0)
    f = sys.argv[1]
    c = sys.argv[2]
    if c.lower() == "unpack":
        unpack(f)
    elif c.lower() == "pack":
        pack(f)
    else:
        print("(-) invalid option!")
        sys.exit(1)

if __name__ == '__main__':
    main()
```

Security.db

![image-20241031131714677](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20241031131714677.png?imageSlim)

### 屁

找到文件头以 `PK` 开头的文件，将其后缀改为 ZIP 

![image-20241031132317891](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20241031132317891.png?imageSlim)

可以看到压缩方法采用 **「Deflate」** 算法 ，没有加密，这意味着**「数据区」**的文件数据可以直接使用 **「`zlib.decompress`」** 进行解压。

同时可确定最小的文件即为文件尾。

删除 ZIP 的文件头尾后，编写代码进行爆破。

删除第一个文件头部

![image-20241031132916243](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20241031132916243.png?imageSlim)

删除最后文件尾部

![image-20241031132946706](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20241031132946706.png?imageSlim)

写脚本进行爆破

（脚本参考官方wp）

```python
import os
import itertools
import zlib
from tqdm import tqdm


def read_binary_file(file_path):
    with open(file_path, "rb") as f:
        return f.read()


def try_decompress(data):
    try:
        decompressed_data = zlib.decompress(data, -zlib.MAX_WBITS)
        return decompressed_data
    except zlib.error:
        return None


def calculate_crc32(data):
    if len(data) != 105734:
        return None
    return zlib.crc32(data) & 0xFFFFFFFF


def main():
    directory = "屁"  # 指定目录
    # 指定开头和结尾文件
    start_file = os.path.join(directory, "屁.z66")
    end_file = os.path.join(directory, "屁.z40")
    files = [os.path.join(directory, f) for f in os.listdir(directory) if os.path.isfile(os.path.join(directory, f))]

    # 移除开头和结尾文件
    files.remove(start_file)
    files.remove(end_file)

    # 生成剩余文件的全排列
    permutations = itertools.permutations(files)

    # 计算排列的总数
    total_permutations = sum(1 for _ in permutations)

    # 重置 permutations 以便再次迭代
    permutations = itertools.permutations(files)

    # 已知的CRC32值
    known_crc32 = 0x0B6E238E

    for perm in tqdm(permutations, total=total_permutations, desc="Processing"):
        # 将开头和结尾文件固定在首尾
        combined_files = [start_file] + list(perm) + [end_file]
        # 连接所有文件的二进制内容
        combined_data = b"".join(read_binary_file(file_path) for file_path in combined_files)

        # 尝试解压缩
        decompressed_data = try_decompress(combined_data)

        if decompressed_data is not None:
            # 计算解压后数据的CRC32值
            calculated_crc32 = calculate_crc32(decompressed_data)

            # 检查CRC32值是否匹配
            if calculated_crc32 == known_crc32:
                print("解压成功！")
                # 输出解压后的数据
                with open("屁.svp", "wb") as f:
                    f.write(decompressed_data)
                print("解压后的数据已保存到 屁.svp")
                break
    else:
        print("没有找到可以成功解压的排列顺序。")


if __name__ == "__main__":
    main()
```

![image-20241031133114366](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20241031133114366.png?imageSlim)

成功解压后得到术力口工程文件，可以使用 `Synthesizer V` 打开

![image-20241031133240723](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20241031133240723.png?imageSlim)

发现部分字和音素对不上。

Synthesizer V 使用 ARPABET 作为音素标准，仔细查找可以找到一个字典

```
https://github.com/cmusphinx/sphinxtrain/blob/master/test/res/communicator.dic.cmu.full 
```

翻译得到下面的话。

```
S.,H.,C.,T.,F.,Open Curly Bracket,B.,L.,four,C.,K.,Underscore,M.,Y.,seven,H.,colon,five,H.,four,N.,H.,three,Close Curly Bracket
```

flag

```
SHCTF{BL4CK_MY7H:5H4NH3}
```

### 拜师之旅②

题目描述是个谐音梗"挨打"(IDAT)

![image-20241031133546787](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20241031133546787.png?imageSlim)

可以发现实质是两张图片放到了一起,一张`4995`为底 ,一张`5185`为底

假flag的图片为前者优先显示,删掉对应的三个IDAT块后保留头尾IHDR,IEND再保存得到真flag图片

![image-20241031133716221](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20241031133716221.png?imageSlim)

![image-20241031133706058](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20241031133706058.png?imageSlim)

### 遮遮掩掩?CCRC!

ZipCrypto加密,并且文件内容大小只有3byte,结合题目考虑CRC爆破

```python
import zlib

flag=''
crc_list = [0x42582aaa, 0xbce853c2, 0x211fdb00, 0x70c6b6fe, 0x63ad436c, 0x84bd90bd, 0x55769db8, 0x8a2a7829, 0x5c66f4cd, 0x8454f318, 0x8c88cc6a, 0x7eb2adde, 0x078776df, 0x21509dfb, 0x0c975144, 0xf51f79ac, 0xf262197e, 0x8b5919f7, 0x8b5919f7, 0x11d0d7ba, 0x5c66f4cd, 0x38457732, 0xcdff1d1b, 0xcdf2ddf2, 0x7af934d6, 0x21509dfb, 0x5bf57dc6, 0xd617d273, 0xf9d901d6, 0xcdf2ddf2, 0x21509dfb, 0xe98e7a37, 0xc94d437d, 0x1bbe8b92, 0x7dc6ef2a, 0x0f1e9f47, 0x5c66f4cd, 0x54f6ab19, 0x3b6a9c6f, 0x9e80fced, 0x94f0383e, 0xcc7fcc02, 0x8eca39aa, 0x7b2fb1b3, 0x62dd04ef, 0x211fdb00]
for target_crc in crc_list:
    for i in range(256):
        for j in range(256):
            for k in range(256):
                data = bytes([i, j, k])  # 构造3字节数据
                crc = zlib.crc32(data) & 0xffffffff  # 计算CRC32值
                if crc == target_crc:
                    data=data.decode()
                    print(f"Found matching data: {data}")
                    flag+=data
                    break

print('解密得到:'+flag)
```

得到的密文是熊曰加密，到解密网站去解密

![image-20241031215227488](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20241031215227488.png?imageSlim)

http://hi.pcmoe.net/index.html

![image-20241031215723568](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20241031215723568.png?imageSlim)

## Week3

### xor

**「出题过程：」**

创建一个文件flag`(/data/flag)`并写入flag字符串

然后创建/randomfile.py并执行：

```
import random

def generateRandomBytearray(length):
    random_bytes = bytearray()
    for _ in range(length):
        random_bytes.append(random.randint(0, 255))
    return random_bytes
    
arrs = []
flag = bytearray(open("data/flag", "rb").read())
files = ["data/flag"]

for i in range(256):
    byte_arr = generateRandomBytearray(len(flag))
    arrs.append(byte_arr)
    files.append(f"data/file{i}")
    with open(f"data/file{i}", "wb") as file:
        file.write(byte_arr)
```

于是在/data/目录下得到了file0~file255这256个文件

再创建一个xor.py`(/data/xor.py)`，代码如下

```
from pwn import xor
from os import listdir

files = [file for file in listdir() if file != 'xor.py' and file != 'flag']
flag = bytearray(open("flag", "rb").read())
for file in files:
    file = open(file, 'rb').read()
    flag = xor(flag, file)

print(flag)
with open('xor', 'wb') as f:
    f.write(flag)
```

执行后得到了xor`(/data/xor)`文件

题目描述给出了最后执行的两条命令：

```
python xor.py
rm -f xor.py flag
```

于是形成了题目附件所展示的文件集合

**「解题脚本：」**

```
from pwn import xor
from os import listdir

files = [file for file in listdir() if file != 'solve.py']
flag = b''
for file in files:
    file = open(file, 'rb').read()
    flag = xor(flag, file)

print(flag)
```

### 完

![image-20241031221138545](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20241031221138545.png?imageSlim)

根据题目描述使用foobar2000查看歌词

![image-20241031221119578](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20241031221119578.png?imageSlim)

rabbit加密，密钥为Eason_Chan

http://www.esjson.com/rabbitEncrypt.html

![image-20241031221231947](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20241031221231947.png?imageSlim)

### The Secret of Tokenizer

bkcrack已知明文攻击

```
bkcrack.exe -C .\challenge.zip -c challenge/LoveDays.otf -p plain.txt
```

得到png和otf文件

后面的otf文件丢到fontdrop网站查看

https://fontdrop.info/

在Data的description能看到密文

然后在搜索后加上看压缩包的那个png文件提示发现其实这个是文本经过GPT的tokenization之后形成的token，用处是让GPT更好的理解输入文本的语义，句法和语义，然后其实在github搜也能找到tiktoken这个模块（这里选用GPT3.5）然后直接写脚本解密

```
import tiktoken
enc = tiktoken.encoding_for_model("gpt-3.5-turbo")
text = [8758, 1182, 37, 90, 12174, 6803, 2632, 62, 22, 71, 18, 2632, 18, 31, 43, 2406, 11237, 1159, 564, 18, 77, 16, 89, 18, 5544, 1267, 19, 267, 18, 81, 12340, 92]
flag = enc.decode(text)
print(flag)
SHCTF{Oh_U_R_7h3_R3@L_LLM_Tok3n1z3rs_M4st3r!!!}
```



### 拜师之旅③

![image-20241031224349617](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20241031224349617.png?imageSlim)

可以看到里面藏了zip文件

foremost提取出压缩包，zsteg扫出密码

![image-20241031225020420](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20241031225020420.png?imageSlim)

在exif信息看到了real_size

![image-20241031232725336](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20241031232725336.png?imageSlim)

和原图刚好差12倍,使用脚本提取新图后得到flag

```python
onfrom PIL import Image

img = Image.open('2.png')
w = img.width
h = img.height
img_obj = Image.new("RGB",(w//12,h//12))

for x in range(w//12):
    for y in range(h//12):
        (r,g,b)=img.getpixel((x*12,y*12))
        img_obj.putpixel((x,y),(r,g,b))

img_obj.save('3.png')
```

![image-20241031232814178](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20241031232814178.png?imageSlim)

## Week4

### 天命人

发现了出题人半年前的博客

https://j-0k3r.github.io/2024/04/26/ps5%E6%89%8B%E6%9F%84usb&%E8%93%9D%E7%89%99%E6%B5%81%E9%87%8F%E5%8D%8F%E8%AE%AE/

```
def decode_hid_data(hex_string):
    # 将十六进制字符串转换为字节串
    bytes_data = bytes.fromhex(hex_string)
    
    # 解析数据包
    report_id = bytes_data[0]
    left_stick_x = bytes_data[1]
    left_stick_y = bytes_data[2]
    right_stick_x = bytes_data[3]
    right_stick_y = bytes_data[4]
    l2_trigger = bytes_data[5]
    r2_trigger = bytes_data[6]
    vendor_defined = bytes_data[7]
   # 解析 Hat switch 按键
    hat_switch = bytes_data[8] & 0x0F
    hat_direction = ""
    if hat_switch == 0x0:
        hat_direction = "N"
    elif hat_switch == 0x1:
        hat_direction = "NE"
    elif hat_switch == 0x2:
        hat_direction = "E"
    elif hat_switch == 0x3:
        hat_direction = "SE"
    elif hat_switch == 0x4:
        hat_direction = "S"
    elif hat_switch == 0x5:
        hat_direction = "SW"
    elif hat_switch == 0x6:
        hat_direction = "W"
    elif hat_switch == 0x7:
        hat_direction = "NW"
    elif hat_switch == 0x8:
        hat_direction = "Neutral"
    square_button = (bytes_data[8] >> 4) & 0x01
    cross_button = (bytes_data[8] >> 5) & 0x01
    circle_button = (bytes_data[8] >> 6) & 0x01
    triangle_button = (bytes_data[8] >> 7) & 0x01
    l1_button = bytes_data[9] & 0x01
    r1_button = (bytes_data[9] >> 1) & 0x01
    l2_button = (bytes_data[9] >> 2) & 0x01
    r2_button = (bytes_data[9] >> 3) & 0x01
    create_button = (bytes_data[9] >> 4) & 0x01
    options_button = (bytes_data[9] >> 5) & 0x01
    l3_button = (bytes_data[9] >> 6) & 0x01
    r3_button = (bytes_data[9] >> 7) & 0x01
    ps_button = bytes_data[10] & 0x01
    touchpad_button = (bytes_data[10] >> 1) & 0x01
    mute_button = (bytes_data[10] >> 2) & 0x01

    # 输出按键状态
    print("Square" if square_button else "")
    print("Cross" if cross_button else "")
    print("Circle" if circle_button else "")
    print("Triangle" if triangle_button else "")
    print(hat_direction if hat_direction else "")
    print("L1" if l1_button else "")
    print("R1" if r1_button else "")
    print("L2" if l2_button else "")
    print("R2" if r2_button else "")
    print("Create" if create_button else "")
    print("Options" if options_button else "")
    print("L3" if l3_button else "")
    print("R3" if r3_button else "")
    print("PS" if ps_button else "")
    print("Touchpad" if touchpad_button else "")
    print("Mute" if mute_button else "")

# 示例数据包的十六进制字符串表示
hex_string = "01827d828000003908200100eb8d076f0000ffff000016009a1fe604bc4a0f03ff80000000800000000005040000000000505e0f032918005e95af2cd222910d"

# 解码并输出按键
decode_hid_data(hex_string)
```

按照说明进行拼接

```
SHCTF{L1+E_R2+R2_Square+R2_Cross+L2_R2+L3_R2+PS_Options}
```

### 今日无事,勾栏听曲。

audacity导入原始数据

![image-20241113185216799](C:\Users\scofi\AppData\Roaming\Typora\typora-user-images\image-20241113185216799.png)

高低频隐写

使用audacity导出wav音频，使用脚本

```
import numpy as np
from scipy.io import wavfile
from scipy.fft import fft
sample_rate = 44100  # 采样率
duration_per_bit = 0.01  # 持续时间
low_freq = 440  # 低频表示0
high_freq = 880  # 高频表示1
threshold = 660  # 分界线
input_file = 'music.wav'
rate, data = wavfile.read(input_file)
samples_per_bit = int(sample_rate * duration_per_bit)
bit_sequence = []
for i in range(0, len(data), samples_per_bit):
   bit_data = data[i:i + samples_per_bit]
   spectrum = np.abs(fft(bit_data))[:samples_per_bit // 2]
   freqs = np.fft.fftfreq(len(bit_data), 1 / sample_rate)[:samples_per_bit // 2]
   dominant_freq = freqs[np.argmax(spectrum)]
   if dominant_freq < threshold:
        bit_sequence.append('0')
   else:
        bit_sequence.append('1')
bit_string = ''.join(bit_sequence)
output_txt_file = 'result.txt'
with open(output_txt_file, 'w') as f:
   f.write(bit_string)
```

得到01之后，cyberchef

![image-20241113221730597](C:\Users\scofi\AppData\Roaming\Typora\typora-user-images\image-20241113221730597.png)

得到rar，解压

![image-20241113221847248](C:\Users\scofi\AppData\Roaming\Typora\typora-user-images\image-20241113221847248.png)

看一下压缩包的详细信息发现是2.9老版本的winrar进行压缩的，5.0及以上版本rar格式压缩算法就不一样了

RAR 由可变长的块组成，这些块的没有固定的先后顺序，但要求第一个块必须是标志块并且其后紧跟一个归档头部块。每个块均以以下字段开头

| 字段名称   | 长度(byte) | 说明                  |
| :--------- | :--------: | :-------------------- |
| HEAD_CRC   |     2      | 所有块或块部分的CRC   |
| HEAD_TYPE  |     1      | 块类型                |
| HEAD_FLAGS |     2      | 块标记                |
| HEAD_SIZE  |     2      | 块大小                |
| ADD_SIZE   |     4      | 可选结构 - 增加块大小 |

HEAD_TYPE 不同的值有对应的块类型

- `HEAD_TYPE = 0x72` - MARK_HEAD(标记块)
- `HEAD_TYPE = 0x73` - MAIN_HEAD(压缩文件头)
- `HEAD_TYPE = 0x74` - FILE_HEAD(文件头)
- `HEAD_TYPE = 0x75` - COMM_HEAD(旧风格的注释头)
- `HEAD_TYPE = 0x76` - AV_HEAD(旧风格的授权信息块/用户身份信息块)
- `HEAD_TYPE = 0x77` - SUB_HEAD(旧风格的子块)
- `HEAD_TYPE = 0x78` - PROTECT_HEAD(旧风格的恢复记录)
- `HEAD_TYPE = 0x79` - SIGN_HEAD(旧风格的授权信息块/用户身份信息块)
- `HEAD_TYPE = 0x7A` - NEWSUB_HEAD(子块)
- `HEAD_TYPE = 0x7B` - ENDARC_HEAD(结束块)

winhex查看rar：

![image-20241113222843060](C:\Users\scofi\AppData\Roaming\Typora\typora-user-images\image-20241113222843060.png)

有`draw.txt`，往前看，HEAD_TYPE的字节是`7A`，将其改成`74`

正常解压，得到draw.txt

放到vscode中查看，发现又图形

![image-20241113223030533](C:\Users\scofi\AppData\Roaming\Typora\typora-user-images\image-20241113223030533.png)

缩放一下，是一座塔楼

![image-20241113223458564](C:\Users\scofi\AppData\Roaming\Typora\typora-user-images\image-20241113223458564.png)

为了方便画图，我们将其设定为0是空格，`|`是1，`-`是2，`/`是3，`\`是4

参考官方wp脚本

```
from PIL import Image, ImageDraw, ImageFont

# 设定对应关系
char_map = {
    '0': ' ',
    '1': '|',
    '2': '-',
    '3': '/',
    '4': '\\',
}

# 读取txt文件
with open('draw.txt', 'r') as f:
    lines = f.readlines()

# 替换数字为字符
lines = [[char_map[ch] for ch in line.strip()] for line in lines]

font_size = 10
width = len(lines[0]) * font_size
height = len(lines) * font_size

image = Image.new('RGB', (width, height), color='white')
draw = ImageDraw.Draw(image)

font = ImageFont.load_default()

for y, line in enumerate(lines):
    for x, ch in enumerate(line):
        draw.text((x * font_size, y * font_size), ch, font=font, fill='black')

# 保存图片
output_image = 'draw.png'
image.save(output_image)
```

搜一下7层高塔，对比发现是大雁塔

SHCTF{MD5(大雁塔)}即：

SHCTF{21506a1b677c7254879d86bbec5b4ec9}

### 音频里怎么有一幅画？

在deep文件属性中找到密码MARETU

![image-20241113112236071](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20241113112236071.png?imageSlim)

使用 `deepsound` 解密 `deep.wav`，得到 `key.rar` ，使用 `010 Editor` 打开。

![image-20241113112618711](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20241113112618711.png?imageSlim)

删除 `RAR!` 字符，并将 `KP` 改为 `PK`，然后运行 ZIP 模板。

![image-20241113112804909](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20241113112804909.png?imageSlim)

压缩软件以及中心目录区的压缩文件名显示为 `key.wav`，但数据存储区显示为 `key`，`.wav` 被归到数据区内，这表明文件头的内容被修改了。

需要调整数据区的 `.wav` 使其回到正确的文件名位置。模板的运行结果没有报错，说明参数设置没有矛盾。

![image-20241113113440158](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20241113113440158.png?imageSlim)

根据文件头信息，能发现文件名长度 `frFileNameLength` 的值被设置为 3，直接将其修改为 7。但只修改文件名长度会导致模板运行错误，并且运行结果也没有中心目录区，说明数据区内容识别错误。

需要同时调整 `frCompressedSize` 和 `frFileNameLength` 为 `2236116` 和 `7`，然后重新运行 ZIP 模板。

![image-20241113113722503](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20241113113722503.png?imageSlim)

运行模板没有报错，但还是不能解压。

![image-20241113140924295](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20241113140924295.png?imageSlim)

`010 Editor` 拉到最下面也可以看到有注释内容。但通过bandzip注释又看不到内容。

通过 zwsp-steg 解密零宽字符。

[Offdev.net - Zero-width space steganography javascript demo](https://offdev.net/demos/zwsp-steg-js?)

![image-20241113141031491](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20241113141031491.png?imageSlim)

推测该zip为真加密，密码为`Z3r0-W1D7H`

将数据区和目录区的加密标志位都改为 `09`。

![image-20241113141328023](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20241113141328023.png?imageSlim)

![image-20241113141313551](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20241113141313551.png?imageSlim)

解压得到`key.wav` 文件

查看频谱图

![image-20241113142038457](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20241113142038457.png?imageSlim)

识别Aztec Code

![image-20241113165853677](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20241113165853677.png?imageSlim)

将其分离立体声到单声道，并对上面的声道做反相处理

![image-20241113164130671](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20241113164130671.png?imageSlim)

随后对两个声道进行混音

![image-20241113164218394](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20241113164218394.png?imageSlim)

得到完整的汉信码

![image-20241113165015728](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20241113165015728.png?imageSlim)

扫描汉信码

[在线汉信码识别,汉信码解码 - 兔子二维码](https://tuzim.net/hxdecode/)

![image-20241113165213436](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20241113165213436.png?imageSlim)

[AI 生成可扫码图像 — 新 ControlNet 模型展示](https://mp.weixin.qq.com/s/i4WR5ULH1ZZYl8Watf3EPw)

分析flag.wav频谱图

![image-20241113170136174](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20241113170136174.png?imageSlim)

发现 `flag.wav` 的图片明显被污染，猜测污染源就是这两个码。根据 `Aztec Code` 的时间 `00:11:67`，推测两个二维码音频的起点是 `00:11:67`。

将汉信码和 `flag.wav` 的另一个声道反相，然后混音，得到最终的图片。

(偷一下官方wp的图)

![image-20241113173832589](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20241113173832589.png?imageSlim)

暴力识别

![image-20241113174031437](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20241113174031437.png?imageSlim)

```
SHCTF{AI_4rt_1s_M4gica1}
```


