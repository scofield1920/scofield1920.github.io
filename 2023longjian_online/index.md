# 2023第二届陇剑杯初赛


<!--more-->

## hard web

考点：哥斯拉流量分析

### hard_web_1

> 服务器开放了哪些端口，请按照端口大小顺序提交答案，并以英文逗号隔开(如服务器开放了80 81 82 83端口则，答案为80,81,82,83)

180机对188机进行端口扫描的流量

根据tcp三次握手原理，过滤器：

```
ip.dst == 192.168.162.188 and tcp.connection.synack
```

![image-20240317100217722](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20240317100217722.png)

flag{80,888,8888}

### hard_web_2

> 服务器中根目录下的 flag 值是多少？

过滤出访问192.168.162.180的HTTP流，

```
ip.dst == 192.168.162.180 && http
```

追踪HTTP流

![image-20240317103851179](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20240317103851179.png)

分析得到Godzilla连接密码为748007e861908c03，加密方式为AES，

随后

![image-20240317111130109](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20240317111130109.png)

在010里面，将AES加密内容截取出来

![image-20240317111150969](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20240317111150969.png)

赛博厨子解密

![image-20240317111319653](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20240317111319653.png)

flag{9236b29d-5488-41e6-a04b-53b0d8276542}

### hard_web_3

> 该webshell的连接密码是多少?

https://www.somd5.com/

![image-20240317111843730](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20240317111843730.png)

flag{14mk3y}

## sevrer save

考点：溯源取证

### sevrer_save_1

> 黑客是使用什么漏洞来拿下 root 权限的。格式为：CVE-2020-114514

过滤器：http

追踪tcp流，发现payload

![image-20240317113121006](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20240317113121006.png)

搜索payload内容，得到flag{CVE-2022-22965}

### sevrer_save_2

> 黑客反弹 shell 的 ip 和端口是什么，格式为：10.0.0.1:4444

综合流量包来看，攻击机地址为172.17.0.1，受害地址为172.17.0.1，同时发现流108为shell交互过程，

![image-20240317113836838](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20240317113836838.png)

故flag{192.168.43.128:2333}

流106可见弹shell内容

![image-20240317113958424](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20240317113958424.png)

### sevrer_save_3

> 黑客的病毒名称是什么？格式为：filename

![image-20240317115052906](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20240317115052906.png)

将用户目录下的main文件丢入云沙箱，鉴定为病毒

### sevrer_save_4

> 黑客的病毒运行后创建了什么用户？请将回答用户名与密码：username:password

shadow文件

![image-20240317123424246](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20240317123424246.png)

flag{11:123456}

### sevrer_save_5

> 服务器在被入侵时外网 ip 是多少? 格式为：10.10.0.1

![image-20240317124234026](C:\Users\scofi\AppData\Roaming\Typora\typora-user-images\image-20240317124234026.png)

flag{172.105.202.239}

### sevrer_save_6

> 病毒运行后释放了什么文件？格式：文件 1,文件 2

将main放到云沙箱里检测

![image-20240317164847015](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20240317164847015.png)

![image-20240317164423599](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20240317164423599.png)

flag{lolMiner,mine_doge.sh}

### sevrer_save_7

> 矿池地址是什么？格式：domain:1234

![image-20240317165117095](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20240317165117095.png)

flag{doge.millpools.cc:5567}

### sevrer_save_8

> 黑客的钱包地址是多少？格式：xx:xxxxxxxx

同上题图

flag{DOGE:DRXz1q6ys8Ao2KnPbtb7jQhPjDSqtwmNN9.lolMinerWorker}

## ez_web

### ez_web_1

> 服务器自带的后门文件名是什么？（含文件后缀）

过滤器：`http contains "HTTP/1.1 200 OK"`

![image-20240317192455864](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20240317192455864.png)

答案不对

![image-20240317202248695](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20240317202248695.png)

flag{ViewMore.php}

### ez_web_2

> 服务器的内网 IP 是多少？

![image-20240317203227884](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20240317203227884.png)

虽然有好几个内网地址，正确答案是

flag{192.168.101.132}

### ez_web_3

> 攻击者往服务器中写入的 key 是什么？

![image-20240317203738344](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20240317203738344.png)

导出一个zip压缩包

![image-20240317204621654](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20240317204621654.png)

追踪10098的http流

![image-20240317204954347](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20240317204954347.png)

压缩包密码：7e03864b0db7e6f9

![image-20240317205215085](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20240317205215085.png)

flag{7d9ddff2-2d67-4eba-9e48-b91c26c42337}

## baby_forensics

### baby_forensics_1

> 磁盘中的 key 是多少？

用过火眼的内存分析工具.......还是得volatility手搓

先filescan一下，然后把key文件dump下来

```
python vol.py -f baby_forensics.raw windows.filescan.FileScan | findstr key

python vol.py -f baby_forensics.raw windows.dumpfiles.DumpFiles --physaddr 0x3df94070
```

![image-20240317224301413](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20240317224301413.png)

得到文本，然后rot47一下（或者直接丢进随波逐流解码）

![image-20240317224431699](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20240317224431699.png)

thekeyis2e80307085fd2b5c49c968c323ee25d5

flag{2e80307085fd2b5c49c968c323ee25d5}

### baby_forensics_2

> 电脑中正在运行的计算器的运行结果是多少？

获取所有进程信息，并找到clac.exe进程

```
python vol.py -f baby_forensics.raw windows.pslist.PsList >> pslist.txt
```

![image-20240317230324197](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20240317230324197.png)

将内存文件下载下来

```
python vol.py -f /baby_forensics.raw windows.memmap.Memmap --pid 2844 --dump
```

然后后缀名改为.data放进GIMP分析

![image-20240317234040429](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20240317234040429.png)

flag{7598632541}

### baby_forensics_3

> 该内存文件中存在的flag值是多少？

![image-20240319212215972](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20240319212215972.png?imageSlim)

dump出来，用gimp还原图像

![image-20240319214523408](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20240319214523408.png?imageSlim)

U2FsdGVkX195MCsw0ANs6/Vkjibq89YlmnDdY/dCNKRkixvAP6+B5ImXr2VIqBSp94qfIcjQhDxPgr9G4u++pA==

顺便dump并还原了exproler的画面

![image-20240319220555733](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20240319220555733.png?imageSlim)

加密的key应该在这里面

然后去检索

```
python vol.py -f baby_forensics.raw windows.filescan.FileScan | findstr k3y
```

![image-20240319220957150](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20240319220957150.png?imageSlim)

然后将其dump下来

```
python vol.py -f baby_forensics.raw windows.dumpfiles.DumpFiles --physaddr 0x3ef3a310
```

得到密钥qwerasdf

解密得到flag

https://www.sojson.com/encrypt_aes.html

![image-20240319222205119](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20240319222205119.png?imageSlim)

flag{ad9bca48-c7b0-4bd6-b6fb-aef90090bb98}

## Wireshark

> 被入侵主机的 IP 是？

### Wireshark_1

![image-20240319223802973](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20240319223802973.png?imageSlim)

只有两台机器在通信，根据流量走向可判断

flag{192.168.246.28}

### Wireshark_2

> 被入侵主机的口令是？

![image-20240320181143041](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20240320181143041.png?imageSlim)

flag{youcannevergetthis}

### Wireshark_3

> 用户目录下第二个文件夹的名称是？

![image-20240320181820221](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20240320181820221.png?imageSlim)

flag{Downloads}

### Wireshark_4

> /etc/passwd中倒数第二个用户的用户名是？

![image-20240320181955575](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20240320181955575.png?imageSlim)

flag{mysql}

## Incidentresponse

### IncidentResponse_1

> 你是公司的一名安全运营工程师，今日接到外部监管部门通报，你公司网络出口存在请求挖矿域名的行为。需要立即整改。经过与网络组配合，你们定位到了请求挖矿域名的内网 IP 是 10.221.36.21。查询 CMDB 后得知该 IP 运行了公司的工时系统。（虚拟机账号密码为：root/IncidentResponsePasswd）挖矿程序所在路径是？（答案中如有空格均需去除，如有大写均需变为小写，使用 echo -n ‘strings’|md5sum|cut -d ’ ’ -f1 获取 md5 值作为答案）
>

`history`没发现可疑信息，随后`netstat -antpu`，看到redis的不寻常端口

![image-20240320191838401](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20240320191838401.png?imageSlim)

去这里看一下

![image-20240320193703558](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20240320193703558.png?imageSlim)

redis.conf里有挖矿相关信息

![image-20240320193832432](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20240320193832432.png?imageSlim)

```
echo -n '/etc/redis/redis-server'|md5sum|cut -d ' ' -f1
```

得到flag

flag{6f72038a870f05cbf923633066e48881}

### IncidentResponse_2

> 挖矿程序连接的矿池域名是？

题解见上题

flag{donate.v2.xmrig.com}

### IncidentResponse_3

> 攻击者入侵服务器的利用的方法是？（答案中如有空格均需去除，如有大写均需变为小写，使用echo -n 'strings'|md5sum|cut -d ' ' -f1获取md5值作为答案）

根据历史命令，查看一下`/home/app/nohup.log`

![image-20240320200937341](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20240320200937341.png?imageSlim)

shiro反序列化

```
echo -n 'shirodeserialization'|md5sum|cut -d ' ' -f1
```

flag{3ee726cb32f87a15d22fe55fa04c4dcd}

### IncidentResponse_4

> 攻击者的IP是？（答案中如有空格均需去除，如有大写均需变为小写，使用echo -n 'strings'|md5sum|cut -d ' ' -f1获取md5值作为答案）

根据nginx日志

```
cat /var/log/nginx/access.log
```

![image-20240320201511249](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20240320201511249.png?imageSlim)

```
echo -n '81.70.166.3'|md5sum|cut -d ' ' -f1
```

flag{c76b4b1a5e8c9e7751af4684c6a8b2c9}

### IncidentResponse_5

> 攻击者发起攻击时使用的User-Agent是？（答案中如有空格均需去除，如有大写均需变为小写，使用echo -n 'strings'|md5sum|cut -d ' ' -f1获取md5值作为答案）

解法同上题

Mozilla/5.0 (Windows NT 6.3; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/49.0.2623.110 Safari/537.36

```
echo -n 'mozilla/5.0(compatible;baiduspider/2.0;+http://www.baidu.com/search/spider.html)'|md5sum|cut -d ' ' -f1
```

flag{6ba8458f11f4044cce7a621c085bb3c6}

### IncidentResponse_6

> 攻击者使用了两种权限维持手段，相应的配置文件路径是？(md5加密后以a开头)（答案中如有空格均需去除，如有大写均需变为小写，使用echo -n 'strings'|md5sum|cut -d ' ' -f1获取md5值作为答案）

[第4篇：Linux权限维持--后门篇](https://bypass007.github.io/Emergency-Response-Notes/privilege/%E7%AC%AC4%E7%AF%87%EF%BC%9ALinux%E6%9D%83%E9%99%90%E7%BB%B4%E6%8C%81--%E5%90%8E%E9%97%A8%E7%AF%87.html)

应该是保存了authoriazed_keys的免密登录

![image-20240320202308338](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20240320202308338.png?imageSlim)

`/root/.ssh/authorized_keys`

```
echo -n '/root/.ssh/authorized_keys'|md5sum|cut -d ' ' -f1
```

flag{a1fa1b5aeb1f97340032971c342c4258}

### IncidentResponse_7

> 攻击者使用了两种权限维持手段，相应的配置文件路径是？(md5加密后以b开头)（答案中如有空格均需去除，如有大写均需变为小写，使用echo -n 'strings'|md5sum|cut -d ' ' -f1获取md5值作为答案）

服务开机自动启动并且还是不间断的重启，那么可能是**服务设置**问题，寻找服务文件。发现服务文件在`/lib/systemd/system/redis.service`

```
echo -n '/lib/systemd/system/redis.service'|md5sum|cut -d ' ' -f1
```

flag{b2c5af8ce08753894540331e5a947d35}

## SmallSword

### SmallSword_1

> 连接蚁剑的正确密码是__?（答案示例：123asd）

![image-20240320214005701](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20240320214005701.png?imageSlim)

url解码之后得到

```
6ea280898e404bfabd0ebb702327b19f=@ini_set("display_errors", "0");@set_time_limit(0);echo "->|";$D=dirname($_SERVER["SCRIPT_FILENAME"]);if($D=="")$D=dirname($_SERVER["PATH_TRANSLATED"]);$R="{$D}	";if(substr($D,0,1)!="/"){foreach(range("A","Z")as $L)if(is_dir("{$L}:"))$R.="{$L}:";}else{$R.="/";}$R.="	";$u=(function_exists("posix_getegid"))?@posix_getpwuid(@posix_geteuid()):"";$s=($u)?$u["name"]:@get_current_user();$R.=php_uname();$R.="	{$s}";echo $R;;echo "|<-";die();

```

flag{6ea280898e404bfabd0ebb702327b19f}

### SmallSword_2

> 攻击者留存的值是__?(答案示例：d1c3f0d3-68bb-4d85-a337-fb97cf99ee2e)

![image-20240320215017715](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20240320215017715.png?imageSlim)

对请求实体进行解码，得到：

```
0x72b3f341e432=RDovcGhwU3R1ZHkvUEhQVHV0b3JpYWwvV1dXL3NxbGlpL0xlc3MtNy9oYWNrZXIudHh0&0xe9bb136e8a5e9=YWQ2MjY5YjctM2NlMi00YWU4LWI5N2YtZjI1OTUxNWU3YTkxIA==&6ea280898e404bfabd0ebb702327b19f=@ini_set("display_errors", "0");@set_time_limit(0);echo "->|";echo @fwrite(fopen(base64_decode($_POST["0x72b3f341e432"]),"w"),base64_decode($_POST["0xe9bb136e8a5e9"]))?"1":"0";;echo "|<-";die();
```

`YWQ2MjY5YjctM2NlMi00YWU4LWI5N2YtZjI1OTUxNWU3YTkxIA==`base64解码得到flag

flag{ad6269b7-3ce2-4ae8-b97f-f259515e7a91}

(这题有点不明所以)

### SmallSword_3

> 攻击者下载到的flag是______________?(答案示例：flag3{uuid})

![image-20240320215518142](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20240320215518142.png?imageSlim)

把tcp130服务器应答的内容提取出来

![image-20240320221704594](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20240320221704594.png?imageSlim)

根据文件头判断为exe文件，修改后缀名

![image-20240320221907689](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20240320221907689.png?imageSlim)

放入云沙箱发现其释放了一个jpg文件

![image-20240320223051040](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20240320223051040.png?imageSlim)

实际为png文件，进行宽高爆破后得到下部flag

![image-20240320223159110](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20240320223159110.png?imageSlim)

flag3{8f0dffac-5801-44a9-bd49-e66192ce4f57}

## tcpdump

### tcpdump_1

> 攻击者通过暴力破解进入了某 Wiki 文档，请给出登录的用户名与密码，以:拼接，比如 admin:admin

过滤器：`http.request.method==POST and http.request.uri== login  or http.response.code != 404 and frame.len != 237`

![image-20240322094542404](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20240322094542404.png?imageSlim)

`username=TMjpxFGQwD&password=123457`

flag{TMjpxFGQwD:123457}

### tcpdump_2

> 攻击者发现软件存在越权漏洞，请给出攻击者越权使用的cookie的内容的md5值。（32位小写）

刚登录时userid=2，后面变成1

![image-20240322101504664](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20240322101504664.png?imageSlim)

![image-20240322101526323](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20240322101526323.png?imageSlim)

`accessToken=f412d3a0378d42439ee016b06ef3330c; zyplayertoken=f412d3a0378d42439ee016b06ef3330cQzw=; userid=1`

flag{383c74db4e32513daaa1eeb1726d7255}

### tcpdump_3

> 攻击使用 jdbc 漏洞读取了应用配置文件，给出配置中的数据库账号密码，以:拼接，比如 root:123456

![image-20240322102028678](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20240322102028678.png?imageSlim)

flag{zyplayer:1234567}

### tcpdump_4

> 攻击者又使用了 CVE 漏洞攻击应用，执行系统命令，请给出此 CVE 编号以及远程 EXP 的文件名，使用:拼接，比如 CVE-2020-19817:exp.so

根据tcp 16022流中的xml的信息能发现weblogic

![image-20240322102912709](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20240322102912709.png?imageSlim)

搜索payload

![image-20240322102830681](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20240322102830681.png?imageSlim)

flag{CVE-2022-21724:custom.dtd.xml}

### tcpdump_5

> 给出攻击者获取系统权限后，下载的工具的名称，比如 nmap

![image-20240322102451723](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20240322102451723.png?imageSlim)

flag{fscan}

## Hacked

### hacked_1

> admIn 用户的密码是什么？

![image-20240322103838537](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20240322103838537.png?imageSlim)

根据该流的下一条tcp流http回显得知，该账号为admin账号

再根据之前的tcp流得知加密方式、密钥以及偏移量

![image-20240322104147595](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20240322104147595.png?imageSlim)

赛博厨子解密

![image-20240322104950446](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20240322104950446.png?imageSlim)

### hacked_2

> app.config[‘SECRET_KEY’]值为多少？

![image-20240322105652191](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20240322105652191.png?imageSlim)![image-20240322105805066](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20240322105805066.png?imageSlim)

flag{ssti_flask_hsfvaldb}

### hacked_3

> flask网站由哪个用户启动？

![image-20240322112254949](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20240322112254949.png?imageSlim)

使用flask-session-cookie-manager进行解密

![image-20240322112132123](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20240322112132123.png?imageSlim)

对回显cookie进行解密

![image-20240322112719608](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20240322112719608.png?imageSlim)

flag{red}

### hacked_4

> 攻击者写入的内存马的路由名叫什么？（答案里不需要加/）

![image-20240322113158687](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20240322113158687.png?imageSlim)

解密得到：

![image-20240322113140430](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20240322113140430.png?imageSlim)

flag{Index}

