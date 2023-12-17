# Reverse-Basis2


reverse基础2

<!--more-->

### 0x1 基本汇编指令

> mov  A B      **将B的值复制到A里面去**
>
> push  A       **将A压栈**
>
> pop  A        **将A从栈中弹出来**
>
> call Funtion  **跳转到某函数**
>
> ret  --> 相当于 pop ip **从栈中pop出一个值放到EIP里面**
>
> je jz       **如果ZF（0标志位）=1，就跳转，否则跳过这条语句，执行下面的语句。
>

### 0x2 栈&栈帧

​	堆栈，就是计算机暂时储存的地方，固定的一端称之为栈底，变化的一端称之为栈顶

​	**栈的原则：先进后出，后进先出**

![image-20230314182443212](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20230314182443212.png)

​	栈帧也叫过程活动记录，是编译器用来实现过程/函数调用的一种数据结构。

​	C语言中，每个栈帧对应着一个未运行完的函数。栈帧中保存了该函数的返回地址和局部变量。

​	函数每次调用，都有它自己独立的栈帧。栈帧中维持着函数调用所需要的各种信息，包括函数的传入，函数的局部变量、函数执行完成后下一步要执行的指令地址、寄存器信息等。

### 0x3 运行时栈

​	栈帧使用了栈这一数据结构，达到了后进先出(First In Last Out)的内存管理原则。不管是插入数据还是删除数据，都是**在栈顶进行的**。

​	x86-64的栈由高地址向低地址增长，寄存器rbp指向当前栈帧的底部(高地址)，寄存器rsp指向当前栈帧的顶部(低地址)。数据压栈和出栈会修改rsp的值。通过push指令将数据存入栈中，同时64位系统中会对栈顶指针做减法操作rsp=rsp-8。pop指令是push的逆操作，它将数据从栈中读取出来，同时64位系统中会对栈顶指针做加法操作rsp=rsp+8

​	当过程P调用过程Q时，

​	1.把实参压栈，cdecl是gcc的默认调用约定，实参压栈顺序为从右至左

​	2.把返回地址(即P调用Q后的下一条指令地址)压入栈中，表示当Q返回后，P程序下一步要从那条指令开始运行

​	3.开始调用Q，首先将P的栈底rbp压栈，然后栈顶rsp赋值给rbp，从而形成新的栈底地址。我们再看函数调用的汇编代码时，经常看到的一段正是在做这个操作

```
	push	rbp
	mov		rbp,rsp
```

​	4.分配局部变量空间，开始具体执行Q函数的指令代码

![1111](https://img-blog.csdnimg.cn/345e62563877408497fbc0f1d0f459e5.png?x-oss-process=image/watermark,type_d3F5LXplbmhlaQ,shadow_50,text_Q1NETiBASW1SZXNwaXJhdGlvbg==,size_10,color_FFFFFF,t_70,g_se,x_16#pic_center)

### 0x3 转移控制

​	将控制从函数P转移到函数Q只需要将程序计数器(PC)设置为Q函数代码的起始位置。另外，稍后从Q返回时处理器还需要继续执行P的下一条指令A。在`x86-64`中，这个过程是用执行`call Q`指令来完成的。该指令将A的地址压栈，并将PC设置为Q的起始地址。

​	Q执行完成后弹出A地址这个过程是通过`ret`指令完成的，它会弹出地址A，并把PC设置为A

```
#include<iostream>
#include<stdint.h>

int32_t Add(int32_t x,int32_t y)
{
    int32_t z=0;
    z=x+y;
    return z;
}

int main()
{
    int32_t a=10;
    int32_t b=20;
    int32_t ret=Add(a,b);
    return 0;
}
```

经过编译后，再进行反汇编，如下是汇编代码

```
#include<iostream>
#include<stdint.h>

int32_t Add(int32_t x,int32_t y)      //  push    rbp
                                      //  mov     rbp, rsp
                                      //  mov     DWORD PTR [rbp-20], edi
                                      //  mov     DWORD PTR [rbp-24], esi
{
    int32_t z=0;                      //  mov     DWORD PTR [rbp-4], 0
    z=x+y;                            //  mov     edx, DWORD PTR [rbp-20]
                                      //  mov     eax, DWORD PTR [rbp-24]
                                      //  add     eax, edx
                                      //  mov     DWORD PTR [rbp-4], eax
    return z;                         //  mov     eax, DWORD PTR [rbp-4]
}                                     //  pop     rbp
                                      //  ret

int main()                       
{                                     
                                      //  push    rbp
                                      //  mov     rbp, rsp
                                      //  sub     rsp, 16
    int32_t a=10;                     //  mov     DWORD PTR [rbp-4], 10
    int32_t b=20;                     //  mov     DWORD PTR [rbp-8], 20
    int32_t ret=Add(a,b);             //  mov     edx, DWORD PTR [rbp-8]
                                      //  mov     eax, DWORD PTR [rbp-4]
                                      //  mov     esi, edx
                                      //  mov     edi, eax
                                      //  call    Add(int, int)
                                      //  mov     DWORD PTR [rbp-12], eax
    return 0;
}
```

当main函数调用了add时，执行了以下步骤：

```
Add(int, int):
    // 5. 将main函数的栈帧底部地址入栈保存 
	push    rbp
    // 6. 将此时的栈帧顶部地址作为Add函数的栈帧底部地址
    mov     rbp, rsp
    // 7. 获取形参x
    mov     DWORD PTR [rbp-20], edi
    // 8. 获取形参y
    mov     DWORD PTR [rbp-24], esi
    // 9. 初始化z=0
    mov     DWORD PTR [rbp-4], 0
    // 10. 将x和y分别保存至寄存器edx和eax，然后相加，结果保存在寄存器eax
    mov     edx, DWORD PTR [rbp-20]
    mov     eax, DWORD PTR [rbp-24]
    add     eax, edx
    // 11. 将寄存器eax中的x和y相加结果赋值给z
    mov     DWORD PTR [rbp-4], eax
    // 12. 将Add函数结果z保存至寄存器eax
    mov     eax, DWORD PTR [rbp-4]
    // 13. 将之前保存的main函数栈帧底部地址出栈并保存至rbp
    pop     rbp
    // 14. 相当于pop eip 将之前保存的mov     DWORD PTR [rbp-12], eax指令地址出栈并保存至eip
    ret

main:
    push    rbp
    mov     rbp, rsp
    sub     rsp, 16
    // 1. 初始化a=10
    mov     DWORD PTR [rbp-4], 10
    // 2. 初始化b=20
    mov     DWORD PTR [rbp-8], 20
    // 3. 分别将a和b保存至寄存器eax和edx，再分别拷贝至寄存器edi和dsi
    mov     edx, DWORD PTR [rbp-8]
    mov     eax, DWORD PTR [rbp-4]
    mov     esi, edx
    mov     edi, eax
    // 4. 等价于两条命令
    //      ① push eip 将eip中存储的下一条指令地址压栈，即mov     DWORD PTR [rbp-12], eax这条指令
    //      ② jmp Add(int,int) 跳转至Add(int,int)
    call    Add(int, int)
    // 15. 将Add函数返回结果保存至ret
    mov     DWORD PTR [rbp-12], eax

```


