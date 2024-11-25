# 2024 蜀道山高校公益联赛_misc


2024 蜀道山高校公益联赛_misc

<!--more-->

### 欢迎来到2024蜀道山CTF

扫码关注回复`劳资蜀道山2024`

### 神奇的硬币纺纱机

一直输入 0 或 1 使结果达到 100 即可

![image-20241125121006287](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20241125121006287.png?imageSlim)

### Elemental Wars

```
>nc64.exe gz.imxbt.cn 20742

  _____ _                           _        _  __        __
 | ____| | ___ _ __ ___   ___ _ __ | |_ __ _| | \ \      / /_ _ _ __ ___
 |  _| | |/ _ \ '_ ` _ \ / _ \ '_ \| __/ _` | |  \ \ /\ / / _` | '__/ __|
 | |___| |  __/ | | | | |  __/ | | | || (_| | |   \ V  V / (_| | |  \__ \
 |_____|_|\___|_| |_| |_|\___|_| |_|\__\__,_|_|    \_/\_/ \__,_|_|  |___/


欢迎来到元素战争！
游戏即将开始...

请选择你的元素（1. 金, 2. 木, 3. 水, 4. 火, 5. 土）：2
你的选择是: 木
敌人的选择是：火
木生火，玩家恢复生命！
你的血量：11，敌人的血量：9
请选择你的元素（1. 金, 2. 木, 3. 水, 4. 火, 5. 土）：
```

写一个脚本来完成自动攻击

```python
import socket
import time
import random

HOST = 'gz.imxbt.cn'
PORT = 20748

def choose_num():
    return f"{random.randint(1,5)}\n"

def main():
    with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as s:
        s.connect((HOST, PORT))
        print("已连接到服务器")

        while True:
            response = s.recv(1024).decode('utf-8')
            print(f"服务器：{response}")



            if "请选择你的元素" in response:
                choose = choose_num()
                print(f"发送随机选择：{choose.strip()}")
                s.sendall(choose.encode('utf-8'))

            for line in response.splitlines():
                if "敌人的血量：" in line:
                    enemy_blood = int(line.split("敌人的血量：")[1])
  
                    # print(f"enemy_blood：{enemy_blood}")
                    if enemy_blood < 1:
                        print("敌人血量小于1,战斗结束")
                        break
            time.sleep(0.1)
if __name__ == "__main__":
    main()
```

最终得到

```
发送随机选择：2
服务器：
你的选择是: 木
敌人的选择是：土
木克土，玩家获胜！
你的血量：23，敌人的血量：0
你获得了胜利！敌人已被击败！
欢迎拿到flag:LZSDS{a485c47f-0b8e-4cce-8e16-d27cf0c8104e}
```

### javaPcap

追踪http流量得到几个GET请求，发现有密文、key和加密方式，但不知道偏移等参数

![image-20241125105146449](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20241125105146449.png?imageSlim)

附件中也给到了jar文件，对其进行反编译

https://www.shenmeapp.com/

![image-20241125105303079](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20241125105303079.png?imageSlim)

在CustomEncryptor.class发现了各种加密方式的参数

```java
package server;

import java.nio.charset.StandardCharsets;
import java.security.Security;
import java.util.Base64;
import javax.crypto.Cipher;
import javax.crypto.spec.SecretKeySpec;
import org.bouncycastle.jce.provider.BouncyCastleProvider;
/* loaded from: CustomEncryptor.class */
public class CustomEncryptor {
    static {
        Security.addProvider(new BouncyCastleProvider());
    }

    public static String encryptSM4(String key, String content) {
        try {
            byte[] keyBytes = generateKeyBytes(key, 16);
            SecretKeySpec secretKey = new SecretKeySpec(keyBytes, "SM4");
            Cipher cipher = Cipher.getInstance("SM4/ECB/PKCS5Padding", "BC");
            cipher.init(1, secretKey);
            byte[] encryptedBytes = cipher.doFinal(content.getBytes(StandardCharsets.UTF_8));
            return Base64.getEncoder().encodeToString(encryptedBytes);
        } catch (Exception e) {
            throw new RuntimeException("Encryption error: " + e.getMessage(), e);
        }
    }

    private static byte[] generateKeyBytes(String key, int length) {
        byte[] keyBytes = new byte[length];
        byte[] inputKeyBytes = key.getBytes(StandardCharsets.UTF_8);
        System.arraycopy(inputKeyBytes, 0, keyBytes, 0, Math.min(inputKeyBytes.length, length));
        return keyBytes;
    }

    public static String encryptAES(String key, String content) {
        return encrypt(content, key, "AES", 16);
    }

    public static String encryptBlowfish(String key, String content) {
        return encrypt(content, key, "Blowfish", 16);
    }

    private static String encrypt(String content, String key, String algorithm, int keySize) {
        try {
            byte[] keyBytes = new byte[keySize];
            byte[] inputKeyBytes = key.getBytes(StandardCharsets.UTF_8);
            System.arraycopy(inputKeyBytes, 0, keyBytes, 0, Math.min(inputKeyBytes.length, keySize));
            SecretKeySpec secretKey = new SecretKeySpec(keyBytes, algorithm);
            Cipher cipher = Cipher.getInstance(algorithm + "/ECB/PKCS5Padding");
            cipher.init(1, secretKey);
            byte[] encryptedBytes = cipher.doFinal(content.getBytes(StandardCharsets.UTF_8));
            return Base64.getEncoder().encodeToString(encryptedBytes);
        } catch (Exception e) {
            throw new RuntimeException("Encryption error: " + e.getMessage(), e);
        }
    }
}
```

可知aes加密key取前16位，ECB模式，PKCS5Padding填充方式

https://www.ssleye.com/ssltool/aes_cipher.html

SM4加密key取前16位，ECB模式，PKCS5Padding填充方式

https://tool.hiofd.com/sm4-decrypt-online/#google_vignette

Blowfish加密key取前16位，ECB模式，PKCS5Padding填充方式

[cyberchef-blowfish](https://cyberchef.cn/#recipe=From_Base64('A-Za-z0-9%2B/%3D',true,false)Blowfish_Decrypt(%7B'option':'UTF8','string':'62484d675a6d7868'%7D,%7B'option':'Hex','string':'0000000000000000'%7D,'ECB','Raw','Raw')&input=RVdVOWpZTUVTNWVZbTN2dmRPa1hEcGxiZ0tDTDhzSkY)

分别对密文进行解密



请求

直接base64解码

```
whoami

ls -alt

ls flag/

base64 flag/flag.zip

cat flag/hint.txt
```

响应

```
root

total 5492
drwx------ 18 root root    4096 Nov  6 15:26 ..
drwxr-xr-x  3 root root    4096 Nov  4 17:22 .
drwxr-xr-x  2 root root    4096 Nov  4 17:22 flag
-rw-r--r--  1 root root 5610013 Nov  4 16:28 SimpleHttpServer.jar

flag.zip
hint.txt

UEsDBBQACQAIABSGZFkAAAAAAAAAACsAAAAIACkAZmxhZy50eHRVVAkABWiKKGeQGitndXgLAAEE
AAAAAAQAAAAAeGwJAAcUAwAAAADtgXBFs0Lb8F43+KxCxq77A+Zya0CyhPRERubzgNwf5fF5GVjt
ntPQZe8hy0s4qLAhBXW42FAs5Xhw4lBLBwiHHE6JOQAAACsAAABQSwECFAMUAAkACAAUhmRZhxxO
iTkAAAArAAAACAAcAAAAAAAAAAAA7YEAAAAAZmxhZy50eHRVVAkABWiKKGeQGitndXgLAAEEAAAA
AAQAAAAAUEsFBgAAAAABAAEAUgAAAJgAAAAAAA==

密码为执行命令（按照时间排序）的首字母的组合重复三次，比如执行了（id,whoami），那么密码就为iwiwiw
```

导出zip文件

![image-20241125112124474](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20241125112124474.png?imageSlim)

解压密码`wllbcwllbcwllbc`

![image-20241125115955283](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20241125115955283.png?imageSlim)

### Summit Potato

分析png，发现文件内部嵌有zip文件，进行binwalk，得到zip修改后缀为elsx

得到：

![image-20241125140741629](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20241125140741629.png?imageSlim)

=BITXOR(CODE(I10),100)

> 在Excel中，`BITXOR`函数用于计算两个数的按位异或（XOR）结果。`CODE`函数则用于返回给定字符的ASCII码。
>
> 假设`I10`单元格中包含一个字符，那么`CODE(I10)`将返回该字符的ASCII码。然后，`BITXOR(CODE(I10), 100)`将计算这个ASCII码与100的按位异或结果。

最终得到Loenn

搜索发现一个项目

![image-20241125141002820](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20241125141002820.png?imageSlim)

用他打开bin，得到密文

![image-20241125141805598](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20241125141805598.png?imageSlim)

kW]Y1:jRZ\B[

将elsx文件后缀改为zip，然后解压，在media中得到：

![Zenith](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/Zenith.png?imageSlim)

得到解压密码：1230ER074563

![image-20241125142114072](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20241125142114072.png?imageSlim)
