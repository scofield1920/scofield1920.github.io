# pngCRC


基础：用010editor打开该png分析其字节信息

![2124073-20200816232241348-1931386985](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/2124073-20200816232241348-1931386985.png)

前八个字节**89 50 4E 47 0D 0A 1A 0A**为png的文件头，**该段格式是固定的**

#### chunk[0]段：

**◎从文件头往后**，四个字节**00 00 00 0D**（即为十进制的13）代表数据块的长度为13，数据块包含了png图片的宽高等信息，**该段格式是固定的**

**◎之后的四个字节****49 48 44 52**（即为ASCII码的IHDR）是文件头数据块的标示，**该段格式也是固定的**

**◎之后进入13位数据块**，前8个字节**00 00 05 A0 00 00 03 84**中：

- 前四个字节**00 00 05 A0**（即为十进制的1366），代表该图片的宽，**该段数据是由图片的实际宽决定的**
- 后四个字节**00 00 03 84**（即为十进制的900），代表该图片的高，**该段数据是由图片的实际高度决定的**

这8个字节都属于13位数据块的内容，因此数据块应再向后数5个字节，即为**00 00 05 A0 00 00 03 84 08 02 00 00 00**

剩余的4位**D8 2F 01 85**为该png的CRC检验码，**该段数据是由IDCH以及十三位数据块（即上文中的49 48 44 52 00 00 05 A0 00 00 03 84 08 02 00 00 00）计算得到的**

![2173837203](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/2173837203.png)

绿色部分是IHDR数据, 里面的`00 00 01 f4`是宽, `00 00 01 af`是高，红色部分是CRC32, 是根据绿色部分算出来的



有了之上的基础知识，再来看大部分png中CRC检验错误的出题思路：

**对一张正常的图片，通过修改其宽度或者高度隐藏信息，使计算出的CRC校验码与原图的CRC校验码不一致；windows的图片查看器会忽略错误的CRC校验码，因此会显示图片，但此时的图片已经是修改过的，所以会有显示不全或扭曲等情况，借此可以隐藏信息。**

**而Linux下的图片查看器不会忽略错误的CRC校验码，因此用Linux打开修改过宽或高的png图片时，会出现打不开的情况**



网上的CRC修正python脚本：

```
import binascii
import struct
import sys

file = input("图片地址：")
fr = open(file,'rb').read()
data = bytearray(fr[0x0c:0x1d])
crc32key = eval('0x'+str(binascii.b2a_hex(fr[0x1d:0x21]))[2:-1])
#原来的代码: crc32key = eval(str(fr[29:33]).replace('\\x','').replace("b'",'0x').replace("'",''))
n = 4095
for w in range(n):
    width = bytearray(struct.pack('>i', w))
    for h in range(n):
        height = bytearray(struct.pack('>i', h))
        for x in range(4):
            data[x+4] = width[x]
            data[x+8] = height[x]
        crc32result = binascii.crc32(data) & 0xffffffff
        if crc32result == crc32key:
            print(width,height)
            newpic = bytearray(fr)
            for x in range(4):
                newpic[x+16] = width[x]
                newpic[x+20] = height[x]
            fw = open(file+'.png','wb')
            fw.write(newpic)
            fw.close
            sys.exit()
```

为方便起见，.py文件最好和png文件处在同一文件夹
