# 数据结构笔记


我摆了，您随意.......

<!--more-->

# 数据结构期末考试

## 题型安排

名词解释5道

计算题5道

应用题6道（共五十分，其余共五十分）

算法设计题2道

## 重点

### 第一章绪论

重点考概念

#### 概念

**什么是数据结构？**

数据结构是相互之间存在一种或多种特定关系的数据元素的集合。

![image-20231208133424697](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20231208133424697.png)

**什么是算法？**

一个又穷的指令集，这些指令为解决某一特定任务规定了一个运算序列。

算法的描述：自然语言，流程图，程序设计语言，伪码。

**什么是时间复杂度？**

算法中**基本语句重复执行的次数**是**问题规模n**的某个函数f(n),算法的时间量度记作：T(n)=O(f(n))，表示随着n的增大，算法执行的时间的增长率和f(n)的增长率相同，称**渐近时间复杂度**，简称时间复杂度。   

### 第二章线性表

#### 概念

**什么是顺序表？**

顺序表是在计算机内存中以数组的形式保存的线性表。

**什么是单链表？**

单链表是一种链式存取的数据结构，用一组地址任意的存储单元存放线性表中的数据元素。

#### 简答题

**顺序表和链表的优缺点**

顺序表优点：

- 存储密度大
- 可以随机存取表中任一元素
- 容易查找一个结点的前驱和后继

顺序表缺点：

- 在插入、删除某一元素时，需要移动大量元素
- 浪费存储空间
- 属于静态存储形式，数据元素的个数不能自由扩充
- 建立空表时，较难确定所需的存储空间

链表优点：

- 数据元素的个数可以自由扩充
- 插入、删除等操作不必移动数据，只需要修改链接指针，修改效率高

链表缺点：

- 存储密度小
- 存取效率不高，必须采用顺序存取，即存取数据元素时，只能按链表的顺序进行访问

**顺序表中第i个元素的地址进行推导计算**

**由数据元素在内存的存储推导数据元素之间的关系**

#### 操作题

**单链表的插入**

(1)查找第i-1个结点p；
(2)生成结点s,存入元素e;
(3)s->next=p->next, p->next=s;

![image-20231212130838239](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20231212130838239.png)

**单链表的删除**

(1) 查找第i-1个结点p；
(2) q=p->next;p->next=q->next;
(3) free(q)

![image-20231212131022299](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20231212131022299.png)

---

![image-20231208134141578](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20231208134141578.png)

![image-20231208134222359](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20231208134222359.png)

![image-20231208134245358](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20231208134245358.png)

![image-20231208134312870](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20231208134312870.png)

![image-20231208134437865](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20231208134437865.png)

![image-20231208134545206](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20231208134545206.png)

### 第三章栈和队列

主要在**简答题**和**计算题**

#### 计算题

**判断合法的入栈出栈序列**

先入后出

![image-20231212135219994](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20231212135219994.png)

**判断合法的入队出队序列**

先入先出

#### 简答题

**循环队列关于队空队满的条件判断**

![image-20231208134902601](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20231208134902601.png)

![image-20231208135048734](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20231208135048734.png)

![image-20231208135244175](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20231208135244175.png)

![image-20231208135407536](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20231208135407536.png)

### 第四章串、数组和广义表

#### 概念

**什么是广义表？**

 n ( n>0 )个表元素组成的有限序列，是线性表的一种推广。记作LS = (a0, a1, a2, …, an-1)。

**求模式串的next函数**（比较重要但考试不考，李健说的）

#### 计算题

**给首元素地址，和元素所占据的存储空间，求该元素的下标**

![image-20231212141405130](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20231212141405130.png)

**广义表求表头，求表尾，求表长度**

```
例5.11 广义表E=( a, ( a,b ), d, e, ( ( i , j ),k ))的表头为( )，表尾为( )，长度为( )，深度为( )。

答：表头为a，表尾为 ( ( a,b ), d, e, ( ( i , j ),k ) )，长度为 5，深度为 3。
```

任何一个非空的广义表其表头可能是原子，也可能是子表，而表尾一定是**子表**。

#### 简答题

**特殊矩阵（上三角，下三角，对称阵，稀疏矩阵(一般不好考)）的存储方法**

**对称矩阵**

![image-20231212143601195](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20231212143601195.png)

**三角矩阵**

![image-20231212143718097](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20231212143718097.png)

**对角矩阵（带状矩阵）**

![image-20231212143855919](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20231212143855919.png)

![image-20231212143922350](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20231212143922350.png)

**稀疏矩阵**

![image-20231212144003162](C:\Users\scofi\AppData\Roaming\Typora\typora-user-images\image-20231212144003162.png)

### 第五章树和二叉树

#### 概念

**二叉树的定义**

![image-20231208140717923](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20231208140717923.png)

**二叉树的五个性质（理解做题）**

![image-20231208141021180](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20231208141021180.png)

![image-20231208141402241](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20231208141402241.png)

![image-20231208142147455](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20231208142147455.png)

![image-20231208142201338](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20231208142201338.png)

![image-20231208142607321](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20231208142607321.png)

**二叉树的五种形态**

![image-20231212154947632](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20231212154947632.png)

#### 算法题

**[二叉树的遍历](#遍历二叉树)**（肯定会考，李健说的)

递归遍历：先(根)序遍历，中序遍历，后序遍历

非递归遍历：运用栈实现、层次遍历

**[二叉树和树、森林之间的转换](#树与二叉树之间的转换)**

**[二叉树的线索化（要会画，有实线画虚线）](#线索二叉树)**

霍夫曼树（重点）

最优树带权路径长度(WPL)

霍夫曼编码

140页习题

### 第六章图

#### 概念

aoe  aov

最小生成树

关键路径，关键活动、强连通图、强连通分量

181页习题

计算图中结点的出入度

计算图中路径长度

操作题：

图的链接矩阵，连接表的。。表示

图的深度、广度优先遍历  156页

图的两种最小生成树算法162页

广度优先遍历最小生成树

深度优先遍历最小生成树

会用Dijkstra算法167页

关键路径解决哪两个问题

### 第七章查找

概念：asl、bst、avl、二叉排序树

计算查找成功时的平均查找长度、查找失败时的平均查找长度

关键字的顺序不变，二叉排序树的插入查找，，

平衡二叉树的调整，

218页，散列表（重点），查找某元素存在的过程

### 第八章排序

概念：

什么是排序，为什么要排序

稳定的排序算法有哪些，不稳定的排序算法有哪些

什么是堆

计算题：
253页，8.5.7

260页8.2的排序方法

（除了基数排序其他都可能考）

希尔排序，折半查找排序等



## 算法大题（两个）

顺序表，单链表，根据复杂度要求设计算法

循环队列的实现，双栈的实现

二叉树的遍历算法

有关二叉树的统计和判断

顺序查找算法的实现（递归或非递归）

折半查找算法的实现（递归或非递归）



选择排序，冒泡排序等

# 课程内容

![image-20230915173220628](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20230915173220628.png)

## 0x1绪论

**数据**：是能输入计算机且能被计算机处理的各种符号的集合

**数据元素**：是数据的基本单位，在计算机程序中通常作为一个整体进行考虑和处理

​					也成为元素，或称为记录、结点或顶点

​					数据元素可以由若干的数据项组成

**数据项**：构成数据元素的不可分割的最小单位

**数据对象**：是性质相同的数据元素的集合，是数据的一个子集

### 1数据结构

是指相互之间存在一种或多种特定关系的数据元素集合

包含三方面内容：

1.数据元素之间的逻辑关系（逻辑结构）
2.数据元素及其关系在计算机内存中的表示（物理结构或储存结构）
3.数据的运算和实现

#### 逻辑结构与存储结构的关系

- 存储结构是逻辑关系的映像与元素本身的映像
- 逻辑结构是数据结构的抽象，储存结构是数据结构的实现
- 两者综合起来就建立了数据结构之间的关系

### 2逻辑结构的种类

#### 划分方式一：

##### 线性结构

有且仅有一个开始和一个终端结点，并且所有结点都最多只有一个直接前驱和一个直接后继

如：线性表、栈、队列、串

##### 非线性结构

一个结点可能有多个直接前驱和直接后继

例如：树、图

#### 划分方式二：

集合结构：数据元素之间同属于一个集合

线性结构：数据元素之间存在着一对一的线性关系

树形结构：数据元素之间存在一对多的层次关系

图状结构：数据元素之间存在着多对多的任意关系

### 3存储结构的种类

#### 顺序存储结构

连续的存储单元依次存储数据元素，数据元素之间逻辑关系由存储位置表示

#### 链式存储结构

任意的存储单元来存储数据，数据元素之间的逻辑关系用指针来表示

<img src="https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20230915221332564.png" alt="image-20230915221332564" style="zoom:80%;" />

#### 索引存储结构

在存储信息本身的同时，还建立附加的索引表
索引表中每一项称为一个**索引项**（关键字，地址）

若每个结点在索引表中都有一个索引项，则该索引表称之为**稠密索引**
若一组结点在索引表中只对应一个索引项，则该索引表称之为**稀疏索引**

#### 散列存储结构

### 4数据类型

一组性质相同的**值的集合**，以及定义上的**一组操作**的总成

#### 抽象数据类型ADT

指一个数学模型以及定义在此数学模型上的一组操作

##### 形式定义

<img src="https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20230915223919313.png" alt="image-20230915223919313" style="zoom:67%;" />

##### 定义格式

<img src="https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20230915224010846.png" alt="image-20230915224010846" style="zoom:67%;" />

（数据对象和数据关系的定义用伪代码描述）

##### 定义举例：复数的定义

<img src="https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20230915232131454.png" alt="image-20230915232131454" style="zoom:67%;" />

带&是返回数据，不带的是传入数据

### 5算法

**定义：**对特定问题求解方法和步骤的一种描述，它是指令的有限序列。其中每个指令表示一个或多个操作。

**描述：**自然语言，流程图，伪代码，程序代码

**时间复杂度**

辅助函数f(n)，使得当n趋近无穷大时，T(n)/f(n)的极限值为**不等于零的常数**，则称f(n)是T(n)的同数量级函数。记作**T(n)=O(f(n))**，称O(f(n))为算法的渐进时间复杂度（O是数量级的符号），简称**时间复杂度**

时间复杂度是由嵌套最深层语句的频度决定的

**空间复杂度**

算法所需储存空间的度量，记作S(n)=O(f(n))，其中n为问题的规模或大小

#### 时间效率的度量：

##### 事前分析

算法运行时间=一个简单操作所需要的时间x简单操作次数

同时也=∑每条语句执行的次数(语句频度)x该语句执行一次所需要的时间

为了便于比较不同算法的时间效率，一般仅比较其数量级

![image-20230921213934253](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20230921213934253.png)

##### 事后统计

利用计算机内的计时工能，不同算法的程序可以用一组或多组相同的统计数据区分。

**缺点：**

①必须先运行依据算法编制的程序

②所的时间统计量依赖于硬件、软件等环境因素，掩盖算法本身的优劣

## 0x2线性表

### 1定义和特点

线性表是具有相同特性的数据元素的一个有限序列

![image-20230926202442240](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20230926202442240.png)

线性表（Linear List）由n(n>=0)个数据元素（结点）a1,a2,,,,an组成的有限序列

- 数据元素的个数n定义为表的长度
- 当n=0时称为空表
- 当非空的线性表(n>0)记作：(a1,a2,,,,,,an)
- 这里的数据元素ai(1<=i<=n)只是一个抽象的符号，其中具体含义在不同的情况下可以不同

同一线性表中的元素必定有相同特征，数据元素的关系是线性关系

#### [案例]：稀疏多项式运算

线性表A=((7,0),(3,1),(9,8),(5,17))
线性表B=((8,4),(22,7),(-9,8))

- 创建一个新数组c
- 分别从头遍历比较a和b的每一项

​			指数相同：对应系数相加，若其和不为零，则在c中增加一个新项
​			指数不相同，则将指数较小的项复制到c中

- 一个多项式已遍历完毕时，将另一个剩余项一次复制到c中即可

#### 顺序储存结构存在的问题

储存空间分配不灵活

运算的空间复杂度高

#### 总结

线性表中数据元素的类型可以为简单类型，也可以为复杂类型
从具体应用中抽象出共性的逻辑结构和基本操作（抽象数据类型）

### 2类型的定义

抽象数据类型线性表的定义如下：

<img src="https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20230926221030160.png" alt="image-20230926221030160" style="zoom:67%;" />

#### 基本操作

- 构造一个空的线性表L：`InitList(&L)`
- 销毁线性表L：`DestroyList(&L)`
- 将线性表L重置为空表：`ClearList(&L)`
- 判断线性表L是否为空：`ListEmpty(L)`
- 返回线性表L中的数据元素个数：`ListLength(L)`
- 用e返回线性表L中第i个数据元素的值：`GetElem(L,i,&e);`（1<=i<=ListLength(L)）
- 返回L中第1个与e满足compare()的数据元素的为序：`LocateElem(L,e,compare())`
- 求一个元素的前驱：`PriorElem(L,cure_e,&pre_e)`
- 求一个元素的后继：`NextElem(L,cure_e,&next_e)`
- 线性表中插入一个元素：`ListInsert(&L,i,e)`（1<=i<=ListLength(L)）
- 线性表中删除一个元素：`ListDelete(&L,i,&e)`
- 线性表元素遍历：`ListTraverse(&L,visited())`

### 3顺序表示和实现

顺序表示又称为**顺序存储结构**或**顺序映像**

定义：把逻辑上相邻的数据元素存储在物理上相邻的存储单元中的存储结构。

线性表顺序存储结构占用一片连续的存储位置，假设线性表的每个元素需占i个存储单元，则第i+1个数据元素的存储位置和第i个数据元素的存储位置之间满足关系：

![image-20231005131938792](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20231005131938792.png)

所有数据元素的存储位置均可由第一个数据元素的存储位置得到：

![image-20231005132229691](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20231005132229691.png)

LOC(a1)即为基地址

![image-20231006003040332](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20231006003040332.png)

#### 顺序表的描述

##### 静态数组

![image-20231006003218903](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20231006003218903.png)

##### 动态数组

![image-20231006003240050](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20231006003240050.png)

---

顺序表跟高级语言中数组的性质类似，我们可以用一维数组来表示顺序表：

![image-20231005132934383](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20231005132934383.png)

但线性表长可变(可增删)，而数组长度不可动态定义，那我们可以用一变量表示顺序表的长度属性。

线性表定义模板：

![image-20231005134011433](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20231005134011433.png)

#### 多项式的顺序存储结构类型定义

![image-20231005134451245](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20231005134451245.png)

![image-20231005134845842](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20231005134845842.png)

##### 传值方式

把实参的值传送给函数局部工作区相应的副本中，函数使用这个副本执行必要的功能。函数修改的是副本的值，实参的值不变。

###### 指针变量作参数

![image-20231006000946309](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20231006000946309.png)

###### 数组名作参数

传递的是数组的首地址

对形参数组所作的任何改变都将反映到实参数组中

![image-20231006001252573](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20231006001252573.png)

###### 引用类型作参数

引用：用来给一个对象提供一个替代的名字

![image-20231006001642894](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20231006001642894.png)

![image-20231006001859743](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20231006001859743.png)

三点说明：
(1)传递引用给函数与传递指针的效果一样
(2)引用类型作形参，在内存中没有产生实参的副本，而是直接对实参操作
(3)指针传参易产生错误，阅读性差；在主调函数的调用点处，必须用变量的地址作为实参

##### 补充：预定义常量和类型

![image-20231006133606337](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20231006133606337.png)

#### 顺序表基本操作的实现

线性表L的初始化（参数用**引用**）

```
Status InitList_Sq(SqList &L){			//构造一个空顺序表	
	L.elem=new ElemType[MAXSIZE];		//为顺序表分配空间		
	if(!L.elem)exit(OVERFLOW);			//储存分配失败	
	L.length=0;							//空表长度为0	
	return OK;
}
```

销毁线性表L

```
void DestroyList(SqList &L){
	if(L.elem)delete L.elem;			//释放存储空间
}
```

 清空线性表L

```
void ClearList(SqList&L){
	L.length=0;							//将线性表长度设为0		
}
```

求线性表L长度

```
int GetLength(SqList L){
	return(L.length)
}
```

判断线性表L是否为空

```
int IsEmpty(SqList){
	if(L.length==0)return 1;
	else return 0;
}
```

顺序表的取值（根据位置i获取相应位置数据元素的内容）

```
int GetElem(SqList L,int i,ElemType &e){
	if(i<1||i>L.length) return ERROR;		//判断合理性
	e=L.elem[i-1];
	return OK;
}
```

顺序表的查找

- 在线性表L中查找与指定值e相同的数据元素的位置
- 从表的一段开始，逐个进行记录的关键字和给定值的比较。找到，返回该元素位置序号，未找到，返回0

平均查找长度ASL：为确定记录在表中的位置，需要与给定值进行比较的关键字的个数的期望值

```
int LocateElem(SqList L,ElemType e){
	for(i=0;i<L.length;i++)
		if(L.elem[i]==e) return i+1;
	return0;
}
```

顺序表的插入

- 插入位置在最后
- 插入位置在中间
- 插入位置在最前面

​	线性表的插入运算是指在表的第i（1<=i<=n+1）个位置上，插入一个新结点e，使长度n的线性表（a1,...,ai-1,ai,...,an）变成长度为n+1的线性表（a1,...ai-1,e,ai,...an）

​	算法思想：

1)判断插入位置i是否合法
2)判断顺序表的存储空间是否已满，若已满返回ERROR
3)将第n至第i位的元素以此向后移动一个位置，空出第i个位置
4)将要插入的新元素e放入第i个位置
5)表长加1，插入成功返回OK

```
Status ListInsert_Sq(SqList &L,int i,ElemType e){
	if(i<1 || i>L.length+1)return ERROR;
	if(L.length==MAXSIZE)return ERROR;
	for(j=L.length-1 ;j>=i-1 ;j--)
		L.elem[j+1]=L.elem[j];
	L.elem[i-1]=e;
	L.length++;
	return OK;
}
```

顺序表的删除

​	线性表的删除运算是指将表的第i（1<=i<=n）个结点删除，使长度为n的线性表变成长度为n-1的线性表

​	算法思想：

1)判断删除位置i是否合法
2)将欲删除的元素保留在e中
3)将第i+1至第n位的元素以此向前移动一个位置
4)表长减1，删除成功返回OK

```
Status ListDelete_Sq(SqList &L,int i){
	if((i<1)||(i>L.length)) return ERROR;
	for(j=i;j<=L.length-1;j++)
	L.elem[j-1]=L.elem[j]'
	L.length--;
	return OK;
}
```

#### 顺序表算法分析

- 时间复杂度

查找，插入，删除算法的平均时间复杂度为O(n)

- 空间复杂度

顺序表操作算法的空间复杂度S(n)=O(1)

#### 顺序表优缺点

优点：

- 存储密度大
- 可以随机存取表中任一元素

缺点：

- 在插入、删除某一元素时，需要移动大量元素
- 浪费存储空间
- 属于静态存储形式，数据元素的个数不能自由扩充

### 4链式表示和实现

**链式存储结构：**结点在储存器中的位置是任意的，即逻辑上相邻的数据元素在物理上不一定相邻。

线性表的链式表示又称为**非顺序映像**和**链式映像**

用一组**物理位置任意的存储单元**来存放线性表的数据元素，这组存储单元既可以是连续的，也可以是不连续的，甚至是零散分布在内存中的任意位置上。链表中的逻辑次序和物理次序不一定相同。

#### 链式存储有关的术语

1.结点：数据元素的存储映像。由数据域和指针域两部分组成
2.链表：n个结点由指针链组成一个链表

带头单链结点表示意图：

<img src="https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20231007142421807.png" alt="image-20231007142421807" style="zoom:80%;" />

3.单链表：结点只有一个指针域的链表，称为单链表或线性链表
4.双链表：结点有两个指针域的链表
5.循环链表：首尾相接的链表

<img src="https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20231007142901335.png" alt="image-20231007142901335" style="zoom: 80%;" />

6.头指针：指向链表中第一个结点的指针
7.首元结点：链表中存储第一个数据元素a1的结点
8.头结点：在链表的首元结点之前附设的一个结点

<img src="https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20231007143154892.png" alt="image-20231007143154892" style="zoom:80%;" />

两种形式：

![image-20231007144535593](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20231007144535593.png)

#### 如何表示空表

无头结点时，头指针为空时表示空表

<img src="https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20231007145644045.png" alt="image-20231007145644045" style="zoom: 80%;" />

有头结点时，当头结点的指针域为空时表示空表

<img src="https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20231007145850272.png" alt="image-20231007145850272" style="zoom:80%;" />

#### 设置结点有什么好处

1.便于首元结点的处理（无需对首元结点进行特殊处理）

2.便于空表和非空表的统一处理

#### 头结点数据域装什么

头结点的数据域可以为空，也可以存放线性表长度等附加信息，但此结点不能计入链表长度值

#### 链表的特点

1）结点在储存器中的位置时任意的
2）访问时只能通过头指针进入链表，并通过每个结点的指针域一次向后顺序扫描其余结点，寻找第一个结点和最后一个结点所花费的时间不等
3）顺序表时随机存存取，连表示顺序存取

#### 单链表的储存结构

![image-20231007154540989](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20231007154540989.png)

单链表定义：

```
typedef struct Lnode{
	ElemType data;				//结点的数据域
	struct Lnode *next;			//结点的指针域
}Lnode,*LinkList;
```

案例：为统一链表操作，通常这样定义：

```
typedef Struct{
	char num[8];		//数据域
	char name[8];		//数据域
	int score;			//数据域
}ElemType;

typedef struct Lnode{
	ElemType data;		//数据域
	struct Lnode *next;	//指针域
}Lnode,*LinkList;
```

#### 单链表基本操作的实现

**单链表初始化**（构造一个空表）
算法步骤：
1)生成新结点作头结点，用头指针L指向头结点
2)将头结点的指针域置空

```
Status InitList_L(LinkList &L){
	L=new LNode;		//或L=(LinkList)malloc(sizeof(LNode));
	L->next=NULL;
	return OK;
}
```

**判断链表是否为空**

即判断头结点指针域是否为空

空表：链表中无元素，称为空链表（头指针和头结点仍然在）

```
int ListEmpty(LinkList L){
	if(L->next)		//非空
		return 0;
	else
		return 1;
}
```

**单链表的销毁**：链表销毁后不存在

从头指针开始，依次释放所有结点

```
Status DestroyList_L(LinkList &L){
	Lnode *p;
	while(L){
		p=L;
		L=L->next;
		delete p;
	}
	return OK;
}
```

**清空链表**

链表仍存在，但链表中无元素，称为空链表（头指针和头结点仍然在）

依次释放所有结点，并将头结点指针域设置为空

```
Status ClearList(LinkList &L){
	Lnode *p,*q;
	p=L->next;
	while(p){
		q=p->next;
		delete p;
		p=q
	}
	L->next=NULL;
	return OK;
}
```

**求单链表的表长**

```
int ListLength_L(LinkList L){
	LinkList p;
	p=L->next;
	i=0;
	while(p){
		i++;
		p=p->next;
	}
	return i;
}
```

**取单链表中第i个元素的内容**

```
Status GetElem_L(LinkList L,int i,ElemType &e){
	p=L->next;j=1;
	while(p&&j<i){				//向后扫描，直到p指向第i个元素或p为空
		p=p->next;++j;
	}
	if(!p||j>i)return ERROR;
	e=p->data;
	return OK;
}//GetElem_L
```

**按值查找**(根据指定数据获取该数据所在地址)

```
Lnode *LocateElem_L(LinkList L,ElemType e){
	p=L->next;
	while(p&&p->data!=e){
		p=p->next;
	}
	return p;
}
```

**按值查找**(根据指定数据获取数据位置序号)

```
int LocateElem_L(LinkList L, ElemType e){
	p=L->next; j=1;
	while(p&&P->data!=e)
		{p=p->next; j++;}
	if(p) return j;
	else return 0;
}
```

**插入**(在第i个结点前插入值为e的新结点)

```
Status ListInsert_L(LinkList &L,int i,ElemType e){
	p=L;j=0;
	while(p&&j<i-i){p=p->next;++j;}
	if(!p||j>i-1) return ERROR;
	s=new LNode; s->data=e;
	s->next=p->next;
	p->next=s;
	return OK;
}//ListInsert_L
```

**删除**(删除第i个结点)

```
Status ListDelete_L(LinkList &L,int i,ElemType &e){
	p=L;j=0;
	while(p->next&j<i-1){p=p->next;++j;}		//寻找第i结点，并令p指向其前驱
	if(!(p->next)||j>i-1)return ERROR;
	q=p->next;
	p->next=q->next;
	e=q->data;
	delet q;
	return OK;
}
```

##### 时间效率分析

1.查找：

因为线性链表只能顺序存取，即在查找时要从头指针找起，查找的时间复杂度为：`O(n)`

2.插入和删除：

因为线性表不需要移动元素，只需要修改指针，一般情况下时间复杂度为O(1)
但如果要在单链表中进行前插或删除操作，由于要从头查找前驱结点，所耗时间复杂度为O(n)

#### 建立单链表

**头插法——元素插入在链表头部，也叫前插法**

1.从一个空表开始，重复读入数据；
2.生成新结点，将读入数据存放到新结点的数据域中
3.从最后一个结点开始，依次将个节点插入到链表的前端

构造一个新结点

```
L=new LNode;							//C++语法
L=(LinkList)malloc(sizeof(LNode));		//C语言语法
```

算法：

```
void CreateList_H(LinkList &L,int n){
	L=new LNode;
	L->next=NULL;				//建立一个带头结点的单链表
	for(i=n;i>0;--i){
		p=new LNode;			
		cin>>p->data;			//输入元素
		p->next=L->next;		//输入表头
		L->next=p;
	}
}
```

头插法时间复杂度：`O(n)`

**尾插法——元素插入在链表尾部，也叫后插法**

1.从一个空表L开始，将新结点逐个插入到链表尾部，尾指针r指向链表的尾结点。
2.初始时，r同L均指向头结点。每读入一个数据元素则申请一个新结点，将新结点插入到尾结点后，r指向新结点。

```
void CreateList_R(LinkList &L,int n){
	L=new LNode;	L->next=NULL;
	r=L;		//尾指针r指向头结点
	for(i=0;i<n;i++){
		p=new LNode; cin>>p->data;	//生成新结点，输入元素值
		p->next=NULL;
		r->next=p;		//插入到表尾
	}
}
```

#### 循环链表

是一种头尾相接的链表（表中最后一个结点的指针域指向头结点，整个链表形成一个环

<img src="https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20231014223217635.png" alt="image-20231014223217635" style="zoom:80%;" />

**优点：**从表中任一结点出发均可找到表中其他结点

**注意：**由于循环链表中没有NULL指针，故设计遍历操作时，其终止条件就不再像非循环链表那样判断p或p->next是否为空，而是判断它们是否等于头指针。

**循环条件：**

![image-20231014224138055](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20231014224138055.png)

表的操作常常是在表的首尾位置上进行

## 0x3栈和的队列

### 栈

**顺序栈进栈**

（1）判断是否栈满，若满则出错

（2）元素e压入栈顶

（3）栈顶指针+1



**两个栈共享一个数组空间**
两个站的栈底分别位于数组空间两端，栈顶向中间移动

栈空：top[i]=bot[i]

栈满：top[0]+1=top[1]（或top[1]-1=top[0]）



**链栈**

运算是受限的单链表，只能在链表头部进行操作，故没有必要附加头结点。栈顶指针就是链表的头指针。

**算法实现**

```
typedef  struct StackNode {
      SElemType  data;
      struct StackNode *next;
 } StackNode,  *LinkStack;
LinkStack S;   
```

![image-20231221170138169](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20231221170138169.png)

#### 递归

一个对象部分地包含它自己，或用他自己给自己定义，则称这个对象是递归的；
若一个过程直接地或间接地调用自己，则称这个过程是递归过程

```
多个函数构成嵌套调用时，遵循后调用先返回原则
```

**递归定义的数学函数**

阶乘函数，2阶Fibonaci数列...

**递归定义的数据结构**

二叉树，广义表...

**分治法求解递归问题**

分治法：对于一个较为复杂的问题，能够分解成几个相对简单的且解法相同或类似的子问题来求解。

##### 函数调用过程

调用前，系统完成

(1)将实参，返回地址等传递给被调用函数

(2)为被调用函数的局部变量分配储存区

(3)将控制转移到被调用函数的入口

调用后，系统完成：

(1)保存被调用函数的计算结果

(2)释放被调用函数的数据区

(3)依照被调用函数保存的返回地址将控制转移到调用函数

##### 递归算法的效率分析

空间效率：与递归树的深度成正比
时间效率：与递归树的结点成正比

##### 递归的优缺点

优点：结构清晰，程序易读

缺点：每次调用要生成工作记录，保存状态信息，入栈；返回时要出栈，恢复状态信息。时间开销大。

### 队列

队列的顺序表示----一维数组base[M]

#### 循环队列----取模运算

入队：

```
base[rear]=x;
rear=(rear+1)%M;
```

出队：

```
x=base[front];
front=(front+1)%M;
```

初始（队空）：

```
front=rear=0
```

队满：

```
front=rear
```

入队：

```
base[rear++]=x;
```

出队：

```
x=base[front--];
```

循环队列：

```
#define MAXQSIZE100
Typedef struct{
	QelemType
	
}
```

##### 案例：数值的转化

##### 案例：括号的匹配

##### 案例：迷宫求解（回溯法）

## 0x4串、数组和广义表

**定义**

串(string)——零个或多个字符组成的有限序列

```
S='a1a2...an'
```

**结构**

```
typedef struct{
   char *ch;      //若串非空,则按串长分配存储区,
                  //否则ch为NULL
   int  length;   //串长度
}HString;
```

![image-20231221165203442](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20231221165203442.png)

**算法实现**

```
#define CHUNKSIZE 80       //可由用户定义的块大小
typedef struct Chunk{
   char  ch[CHUNKSIZE];
   struct Chunk *next;
}Chunk;

typedef struct{
   Chunk *head,*tail;      //串的头指针和尾指针
   int curlen;             //串的当前长度
}LString;
```

**特点**

优点：操作方便
缺点：存储密度较低

<img src="https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20231221165402300.png" alt="image-20231221165402300" style="zoom:67%;" />

可将多个字符存放在一个结点中，以克服其缺点

![image-20231221165450621](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20231221165450621.png)

#### 补充：C语言中常用的串运算

调用标准库函数：`#include<string.h>`

```
串比较，strcmp(char s1,char s2)
串复制，strcpy(char to,char from)
串连接，strcat(chat to,char from)
求串长，strlen(char s)
....
```

### 串的模式匹配算法

- 两个串：主串：S，模式串T（数组储存）
- 从主串S中找到和T相等的子串，返回位置

#### 1.BruteForce算法

时间复杂度：`O(S[0]*T[o])`

> （主串）i=st（初始位置）
>
> （模式串）j=1（从头开始比较）
>
> 若S[i]==T[j]，则++j，++i；若仍然相等，则重复该过程，若出现不相等，则执行下述操作
>
> 若S[i]!=T[j]，则i=i-j+2（从上个比较点的下一位开始），j=1
>
> 若i>S[0]（串的长度）（或j>T[0]），结束操作

```
int Index(String S,string T, int* POS){
	i=st;j=1;
	while(i<=S[0]&&j<=T[0]){	//S[0]存储串S的长度
		if(S[i]==T[i])	++i;+++j;
		else  i=i-j+2; j=1;
	}
	if(i>S[0])	POS=0;
	else POS=i-T[0];
}
```

##### 时间复杂度

总次数为：`(n-m)*m+m＝(n-m+1)*m`

若m<<n，则算法复杂度O(n*m)

#### 2.KMP算法

时间复杂度：`O(S[0]+T[0])`

改进：不回溯i指针，利用已得到的部分匹配结果，将模式串向右滑动，尽可能得到新j

```
int Index(String S,string T, int* POS){
	i=st;j=1;
	while(i<=S[0]&&j<=T[0]){				//S[0]存储串S的长度
		if(j==0||S[i]==T[i])	++i;++j;
		else j=next[j];
	}
	if(i>S[0])	POS=0;
	else POS=i-T[0];
}
```

定义next[j]函数，表明当模式中第j个字符与主串相应字符匹配“失败”时，执行此函数。

![image-20231221165832497](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20231221165832497.png)

##### 如何求next函数的值：

1.next[1]=0;表明主串从下一字符si+1起和模式串重新开始匹配。i=i+1;j=1;

2.设next[j]=k，则next[j+1]=?

​	①若pk=pj，则有"p1...pk-1pk”="pj-k+1...pj-1pj"，如果在j+1发生不匹配，说明next[j+1]=k+1=next[j]+1。

​	②若pk!=pj，可把求next值问题看成是一个模式匹配问题，整个模式串既是主串又是子串。











### 特殊矩阵的压缩存储

#### 压缩存储

若多个数据元素的值都相同，则只分配一个元素值的储存空间，且零元素不占储存空间。

#### 什么样的矩阵能压缩存储

一些特殊矩阵：对称矩阵，对角矩阵，三角矩阵，稀疏矩阵

#### 对称矩阵

特点：在nxn的矩阵a中，满足性质aij=aji（1<=i,j<=n）

存储方法：只能存储上（或者下）三角（包括主对角线）的数据元素。共占`n(n+1)/2`个元素空间。

![image-20231221164514098](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20231221164514098.png)

#### 三角矩阵

特点：对角线以下（或者以上）的数据元素（不包括对角线）全部为常数c。

![image-20231221164556311](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20231221164556311.png)

储存方法：重复元素c共享一个元素存储空间，共占用`n(n+1)/2+1`个元素空间：`sa[1...n(n+1)/2+1]`

![image-20231221164621149](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20231221164621149.png)

#### 对角矩阵(带状矩阵)

特点：在nxn的方阵中，非零元素集中在主对角线及其两侧共L(奇数)条对角线的带状区域内——L对角矩阵。

储存方法：

![image-20231221164722205](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20231221164722205.png)

#### 稀疏矩阵

矩阵中非零元素的个数较少（一般小于5%）

特点：大多数元素为0。

常用存储方法：只记录每一非零元素（i，j，aij），节省空间但丧失随机存取功能。

​	顺序存储：三元组表

​	链式存储：十字（正交）链表

![image-20231221164810519](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20231221164810519.png)

### 广义表

n个表元素组成的有限序列，记作`LS=(a0,a1.a2......,an-1)`

LS是表名，ai是表元素，它可以是表（称为子表），可以是数据元素（称为原子）。

n为表的长度，n=0的广义表为空表。

#### 广义表和线性表的区别

- 线性表的成分都是结构上不可分的单元素
- 广义表的成分可以是单元素，可以是有结构的表
- 线性表是一种特殊的广义表
- 广义表不一定是线性表，也不一定是线性结构

#### 广义表的基本运算

(1)求表头`GetHead(L)`：非空广义表的第一个元素，可以是一个单元素，也可以是一个子表。

(2)求表尾`GetTail(L)`：非空广义表除去表头元素以外其他元素所构成的表，表尾一定是一个表。

#### 广义表特点

- 有次序性：一个直接前驱和一个直接后继
- 有长度=表中元素个数
- 有深度=表中括号重数
- 可递归：自己可以作为自己的子表
- 可共享：可以为其他广义表所共享

## 0x5树和二叉树

树：是n个结点的有限集，它或为空树；或为非空树，对于非空树T：

1. 有且仅有一个称之为根的结点
2. 除根结点以外的其余结点可分为m（m>0）个互不相交的有限集T1，T2，...,Tm其中每一个结合本身又是一棵树 ，并且称为根的子树（SubTree）

#### 树的其他表示方式

嵌套集合，凹入表示，广义表

#### 基本术语

![image-20231117143337138](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20231117143337138.png)

```
根——根结点（无前驱）
叶子——终端结点（无后继）
森林——指m棵不相交的树的集合
一棵树可以看成是一个特殊的森林，但森林不一定是树（给森林中的各子树加上一个双亲结点，森林就成了树）
有序树——结点各子树从左至右有序，不能互换（左为第一）
无序树——结点各子树课互换位置

双亲
孩子
兄弟
堂兄弟
祖先
子孙
结点——树的数据元素
结点的度——结点挂接的子树数
结点的层次——从根到该结点的层数
终端结点——度为0的结点
分支结点——度不为0的结点
树的度——所有结点度中的最大值
树的深度——所有结点中最大的层数
```

### 二叉树

是n（n>=0）个结点所构成的集合，它或为空树，或为非空树，对于非空树T：

1. 有且仅有一个称之为根的结点
2. 除根结点以外的其余结点分为两个互不相交的子集T1和T2，分别成为T的左子树和右子树，且T1和T2本身又都是二叉树

#### 基本特点：

- 结点的度<=2
- 有序树（子树有序，不能颠倒）
- 二叉树可以是空集合，根可以有空的左子树或者空的右子树

#### 为什么要用二叉树：

- 结构最简单，规律性最强
- 可以证明，所有树都能转为唯一对应的二叉树，不失一般性。
- 普通树若不转化为二叉树，运算很难实现

**注**：

二叉树不是树的特殊情况，这是两个概念

二叉树结点的子树分为左子树和右子树，而树是不区分左右次序的

![image-20231117144655678](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20231117144655678.png)

**性质1：**在二叉树的第i层上至多有2^(i-1)个结点（至少有1个结点）

**性质2：**深度为k的二叉树至多有2^k-1个结点（至少有k个结点）

**性质3：**对于任何一棵二叉树，若2度的结点数有n2个，则叶子数n0必定为n2+1（即n0=n2+1）

##### 案例6.1：数据压缩问题

将数据文件转换成由0、1组成的二进制串，称之为编码

![image-20231117144833829](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20231117144833829.png)

##### 案例6.2：利用二叉树求解表达式的值

以二叉树表示表达式的递归定义如下：
（1）若表达式为数或简单变量，则相应二叉树中仅有一个根结点，其数据域存放该表达式信息；

（2）若表达式“第一操作数  运算符  第二操作数”的形式，则相应的二叉树中以左子树表示第一操作数，右子树表示第二操作数，根结点的数据域存放运算符（若为一元运算符，则左子树为空），其中，操作数本身有为表达式。

![image-20231117145445840](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20231117145445840.png)

#### 二叉树的抽象数据类型定义

![image-20231121114802436](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20231121114802436.png)

#### 二叉树的性质

![image-20231124140944074](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20231124140944074.png)

![image-20231124141049405](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20231124141049405.png)

![image-20231124141405912](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20231124141405912.png)

##### 满二叉树

![image-20231124144204209](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20231124144204209.png)

满二叉树一定是完全二叉树，完全二叉树不一定是满二叉树

##### 完全二叉树

![image-20231124144628826](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20231124144628826.png)

注：在满二叉树中，从最后一个结点开始，连续去掉任意个结点，即是一棵完全二叉树

特点：

- 叶子只可能分布在层次最大的两层上

- 对任一结点，如果其右子树的最大层次为i，其左子树的最大层必为i或i+1

##### 完全二叉树性质

![image-20231129215850640](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20231129215850640.png)

![image-20231129221208814](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20231129221208814.png)

#### 二叉树的存储结构

![image-20231205174512826](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20231205174512826.png)

##### 顺序存储

实现：按满二叉树的结点层次编号，一次存放二叉树中的数据元素

```
//二叉树顺序存储表示
#define MAXSIZE 100
Typedef TElemType SqBiTree[MAXSIZE]
SqBiTree bt;
```

特点：结点间关系蕴含再其存储位置中，浪费空间，适于存**满二叉树**和**完全二叉树**

![image-20231129224954413](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20231129224954413.png)

##### 链式存储

![image-20231205175017545](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20231205175017545.png)

**二叉链表**

```
typedef struct BiNode{
	TElem Type data;
	struct BiNode *Lchild,*rchild;
}BiNode,*BiTree;
```

![image-20231205184001753](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20231205184001753.png)

**三叉链表**

![image-20231205184304347](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20231205184304347.png)

#### 遍历二叉树

**遍历定义：**顺着某一条搜索路径巡访二叉树中的结点，使得每个结点均被访问一次，而且仅被访问一次。

**遍历目的：**得到树中的所有结点的一个线性排列。

**遍历用途：**它是树结构插入、删除、修改、查找和排序运算的前提，是二叉树一切运算的基础和核心。

**遍历方法：**依次遍历二叉树中的三个部分，便是遍历了整个二叉树。

若规定先左后右，则只有三种情况：

![image-20231205185536799](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20231205185536799.png)

![image-20231205191847053](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20231205191847053.png)

##### 递归遍历算法

**先序遍历**

```
Stauts PreOrderTraverse(BiTree T){
 if(T==NULL) return OK;	//空二叉树
 else{
 	visit(T);	//访问根结点
 	PreOrderTraverse(T->lchild);  //递归遍历左子树
 	PreOrderTraverse(T->rchild);  //递归遍历右子树
 }
}
```

![image-20231205194234549](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20231205194234549.png)

**中序遍历**

```
Status InOrderTraverse(BiTree T){
	if(T==NULL) return OK;
	else{
		InOrderTraverse(T->lchild);
		visit(T);
		InOrderTraverse(T->rchild);
	}
}
```

**后序遍历**

```
Status PostOrderTraverse(BiTree T){
	if(T==NULL) return OK;
	else{
		InOrderTraverse(T->lchild);
		InOrderTraverse(T->rchild);
		visit(T);
	}
}
```

**遍历算法分析**

![image-20231205195203180](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20231205195203180.png)

时间复杂度：O(n)	//每个结点之访问一次

空间效率：	O(n)	//栈占用的最大辅助空间

##### 非递归遍历

以中序遍历为例

使用栈来实现

```
Status InOrderTraverse(BiTree T){
	BiTree p; InitStack(S); p=T;
	while(p || !StackEmpty(S)){
		if(p) {Push(S,p); p=p->lchild;}
		else  {Pop(S,q);  printf("%c",q->data);
				p=q->rchild;}
	}//while
	return OK;
}
```

##### 层次遍历

对于一颗二叉树，从根结点开始，按从上到下、从左到右的顺序访问每一个结点。每个结点仅仅访问一次。

使用队列来实现

循环队列类型定义：

```
typedef struct{
	BTNode data[MaxSize];	//存放队中元素
	int front, rear;		//队头和队尾指针
}SqQueue					//顺序循环队列类型
```

层次遍历算法：

```
void LevelOrder(BTNode *b){
	BTNode *p;  SqQueue *qu;
	InitQueue(qu);
	enQueue(qu,b);
	while(!QueueEmpty(qu)){
		deQueue(qu,p);
		printf("%c",p->data);
		if(p->lchild!=NULL) enQueue(qu,p->lchild);
		if(p->rchild!=NULL) enQueue(qu,p->rchild)；
	}
}
```

#### 遍历算法的应用

##### 创建二叉树

按先序遍历序列建立二叉树的二叉链表

对下图所示二叉树，按下列顺序读入字符：

```
ABC##DE#G##F###
```

![image-20231205222028251](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20231205222028251.png)

```
Status CreateBiTree(BiTree &T){
  scanf(&ch);
  if(ch=="#") T = NULL;
  else{
    if(!(BiTNode *)malloc(sizeof(BiTNode)))
      exit(OVERFLOW);
    T->data = ch;
    CreateBiTree(T->lchild);
    CreateBiTree(T->rchild);
  }
  return OK;
}
```

##### 复制二叉树

```
int Copy(BiTree T, BiTree &NewT){
	if(T==NULL){
		NewT=NULL; return 0;
	}
	else{
		NewT=new BiTNode;   NewT->data=T->data;
		Copy(T->lChild,  NewT->lchild)
		Copy(T->rChild,  NewT->rchild)
	}
}
```

##### 计算二叉树深度

```
int Depth(BiTree){
  if(T==NULL)  return 0;
  else{
  		m=Depth(T->lChild);
  		n=Depth(T->rChild);
  		if(m>n) return(m+1);
  		else return(n+1);//比较左右子树最大深度并+1
  }
}
```

##### 计算二叉树结点总数

```
int NodeCount(BiTree T){
   if(T==NULL)
     return 0;
   else
     return NodeCount(T->lchild)+NodeCount(T->rchild)+1;
}
```

##### 计算二叉树叶子结点总数

```
int LeadCount(BiTree T){
   if(T==NULL)
      return 0;
   if(T->lchild==NULL&&T->rchild==NULL)
      return 1;
   else
      return LeafCount(T->lchild)+LeafCount(T->rchild);
}
```

#### 线索二叉树

利用二叉链表中的空指针域：

如果某个个结点的左孩子为空，则将空的左孩子指针域改为指向其前驱；如果某结点的右孩子为空，则将空的右孩子指针域改为指向其后继，这种改变指向的指针称为“线索”，加上了线索的二叉树称为线索二叉树（Threaded Binary Tree）。

为区分lchild和rchild指针是指向孩子的指针还是指向前驱或者后继的指针，对二叉链表中每个结点增设两个标志域ltag和rtag，并约定：

ltag=0 lchild指向该结点的左孩子
ltag=1 lchild指向该结点的前驱

rtag=0 rchild指向该结点的右孩子
rtag=1 rchild指向该结点的后继

结点的结构：

![image-20231206094855781](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20231206094855781.png)

```
typedef struct BiThrNode{
  int data;
  int ltag,rtag;
  struct BiThrNode *lchild,rchild;
}
```

为避免第一个结点和最后一个结点悬空

![image-20231206095640989](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20231206095640989.png)

### 树和森林

#### 树的存储结构

##### 双亲表示法

**实现：**定义结构数组存放树的结点，每个结点含两个域
**数据域：**存放节点本身信息
**双亲域：**指示本结点的双亲结点在数组中的位置

根结点的下标为0，我们取根结点的双亲结点（不存在）下标为-1

**特点：**找双亲容易，找孩子难

```
typedef struct PTNode{
	TElemType data;
	int parent;			//双亲位置域
}
```

##### 孩子链表表示法

把每个结点的孩子结点排列起来，看成是一个线性表，用单链表存储则把n个结点由n个孩子链表（叶子的孩子链表为空表）。而n个头指针又组成一个线性表，用顺序表（含n个元素的结构数组）存储。

![image-20231207112412383](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20231207112412383.png)

孩子结点结构：

```
typedef struct CTNode{
	int child;
	struct CTNode *next;
}
```

双亲结点结构：

```
typedef struct{
	TElemType data;
	ChildPtr firstchild;
}
```

树结构：

```
typedef struct{
	CTBox nodes[MAX_TREE_SIZE];
	int n,r;
}
```

**特点：**找孩子容易，找双亲难

##### 孩子兄弟表示法（二叉链表的表示法）

**实现：**用二叉链表作树的存储结构，链表中每个结点的两个指针域分别指向其第一个孩子节点和下一个兄弟结点

```
typedef struct CSNode{
	ElemType data;
	Struct CSNode *firstchild,*nextsibing;
}CSNode,*CSTree;
```

![image-20231207113551885](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20231207113551885.png)

**特点：**找孩子和兄弟容易，找双亲困难

#### 树与二叉树之间的转换

##### 树与二叉树的转换

- 将树化为二叉树进行处理，利用二叉树的算法来实现对树的操作
- 由于树和二叉树都可以使用二叉链表作储存结构，则以二叉链表作媒介可以导出树与二叉树之间的一个对应关系

**下图中的树和二叉树有相同的二叉链表:**

![image-20231207114453199](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20231207114453199.png)

给定一一棵树，可以找到唯一的一棵二叉树与之对应

**树变二叉树：兄弟相连留长子**

①加线：在兄弟之间加一连线
②抹线：对每个结点，除了其左孩子外，去除其与其余孩子之间的关系
③旋转：以树的根结点为轴心，将树顺时针旋转45°

**二叉树变树：左孩右右连双亲，去掉原来右孩线**

①加线：若p结点是双亲结点的左孩子，则将p的右孩子，右孩子的右孩子....沿分支找到的所有右孩子，都与p的双亲用线连起来
②抹线：抹掉原二叉树中双亲与右孩子之间的连线 
③调整：将结点按层次排列，形成树结构

##### 森林转化为二叉树

**森林变二叉树：树变二叉根相连**

①将各棵树分别转换成二叉树
②将每个数的根结点用线相连
③以第一棵树根结点为二叉树的根，再以根节点为轴心，顺时针旋转，构成二叉树结构

##### 二叉树转换成森林

**二叉树变森林：去掉全部右孩线，孤立二叉再还原**

①抹线：将二叉树根结点与其右孩子连线，及沿右分支搜索到的所有右孩子间连线全部抹掉，使之变成孤立的二叉树
②还原：将孤立的二叉树还原成树

#### 树的遍历

##### 先根（次序）遍历：

若树不空，则先访问根结点，然后依次先根遍历各棵子树。

##### 后根（次序）遍历：

若树不空，则先依次后根遍历各棵子树，然后访问根结点。

##### 按层次遍历：

若树不空，则自上而下自左至右访问树种每个结点。

#### 森林的遍历

将森林看作由三个部分构成：

1.森林中第一棵树的根结点
2.森林中第一个棵树的子树森林
3.森林中其他树构成的森林

##### 先序遍历

依次从左至右对森林中的每一棵树进行先根遍历

若森林不为空，则：

1.访问森林中第一棵树的根结点
2.先序遍历森林中第一棵树的子树森林
3.先序遍历森林中（除第一棵树之外）其余树构成的森林

#####  中序遍历

依次从左至右对森林中的每一棵树进行后根遍历

若森林不为空，则

1.中序遍历森林中第一棵树的子树森林
2.访问森林中第一棵树的根结点
3.中序遍历森林中（除第一棵树之外）其余树构成的森林

#### 哈夫曼树

**路径：**由一结点到另一结点间的分支所构造

**路径长度：**两结点间路径上的分支数目

**带权路径长度：**结点到根的路径长度与结点上权的乘积

**树的带权路径长度：**树中所有叶子结点的带权路径长度之和

<img src="https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20231209112327670.png" alt="image-20231209112327670" style="zoom:67%;" />

**哈夫曼树：**带权路径长度最小的树

##### 哈夫曼树构造过程

**基本思想：**使权大的结点靠近根

**操作要点：**对权值的合并、删除与替换，总是合并当前值最小的两个

**构造过程：**

1. 根据给定的n个权值{w1,w2,……wn}，构造n棵只有根结点的二叉树。
2. 在森林中选取两棵根结点权值最小的树作左右子树，构造一棵新的二叉树，置新二叉树根结点权值为其左右子树根结点权值之和。
3. 在森林中删除这两棵树，同时将新得到的二叉树加入森林中。
4. 重复上述两步，直到只含一棵树为止，这棵树即哈夫曼树。

**算法实现：**

一棵有n个叶子结点的Huffman树有    个结点

采用顺序存储结构——一维结构数组

**节点类型定义：**

```
typedef  struct
{  int weght;
   int parent,lch,rch;
}*HuffmanTree;
```

**算法：**

```
1)初始化HT[1..2n-1]：lch=rch=parent=0
2)输入初始n个叶子结点：置HT[1..n]的weight值
3)进行以下n-1次合并，依次产生HT[i]，i=n+1..2n-1：
   3.1)在HT[1..i-1]中选两个未被选过的weight最小的两个结点HT[s1]和HT[s2] (从parent = 0 的结点中选)
   3.2)修改HT[s1]和HT[s2]的parent值： parent=i
   3.3)置HT[i]：weight=HT[s1].weight + HT[s2].weight ,lch=s1,  rch=s2
```

##### 哈夫曼编码

哈夫曼编码是不等长编码

哈夫曼编码是前缀编码，即任一字符的编码都不是另一字符编码的前缀

哈夫曼编码树中没有度为1的结点。若叶子结点的个数为n，则哈夫曼编码树的结点总数为 2n-1

发送过程：根据由哈夫曼树得到的编码表送出字符数据

接收过程：按左0、右1的规定，从根结点走到一个叶结点，完成一个字符的译码。反复此过程，直到接收数据结束

**代码实现：**

```
void CreatHuffmanCode(HuffmanTree HT, HuffmanCode &HC, int n){
//从叶子到根逆向求每个字符的赫夫曼编码，存储在编码表HC中
HC=new char *[n+1];         		//分配n个字符编码的头指针矢量
cd=new char [n];			//分配临时存放编码的动态数组空间
cd[n-1]=’\0’; 	//编码结束符
for(i=1; i<=n; ++i){	//逐个字符求赫夫曼编码
    start=n-1; c=i; f=HT[i].parent;                 			
    while(f!=0){	//从叶子结点开始向上回溯，直到根结点
         --start;                          			//回溯一次start向前指一个位置
         if (HT[f].lchild= =c)  cd[start]=’0’;	//结点c是f的左孩子，则生成代码0
         else cd[start]=’1’;               		//结点c是f的右孩子，则生成代码1
         c=f; f=HT[f].parent;             		//继续向上回溯
    }                                  		//求出第i个字符的编码      
    HC[i]= new char [n-start];         	// 为第i 个字符编码分配空间
    strcpy(HC[i], &cd[start])；    //将求得的编码从临时空间cd复制到HC的当前行中
  }
  delete cd;                            	//释放临时空间
} // CreatHuffanCode
```

![image-20231209113420207](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20231209113420207.png)

#### 文件的编码和解码

1.编码：

①输入个字符及其权值
②构造哈夫曼树HT[i]
③进行哈夫曼编码HC[i]
④查HC[i]，得到各字符的哈夫曼编码

2.解码

①构造哈夫曼树
②依次读入二进制码
③读入0，则走向左孩子；读入1，则走向右孩子
④一旦到达某叶子时，即可译出字符
⑤然后再从根出发继续译码，直到结束

## 0x6图

### 图的定义和术语

**图：**`Graph=(V,E)` 
V：顶点(数据元素)的有穷非空集合；  
E：边的有穷集合。

**无向图：**每条边都是无方向的

**有向图：**每条边都是有方向的

**完全图：**任意两个点都有一条边相连

![image-20231209114516951](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20231209114516951.png)

**稀疏图：**有很少边或弧的图。

**稠密图：**有较多边或弧的图。

**网：**边/弧带权的图。

**邻接：**有边/弧相连的两个顶点之间的关系。
			存在(vi, vj)，则称vi和vj互为邻接点；
			存在<vi, vj>，则称vi邻接到vj， vj邻接于vi 

**关联(依附)：**边/弧与顶点之间的关系。
			存在(vi, vj)/ <vi, vj>， 则称该边/弧关联于vi和vj

**顶点的度：**与该顶点相关联的边的数目，记为TD(v)

在有向图中, 顶点的度等于该顶点的入度与出度之和。顶点 v 的入度是以 v 为终点的有向边的条数, 记作 ID(v) 顶点 v 的出度是以 v 为始点的有向边的条数, 记作OD(v)

<img src="https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20231209114951137.png" alt="image-20231209114951137" style="zoom:80%;" />

**路径：**接续的边构成的顶点序列。
**路径长度：**路径上边或弧的数目/权值之和。
**回路(环)：**第一个顶点和最后一个顶点相同的路径。
**简单路径：**除路径起点和终点可以相同外，其余顶点均不相同的路径。
**简单回路(简单环)：**除路径起点和终点相同外，其余顶点均不相同的路径。

<img src="https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20231209115110297.png" alt="image-20231209115110297" style="zoom:80%;" />

**连通图（强连通图）**

在无（有）向图G=( V, {E} )中，若对任何两个顶点 v、u 都存在从v 到 u 的路径，则称G是连通图（强连通图）。

<img src="https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20231209115244536.png" alt="image-20231209115244536" style="zoom:80%;" />

**权与网**

图中边或弧所具有的相关数称为权。表明从一个顶点到另一个顶点的距离或耗费。带权的图称为网。

**子图**

设有两个图G=（V，{E}）、G1=（V1，{E1}），若V1属于V，E1属于 E，则称 G1是G的子图。例:(b)、(c) 是 (a) 的子图

![image-20231209115552286](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20231209115552286.png)

**连通分量（强连通分量）**

无向图G 的极大连通子图称为G的连通分量。

极大连通子图意思是：该子图是 G 连通子图，将G 的任何不在该子图中的顶点加入，子图不再连通。

![image-20231209115655675](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20231209115655675.png)



有向图G 的极大强连通子图称为G的强连通分量。

极大强连通子图意思是：该子图是G的强连通子图，将D的任何不在该子图中的顶点加入，子图不再是强连通的。

![image-20231209115813637](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20231209115813637.png)

**极小连通子图：**该子图是G 的连通子图，在该子图中删除任何一条边，子图不再连通。

**生成树：**包含无向图G 所有顶点的极小连通子图。

**生成森林：**对非连通图，由各个连通分量的生成树的集合。    

![image-20231209115947702](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20231209115947702.png)

### 图的类型定义

图的抽象数据类型定义：

![image-20231210002047718](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20231210002047718.png)<img src="https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20231210002225739.png" alt="image-20231210002225739"  />

### 图的存储结构

#### 邻接矩阵（数组）

![image-20231210005122906](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20231210005122906.png)

**无向图的邻接矩阵表示法**

![image-20231210005555478](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20231210005555478.png)

分析1：无向图的邻接矩阵是对称的。
分析2：顶点i的度=第i行（列）中1的个数。
特别：完全图的邻接矩阵中，对角元素为0，其余为1。

**有向图的邻接矩阵表示法**

![image-20231210010821692](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20231210010821692.png)

分析1：有向图的邻接矩阵可能是不对成的。
分析2：顶点的出度=第i行元素之和
			  顶点的出度=第i列元素之和
			  顶点的度=第i行元素之和+第i列元素之和。

**网（有权图）的邻接矩阵表示法**

![image-20231210011424009](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20231210011424009.png)

##### 邻接矩阵的存储表示

用两个数组分别存储定点表和邻接矩阵

```
//用两个数组分别存储顶点表和邻接矩阵
#define MaxInt 32767                    	//表示极大值，即∞
#define MVNum 100                       	//最大顶点数 
typedef char VerTexType;              	//假设顶点的数据类型为字符型 
typedef int ArcType;                  	//假设边的权值类型为整型 
typedef struct{ 
  VerTexType vexs[MVNum];            		//顶点表 
  ArcType arcs[MVNum][MVNum];      		//邻接矩阵 
  int vexnum,arcnum;                		//图的当前点数和边数 
}AMGraph; 
```

###### 创建无向网

算法思想：

1. 输入总顶点的数和总边数
2. 依次输入点的信息存入顶点表中
3. 初始化邻接矩阵，使每个权值初始化为极大值
4. 构造邻接矩阵

算法实现：

```
Status CreateUDN(AMGraph &G){ 
    //采用邻接矩阵表示法，创建无向网G 
    cin>>G.vexnum>>G.arcnum; 	//输入总顶点数，总边数 
    for(i = 0; i<G.vexnum; ++i)    
      cin>>G.vexs[i];                        	//依次输入点的信息 
    for(i = 0; i<G.vexnum;++i) 	//初始化邻接矩阵，边的权值均置为极大值
       for(j = 0; j<G.vexnum;++j)   
         G.arcs[i][j] = MaxInt;   
    for(k = 0; k<G.arcnum;++k){                     //构造邻接矩阵 
      cin>>v1>>v2>>w;                                 //输入一条边依附的顶点及权值 
      i = LocateVex(G, v1);
      j = LocateVex(G, v2);  //确定v1和v2在G中的位置
      G.arcs[i][j] = w; //边<v1, v2>的权值置为w 
      G.arcs[j][i] = G.arcs[i][j];              //置<v1, v2>的对称边<v2, v1>的权值为w 
   }//for 
   return OK; 
}//CreateUDN
```

补充算法：在图中查找顶点

```
int LocateVex(AMGraph G,VertexType u){
//图G中查找顶点u，存在则返回顶点表中的下标；否则返回-1
  int i;
  for(i=0;i<G.vexnum;++i)
    if(u==G.vexs[i])  return i;
  return -1;
}
```

###### 创建无向图和有向网

![image-20231210111245583](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20231210111245583.png)

##### 邻接矩阵特点

**优点：**容易实现图的操作，如：求某顶点的度、判断顶点之间是否有边、找顶点的邻接点等等。

**缺点：**n个顶点需要n*n个单元存储边;空间效率为O(n2)。 对稀疏图而言尤其浪费空间。

#### 邻接表（链式）

![image-20231210112005573](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20231210112005573.png)

**顶点：**按编号顺序将顶点数据存储在一维数组中

**关联统一顶点的边（以顶点为尾的弧）：**用线性链表存储

**无向图的表示方式**

![image-20231210113639854](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20231210113639854.png)

**特点：**

- 邻接表不唯一
- 若无向图中由n个顶点、e条边、则其邻接表需要n个头结点和2e个表结点。适合存储稀疏图。
- 无向图中顶点vi的度为第i个单链表中的结点数。

**有向图的表示方式**

![image-20231210133746755](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20231210133746755.png)

**邻接表特点：**

- 顶点vi的出度为第i个单链表中的结点个数
- 顶点vi的入度为则很难哥哥但李娜表中邻接点域值是i-1的结点个数

**逆邻接表特点：**

- 顶点vi的入度为第i个单链表中的结点个数
- 顶点vi的出度为整个单链表中邻接点域值是i-1的结点个数

##### 顶点的结点结构

```
typedef struct VNode{
  VerTexType data;
  ArcNode *firstarc;
}VNode,AdjList[MVNum]
```

##### 弧（边）的结点结构

```
#define MVNum 100		//最大顶点数
typedef struct AceNode{	//边结点
  int adjvex;			//该边所指向的顶点的位置
  struct ArcNode *nextarc;  //指向下一条边的指针
  OtherInfo info;		//和边相关的信息
}Arcnode;
```

##### 图的结构

```
typedef struct{
  AdjList vertices;
  int vexnum,arcnum;
}ALGraph;
```

##### 邻接表储存表示

###### 创建无向图

1. 输入总顶点数和总边数
2. 建立顶点表，依次输入点的信息存入顶点表中，是每个表头结点的指针域初始化为NULL
3. 创建邻接表，依次输入每条边依附的两个顶点，确定两个顶点的序号i和j，建立边结点，将此边结点分别插入到vi和vj对应的两个边链表的头部

```
Status CreateUDG(ALGraph &G){ 
　　//采用邻接表表示法，创建无向图G 
　  cin>>G.vexnum>>G.arcnum;         //输入总顶点数，总边数 
    for(i = 0; i<G.vexnum; ++i){     //输入各点，构造表头结点表 
       cin>> G.vertices[i].data;     //输入顶点值 
       G.vertices[i].firstarc=NULL;  //初始化表头结点的指针域为NULL 
    }//for 
    for(k = 0; k<G.arcnum;++k){      //输入各边，构造邻接表 
       cin>>v1>>v2;                  //输入一条边依附的两个顶点 
       i = LocateVex(G, v1);  j = LocateVex(G, v2);    
       p1=new ArcNode;               //生成一个新的边结点*p1 
　　  p1->adjvex=j;                   //邻接点序号为j 
　  　p1->nextarc= G.vertices[i].firstarc; 
　  　			 G.vertices[i].firstarc=p1;  
      //将新结点*p1插入顶点vi的边表头部 
      p2=new ArcNode; //生成另一个对称的新的边结点*p2 
　　  p2->adjvex=i;                   //邻接点序号为i 
　  　p2->nextarc= G.vertices[j].firstarc;  G.vertices[j].firstarc=p2;  
      //将新结点*p2插入顶点vj的边表头部 
    }//for 
    return OK; 
}//CreateUDG 
```

##### 邻接表特点

- 方便找任一顶点的所有“邻接点”
- 节约稀疏图的空间，需要N个头指针+2E个结点（每个结点至少两个域）

- 对于无向图，方便计算任一顶点的”度“
- 对于有向图，之恩那个计算“出度”，需要构造”逆邻接表“来方便计算”出度“

- 不方便检查任意一堆顶点间是否存在边

#### 邻接矩阵和邻接表的关系

![image-20231210145833327](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20231210145833327.png)

##### 联系

邻接表中的每个链表对应于邻接矩阵中的一行，链表中结点个数等于一行中非零元素的个数。

##### 区别

①对于任一确定的无向图，邻接矩阵是唯一的（行列号于顶点编号一致），但邻接表不唯一（链接次序于顶点编号无关）。

②邻接矩阵的空间复杂度为O(n^2)，而邻接表的空间复杂度为O(n+e).

##### 用途

邻接矩阵多用于稠密图

邻接表多用于稀疏图

#### 十字链表

Orthogonal List 是**有向图**的另一种链式存储结构，我们可以把它看成是将有向图的邻接表和逆邻接表结合起来形成的一种链表。

有向图的每一条弧对应是链表中的一个**弧结点**，同时有向图中的每个顶点在十字链表中对应有一个结点，叫做**顶点节点**。

![image-20231210152419623](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20231210152419623.png)

#### 邻接多重表

每条边只存储一次，解决邻接表操作不方便的问题

![image-20231210153601376](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20231210153601376.png)

### 图的遍历

#### 遍历定义

从已给的连通图中某一顶点出发，沿着一些边访问图中所有的顶点，且使每个顶点仅被访问一次，叫做图的遍历，它是图的基本运算。

**遍历的实质：**找每个顶点的邻接点过程

**图的特点：**图中可能存在回路，且图的任一顶点都可能与其他顶点相同，在访问完某个顶点之后可能会沿着某些边又回到了曾经访问过的顶点。

**如何避免重复访问：**设置辅助数组visitied[n]，来标记每个被访问过的顶点。
								   初始状态visited[i]为0
								   顶点i被访问，改visited[i]为1，防止被多次访问

**图常用的遍历：**

- 深度优先搜索（Depth_First Search——DFS）
- 广度优先搜索（Breadth_First Search——BFS）

#### 深度优先遍历（DFS）

- 在访问图中某一其实顶点v后，由v出发，访问它的任一邻接顶点w1；
- 再从w1出发，访问与w1邻接但还未被访问过的顶点w2；
- 然后再从w2出发，进行类似的访问，....
- 如此进行下去，直至到达所有的邻接顶点都被访问过的顶点u为止。
- 接着，退回一步，退到前一次刚访问过的顶点，看是否还有其他没有被访问的邻接顶点。
- 如果有，则访问此顶点，之后再从此顶点出发，进行与前述类似的访问；
- 如果没有就再退回一步进行搜索。重复上述过程，直到连通图中所有顶点都被访问过为止。

连通图的深度优先遍历类似于树的先根遍历

##### 算法实现

引入辅助数组`visited[n]`来确保每个结点只访问一次

![image-20231210173841199](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20231210173841199.png)

```
void DFS(AMGraph G, int v){        	//图G为邻接矩阵类型 
  cout<<v;  visited[v] = true;  	//访问第v个顶点
  for(w = 0; w< G.vexnum; w++)  	//依次检查邻接矩阵v所在的行  
        if((G.arcs[v][w]!=0)&& (!visited[w]))  
            DFS(G, w); 
        //w是v的邻接点，如果w未访问，则递归调用DFS 
} 
```

##### 效率分析

- 用**邻接矩阵**来表示图，遍历图中每一个顶点都要从头扫描该顶点所在行，时间复杂度为O(n^2)。
- 用**邻接表**来表示图，虽然有2e个表结点，但只需扫描e个结点即可完成遍历，加上访问n个头结点的时间，时间复杂度为O(n+e)。

**结论：**

- **稠密图**适于再邻接矩阵上进行深度遍历
- **稀疏图**适于再邻接表上进行深度遍历

##### 非连通图的遍历

先访问一个连通分量，当访问完再访问另一个连通分量

#### 广度优先遍历（BFS）

**方法：**从图的某一结点出发，首先依次访问该结点的所有邻接点，再按这些顶点被访问的先后次序依次访问与它们相邻接的所有未被访问的顶点。重复此过程，直至所有顶点均被访问为止。

##### 非递归遍历连通图

```
void BFS (Graph G, int v){ 
    //按广度优先非递归遍历连通图G 
    cout<<v; visited[v] = true;     //访问第v个顶点
    InitQueue(Q);              		//辅助队列Q初始化，置空         
    EnQueue(Q, v);            		//v进队 
    while(!QueueEmpty(Q)){   		//队列非空 
       DeQueue(Q, u);        		//队头元素出队并置为u 
       for(w = FirstAdjVex(G, u); w>=0; w = NextAdjVex(G, u, w)) 
       if(!visited[w]){             //w为u的尚未访问的邻接顶点 
             cout<<w; visited[w] = true;	EnQueue(Q, w); //w进队 
          }//if 
    }//while 
}//BFS 

```

##### 效率分析

用**邻接矩阵**，则BFS对于每一个被访问到的顶点，都要循环检测矩阵中的整整一行（n个元素），总的时间代价为O(n^2)。

用**邻接表**，虽然有2e个表结点，但只需要扫描e个结点即可完成遍历，加上访问n个头结点的时间，时间复杂度为O(n+e)。

#### DFS与BFS算法效率比较

空间复杂度相同，都是O(n)（借用了堆栈或队列）；

时间复杂度只与存储结构（邻接矩阵或邻接表）有关，而与搜索路径无关。

### 图的应用

无向图的生成树

![image-20231210224507922](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20231210224507922.png)

#### 最小生成树

Minimum Spanning Tree

给定一个无向网络，在该网的所有生成树中，是的个边权值之和最小的那棵生成树称为该网的最小生成树，也叫最小代价生成树。

**MST性质：**设N=(V,E)是一个连通网，U是顶点集V的一个非空子集。若边(u,v)是一条具有最小权值的边，其中u属于U，v属于V-U，则必存在一颗包含边(u,v)的最小生成树。

**MST性质解释：**在生成树的构造过程中，图中n个顶点分数两个集合：

- 已落在生成树上的顶点集：U
- 尚未落在生成树上的顶点集：V-U

接下来应该在所有连通U中顶点和V-U中顶点的边中选取权值最小的边。

**贪心算法(Greedy Algorithm)：**以当前情况为基础作最优选择，而不考虑各种可能的整体情况，所以贪心法不要回溯。（因为省去了为寻找解而穷尽所有可能所必须耗费的大量时间，因此算法效率高。）

##### 普里姆(Prim)算法

**算法思想：**

- 设连通网络 N = { V, E }，从某顶点 u0 出发，选择与它关联的具有最小权值的边(u0, v)，将其顶点加入到生成树的顶点集合U中
- 每一步从一个顶点在U中，而另一个顶点不在U中的各条边中选择权值最小的边(u, v),把它的顶点加入到U中
- 直到所有顶点都加入到生成树顶点集合U中为止

##### 克鲁斯卡尔(Kruskal)算法

**算法思想：**

- 设连通网络 N = { V, E }，构造一个只有 n 个顶点，没有边的非连通图 T = { V,  }, 每个顶点自成一个连通分量
- 在 E 中选最小权值的边,若该边的两个顶点落在不同的连通分量上，则加入 T 中；否则舍去，重新选择
- 重复下去，直到所有顶点在同一连通分量上为止

**最小生成树可能不唯一 **

##### 两种算法比较

| **算法名**     | **普里姆算法**   | **克鲁斯卡尔算法** |
| -------------- | ---------------- | ------------------ |
| **算法思想**   | 选择点           | 选择边             |
| **时间复杂度** | O(n^2),n为顶点数 | O(eloge),e为边数   |
| **适应范围**   | 稠密图           | 稀疏图             |

**Prim算法：**归并顶点，与边数无关，适于稠密网

**Kruskal算法：**归并边，适于稀疏网

#### 最短路径

##### 单源最短路径——Dijkstra(迪杰斯特拉)算法

1. 初始化：先找出从源点v0到各终点vk的直达路径（v0,vk），即通过一条弧到达的路径。
2. 选择：从这些路径中找出一条长度最短的路径（v0,u）。
3. 更新：然后对其余各条路径进行适当调整：若在图中存在弧（u,vk），且（v0,u）+（u,vk）<（v0,vk）,则以路径（v0,u,vk）代替（v0,vk）。

在调整后的各条路径中，再找长度最短的路径，依此类推。

**步骤：**

1.把V分成两组

（1）S：已求出最短路径的顶点的集合。

（2）T=V-S：尚未确定最短路径的顶点集合。

2.将T中顶点按最短路径递增的次序加入到S中，保证：

（1）从源点v0到s中各顶点的最短路径长度都不大于从v0到T中任何顶点的最短路径长度。

（2）每个顶点对应一个距离值。

**S中顶点：**从v0到此顶点的最短路径长度。

**T中顶点：**从v0到此顶点的只包括S中顶点作中间顶点的最短路径长度。

##### 所有顶点间的最短路径——Floyd(弗洛伊德)算法

**算法思想：**

逐个试探顶点，从vi到vj的所有可能存在的路径中选出一条长度最短的路径。

**步骤：**

初始时设置一个n阶方阵，令其对角线元素为0，若存在弧<vi,vj>，则对应元素为权值；否则为∞。

逐步试着再原直接路径中增加中间点，若加入中间顶点后路径变短，则修改；否则，维持原值。所有顶点试探完毕，算法结束。

#### 有向无环图

DAG图（Directed Acycline Graph），常用来描述一个工程或系统的进行过程。

##### AOE网

用一个有向图表示一个工程的各子工程及其相互制约的关系，以**弧**表示活动，以顶点表示活动的开始或结束事件，称这种有向图为边表示活动的网，简称AOE网（Activity On Edge）。

**用途：**估算工程项目的完成时间

**术语：**

源点：整个工程开始点，也称起点。

收点：整个工程结束点，也称汇点。

事件结点：单位时间，表示的是时刻。

活动（有向边）：它的权值定义为活动进行所需要的时间。方向表示起始结点事件先发生，而终止结点事件才能发生。

事件的最早发生时间（Ve(j)）：从起点到本结点的最长的路径。意味着事件最早能够发生的时刻。

事件的最迟发生时间（Vl (j)）：不影响工程的如期完工，本结点事件必须发发生的时刻。

活动的最早开始时间：e( ai ) = Ve( j )    活动的最迟开始时间：l( ai ) = Vl( k ) - dut( j , k )。

##### AOV网

用一个有向图表示一个工程的各子工程及其相互制约的关系，其中以**顶点**表示活动，弧表示活动之间的优先制约关系，这种有向图称为顶点表示活动的网，简称AOV网（Activity On Vertex network）。

**拓扑排序：**

在AOV 网没有回路的前提下，我们将全部活动排列成一个线性序列，使得若 AOV 网中有弧 <i,j>存在，则在这个序列中，i一定排在j的前面，具有这种性质的线性序列称为**拓扑有序序列**，相应的拓扑有序排序的算法称为**拓扑排序**。

**拓扑排序的方法：**

- 在有向图中选一个没有前驱的顶点且输出之。
- 从图中删除该顶点和所有以它为尾的弧。
- 重复上述两步，直至全部顶点均已输出或者当图中不存在无前驱的顶点为止。

**一个AOV网的拓扑序列时不唯一的。**

**拓扑排序的应用：**检测AOV网中是否存在环：

对有向图构造其顶点的拓扑有序序列，若网中所有顶点都在它的拓扑有序序列中，则该AOV网必定不存在环。

#### 关键路径

把工程计划表示为**边表示活动的网络**，即**AOE网**，用顶点表示事件，弧表示活动，弧的权表示活动持续时间。

事件表示在它之前的活动已经完成，在它之后的活动可以开始。

关键路径——路径长度最长的路径。

路径长度——路径上各活持续时间之和。

**定义关键路径，需要定义4个描述量：**

![image-20231212100118016](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20231212100118016.png)

**如何找L(i)==e(i)的关键活动？**

![image-20231212102649235](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20231212102649235.png)

**如何求ve(j)和vl(j)?**

![image-20231212102749640](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20231212102749640.png)

**例题：**

![image-20231212114534015](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20231212114534015.png)

**关键路径的讨论：**

1. 若网中有几条关键路径则需加快同时在几条关键路径上的关键活动。
2. 如果一个活动处于所有的关键路径上，那么提高这个活动的速度，就能缩短整个工程的完成时间。
3. 处于所有的关键路径上的活动完成时间不能缩短太多，否则会使原来的关键路径变成不是关键路径。这时，必须重新寻找关键路径。



## 0x7查找

### 查找的基本概念

#### 名词解释

**查找表：**是由同一类型的数据元素(或记录) 构成的集合。由于“集合”中的数据元素之间存在着松散的关系，因此查找表是一种应用灵便的结构。

**关键字：**用来标识一个数据元素（或记录）的某个数据项的值。

**主关键字：**可唯一地标识一个记录的关键字是主关键字；
**次关键字：**反之，用以识别若干记录的关键字是次关键字。

**静态查找表：**仅作“查找”（检索）操作的查找表。
**动态查找表：**作“插入”和“删除”操作的查找表。

#### 查找算法的评价指标

关键字的平均比较次数，也称平均查找长度ASL(Average Search Length)

![image-20231218230146424](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20231218230146424.png)

### 线性表查找

#### 顺序查找

##### 应用范围

- 顺序表或线性表标识的静态查找表
- 表内元素之间无序

##### 数据元素类型定义

```
typedef struct{
  KeyType key;	//关键字域
  ....			//其他域
}ElemType;
```

##### 算法实现

```
int Search_Seq(SSTable ST,KeyType key){
  for(i=ST.length;i>=1;--i)
    if(ST.R[i].key==key)  return i;
  return 0;
}
```

**算法改进：**

把待查关键字key存入表头 (“哨兵”、“监视哨”) ，从前往后逐个比较，可免去查找过程中每一步都要检测是否查找完毕，加快速度。

```
int Search_Seq(SSTable ST,KeyType key) {
  ST.R[0].key = key;
  for(i = ST.length;ST.R[i].key != key; --i);
  return i;
}
```

当ST.length较大时，此改进能使进行依次查找所需的平均时间几乎减少一半。

##### 性能分析

**时间复杂度：**O(n)

**空间复杂度：**一个辅助空间——O(1)

##### 提高查找效率

**记录的查找概率不相等时如何提高查找效率？**

查找表存储记录原则——按查找概率高低存储：
1)查找概率越高，比较次数越少
2)查找概率越低，比较次数较多

**记录的查找概率无法测定时如何提高查找效率？**

方法——按查找概率动态调整记录顺序:

1)在每个记录中设一个访问频度域
2)始终保持记录按非递增有序的次序排列
3)每次查找后均将刚查到的记录直接移至表头

##### 特点

**优点:** 算法简单，逻辑次序无要求，且不同存储结构均适用。
**缺点:** ASL太长，时间效率太低。

#### 折半查找

每次将待查记录所在区间缩小一半。

##### 算法实现

（非递归）

```
int Search_Bin(SSTable ST, KeyType key){
  low=1;high=ST.length;
  while(low<=high){
    mid=(low+high)/2;
    if(ST.R[mid].key==key) return mid;
    else if(key<ST.R[mid].key)
      high=mid-1;
    else low=mid+1;
  }
  return 0;
}
```

（递归算法）

```
int Search_Bin(SSTable ST,KeyType key,int low,int high){
  if(low>high) return 0;
  mid=(low+high)/2;
  if(key==ST.elem[mid].key) return mid;
  else if(key<ST.elem[mid].key)
  .....//递归，在前半区间进行查找
  	else .....//递归，在后半区间进行查找
}
```

##### 性能分析

**判定树**

![image-20231219002501151](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20231219002501151.png)

**平均查找长度**

![image-20231219003244948](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20231219003244948.png)

##### 特点

**优点：**效率比顺序查找高。
**缺点：**只适用于有序表，且限于顺序存储结构(对线性链表无效)

#### 分块查找

（索引顺序查找）

##### 条件

1.将表分成几块，且表或者有序，或者分块有序；
若i<j，则第i块中所有记录的关键字均大于第i块中的最大关键字。

2.建立“索引表” (每个结点含有最大关键字域和指向本块第一个结点的指针，且按关键字有序)。

##### 查找过程

先确定待查记录所在块（顺序或折半查找），再在块内查找（顺序查找）。

![image-20231219005015854](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20231219005015854.png)

##### 性能分析

![image-20231219005239937](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20231219005239937.png)

##### 特点

**优点:** 插入和删除比较容易，无需进行大量移动。

**缺点:**要增加一个索引表的存储空间并对初始索引表进行排序运算。

**适用情况:** 如果线性表既要快速查找又经常动态变化，则可采用分块查找。

#### 查找方法比较

|          | 顺序查找         | 折半查找 | 分块查找         |
| -------- | ---------------- | -------- | ---------------- |
| ASL      | 最大             | 最小     | 中间             |
| 表结构   | 有序表、无序表   | 有序表   | 分块有序         |
| 储存结构 | 顺序表、线性链表 | 顺序表   | 顺序表、线性链表 |

### 树表的查找

#### 二叉排序树

Binary Sort Tree，又称为二叉搜索树、二叉查找树

##### 定义

**二叉排序树**或是空树，或是满足如下性质的二叉树：

(1)若其**左子树**非空，则左子树上所有结点的值均**小于根结点**的值
(2)若其**右子树**非空，则右子树上所有结点的值均**大于等于根结点**的值
(3)其左右子树本身又各是一棵二叉排序树

##### 性质

中序遍历非空的二叉排序树所得到的数据元素序列是一个按关键字排列的**递增有序**序列。

##### 存储结构

```
typedef struct{
  KeyType key;			//关键字项
  InfoType otherinfo;	//其他数据域
}ElemType;
```

```
typedef struct BSTNode{
  ElemType data;					//数据域
  struct BSTNode *Lchild,*rchild;   //左右孩子指针
}BSTNode,*BSTree
```

##### 算法实现

（递归）

```
BSTree SearchBST(BSTree T,KeyType key){
  if((!T)||key==T->data.key) return T;
  else if(key<T->data.key)
    return SearchBST(T->Lchild,key);
  else return SearchBST(T->rchild,key);
}//SearchBST
```

##### 性能分析

二又排序树上查找某关键字等于给定值的结点过程，其实就是走了一条从根到该结点的路径。

比较的关键字次数=此节点所在层数
最多的比较次数=树的深度

**平均查找长度**

含有n个结点的二叉排序树的**平均查找长度**和树的**形态**有关

**最好情况：**

初始序列{45,24,53,12,37,93)，ASL=log2 (n + 1) - 1；树的深度为:⌊log2 n⌋+ 1；与折半查找中的判定树相同。(形态比较均): O (log2 n)1

![image-20231219111542888](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20231219111542888.png)

**最坏情况：**

初始序列{12,24,37,45,53,93}插入的n个元素从一开始就有序，——变成单支树的形态！此时树的深度为n，ASL=(n+ 1)/2查找效率与顺序查找情况相同：O(n)

![image-20231219111617253](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20231219111617253.png)



##### 操作

###### 插入

插入的元素一定在叶节点上

###### 生成

一个无序序列可通过构造二叉排序树而变成一个有序序列。构造树的过程就是对无序序列进行排序的过程。

插入的结点均为叶子结点，故无需移动其他节点。相当于在有序序列插入记录而无需移动其他记录。

关键字输入顺序不同，建立的不同二叉排序树。

###### 删除

要保证删除后所得的二叉树仍满足二叉排序树的性质不变。

- 将因删除结点而断开的二叉链表重新连接起来
- 防止重新链接后树的高度增加

（1）被删除的结点是叶子结点：直接删去该结点。

（2）被删除的结点只有左子树或者只有右子树，用其左子树或者右子树替换它 (结点替换)。

其双亲结点的相应指针域的值改为“指向被删除结点的左子树或右子树”。

（3）被删除的结点既有左子树，也有右子树。

- 以其中序前趋值替换之（值替换），然后再删除该前趋结点。前趋时左子树中最大的结点。
- 也可以用其后继替换之，然后再删除该后继节点。后继是右子树中最小的结点。

![image-20231219113958907](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20231219113958907.png)

#### 平衡二叉树

Balanced Binary Tree，又称AVL树

一棵平衡二叉树或者是空树，或者是具有下列性质的二叉排序树：

- 左子树与右子树的高度之差的绝对值小于等于1；
- 左子树和右子树也是平衡二叉树。

为计算方便，给每个结点附加一个数字，给出该结点左子树与右子树的高度差。这个数字称为结点的平衡因子（BF）。

**平衡因子=结点左子树的高度-结点右子树的高度**

![image-20231219120159539](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20231219120159539.png)

对于一棵有n个结点的AVL树，其高度保持在O(log2 n)数量级，ASL保持在O(log2 n)量级

#### 分析与调整

如果在一棵AVL树中插入一个新结点后造成失衡，则必须重新调整树的结构，使之恢复平衡。

**平衡调整的四种类型：**

![image-20231219130521988](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20231219130521988.png)

A：失衡结点   不止一个失衡结点时，为最小失衡子树的根结点
B：A结点的孩子，C结点的双亲
C：插入新结点的子树

**调整原则：**

![image-20231219130758265](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20231219130758265.png)

①降低高度
②保持二叉排序树性质

### 散列表的查找

#### 基本概念

**基本思想：**记录的储存位置与关键字之间存在对应关系

对应关系——hash函数

**如何查找：**根据散列函数H(key)=k，查找key=9，则访问H(9)=9号地址，若内容为9则成功；若查不到，则返回一个特殊值，如空指针或空记录。

![image-20231219170622707](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20231219170622707.png)

**优点：**查找效率高
**缺点：**空间效率低

**散列方法（杂凑法）：**选取某个函数，依该函数按关键字计算元素的存储位置，并按此存放；查找时，由同一个函数对给定值k计算地址，将k与地址单元中元素关键码进行比，确定查找是否成功。

**散列函数（杂凑函数）：**散列方法中使用的转换函数。

**散列表（杂凑表）：**按上述思想构造的表。

**散列函数：**H(key)=k

**散列存储：**选取某个函数，依该函数按关键字计算元素的存储位置Loc(i)=H(keyi)

**冲突：**不同的关键码映射到同一个散列地址key1≠key2，但是H(key1)=H(key2)，在散列查找方法中，冲突是不可避免的，只能尽可能减少。

**同义词：**具有相同函数 值的多个关键字。

#### 散列函数的构造

##### 考虑的因素

①执行速度(计算散列函数所需时间)
②关键字的长度
③散列表的大小
④关键字的分布情况
⑤查找频率

##### 两个要求

①地址空间尽量小
②存储分布尽量均匀，避免冲突

##### 构造方法

直接定址法
数字分析法
平方取中法
折叠法
除留余数法
随机数法

###### 直接定址法

Hash(key) = a·key + b (a、b为常数)

**优点：**以关键码key的某个线性函数值为散列地址，不会产生冲突。
**缺点：**要占用连续地址空，空间效率低。

###### 除留余数法

Hash(key)=key mod p (p是一个整数)

设表长为m，取p<=m且为质数

#### 处理冲突的方法

##### 1.开放定址法(开地址法)

**基本思想：**有冲突时就去寻找下一个空的哈希地址，只要哈希表足够大，空的哈希地址总能找到，并将数据元素存入。

**常用方法：**

- 线性探测法

![image-20231219195155754](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20231219195155754.png)

其中：m为散列表长度
            di为增量序列1，2，...m-1，且di=i

**例：**关键码集为{47，7，29，11，16，92，22，8，3}，散列表表长为m=11，散列函数为Hash(key)=key mod 11；拟用线性探测法处理冲突。建散列表如下：

![](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20231219200221586.png)

平均查找长度ASL=(1+2+1+1+1+4+1+2+2)/9=1.67

**举一个查找失败的例子（线性探测）：**

假设我们给出的哈希函数是`H（key） = (key*3)%7`
对于一个数去%7，算出来的值不会超过7，故而查找时计算出的哈希地址只可能是0、1、2、3、4、5、6

假设我们要查找一个关键字m,计算出的哈希地址为0，
1.先去探测哈希地址0，发现不是，
2.去探测哈希地址1，发现不是
2.去探测哈希地址2，发现是空位置
发现是空的，说明查找失败了

![image-20231221220051226](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20231221220051226.png)

因此计算出的哈希地址为0的关键字，在该哈希表中查找失败的长度为`3`
同理，计算出的哈希地址为1的关键字，在该哈希表中查找失败的长度为`2`

![image-20231221220118977](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20231221220118977.png)

计算出的哈希地址为2的关键字，在该哈希表中查找失败的长度为`1`

![image-20231221220157640](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20231221220157640.png)

计算出的哈希地址为3的关键字，在该哈希表中查找失败的长度为`2`

![image-20231221220223138](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20231221220223138.png)

…

根据上述的推导过程，我们就可以得出查找失败的所有情况。

![image-20231221220254959](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20231221220254959.png)

故而，查找失败的情况只取决于哈希函数和空位置。
而对于一个需要查找的关键字，在还不知道具体数值的情况下，我们认为它计算出来的哈希地址落在每一个地址（0~6）的概率都相同，即1/7

根据数学期望的知识，可知查找失败的平均查找长度为：
`ASL = 3*（1/7）+ 2*（1/7）+1*（1/7）+2*（1/7）+1*（1/7）+5*（1/7）+4*（1/7）=18/7`







- 二次探测法 

![image-20231219201956522](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20231219201956522.png)

- 伪随机探测法

![image-20231219202023120](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20231219202023120.png)

##### 2.链地址法(拉链法)

**基本思想：**相同散列地址的记录链成一单链表。m个散列地址就设m个单链表，然后用一个数组将m个单链表的表头指针存储起来，形成一个动态的结构。

例如：一组关键字为{19,14,23,1,68,20,84,27,55,11,10,79}，散列函数为Hash(key)=key mod 13

![image-20231219202535855](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20231219202535855.png)

**链地址法优点：**

- 非同义词不会冲突
- 链表上结点空间动态申请，更适合于表长不确定的情况

**给定值查找值k，查找过程：**

![image-20231219202923736](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20231219202923736.png)

#### 查找效率分析

使用平均查找长度ASL来衡量查找算法，ASL取决于：

- 散列函数
- 处理冲突的方法
- 散列表的填装因子α

α=表中填入的记录数/哈希表的长度

α越大，表中记录数越多，说明表装得越满，发生冲突的可能性就越大，查找时比较次数就越多。

ASL与填装因子α有关，既不是严格的O(1)，也不是O(n)

![image-20231219203742215](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20231219203742215.png)

##### 结论

- 散列表基数与有很好的平均性能，优于一些传统的技术
- 链地址法优于开地址法
- 除留余数法作散列函数优于其他类型函数

## 0x8排序

### 概述

**什么是排序：**排序是将一组杂乱无章的数据按一定规律顺次排列起来

**排序的目的：**便于查找

#### 排序方法分类

##### 按照存储介质分

**内部排序：**数据量不大、数据在内存、无需内外存交换数据

**外部排序：**数据量较大、数据在外存（文件排序）

> 外部排序时，要将数据分批调入内存来排序，中间结果还要即使放入外存，外部排序要复杂得多。

##### 按比较器个数分

**串行排序：**单处理机(同一时刻比较一对元素)

**并行排序：**多处理机(同一时刻比较多对元素)

##### 按主要操作分

**比较排序：**用比较的方法

插入排序，交换排序，选择排序，归并排序

**基数排序：**不比较元素的大小，仅仅根据元素本身的取值确定其有序位置。

##### 按辅助空间分

**原地排序：**辅助空间用量为O(1)的排序方法。

（所占的辅助存储空间与参与排序的数据量大小无关）

**非原地排序：**辅助空间用量超过O(1)的排序方法。

##### 按稳定性分

**稳定排序：**能够使任何数值相等的元素，排序后相对次序 不变。

**非稳定性排序：**不是稳定排序的方法。

##### 按自然性分

**自然排序：**输入数据越有序，排序的速度越快的排序方法。

**非自然排序：**不是自然排序的方法。

记录序列以顺序表存储

```
#define MAXSIZE 20
typedef int KeyType;

Typedef struct{
	KeyType key;
	InfoType otherinfo;
}RedType;

typedef struct{
	RedType r[MAXISIZE+1];
	
	int length;
}SqList;
```

### 排序算法分类

规则不同：

- 插入排序
- 交换排序
- 选择排序
- 归并排序

时间复杂度不同：

- 简单排序
- 先进排序

#### 插入排序

**基本思想：**有序插入。

- 在有序序列中插入一个元素，保持序列有序，有序长度不断增加。
- 起初，a[0]是长度为1的子序列。然后，逐一将a[1]至a[n-1]插入到有序子序列中。

![image-20231220163857981](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20231220163857981.png)

##### 直接插入排序

![image-20231220180146029](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20231220180146029.png)

```
void InsertSort(SqList &L){
  int i,j;
  for(i=2;i<=L.length; ++i){
    if(L.r[i].key<L.r[i-1].key){  // 若"<",需将L.r[i]插入有序子表
    L.r[O]=L.r[i];				  // 复制为哨兵
    for(j=i-1;L.r[0].key<L.r[j].key;--j){
      L.r[j+1]=L.r[j];			  // 记录后移
    }
	L.r[j+1]=L.r[O];			  // 插入到正确位置
  }
 }
}
```

###### 性能分析

**基本操作：**

（1）“比较”序列中两个关键字的大小；

（2）“移动”记录。

**最好的情况**（关键字在记录序列中**顺序有序**）

![image-20231220182811885](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20231220182811885.png)

**最坏的情况**（关键字在记录序列中**逆序有序**）

![image-20231220183040548](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20231220183040548.png)

**最坏的情况**

![image-20231220183108955](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20231220183108955.png)

######  **结论**

- 原始数据越接近有序，排序速度越快
- 最坏情况（输入数据是逆有序的）	Tw(n)=O(n^2)
- 平均情况下，耗时差不多是最坏情况的一半	Te(n)=O(n^2)
- 要提高查找速度：
  - 减少元素的比较次数
  - 减少元素的移动次数

##### 折半插入排序

查找插入位置是采用折半查找法

![image-20231220193125476](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20231220193125476.png)

```
void BInsertSort(SqList &L){
  for(i=2;i<=L.length;++i){
    L.r[0]=L.r[i];
    low=1;high=i-1;
    while(low<=high){
      mid=(low+high)/2;
      if(L.r[0].key<L.r[mid].key) high=mid-1;
      else low=mid+1;
    }
  for(j=i-1;j>=high+1;--j) L.r[j+1]=L.r[j];
  l.r[high+1]=L.r[0];
  }
}
```

###### 性能分析

**查找：**

- 折半查找比顺序查找快，所以折半排序就平均性能来说比直接插入排序要快；
- 它所需要的关键码比较次数与待排序对象序列的初始排列无关，仅依赖于对象个数。在插入第i个对象时，需要经过⌊log2 i⌋ +1次关键码比较，才能确定它应插入的位置；
  - 当n较大时，总关键码比较次数比直接插入排序的最坏情况要好得多，但比其最好情况要差;
  - 在对象的初始排列已经按关键码排好序或接近有序时，直接插入排序比折半插入排序执行的关键码比较次数要少；

**移动：**

- 折半插入排序的对象移动次数与直接插入排序相同，依赖于对象的初始排列
  - 减少了比较次数，但没有减少移动次数
  - 平均性能优于直接插入排序

时间复杂度为O(n^2)

空间复杂度为O(1)

是一种**稳定**的排序方法

##### 希尔排序

Donald.L.Shell

###### 基本思想

先将整个待排记录序列分割成**若干子序列**，分别进行直接插入排序，待整个序列中的记录”基本有序“时，再对全体记录进行一次直接插入排序。

###### 算法特点

（1）缩小增量

（2）多遍插入排序

###### 举例

![image-20231220211747306](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20231220211747306.png)

###### 思路

![image-20231220212334618](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20231220212334618.png)

###### 特点

- 一次移动，移动位置较大，跳跃式地接近排序后的最终位置
- 最后一次只需要少量移动
- 增量序列必须是递减的，最后一个必须是1
- 增量序列应该是互质的

###### 算法实现

主程序

```
void ShellSort(Sqlist &L, int dlta[], int t){
//按增量序列dlta[0...t-1]对顺序表L作希尔排序
  for(k=0;k<t;++k)
    ShellInsert(L, dlta[k]);//一趟增量为dlta[k]的插入排序
}
```

其中某一趟的排序操作

```
void ShellInsert(SqList &L, int dk){
	//对顺序表L进行一趟增量为dk的Shell排序，dk为步长因子
  for(i=dk+1;i<=L.length;++i)
    if(r[i].key<r[i-dk].key){
      r[0]=r[i];
      for(j=i-dk;j>0&&(r[0].key<r[j].key);j=j-dk)
        r[j+dk]=r[j];
      r[j+dk]=r[0];
    }
}
```

###### 算法分析

希尔排序算法效率与**增量序列的取值**有关

**时间效率**

![image-20231220215240160](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20231220215240160.png)

**稳定性**

希尔排序是一种**不稳定**的排序算法。

**总结**

- 时间复杂度是n和d的函数公式（经验公式）：

![image-20231220215440796](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20231220215440796.png)

- 空间复杂度为O(1)
- 如何选择最佳d序列，目前**尚未解决**
- 最后一个增量值**必须为1**，无除了1之外的公因子
- 不适合在链式存储结构上实现

#### 交换排序

##### 冒泡排序

###### 基本思想

每趟不断将记录两两比较，并按”前小后大“规则交换。

```
void bubble_sort(SqList &L){//冒泡排序算法
  int m,i,j;  RedType x;	//交换时临时存储
  for(m=1;m<=n-1;m++){		//总共需m趟
    for(j=1;j<=n-m;j++)
    if(L.r[j].key>L.r[j+1].key){//发生逆序
      x=L.r[j];L.r[j]=L.r[j+1];L.r[j+1]=x;//交换
      }//endif
  }//for
}
```

**优点：**每趟结束时，不仅能挤出一个最大值到最后面的位置，还能同时部分理顺其他元素；

**如何提高效率？**

一旦某一趟比较时不出现记录交换，说明已经排好序了，就可以结束本算法。

###### 算法改进

```
void bubble_sort(SqList &L){   //改进的冒泡排序算法
  int m,i,j,flag=1; RedType x; //flag作为是否有交换的标记     for(m=1; m<=n-1&&flag==1; m++) {
    flag=0;
    for(j=1;j<=m;j++)
      if(L.r[j].key>L.r[j+1].key){ //发生逆序
        flag=1; //发生交换，flag置为1，若本趟没发生交换，flag保持为0
        x=L.r[j];L.r[j]=L.r[j+1];L.r[j+1]=x; //交换
	  } //endif
   }//for
}
```

###### 算法分析

- 最好情况（正序）

比较次数：n-1

移动次数：0

- 最坏情况（逆序）

比较次数：

![image-20231220230515286](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20231220230515286.png)

移动次数：

![image-20231220230553636](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20231220230553636.png)

**时间复杂度**

最好情况时间复杂度O(n)

最坏情况时间复杂度O(n^2)

平均情况时间复杂度O(n^2)

**空间复杂度**

需要添加一个辅助空间temp，辅助空间S(n)=O(1)

**稳定性**

冒泡排序是稳定的。

##### 快速排序

###### 基本思想

通过一趟排序，将待排序记录分割成独立的两部分，其中前部分记录的关键字均比另一部分记录的关键字小，则可分别对这两部分记录进行排序，以达到整个序列有序。

**实现过程：**选定一个中间数作为参考，所有元素与之比较，小的调到其左边，大的调到其右边。

**（枢轴）中间数：**可以是第一个数、最后一个数、最中间一个数、任选一个数。

即：

- 任取一个元素为中心(pivot)
- 所有比它小的元素一律前放，比它大的元素一律后放

形成**左右两个子表**：

- 对各子表重新选择中心元素并**依次规则调整**
- 直到每个子表的元素只剩一个

###### 实例

![image-20231220233531229](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20231220233531229.png)

###### 过程描述

①每一趟的子表的形成是采用从两头向中间交替式逼近法；

②由于每趟中对各子表的操作都相似，可采用**递归算法**。

###### 算法实现

```
void main(){
  QSort(L,1,L.length);
}
```

对顺序表L快速排序

```
void QSort (SqList &L, int low, int high){
  if(low<high){ // 长度大于1
    pivotloc = Partition(L, low, high);
  // 将L.r[low..high]一分为二，pivotloc为枢轴元素排好序的位置     QSort(L,low, pivotloc-1); // 对低子表递归排序
    QSort(L,pivotloc+1,high); // 对高子表递归排序
}//endif }//QSort
```

中间数选择函数

```
int Partition (SqList &L, int low, int high ) {
  L.r[O] = L.r[low]; pivotkey = L.r[low].key;
  while (low < high ) {
    while (low < high && L.r[high].key >= pivotkey ) --high;
    L.r[low] = L.r[high];
    while(low<high&&L.r[low].key<=pivotkey) ++low;
    L.r[high]=L.r[low];
  }
  L.r[low]=L.r[0]；
  return low;
}
```

###### 算法分析

**时间复杂度**

- 可证明，平均时间复杂度O(nlog2 n)
  - Qsort()：O(log2 n)
  - Partition()：O(n)
- 实验结果表明：就平均计算时间而言，快速排序是我们所讨论的所有内排序方法中最好的一个

**空间复杂度**

快速排序不是原地排序

由于程序中使用了递归，需要递归调用栈的支持，而栈的长度取决于递归调用的深度。(即使不用递归，也需要用用户栈)

- 平均情况下：需要O(log n)的栈空间
- 最坏情况下：栈空间可达O(n)

**稳定性**

快速排序是一种不稳定的排序方法。

快速排序不适于对原本有序或基本有序的记录序列进行排序。（会退化成没有改进措施的冒泡排序。）

**划分元素的选取**是影响时间性能的关键。

输入数据次序越乱，所选划分元素值的随机性越好，排序速度越快，快速排序**不是自然排序**方法。

改变划分元素的选取方法，至多只能改变算法平均情况的下的时间性能，无法改变最坏情况下的时间性能。即最坏情况下，快速排序的时间复杂性总是O(n^2)。

#### 选择排序

##### 简单选择排序

###### 基本思想

在待排序的数据中选出最大 (小)的元素放在其最终的位置。

###### 基本操作

1. 首先通过n-1次关键字比较，从n个记录中找出关键字最小的记录，将它与第一个记录交换。
2. 再通过n-2次比较，从剩余的n-1个记录中找出关键字次小的记录，将它与第二个记录交换。
3. 重复上述操作，共进行n-1趟排序后，排序结束。

###### 算法实现

```
void SelectSort(SqList &k) {
  for (i=1;i<L.length; ++i) {
    k=i；
    for(j=i+1;j<=L.length;j++)
      if(L.r[j].key<L.r[k].key) k=j;  //记录最小值位置     
    if(k!=i) L.r[i]<-->L.r[k];        //交换
 }
}
```

###### 算法分析

**时间复杂度O(n^2)**

- 记录移动次数
  - 最好情况:0
  - 最坏情况：3(n-1)

- 比较次数：无论待排序列处于什么状态，选择排序所需进行的”比较”次数都相同。

**空间复杂度**

需要一个额外的存储空间O(1)。

**算法稳定性**

简单选择排序是**不稳定**排序。

##### 堆排序

###### **堆的定义**

若n个元素的序列{a1  a2 ... an} 满足

![image-20231221104524222](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20231221104524222.png)

则分别称该序列{a1 a2 ... an}为**小根堆**和**大根堆**。

堆实质是满足如下性质的**完全二叉树**：二叉树中任一非叶子结点均小于(大于)它的孩子结点。

###### 堆排序

若在输出**堆顶**的最小值(最大值)后，使得剩余n-1个元素的序列重又建成一个堆，则得到n个元素的次小值 (次大值) ......如此反复，便能得到一个有序序列，这个过程称之为**堆排序**。

###### 堆的调整

**小根堆**

- 输出堆顶元素之后，以堆中**最后一个元素替代之**；
- 然后将根结点值与左、右子树的根结点值进行比较，并与其中**小者**进行**交换**;
- 重复上述操作，直至叶子结点，将得到新的堆，称这个从堆顶至叶子的调整过程为**“筛选“**。

![image-20231221110443129](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20231221110443129.png)

###### 算法描述

```
void HeapAdjust(elem R[], int s, int m){
//已知R[s..m]中记录的关键字除R[s]之外均满足堆的定义，本函数调整R[s]的关键字，使R[s..m]成为一个大根堆
  rc = R[s];
  for(j=2*s;j<=m;j*= 2) {// 沿key较大的孩子结点向下筛选
    if(j<m&&R[j]<R[j+1]) ++j; //j为key较大的记录的下标
    if(rc>=R[j]) break;
    R[s]=R[j]; s=j;  //rc应插入在位置s上
  }//for
  R[s] = rc; // 插入
}//HeapAdjust
```

###### 堆的建立

单节点的二叉树是堆；

在完全二又树中所有以叶子结点 (序号i > n/2) 为根的子树是堆。

**例如：**

![image-20231221125524468](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20231221125524468.png)

**建立小根堆实现语句：**

```
for(i=n/2; i>=1; i--)
  HeapAdjust(R,i,n);
```

###### 堆排序实现原理

对一个无序序列建堆，然后输出根；重复该过程就可以由一个无序序列输出有序序列。

实质上，堆排序就是利用完全二叉树中父结点与孩子结点之间的内在关系来排序的。

###### 算法实现

```
void HeadSort(elem R[]){	//堆R[1]到R[n]进行堆排序
  int i;
  for(i=n/2;i>=1;i--)
    HeapAdjust(R,i,n);		//建初始堆
  for(i=n;i>1;i--){			//进行n-1趟排序
    Swap(R[1],R[i]);		//根与最后一个元素交换
    HeapAdjust(R,1,i-1);	//对R[1]到R[i-1]重新建堆
  }
}//HeapSort
```

###### 性能分析

- 初始堆化所需时间不超过O(n)

- 排序阶段（不含初始堆化）

  - 一次重新堆化所需时间不超过O(log2 n)

  - n-1次循环所需时间不超过O(nlog2 n)

Tw(n)=O(n)+O(nlog2 n)=O(nlog2 n)

堆排序的**时间主要耗费**在建初始堆和调整建新堆时进行的反复“筛选”上。

在最坏情况下，**时间复杂度**依然是O(nlog2 n)，这也是堆的最大优点。

无论待排序列中的记录是正序还是逆序，都不会使堆排序处于“最好”或“最坏”的状态。

堆排序仅需一个记录大小供交换用的**辅助存储空间**。

堆排序是一种**不稳定**的排序方法，不适用于待排序记录个数较少的情况，对于n较大的文件很有效。

#### 归并排序

##### 基本思想

将两个或两个以上的有序子序列**“归并”**为一个有序序列。

在内部排序中，通常采用**2-路归并排序**。

  即：将两个位置相邻的有序子序列R[l..m]和R[m+1..n]归并为一个有序序列R[l..n]

##### 举例

![](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20231221132313793.png)

奇数情况

![image-20231222090834854](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20231222090834854.png)

##### 关键问题

如何将两个有序序列合成一个有序序列？

![image-20231221132446435](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20231221132446435.png)

（第二章知识）

##### 算法标识

![image-20231221132816140](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20231221132816140.png)

##### 算法分析

- 时间效率：O(nlog2 n)

- 空间效率：O(n)

​	因为需要一个与原始序列同样大小的辅助序列（R1）。这正是此算法的缺点。

- 稳定性：	稳定

#### 基数排序

##### 基本思想

分配+收集

**基数排序**是一种非比较型地整数排序算法，它将整数按照个位数逐个进行比较和排序。这种排序算法地特殊之处在于它针对整数地每一位进行排序，从最低位到最高位，最终得到有序的结果。

##### 举例

![image-20231221161620881](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20231221161620881.png)
![](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20231221161739746.png)
![image-20231221161920224](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20231221161920224.png)

第三趟收集得到最终的排序结果

##### 算法分析

```
n个记录
每个记录有d位关键字
关键字取值范围r（如十进制位10）
```

- 重复执行d趟“分配”与“收集”
- 每趟对n个记录进行“分配”，对rd个队列进行“收集”
- 需要增加n+2rd个附加链接指针

时间效率：O(d*(n+r))
空间效率：O(r)
稳定性：	稳定

### 各种排序方法的综合比较

![image-20231221213116586](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20231221213116586.png)

#### 时间性能

1.按平均的时间性能来分，有三类排序方法

- 时间复杂度为O(nlog2 n)的方法有：
  - 快速排序、堆排序和归并排序，其中以快速排序为最好;

- 时间复杂度为O(n^2)的有：
  - 直接插入排序、冒泡排序和简单选择排序，其中以直接插入为最好，特别是对那些对关键字近似有序的记录序列尤为如此；

- 时间复杂度为O(n)的排序方法只有: 基数排序

2.当待排记录序列按关键字顺序有序时，直接插入排序和冒泡排序能达到O(n)的时间复杂度;而对于快速排序而言，这是最不好的情况，此时的时间性能退化为O(n^2)，因此是应该尽量避免的情况。

3.简单选择排序、堆排序和归并排序的时间性能不随记录序列中关键字的分布而改变。

#### 空间性能

指的是排序过程中所需的辅助空间大小

1.所有的简单排序方法(包括：直接插入、冒泡和简单选择)和堆排序的空间复杂度为O(1)

2.快速排序为O(logn)，为栈所需的辅助空间

3.归并排序所需辅助空间最多，其空间复杂度为O(n)

4.链式基数排序需附设队列首尾指针，则空间复杂度为O(rd)

#### 稳定性能

稳定的排序方法指的是，对于两个关键字相等的记录，它们在序列中的相对位置，在排序之前和经过排序之后，没有改变。

当对多关键字的记录序列进行LSD方法排序时，必须采用稳定的排序方法。

对于不稳定的排序方法，只要能举出一个实例说明即可。

快速排序和堆排序是不稳定的排序方法。







<--2023年12月5日-->

①快速排序

②复杂度

③堆排序
	希尔排序
	归并排序

<--2023年12月5日-->总结

①线性结构

②树形结构（树，二叉树）

③图型结构（存储，算法）

④查找和排序






