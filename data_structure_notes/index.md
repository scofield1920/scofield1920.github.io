# 数据结构笔记


没写完，还在写.......

<!--more-->

### 课程内容

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

运算是受限的单链表，只能在链表头部进行操作，故没有必要附加头结点







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

分治法：对于一个较为复杂的问题，能够分解成几个相对简单的且解法相同或类似的子问题来求解



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

缺点：

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

## 补充：C语言中常用的串运算

调用标准库函数：`#include<string.h>`

```
串比较，strcmp(char s1,char s2)
串复制，strcpy(char to,char from)
串连接，strcat(chat to,char from)
求串长，strlen(char s)
```

## 0x4串、数组和广义表

定义：串(string)——零个或多个字符组成的有限序列

```
S='a1a2...an'
```

结构：

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
	while(i<=S[0]&&j<=T[0]){				//S[0]存储串S的长度
		if(S[i]==T[i])	++i;+++j;
		else  i=i-j+2; j=1;
	}
	if(i>S[0])	POS=0;
	else POS=i-T[0];
}
```

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

定义next[j]函数，表明当模式中第j个字符与主串相应字符匹配“失败”时，执行此函数

next[j]=

```
max{k|1<k<j,且"p1...pk-1"="Pj-k+1...pj-1"}	//此集合非空时
0											//当j=1时
1											//其他情况
```

##### 如何求next函数的值：

1.next[1]=0;表明主串从下一字符si+1起和模式串重新开始匹配。i=i+1;j=1;

2.设next[j]=k，则next[j+1]=?

​	若pk=pj，则有"p1...pk-1pk”="pj-k+1...pj-1pj"，如果在j+1发生不匹配，说明next[j+1]=k+1=next[j]+1。

​	若pk!=pj，可把求next值问题看成是一个模式匹配问题，整个模式串既是主串又是子串。











### 特殊矩阵的压缩存储

#### 压缩存储

若多个数据元素的值都相同，则只分配一个元素值的储存空间，且零元素不占储存空间。

#### 什么样的矩阵能压缩存储

一些特殊矩阵：对称矩阵，对角矩阵，三角矩阵，稀疏矩阵

#### 对称矩阵

特点：在nxn的矩阵a中，满足性质aij=aji（1<=i,j<=n）

存储方法：只能存储上（或者下）三角（包括主对角线）的数据元素。共占`n(n+1)/2`个元素空间。

#### 三角矩阵

特点：对角线以下（或者以上）的数据元素（不包括对角线）全部为常数c。

储存方法：重复元素c共享一个元素存储空间，共占用`n(n+1)/2+1`个元素空间：`sa[1...n(n+1)/2+1]`



#### 对角矩阵(带状矩阵)

特点：在nxn的方阵中，非零元素集中在主对角线及其两侧共L(奇数)条对角线的带状区域内——L对角矩阵。

储存方法：



#### 稀疏矩阵

矩阵中非零元素的个数较少（一般小于5%）

特点：大多数元素为0。

常用存储方法：只记录每一非零元素（i，j，aij），节省空间但丧失随机存取功能。

​	顺序存储：三元组表

​	

### 广义表

n个表元素组成的有限序列，记作`LS=(a0,a1.a2......,an-1)`

LS是表名，ai是表元素，它可以是表（称为子表），可以是数据元素（称为原子）。

n为表的长度，n=0的广义表为空表

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

路径：由一结点到另一结点间的分支所构造

路径长度：两结点间路径上的分支数目

带权路径长度：结点到根的路径长度与结点上权的乘积

树的带权路径长度：树中所有叶子结点的带权路径长度之和

<img src="https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20231209112327670.png" alt="image-20231209112327670" style="zoom:67%;" />

哈夫曼树：带权路径长度最小的树

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

### 哈希函数的构造方法



#### 1.开放地址法（开地址法）

基本思想：有冲突时就去寻找下一个空的哈希地址，只要哈希表足够大，空的哈希地址总能找到，并将数据元素存入。

- 线性探测法
- 二次探测法
- 伪随机探测法



##### 线性探测法的特点

优点：只要哈希表未被填满，保证能找到

缺点：



##### 二次探测法

关键码集`{47,7,29,11,16,92,22,8,3},`

设： 哈希函数为`Hash(key)=key mod 11`

`H1=(Hash(key)+_d1)mod m`

其中:m为哈希表长度，m要求是某个4k+3的质数

di为增量序列 `1^2,-1^2,2^2,-2^2,...,q^2`

2.链地址法(拉链法)

链地址法的优点：

非同义词不会冲突

#### 哈希表的查找



## 0x8排序

什么是排序：排序是将一组杂乱无章的数据按一定规律顺次排列起来

排序的目的：便于查找

内部排序：待排序记录都在内存中

外部排序：待排序记录一部分在内存，一部分在外存

> 外部排序时，要将



记录序列以顺序表存储

```
#define MAXSIZE 20
typedef int KeyType;
Typedef struct{
	KeyType key;
	InfoType otherinfo;
}RedType;

typedef struct{ds
	RedType r[MAXISIZE+1];
	
	int length;
	
	...
	
}
```



#### 排序算法分类

规则不同：

- 插入排序
- 交换排序
- 选择排序
- 归并排序

时间复杂度不同：

- 简单排序
- 先进排序







#### 如果数据量很大怎么办?(归并排序)

**归并排序**是一种分治的排序算法，它的基本思想是将待排序序列递归地拆分成多个



##### 算法分析

时间效率：O(nlog2n)
空间效率：O(n)
稳定性：	稳定



#### 有额外储存空间如何利用?(基数排序)

**基数排序**是一种非比较型地整数排序算法，它将整数按照个位数逐个进行比较和排序。这种排序算法地特殊之处在于它针对整数地每一位进行排序，从最低位到最高位，最终得到有序的结果。

##### 按位排序

基数排序从最低有效位（最右边）开始，按照每个位上的数值及逆行排序



##### 最高位优先法

- 先对最高位关键字k1排序，将序列分成若干子序列，每个子序列有相同的k1值
- 然后让每个子序列对次关键字k2进行排序、



##### 最低位优先法

- 首先依据最低位排序码kd对所有对象进行一趟排序
- 再一句次低位排序码kd-1对上一趟排序结果排序
- 依次重复，直到依据排序码k1最后一趟排序完成，就可以得到一个有序的序列

这种方法不需要再分组，而是整个对象组都参加排序



##### 链式基数排序

先决条件：

- 知道各级关键字的主次关系
- 知道各级关键字的取值范围

利用“分配”和“收集”对关键字进行排序

- 首先对低位关键字排序，各个记录按照此关键字的值“分配”到相应的序列里
- 按照序列对应的值的大小，从各个序列中将记录“收集“，收集后的序列按照此关键字有序
- 在此基础上，对前一位关键字进行排序

步骤：

设置10个队列，f[i]和e[i]分别头指针和尾指针

第一趟分配对



##### 算法分析

```
n个记录
每个记录有d位关键字
关键字取值范围r（如十进制位10）
```

- 重复执行d趟“分配”与“收集”
- 每趟对n个记录进行“分配”，对rd个队列进行“收集”
- 需要增加n+2rd个附加链接指针

时间效率：O(d(n+r))
空间效率：O(r)
稳定性：	稳定

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





## 数据结构期末考试

名词解释5道

计算题5道

应用题6道（共五十分，其余共五十分）

算法设计题2道

## 重点

### 第一章绪论

重点考

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

关联路径，关联活动、强连通图、强连通分量

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
