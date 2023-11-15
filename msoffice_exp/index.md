# MS&Office漏洞exp收集


https://github.com/Lz1y/CVE-2017-8759 .NET Framework换行符漏洞，CVE-2017-8759完美复现
（另附加hta+powershell弹框闪烁解决方案）https://www.freebuf.com/vuls/147793.html

https://github.com/WyAtu/CVE-2018-8581 Exchange使用完成添加收信规则的操作进行横向渗透和提权漏洞

https://github.com/dafthack/MailSniper PS,用于在Microsoft Exchange环境搜索电子邮件查找特定邮件（密码、网络架构信息等）

https://github.com/sensepost/ruler GO,通过MAPI / HTTP或RPC / HTTP协议远程与Exchange服务器进行交互,通过客户端Outlook功能远程获取shell

https://github.com/3gstudent/Smbtouch-Scanner 扫描内网永恒之蓝ETERNAL445SMB系列漏洞

https://github.com/smgorelik/Windows-RCE-exploits windows命令执行RCE漏洞POC样本，分为web与文件两种形式

https://github.com/3gstudent/CVE-2017-8464-EXP CVE-2017-8464，win快捷方式远程执行漏洞

https://github.com/Lz1y/CVE-2018-8420 Windows的msxml解析器漏洞可以通过ie或vbs执行后门

https://www.anquanke.com/post/id/163000 利用Excel 4.0宏躲避杀软检测的攻击技术分析

https://github.com/BuffaloWill/oxml_xxe XXE漏洞利用

https://thief.one/2017/06/20/1/ 浅谈XXE漏洞攻击与防御

https://github.com/thom-s/docx-embeddedhtml-injection word2016，滥用Word联机视频特征执行恶意代码poc

https://blog.cymulate.com/abusing-microsoft-office-online-video word2016，滥用Word联机视频特征执行恶意代码介绍

https://github.com/0xdeadbeefJERKY/Office-DDE-Payloads 无需开启宏即可在word文档中利用DDE执行命令

http://www.freebuf.com/articles/terminal/150285.html 无需开启宏即可在word文档中利用DDE执行命令利用

https://github.com/Ridter/CVE-2017-11882 利用word文档RTF获取shell，https://evi1cg.me/archives/CVE_2017_11882_exp.html

https://github.com/Lz1y/CVE-2017-8759 利用word文档hta获取shell，http://www.freebuf.com/vuls/147793.html

https://fuping.site/2017/04/18/CVE-2017-0199漏洞复现过程 WORD RTF 文档，配合msf利用

https://github.com/tezukanice/Office8570 利用ppsx幻灯片远程命令执行，https://github.com/rxwx/CVE-2017-8570

https://github.com/0x09AL/CVE-2018-8174-msf 目前支持的版本是 32 位 IE 浏览器和 32 位 office。
网页访问上线，浏览器关闭，shell 依然存活，http://www.freebuf.com/vuls/173727.html

http://www.4hou.com/technology/9405.html 在 Office 文档的属性中隐藏攻击载荷

https://evi1cg.me/archives/Create_PPSX.html 构造PPSX钓鱼文件

https://github.com/enigma0x3/Generate-Macro PowerShell脚本，生成含有恶意宏的Microsoft Office文档

https://github.com/mwrlabs/wePWNise 生成独立于体系结构的VBA代码，用于Office文档或模板，并自动绕过应用程序控制

https://github.com/curi0usJack/luckystrike 基于ps，用于创建恶意的Office宏文档

https://github.com/sevagas/macro_pack MS Office文档、VBS格式、快捷方式payload捆绑

https://github.com/khr0x40sh/MacroShop 一组通过Office宏传递有效载荷的脚本
