# fluxion


破解WiFi的瑞士军刀

<!--more-->

**首先声明：**工具经过我多次实测过，验证了很多网传的教程，大多数是正确的，但也有些不是很合理的指导步骤，或者说是文章作者不加验证和修改地抄别人文章。确实，在这个圈子里很多技术帖都是传来传去，抄来抄去，但我觉得，抄文章应在学习的同时加以验证和修改一些前人不妥的地方，由于时间和个人水平的限制，本文章有些截图和内容来源于他人文章，所以会造成前后图片中SSID不一致的情况，但并不影响阅读和实践。

**<u>私自破解他人 WiFi 属于违法行为，我这里使用的是自己买的 迷你版路由器 作为学习和测试。明白了破解原理就知道应该怎么防范了。</u>**

## **0x1-Fluxion是什么**

Fluxion是一个无线破解工具，这款软件可以帮你挤掉WiFi主人的网络让你自己登陆进去，而且WiFi主人怎么挤也挤不过你。

## **0x2-Fluxion工作原理**

　　1.扫描能够接收到的WIFI信号

　　2.抓取握手包(这一步的目的是为了验证WiFi密码是否正确)

　　3.使用WEB接口

　　4.启动一个假的AP实例来模拟原本的接入点

　　5.然后会生成一个MDK3进程。如果普通用户已经连接到这个WiFi，也会输入WiFi密码

　　6.随后启动一个模拟的DNS[服务器](https://cloud.tencent.com/product/cvm?from=10680)并且抓取所有的DNS请求，并且会把这些请求重新定向到一个含有恶意脚本的HOST地址

　　7.随后会弹出一个窗口提示用户输入正确的WiFi密码

　　8.用户输入的密码将和第二步抓到的握手包做比较来核实密码是否正确

## **0x3-Fluxion的安装**

在终端输入以下命令安装fluxion：

```
git clone https://github.com/deltaxflux/fluxion.git
```

随后通过终端进入到fluxion目录

![](https://img-blog.csdnimg.cn/20210321125030112.png#pic_center)

![img](https://www.likecs.com/default/index/img?u=aHR0cHM6Ly9pbWcyMDE4LmNuYmxvZ3MuY29tL2Jsb2cvMTUxMzU0MC8yMDE4MTEvMTUxMzU0MC0yMDE4MTExMDIyMDkzMzQyMi0yMTM3OTAzNzIwLnBuZw%3D%3D)

**Tips：不同版本的kali情况可能不同，但首次需要使用通过./fluxion.sh -i 来安装kali缺少的工具**

## 0x4-Fluxion的使用

```
cd fluxion
./fluxion.sh
```

在语言选择界面直接选中文就好了，6.9版本的选18，注意不要输入018

接下来进入主界面：

![20210321125800132](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/20210321125800132.png)

首先我们选择2，先扫描并抓取WiFi信息，虽然网上有些教程说是先选1，但其实并不正确。

![20210321151057704](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/20210321151057704.png)

可以看到左边终端窗口显示扫描到的一些热点，当目标信号出现后，可按ctl+c返回原界面，当然也可以按两次q键。

![20210321154549357](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/20210321154549357.png)

输入编号选中要攻击的信号节点



输入2跳过

![image-20220929000029204](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20220929000029204.png)

选择2，因为之前有攻击过一次，抓到了握手包

![image-20220929000117595](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20220929000117595.png)

选择2

![image-20220929000136301](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20220929000136301.png)

选择2

![image-20220929000158777](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20220929000158777.png)

选择1

![image-20220929000219227](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20220929000219227.png)

选择2

![image-20220929000240419](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20220929000240419.png)

开始抓去握手包…

![image-20220929000526997](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20220929000526997.png)

出现如图所示，则抓包成功，这个包是后续用来检测密码的。当然也可对其进行其他的一些研究和操作，接着选择1，启动攻击

![image-20220929000623587](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20220929000623587.png)

接着回到刚开始的界面，这里我们要选择1，因为我们已经抓到包了

![image-20220929000708702](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20220929000708702.png)

这里继续选择2，选择1，后面的钓鱼热点就开不开了

![image-20220929000726974](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20220929000726974.png)

这里选择2

![image-20220929000744684](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20220929000744684.png)

选择1的话网上说所有人都会连不上，我试过了，确实是这样的

![image-20220929000840243](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20220929000840243.png)

选择推荐的1，开始建立AP

![image-20220929000901196](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20220929000901196.png)

选择1

![image-20220929000921344](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20220929000921344.png)

选择1，这个抓取到的hash文件就是我们刚才抓到的包

![image-20220929000939996](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20220929000939996.png)

选择推荐的2

![image-20220929000956322](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20220929000956322.png)

选择1

![image-20220929001014851](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20220929001014851.png)

选择推荐的1

![image-20220929001031593](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20220929001031593.png)

这个工具的工作原理是，把原来的WiFi打掉，然后建立一个同名热点，你连接上这个热点后，他会弹出你选择的认证界面，提示你重新输入密码，你输入的密码他会去根据抓到的包进行验证，密码正确就保存密码，关闭钓鱼热点，密码错误就继续让你输入。

下面还有很多界面种类，这里选3中文认证界面，这个界面是可以自己建立的钓鱼WiFi的认证界面，但是我不会，应该是用一个什么软件建立了一个界面，然后在特定的文件夹里添加上，如果不会建立界面，就用它自带的即可。
![image-20220929001053865](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20220929001053865.png)

选择后开始建立钓鱼热点，出现六个小窗口，原来的WiFi就连接不上了，我们的钓鱼WiFi出现了，当连接同名钓鱼WiFi时就会弹出认证窗口。
注意，这时候所选择的设备是早已经连上目标WiFi的，我是用自己手机连着实验室的bamboo的。

可以看到，我手机上提示了密码错误，以及出现了两个bamboo。

真正的WiFi会一直无法连接，同时会有一个一模一样未加密的伪AP，手机连上伪AP，输入密码后正确密码保存在netlog文件夹中，错误密码保存在pwdlog文件夹中

![image-20220929001242887](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20220929001242887.png)

![image-20220929001259715](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20220929001259715.png)

以下是手机连上伪AP后弹出的认证界面，可以看到它要求你输入密码，输入正确密码后会告诉你自动修复。

![image-20220929001308725](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20220929001308725.png)

出现了钓鱼界面，而刚才说的可以自己制作的钓鱼界面就是这个，可以自己根据社工出的路由器牌子制作相应逼真的网站提高钓鱼成功率。
如果成功的话4个窗口会消失，如下图

![image-20220929001451035](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20220929001451035.png)

2退出

最终结果：

![image-20220929001537539](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20220929001537539.png)

![在这里插入图片描述](https://img-blog.csdnimg.cn/29a24368739449f886864a9007837634.png)

文件打开后可以看到Password后就是bamboo的密码
另外错误密码的文件夹也能查看

![image-20220929001606022](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20220929001606022.png)

---

![image-20220928225344796](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20220928225344796.png)
