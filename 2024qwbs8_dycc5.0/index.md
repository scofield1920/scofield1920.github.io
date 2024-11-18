# 2024 强网杯s8_谍影重重5.0


NTLM v2 hash爆破与 RDP流量分析

<!--more-->

### 谍影重重5.0

```
我国某部门已经连续三年对间谍张纪星进行秘密监控，最近其网络流量突然出现大量的神秘数据，为防止其向境外传送我国机密数据，我们已将其流量保存，请你协助我们分析其传输的秘密信息。
```

![121212](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/121212.png?imageSlim)

发现有SMB流量和TLS流量

根据经验应该是要爆破NTLM v2 hash来解密SMB流量， 并且要取得公钥来解密TLS流量

可以手动提取ntlmv2 hash，参考

https://www.secpulse.com/archives/106276.html

利用python自动提取pcap包中的ntlmv2 hash

https://github.com/gh-balthazarbratt/nocashvalue

```python
#!/usr/bin/python3

import os, sys, subprocess, json, logging, argparse
from uuid import uuid4

parser = argparse.ArgumentParser(description='Extracts NTLMv2 tokens from pcaps \
and creates files ready to be consumed by hashcat')
parser.add_argument('--tshark_path', 
                    type=str, 
                    help='full path to tshark executable', 
                    required=True)
parser.add_argument('--pcap_file', 
                    type=str, 
                    help='full path to pcap file', 
                    required=True)

args = parser.parse_args()
tshark_path = args.tshark_path
pcap_file = args.pcap_file

# Change the value below based on your system paths, it is set for *nix type systems
tmp = '/tmp'
# Set temporary directory and log file names
scr_dir = 'nocashvalue_ntlmv2-' + uuid4().__str__()[:8]
tmp_scr_dir = tmp + '/' + scr_dir
log_file = 'nocashvalue.log'

# Create script tmp directory
os.mkdir(tmp_scr_dir)

# Setup logger
logger = logging.getLogger('nocashvalue')
logger.setLevel(logging.DEBUG)
fh = logging.FileHandler(tmp_scr_dir+'/'+log_file)
fh.setFormatter(logging.Formatter('%(asctime)s - %(levelname)s - %(message)s'))
logger.addHandler(fh)

logger.info('Logger initialized')

challenge_filter_str = "'ntlmssp.identifier == NTLMSSP and ntlmssp.messagetype == 0x00000002'"
blob_filter_str = "'ntlmssp.identifier == NTLMSSP and ntlmssp.messagetype == 0x00000003'"

challenge_str_cmd = "{} -r {} -Y{} -Tjson -e ntlmssp.auth.username \
-e ntlmssp.auth.domain -e ntlmssp.ntlmserverchallenge -e ntlmssp.ntlmv2_response.ntproofstr \
-e ntlmssp.ntlmv2_response".format(tshark_path, pcap_file, challenge_filter_str)

blob_str_cmd = "{} -r {} -Y{} -Tjson -e ntlmssp.auth.username -e ntlmssp.auth.domain \
-e ntlmssp.ntlmserverchallenge -e ntlmssp.ntlmv2_response.ntproofstr \
-e ntlmssp.ntlmv2_response".format(tshark_path, pcap_file, blob_filter_str)

logger.info('Executing "{}" in a subprocess shell'.format(challenge_str_cmd))
pipe1 = subprocess.Popen(challenge_str_cmd, stdout=subprocess.PIPE, shell=True)
logger.info('Child process pid is {} and it exited with {}'.format(pipe1.pid, pipe1.returncode))

logger.info('Executing "{}" in a subprocess shell'.format(blob_str_cmd))
pipe2 = subprocess.Popen(blob_str_cmd, stdout=subprocess.PIPE, shell=True)
logger.info('Child process pid is {} and it exited with {}'.format(pipe2.pid, pipe2.returncode))

challenge_str_output = pipe1.stdout.read()
blob_str_output = pipe2.stdout.read()

# This is a list of dictionaries
challenge_str_json = json.loads(challenge_str_output.decode('UTF-8'))
logger.info(json.dumps(challenge_str_json, indent=2))

blob_str_json = json.loads(blob_str_output.decode('UTF-8'))
logger.info(json.dumps(blob_str_json, indent=2))

# Log the fact that the number of server challenge packets 
# are different than the number of ntlmv2_response packets and exit
if (len(challenge_str_json) != len(blob_str_json)): 
    sys.stdout.write('Number of SMB2 packets containing NTLM Server Challenge tokens \
are different than the number of packets containing NTLMv2 responses. See {} \
for details.'.format(tmp_scr_dir+'/'+log_file))
    exit()

packets = []

# Merge server challenge tokens with the rest of the ntlmv2_response details
# Caveat: We assume that the packets are received in chronological order such that
# the packet which contains server_challenge token appears right before the packet 
# that contains NTLMv2_response it is associated with
for i, blob_pkt in enumerate(blob_str_json):
    username, domain, server_challenge, ntproofstr, ntlmv2_response = ['', '', '', '', '']
    if (len(blob_pkt['_source']['layers']) > 0 and 
        'ntlmssp.auth.username' in blob_pkt['_source']['layers']):
        username = blob_pkt['_source']['layers']['ntlmssp.auth.username'][0]
    if (len(blob_pkt['_source']['layers']) > 0 
        and 'ntlmssp.auth.domain' in blob_pkt['_source']['layers']):
        domain = blob_pkt['_source']['layers']['ntlmssp.auth.domain'][0]
    if (len(challenge_str_json[i]['_source']['layers']) > 0 
        and 'ntlmssp.ntlmserverchallenge' in challenge_str_json[i]['_source']['layers']):
        server_challenge = challenge_str_json[i]['_source']['layers']['ntlmssp.ntlmserverchallenge'][0]
    if (len(blob_pkt['_source']['layers']) > 0 
        and 'ntlmssp.ntlmv2_response.ntproofstr' in blob_pkt['_source']['layers']):
        ntproofstr = blob_pkt['_source']['layers']['ntlmssp.ntlmv2_response.ntproofstr'][0]
    if (len(blob_pkt['_source']['layers']) > 0 
        and 'ntlmssp.ntlmv2_response' in blob_pkt['_source']['layers']):
        ntlmv2_response = blob_pkt['_source']['layers']['ntlmssp.ntlmv2_response'][0]
        if len(ntlmv2_response) > 0:
            ntlmv2_response = ntlmv2_response[31:]
    packets.insert(i, {'username': username, 
                       'domain': domain, 
                       'server_challenge': server_challenge, 
                       'ntproofstr': ntproofstr, 
                       'ntlmv2_response': ntlmv2_response})

# Hashcat NTLMv2 file format
# username::domain:ServerChallenge:NTproofstring:modifiedntlmv2response
for packet in packets:
    file_name = (tmp_scr_dir 
                    + '/' + packet['username'] + '_' + packet['domain'] 
                    + '-' + uuid4().__str__()[:8] + '.txt')
    with open(file_name, 'w', encoding="UTF-8") as file:
        blob = packet['username'] + '::' + packet['domain'] + ':' + packet['server_challenge'] 
        blob += ':' + packet['ntproofstr'] + ':' + packet['ntlmv2_response']
        file.write(blob)

sys.stdout.write('{} files created. See {} for details.'.format(len(packets),tmp_scr_dir))
```

得到两个文档，里面包括了username::domain:ServerChallenge:NTproofstring:modifiedntlmv2response 的所有信息

随后使用hashcat破解

```
hashcat -m 5600 tom.txt rockyou.txt -o result.txt --force
```

> 过程中也是出现了点问题
>
> ![image-20241117220420916](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20241117220420916.png?imageSlim)
>
> 后来重新手动提取了一下username::domain:ServerChallenge:NTproofstring:modifiedntlmv2response，发现脚本提的数据中`NTproofstring`多了第一位
>

![image-20241117220529183](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20241117220529183.png?imageSlim)

修正后的数据

```
tom::.:c1dec53240124487:ca32f9b5b48c04ccfa96f35213d63d75:010100000000000040d0731fb92adb01221434d6e24970170000000002001e004400450053004b0054004f0050002d004a0030004500450039004d00520001001e004400450053004b0054004f0050002d004a0030004500450039004d00520004001e004400450053004b0054004f0050002d004a0030004500450039004d00520003001e004400450053004b0054004f0050002d004a0030004500450039004d0052000700080040d0731fb92adb0106000400020000000800300030000000000000000100000000200000bd69d88e01f6425e6c1d7f796d55f11bd4bdcb27c845c6ebfac35b8a3acc42c20a001000000000000000000000000000000000000900260063006900660073002f003100370032002e00310036002e003100300035002e003100320039000000000000000000
```

使用hashcat爆破，得到密码：babygirl233

```
TOM::.:c1dec53240124487:ca32f9b5b48c04ccfa96f35213d63d75:010100000000000040d0731fb92adb01221434d6e24970170000000002001e004400450053004b0054004f0050002d004a0030004500450039004d00520001001e004400450053004b0054004f0050002d004a0030004500450039004d00520004001e004400450053004b0054004f0050002d004a0030004500450039004d00520003001e004400450053004b0054004f0050002d004a0030004500450039004d0052000700080040d0731fb92adb0106000400020000000800300030000000000000000100000000200000bd69d88e01f6425e6c1d7f796d55f11bd4bdcb27c845c6ebfac35b8a3acc42c20a001000000000000000000000000000000000000900260063006900660073002f003100370032002e00310036002e003100300035002e003100320039000000000000000000:babygirl233
```

导入到wireshark首选项NT Password

![12314](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/12314.png?imageSlim)

在文件导出对象-->smb对象中，可以导出一些文件

![image-20241117221134906](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20241117221134906.png?imageSlim)

flag.7z被加密了，还有两个证书文件，根据名称可猜测是远程桌面流量加密所用的证书，另外，在流量中包含了大量的RDP流量，证书是带密码的

因为密钥pfx和pem是一起出来的，没分析流量直接推测是mimikatz导出的

wireshark可以直接用pfx解密TLS，在首选项中添加RSA密钥，输入密码mimikatz（推测得知）

![image-20241117231243594](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20241117231243594.png?imageSlim)

随后导出PUD到文件

![image-20241117231453889](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20241117231453889.png?imageSlim)

![image-20241117231529074](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20241117231529074.png?imageSlim)

![image-20241117231541410](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20241117231541410.png?imageSlim)

保存到rdp_session.pcap

```
分析rdp流量参考

https://www.haxor.no/en/article/analyzing-captured-rdp-sessions
```

在Linux环境下安装pyrdp

https://github.com/GoSecure/pyrdp

```bash
pyrdp-convert -o output rdp_session.pcap
```

随后得到

![image-20241117230655527](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20241117230655527.png?imageSlim)

```
pyrdp-player
```

进入GUI界面选中`20241030104801_172.16.105.1:50834-172.16.105.129:3389.pyrdp`进行播放

![image-20241117230816219](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20241117230816219.png?imageSlim)

得到

```
--------------------
USERNAME: tom
PASSWORD: 
DOMAIN: 

--------------------

<Tab released>
<Shift released>
<Shift released>
<Control released>
<Control released>
<Tab released>
<Alt released>
<Tab released>
<Alt released>
<Tab released>
<Tab released>
<Shift released>
<Shift released>
<Control released>
<Control released>
<Tab released>
<Alt released>
<Tab released>
<Alt released>
<Tab released>
<Tab released>
<Meta released>
<Windows released>
<Shift released>
<Shift released>
<Control released>
<Control released>
<Tab released>
<Alt released>
<Tab released>
<Alt released>
<Tab released>
<Return pressed>
<Return released>the
<Shift pressed>
<Shift released>
<Space pressed>
<Space released>7z
<Space pressed>
<Space released>password
<Space pressed>
<Space released>is
<Space pressed>
<Space released>f'
<Shift pressed>{
<Shift released>windows
<Shift pressed>_
<Shift released>password
<Shift pressed>}
<Shift released>9347013182'
<Control pressed>s
<Control released>
<Tab released>
<Shift released>
<Shift released>
<Control released>
<Control released>
<Tab released>
<Alt released>
<Tab released>
<Alt released>
<Tab released>
<Connection closed>
```

the 7z password is f'{windows_password}9347013182's

可知7z压缩包密码为`babygirl2339347013182`

 ![image-20241117231109932](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20241117231110201.png?imageSlim)


