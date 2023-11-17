# C语言笔记


C语言学习笔记以及希冀平台样题

<!--more-->

### C语言一刷的时候是没有笔记的，开刷Python之后才开始整理笔记，今天开始C语言二刷，顺便做做题，笔记的框架是根据浙大翁凯教授的慕课构建的，随后又根据学校的考试内容进行了整体补充插入，可能会出现小部分内容重复，也可能会存在插入知识点跟前后关联性较小等问题，同时也插入了学校教材中的习题

---

## 1.1解释型语言&编译型语言

- 有的编程语言要求必须提前将所有源代码一次性转换成二进制指令，也就是生成一个可执行程序（Windows 下的 .exe），比如C语言、C++、Golang、Pascal（Delphi）、汇编等，这种编程语言称为编译型语言，使用的转换工具称为编译器。**(编译型)**
- 有的编程语言可以一边执行一边转换，需要哪些源代码就转换哪些源代码，不会生成可执行程序，比如 Python、JavaScript、PHP、Shell、MATLAB 等，这种编程语言称为解释型语言，使用的转换工具称为解释器。**(解释型)**

![image-20230221105532331](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20230221105532331.png)

## 2.1计算

printf("xx");  打印xx

scanf("%d",&price);  将读取到的整数赋值给price

#### const

是一个修饰符，加载变量类型前面，表示“ 不变的”这一属性，即常量

```
const int AMOUNT = 100
```

常量变量名常用全大写

#### 浮点数

带小数点的数值，浮点数这个词的本意就是指小数点是浮动的，是计算机内部表达非整数(包含分数和无理数)的一种方式，另一种方式叫做定点数(在c语言中不会遇到定点数)

当浮点数和证书放到一起运算时，C会将整数转换成浮点数，然后进行浮点数的运算

#### double

双精度浮点数，还有float表示单精度浮点数

改进后的例子：

#### 身高单位换算

```c
#include<stdio.h>
int main()
{
	printf("请分别输入身高的英尺和英寸，"
			如输入\"5 7\"表示5英尺7英寸：”)；
	double foot;
	double inch;
	
	scanf("%lf %lf",&foot,&inch);
	
	print("身高是%f米。\n",((foot + inch /12)* 0.3048));
	
	return 0;
}
```

### 2.2表达式

一个表达式是一系列运算符和算子的组合，用来计算一个值

#### 运算符

operator，是指进行运算的动作，比如加法运算符“+”。

#### 算子

operand，是指参与运算的值，这个值可能是常数，也可能是变量，还可能是一个方法的返回值

#### 计算时间差

```c
#include <stdio.h>
int main() {
	int hour1, minute1;
	int hour2, minute2;
	scanf_s("%d %d", &hour1, &minute1);
	scanf_s("%d %d", &hour2, &minute2);
	int t1 = hour1 * 60 + minute1;
	int t2 = hour2 * 60 + minute2;
	int t = t1 - t2;
	printf("时间差是%d小时，%d分钟。", t / 60, t % 60);
	return(0);

```

#### 求平均值

```c
#include<stdio.h>
int main() {
	int a, b;
	scanf_s("%d %d", &a, &b);
	double c = (a + b) / 2.0;
	printf("%d和%d的平均值=%f\n", a, b, c);
	return(0);
}
```

#### 运算符优先级

![image-20230225165924207](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20230225165924207.png)

单目运算符只有一个算子，如：+a，-b（正a，负b）

#### 嵌入式赋值

(不利于阅读，容易产生错误，不建议使用)

```c
int a = 6;
int b;
int c = 1 + (b = a);
```

#### 结合关系

一般是自左向右
而单目运算(+-)和赋值(=)是自右向左

#### 递增递减运算符

“++”和“--”是两个很特殊的运算符，它们是单目运算符，这个算子还必须是变量

#### 前缀和后缀

++和--可以放在变量的前面，叫做前缀形式，也可以放在变量的后面，叫做后缀形

在同一行代码中，++在前，则表达式中为++以后的值，若++在后，表达式中为++以前的值

## 3.1判断

#### 时间差计算(通过if语句改进)

```c
#include<stdio.h>
int main() {
	int hour1, minute1;
	int hour2, minute2;
	scanf_s("%d %d", &hour1, &minute1);
	scanf_s("%d %d", &hour2, &minute2);
	int ih = hour2 - hour1;
	int im = minute2 - minute1;
	if (im < 0) {
		im = im + 60;
		ih--;
	}
	printf("时间差是%d小时%d分钟", ih, im);
}
```

#### if语句

```c
if(条件成立){
   ...
}
```

#### 关系运算符

![image-20230225205201696](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20230225205201696.png)

#### 关系运算的结果

![image-20230225205432179](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20230225205432179.png)

#### 找零计算器

```c
#include<stdio.h>
int main() {
int bill = 0;
int price = 0;

printf("请输入金额：");
scanf_s("%d", &price);
printf("请输入票面：");
scanf_s("%d", &bill);
if (bill >= price) {
	printf("应该找您%d元\n", bill - price);
}
else {
	printf("你的钱不够\n");
}

}
```

#### 判断闰年

```c
#include<stdio.h>
int main(){
	int n=0;
	printf("请输入年份：");
	scanf("%d",&n);
	if(n%100==0){
		if(n%400==0){
			printf("是闰年");
		}else{
			printf("不是闰年");
		}
	}else{
		if(n%4==0){
			printf("是闰年");
		}else{
		printf("不是闰年");
		}
		} 
		return 0;
	}
```



#### 常用的数学函数：

调用数学函数，需要加入`#include<math.h>`

```
平方根函数：sqrt(x)
绝对值函数：fabs(x)
幂函数：pow(x,n)，x的n次方
指数函数：exp(x)，e^x
ln函数：log(x)，计算lnx
```

### 3.2分支

#### 嵌套的判断

当if的条件满足或者不满足的时候要执行的语句也可以是一条if或if-else语句

```c
if( code == ready )
	if ( count <20 )
		printf("一切正常\n");
	else
		printf("继续等待\n")
```

#### else的匹配

如果不加大括号，else总是和最近的那个if匹配，如果加了大括号，else和内含有if语句的第1个if语句匹配，当然我们也可以通过添加空else语句来闭合if

```c
if( code == ready ){
	if ( count <20 )
		printf("一切正常\n");
	} else
		printf("继续等待\n")
```

#### 级联的if-else if

```c
if ( exp1 )
	st1;
else if ( exp2 )
	st2;
else
	st3;
```

#### if语句常见错误

- 忘记打括号(大于一条语句)
- if后面忘记分号(if后面无分号，如果有分号，则相当于已有一条“；”语句)
- 错误使用==和=(若一个等号，则为赋值)
- 使人困惑的else

#### switch-case

```c
switch (控制表达式){
case 常量:
	...
	break;
case 常量:
	...
	break;
default:
	...
	break;
}
```

控制表达式只能是整数型结果
常量，可以是常数，也可以是表达式
break用来分割case与case，否则之后会进入下一个case

- switch在每个语句中都是用switch
- switch语句中如果省略了default，当表达式的值与任何一个常量表达式的值都不相等，则什么都不执行

#### 简单的计算器程序

```c
#include<stdio.h>
int main(){
	int v1,v2;
	char op;
	
	printf("Type in an expresseion:");
	scanf("%d%c%d",&v1,&op,&v2);
	switch(op){
		
		case '+':
			printf("=%d",v1+v2);
			break;
		case '-':
			printf("=%d",v1-v2);
			break;
		case '*':
			printf("=%d",v1*v2);
			break;
		case '/':
			if(v2==0){
				printf("Discover can not be 0!\n");
				break;
			}else{
				printf("=%d",v1/v2);
				break;
			}
		case '%':
			if(v2==0){
				printf("Discover can not be 0!\n");
				break;
			}else{
				printf("=%d",v1%v2);
				break;
			}
		default:
			printf("Unknow operator\n");
			break;
	} 
		return 0;
	}
```

#### 字符统计

输入一个正整数n，再输入n个字符，分别统计出其中空格和回车、数字字符和其他字符的个数，要求使用switch语句编写：

```c
#include<stdio.h>
int main(){
	int n;
	int blank=0;
	int digit=0;
	int other=0;
	char ch;
	printf("Enter n:");
	scanf("%d",&n);
	getchar();		   //读入并舍弃换行符
	printf("Enter %d Characters:",n);
	for(int i=1;i<=n;i++){
		ch=getchar();
		switch(ch){
			case ' ':
			case '\n':
				blank++;
				break;
			case '0':case '1':case '2':case '3':case '4':
			case '5':case '6':case '7':case '8':case '9':	
				digit++;
				break;
			default:
				other++;
				break;
		}	
	} 
	printf("blank:%d,digit:%d,other=%d\n",blank,digit,other);
	return 0;
} 
```



#### 逻辑运算符

##### 单目：

逻辑非：`!`

##### 双目：

逻辑与：`&&`
逻辑或：`||`

逻辑运算符&&和||的优先级低于关系运算符，故：

```c
(ch>='a')&&(ch<='z')
等价于
ch>='a'&&ch<='z'
```



## 4.1循环

#### 数位数算法

```c
int x ;
int n=0 ;
scanf_s("%d",&x);
n++;
x=x/10;
while(x>0){
	n++;
	x=x/10;
}
printf("该数字是%d位数",n);
```

一个int是4个字节，一个字节是8位，int可表示最大数范围：2^(4*8)=2147483648

#### while语句

```c
while ( x > 0 ) {
	...
	...
}
```

#### do-while语句

```c
do
{
	<循环体语句>
}while(<循环体语句>);
```

#### 统计数字位数

```c
#include<stdio.h>
int main(){
	int num=0;
	int count=0;
	printf("Enter a number:");
	scanf("%d",&num);
	do{
		num=num/10;
		count++;
	}while(num!=0);
	printf("total:%d",count);
	return 0;
} 
```

#### 逆向输出数字串

```c
#include<stdio.h>
int main(){
	int num=0;
	printf("Enter a number:");
	scanf("%d",&num);
	do{
		printf("%d",num%10);
		num=num/10;
	}while(num!=0);
	return 0;
} 
```

#### 求1!+2!+3!+........n!

```c
#include<stdio.h>
double fact(int n);
int main(){
	int a=0;
	double sum=0;
	printf("Enter a number:");
	scanf("%d",&a);
	for(int i=1;i<=a;i++){
		sum=sum+fact(i);
	}
	printf("1!+2!+3!+....+%d!=%.0lf\n",a,sum);
	return 0;
}
	double fact(int n){
		double result=0;
		if(n<0){
			return 0;
		}
			result=1;
			for(int i=1;i<=n;i++){
				result=result*i;
			}
		return result;
	}
```

#### while 和 do-while的区别：

while先判断，do-while先执行一次

### 4.2循环应用

#### 计数循环

```c
int count = 100;
while(count >=0){
	cout --;
	printf("%d\n",count);
}
printf("发射\n");
```

#### 格雷公式求π近似值

```c
#include<stdio.h>
#include<math.h>
int main(){
	int demo=1;
	int flag=1;
	double eps,pi=0;
	double item=1.0;
	printf("Enter eps:");
	scanf("%lf",&eps);
	while(fabs(item)>=eps){
		pi=pi+item;
		flag=-flag;
		demo=demo+2;
		item=flag*(1.0/demo);
	}
	pi=pi+item;
	pi=pi*4;
	printf("pi=%.4f\n",pi);
	return 0;
}
```



#### 随机数

每次召唤rand()就得到一个随机数

## 5.1循环控制

#### 阶乘算法

```c
int n;
scanf_s("%d",&n);
int fact = 1;
int i =1;
for(i=1;i<=n;i++){
	fact*=i;
}
printf("%d!=%d\n",n,fact);
```

#### for循环语句

```c
for (初始条件;循环继续的条件;循环结束后执行的语句)
{

}
```

for像一个计数循环

<img src="https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20230226105343746.png" alt="image-20230226105343746" style="zoom:67%;" />

#### Tips

- 如果有固定次数，用for语句更合适
- 如果必须执行一次，用do_while
- 其他情况用while

![image-20230226110957209](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20230226110957209.png)

```
10 5 3 2
```

### 5.2循环控制

#### break和continue

break：当 break 关键字用于 while、[for 循环](http://c.biancheng.net/view/172.html)时，会终止循环而执行整个循环语句后面的代码。break 关键字通常和 if 语句一起使用，即满足条件时便跳出循环。
continue：跳过循环这一轮剩下的语句，进入下一轮

#### 接力break

#### goto语句

（在多重嵌套的循环中，要从内层跳出，用goto语句

直接跳到标志位置

### 5.3循环应用

#### 求最大公约数

##### 1.枚举算法

```c
#include <stdio.h>
    int main()
    {
        int a, b;
        int min;
        scanf("%d %d", &a, &b);
            if (a > b) {
                min = b;
            }
            else {
                min = a;
            }
        int ret = 0;
        int i;
        for (i = 1; i < min; i++) {
            if (a % i == 0) {
                if (b % i == 0) {
                    ret = i;
                }
            }

    }
    printf("%d和%d的最大公约数为%d.\n", a, b, ret);
} 
```

##### 2.辗转相除法

![image-20230226165831590](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20230226165831590.png)

```c
#include <stdio.h>
int main()
{
	int a, b;
	int t;
	scanf_s("%d %d", &a, &b);
	while (b != 0) {
		t = a % b;
		a = b;
		b = t;
		printf("a=%d,b=%d,t=%d\n",a,b,t);
	}
	printf("gcd=%d\n", a);
	return 0;
} 	
```

#### 求最小公倍数

```c
int main()
{
	int a = 0, b = 0;
	scanf("%d %d", &a, &b);
	int i = 1;
	while ((a * i) % b != 0)
	{
			i++;
	}
	printf("%d\n", i * a);
	return 0;
}
```

## 6.1数据类型

#### 数据的储存

正数的原码、反码、补码相同，符号位是0

负数的原码、反码、补码不同：

- 原码：符号位是1，其余各位表示数值的绝对值
- 反码：符号位是1，其余各位对原码取反
- 补码：反码+1

c语言数据类型：整型、字符型、实型

早期语言强调类型（面向底层）

- 整数
  char、short、int、long、longlong
- 浮点数
  float、double、longdouble
- 逻辑
  bool
- 指针
- 自定义类型

所表达的数的范围：char<short<int<float<double

#### sizeof

给出某个类型或变量在内存中所占据的字节数
sizeof()是一个静态运算符，不能在括号内进行运算

```c
#include <stdio.h>
int main()
{
	int a;
	a = 6;
	printf("sizeof(double)=%ld\n", sizeof(long double));
	printf("sizeof(a)=%ld\n", sizeof(a));
	return 0;
} 	
```

![11](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20230228132318636.png)

#### 补码

![image-20230228134741719](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20230228134741719.png)

#### unsigned

![image-20230228135954322](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20230228135954322.png)

#### 整数越界

![image-20230228140123841](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20230228140123841.png)

![image-20230228140232157](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20230228140232157.png)

#### 整数的输入输出

![image-20230228140526928](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20230228140526928.png)

int类型输入输出形式：
	十进制：%d
	八进制：%o
	十六进制：%x

#### 八进制和十六进制

![image-20230228215931085](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20230228215931085.png)

十六进制很适合表达二进制数据，因为四位二进制正好是一个十六进制位

#### 整数类型的选择

![image-20230228221113830](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20230228221113830.png)

所以说，没有特殊需要，就选择int

#### 浮点类型

![image-20230228224531711](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20230228224531711.png)

---

![image-20230228224556065](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20230228224556065.png)

实数类型，即实型，又称为浮点型，指存在小数部分的数。浮点型数据有单精度浮点型和双精度浮点型两种。

实型常量即实数，又称为浮点数，都是双精度浮点型，%e可输出科学计数法。

#### 科学计数法

![image-20230228224758320](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20230228224758320.png)

#### 输出小数

```c
#include <stdio.h>
int main()
{
	double ff = 1e-10;
	printf("%e,%f\n", ff, ff);
	return 0;
} 	
```

![image-20230228225254927](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20230228225254927.png)

这样的话，%e显示的科学计数法可以表示，但用%f输出的单精小数无法显示具体数值，

```c
printf("%e,%.16f\n", ff, ff);
```

添加.16来修改输出的小数点后面的位数

#### 宽度限定词

指定数据的输出宽度，
整型数据的输出格式控制说明%md，制定了数据的输出宽度为m(包含符号位)
若数据的实际位数小于m，则左侧补空格，若大于m，则按实际位数输出
实型数据的输出格式控制说明%m.nf，指定了输出浮点型数据时保留n位小数，且输出宽度是m(包括符号位和小数点)(同时实际位数小于m左端补空格，大于m按实际输出)

#### 超过范围的浮点数

printf输出inf表示超过范围的浮点数
printf输出nan表示不存在的浮点数

#### 浮点运算的精度

![image-20230228230904378](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20230228230904378.png)

- 带小数点的字面量是double而非float
- float需要用f或F后缀来表明身份

#### 选择浮点类型

​	没有特殊需要就选double
​	现代CPU能直接对double做硬件运算，性能不会比float差，在64位的机器上，数据存储的速度也不比float慢

#### 字符类型

char是一种整数，也是一种字符类型
printf和scanf里用%c来输入输出字符

 ![image-20230228231706198](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20230228231706198.png)

以上这段代码中，c是整数1，d是字符'1'，故输出的结果为不相等

#### 字符的输入输出

![image-20230301222020191](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20230301222020191.png)

字符数据的输入输出可以调用函数scanf()、printf()、getchar()、putchar()

##### getchar()

从键盘输入一个字符，并赋值给变量

##### putchar()

输出一个字符，调用格式为：putchar(输出参数);

若要实现多字符的输入和输出，就要循环调用putchar和getchar,下面给出一个栗子：

```c
#include<stdio.h>
int main(){
	char ch;
	int first=1,k;
	printf("Enter 8 characters:");
	for(k=1;k<=8;k++){
		ch = getchar();
		if(first==1){
			putchar(ch);
			first=0;
		}else{
			putchar('-');
			putchar(ch);
		}
	}
	return 0;
} 
```



#### 字符计算

![image-20230301225305811](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20230301225305811.png)

#### 大小写转换

- 字母在ASCII表中是顺序排列的
- 大写字母和小写字母是分开排列的，并不在一起
- 'a'-'A'可以得到两段之间的距离，于是

​		a+'a'-'A'可以把一个大写字母变成小写字母
​		a+'A'-'a'可以把一个小写字母变成大写字母

eg.输入一行字符，以回车符'\n'结束输入，将其中的大写字母转换为相应的小写字母，小写字母转换为相应的大写字母，其他字符原样输出

```c
#include<stdio.h>
int main(){
	printf("Input characters:");
	char ch;
	ch=getchar();
	while(ch!='\n'){
		if(ch>='A'&&ch<='Z'){
			ch=ch-'A'+'a';
		}
		else if(ch>='a'&&ch<='z'){
			ch=ch-'a'+'A';
		}
		putchar(ch);	//输出转换后的字符 
		ch=getchar();
	}
	return 0;
} 
```

#### 逃逸字符

​	用来表达无法印出来的控制字符或特殊字符，它由一个反斜杠`"\"`开头，后面跟上另一个字符，这两个字符合起来，组成了一个字符

​	举个栗子：

```c
	printf("请分别输入身高的英尺和英寸。"“如输入\"5 7 \"表示5英尺7英寸:");
```

![image-20230301231239357](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20230301231239357.png)

不同的shell会对特殊字符有不同的处理方式

比如\b有些shell会解释为退一个(但不是删除，如果有新字符录入，则会覆盖)

转义字符由反斜杠加一个字符或数字组成，它把反斜杠后的字符或数字转换成别的意义，虽然转义字符形式上由多个字符组成，但它是字符常量，只代表一个字符。

#### 自动类型转换

当运算符的两边出现不一致的类型时，会自动转换成较大的类型
大的意思是能表达的数的范围更大
![image-20230301232845793](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20230301232845793.png)

对于printf，任何小于int的类型会被转换成int，float会被转换成double
但是scanf不会，要输入short，需要%hd

#### 强制类型转换

要把一个量强制转换成另一个类型(通常是一个较小的类型)
格式：(类型)值
例如：(int)10.2

注意这时候的安全性，小的变量不总能表达大的变量

强制类型转换的优先级高于四则运算

#### 整数的类型转换

强制类型转换(大转小)或遇高级时自动转换(小转大)

#### bool

```c
#include<stdbool.h>
```

之后就可以使用bool和true、false

当然，用printf输出的时候只能输出1或者0，无法输出true或者false

### 6.2逻辑运算

是对逻辑量进行的运算，结果只有1或者0
逻辑量是关系运算或者逻辑运算的结果

![image-20230301234332057](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20230301234332057.png)

例如要表示<img src="https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20230301234514829.png" alt="image-20230301234514829" style="zoom:67%;" />可以<img src="https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20230301234547670.png" alt="image-20230301234547670" style="zoom:67%;" />

#### 如何判断一个字符c是否是大写字母？

![image-20230301234652993](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20230301234652993.png)

#### 优先级

![image-20230301235032854](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20230301235032854.png)

#### 短路

![image-20230301235231542](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20230301235231542.png)

#### 条件运算符

是一个三目运算符，一般形式：

表达式1 ？ 表达式二2：表达式3

![image-20230301235459243](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20230301235459243.png)

优先级高于赋值运算符，但比其他运算符低

#### 嵌套条件表达式

![image-20230301235723123](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20230301235723123.png)

(不希望使用嵌套条件表达式)

#### 逗号运算符

连接两个表达式，以右边的表达式的值作为它的结果。
优先级最低
组合关系为自左向右

用处：主要是在for语句中使用

![image-20230302000041171](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20230302000041171.png)

e.g.

```c
a=3*5,a*4         //a=15,表达式值60

a=3*5,a*4,a+5    //a=15,表达式值20
```

#### 位运算

进行二进制位的运算

| 运算符 | 名称       |
| ------ | ---------- |
| &      | 按位“与”   |
| \|     | 按位“或”   |
| ^      | 按位“异或” |
| ~      | 取反       |
| <<     | 左移       |
| >>     | 右移       |

除了~是单目运算之外，其余均为二目运算

异或运算^有一个神奇的应用：

交换a和b的值：

```c
a^=b^=a^=b;
```

e.g.

```c
#include<stdio.h>
int main(){
	int a=1;
	int b=5;
	a^=b^=a^=b;
	printf("a=%d,b=%d",a,b);
	return 0;
}
			//a=5,b=1
```



## 7.1函数

#### 求和函数

```c
#include <stdio.h>

 //求和函数
void sum(int begin, int end)
{
	int i;
	int sum = 0;
	for (i = begin; i <= end; i++) {
		sum += i;
	}
	printf("%d到%d的和是%d\n", begin, end, sum);
}

int main()
{
	sum(1, 10);
	sum(20, 30);
	return 0;

}
```

#### 什么是函数

一块代码，接受零个或多个参数做一件事，并返回零个或一个值

![image-20230302151822813](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20230302151822813.png)

#### 调用函数

- 函数名(参数值)；
- ()起到了表示函数调用的作用
- 即使没有参数也要加()

#### 从函数中返回值

##### return的作用

1. 结束函数的运行
2. 带着运算结果返回主调函数

但当函数产生了多个运算结果，就不能用return来返回
后面会介绍使用全局变量和指针实现函数多个结果返回

但若函数中出现两个ruturn语句，则只能执行一个，return之后的语句将不会被执行

return 表达式;

```c
#include<stdio.h>
int max(int a, int b)
{
	int ret;
	if (a > b) {
		ret = a;
	}
	else {
		ret = b;
	}
	return ret;
}
```

####  没有返回值的函数

void  函数名(参数表)
不能使用带值的return
可以没有return(或者return无表达式)，调用的时候不能做返回值的赋值
由于没有返回结果，函数调用不可能出现在表达式中，通常以独立的调用语句方式，如pyramid(n);

### 7.2函数的参数和变量

#### 函数先后关系

![image-20230302191820162](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20230302191820162.png)

函数头中的参数是形参，调用函数时的参数是实参

#### 函数原型

![image-20230302205059149](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20230302205059149.png)

对于函数声明，可以只写参数类型而不写参数名
函数声明既可以写在主函数里面，也可以写在主函数外面，但习惯写在主函数外面

#### 调用函数

![image-20230302210059831](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20230302210059831.png)

#### 传值

![image-20230302225311542](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20230302225311542.png)

#### 本地变量

​	函数每次运行，就产生了一个独立的变量空间，在这个空间中的变量，是函数的这次运行所独有的，称作本地变量
​	定义在函数内部的变量就是本地变量
​	参数也是本地变量

#### 全局变量和局部变量

```c
#include<stdio.h>
int a;
int main(){
	int b;
	{
	int c;
	}
	return 0;
}
```

定义在函数内部的变量为局部变量，有效作用范围局限于所在的函数内部。形参是局部变量。

全局变量定义在函数外，不属于任何函数，作用范围是从定义开始到程序所在文件的结束。

变量a为全局变量，变量b为局部变量，当遇到函数需要传多个值的时候，可以通过定义全局变量的方式进行传值.

定义在复合语句内的变量，作用范围局限在复合语句内，如变量c。

全局变量和局部变量可以重名，在出现重名的函数中，变量值采用局部变量。

局部变量都是自动变量，调用时分配内存空间，调用结束内存自动回收。

自动变量如果没有赋初值，其储存单元中将是随机值

而静态变量如果在定义时没有赋初值，系统将动赋0，而且初值只在函数第一次调用的时候起作用，以后调用都按前一次调用保留的值使用

#### 变量的生存期、作用域

什么时候这个变量出现了，到什么时候它消亡了---**生存期**

在代码的什么范围可以访问这个变量(变量可以起作用)---**作用域**

对于本地变量，这两个问题的答案是统一的：大括号内(块)

#### 变量储存的内存分布

保存所有变量的储存区分为**动态储存区**和**静态储存区**
动态储存区使用堆栈来管理，适合函数动态分配与回收储存单元
静态储存区相对固定，用于存放全局变量和静态变量

#### 静态变量

储存在静态储存区，储存单元会被保留，生存周期持续到程序结束

定义格式：`static  类型名  变量表`

#### 本地变量的规则

- 本地变量是定义在块内的

​		可以是定义在函数的块内
​		也可以定义在语句的块内
​		甚至可以随便拉一对大括号来定义变量

- 程序运行进驻这个块之前，其中的变量不存在，离开这个块，其中的变量就消失

- 在块外边定义的变量，在块内仍然有效
- 块里面定义了和外面同名的变量，则掩盖了外面的，出来之后，其值仍然是原来在外面定义的值       
- 在同一个块里面，不能同时定义同名的变量
- 本地变量不会被默认初始化
- 参数在进入函数时候被初始化

#### 当函数没有参数时

- void f(void);

  明确声明，该函数不接受任何参数

- void f();

  表示参数表位置，并不表示没有参数

当构造一个普通函数的时候，最好在括号内填入参数，若没有参数则填void

#### 调用函数时的逗号

调用函数时圆括号里的逗号是标点符号，不是运算符，例如f(a,b)，然而f((a,b))里面的逗号是运算符

#### 数字金字塔

```c
#include<stdio.h>
void pyramid(int n);
int main(){
	int n;
	printf("Enter n:");
	scanf("%d",&n);
	pyramid(n);
	return 0; 
}
void pyramid(int n){
	for(int i=1;i<=n;i++){
		for(int j=1;j<=n-i;j++){
			printf(" ");
		}
		for(int a =1;a<=i;a++){
			printf("%d ",i);
		}
		putchar('\n');
	}
}
```

#### 

## 8.1数组

#### 定义数组

<类型> 变量名称[元素数量];
int grades[100];
double weight[20];
元素数量必须是整数

数组名是一个地址常量，存放数组内存空间的首地址，不允许随意更改

#### 数组是什么

是一种容器
其中所有的元素具有相同的数据类型
一旦创建，不能改变大小
数组中的元素在内存中是连续一次排列的

#### int a[10];

一个int的数组
10个单元：a[0]，b[1]，....，a[9]
每个单元就是一个int类型的变量
在赋值左边的叫做左值

#### 数组的单元

数组的每个单元就是数组类型的一个变量
使用数组时放在[]中的数字叫做下标或索引，下标从0开始计数
grades[0]

#### 有效的下标范围

编译器和运行环境不会检查数组下标是否越界，无论是对数组单元做读还是写
一旦程序运行，越界的数组访问可能造成的问题，导致系统崩溃

segmentation fault 报错可能是数组越界

数组下标的合理取值范围：[0，数组长度-1]，注意不要让下标越界

####  统计0-9之间的数字输入的次数

```c
#include <stdio.h>
int main()
{
	int x;
	int count[10];
	int i;
	//初始化数组(循环遍历数组)
	for (i = 0; i < 10; i++) {
		count[i] = 0;
	}
	scanf_s("%d", &x);
	while (x != -1) 
	{
		if (x >= 0 && x <= 9) {
			//数组参与运算
			count[x] ++;
		}
		scanf_s("%d", &x);
	}
	//遍历输出数组
	for (i = 0; i < 10; i++) {
		printf("%d:%d\n", i, count[i]);
	}
	return 0;
}
```

### 8.2数组运算

#### 数组的集成初始化

```c
int a[] = {2,3,4,45,5,6,4};
```

#### 集成初始化时的定位

```c
int a[10] = {[0]=2, [2]=3, 6 };
```

- 用[n]在初始化数据中给出定位
- 没有定位的数据在前面的位置后面
- 没有位置的值补零
- 也可以不给出数组大小，让编译器算
- 特别适合初始数据稀疏的数组
- 数组未初始化默认为0
- **但要注意，**在使用前尽量将数组初始化，至少把数组第一个元素初始化，剩余元素会自动初始化为0,
- 一般来说，全局变量，静态变量位于数据区，默认初始化为0，局部数组根据编译器的特点有所不一样

#### 数组的大小

sizeof给出整个数组占据的内容的大小，单位是字节

```c
sizeof(a)/sizeof(a[0])
```

sizeof(a[0])给出数组中单个元素的大小，于是相除就得到了数组的单元个数

#### 数组的赋值

数组变量本身不能被赋值
要把一个数组的所有元素交给另一个数组，必须采用遍历

#### 遍历数组

```c
for ( i=0 ; i<length ;i++ ){
	b[i] = a [i];
}
```

#### 数组查找

```c
#include <stdio.h>

int search(int key, int a[], int length);

int main() {
	int a[] = { 1,2,3,4,5,56,5,5,6,8 };
	int x;
	int loc;
	printf("请输入一个数字：");
	scanf_s("%d", &x);
	loc = search(x, a, sizeof(a) / sizeof(a[0]));
	if (loc != -1) {
		printf("%d在第%d个位置上\n", x, loc+1);
	}
	else {
		printf("%%d不存在\n", x);

		return 0;
	}
}

	int search(int key, int a[], int length){
		
		int ret = 1;
		int i;
		for (i = 0; i <length; i++) {
			if (a[i] == key) {
				ret = i;
				break;
			}
		}
		return ret;
	}
```

#### 计算斐波那契数列

```c
#include<stdio.h>
#define MAXN 46
int main(){
	int i,n;
	int fib[MAXN]={1,1};
	printf("Enter n:");
	scanf("%d",&n);
	if(n>=1&&n<=46){	
	for(i=2;i<=n;i++){
		fib[i]=fib[i-1]+fib[i-2];
	}
	for(i=1;i<=n;i++){
		printf("%6d",fib[i-1]);	
	if(i%5==0){
		printf("\n");
	}
	}	
	}else{	
		printf("Invalid Value!\n");
	}
	return 0;
} 
```

#### 查找数组中最小值及其下标

```c
#include<stdio.h>
#define MAXN 10
int main(){
	int i,index,n;
	int a[MAXN];
	printf("Enter n:");
	scanf("%d",&n);
	for(i=0;i<n;i++){
		scanf("%d",&a[i]);
	}
	index=0;
	for(i=1;i<n;i++){
		if(a[i]<a[index]){
			index=i;
		}
	}
	printf("min is %d \t sub is %d\n",a[index],index);
	return 0;
}
```

#### 二维数组

```c
int a[3][5];
```

通常理解为a是一个3行5列的矩阵

![image-20230305110202872](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20230305110202872.png)

二维数组的元素在内存存放：(按照行优先的方式存放)先存放第0行元素，再存放第1行元素........

#### 二维数组遍历

```c
for (i=0;i<3;i++){
	for (j=0;j<5;j++){
		a[i][j] = i*j;
	}
}
```

#### 二维数组的初始化

```c
int a[][5] = {
	{0,1,2,3,4},
	{2,3,4,5,6},

};
```

- 列数是必须给出的，行数可以由编译器来数
- 每行一个{}，逗号分隔
- 最后的逗号可以存在
- 如果省略，表示补零

#### 找出矩阵中最大值

```c
#include<stdio.h>
#define MAXM 6
#define MAXN 6
int main(){
	int n,m,col,i,j,row;
	int a[MAXM][MAXN];
	printf("Enter m,n:");
	scanf("%d %d",&m,&n);
	
	printf("Enter %d characters:\n",m*n);
	for(i=0;i<m;i++){
		for(j=0;j<n;j++){
			scanf("%d",&a[i][j]);
		}
	}
	
	row=col=0;
	for(i=0;i<m;i++){
		for(j=0;j<n;j++){
			if(a[i][j]>a[row][col]){
				row=i;
				col=j;
			}
		}
		
	}
	printf("max=a[%d][%d]=%d\n",row,col,a[row][col]);
	return 0;
}
```

#### 判断回文

```c
#include<stdio.h>
#define MAXLINE 80
int main(){
	int i,k;
	char line[MAXLINE];
	
	printf("Enter a string:");
	k=0;
	while((line[k]=getchar())!='\n'){
		k++;
	}
	line[k]='\0';
	i=0;
	k=k-1;
	while(i<k){
		if(line[i]!=line[k]){
			break;
		}
		i++;
		k--;
	}
	if(i>=k){
		printf("Palindrome\n");
	}else{
		printf("Not a Palindrome\n");
	}
	return 0;
} 
```

以下方法更简洁

```c
#include <stdio.h>
int main()
{
	int max=80;
	int k=0;
	char a[max];
	scanf("%d",&k);
	while((a[k]=getchar())!='\n'){
		k++;
	}
	a[k]='\0';
	k=k-1;
	int i=0;
	while(i<k){
		if(a[i]!=a[k]){
			printf("not");
			return 0;
		}
		i++;
		k--;
	}
	printf("yes");	
return 0; 
}
```

## 9.1指针

#### 运算符&

```
scanf("%d",&i);
```

获得变量地址，只能对变量取地址

#### 输出地址

```
printf("%p\n",&i);
```

#### 指针

```
int* p = &i;
```

 表示内存地址的变量

星号可以靠近p也可以靠近int，但

```
int* p,q;
```

*p是一个指针变量，而q是普通变量

#### 指针定义

```
int *p;				//定义一个指针变量p,指向整型变量
char *cp;			//定义一个指针变量cp，指向字符型变量
float *fp;
double *dp1，*dp2;	//定义多个指针时，每个变量名前都要加上*
```

不同的类型名代表该指针所指向的内存空间上所存放的数据的类型

#### 作为参数的指针

```
void f(int *p);
```

在被调用的时候得到了某个变量的地址：

```
	int i = 0;
	f(&i);
```

#### 访问地址上的变量*

*(指针声明符)是一个单目运算符(运算的优先级较高)，用来访问指针的值所表示的地址上的变量

#### 指针应用

##### 交换两个变量的值

```
void swap(int *pa,int *pb)
{
	int t = *pa;
	*pa = *pb
	*pb = t;
}
```

##### 寻找数组中最大值和最小值

```
#include <stdio.h>

void minmax(int a[], int len, int* max, int* min);

int main() {
	int a[] = { 1,2,3,4,5,6,7,8,9,0,33,55 };
	int min, max;
	minmax(a, sizeof(a) / sizeof(a[0]), &min, &max);
	printf("min=%d,max=%d\n", min, max);
	return 0;
} 

void minmax(int a[], int len, int* min, int* max)
{
	int i;
	*min = *max = a[0];
	for (i = 1; i < len; ++i) {

		if (a[i] < *min) {
			*min = a[i];
		}
		if (a[i] > *max) {
			*max = a[i];
		}
	}
}
```

#### 指针常见的错误

定义了指针变量，还没有指向任何变量，就开始使用指针

另外，`++*p`、`(*p)`++都是将指针p所指向的变量值加1，而表达式`*p++`等价于`*(p++)`随后p不再指向变量a

#### 传入函数的数组

函数表中的数组实际上是指针

```
sizeof(a)==sizeof(int*)
```

但是可以用数组的运算符[]进行运算

#### 数组名作为函数的参数

数组的形参a实际上是一个指针，进行参数传递时，主函数传递的是数组a的基地址，数组元素本身不被复制。

```
int sum(int a[ ],int n){
	int i,s =0;
	for(i=0;i<n;++i){
	s+=a[i];
	}
	return s;
}
```



#### 数组变量是特殊的指针

数组变量本身表达地址

```
int a[10]; int*p=a;  //无需用&取地址
```

数组的单元表达的是变量，需要用&取地址

```
a == &a[0]
```

[]运算符可以对数组做，也可以对指针做

```
p[0] <==> a[o]
```

*运算符可以对指针做，也可以对数组做
数组变量是const的指针，所以不能被赋值

```
int a[] <==> int * const a =
```

#### 指针、数组和地址间的关系

数组的基地址是在内存中存储数组的起始位置，是数组中第一个元素的地址

数组名的值是一个特殊的固定地址，可以看作是指针常量，不是变量，不能对其进行赋值操作

下面两条语句是等价的：

```c
p=a;
p=&a[0];
```

同时下面两条语句也是等价的：

```c
p=a+1;
p=&a[1];
```

#### 通过指针实现数组求和

e.g.输入正整数n，再输入，n个整数作为数组元素，分别使用数组和指针来计算并输出他们的和

```c
#include<stdio.h>
int main(){
	int n,i;
	int a[10];
	int *p;
	int sum1=0,sum2=0;
	printf("Enter n:");
	scanf("%d",&n);
	printf("Enter %d integers:",n);
	for(i=0;i<n;i++){
		scanf("%d",&a[i]);
	}	
	for(p=a;p<a+n;p++){
		sum2=sum2+*p;
	}
		for(i=0;i<n;i++){
		sum1=sum1+*(a+i);
	}
	printf("Calculated by arry:%d\n",sum1);
	printf("Calculated by pointer:%d\n",sum2);
	return 0;
} 
```

通过以下方法也可以实现数组求和

```c
p=a;
sum=0;
for(i=0;i<100;i++){
	sum+=p[i];
}
```

#### 通过指针计算数组元素个数和数组元素的储存单元数

```c
#include<stdio.h>
int main(){
	double a[2],*p,*q;
	p=&a[0];
	q=p+1;
	printf("%d\n",q-p);
	printf("%d\n", (int)q-(int)p);
	return 0;
}
```

#### 指针是const

表示一旦得到了某个变量的地址，不能再指向其他变量

```c
int * const q = &i;    //q 是const
*q = 26 ;  //OK
q++ ;  //ERROE
```

#### const数组

```c
const int a[] = {1,2,3,4,5,6};
```

​	数组变量已经是const的指针了，这里的const表明数组的每个单元都是const int

​	所以必须通过初始化进行赋值

#### 保护数组值

因为把数组传入函数时传递的是地址，所以那个函数内部可以修改数组的值
为了保护数组不被函数破坏，可以设置参数为const

```c
int sum (const int a[] , int length );
```

### 9.2指针运算

指针地址+1实际上是加一个sizeof()

给一个指针加1表示要让指针指向下一个变量

```c
int a[10] ;
int *p = a ;
```

```c
*(p+1) ---> a[1]
```

如果指针不是指向一片连续分配的空间(如数组)，则这种运算没有意义

#### 指针计算

这些算术运算可以对指针做：

- 给指针加减一个整数
- 递增递减(++/--)
- 两个指针相减

指针减法的含义是，表示两个指针之间含有几个sizeof()

#### *p++

- 取出p所指的那个数据，之后把p移动到下一个位置去
- *优先级比++低
- 常用于数组类的连续空间操作
- 在某些CPU上，这可以直接被翻译成一条汇编指令

####  指针比较

<,<=,==,>,>=,!=都可以对指针做
比较它们在内存中的地址
数组中的单元的地址肯定是线性递增的

#### 0地址

0地址通常是不能随便碰的地址
可以用0地址来表示特殊的事情
	返回的指针是无效的
	指针没有被真正初始化
NULL是一个预定定义的符号，表示0地址
	有的编译器不希望用0表示0地址

#### 指针的类型

无论指向什么类型，所有的指针大小都是一样的(因为都是地址)

但是指向不同类型的指针是不能直接互相赋值的(为了避免用错指针)

#### 指针的类型转换

void* 表示不知道只想什么东西的指针
	计算时与char*相同(但不相通)

指针也可以转换类型

```c
int *p = &i ;
void *q = (void*)p ;
```

这并没有改变p所指的变量的类型，而是让后人用不同的眼光通过p看他所指的变量

#### 用指针来做什么

- 需要传入较大的数据用作参数
- 传入数组后对数组做操作
- 函数返回不止一个结果
- 需要用函数来修改不止一个变量
- 动态申请的内存....

### 动态内存的分配

#### malloc

就是向系统申请内存

```c
#include<stdlib.h>
void* malloc(size_t size) ;
```

向malloc申请的空间的大小是以字节为单位的
返回的结果是void*，需要类型转换为自己需要的类型

```c
(int*)malloc(n*sizeof(int))
```

#### 如果没空间了

如果申请失败则返回0，或者叫做NULL

```c
#include <stdio.h>
#include<stdlib.h>
int main(void) {
	void *p;
	int cnt = 0;
	while ((p = malloc(100 * 1024 * 1024))) {
		cnt++;
	}
	printf("分配了%d00MB的空间", cnt);
	return 0;
	}
```

查看系统最多能给分配多少内存(不要轻易尝试，容易卡死)

#### free()

与malloc配套的函数，把申请的空间还给系统

只能还申请阿里的空间的首地址

#### 常见问题

申请了没free---->长时间运行内存逐渐下降(内存垃圾堆积)

## 10.1字符串

#### 字符数组

![image-20230307163854417](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20230307163854417.png)

- 以整数0结尾的一串字符
- 0或'\0'是一样的，但是和'0'不同
- 0标志字符串的结束，但它不是字符串的一部分|
- 计算字符串长度的时候不包含这个0
- 字符串以数组的形式存在，以数组或指针的形式访问
- 更多的是以指针的形式
- string.h里有很多处理字符串的函数

#### 字符串变量

```c
char *str = "Hello" ;
char word[] = "Hello" ;
char line[10] = "Hello" ;
```

#### 字符串常量

- "Hello"
- "Hello"会被编译器变成一个字符数组放在某处，这个数组的长度是6，结尾还有表示结束的0
- 两个相邻的字符串常量会被自动连接起来

```c
char* s = "hello,world.";
```

- s是一个指针，初始化为指向一个字符串常量
- 这个常量所在的地方只能读不能写，所以实际上s是`const char* s`，但是由于历史的原因，编译器接受不带const的写法
- 试图对s所指的字符串做写入会导致严重的后果
- 如果需要修改字符串，应该用数组：`char s[] = "Hello,world!";`

#### 字符串

- C语言的字符串是以字符数组的形态存在的
- 不能用运算符对字符串做运算
- 通过数组的方式可以遍历字符串
- 唯一特殊的地方是字符串字面量可以用来初始化字符数组
- 标准库提供了一些列字符串函数

#### 构造字符串，用指针还是数组

数组：这个字符串在这里，作文本地变量空间自动被收回
指针：这个字符串不知道在哪里(处理参数，动态分配空间)

也就是说，
如果要构造字符串---->数组
如果要处理字符串---->指针

#### char*是字符串？

不对，字符串可以表达为`char*`形式，但`char*`不一定是字符串
本意是指向字符串的指针，可能指向的是字符的数组(就像int*一样)
只有它所指的字符串数组有结尾的0，才能说它所指的是字符串

#### 字符串输入输出

```c
char string[8];
scanf("%s,string");
printf("%s",string);
```

scanf读入一个单词(到空格、tab或回车为止)
scanf是不安全的，其不限制读入的长度

#### 安全的输入

```c
char string[8];
scanf("%7s",string);
```

​	在%和s之间的数字表示最多允许读入的字符的数量，这个数字应该比数组的大小小一

#### 常见错误

```c
char *string;
scanf("%s",string);
```

以为char*是字符串类型，定义了一个字符串类型的变量string就可以直接使用了

由于没有对string初始化为0，所以不一定每一运行都出错

#### 空字符串

```c
char buffer[100]="";
	这是一个空的字符串，buffer[0] == '\0'
char buffer[] = "";
	这个数组的长度只有1
```

#### 字符串数组

```c
char **a
```

a是一个指针，指向另一个指针

```c
char a[][]
```

#### 程序参数

```c
int main(int argc,char const *argv[])
```

argv[0]是命令本身
当使用Unix的符号链接时，反应符号链接的名字

### 10.2字符串函数

#### putchar

```c
int putchar(int c);
```

向标准输出写一个字符

返回写了几个字符，EOF(-1)表示写失败

#### getchar

```c
int getchar(void);
```

从标准输入读入一个字符
返回类型是int是为了返回EOF(-1)

输入结束 Windows ： CTRL+D
				 Unix：CTRL+Z

### string.h文件头

#### strlen

```c
size_t strlen(const char *s);
```

返回s的字符串长度(不包括结尾的0)

```c
#include <stdio.h>
int main() {
	char line[] = "hello";
	printf("strlen=%lu\n", strlen(line));
	printf("sizeof=%lu\n", sizeof(line));
	return 0;
}
```

strlen=5，sizeof=6 (字符串数组结尾有\0)

#### strcmp

```c
int strcmp(const char *s1,const char *s2);
```

比较两个字符串，返回：

```c
0:s1==s2
1:s1>s2
-1:s1<s2
```

#### strcpy

```c
char *strcpy(char *restrict dst,const char *restrict src);
```

把src的字符串拷贝到dst
restrict表明src和dst不重叠
返回dst
为了能链起代码来

##### 复制一个字符串(复制字符串而不是指针)

```c
char* dst = (char* ) mallloc (strlen (src)+1);
strcpy(dst,src);
```

#### strcat

```c
char * strcat(char *restrict s1,const char *restrict s2);
```

把s2拷贝到s1的后面，接成一个长的字符串
返回s1
(s1必须具有足够的空间)

#### 安全问题

strcpy和strcat都可能出现安全问题
(如果目的地没有足够的空间)

#### 字符串中找字符

```c
char * strchr(const char *s,int c);
char * strchr(const char *s,int c);  //从右边找回来
```

返回NULL表示没有找到

####  字符串中找字符串

```c
char *srtrstr(const char *s1,const char *s2);
char *strcasestr(const char *s1,const char* s2);  //忽略大小写
```







后面的知识感觉现阶段要求没那么深，水一水吧







## 11.1结构类型

#### 枚举

是一种用户定义的数据类型，关键字enum
语法：

```c
enum 枚举类型名字 {名字0,.....,名字n}；
```

枚举类型名字通常并不真的使用，要用的是大括号里的名字，因为它们就是常量符号，它们的类型是int，值则依次从0到n

```c
enum colors {red, yellow,green};
```

就创建了三个常量，red的值是0，yellow是1，green是2

当需要一些可以排列起来的常量时，定义枚举的意义就是给了这些常量值名字

```c
#include <stdio.h>
enum color {red,yellow,green};
void f(enum color c);
int main() {
	enum color t = red;
	scanf_s("%d", &t);
	f(t);
	return 0;
	}
void f(enum color c)
{
	printf("%d\n", c);
}
```

#### 枚举量

声明枚举量的时候可以指定值

```c
enum COLOR {RED=1,YELLOW,GREEN = 5};
```

这样的话，RED是1，YELLOW是2，GREEN是5，3和4就直接跳过了

#### 枚举只是int

即使给枚举类型的变量赋不存在的整数值也没有任何warning或error

虽然枚举类型可以当做类型使用，但实际上不好用

如果有意义上排比的名字，用枚举比const int 方便

枚举比宏(macro)号，因为枚举有int类型

### 11.2结构

####  声明结构类型

```c
#include<stdio.h>
int main(int argc,char const *argv[])
{
	struct date{
		int month;
		int day;
		int year;
	};   //该分号易漏，一定要注意
	struct date today;
	today.month = 07;
	today.day = 31;
	today.year = 2014;
	printf("Today's date is %i-%i-%i.\n",today.year,today.month,today.day);
	return 0;
}
```

当然，和本地变量一样，在函数内部声明的结构类型只能在结构内部使用

所以通常在函数外部声明结构类型，这样就可以被多个函数使用了

#### 声明结构的形式

##### 第一种形式

```c
struct point{
	int x;
	int y;
};
struct point p1,p2;
```

p1和p2都是point里面有x和y的值

先声明结构，再给出变量

##### 第二种形式

```c
struct {
	int x;
	int y;
}p1,p2;
```

p1和p2都是一种无名结构，里面有x和y

##### 第三种形式

```c
struct point {
	int x;
	int y;
}p1,p2;
```

p1和p2都是point，里面有x和y

#### 结构的初始化

```c
#include <stdio.h>
struct date {
	int month;
	int day;
	int year;
};
int main() {
	struct date today = {07, 31, 2014};
	struct date thismonth = { .month = 7,.year = 2014 };
	printf("Today's date is %i-%i-%i.\n", today.year, today.month, today.day);
	printf("Today's date is %i-%i-%i.\n", thismonth.year, thismonth.month, thismonth.day);
}
```

上面给出了两种初始化类型

#### 结构成员

结构和数组有点像 

数组用[]运算符和下标访问其成员

​	a[0]=10；

结构用`.`运算符和名字访问其成员

#### 结构运算

要访问整个结构，直接用结构变量的名字

对于整个结构，可以做赋值、取地址、也可以传递给函数参数

```c
p1 = (struct point){5,10}; //相当于p1.x = 5;p1.y = 10;
```

#### 结构指针

和数组不同，结构变量的名字并不是结构变量的地址，必须使用&运算符

```c
struct date *pDate = &today;
```

#### 结构作为函数参数

```c
int numberofDays(struct date d)
```

整个结构可以作为参数的值传入函数

这时候是在函数内部新建一个结构变量，并赋值调用者的结构的值

也可以返回一个结构，这与数组完全不同

#### “输入结构”解决方案

把一个结构传入函数，然后再函数中操作，但是没有返回回去

问题在于传入函数的是外面那个结构的克隆体，而不是指针

​	传入结构和传入数组是不同的

​	**在这个输入函数中，完全可以创建一个临时的结构变量，然后把这个结构返回给调用者**

```c
void main(){
	struct point y = (0,0);
	y = input Point
}
```

```c
struct point inputPoint()
{
	struct point temp;
	scanf("%d",&temp.x);
	scanf("%d",&temp.y);
	return temp;
}
```

#### c指向结构的指针

```c
struct date {
	int month;
	int day;
	int year;
}myday;

struct date *p = &myday;

(*p).month = 12;
p->month = 12;
```

用->表示指针所指的结构变量中的成员

#### 结构数组

```c
struct date dates[100];
struct date dates[] = {
	{4,5,2005},{2,4,2005}};
```

只是举个栗子，完整的代码就不qiao了

#### 结构中的结构

```c
struct dateAndTime{
	struct time stime;
	struct date sdate;
};
```

#### 嵌套的结构

![image-20230309215655624](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20230309215655624.png)

#### 结构中的结构的数组

![image-20230309220058697](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20230309220058697.png)

### 11.3联合

#### 自定义数据类型(typedef)

c语言提供了一个叫做typedef的功能来声明一个已有的数据类型的新名字
比如： typedef int Length
使得 Length 成为 int 类型的别名

这样，Length 这个名字就可以代替int出现在变量定义和参数声明的地方了

```c
Length a,b,len;
Length numbers[10];
```

Typedef用来声明新的类型的名字
	新的名字是某种类型的别名
	改善了程序的可读性

![image-20230309222311356](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20230309222311356.png)

(第一个是原来的名字，后面的是新名字)

![image-20230309222632697](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20230309222632697.png)

#### 联合

​	储存时，所有的成员共享一个空间，同一时间只有一个成员是有效的，union的大小事其最大的成员。

​	初始化时，对第一个成员做初始化。

## 12.1算法

常用排序算法：选择排序，冒泡排序，插入排序

#### 选择排序

```c
#include<stdio.h>
#define MAXN 10
int main(){
	int i,index,k,n,temp;
	int a[MAXN];
	
	printf("Enter n:");
	scanf("%d",&n);
	for(i=0;i<n;i++){
		scanf("%d",&a[i]);
	}
	
	for(k=0;k<n-1;k++){
		index=k;
		for(i=k+1;i<n;i++){
			if(a[i]<a[index]){
				index=i;
			}
		}
		
		temp=a[index];
		a[index]=a[k];
		a[k]=temp;
	}
	
	printf("After sorted:");
	for(i=0;i<n;i++){
		printf("%d",a[i]);
	}
	printf("\n");
	return 0;
}
```

#### 冒泡排序

```c
#include<stdio.h>
#define MAXN 10
void swap(int*px, int*py);
void bubble(int a[],int n);
int main(){
	int n,a[MAXN];
	int i;
	printf("Enter n(n<=10):");
	scanf("%d",&n);
	printf("Enter %d characters:\n",n);
	
	for(i=0;i<n;i++){
		scanf("%d",&a[i]);
	}
		
	bubble(a,n);
	printf("After sorted:");
	for(i=0;i<n;i++){
		printf("%3d",a[i]);	
	}
	return 0;
}

void swap(int *px,int *py){
	int t;
	t=*px;
	*px=*py;
	*py=t;
}

void bubble(int a[],int n){
	
	int i,j,t;
	for(i=1;i<n;i++){
		for(j=0;j<n-i;j++){
			if(a[j]>a[j+1]){
				swap(&a[j],&a[j+1]);
			}
		}
	}
}
```

#### 分类统计

```c
#include<stdio.h>
#define MAXN 8
int main(){
	int n,i,response;
	int a[MAXN+1];
	printf("Enter n:");
	scanf("%d",&n);
	for(i=1;i<=n;i++){
		a[i]=0;
	}
	for(i=1;i<=n;i++){
		printf("Enter your response:");
		scanf("%d",&response);
		if(response>=1&&response<=MAXN){
			a[response]++;
		}else{
			printf("Invalid number!\n");
		}
	}
	printf("result:\n");
	for(i=1;i<=n;i++){
		printf("%4d%4d\n",i,a[i]);
	}	
	return 0;
}
```

#### 二分查找法

```c
#include<stdio.h>
int main(){
	int low,high,mid,n=10,x;
	int a[10]={1,2,3,4,5,6,7,8,9,10};
	printf("Enter x: ");
	scanf("%d",&x);
	low=0;
	high=n-1;
	while(low<=high){
		mid=(low+high)/2;
		if(x==a[mid]){
			break;
		}else if(x>a[mid]){
			low=mid+1;
		}else{
			high=mid-1;
		}
	}
	if(low<=high){
		printf("Index is %d\n",mid);
	}else{
		printf("Not Found\n");
	}
	
	return 0;
}
```

#### 递归函数

递归是一种独特的定义方式
如果在定义某个事物的时候，又直接或间接地引用了这个事物本身，就称之为递归定义
例如，将n的阶乘定义为n-1的阶乘乘以n，就是一个递归定义

##### 使用递归算法求n的阶乘：

```c
#include<stdio.h>
long fact(int n);
int main(){
	int m=0,n;
	printf("Enter n:");
	scanf("%d",&n);
	m=fact(n);
	printf("n!=%d",m);
	return 0;
} 
long fact(int n){
	int f=0;
	if(n==1){
		f=1;
	}else{
		f=n*fact(n-1);
	}
	return f;
}
```

## 13.1几个综合练习

#### 1.求m到n之间整数的和(m<n)，包括m和n

```c
#include<stdio.h>
int sum(int m, int n);
int main(){
	int m,n;
	printf("Enter m n ,(m<n):"); 
	scanf("%d %d",&m,&n);
	printf("sum = %d\n",sum(m,n));
	return 0;
}

int sum(int m,int n){
	int sum=0;
	while(m<=n){
		sum=sum+m;
		m++;
	}	
	return sum;
}
```

#### 2.计算摄氏温度

```c
#include<stdio.h>
int main(){
	double f,c;
	printf("Enter F:");
	scanf("%lf",&f);
	c=5*(f-32)/9;
	printf("Celsius = %.1lf",c);	
	return 0;
}
```

#### 3.最大公约数和最小公倍数

> 可以先用辗转相除法求出最大公约数，然后`a*b/[最大公约数]=最小公倍`

```c
#include<stdio.h>
int main(){
	int m,n,t,k;
	int a,b;
	scanf("%d %d",&m,&n);
	a=m;
	b=n;
	if(n>m){
		t=m;
		m=n;
		n=t;
	}
	while(n!=0){
		t=m%n;
		m=n;
		n=t;
	}
	k=a*b/m;
	printf("%d %d",m,k);
	return 0;
} 
```

#### 4.统计字符

输入10个字符，统计其中英文字母，空格或回车，数字字符和其他字符的个数

```c
#include<stdio.h>
int main(){
	char a;
	int blank=0,digit=0,letter=0,other=0;
	for(int i=1;i<=10;i++){
		a=getchar();
		switch (a){
			case ' ':
			case '\n':
			blank++; 
			break;
			case '1':case '2':case '3': case '4': case '5': 
			case '6':case '7':case '8': case '9': case '0':
			digit++;
			break;
			case 'a':case 'b':case 'c':case 'd':case 'e':case 'f':case 'g':case 'h':
			case 'i':case 'j':case 'k':case 'l':case 'm':case 'n':case 'o':case 'p':
			case 'q':case 'r':case 's':case 't':case 'u':case 'v':case 'w':case 'x':
			case 'y':case 'z':
			letter++;
			break;
			default:
				other++;
				break; 
			}
	}
	printf("blank:%d,digit:%d,other=%d,letter:%d\n",blank,digit,other,letter);
	return 0;
} 
```

#### 5.输出闰年

```c
#include<stdio.h>
int main(){
	int year;
	scanf("%d",&year);
	if(year%100==0){
		if(year%400==0){
			printf("闰年");
		}else{
			printf("不是闰年");
		}
	}
	else if(year%4==0){
		printf("r闰年");
	}
	else{
		printf("不是闰年"); 
	} 
	return 0;
}
```

#### 6.判断水仙花数

```c
#include<stdio.h>
#include<stdlib.h>
#include<math.h>
int main()
{
	int n;    
	int  t,z = 0;
	scanf("%d", &n);
	int min = pow(10, n - 1);
	int max = pow(10, n);
	for(int i=min;i<max;i++)
	{ 
	z = i;     
	t = 0;    
	while(z > 0)
	{
		t = t+pow(z % 10, n);
		z = z / 10;
	}
	if (i == t)
	{
		printf("%d\n", i);
	}
	}
	return 0;
}
```



## 2023六月份希冀在线判题平台样题

### 1.

【问题描述】计算摄氏温度：输入华氏温度，输出对应的摄氏温度。计算公式如下：  **c=5×(f-32)÷9**

​          其中，c表示摄氏温度，f表示华氏温度，均使用浮点数存储数据。

【输入形式】输入一个温度值。
【输出形式】输出的**数值结果前带有字符串**“Celsius**=**”，输出**保留二位小数。**
【样例输入】**150**
【样例输出】**Celsius=65.56**

```c
#include<stdio.h>
int main(){
	double c;
	double f;
	scanf("%lf",&f);
	c=5*(f-32)/9;
	printf("Celsius=%.2lf",c);
	return 0;
}
```



### 2.

【问题描述】求给定序列（1+1/2+1/3+……）前n项的和：输入一个正整数n，计算序列1+1/2+1/3+……的前n项之和；

【输入形式】输入一个整数值，输出一个**单精度浮点数**。
【输出形式】输出n的值，前面包含字符串"**n=**"；输出**逗号**"**,**"；输出求和后的结果值，前面包含字符串"**sum=**"，**保留7位小数**
【样例输入】**5**
【样例输出】**n=5,sum=2.2833335**
【补充说明】若结果为总是为1，请仔细思考有关数据类型运算规则的问题。同时思考，若使用双精度浮点输出，结果应该是多少？

``` c
#include<stdio.h>
int main(){
	int n,k=1,i;
	float sum=0,u;
	scanf("%d",&n);
	for(i=0;i<n;i++){
		u=1.0/k;
		sum=sum+u;
		k++;
	}
	
	printf("n=%d,sum=%.7f",n,sum);
	return 0;
}
```

**这道题最容易出问题的地方在于`u=1.0/k`,如果写成u=1/k，u的值会被按整型来计算，这样sum的值会恒等于1.0000000**



### 3.

【问题描述】输入一个正整数n（1<n<10），再输入n个整数，存入数组中，再将数组中的数，逆序存放并输出
【输入形式】先输入一个整数n，再输入n个整数，用空格间隔

【输出形式】输出n个整数，用空格间隔

【样例输入】

  5

  1 2 3 4 5

【样例输出】

  5 4 3 2 1

```c
#include<stdio.h>
int main(){
	int n,i;
	int a[10];
	scanf("%d",&n);
	for(i=0;i<n;i++){
		scanf("%d",&a[i]);
	}
	for(i=n-1;i>=0;i--){
		printf("%d ",a[i]);	
	}
	return 0;
}
```

### 4.

【问题描述】输入一个正整数n，再输入n个整数，输出其中最小的值。
【输入形式】先输入一个整数n，再根据n，输入n个数

【输出形式】输出最小值，形式：min=？

【样例输入】

  5

  10 22 4 67 2

【样例输出】

  min=2

```c
#include<stdio.h>
int main(){
	int n,i,min;
	scanf("%d",&n);
	int a[n];
	for(i=0;i<n;i++){
	scanf("%d",&a[i]);
	}
	min=a[0];
	for(i=1;i<n;i++){
		if(a[i]<min){
			min=a[i];
		}
	}
	printf("min=%d",min);
	return 0;
}
```

### 5.

【问题描述】比较大小：输入三个整数，按从小到大顺序输出。
【输入形式】三个整数，以单个空格分隔
【输出形式】三个整数，以单个空格分隔，由小到大输出
【样例输入】2 6 5
【样例输出】2 5 6

c语言非指针题解

```c
#include<stdio.h>
int main(){
	int a,b,c,q,w,e;
	scanf("%d %d %d",&a,&b,&c);
	if(a<b){
		if(a<c){
			q=a;
			if(b<c){
				w=b;
				e=c;
			}else{
				w=c;
				e=b;
			}
		}else{
			q=c;
			w=b;
			e=a;
		}	
	}else{
		if(c>a){
			q=b;
			w=a;
			e=c;
		}else{
			if(b>c){
				q=c;
				w=b;
				e=a;
			}else{
				q=b;
				w=c;
				e=a;
			}
		}
	}
	printf("%d %d %d",q,w,e);
	return 0;
}
```

c语言指针题解

```c
#include <stdio.h>

void swap(int* a, int* b) {
    int temp = *a;
    *a = *b;
    *b = temp;
}

void sort(int* nums, int size) {
    for (int i = 0; i < size - 1; i++) {
        for (int j = 0; j < size - i - 1; j++) {
            if (nums[j] > nums[j + 1]) {
                swap(&nums[j], &nums[j + 1]);
            }
        }
    }
}

int main() {
    int nums[3];
    scanf("%d %d %d", &nums[0], &nums[1], &nums[2]);

    sort(nums, 3);

    printf("%d %d %d\n", nums[0], nums[1], nums[2]);

    return 0;
}

```

c++解法(题目莫名其妙非让用c++，我也不怎么会，用ChatGPT帮忙写的)

```c++
#include<iostream>
using namespace std;

int main() {
    int a, b, c;
    cin >> a >> b >> c;

    if (a > b) {
        swap(a, b);
    }
    if (a > c) {
        swap(a, c);
    }
    if (b > c) {
        swap(b, c);
    }

    cout << a << " " << b << " " << c << endl;

    return 0;
}

```

# 程序片段编程题

### 1.

【问题描述】给定平面上任意两点坐标(x1,y1)和(x2,y2)，求这两点之间的距离（保留两位小数）。要求定义和调用函数dist(x1,y1,x2,y2)计算两点间的距离。
根据程序中的提示，在对应位置编写相关函数及内容。

```c
#include<stdio.h>
#include<math.h>
float dist(float xs,float ys,float xe,float ye){
	float sum;
	sum=sqrt(pow((ye-ys),2)+pow((xe-xs),2));
	return sum;
}

int  main(){
        float  xs,ys,xe,ye,d;
        scanf("%f%f",&xs,&ys);
        scanf("%f%f",&xe,&ye);
        d=dist(xs,ys,xe,ye);
        printf("Distance=%.2f",d);
        return  0;
}
```

这个题要注意pow函数和sqrt函数的用法

pow() 函数用来求 x 的 y 次幂（次方），`pow(x,y)`

sqrt()函数用来求一个非负实数平方根


