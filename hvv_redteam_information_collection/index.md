# hvv_红队外围信息收集


本文的性质为资料整理，相关来源在相关内容下方或文章末尾

---

## 红队概述：

![image-20230713215952532](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20230713215952532.png)



### **信息收集方式**：

一般采取以下几种方式在搜索引擎（如：baidu、google）进行搜索：

- 主站相关联的链接，主站链接下可能会放置跳转，如邮件、OA等相关系统。

- 主站子域名进行搜索，通过二级或三级域名进行目标搜索相关域名。

- 主目标相关title，主要为搜索一些没有设置域名只有相关IP的系统。

- 主目标相关body，这种搜索方式误报率比较高，通过一些条件可筛选出相关联系统。

- C段探测，一般前几种搜索方式获取相关IP，然后探测可能存在的C段，可获取一些没有相关联信息的隐藏资产。

- 端口探测，扫描是否存在其他的web服务，或可利用的、可爆破的、未授权的端口等。

- 邮件账号收集，一般为发布在公网上招聘、联系方式等，然后可进行弱密码破解。
  

### **主要进攻目标原则:**

- 资产范围比较庞大。因为资产范围广，容易出现不被关注的系统，安全性可能存在疏忽，比较容易进行突破；

- 受关注比较低的。由于受到关注度高的系统，如果受到攻击，影响会比较大，安全性会比一般的高。所以需要选择受关注比较低的系统做为突破口；

- 没有与资金直接关系的系统。涉及资金交易的系统，安全性受到重视度最高，突破难度大，所以不选择；

- 安全管理不够完善的单位。安全管理不够完善的单位做为突破口，容易发现弱口令或密码相同，人员安全意识不高，容易利用钓鱼手段做为突破口；
  

### **三个阶段：**

**第一阶段**

定位好主要攻击目标后，一起寻找主要突破口，当成功撕开一个突破口后进入第二阶段；

**第二阶段**

由于刚撕开突破口，不宜动作太大，所以由主要攻击手进行内网探测信息收集，以及留后门工作，寻找其他跳板机；另外两人进行次要目标的寻求突破，当主攻手成功获取其他跳板机后，或者次要目标找到突破口进入第三阶段；

**第三阶段**

全力挖掘内网，尽量得分，寻求拿下任务目标系统。

**攻击手段**
主要是通过以下途径开展渗透攻击：一是通过SQL注入、文件上传漏洞等攻击方式，对目标系统开展攻击，获取系统权限；二是利用后台、用户弱口令漏洞，获取网络及信息系统关键信息；三是利用系统已知漏洞，直接获得系统服务器权限。

当攻陷的服务器处于内网之中，将进一步深入进行内网漫游。

**由于不同目标防守方一般经过行业划分，所以防守实力强弱差距比较大。**

防守方最强的为金融行业，毕竟与金钱有着直接关系的，受到关注度也是最高，安全投入最高，就算突破也很难获取大量得分，所以大多数攻方都不以金融行业为主要攻击目标。

其次防守比较强的行业为重要企业，由于企业对外网络服务的业务少，受众面不如政府、金融行业，再加上企业对安全管理比较重视，所以企业属于易守难攻类型。

防守比较薄弱的几个行业如下：

- 运输交通、政府公众服务类、能源矿产类、电力等这几类系统的特点：

- 资产庞大，业务系统驳杂、全国各地都有甚至到县城，容易被找到突破口。

- 没有统一的安全管理，由于庞大系统需要多个管理员一起维护，一旦有重大漏洞爆出往往会出现响应不及时的现象。例如：在互联网上传播最新漏洞信息，防守比较强的行业能在第一时间内修复漏洞或者找到临时应对的方法。而防守薄弱的可能，没有获取相关信息，或者在了解信息后，没有比较好的解决方法选择极端的防守方式关闭站点。

- 安全边界防护不严格，由于系统庞大系统需要布满全国各地，地方可能也会开放自己的业务系统，一旦一个地方被入侵成功，就可连通全国各地的内网，以点破面全部沦陷的风险。

- 排查攻击能力较弱。


例如：在内网中发现攻击或木马后门，防守强的行业能在发现后门后，分析出攻击的入侵点，并能锁定哪些资产可能被入侵进行彻底排查。而防守比较弱的队伍可能无法发现后门，或者无法彻底清除后门，导致在管理以为彻底修复问题后，内网仍然被入侵。

## 正题：

### 0x01 信息收集踩点

| a b c                                                        | 自动对词进行拆分匹配 拆分标准 空格                           |
| ------------------------------------------------------------ | ------------------------------------------------------------ |
| “a b c “                                                     | 把a b c 当成一个整体去查                                     |
| ” a*b”                                                       | *通配符 里面是一个或者多个 以a开头 b结尾                     |
| “ab” -c                                                      | 找到ab 不包含c                                               |
| a and b                                                      | 包含a和b                                                     |
| “ab”(c\|d)                                                   | ab中可能包含c或者d                                           |
| intitle: xx                                                  | 找标题                                                       |
| intext: xx                                                   | 找内容                                                       |
| info: xx                                                     | 搜索到关于一个URL的更多信息的页面列表，这里的信息包括这个网页的cache，还有与这个网页相似的网页等等 |
| inurl: *.baidu.com                                           | 模糊搜索地址                                                 |
| inurl:phpmyadmin/index.php & (intext:username & password & “Welcome to”) |                                                              |
| inanchor:修改密码                                            | 锚点描述文本                                                 |
| filetype:pdf                                                 | 搜索                                                         |
| cache:baidu.com                                              | 快照 历史信息                                                |
| link:xxx.com                                                 | 搜索所有链接有xxx.com 链接                                   |
| site:*.baidu.com                                             | 搜索这个所有域名                                             |
| related: xx.com                                              | 搜索相关网站                                                 |
| book: Lisa+CA                                                | phone电话簿查询美国街道地址和电话号码信息。例如 “phonebook:Lisa+CA”将查询名字里面包含”Lisa” 并住在加州的人的所有名字。 |
| allinanchor                                                  | 限制搜索结果必须是那些在anchor文字里包含了我们所有查询关键词的网页。 |
| allintext                                                    | 限制搜索结果仅仅是在网页正文里边包含了我们所有查询关键词的网页。 |
| allintitle                                                   | 限制搜索结果仅是那些在网页标题里边包含了我们所有查询关键词的网页。 |
| allinurl                                                     | 限制搜索结果仅是那些在URL（网址）里边包含了我们所有查询关键词的网页。 |
| author                                                       | 限制返回结果仅仅是那些在Google论坛里边，包含了特定作者的新闻文章。 |
| bphonebook                                                   | 用bphonebook进行查询的时候，返回结果将是那些商务电话资料。   |
| datarange                                                    | 将查询结果限制在一个特定的时间段内，这个时间相对于网站来说，是按网站被google收录的时间算的。 |
| define                                                       | 返回包含查询关键词定义的网面。                               |
| ext                                                          | 用于filetype:查找扩散名为ext的文件。                         |
| group                                                        | 限制我们的论坛查询结果仅是某几个固定的论坛组或是某些特定主题组的新闻文章。 |
| id                                                           | 又是一个没有证实的语法，效果很一般。                         |
| insubject                                                    | 限制论坛搜索结果仅是那些在主题里边包含了查询关键词的网面。   |
| location                                                     | 当我们提交location进行Google新闻查询的时候，Google仅会返回你当前指定区的跟查询关键词相关的网页。 |
| movie                                                        | 用movie提交查询的时候，Google会返回跟查询关键词相关的电影信息。 |
| phonebook                                                    | 用phonebook进行查询的时候，Google会返回美国当地跟查询关键词相关的电话信息。 |
| related                                                      | 用related提交查询，Google会返回跟我们要查询的网站结构内容相似的一些其它网站。 |
| rphonebook                                                   | 查询用来搜索美国当地跟查询关键词相关的住宅电话信息。         |
| safesearch                                                   | 用safesearch提交查询的时候，Google会过滤你搜索的结果，其中过滤的内容可能包括一些色情的，暴力，赌博性质的，还有传染病毒的网页。但是它不是百分之百确保安全的。 |
| source                                                       | 用source提交查询的时候，Google新闻会限制我们的查询仅是那些我们指定了特定ID或新闻源的网址。 |
| stocks                                                       | 返回跟查询关键词相关的股票信息，这些信息一般来自于其它一些专业的财经网站。 |
| store                                                        | 查询的时候，Google Froogle仅会显示我们指定了store ID的结果。 |
| tq                                                           | 如果想查某个地方的天气如何,我们只要在Google搜索框中输入”城市名称 Tq”就可以查询到这个城市的天状况.例”北京 tq”,当然tq也可以用汉字的天气代替。 |
| weather                                                      | 用weather提交查询的时候，如果我们指出一个Google可以识别的地区或城市，Google会返回该地区或城市当前的天气状况。 |
| Related:URL                                                  | 搜索结果将展示与这个URL链接页面相关的页面。”相关”除了和该页面内容相关的页面外，还包括这个页面的导入链接和导出链接所指向的页面。 |
| Ext                                                          | “Ext:文件后缀”。它可以帮你搜索各种后缀格式的文件。比如说： xls (微软 Excel) ppt (微软 PowerPoint) doc (微软 Word) pdf (Adobe 文件) html or htm (HTML代码文件) |
| Inanchor                                                     | 搜索结果中必须出现以这个关键词为链接关键词的链接。           |

#### 谷歌常用搜索语法：

```
AND：缺一不可
OR：两者皆可
""：为一个关键词
-：不包含某关键词
+：不忽略某关键词
“~”：同义词匹配搜索
“?”和“*”：占位通配符
```

关键字搜索

```
site：指定域名，如：site:edu.cn 搜索教育网站
inurl：用于搜索包含的url关键词的网页，如：inurl:login 搜索网址中含有login的网页
intitle：搜索网页标题中的关键字，如：intitle:“index of /admin”
intext：搜索网页正文中的关键字，如：intext:登陆/注册/用户名/密码
filetype：按指定文件类型即文件后缀名搜索，如：filetpye:php/asp/jsp
```

查找后台

```
site:xx.com intext:管理|后台|登陆|用户名|密码|系统|帐号|admin|login|sys|managetem|password|username
site:xx.com inurl:login|admin|manage|member|admin_login|login_admin|system|login|user
```

查找sql注入漏洞

```
inurl:.php?id=23 公司
inurl:.asp?id=11
```

查找上传点：

```
site:xx.com inurl:file| uploadfile
```

查找敏感信息泄露

```
intitle:"Index of /admin"
intitle:"Index of /root"
intitle:"Index of /" +password.txt
intitle:phpinfo()或者inurl:phpinfo.php
```

查找未授权访问phpmyadmin

```
inurl:.php? intext:CHARACTER_SETS,COLLATIONS, ?intitle:phpmyadmin
```



### **0x02 GitHub 信息收集**

- **数据库信息泄露**

site:github.com  root password

site:github.com  sa password

site:github.com  User ID=’sa’;Password

- **svn信息泄露**

site:github.com  svn

site:github.com  svn password

site:github.com  svn username

site:github.com  svn username password

- **数据库备份文件**

 site:github.com  inurl:sql

- **综合信息泄露**

site:github.com  password

site:github.com  ftp ftppassword

site:github.com  密码

site:github.com  内部

- **Github 信息收集**

**https://github.com/michenriksen/gitrob**

**https://securitytrails.com/blog/github-dorks**

### 0x03 搜索空间信息收集

子域名中的常见资产类型一般包括办公系统，邮箱系统，论坛，商城等，其他管理系统，网站管理后台等较少出现在子域名中。
首先找到目标站点，在官网中可能会找到相关资产（多为办公系统，邮箱系统等），关注一下页面底部，也许有管理后台等收获。
**查找目标域名信息的方法：**

| **名称**                           | **用法或地址**                                               |
| ---------------------------------- | ------------------------------------------------------------ |
| FOFA                               | title=”公司名称”                                             |
| 钟馗之眼                           | site=域名即可                                                |
| 百度                               | intitle=公司名称                                             |
| Google                             | intitle=公司名称                                             |
| FOFA搜索子域名                     | https://fofa.so/ 语法：domain=”baidu.com”                    |
| Hackertarget查询子域名             | https://hackertarget.com/find-dns-host-records/ 注意：查询子域名可以得到一个目标大概的ip段，接下来可以通过ip来收集信息。 |
| 站长之家，直接搜索名称或者网站域名 | http://tool.chinaz.com/                                      |
| 钟馗之眼，直接搜索名称或网站名称   | https://www.zoomeye.org/                                     |

#### FOFA常用语法：

```
1、domain= "qq.com" //搜索qq.com所有的子域名
2、host="edu.cn" //从url中搜索edu.cn
3、ip= "11.1.1.1" //搜索ip
4、server="apache" //搜索服务是apache的网站
5、os="windows" //搜素操作系统是windows的网站
6、port=3306 或者 protocol=="mysql" //搜索mysql数据库的网站
7、app="致远" //搜索致远oa办公系统搭建的网站
8、title="登陆" //从标题中搜索登陆
9、header="thinkphp" //从http的头里面搜thinkphp
```

### 0x04 端口、邮箱、备案收集

| **名称**              | **地址或命令**                                               |
| --------------------- | ------------------------------------------------------------ |
| Tag1-Nmap端口扫描     | nmap -sS -T4 -Pn –open -n -p- -iL ***.txt -oX ***            |
| 小蓝本                | https://www.xiaolanben.com/                                  |
| ThreatScan            | https://scan.top15.cn/web/                                   |
| 邮箱收集              | https://www.email-format.com/                                |
| 注册edu邮箱           | 往下面看当前0x03 的PS的内容                                  |
| 奇怪域名收集          | https://archive.org/web/                                     |
| Aquatone  —子域名截图 | https://github.com/michenriksen/aquatone                     |
| Github 收集           | “*.com” login “*.com” ftp “*.com” password “*.com” token     |
| 图标hash搜索          | 1. 平台 2. 领英3. 脉脉 4. 新媒体资产5. 抓公众号、小程序链接，能发现一堆奇奇怪怪的资产；还有抖音，支付宝商号等等 |
| Fuzz                  | 资产存活，但却访问不了，是因为目录不正确，收集一个高命中率的资产字典进行fuzz |
| Hosts碰撞             | https://github.com/r35tart/Hosts_scan用于碰撞某些绑定了host的域名进行强制匹配进行访问，跟改了本地host文件一样 |
| JS分析                | 网页的JS中往往存在着奇奇怪怪的URL，里面有些参数说不定也有，意想不到的接口泄露 推荐工具JSfinderhttps://github.com/Threezh1/JSFinder |
| 客服窗口              | 为什么此处会说客户窗口？说不定能弹个XSS，在打点的时候可以用此处知道客户的后台地址和Cookie |
| Crunchbase            | Crunchbase是一个以Web 2.0方式表达的创业公司数据库，包含了创始人，关键雇员，财务状况，收购新闻以及其他重要事件 https://www.crunchbase.com |

### 0x05 端口检测

| **名称**                   | **地址**                                                     |
| -------------------------- | ------------------------------------------------------------ |
| 在线端口检测               | http://coolaf.com/tool/port                                  |
| 扫描主机端口               | nmap -T5 -A -v -p- <target ip>                               |
| 扫描一个IP段，探测存活主机 | nmap -sP <network address> </CIDR>                           |
| 探测操作系统类型           | nmap -0 <target IP>                                          |
| 寻找登录授权页面           | nmap -p 80 –script http-auth-finder <www.xxx.com>            |
| SSH爆破                    | nmap -p22 –script ssh-brute <target ip>                      |
| dns 域传送漏洞             | nmap -p 53 –script dns-zone-transfer.nse -v <target ip>      |
| Masscan                    | Masscan 127.0.0.0/24 -p443 # 单端口扫描                      |
| Masscan                    | Masscan 127.0.0.0/24 –top-ports 100 -rate 100000 # 快速扫描  |
| Masscan                    | Masscan 127.0.0.0/24 –top-ports 100 –excludefile exclude.txt # 排除指定目标 |
| Masscan                    | Masscan 127.0.0.0/24 -p20,21,22,23,80,161,443,873,2181,3389,6379,7001,8000,8009,8080,9000,9009,9090,9200,9300,10000,50070 > results.txt |

### 0x06 邮箱收集技巧

#### 使用邮箱地址查找工具

**· 批量邮箱验证**

1）Clearbit Connect：可免费访问，每月免费搜索上限100个；

2）Hunter：每月免费搜索上限100个，付费每月49美元起，每月搜索上限1000个起；

3）Findanyemail 2.0：每月免费搜索上限100个，付费每月49美元起，每月搜索上限5000个起；

4）toofr：首次使用可免费搜索30个，之后每月19美元，每月搜索上限2500个起；

5）Voila Norbert：首次使用可免费搜索30个，之后每月49美元起，每月搜索上限1000个起；

6）Anymail finder：首次使用可免费搜索20个，之后每月18美元起，每月搜索上限200个起；

7）Find That Email：首次使用可免费搜索15个，之后每月19美元起，每月搜索上限500个起；

8）Snovio 查看三度人脉以内的邮箱

9）Rapportive 输入邮箱或者将鼠标悬浮在Gmail中任意一个联系人的邮箱，此工具会立马给出相应联系人的详细LinkedIn个人资料信息

10）Emailmatcher：无限免费搜索。

11）SellHack：输入名称和域名，然后扫描邮件服务器以查找所有匹配的电子邮件地址。替代品：Clearbit

**· 性格+其它收集**

- Crystal 性格分析工具（使用相同或相似分析后判断是否有可能是同公司的）
- 收集目标网站信息构造文件内容（批量发送邮件验证）
- Google、必应、百度浏览器搜索相关邮件信息

这里解释一下如上说的一些搜索信息大致分为三类：

- 第一种：目标单位正在运营的网站，例如官方网站，社交网站等

- 第二种：保留在第三方网站上的信息，例如用于注册公司信息的网站，行业网站，招聘网站等

- 第三种：最后一个类别与关键字相关

  **在这三种类型的网站中，第一类和第二类网站确实有价值**
  **（**该公司的官方网站通常可以找到开发历史，主要产品和市场信息。社交网站通常使我们能够找到关键人物的职业信息。第三方网站上的信息通常使我们能够找到有关公司的更深入的信息，例如资产净值，公司的业务状况和员工人数。展示的信息。**）**

- Bloomberg 是专门用于查询公司信息的网站

- whois 适合查询个人注册的公司、历史快照、从Bloomberg 相关关键人员信息

- 通过网站的通用联系表单和邮箱。

  **PS：**通常，邮件接收人会猜你是不是有重要的事，然后又因为他跟你的目标人基本无利益冲突，很可能会热心的帮你这个忙。

- 验证邮箱真假（https://www.mail-verifier.com/ （邮箱侦探 验证电子邮件地址有效性!）、https://verify-email.org/ （核实邮件）、https://www.emailcamel.com （批量验证收费））

**· SKYPE 工具使用**

“一个” 直接使用SKYPE查找客户

（1）使用产品关键字在SKYPE中搜索客户（当前正在与客户聊天！）

（2）使用行业名称在SKYPE中搜索客户

（3）搜索之后，在SKYPE个人资料图片中使用客户的SKYPE名称，昵称，信息和客户的公司LOGO来过滤和添加客户

**“两个” 使用客户查询信息来搜索客户的SKYPE**

（1）在SKYPE中搜索客户网站名称（在www之后和点之前）

（2）使用客户电子邮件@前content在SKYPE中搜索

（3）使用客户名称在SKYPE中搜索。

（4）使用客户公司名称在SKYPE中搜索

“三” 将客户的邮箱放在Skype上进行搜索，然后可以搜索客户的Skype ID，以便您可以及时与客户在线聊天。（当前，使用此方法搜索有较大意图的先前客户）

#### 分类目标单位类型

**· 外贸或类似食品类型**

1）展览客户-展览将遇到一些新客户，通过交流和网站调查，可以确定一些精确的买家。

2）B2B查询-通过分析查询客户，可以确定一些精确的买家。

3）海关数据通过关键字搜索+数据分析，您可以找到与自己公司实力相匹配的准确买家。

4）公司名称和联系方式放在LinkedIn、Facebook等国外社交媒体平台上进行搜索

3）猜测邮箱姓、名等地址：metricsparrow.com/toolkit/email-permutator

4）谷歌指定搜索，例如名称

假设对方叫做Ken Lyons，可利用的谷歌搜索指令如下：

● site:companywebsite.com + ken.lyons [at] companyname.com

● site:companywebsite.com + kenlyons [at] companyname.com

● site:companywebsite.com + klyons [at] companyname.com

● site:companywebsite.com + ken [at] companyname.com

● site:companywebsite.com + ken_lyons [at] companyname.com

● site:WEBSITE.com+[name]+email

● site:WEBSITE.com+[name]+contact

● NAME email

● NAME contact

● “FIRSTNAME LASTNAME” email

● “FIRSTNAME LASTNAME” contact

5）利用the Harvester 可以查找电子邮箱和子域名

6）使用Pipl查找

7）外贸搜（waimaosou.com）

鹰眼搜（yingyanso.cn）

微匹（veryvp.com）

类似微匹搜索的网站（email-format.com）

skymem搜索邮箱（skymem）

8）邮件反查工具（懒得工具）

9）知道客户和国家/地区的全名，通过此URL查询客户信息（peoplelooker、beenverified）

10）探测邮箱（免费）

11）www.emailgo.cn进行注册。您只能输入URL，找到邮箱，并找到更多，更完整和可靠的邮箱。

12）www.email-format.com，无需注册。

13）emailhunter.co，如果您要注册，每个月丢失网站地址只能找到150个电子邮件地址。

14）www.yingyanso.com，要注册，有客户端下载，客户端电子邮件结果比较完整，搜索URL或产品名称查找电子邮件.

15）teemo扫描工具（提莫）

16）www.mingluji.com 名录集

17）buyerinfo.biz.cutestat.com 世界买家网

18）谷歌地图搜索，搜索邮箱

- www.52wmb.com
- www.365trade.com.cn
- cn.panjiva.com

19）领英、脉脉、陌陌、youtube、twitter、pinterest、google+,vk,tumblr等国外社交网站发布产品

20）istagram 国外社交软件搜索邮箱

21）Snovio 自动化搜索邮箱（免费试用）

22）中国制造，环球资源，环球资源、tradekey等等B2B平台，搜索邮箱

23）souyouxiang.com 搜邮箱

24）常用外贸B2B

Global Sources、Alibaba、Kompass、Aliexpress、Globalimporter、hktdc、Eworldtrade、Mytradezone、Dhgate

25）常用外贸搜索

Google、Yahoo、who.is、商务部买家数据、海关及海关数据、Icanopen、Thomasnet、Kellysearch、Ezilon、Ask

26）中国(中国最有影响力搜索引擎、中国最有影响力B2B网站、中国本国黄页网站、中国国家政府官方经典对外经贸网站、中国新闻信息网站、中国银行证券网站、中国相关信息网站)

https://www.b2bwz.com/guobie/yazhou/china.htm

27）谷歌邮箱插件

28）邮箱工具

http://www.qunfa158.com/software-email-search

29）谷歌查找

1. **公司名称+ Google查找电子邮件**
2. **公司地址+ Google查找电子邮件**
3. **公司网站+ Google查找客户**
4. **公司电话+ Google查找客户**

http://www.qunfa158.com/software-email-search

30）软件（网络登录）—猎人

名称：hunter.io
功能：按域名查找邮箱，使用非KP邮箱（如INFO）
用法：可以找到相应的来源

31）软件（网络登录）

名称：connect.data.com
功能：免费账户可以查询2家公司的邮箱，邮箱的信誉还可以
用法：

​    1）支付或上传数据以换取积分
​    2）电子邮件验证需要时间

32）海关数据

外贸数据（https://www.52wmb.com/）
出口贸易（http://www.e8t.com/information/）

33）电话联系以获取电子邮件

用法：
**a.** 直接联系老板进行沟通（中小企业直接与老板沟通），获取对方的邮箱
**b.** 如果老板不在等，请向收件人询问电子邮件地址
提示：通知被叫人紧急情况或作为买方查询老板的电子邮件地址；检查与被叫方的老板电子邮件地址（按照1a，询问他的邮箱是否错误并被退回）
**c.** 致电公司销售人员获取其电子邮件地址，然后以电子邮件格式插入相应的联系人姓名。或与他们核对联系电子邮件是否有问题。
**d.** 如果以上b或c方法均不能确认Boss邮箱，请找一名管理人员并告知他们订单信息已发送给Sales和Boss，但Boss邮箱将返回该信件，需要进行检查。

34）猜邮箱法

名称：猜测联系电子邮件+发送给公司INFO，SALES等的电子邮件
功能：猜测邮箱后，结合使用邮箱身份验证工具，或发送公司的公共邮箱以请求转发
用法：猜猜联系电子邮件。例如，如果老板是史蒂文·利维（Steven Levy），则联系电子邮件可能是：steven.levy@xxx.com;
steven_levy@xxx.com ;
steven@xxx.com ;
stevenl@xxx.com ….
b。发送到公司的公共邮箱，并在电子邮件中写上老板的姓名和职位。
例如，如果老板是史蒂文·利维（Steven Levy），请发送电子邮件至info@xxx.com。it@xxx.com; service@xxx.com…并写信给Dear Steven Levy

**· 邮箱收集工具**

**深维软件开发有限公司**

Google邮箱搜索器（深维软件外贸版）

深维百度邮箱搜索软件

深维超级邮箱搜索软件

深维手机号码搜索软件

深维邮箱填补搜索软件

深维淘宝商家信息采集软件

中国制造网会员信息采集软件

**智动软件 – 辅助优化推广软件提供商**

智动邮件搜索

智动网页内容采集器

**小笨鸟软件**

小笨鸟邮箱采集大师—客户邮件地址email精准搜索软件

小笨鸟手机号码采集大师—客户手机按号段精准搜索软件

**邮件营销大师**

邮箱地址批量验证大师2017

邮箱地址批量验证专家商业版（免费软件）

全网邮箱批量采集工具（支持百度、谷歌、搜狗、360）

邮件营销大师2019

**群发158**

158邮件地址搜索专家

158手机号码搜索专家

社交电子邮件提取器Pro

在线潜在顾客查找器Pro

Encryptomatic MailDex 

**思路：**

根据目标客户关键词搜索目标客户网址，深度搜索网站邮箱，客户域名注册邮箱，社交平台邮箱，数据平台 邮箱，聚合算法邮箱，深度算法邮箱，多种大数据全面抓取有价值邮箱，不仅提取网站本身联系人，更加广泛挖掘社交SNS联系人，逆向批量分析客户邮箱公司名字职位搜索，分析联系人的身份和职位，有效找到CEO和采购负责人，让您高效联系潜在客户；海关数据结合社交平台客户公司详细信息，直接找出决策人采购，精准找到可被钓鱼的人员。

#### **邮件服务入口**

1. 查询域名MX记录找到真实ip,扫描该ip的C段，端口(25、109、110、143、465、995、993)
2. 扫描子域名
3. 搜索引擎、Shodan、fofa、zoomeye搜索 site:target.com intitle:”Outlook Web App” site:target.com intitle:”mail” site:target.com intitle:”webmail”

#### **在线搜索邮件**

https://monitor.firefox.com/breaches 

https://haveibeenpwned.com/ 

https://ghostproject.fr/

https://hunter.io/ 

https://github.com/m4ll0k/Infoga 

http://www.skymem.info/ 

https://smallseotools.com/zh/secure-email/

https://www.email-format.com/i/search/ 

https://github.com/0Kee Team/CatchMail

https://github.com/bit4woo/teemo 

#### **TheHarvester**

TheHarvester 能够收集电子邮件账号、用户名、主机名和子域名等信息

#### **验证账户有效性**

https://mailtester.com/testmail.php

https://github.com/Tzeross/verifyemail

https://github.com/albandum/mailtester  配合https://www.aies.cn/pinyin.htm生成人名字典

https://github.com/pentestmonkey/smtp-user-enum  枚举用户名

https://github.com/busterb/msmailprob    枚举邮箱用户

**没有SPF 直接用swaks伪造**

swaks –to xxxx@qq.com –from info@360.cn –ehlo 360.cn –body welcome –header “Subject: welcome” –header-X-Mailer SMTP –header-Message-Id ‘<51891223094431836868@example.com>’

其中：

- from <要显示的发件人邮箱>
- ehlo <伪造的邮件ehlo头>
- body <邮件正文>
- header <邮件头信息，subject为邮件标题>

**第三方数据可利用地址**

- Google 地图
- Linkedin
- Facebook
- Twitter
- B2B网站
- Facebook
- Skype
- 其他社交媒体：TikTok、Instagram、Line
- 海关数据
- 招聘网站
- QQ
- 微信
- 企业微信
- 钉钉
- 探探
- 微博
- Google、必应、雅虎搜索

**利用关键词seo 分析工具**

https://keywordtool.io/
https://neilpatel.com/ubersuggest/
https://moz.com/ （收费，30天试用）
https://neilpatel.com/ubersuggest/
https://www.wordtracker.com/（收费，2次10条信息免费）
https://www.webceo.com/ （需注册,不限次15条信息免费）
https://www.keyworddiscovery.com/search.html（收费，不限次100条信息免费）
https://www.keywordtooldominator.com/k/google-autocomplete-keyword-tool（收费，每天3次免费搜索）
https://kwfinder.com
https://www.semrush.com
https://googleautosuggest.wordpress.com/

**邮件追踪工具**

- http://www.bananatag.com/email-tracking
- http://www.getnotify.com
- http://www.whoreadme.com
- http://www.ifread.com
- http://www.wasmyemailread.com
- http://www.didtheyreadit.com
- http://www.pointofmail.com
- http://www.msgtag.com

**插件搜索邮箱**

**· SNS中的搜索组合方法**

**名称：**如何在linkedin中查找电子邮件
**网站：**www.linkedin.com
**功能：**

1）可以找出公司的主要KP及其可能的对应邮箱
2）您可以查看其KP的详细信息，这有助于分析和跟进
**用法：**

1）使用产品关键字或已知的公司名称，使用COMPANIES维进行搜索
2）进入其公司页面，然后检查其雇员
3）在EMPLOYEES中找到主要KP，添加为CONNECTION后即可看到其邮箱
4）您也可以使用GOOGLE插件查找邮箱

**· Google插件**

**名称：**RocketReach
**网站：**www.rocketreach.co
**功能：**查找电子邮件（工作电子邮件）+电话号码+完整的个人资料信息+其他活跃的社交平台
**2种方式**
1）直接在他们的网站上使用3 /月
2）直接在LinkedIn上使用5 /月
**用法：**

1）仅通过公司电子邮件注册
2）2种用法。如果要在LinkedIn界面上使用它，则需要下载并安装Google插件（不建议在LinkedIn上使用。它违反了LinkedIn的用户协议）

**· Google插件-获取电子邮件**

**名称：**获取电子邮件
**功能：**

1）在LinkedIn上找到该页面的电子邮件地址（您需要下载该插件，安装成功后它将在浏览器中标记出来），在其标题下打开您要查找的人的个人资料，然后单击图标“获取电子邮件”，它将出现
2）有些不确定是否正确，可以与电子邮件验证工具结合使用
**用法：**

1）在Google App Store中找到并添加后，添加成功后，您将在浏览器中看到此图标；
2）不建议在LinkedIn上使用，因为它违反了LinkedIn的用户协议

**· Google插件-原子电子邮件猎人**

**名称：**原子电子邮件猎人
**功能：**在LinkedIn上找到页面的电子邮件地址（您需要下载插件，安装成功后它将在浏览器中标记），打开要查找的人的个人资料，然后单击图标电子邮件猎人，它会出来
**用法：**

1）在Google App Store中找到并添加后，添加成功后，您将在浏览器中看到此图标；（不建议在LinkedIn Miles上使用，这违反了LinkedIn的用户协议）
2）也可以安装在桌面上以查看客户电子邮件

**· Google插件-FTL（查找线索）**

**名称：**FTL（查找线索）
**功能：**找到线索，twitter.com
**用法：**一旦在Google App Store中找到并添加（不建议在LinkedIn Miles上使用，则违反了LinkedIn的用户协议）

**· Google插件-Lusha（查找电话号码）**

**姓名：**卢莎（电话号码）
**功能：**find email & phone from anywhere on web
**用法：**一旦在Google App Store中找到并添加（不建议在LinkedIn Miles上使用，则违反了LinkedIn的用户协议）

**· Google plugin-snov.io**

**名称：**snov.io
**功能：**从Linkedin个人资料或网站获取电子邮件。使用电子邮件验证程序验证电子邮件，在LinkedIn，Twitter，Facebook或您访问的任何网站上找到潜在客户。
**用法：**

1）在Google App Store中找到并添加后，添加成功后符号S将出现在右上角。打开您想看到的人的LinkedIn个人资料，在右上角的“ S”，“人员列表”，“电子邮件”中单击（不是（建议用于LinkedIn Miles，违反了LinkedIn的用户协议）
2）注册（开箱即用也可以）直接在网站上使用，您可以执行DOMAIN，EMAIL，PROSPECT等6个方面。

### 0x07 Whois 查询

通过whois来对域名信息进行查询，可以查到注册商、注册人、邮箱、DNS解析服务器、注册人联系电话等，因为有些网站信息查得到，有些网站信息查不到，所以推荐以下信息比较全的查询网站，直接输入目标站点即可查询到相关信息。

| **名称**                      | **地址**                                         |
| ----------------------------- | ------------------------------------------------ |
| 站长之家域名WHOIS信息查询地址 | http://whois.chinaz.com/                         |
| 爱站网域名WHOIS信息查询地址   | https://whois.aizhan.com/                        |
| 腾讯云域名WHOIS信息查询地址   | https://whois.cloud.tencent.com/                 |
| 美橙互联域名WHOIS信息查询地址 | https://whois.cndns.com/                         |
| 爱名网域名WHOIS信息查询地址   | https://www.22.cn/domain/                        |
| 易名网域名WHOIS信息查询地址   | https://whois.ename.net/                         |
| 中国万网域名WHOIS信息查询地址 | https://whois.aliyun.com/                        |
| 西部数码域名WHOIS信息查询地址 | https://whois.west.cn/                           |
| 新网域名WHOIS信息查询地址     | http://whois.xinnet.com/domain/whois/index.jsp   |
| 纳网域名WHOIS信息查询地址     | http://whois.nawang.cn/                          |
| 中资源域名WHOIS信息查询地址   | https://www.zzy.cn/domain/whois.html             |
| 三五互联域名WHOIS信息查询地址 | https://cp.35.com/chinese/whois.php              |
| 新网互联域名WHOIS信息查询地址 | http://www.dns.com.cn/show/domain/whois/index.do |
| 国外WHOIS信息查询地址         | https://who.is/                                  |

### 0x08 在线网站备案查询

| **名称**             | **地址**                    |
| -------------------- | --------------------------- |
| 小蓝本               | https://www.xiaolanben.com/ |
| 天眼查               | https://www.tianyancha.com/ |
| ICP备案查询网        | http://www.beianbeian.com/  |
| 爱站备案查询         | https://icp.aizhan.com      |
| 域名助手备案信息查询 | http://cha.fute.com/index   |
| 企查查               | https://www.qcc.com/        |

### 0x09 查找真实IP

> 多地ping、nslookup、DNS 历史查询、查找子域名、反向连接、利用SSL证书寻找真实IP、国外解析域名、漏洞利用、目标敏感文件泄露、扫描全网、从 CDN 入手、利用HTTP标头寻找真实原始IP、利用网站返回的内容寻找真实原始IP、F5 LTM解码法

**DNS解析与Whois 查询意义何在？**

（1）DNS解析记录可以反查IP，比较早的解析记录有时可以查到真实IP，需要留意一下。

（2）注册人电话，注册人邮箱等社工信息可以钓鱼或者收集进字典来爆破目标办公系统。

**为何需要收集子域名？** 

收集子域名可以扩大测试范围，同一域名下的二级域名都属于目标范围。

- 常用方式

子域名中的常见资产类型一般包括办公系统，邮箱系统，论坛，商城等，其他管理系统，网站管理后台等较少出现在子域名中。

首先找到目标站点，在官网中可能会找到相关资产（多为办公系统，邮箱系统等），关注一下页面底部，也许有管理后台等收获。 

**查找目标域名信息的方法：**

| **名称**                           | **用法或地址**                                               |
| ---------------------------------- | ------------------------------------------------------------ |
| FOFA                               | title=”公司名称”                                             |
| 钟馗之眼                           | site=域名即可                                                |
| 百度                               | intitle=公司名称                                             |
| Google                             | intitle=公司名称                                             |
|                                    |                                                              |
| FOFA搜索子域名                     | https://fofa.so/ 语法：domain=”baidu.com”                    |
| Hackertarget查询子域名             | https://hackertarget.com/find-dns-host-records/   注意：查询子域名可以得到一个目标大概的ip段，接下来可以通过ip来收集信息。 |
| 站长之家，直接搜索名称或者网站域名 | http://tool.chinaz.com/                                      |
| 钟馗之眼，直接搜索名称或网站名称   | https://www.zoomeye.org/                                     |

**第三方子域名查询**

| **名称**             | **地址**                                                     |
| -------------------- | ------------------------------------------------------------ |
| 子域名在线查询       | https://phpinfo.me/domain/                                   |
| 子域名在线查询       | https://www.t1h2ua.cn/tools/                                 |
| IP138查询子域名      | https://site.ip138.com/baidu.com/domain.htm                  |
| Layer子域名挖掘机4.2 | https://www.webshell.cc/6384.html                            |
| Layer子域名挖掘机5.0 | https://pan.baidu.com/s/1wEP_Ysg4qsFbm_k1aoncpg 提取码：uk1j |
| SubDomainBrute       | https://github.com/lijiejie/subDomainsBrute                  |
| Sublist3r            | https://github.com/aboul3la/Sublist3r                        |

**假设：如果目标网站使用了CDN，该如何找到真实IP?**

**注意：**很多时候，主站虽然是用了CDN，但子域名可能没有使用CDN，如果主站和子域名在一个ip段中，那么找到子域名的真实IP也是一种途径，而且说不定子域名IP的C段就存在主域名的真实IP。

**1. 部分收集真实IP**

####  **1) 多地ping**

如果多地ping同一网站，出现多个解析IP地址，那么说明使用了CDN进行内容分发~

- http://www.baidu.com

可以看到解析到10多个IP地址，猜测应该是使用了CDN 

**IP 信息收集网址**

| **网址**                                 | **作用**                 |
| ---------------------------------------- | ------------------------ |
| http://whois.chinaz.com/                 | Whois查询                |
| http://tool.chinaz.com/                  | 站长工具                 |
| https://dns.aizhan.com/                  | 爱站网 ping检测 ip反查域 |
| https://x.threatbook.cn/                 | 微步在线                 |
| https://toolbar.netcraft.com/site_report | 网站查询                 |
| http://tool.chinaz.com/nslookup          | DNS 服务器解析           |
| http://ping.chinaz.com/ping.chinaz.com   | 多地ping 检查dns是否存在 |
| https://phpinfo.me/bing.php              | 在线旁站查询 c段         |
| http://s.tool.chinaz.com/same            | 同ip查旁站               |
| https://www.reg007.com/                  | 个人邮箱注册查询         |

**windows 系统对应的内核版本和自带 iis 版本**

| Windows 10                | 10.0* |
| ------------------------- | ----- |
| Windows Server 2016       | 10.0* |
| Windows 8.1               | 6.3*  |
| Windows Server 2012 R2    | 6.3*  |
| Windows 8                 | 6.2   |
| Windows Server 2012       | 6.2   |
| Windows 7                 | 6.1   |
| Windows Server 2008 R2    | 6.1   |
| Windows Server 2008       | 6.0   |
| Windows Vista             | 6.0   |
| Windows Server 2003 R2    | 5.2   |
| Windows Server 2003       | 5.2   |
| Windows XP 64-Bit Edition | 5.2   |
| Windows XP                | 5.1   |
| Windows 2000              | 5.0   |

> Windows 2000 Server→IIS5.0 Windows XP SP1→IIS5.0 Windows XP SP2,SP3→IIS5.1 Windows Server 2003，xp porfessional →IIS6.0 Windows Vista Ultimate→IIS7.0 Windows 7→iis7, iis7.5 Windows server2008 sp2 sp3 → iis7.0 Windows server2008 R2 ,部分win7→iis7.5 Windows server2008 sp2 sp3 → iis7.0 Windows server2012 ,windows 8 →iis8.0 Windows server2012 r2 →iis8.5 windows server 2016 ,windows 10 →iis10

####  **2) nslookup**

使用nslookup查看域名解析对应的IP地址 

#### 3) DNS 历史查询

**查看IP与域名绑定的历史记录，有可能会存在使用CDN前的记录信息**

**·** DNS历史：https://completedns.com/dns-history/

**·** 域历史记录检查器：https://whoisrequest.com/history/

**·** 世界上最大的DNS库：https://securitytrails.com/dns-trails

**·** WHOIS搜索，域名，网站，和IP工具- WHOIS：https://who.is/

**·** 托管历史|过去的IP, DNS，注册商信息|域名工具：https://research.domaintools.com/research/hosting-history/

**·** 全球DNS搜索引擎：https://dnsdb.io/zh-cn/

**·** 网站全国各地Ping值测试|在线ping工具—卡卡网：http://www.webkaka.com/ping.aspx

**·** CA应用合成监控网站监控服务- Ping – IPv6：https://asm.ca.com/en/ping.php iphistory：https://viewdns.info/iphistory/

**·** DNS查询：https://dnsdb.io/zh-cn/

**·** 微步在线：https://x.threatbook.cn/

**·** 域名查询：https://site.ip138.com/

**·** Netcraft：https://sitereport.netcraft.com/?url=github.com

**·** CDN Finder工具：https://www.cdnplanet.com/tools/cdnfinder/

**通过大量DNS查漏** 查询冷门的DNS的解析或者多地Ping

全球多地ping

| http://ce.cloud.360.cn/          |
| -------------------------------- |
| http://www.webkaka.com/ping.aspx |
| https://asm.ca.com/en/ping.php   |

#### **4)查找子域名**

很多时候，站长都喜欢对主站或者流量大的子站点加 CDN，很多小站点又跟主站在同一台服务器或者同一个C段内，一些重要的站点会做CDN，而一些子域名站点并没有加入CDN，而且跟主站在同一个C段内，这时候，就可以通过查找子域名来查找网站的真实IP。

常用的子域名查找方法和工具：

**1、搜索引擎查询：**如Google、baidu、Bing等传统搜索引擎，site:baidu.com inurl:baidu.com，搜target.com|公司名字。

**2、一些在线查询工具**

如：

http://tool.chinaz.com/subdomain/

http://i.links.cn/subdomain/  

http://subdomain.chaxun.la/

http://searchdns.netcraft.com/

https://www.virustotal.com/

**3、 子域名爆破工具**

Layer子域名挖掘机

wydomain：https://github.com/ring04h/wydomain   

subDomainsBrute：https://github.com/lijiejie/

Sublist3r：https://github.com/aboul3la/Sublist3r

#### **5) 反向连接**

让服务器主动连接我们告诉我们它的IP，如RSS邮件订阅、邮箱注册、邮箱密码找回等，很多网站都自带sendmail，通过网站给自己发送邮件，从而让目标主动暴露他们的真实的IP，查看邮件头信息，获取到网站的真实IP。

####  **6) 利用SSL证书寻找真实IP**

证书颁发机构(CA)必须将他们发布的每个SSL/TLS证书发布到公共日志中，SSL/TLS证书通常包含域名、子域名和电子邮件地址。因此SSL/TLS证书成为了攻击者的切入点。

**SSL证书搜索引擎：**

https://censys.io/ipv4?q=github.com

https://transparencyreport.google.com/

https/certificates?hl=zh_CN

https://www.chinassl.net/ssltools/ssl-checker.html

####  **7) 国外解析域名**

国内很多 CDN 厂商因为各种原因只做了国内的线路，而针对国外的线路可能几乎没有，此时我们使用国外的DNS查询，很可能获取到真实IP。

**国外多PING测试工具：**

https://asm.ca.com/zh_cn/ping.php

http://host-tracker.com/

http://www.webpagetest.org/

https://dnscheck.pingdom.com/

####  **8) 漏洞利用**

利用漏洞目标服务器主动来连接我们，知道真实IP后，可以实施比如SSRF、XSS盲打，命令执行反弹shell等等。

####  **9) 目标敏感文件泄露**

也许目标服务器上存在一些泄露的敏感文件中会告诉我们网站的IP，另外就是如 phpinfo之类的探针了。

**例如：**配置CDN的时候，需要指定域名、端口等信息，有时候小小的配置细节就容易导致CDN防护被绕过。

**案例1：**为了方便用户访问，我们常常将`www.test.com` 和 `test.com` 解析到同一个站点，而CDN只配置了www.test.com，通过访问test.com，就可以绕过 CDN 了。

**案例2：**站点同时支持http和https访问，CDN只配置 https协议，那么这时访问http就可以轻易绕过。

####  **10) 扫描全网**

通过Zmap、masscan等工具对整个互联网发起扫描，针对扫描结果进行关键字查找，获取网站真实IP。

ZMap：https://github.com/zmap/zmap

Masscan：https://github.com/robertdavidgraham/masscan

####  **11) 从 CDN 入手**

无论，是用社工还是其他手段，反正是拿到了目标网站管理员在CDN的账号了，此时就可以自己在CDN的配置中找到网站的真实IP了。

####  12) 利用HTTP标头寻找真实原始IP

当我们知道一个拥有非常特别的服务器名称与软件名称时，可以通过HTTP标头来寻找真实IP。

> Censys 是一款用以搜索联网设备信息的新型搜索引擎，安全专家可以使用它来评估他们实现方案的安全性，而黑客则可以使用它作为前期侦查攻击目标、收集目标信息的强大利器。Censys 搜索引擎能够扫描整个互联网，Censys 每天都会扫描IPv4地址空间，以搜索所有联网设备并收集相关的信息，并返回一份有关资源（如设备、网站和证书）配置和部署信息的总体报告。

censys：https://censys.io/

查找由CloudFlare提供服务的网站的参数的网站有哪些

#### 13) 利用网站返回的内容寻找真实原始IP

浏览网站源代码，寻找独特的代码片段。在JavaScript中使用具有访问或标识符参数的第三方服务（例如Google Analytics，reCAPTCHA）是攻击者经常使用的方法。

以下是从HackTheBox网站获取的Google Analytics跟踪代码示例：

ga（’create’，’UA-93577176-1’，’auto’）; 可以使用80.http.get.body：参数通过body/source过滤Censys数据，不幸的是，正常的搜索字段有局限性，但你可以在Censys请求研究访问权限，该权限允许你通过Google BigQuery进行更强大的查询。

Shodan是一种类似于Censys的服务，也提供了http.html搜索参数。

搜索示例：https://www.shodan.io/search?query=http.html%3AUA-32023260-1

#### 14) 利用网站返回的内容寻找真实原始IP

浏览网站源代码，寻找独特的代码片段。在JavaScript中使用具有访问或标识符参数的第三方服务（例如Google Analytics，reCAPTCHA）是攻击者经常使用的方法。

以下是从HackTheBox网站获取的Google Analytics跟踪代码示例：

ga（’create’，’UA-93577176-1’，’auto’）; 可以使用80.http.get.body：参数通过body/source过滤Censys数据，不幸的是，正常的搜索字段有局限性，但你可以在Censys请求研究访问权限，该权限允许你通过Google BigQuery进行更强大的查询。

Shodan是一种类似于Censys的服务，也提供了http.html搜索参数。

搜索示例：https://www.shodan.io/search?query=http.html%3AUA-32023260-1

#### 15) F5 LTM解码法

服务器使用F5 LTM做负载均衡时，通过对set-cookie关键字的解码真实ip也可被获取

**例如：**

> Set-Cookie: BIGipServerpool_8.29_8030=487098378.24095.0000，先把第一小节的十进制数即487098378取出来，然后将其转为十六进制数1d08880a，接着从后至前，以此取四位数出来，也就是0a.88.08.1d，最后依次把他们转为十进制数10.136.8.29，也就是最后的真实ip。

**2. phpinfo、旁站和C段**

如果目标网站存在phpinfo泄露等，可以在phpinfo中的SERVER_ADDR或_SERVER[“SERVER_ADDR”]找到真实IP。

旁站往往存在业务功能站点，建议先收集已有IP的旁站，再探测C段，确认C段目标后，再在C段的基础上再收集一次旁站。

旁站是和已知目标站点在同一服务器但不同端口的站点，通过以下方法搜索到旁站后，先访问一下确定是不是自己需要的站点信息。

**PS：不是所有C段都是该目标服务器的，可能只是某个范围是或切割多个范围才属于该目标范围的IP段，建议先收集已有IP的旁站，再探测C段，当然有些C段，你别傻不拉几的用Goby或漏扫直接扫，有些有WAF，你线程一大就封你IP，扫或不扫，根据现场测试业务环境决定。**

\3. 网络空间搜索引擎 如FOFA搜索旁站和C段 Nmap,Msscan扫描等

**例如：**nmap -p 80,443,8000,8080 -Pn 192.168.0.0/24**网络空间搜索引擎**

> 如果想要在短时间内快速收集资产，那么利用网络空间搜索引擎是不错的选择，可以直观地看到旁站，端口，站点标题，IP等信息，点击列举出站点可以直接访问，以此来判断是否为自己需要的站点信息。
>
> FOFA的常用语法
>
> 1、同IP旁站：ip=”192.168.0.1”
>
> 2、C段：ip=”192.168.0.0/24”
>
> 3、子域名：domain=”baidu.com”
>
> 4、标题/关键字：title=”百度”
>
> 5、如果需要将结果缩小到某个城市的范围，那么可以拼接语句 title=”百度”&& region=”Beijing”
>
> 6、特征：body=”百度”或header=”baidu”

**扫描敏感目录/文件**

> 扫描敏感目录需要强大的字典，需要平时积累，拥有强大的字典能够更高效地找出网站的管理后台，敏感文件常见的如.git文件泄露，.svn文件泄露，phpinfo泄露等，这一步一半交给各类扫描器就可以了，将目标站点输入到域名中，选择对应字典类型，就可以开始扫描了，十分方便
>
> 1、御剑  https://www.fujieace.com/hacker/tools/yujian.html
>
> 2、7kbstorm  https://github.com/7kbstorm/7kbscan-WebPathBrute
>
> 3、bbscan   https://github.com/lijiejie/BBScan
>
> 4、dirmap   https://github.com/H4ckForJob/dirmap
>
> 5、dirsearch   https://github.com/maurosoria/dirsearch
>
> 6、Github搜索

------

### 0x10 指纹识别

收集网站信息，对网站进行指纹识别，通过识别指纹，确定目标的cms及版本

| **名称**                         | **地址**                                   |
| -------------------------------- | ------------------------------------------ |
| 云悉                             | http://www.yunsee.cn/info.html             |
| 潮汐指纹                         | http://finger.tidesec.net/                 |
| bugscaner CMS指纹识别            | http://whatweb.bugscaner.com/look/         |
| Wappalyzer 指纹识别 (浏览器插件) | https://github.com/AliasIO/wappalyzer      |
| GodEye Web指纹识别平台           | https://www.godeye.vip/                    |
| WhatWeb ruby写的Web指纹识别工具  | https://github.com/urbanadventurer/WhatWeb |
| 数字观星指纹平台                 | https://fp.shuziguanxing.com/#/            |

### 0x11 威胁情报平台

| **名称**                           | **地址**                                                   |
| ---------------------------------- | ---------------------------------------------------------- |
| 微步在线 威胁情报社区              | https://x.threatbook.cn/                                   |
| 奇安信 威胁情报中心                | https://ti.qianxin.com/                                    |
| VenusEye 威胁情报中心              | https://www.venuseye.com.cn/                               |
| 绿盟科技 威胁情报云                | https://ti.nsfocus.com/                                    |
| IBM 情报中心                       | https://exchange.xforce.ibmcloud.com/                      |
| 天际友盟 安全智能服务平台          | https://redqueen.tj-un.com/IntelHome.html                  |
| 华为安全中心平台                   | https://isecurity.huawei.com/sec/web/intelligencePortal.do |
| 安恒威胁情报中心                   | https://ti.dbappsecurity.com.cn/                           |
| 360 威胁情报中心                   | https://ti.360.cn/                                         |
| 世界上第一个真正的开放威胁情报社区 | https://otx.alienvault.com/                                |
| 丁爸 情报分析师的工具箱            | http://dingba.top/                                         |
| 听风者情报源 start.me              | https://start.me/p/X20Apn                                  |

------

### 0x12 账号/密码/数据泄漏情况查询网站

| **名称**                                                     | **地址**                     |
| ------------------------------------------------------------ | ---------------------------- |
| reg007 你注册过哪些网站？                                    | https://www.reg007.com/      |
| Firefox 电子邮件泄漏查询                                     | https://monitor.firefox.com/ |
| haveibeenpwned 检查电子邮件是否泄漏过                        | https://haveibeenpwned.com/  |
| Dehashed 通过用户名、邮箱、地址搜索是否存在泄漏              | https://dehashed.com/        |
| Aleph 查询公共记录和泄漏信息                                 | https://aleph.occrp.org/     |
| SnusBase 最长的数据泄露搜索引擎                              | https://snusbase.com/        |
| vigilante.pw 搜索数据泄露事件                                | https://vigilante.pw/        |
| CheckUsernames 在160个社交网络上检查您的品牌或用户名的使用情况 | https://checkusernames.com/  |

### 0x13 匿名邮箱/一次性邮箱/短信/隐私短信

| **名称**                                                     | **地址**                     |
| ------------------------------------------------------------ | ---------------------------- |
| ProtonMail:免费的加密电子邮箱                                | https://mail.protonmail.com/ |
| mfk.app 免费临时电子邮件地址                                 | https://www.8164.cc/         |
| Temp Mail – 临时性 – 匿名电子邮件                            | https://temp-mail.org/       |
| chacuo.net 临时邮箱、临时邮、临时电子邮箱、24小时邮箱  隐私短信 在线短信验证码接收码平台 | http://24mail.chacuo.net/    |
| 云简讯验证码接收平台                                         | https://www.bfkdim.com/      |

### 0x14 密码破解/密码生成/MD5破解/MD5加密类网站

| **名称**                                     | **地址**                               |
| -------------------------------------------- | -------------------------------------- |
| CMD5 md5在线解密破解,md5解密加密             | https://www.cmd5.com/                  |
| SOMD5 MD5在线免费解密平台                    | https://www.somd5.com/                 |
| 猜密码 输入目标信息 猜测可能使用的密码       | https://www.hacked.com.cn/pass.html    |
| hashC 是完美的在线破解服务网站               | https://hashc.co.uk/                   |
| CrackStation – Online Password Hash Cracking | https://crackstation.net/              |
| Online Password Recovery 在线密码恢复        | https://passwordrecovery.io/           |
| 在线随机密码生成工具                         | https://www.hacked.com.cn/password.php |
| sojson MD5在线加密/解密/破解—MD5在线         | https://www.sojson.com/md5/            |

### 0x15 一些在线的命令生成网站,比如反弹shell命令，下载文件命令等

| **名称**                                     | **地址**                                            |
| -------------------------------------------- | --------------------------------------------------- |
| 在线反弹shell命令生成                        | https://forum.ywhack.com/reverse-shell/             |
| File Download Generator 文件下载快捷命令生成 | https://file-downloads.com/                         |
| java.lang.Runtime.exec() Payload Workarounds | http://java.lang.Runtime.exec() Payload Workarounds |
| Hacking8 备忘录                              | https://www.hacking8.com/cheatsheet                 |
| 草料二维码生成器                             | https://cli.im/                                     |

### 0x16 在线提权辅助工具或一些提权相关的漏洞

| **名称**                                                | **地址**                                                  |
| ------------------------------------------------------- | --------------------------------------------------------- |
| hacking8 Windows提权辅助工具                            | https://viewdns.info/reverseip/                           |
| Kernelhub – Windows 提权漏洞合集(带有编译环境/详细说明) | https://github.com/Ascotbe/Kernelhub                      |
| DazzleUP – 一款win下辅助提权的小工具                    | https://github.com/hlldz/dazzleUP                         |
| wesng – Windows利用辅助工具                             | https://github.com/bitsadmin/wesng                        |
| Windows-Exploit-Suggester Windows提权辅助               | https://github.com/AonCyberLabs/Windows-Exploit-Suggester |
| windows-kernel-exploits Windows平台提权漏洞集合         | https://github.com/SecWiki/windows-kernel-exploits        |
| linux-kernel-exploits Linux平台提权漏洞集合             | https://github.com/SecWiki/linux-kernel-exploits          |

### 0x17 SSL/TLS证书查询

SSL/TLS证书通常包含域名、子域名和邮件地址等信息，结合证书中的信息，可以更快速地定位到目标资产，获取到更多目标资产的相关信息。

| **名称**                 | **地址**                                |
| ------------------------ | --------------------------------------- |
| 亚洲诚信-SSL/TLS安全评估 | https://myssl.com/                      |
| AUTO-EARN                | https://github.com/Echocipher/AUTO-EARN |

### 0x18 OSINT调查平台工具

| **名称**         | **地址**                                                     |
| ---------------- | ------------------------------------------------------------ |
| iKy              | https://kennbroorg.gitlab.io/ikyweb/PS：电子邮件收集信息并以漂亮的可视界面显示结果的工具 |
| Boardreader      | https://boardreader.com/ PS：搜索全球各个论坛平台的内容。    |
| blackhat线上会议 | https://www.blackhat.com/us-20/briefings/schedule/           |
| CTFR             | https://github.com/UnaPibaGeek/ctfr 滥用证书透明度日志，允许在几秒钟内获取子域。 |
| DNS 聚合器       | https://dnsdumpster.com/                                     |

### 0x19 其它信息收集

互联网上的信息和数据不断更新，每天都会产生新的信息。面对互联网上海量的信息，如何收集民意，如何收集民意信息是一个难题。

**那么我们是否能借助舆情信息收集方面的技术来帮我们快速定位相关企业的威胁情报方面的重要信息呢？**

**1、从媒体收集信息**

  国内外媒体信息来源非常广泛，尤其是网络媒体信息，传输速度快，周转环节少。此外，媒体报道的信息往往是尖锐和及时的。因此，舆论信息的收集可以从媒体开始，划分不同类型的媒体，然后针对不同类型的媒体，分类别进行收集。

**2、运用舆论监督系统进行收集**

  因为网上的信息种类很多，收集舆论需要很多工作和一定的人力物资。因此，这项工作不能只靠人力来完成。可以使用智能网络舆论来确保网络舆论信息的客观、可靠性、正确的收集网络舆情监测系统工具来设置要监测的主题或关键词，系统将自动监测和收集与整个网络相关的信息，使相关部门和单位能够快速、直观地获取所需的数据和信息内容。

**3、实时监控互联网平台信息**

  突发公共舆论事件通常是由于未及时发现公共舆论信息或未能收集公共舆论监测而造成的。因此，为了及时收集公众意见，我们必须首先确保能够准确掌握公众意见。为了确保快速、准确、准确和完整地收集公众意见，一些舆情监控系统工具还可以实时监控主要权威新闻媒体、主流门户网站、论坛、博客、数字报纸、行业垂直网站、新闻客户端等平台的互联网信息，从而深入准确地分析舆情发展趋势，找到解决问题的关键。

**4、推荐类似微热点舆情通的软件**

自己写爬虫来解决，但是这个想法精力占用较大，作为一个白嫖党，当然是现场马上能用的最香咯！自己写一个舆情监控系统？我这个编程水平还不够，就是可以，也没这么大的精力！

那么换个方面，自己写比较麻烦！那么网上是不是有写好的舆情监控系统？（免费的！免费是重点，圈起来要考的！）好的！我们打开百度！

#### **金石舆情监测系统**

舆情监测范围包含各大新闻门户网站、论坛、贴吧、博客、微博、文档、视频等。您还可以自定义网站采集监测。系统具有类同信息分析、追踪信息源头、制作舆情专题报告的功能。系统能自动预警，自动生成舆情报告 。

#### **马克斯舆情监测(免费版)**

马克斯舆情监测免费版，所有用户每天可以使用系统一次，每日24点刷新。中级版用户的查询次数为10次/天，价格为199元/月高级版不仅将用户每日查询次升级为100次/天,价格为1999元/月

项目地址：http://www.gg360.cn/

#### **中科微步**

项目地址：http://www.vbu.cn/

#### **微步商情**

这个注册最难注册，试了好多接码平台，也可以白嫖免费版的

项目地址：http://e.vbu.cn/#/

#### **探索者互联网舆情监测系统(免费)**

搭建在自身系统上面的舆情监控系统

http://www.ourgogo.net/articles.aspx?id=70

#### **舆情录**

免费使用，但有限制，即使关键字组合只能是1个

项目地址：http://www.yuqinglu.com/index.html

#### **脉讯互联网传播管理平台**

免费版有限制，可以白嫖就对了

项目地址：http://platform.maixunbytes.com/

#### **瞬速互联网舆情监测系统(免费)**

一款功能强大、简单实用的互联网情报采集、监控、跟踪与分析的软件。可以时刻监测互联网上最新的新闻、博客、论坛等与您相关的资讯信息。软件提供多种舆情监测功能，网站跟踪、论坛跟贴、全网监测、可以无遗漏地满足了目前互联网信息监测所必需的作业模式。

PS：试用期一个月

#### **瞬速网络信息采集系统(免费)**

瞬速网络信息采集系统是一套互联网信息采集软件。软件基于人工智能的自动学习技术，只要输入目标网站的网址就可以自动监测并采集目标网站上最新的资讯信息，自动过滤掉无关的信息（如广告信息、版权信息等）达到了所采即所得的效果。同时，自动识别与资讯信息相关的图片、附件等感兴趣的媒体资源，并可根据设置自动采集到本地或是建立映射快照。除了满足新闻信息的智能采集外，软件可以根据业务需求在软件上自定义配置相应的业务规则，软件可以满足大数据、多分类、跨网站下的多维度的数据采集（如房产信息、求职招聘、汽车数据等）与数据分类管理等。

PS：试用期7天

### 0x20 搜索引擎收集的所有资产

如上标题里说的资产，不是普通定义中的资产，而是信息收集里面的企业信息资产。

**ICMP存活探测–>端口开放探测–>端口指纹服务识别–>提取快照(若为WEB)–>搜索网页敏感内容(邮箱、手机号、URL)–>生成结果报表**

**此处为什么会这么讲呢？**

因为，随着企业内部业务的不断壮大，各种业务平台和管理系统越来越多，很多单位往往存在着“隐形资产”，这些“隐形资产”通常被管理员所遗忘，长时间无人维护，导致存在较多的已知漏洞。
在渗透测试中，我们需要尽可能多的去收集目标的信息，资产探测和信息收集，决定了你发现安全漏洞的几率有多大。如何最大化的去收集目标范围，尽可能的收集到子域名及相关域名的信
息，这对我们进一步的渗透测试显得尤为重要。

**APP、媒体公众号等收集**

通过百家号、微博、抖音、快手、哔哩哔哩等媒体公众号，可以收集到员工的账号。或是不小心泄露出来的一些web服务。当收集到qq群这种信息时还可以”潜伏”到qq群，qq群文件可能会包含一些敏感的信息。这方面的信息收集能够帮助我们在漏洞利用时构造一些参数值或是进行暴力破解等等。

随着移动端的兴起，很多单位都有自己的移动APP、微信公众号、支付宝生活号等，这也是值得重点关注的点。

通过对APP流量的抓取也可以获取到部分子域名或者ip。

http://www.zyzilxy.top:1220/?p=5328

**行业系统**

- 同行业可能存在类似的系统，甚至于采用同一家厂商的系统，可互做对比
- 通用：办公OA、邮件系统、VPN等
- 医院：门户、预约系统、掌上医院、微信公众平台等

而关于信息收集，主要就是在资产收集之后，针对单个站点的信息进行收集，主要围绕服务器ip，域名，网站等.

对于更高阶的安全从业人员来说，可以结合威胁情报，对红队人员进行针对性溯源。

对于企业的运维人员来说，可以结合流量日志，对IP信誉进行碰撞，发现隐藏的攻击IP。

对于红队人员来说，可以结合威胁情报搜索攻击资产，从而不必使用目录爆破方式进行批量的爆破，费时费力（有的子目录的名字不好猜，通过爆破目录工具也拿不到）。

有时主站实在弄不动，其实也可以去收集情报，意思就是说：收集主站官网上发布的相关情报信息进行汇总，说不定会有额外的发现。

**例如：**某Ax集团从2017年开始改名为某AX1集团。但我们分配下来的目标时拿到的目标单位名称是某AX1集团，那么我们猜测，去信息收集相关的某Ax集团资产信息（有些忘记改网站名称，甚至有可能一直使用之前该名称之前的单位名称），我们也可以拿到足够多的情报后，制作针对性的钓鱼邮件，网上收集相关的目标单位的在职人员的邮箱，进行钓鱼

对于女生来说，可以使用情报对男朋友进行溯源。

#### 参考链接：

[https://mp.weixin.qq.com/s/VJCPAluqz8YDyCxE8HZtdQ](https://mp.weixin.qq.com/s?__biz=MzIyMjkzMzY4Ng==&mid=2247484510&idx=1&sn=f0a5496cc6107eca3bebfbf3c42b8961&scene=21#wechat_redirect)

[https://mp.weixin.qq.com/s/SwnFnn9kB-_3fSLvFS5bVQ](https://mp.weixin.qq.com/s?__biz=Mzg5MDQyMzg3NQ==&mid=2247483727&idx=1&sn=1409142a332f131ed5a2e25c79451583&scene=21#wechat_redirect)

[https://mp.weixin.qq.com/s/hZ47n0SgycWxf2lWoRp1ZQ](https://mp.weixin.qq.com/s?__biz=Mzg5MDQyMzg3NQ==&mid=2247483746&idx=1&sn=f07c15c92396a72a047afee7557175a4&scene=21#wechat_redirect)

[https://mp.weixin.qq.com/s/4SIxsPoIICxHxZYs64I5vw](https://mp.weixin.qq.com/s?__biz=MjM5MDkwNjA2Nw==&mid=2650375228&idx=2&sn=8f2cbe1798b63a26f4f3eed17d57ff39&scene=21#wechat_redirect)

https://mp.weixin.qq.com/s/QDarNtl9yPjGl8u2QQ2QRA

