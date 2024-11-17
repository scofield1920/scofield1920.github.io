# 2024 YLCTF_misc


省赛前夕把2024ylctf不太离谱的misc复现一下

<!--more-->

## [Round 1]

###  乌龟子啦

base64转图片

![image-20241026181533950](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20241026181533950.png?imageSlim)

得到全是01的图片，ocr识别出来

二进制转图片，得到二维码，扫码得到flag

### hide_png

编写脚本提取像素点，或者用ps提取

官方wp给出的脚本

```python
from PIL import Image
f = Image.open('./attachments.png')
img = Image.new("RGB", (652,79))

for i in range(650):
    for j in range(79):
        t = f.getpixel(((i+5)*3,(j+4)*16))
        img.putpixel((i,j),(t))
img.show()
img.save('output.png')
```

### plain_crack

明文攻击

![image-20241026185339572](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20241026185339572.png?imageSlim)

### pngorzip

lsb隐写，提取出zip压缩文件	

![image-20241026185758886](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20241026185758886.png?imageSlim)

ARCHPR掩码爆破

![image-20241026200059750](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20241026200059750.png?imageSlim)

得到密码114514giao，解压得到flag

### whatmusic

发现文件尾有png倒置字样

byte翻转

脚本参考哦官方wp

```python
def reverse_byte_data(image_path, output_path):
    # 读取图片的二进制数据
    with open(image_path, 'rb') as file:
        byte_data = file.read()

    # 翻转二进制数据流
    reversed_byte_data = bytearray(reversed(byte_data))

    # 将翻转后的二进制数据流写入新的文件
    with open(output_path, 'wb') as file:
        file.write(reversed_byte_data)

if __name__ == "__main__":
    import sys
    if len(sys.argv) != 3:
        print("Usage: python reverse_byte_data.py <input_image_path> <output_image_path>")
        sys.exit(1)

    input_image_path = sys.argv[1]
    output_image_path = sys.argv[2]

    reverse_byte_data(input_image_path, output_image_path)
    print(f"Image byte data reversed and saved to {output_image_path}")
```

得到一个长条png图片，png宽高修复得到

![image-20241026201421064](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20241026201421064.png?imageSlim)

根据hint1可知为lyra项目

https://github.com/google/lyra

![image-20241026203813161](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20241026203813161.png?imageSlim)

进行解密

```
bazel-bin/lyra/cli_example/decoder_main --encoded_path=$HOME/temp/flag.lyra --output_dir=$HOME/temp/
```

得到一段音频后，可以使用语音识别得到flag

[Round 1] trafficdet

[Round 1] SinCosTan

## [Round 2] 

### 滴答滴

查看十六进制发现全部都是 00 和 FF，猜测为电平信号

题目描述给了  man~ ，猜测曼切斯特编码

脚本参考官方wp脚本

```
def read_from_file(filename):
    # 从文件中读取二进制数据
    with open(filename, 'rb') as file:
        return file.read()

def manchester_to_binary(manchester_data):
    # 将曼切斯特编码的数据转换回二进制字符串
    binary_str = ''
    i = 0
    while i < len(manchester_data):
        if manchester_data[i] == 0 and manchester_data[i+1] ==255:
            binary_str += '0'
        elif manchester_data[i] == 255 and manchester_data[i+1] == 0:
            binary_str += '1'
        i += 2  # 每次处理两个字节
    return binary_str

def binary_to_char(binary_str):
    # 将二进制字符串转换回ASCII字符
    return ''.join([chr(int(binary_str[i:i+8], 2)) for i in range(0, len(binary_str), 8)])

# 示例使用
filename = "attachment"  # 输入文件名
manchester_data = read_from_file(filename)
binary_str = manchester_to_binary(manchester_data)
print(binary_str)
ascii_str = binary_to_char(binary_str)

print(f"解码后的ASCII字符串: {ascii_str}")
```

![image-20241026211743865](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20241026211743865.png?imageSlim)

### 听~

deepsound发现隐藏文件

![image-20241026212217261](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20241026212217261.png?imageSlim)

通过ARCHPR爆破得到密码为10117

加压后得到png图片，使用StegSolve查看各通道是否隐藏数据

![image-20241026212715513](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20241026212715513.png?imageSlim)

提取对应通道数据

![image-20241026212836260](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20241026212836260.png?imageSlim)

### Trace

010editor 打开附件，对文件尾部base64编码进行解码

得到rar文件

john+hashcat进行掩码爆破

```
┌──(kali㉿kali)-[~/Desktop]
└─$ rar2john download.rar 
Created directory: /home/kali/.john
download.rar:$rar5$16$cf7eaa5f77d931abb9d85c59e8743331$15$cc4fd7b00922373ef35e56129d016a9e$8$bb8c122375a4ed23
                                                                             
┌──(kali㉿kali)-[~/Desktop]
└─$ hashcat -m 13000 -a3 '$rar5$16$cf7eaa5f77d931abb9d85c59e8743331$15$cc4fd7b00922373ef35e56129d016a9e$8$bb8c122375a4ed23' ?d?d?d?d?d?d --show
```

得到密码为370950

解压后得到

![image-20241026215804403](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20241026215804403.png?imageSlim)

猫脸变换得到修复后的图片

脚本参考官方wp

```python
def arnold_encode(image, shuffle_times=10, a=1, b=1, mode='1'):

    image = np.array(image)
    arnold_image = np.zeros(shape=image.shape, dtype=image.dtype)
    h, w = image.shape[0], image.shape[1]
    N = h
    for _ in range(shuffle_times):
        for ori_x in range(h):
            for ori_y in range(w):
                new_x = (1*ori_x + b*ori_y)% N
                new_y = (a*ori_x + (a*b+1)*ori_y) % N
                if mode == '1':
                    arnold_image[new_x, new_y] = image[ori_x, ori_y]
                else:
                    arnold_image[new_x, new_y, :] = image[ori_x, ori_y, :]
    return Image.fromarray(arnold_image)

import numpy as np
from PIL import Image

def arnold_decode(image, shuffle_times=10, a=1, b=1, mode='1'):
    image = np.array(image)
    decode_image = np.zeros(shape=image.shape, dtype=image.dtype)
    h, w = image.shape[0], image.shape[1]
    N = h
    for _ in range(shuffle_times):
        for ori_x in range(h):
            for ori_y in range(w):
                new_x = ((a*b+1)*ori_x + (-b)* ori_y)% N
                new_y = ((-a)*ori_x + ori_y) % N
                if mode == '1':
                    decode_image[new_x, new_y] = image[ori_x, ori_y]
                else:
                    decode_image[new_x, new_y, :] = image[ori_x, ori_y, :]
    return Image.fromarray(decode_image)

img = Image.open('input.png')
decode_img = arnold_decode(img)
decode_img.save('flag-output.png')
```

![image-20241026215753952](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20241026215753952.png?imageSlim)

## [Round 3]

### Blackdoor

d盾查杀

![image-20241026213929921](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20241026213929921.png?imageSlim)

![image-20241026213911829](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20241026213911829.png?imageSlim)

### CheckImg

stegsolve发现red plane 0 有隐写

![image-20241026220725653](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20241026220725653.png?imageSlim)

Green plane 0给了提示

![image-20241026220738051](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20241026220738051.png?imageSlim)

把 Red plane 0 通道的数据给提取出来

![image-20241026220754736](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20241026220754736.png?imageSlim)

发现是两位两位逆转，写个脚本反转一下

```
def reverse_string(s):
    s = list(s)
    for i in range(0, len(s), 4):
        s[i:i+4] = s[i:i+4][::-1]
    return ''.join(s)

f = open('data.txt', 'rb')
data = f.read().decode('utf-8')
print(reverse_string(data))
```

贴到010恢复成png，得到另一张图片

![image-20241026220905278](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20241026220905278.png?imageSlim)

zsteg一把梭，发现对IDAT块进行了隐写

![image-20241026221043168](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20241026221043168.png?imageSlim)

对dna解码

```python
import sys

bin_dna = {'00':'A','10':'C','01':'G','11':'T'}
mapping = {
        'AAA':'a','AAC':'b','AAG':'c','AAT':'d','ACA':'e','ACC':'f', 'ACG':'g','ACT':'h','AGA':'i','AGC':'j','AGG':'k','AGT':'l','ATA':'m','ATC':'n','ATG':'o','ATT':'p','CAA':'q','CAC':'r','CAG':'s','CAT':'t','CCA':'u','CCC':'v','CCG':'w','CCT':'x','CGA':'y','CGC':'z','CGG':'A','CGT':'B','CTA':'C','CTC':'D','CTG':'E','CTT':'F','GAA':'G','GAC':'H','GAG':'I','GAT':'J','GCA':'K','GCC':'L','GCG':'M','GCT':'N','GGA':'O','GGC':'P','GGG':'Q','GGT':'R','GTA':'S','GTC':'T','GTG':'U','GTT':'V','TAA':'W','TAC':'X','TAG':'Y','TAT':'Z','TCA':'1','TCC':'2','TCG':'3','TCT':'4','TGA':'5','TGC':'6','TGG':'7','TGT':'8','TTA':'9','TTC':'0','TTG':' ','TTT':'.'}

def bin_2_code(string):
    string = string.replace(" ","")
    string = string.replace("\n","")
    final=""
    for j in range(0,len(string),2):
        final+=bin_dna[string[j:j+2]]
    return final

def decode_dna(string):
    final=""
    for i in range(0,len(string),3):
        final+=mapping[string[i:i+3]]
    return final

print(decode_dna("GCAGTTCTGCTGGGGGGTGTACTAGAGTGACTCGTTGCAGTTGTATACGCATATCTGGTGGGGGTATCCCTTGATCGTGCACTGTCCTAAGCAGCAGAAGAGTCCCTGGCAGCTCTATAAGATCTTCTAGTGGGGGCTGTAGCAGAGGTTCGGGTTGAGGCTCGTGTCGCAGTTGCACTGTCCGTCTATGTGGCAGTTGACGTGTAAGGTTATTAAGAAGGTGAGGTTGTAGTTGTAGCTGATTATGATCTTGAGGGGGCAGCTGAGTATGCCCTCGAGGCTGCAGACGATGGGTCCCTTGTAGGGGCATAAGATGTTCGTGTGGTAGTCGTAGAGGCACTTGCCGTTGCGGTAGCACTTGCAGCTCTTCTGGAAGTTTATGTTGCAGTTGAACTGGCGGTAGATTAAGATGCGTATCTCGCGGTTGTAGTCGATGCTCTCGTGGGGGGGGTAGAAGAGTGAGCACTGTAGGCTTCCGCCGCATAGTCCCTCCTGGTCGCATAAGCATGACTGCTGGGGGTCGTACTAGAAGATCTCCTTGCGGTGTCCGAGGATCGGTCGCTGCTAGTCGCAGTTGCAGTTGCTCTGTAAGTGTCCCTAGAGCTTGAAGTGTAGGTTGCACGTGAGGGTGATCTGGCGGGTGTAGGTGAGGCTGCACTGTCCGTCGCAGAAGCACGGTATGTGTGCGCGTCCGTGGATGTTCGGGTTCGGGTGGTAGCCGCACTTCTCCTTGCGGGTGCAGAAGATCTTGCGCTCGAGGTCGGTTGA"))
```

得到

```
KVEEQRSCI5DVKVSXKZEUQS2FJBKE2WKKGI2EKNCWJFCUQNSKIVAVINBTKVKE2TZUKVHUWRZWGRIVSVSNJZJFIQKNIZLDINKHJQ2FSQKWJVBUSTSIKFLVMSKFKNFEGVZVKVGEMSJWJMZDMVSTJNDUQQSGI5KEYN2LKY2DETKWK5EEQTSCGJDFMU2IJA3ECTKVKVNEWU2CIFGUYVKBIRJEMRSRINKE2TKGKAZU6M2UJVAVAUSLKFDFMRKGJFMDITR5
```

cyberchef进行解码得到flag
