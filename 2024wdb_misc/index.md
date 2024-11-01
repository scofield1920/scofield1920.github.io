# 2024网鼎杯网络安全大赛青龙组Misc


2024网鼎杯网络安全大赛青龙组Misc

<!--more-->

### Misc01

附件为`MME.cap`流量包

流量包中的协议主要有：`DIAMETER`、`S1AP/NAS-EPS`、`GTPv2`、`S1AP`

问GPT哪几个协议可能会泄露用户的位置信息，得知为GTPv2和DIAMETER

最终在`DIAMETER`协议中发现关键信息`MME-Location-Information`

![image-20241101003818235](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20241101003818235.png?imageSlim)

最后把该字段的值md5加密后为flag

wdflag{f9243fa9f18aec525ccb1ea3bd5dd190}

### Misc02

使用RStudio回复了许多txt文件，但并没扫到有效信息

用foremost对flag进行提取，发现两张可疑的png图片

![image-20241101145643886](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20241101145643886.png?imageSlim)

用zsteg对第一张图片进行扫描，得到了疑似hint信息

![image-20241101145727777](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20241101145727777.png?imageSlim)

同时再镜像尾部发现7z文件`37 7A BC AF 27 1C`

![image-20241101150514302](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20241101150514302.png?imageSlim)

有密码，根据前面得到的hint信息进行掩码爆破

![image-20241101150602155](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20241101150602155.png?imageSlim)

![image-20241101154309298](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20241101154309298.png?imageSlim)

解压得到flag.txt

```
 31         226 PUSH_NULL
            228 LOAD_NAME                8 (key_encode)
            230 LOAD_NAME                7 (key)
            232 PRECALL                  1
            236 CALL                     1
            246 STORE_NAME               7 (key)

 32         248 PUSH_NULL
            250 LOAD_NAME               10 (len)
            252 LOAD_NAME                7 (key)
            254 PRECALL                  1
            258 CALL                     1
            268 LOAD_CONST               7 (16)
            270 COMPARE_OP               2 (==)
            276 POP_JUMP_FORWARD_IF_FALSE    43 (to 364)

 33         278 PUSH_NULL
            280 LOAD_NAME                9 (sm4_encode)
            282 LOAD_NAME                7 (key)
            284 LOAD_NAME                5 (flag)
            286 PRECALL                  2
            290 CALL                     2
            300 LOAD_METHOD             11 (hex)
            322 PRECALL                  0
            326 CALL                     0
            336 STORE_NAME              12 (encrypted_data)

 34         338 PUSH_NULL
            340 LOAD_NAME                6 (print)
            342 LOAD_NAME               12 (encrypted_data)
            344 PRECALL                  1
            348 CALL                     1
            358 POP_TOP
            360 LOAD_CONST               2 (None)
            362 RETURN_VALUE

 32     >>  364 LOAD_CONST               2 (None)
            366 RETURN_VALUE

Disassembly of <code object key_encode at 0x14e048a00, file "make.py", line 10>:
 10           0 RESUME                   0

 11           2 LOAD_GLOBAL              1 (NULL + list)
             14 LOAD_FAST                0 (key)
             16 PRECALL                  1
             20 CALL                     1
             30 STORE_FAST               1 (magic_key)

 12          32 LOAD_GLOBAL              3 (NULL + range)
             44 LOAD_CONST               1 (1)
             46 LOAD_GLOBAL              5 (NULL + len)
             58 LOAD_FAST                1 (magic_key)
             60 PRECALL                  1
             64 CALL                     1
             74 PRECALL                  2
             78 CALL                     2
             88 GET_ITER
        >>   90 FOR_ITER               105 (to 302)
             92 STORE_FAST               2 (i)

 13          94 LOAD_GLOBAL              7 (NULL + str)
            106 LOAD_GLOBAL              9 (NULL + hex)
            118 LOAD_GLOBAL             11 (NULL + int)
            130 LOAD_CONST               2 ('0x')
            132 LOAD_FAST                1 (magic_key)
            134 LOAD_FAST                2 (i)
            136 BINARY_SUBSCR
            146 BINARY_OP                0 (+)
            150 LOAD_CONST               3 (16)
            152 PRECALL                  2
            156 CALL                     2
            166 LOAD_GLOBAL             11 (NULL + int)
            178 LOAD_CONST               2 ('0x')
            180 LOAD_FAST                1 (magic_key)
            182 LOAD_FAST                2 (i)
            184 LOAD_CONST               1 (1)
            186 BINARY_OP               10 (-)
            190 BINARY_SUBSCR
            200 BINARY_OP                0 (+)
            204 LOAD_CONST               3 (16)
            206 PRECALL                  2
            210 CALL                     2
            220 BINARY_OP               12 (^)
            224 PRECALL                  1
            228 CALL                     1
            238 PRECALL                  1
            242 CALL                     1
            252 LOAD_METHOD              6 (replace)
            274 LOAD_CONST               2 ('0x')
            276 LOAD_CONST               4 ('')
            278 PRECALL                  2
            282 CALL                     2
            292 LOAD_FAST                1 (magic_key)
            294 LOAD_FAST                2 (i)
            296 STORE_SUBSCR
            300 JUMP_BACKWARD          106 (to 90)

 15     >>  302 LOAD_GLOBAL              3 (NULL + range)
            314 LOAD_CONST               5 (0)
            316 LOAD_GLOBAL              5 (NULL + len)
            328 LOAD_FAST                0 (key)
            330 PRECALL                  1
            334 CALL                     1
            344 LOAD_CONST               6 (2)
            346 PRECALL                  3
            350 CALL                     3
            360 GET_ITER
        >>  362 FOR_ITER               105 (to 574)
            364 STORE_FAST               2 (i)

 16         366 LOAD_GLOBAL              7 (NULL + str)
            378 LOAD_GLOBAL              9 (NULL + hex)
            390 LOAD_GLOBAL             11 (NULL + int)
            402 LOAD_CONST               2 ('0x')
            404 LOAD_FAST                1 (magic_key)
            406 LOAD_FAST                2 (i)
            408 BINARY_SUBSCR
            418 BINARY_OP                0 (+)
            422 LOAD_CONST               3 (16)
            424 PRECALL                  2
            428 CALL                     2
            438 LOAD_GLOBAL             11 (NULL + int)
            450 LOAD_CONST               2 ('0x')
            452 LOAD_FAST                1 (magic_key)
            454 LOAD_FAST                2 (i)
            456 LOAD_CONST               1 (1)
            458 BINARY_OP                0 (+)
            462 BINARY_SUBSCR
            472 BINARY_OP                0 (+)
            476 LOAD_CONST               3 (16)
            478 PRECALL                  2
            482 CALL                     2
            492 BINARY_OP               12 (^)
            496 PRECALL                  1
            500 CALL                     1
            510 PRECALL                  1
            514 CALL                     1
            524 LOAD_METHOD              6 (replace)
            546 LOAD_CONST               2 ('0x')
            548 LOAD_CONST               4 ('')
            550 PRECALL                  2
            554 CALL                     2
            564 LOAD_FAST                1 (magic_key)
            566 LOAD_FAST                2 (i)
            568 STORE_SUBSCR
            572 JUMP_BACKWARD          106 (to 362)

 18     >>  574 LOAD_CONST               4 ('')
            576 LOAD_METHOD              7 (join)
            598 LOAD_FAST                1 (magic_key)
            600 PRECALL                  1
            604 CALL                     1
            614 STORE_FAST               1 (magic_key)

 19         616 LOAD_GLOBAL             17 (NULL + print)
            628 LOAD_FAST                1 (magic_key)
            630 PRECALL                  1
            634 CALL                     1
            644 POP_TOP

 20         646 LOAD_GLOBAL              7 (NULL + str)
            658 LOAD_GLOBAL              9 (NULL + hex)
            670 LOAD_GLOBAL             11 (NULL + int)
            682 LOAD_CONST               2 ('0x')
            684 LOAD_FAST                1 (magic_key)
            686 BINARY_OP                0 (+)
            690 LOAD_CONST               3 (16)
            692 PRECALL                  2
            696 CALL                     2
            706 LOAD_GLOBAL             11 (NULL + int)
            718 LOAD_CONST               2 ('0x')
            720 LOAD_FAST                0 (key)
            722 BINARY_OP                0 (+)
            726 LOAD_CONST               3 (16)
            728 PRECALL                  2
            732 CALL                     2
            742 BINARY_OP               12 (^)
            746 PRECALL                  1
            750 CALL                     1
            760 PRECALL                  1
            764 CALL                     1
            774 LOAD_METHOD              6 (replace)
            796 LOAD_CONST               2 ('0x')
            798 LOAD_CONST               4 ('')
            800 PRECALL                  2
            804 CALL                     2
            814 STORE_FAST               3 (wdb_key)

 21         816 LOAD_GLOBAL             17 (NULL + print)
            828 LOAD_FAST                3 (wdb_key)
            830 PRECALL                  1
            834 CALL                     1
            844 POP_TOP

 22         846 LOAD_FAST                3 (wdb_key)
            848 RETURN_VALUE

magic_key:7a107ecf29325423
encrypted_data:f2c85bd042247896b43345e589e3ad025fba1770e4ac0d274c1f7c2a670830379195aa5547d78bcee7ae649bc3b914da
```

Python字节码的反汇编

```python
def restore(mk):
    magic_key = [_ for _ in mk]
    for i in range(0, len(mk), 2):
        magic_key[i] = hex(int("0x" + magic_key[i], 16) ^ int("0x" + magic_key[i + 1], 16)).replace("0x", "")
    
    for i in range(len(mk) - 1, 0, -1):
        magic_key[i] = hex(int("0x" + magic_key[i], 16) ^ int("0x" + magic_key[i - 1], 16)).replace("0x", "")

    return "".join(magic_key)

def encode_key(key):
    magic_key = [_ for _ in key]
    for i in range(1, len(key)):
        magic_key[i] = hex(int("0x" + magic_key[i], 16) ^ int("0x" + magic_key[i - 1], 16)).replace("0x", "")

    for i in range(0, len(key), 2):
        magic_key[i] = hex(int("0x" + magic_key[i], 16) ^ int("0x" + magic_key[i + 1], 16)).replace("0x", "")
        
    magic_key = "".join(magic_key)

    wdb_key = hex(int("0x" + magic_key, 16) ^ int("0x" + key, 16)).replace("0x", "")
    return wdb_key

print(encode_key(restore("7a107ecf29325423")))
```

得到密钥`ada1e9136bb16171`

![image-20241101161438168](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20241101161438168.png?imageSlim)

SM4解密得到flag

wdflag{815ad4647b0b181b994eb4b731efa8a0}

### Misc03

![image-20241031235723385](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20241031235723385.png?imageSlim)

直接统计交互IP

![img](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/wps1.jpg?imageSlim)

回查流量

![img](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/wps2.jpg?imageSlim)

蚁剑流量

攻击ip为39.168.5.60

wdflag{ 39.168.5.60}

### Misc04

![image-20241101000334156](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20241101000334156.png?imageSlim)

附件为

![image-20241101000431384](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20241101000431384.png?imageSlim)

希尔伯特-皮亚诺曲线

IrisCTF2024原题

```python
from PIL import Image
from tqdm import tqdm

def peano(n):
    if n == 0:
        return [[0,0]]
    else:
        in_lst = peano(n - 1)
        lst = in_lst.copy()
        px,py = lst[-1]
        lst.extend([px - i[0], py + 1 + i[1]] for i in in_lst)
        px,py = lst[-1]
        lst.extend([px + i[0], py + 1 + i[1]] for i in in_lst)
        px,py = lst[-1]
        lst.extend([px + 1 + i[0], py - i[1]] for i in in_lst)
        px,py = lst[-1]
        lst.extend([px - i[0], py - 1 - i[1]] for i in in_lst)
        px,py = lst[-1]
        lst.extend([px + i[0], py - 1 - i[1]] for i in in_lst)
        px,py = lst[-1]
        lst.extend([px + 1 + i[0], py + i[1]] for i in in_lst)
        px,py = lst[-1]
        lst.extend([px - i[0], py + 1 + i[1]] for i in in_lst)
        px,py = lst[-1]
        lst.extend([px + i[0], py + 1 + i[1]] for i in in_lst)
        return lst

order = peano(6)

img = Image.open(r"C:\Users\ASUSROG\Desktop\chal.png")

width, height = img.size

block_width = width # // 3
block_height = height # // 3

new_image = Image.new("RGB", (width, height))

for i, (x, y) in tqdm(enumerate(order)):
    # 根据列表顺序获取新的坐标
    new_x, new_y = i % width, i // width
    # 获取原图像素
    pixel = img.getpixel((x, height - 1 - y))
    # 在新图像中放置像素
    new_image.putpixel((new_x, new_y), pixel)

new_image.save("rearranged_image.jpg")
```

![image-20241029235437098](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20241029235437098.jpeg?imageSlim)

扫二维码

![image-20241101000612017](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20241101000612017.png?imageSlim)

wdflag{4940e8dc-5542-4eee-9243-202ae675d77f}
