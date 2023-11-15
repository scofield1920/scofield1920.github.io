# sqlmap常用命令


## sqlmap简介：

- sqlmap是一款开源免费的漏洞检查、利用工具.
- 可以检测页面中get,post参数,cookie,http头等.
- 可以实现数据榨取
- 可以实现文件系统的访问
- 可以实现操作命令的执行
- 还可以对xss漏洞进行检测

## sqlmap 支持5种漏洞检测类型:

- 基于布尔的盲注检测 (如果一个url的地址为xxxx.php?id=1,那么我们可以尝试下的加上 and 1=1(和没加and1=1结果保持一致) 和 and 1=2(和不加and1=2结果不一致),则我们基本可以确定是存在布尔注入的. )
- 基于时间的盲注检测(和基于布尔的检测有些类似.通过mysql的 sleep(int)) 来观察浏览器的响应是否等待了你设定的那个值 如果等待了,则表示执行了sleep,则基本确定是存在sql注入的
- 基于错误的检测 (组合查询语句,看是否报错(在服务器没有抑制报错信息的前提下),如果报错 则证明我们组合的查询语句特定的字符被应用了,如果不报错,则我们输入的特殊字符很可能被服务器给过滤掉(也可能是抑制了错误输出.))
- 基于union联合查询的检测(适用于如果某个web项目对查询结果只展示一条而我们需要多条的时候 则使用union联合查询搭配concat还进行获取更多的信息)
- 基于堆叠查询的检测(首先看服务器支不支持多语句查询,一般服务器sql语句都是写死的,某些特定的地方用占位符来接受用户输入的变量,这样即使我们加and 也只能执行select(也不一定select,主要看应用场景,总之就是服务端写了什么,你就能执行什么)查询语句,如果能插入分号;则我们后面可以自己组合update,insert,delete等语句来进行进一步操作)

## option类：

　　　　sqlmap --version  　　　查看sqlmap版本信息.

　　　　-h　　　　　　　 　　　查看功能参数(常用的)

　　　　-hh　　　　　　　　　　  查看所有的参数 (如果有中文包 就最好了)

　　　　-v　　　　　　　　　　　 显示更详细的信息 一共7级, 从0-6.默认为1, 数值越大,信息显示越详细.

​    Target(指定目标):

　　　　-d　　　　　　　　　　　 直接连接数据库侦听端口,类似于把自己当一个客户端来连接.

　　　　-u　　　　　　　　　　   指定url扫描,但url必须存在查询参数. 例: xxx.php?id=1 

　　　　-l　　　　　　　　　　　　指定logfile文件进行扫描,可以结合burp 把访问的记录保存成一个log文件, sqlmap可以直接加载burp保存到log文件进行扫描

　　　　-x　　　　　　　　　　　　以xml的形式提交一个站点地图给sqlmap(表示不理解..)

　　　　-m　　　　　　　　　　　　如果有多个url地址,可以把多个url保存成一个文本文件 -m可以加载文本文件逐个扫描

　　　　-r　　　　　　　　　　　　把http的请求头,body保存成一个文件 统一提交给sqlmap,sqlmap会读取内容进行拼接请求体

　　　　-g　　　　　　　　　　　　利用谷歌搜索引擎搭配正则来过滤你想要的

　　　　-c　　　　　　　　　　　　加载配置文件,配置文件可以指定扫描目标,扫描方式,扫描内容等等.加载了配置文件sqlmap就会根据文件内容进行特定的扫描

## 扫描类型：

### get扫描：

　　-u 指定一个带参数的url地址进行扫描.

　　-p 只对特定的参数进行扫描(我们知道,page等是用不到的,在这串url中,只有password和username是有价值的信息,所以我们只对username进行扫描)

### post扫描：

sqlmap 支持2种post 扫描：

1.请求文件.
2.busp suite log文件

对于第一种请求文件扫描，将bp的抓包流量保存到txt，然后：

```
sqlmap -r request.txt -f 
```

另一种就是通过加载burp suite的日志文件进行扫描注入：

```
sqlmap -l xxx.txt -f --dbs ... 
```

![image-20230514223637792](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20230514223637792.png)

## Request类参数：

　　　　--data　　　　　　　　　提交的时候要携带的参数. (get,post通用,最简单的post请求方式).　

　　　　--users　　　　　　　　 获取数据库用户

　　　　--dbs　　　　　　　　　 获取所以数据库

　　　　--param-del　　　　　　 变量分隔符,默认为&,

　　　　--cookie　　　　　　　　设置cookie头

　　　　--user-agent　　　　　　指定user-agent(防止对方服务器侦测到)

　　　　--random-agent　　　　 随机agent

　　　　--host　　　　　　　　 指定host头

　　　　--level　　　　　　　　安全级别 (1-5, >=3,检测anent,>=5,检测host头)

　　　　--referer　　　　　　  指定referer头(level >=3才检测)

　　　　--headers　　　　　　 指定额外的headers请求头(多个必须使用换\n,首字母必须大写)

　　　　--method　　　　　　 指定请求方式, 默认为get,get请求不成功尝试post

　　　　--auth-type　　　　　　身份认证类型 (Basic,Digest,NTLM) ,

　　　　--auth-cred　　　　　　身份认证账号密码 "username:password" , 完整demo: http://xxx.php?id=1 --auth-type Basic --auth-cred "u:p" (个人认为不常用)

　　　　--auth-cert / --auth-file　 基于客户端证书进行校验,(个人感觉非常非常非常之不常用,略过...嘿嘿,放肆一把,就不学这个了)　　　　　　

　　　　--proxy　　　　　　　指定代理 

　　　　--proxy-cred　　　　  指定代理的账号密码(代理需要账号密码的前提下)

　　　　--ignore-proxy　　　　忽略系统代理(我们设置的代理都是通过浏览器进行设置的,通常用于扫描本地系统)

　　　　--delay　　　　　　　每次请求的延迟时间,单位秒,默认无延迟.

　　　　--timeout　　　　　　请求超时时间,默认30秒.

　　　　--retries　　　　　　 连接超时重试次数 ,默认3次

　　　　--randomize　　　　 长度,类型与原始值保持一致的情况下,指定每次请求随机取值的参数名 例: xxx.php?id=100, --randomize=''id" 则id的值在100-999随机出现

　　　　--scope　　　　　　 过滤日志内容,通过正则筛选扫描对象. 例: sqlmap -l burp.log --scope="(www)?\.aaa\.(com|net|org)" 则只会扫描以www开头.aaa.com或者net或者org

　　　　--safe-url  \ --safe-freq 扫描的时候回产生大量的url,服务器可能会销毁session.每发送--safe-freq 次注入请求后 就发送一次正常请求.

　　　　--safr-url　　　　   需要扫描的url.

　　　　--safe-freq　　　　  出现错误(或者说带sql注入请求)的次数

　　　　--skip-urlencode　　get请求会对url进行编码. 某些web服务器不遵循标准编码 此参数就是不对get请求的url进行编码

　　　　--eval　　　　　　  每次请求前指定执行特定的python代码.

### sqlmap之cookie应用：

对本机dvwa进行sql漏洞扫描. 首先登录

<img src="https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20230514225158957.png" alt="image-20230514225158957" style="zoom:80%;" />

登录过之后,在浏览器内获取cookie信息.

![image-20230514225221889](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20230514225221889.png)

复制cookie信息到sqlmap ,多个cookie之间用分号间隔分开

![image-20230514225249068](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20230514225249068.png)

## Optimization(参数优化)：

​					   -0　　　　　　　　　　　　后续3个参数的集合(除--threads)

　　　　　　--predict-output　　　　　　根据检测方法,比对返回值和统计表(/sqlmap/common-outputs.txt)内容,不断缩小检测范围,提高检测效率.(比对信息包括但不限于版本名,用户名,密码,表名,列名..等,与--threads参数不兼容)

　　　　　　--keep-alive　　　　　　　　使用http(s)长连接,新能好, 与--proxy参数不兼容.长连接避免重复简历连接的网络开销,但大量长连接会严重占用服务器资源

　　　　　　--null-connection　　　　　　只获取相应页面的大小值,而非页面具体内容.通常用于盲注判断真/假,降低网络带宽消耗. 与--text-only(基于页面内容的比较判断)不兼容

　　　　　　--threads　　　　　　　　　 最大并发线程,默认为1个线程,建议不要超过10个线程,否则可能影响站点可用性.与--predict-output参数不兼容

## Injection(参数注射)：

　　　　　　-p　　　　　　　　　　　　　扫描指定的参数,例 xxx.php?id=2&name=root -p id 只会扫描id变量的值 (可以指定多个变量名,多个变量名逗号隔开)

　　　　　　　　　　　　　　　　　　　　(在使用-p的时候会使--level失效,例如--level=3的时候才会扫描user-agent,但是我们使用手动指定了扫描参数user-agent 虽然没有指定--level=3,但此时也会扫描)

　　　　　　--skip　　　　　　　　　　　 排除指定的参数,例如--level=3 会扫描user-agent 但是我们不希望扫描useragent 可以使用--skip跳过此参数的扫描

　　　　　　--dbms　　　　　　　　　　 指定后端数据库,在已知web应用的数据库前提下,略去sqlmap扫描判断后端数据库过程,提高效率.例: --dbms="mysql"(<5.0>指定版本)

　　　　　　--os　　　　　　　　　　　　指定目标操作系统

　　　　　　--invalid-bignum/ --invalid-logical 默认使用负值使参数失效,bignum使用最大参数值使参数失效,logical使用布尔判断值使取值失效

　　　　　　--no-cast　　　　　　　　　　榨取数据时,sqlmap将所有结果转换为字符串,默认用空格替换null, 老版本可能不支持空格替换,使用--no-cast关闭替换

　　　　　　--no-escape　　　　　　　　 不逃逸,也就是说当payload中用丹壹号界定字符串时,sqlmap使用char()编码逃逸的方法替换字符串,也就是说不然sqlmap对payload中　的单引号进行编码

　　　　　　--prefix/ --suffix　　　　　　　前缀/后缀　　　　

　　　　　　--tamper　　　　　　　　　　混淆脚本,用于绕过应用层过滤,IPS,WAF. 编写好的脚本存放于(sqlmap/tamper/...)使用的时候直接写出脚本名称即可,sqlmap会 自动去对应文件夹加载对应的文件　

## Detection(检测)：


　　　　　　--level　　　　　　　　　检测级别,默认1级. 可设定1-5.级别不同,检测的细度不同./sqlmap/xml/payloads(检测级别不同,发送的payloads不同,)

　　　　　　--risk　　　　　　　　　 风险级别 1-4 默认1, 如果指数过高,可能会对数据造成伤害(如:更新,删除等)

## Techniques(检测sql漏洞存在的技术类型)：

　　　　　　就是之前提到的sqlmap的五种检测类型, 默认是全部使用, 也可以手动指定.

　　　　　　--time-sec　　　　　　　　基于时间的注入检测相应延迟时间(默认5秒)

　　　　　　--union-cols　　　　　　　 默认联合查询1--10列,随着--level增加 最多检查50列.可以手动指定.

　　　　　　--union-char　　　　　　　联合查询默认使用null,可能会出现失败,此时可以手动指定数值. 例: union select null union select 1111

　　　　    --dns-domain　　　　　　 如果攻击了dns服务器,使用此功能可以提高数据榨取速度

## Fingerprint(指纹信息)：

　　　　　　-f(--fingerprint)　　　　　　　　　　　　数据库管理系统的指纹信息(数据库类型,操作系统,架构,补丁等)

　　　　　　-b (--banner)　　　　　　　　　　　　 banner信息

## Enumeration(枚举)：

　　　　　　--current-user　　　　　　　　　　　　查询当前数据库管理系统账号

　　　　　　--current-db　　　　　　　　　　　　　查询当前数据库昵称

　　　　　　--hostname　　　　　　　　　　　　　查询当前主机名

　　　　　　--users　　　　　　　　　　　　　　　查询数据库系统中所有的账号

　　　　　　--peivileges-U xxx　　　　　　　　　　-u 查询指定账号的权限 如果不跟指定用户名 则查询的是所有的用户, -CU 查询当前用户

　　　　　　-D 　　　　　　　　　　　　　　　　 指定数据库

　　　　　　--table　　　　　　　　　　　　　　　查询所有表

　　　　　　-T 　　　　　　　　　　　　　　　 指定表

　　　　　　--columns　　　　　　　　　　　　　 查询指定表的所有列

　　　　   -C 　　　　　　　　　　　　　　　 指定某一列查询

　　　　　　--exclude-sysdbs　　　　　　　　　　忽略系统库

　　　　　　--count　　　　　　　　　　　　　　 统计记录

　　　　　　--batch　　　　　　　　　　　　　　批处理,也就是系统默认选项(按照默认的选项 全自动执行)

## dump数据：

　　　　　　--dump　　　　　　　　　　　　　　保存数据到本地(配合一系列的指令)

　　　　　　-C　　　　　　　　　　　　　　　　指定columns 如果不指定,默认整表

　　　　　　-T　　　　　　　　　　　　　　　　指定表名,

　　　　　　-D　　　　　　　　　　　　　　　　指定数据库

　　　　　　-start　　　　　　　　　　　　　　 数据起始位置 (按表的id进行取值)

　　　　　　-stop　　　　　　　　　　　　　　 数据结束位置

　　　　　　--dump-all　　　　　　　　　　　　下载整表

　　　　　　--sql-query　　　　　　　　　　　　指定sql语句

## Brute Force(暴力破解)：

　　　　　　在mysql <5.0的时候 ,是没有information_schema库的,这时候我们就不能根据数据源表进行一系列的操作

　　　　　　还有一种情况是mysql>=5.0的时候,但无权限读取information_schema库,这时候可能就需要用到暴力破解

　　　　　　在微软access数据库中,默认是无权读取MSysObjects库的

　　　　　　--common-tables　　　　　　　　　　　　　　　　　　暴力破解表名(根据字典)

　　　　　　--common-columns(Access系统表无列信息)　　　　　　暴力破解表字段

## Udf Injection(UDF注射)：

　　　　　　--udf-inject ,, --shared-lib

　　　　　　--file-read　　　　　　　　　　　　　　读取目标系统指定文件(值为具体文件的路径)

　　　　　　--file-write　　　　　　　　　　　　　　写入的文件 

　　　　　　--file-dest　　　　　　　　　　　　　　 写入保存的路径

　　　　　　--os-cmd　　　　　　　　　　　　　　 执行系统命令

　　　　　　--os-shell　　　　　　　　　　　　　　 得到系统shell

　　　　　　--sql-shell　　　　　　　　　　　　　　 得到sqlshell

## Windows RegisTory(Windows注册表相关)：

　　　　　　--reg-read　　　　　　　　　　　　　　读取注册表键值

　　　　　　--reg-add　　　　　　　　　　　　　　 向注册表添加键值

　　　　　　--reg-del　　　　　　　　　　　　　　  删除注册表键值

　　　　　　--reg-key --reg-value --reg-data --reg-type 辅助参数, 上面三个操作的时候可以缩小范围.

## General(常规参数)：

　　　　　　-s　　　　　　　　　　sqllite会话文件保存位置

　　　　　　-t　　　　　　　　　　 记录流量文件保存位置

　　　　　　--charset　　　　　　　强制字符编码

　　　　　　--crawl　　　　　　　　从起始位置爬站深度

　　　　　　--csv-del　　　　　　　dump下来的数据默认存于","分割的csv文件中,--csv-del用来指定其他分隔符

　　　　　　--dbms-cred　　　　　 指定数据库账号

　　　　　　--flush-session　　　　 清空session　　　　

　　　　　　--force-ssl　　　　　　 针对https的网站..

　　　　　　--fresh-queries　　     忽略本地session 从新发送请求

　　　　　　--output-dir　　　　　　指定一个输出目录

　　　　　　--parse-errors　　　　  分析和显示数据库中内建报错信息

　　　　　　--save　　　　　　　　 将命令保存成配置文件

　　　　　　--check-waf　　　　    检测waf.ips.ids

　　　　　　--hpp　　　　　　　　 绕过WAF,IPS,IDS 尤其对ASP,/IIS.ASP.NET/IIS

 　　　　　--identify-waf　　　　  更彻底的检查waf

## Miscellaneous(杂项)：

　　　　　　--mobile　　　　　　　　模拟只能手机设备(实现方式只是替换对应的user-agent)

　　　　　　--purge-output　　　　 清除output文件夹

　　　　　　--smart　　　　　　　　 当有大量检测目标时, 只选择基于错误的检测结果

　　　　　　--wizard　　　　　　　　向导模式.　
