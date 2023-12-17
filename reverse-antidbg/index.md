# Reverse-AntiDBG


reverse反调试基础

<!--more-->

### 关于反调试

分为**静态反调试**和**动态反调试**

### 调试常用的工具

IDA Pro	Ollydbg 	peid(查壳工具)

## 一.栈指针平衡

![image-20230315155620824](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20230315155620824.png)

> ESP寄存器指向当前栈顶元素的地址，是栈操作的重要寄存器。
>
> EBP寄存器通常用于指向当前函数的基址（起始地址）或堆栈帧的基址。

当我们用IDA进行静态分析，用F5进行反编译的时候，会出现如下这种报错：

![image-20230315155722157](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20230315155722157.png)

> sp：stack pointer 栈指针

为解决这个问题，我们首先要清除是什么地方导致栈指针不平衡，根据报错：

![image-20230315155823166](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20230315155823166.png)

找到这个地方之后，要进行栈指针分析，此时要设置一下IDA，让其显示栈指针`Options-General-Disassembly-"Stack pointer"`

![img](https://xzfile.aliyuncs.com/media/upload/picture/20190715171030-64d2f4ca-a6e0-1.png)

> 栈的生命周期结束后，ESP和EBP寄存器的值会恢复到它们在函数调用前的值

![20190715171057-7514348e-a6e0-1](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/20190715171057-7514348e-a6e0-1.png)

然而，我们看到的这个pop指令后的栈指针与入栈的栈指针不一致

![20190715171140-8e5b5d78-a6e0-1](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/20190715171140-8e5b5d78-a6e0-1.png)

这就引起了栈指针不平衡，因此我们需要手动调节栈指针，让其恢复平衡
Attention：每条语句前的栈指针是这条语句未执行的栈指针
我们在IDA中使用Alt+k可以修改栈指针

修改后的值为：0X21E-0X4 = 0X21A

(然而，根据大佬在博客中的解释，栈指针不平衡可能是IDA的一个漏洞)

> IDA有栈跟踪的功能，它在函数内部遇到ret(retn)指令时会做判断：栈指针的值在函数的开头/结尾是否一致，如果不一致就会在函数的结尾标注"sp-analysis failed"。一般编程中，不同的函数调用约定(如stdcall&_cdcel call)可能会出现这种情况；另外，为了实现代码保护而加入代码混淆(特指用push/push+ret实现函数调用)技术也会出现这种情况。

我看的这篇文章是2019年发布的，或许当年的IDA还有这方面缺陷，然而我下载了其博客中的附件进行复现的时候，发现并没有其博客中出现的问题，可以直接进行反编译，或许是新版本的IDA进行了自动修复



## 二.花指令

### 0x1 花指令概述

​	在正常的代码流程中通过内联汇编或者插入机器码的方式来干扰指令执行的顺序，从而影响反汇编引擎的工作，导致反汇编工具难以正确地识别代码

​	是反静态调试的一种手段，从而加大逆向分析难度

### 0x2 花指令又是怎样影响栈指针的

我们可以写一个简单的花指令，来分析其如何影响栈指针的

**asm指令的作用**：用于调用内联汇编程序，并且可在C或C++语句合法时出现，asm后跟一个程序指令集、一组括在大括号中的指令集或者至少一堆空大括号

**emit指令的作用**：

1. 编译器不认识的指令，拆成机器码来写。
2. 插入垃圾字节来反跟踪，又称花指令。

> 用emit就是在当前位置直接插入数据（实际上是指令），一般是用来直接插入汇编里面没有的特殊指令，多数指令可以用asm内嵌汇编来做，没有必要用emit来做，除非你不想让其它人看懂你的代码。



![image-20230315170504027](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20230315170504027.png)

将改程序编译成exe，然后用IDA进行反编译，之后双击访问`func2();`,产生栈指针不平衡报错，以此可以达到反跟踪的目的

![image-20230315172217747](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20230315172217747.png)

![image-20230315172230792](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20230315172230792.png)



> 在编程语言中，通常以一个下划线开头的函数或变量名表示该函数或变量是库或系统的内部实现，不应该在用户代码中直接使用。这种命名约定通常被称为“前缀保留”。
>
> 有些编程语言还使用了双下划线前缀来表示特殊含义，例如：
>
> - **attribute**：在C和C++中，`__attribute__`关键字用于指定变量或函数的属性，例如对齐方式、强制inline等。
> - `__init`和`__exit`：在Linux内核中，这些函数是内核模块初始化和清理函数的标准名称。
>
> 需要注意的是，使用双下划线前缀是非标准的命名约定，因此在编写代码时应该尽可能避免使用这种方式，以免与标准库或系统库的命名冲突。

### 0x3 花指令分类

#### 可执行花指令

​	1.可执行花指令指的是这部分花指令代码在程序的正常执行过程中会被执行，但执行这些代码没有任何意义，执行前后不会改变寄存器的值(eip这种除外)，同时这部分代码也会被反汇编器正常识别。

​	2.花指令的首要目的是加大静态分析的难度，让你难以识别代码的真正意图，同时可以破坏范斌已的分析，使得栈指针在反编译引擎中出现异常。

#### 不可执行花指令

​	1.花指令虽然被插入到了正常的代码中间，但是并不意味着一定会得到执行，这类花指令通常形式为在代码中出现了类似数据的代码，或者IDA反汇编后为jmupout(xxxxx).

​	2.这类花指令一般不属于CPU可以识别的操作码，那么就需要在上面用跳转跳过这些花指令才能保证程序正常运行。

### 0x3 一点点收集

#### 1.简单的花指令

0xe8是跳转指令，可以对线性扫描算法进行干扰，但是递归扫描算法可以正常分析。

![02fbea5745f0d2f7e5648286b382e2b4](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/02fbea5745f0d2f7e5648286b382e2b4.png)

jz，jnz意味着无论如何都将跳转到labell这个无效数据

#### 2.简单的jmp

PD能被骗过去，但是因为IDA采用的是递归扫描算法所以能够正常识别

```
#include<stdio.h>
int main() {
	__asm{
		jmp label1;
		__emit 0xe8;
	label1:    
	}
	printf("Hello World!");
	return 0;
}
```

![722f96febd563ed0d3ef4896ac2daedd](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/722f96febd563ed0d3ef4896ac2daedd.png)

### 3.多级跳转

```
#include<stdio.h>
int main() {
	__asm{
	start://花指令开始
		jmp label1;
		__emit 0xe8;
	label1:
		jmp label2;
		__emit 0xe8;
	label2:
		jmp label3;
		__emit 0xe8;
	label3:  
	}
	printf("Hello World!");
	return 0;
}

```

![d2f6c1ec07aa341083eef56f035cde0a](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/d2f6c1ec07aa341083eef56f035cde0a.png)

### 4.call&ret构造花指令

```
__asm{
    call label1
    _emit junkcode
label1:
    add dword ptr ss:[esp],8//具体增加多少根据调试来
    ret
    _emit junkcode
}

call指令：将下一条指令地址压入栈，再跳转执行
ret指令：将保存的地址取出，跳转执行

```

![79389794c61d0baea5eca2cb1658259a](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/79389794c61d0baea5eca2cb1658259a.png)

### 0x4 如何处理

#### 1.手动清除

找到所有的花指令，重新设置数据和代码地址。或者将花指令设置为nop（0x90）

在0x401051设置为数据类型（快捷键D）,在0x401052设置为代码类型（快捷键C）

这里用一个ida python脚本添加ALT+N快捷键来将指令的第一个字节设置为NOP

```
from idaapi import *
from idc import *

def nopIt():
	start = get_screen_ea()
	patch_byte(start,0x90)
	refresh_idaview_anyway()

add_hotkey("alt-N",nopIt)



```

#### 2.自动清楚花指令

上面有3个类别ida无法正常识别

互补条件跳转（比较好处理）
永真条件跳转 （各种永真条件比较难匹配）
call&ret跳转（比较难处理）
所以就只对第一种jnx和jx的花指令进行自动化处理
所有的跳转指令，互补跳转指令只有最后一个bit位不同

```
70 <–> JO(O标志位为1跳转)
71 <–> JNO
72 <–> JB/JNAE/JC
73 <–> JNB/JAE/JNC
74 <–> JZ/JE
75 <–> JNZ/JNE
76 <–> JBE/JNA
77 <–> JNBE/JA
78 <–> JS
79 <–> JNS
7A <–> JP/JPE
7B <–> JNP/JPO
7C <–> JL/JNGE
7D <–> JNL/JGE
7E <–> JLE/JNG
7F <–> JNLE/JG
```


第一条指令跳转距离=第二条跳转距离+2。简单一点可以是\x03和\x01

抄的代码

```
from ida_bytes import get_bytes,patch_bytes
start= 0x401000#start addr
end = 0x422000
buf = get_bytes(start,end-start)

def patch_at(p,ln):
    global buf
    buf = buf[:p]+b"\x90"*ln+buf[p+ln:]

fake_jcc=[]
for opcode in range(0x70,0x7f,2):
    pattern = chr(opcode)+"\x03"+chr(opcode|1)+"\x01"
    fake_jcc.append(pattern.encode())
    pattern = chr(opcode|1)+"\x03"+chr(opcode)+"\x01"
    fake_jcc.append(pattern.encode())

print(fake_jcc)
for pattern in fake_jcc:
    p = buf.find(pattern)
    while p != -1:
        patch_at(p,5)
        p = buf.find(pattern,p+1)

patch_bytes(start,buf)
print("Done") 

```

## 三.**SMC自解码**

SMC（Self-Modifying Code）（自解码），可以在一段代码执行前对它进行修改。

常常利用这个特性，把代码以加密的形式保存在可自行文件中，然后在程序执行的时候进行动态解析。这样我们在采用静态分析时，看到的都是加密的内容，从而阻断了静态调试的可能性。

### sms题目静态分析

拿到题目，找到main函数，进行反编译

![image-20230315175450013](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20230315175450013.png)

进行代码审计，然而，能传参的肯定是函数，分析`byte_403020`这个函数，双击跟进

![image-20230315175638123](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20230315175638123.png)

然而得到的确实一堆数据，而不是函数。这就是典型的对某段代码进行了加密处理，上面的异或操作既是加密操作也是也解密操作，这样我们静态分析就进行不下去了。这样的情况就是SMC自解码问题。

解决此类问题，就要进行动态分析

### sms题目动态分析

使用OllyDbg找到主函数，开始单步执行

大部分的逻辑就是下面注释的地方，我们需要关注的重点在于找到处理输入函数的地方，看看在解密后的那个函数是怎样对输入内容进行比较或者变换的

![image-20230315182138614](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20230315182138614.png)

当运行到这个地步的时候，我们就发现函数快运行到结束了

![image-20230315182209463](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20230315182209463.png)

在函数结束之前，调用了EAX，其实就是解密后的函数。这个地方就是我们静态分析想要分析的地方。因此，在这里我们就可以跟进去。因为现在那个数组经过解密后已经是一个函数了。

![image-20230315182233211](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20230315182233211.png)

进入之后我们就发现了比较的指令。看看比较的内容，翻译一下就是BUPT{

总的来说，就是需要通过程序调试，进行单步执行，当程序执行到解码的步骤时，就会对主程序进行解码运行，静态状态是加密的。

## 四.MOV混淆

> MOV这种混淆是怎样产生的呢？剑桥大学的Stephen Dolan证明了x86的mov指令可以完成几乎所有功能了（可能还需要jmp），其他指令都是“多余的”。受此启发，有个大牛做了一个虚拟机加密编译器。它是一个修改版的LCC编译器，输入是C语言代码，输出的obj里面直接包含了虚拟机加密后的代码。如它的名字，函数的所有代码只有mov指令，没有其他任何指令。这个加密编译器在网上是开源的项目。
>
> 
>
> https://github.com/xoreaxeaxeax/movfuscator

这种题目的特征就是：汇编代码的汇编指令几乎全部就是MOV

![image-20230315182715062](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20230315182715062.png)

这种情况，我们几乎无法直接审计汇编代码

这道题没用啥特殊技巧，通过不断观察后发现，r2后的字符拼接起来或许就是flag字符串

![image-20230315202622853](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20230315202622853.png)

我们进行全局搜索R2,得到flag

![image-20230315203010127](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20230315203010127.png)

**总结一下：**
1.注意字符串的全局搜索
2.MOV并不混淆函数逻辑
3.大多数汇编代码可以猜测

## 附按调试函数

> ##### 0x1 IsDebuggerPresent函数
>
> ​	只能用于自身进程的检测，通过查询进程环境块(PEB)中的IsDubugged标志，如果处在被调试状态则返回非0，没有调试状态返回0
>
> ##### 0x2 NeQueryInformationProcess函数
>
> ​	用于提取一个给定进程的信息，函数参数1表示进程句柄，参数2表示信息类型，第二个参数ProcessDebugPort的值如果设置为0x7，就可以进行返回句柄标识的进程是否被调试，如果处于调试状态，那么就会返回调试的端口，非调试状态则返回0
>
> ##### 0x3 CheckRemoteDebuggerPresent函数
>
> ​	它可以用与自身进程和其他进程，通过查询进程环境块(PEB)中的IsDebugged标志，如果被调试状态，返回值返回非0，没调试状态返回0
>
> ##### 0x4 FindWindowA、EnumWindows
>
> ​	通过检测运行环境的调试器的窗口信息
>
> ##### 0x5 OutputDebug String
>
> ​	调试器调试应用程序的时候是通过触发异常方式进行调试功能的，通过利用SetLastError获取到的错误码是前面用SetLastError的错误码一致，如果没有被调试，那么错误码可能是任意值
>
> ##### 0x6 注册表检测
>
> ​	通过查找调试器引用的注册表信息进行判断，如果当前环境下的注册表存在调试器的信息，则应用程序就可能确定它正在被调试
>
> ##### 0x7 BeginDebugged标志检测
>
> ​	当应用程序运行的时候，fs:[30h]指向PEB地址，如果在指向的BeginDebugged标志位0的情况下，应用程序则没有被调试，反之则被调试。
>
> ##### 0x8 检测ProcessHead标志
>
> ​	在PEB结构中的Reserved数组中有一个未公开的位置ProcessHeap，它位于PEB结构的0x18处，ProcessHead中包括ForceFlags标志，可以通过该标志进行判断是否处于被调试状态
>
> ##### 0x9 检测NTGlobalFlag标志
>
> ​	通过调试器启动的进程和正常创建启动的进程有差别的，他们创建内存堆的方式也不一样。NTGlobaFlag标志它是微软未公开的，在PEB偏移0x68位置，如果值为0x70，那么表示程序是调试器启动的。
>
> ##### 0x10 检测父进程是否是explorer.exe
>
> ​	正常启动的应用，其父进程是explorer.exe，如果进程被调试状态，那么其父进程就是调试器进程。所以只要其父进程不是explorer.exe进程就可以认定为调试状态。
