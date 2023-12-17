# JavaScript 原型链污染


一些JavaScript 原型链污染基础

<!--more-->

## 前置基础知识

原型链污染攻击也称`JavaScript Prototype` 污染攻击

**Javascript**

> JavaScript（简称“JS”） 是一种具有函数优先的轻量级，解释型或即时编译型的编程语言。虽然它是作为开发Web页面的脚本语言而出名，但是它也被用到了很多非浏览器环境中，JavaScript 基于原型编程、多范式的动态脚本语言，并且支持面向对象、命令式、声明式、函数式编程范式
>
> —JavaScript 百度百科

**NodeJS**

> Node.js发布于2009年5月，由Ryan Dahl开发，是一个基于Chrome V8引擎的JavaScript运行环境，使用了一个事件驱动、非阻塞式I/O模型， 让JavaScript 运行在服务端的开发平台，它让JavaScript成为与PHP、Python、Perl、Ruby等服务端语言平起平坐的脚本语言。
>
> —NodeJS 百度百科

### JavaScript数据类型

#### let和var关键字的区别

使用var或let关键字可以定义变量

**let和var的区别如下：**

- var是全局作用域，let 只在当前代码块内有效

  当在代码块外访问let声明的变量时会报错

- var有变量提升，let没有变量提升

  let必须先声明再使用，否则报Uncaught ReferenceError xxx is not defined

  var可以在声明前访问，只是会报undefined

- let变量不能重复声明，var变量可以重复声明

#### 普通变量

```JavaScript
var x=5;
var y=6;
var z=x+y;
var x,y,z=1;
```

```JavaScript
let x=5;
```

#### 数组变量

```JavaScript
var a = new Array();
```

```JavaScript
var a = [];
```

#### 字典

```JavaScript
var a = {};
var a = {"foo":"bar"};
```

### JavaScript函数

在Javascript中，函数使用function关键字来进行声明

```javascript
function myFunction(){

}		//声明一个函数
function myFuntion(a) {
	
}		//声明一个带参数的函数
function myFuntion(a) {
	return a;
}		//声明一个带返回值的函数
```

#### 匿名函数

```javascript
(function(a){
	console.log(a);
})(123);		//直接调用匿名函数
```

调用fn()即调用了匿名函数的功能，把变量变成函数

```JavaScript
var fn = function(){
	return "将匿名函数赋值给变量"；
}
```

#### 闭包

假设在函数内部新建了一个变量，函数执行完毕之后，函数内部这个独立作用域就会被删除，此时这个新建变量也会被删除。

闭包后，内部函数可以访问外部函数作用域的变量，而外部的函数不能直接获取到内部函数的作用域变量。

例如，不适用额外的全局变量来实现一个计数器
因为add变量指定了函数自我调用的返回值，每次调用值都加1而不是每次都是1

```js
var add=(function(){
	var counter = 0;
	return function () {return counter +=1;}
})
```

### JavaScript类

如果定义一个类，需要以定义”构造函数“的方式来定义，

```js
function newClass(){
	this.test = 1;
}

var newObj = new newClass();
```

如果想添加一些方法，可以在内部使用构造方法

```js
function newClass(){
	this.test = 123;
	this.fn = function(){
		return this.test;
	}
}

var newObj = new newClass();
newObj.fn();
```

#### class关键字

可以使用class关键字来创建一个类

如果不定义构造方法，JavaScript会自动添加一个空的构造方法

```js
class ClassName{
	constructor(){...}
}
```

#### 使用new创建对象

```js
let testClass = new myClass("testtest");
```

#### 往对象添加属性

直接使用`.属性名`即可，例如向testClass添加aaa属性

```js
testClass.aaa = 333;
```

#### 举个例子

JavaScript中，我们以构造函数的方式来定义类：

```js
function a() {
    this.bar = 1
}

new a()
```

`a`函数的内容，就是`a`类的构造函数，而`this.bar`就是`a`类的一个属性。

我们也可以将方法定义在构造函数内部：

```js
function a() {
    this.bar = 1
    this.show = function() {
        console.log(this.bar)
    }
}

(new a()).show()
```

每当我们新建一个a对象，`this.show = function...`就会执行一次，这个`show`方法实际上是绑定在对象上的，而不是绑定在“类”中。

如果希望在创建类的时候只创建一次show方法，这时候就需要使用原型（prototype）：

```js
function a() {
    this.bar = 1
}

Foo.prototype.show = function show() {
    console.log(this.bar)
}

let a = new a()
foo.show()
```

我们可以认为原型prototype是类a的一个属性，而所有用a类实例化的对象，都将拥有这个属性中的所有内容，包括变量和方法。

我们可以通过`a.prototype`来访问`a`类的原型，但`a`实例化出来的对象，是不能通过prototype访问原型的，需要用`__proto__`

```js
foo.__proto__ == Foo.prototype
```



## 原型链污染

原型指的是prototype

如上文，我们使用new创建了一个newClass对象给newObj变量

```js
function newClass(){
	this.test = 1;
}

var newObj = new newClass();
```

实际上，newObj变量使用了原型来实现对象的绑定

prototype是newClass类的一个属性，而所有用newClass类实例化的对象，都将拥有这个属性中的所有内容，包括变量和方法

也就是说：

- prototype是newClass类的一个属性
- newClass类实例化的对象newObj不能访问prototype，但可以通过.__proto__来访问newClass类的prototype
- newClass实例化的对象newObj的.__proto__指向newClass类的prototype

关系图如下：
![image-20230709064342550](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20230709064342550.png)

### 原型链污染原理

现在已经知道实例化的对象的`.__proto__`指向类的`prototype`

那么修改了实例化的对象的`.__proto__`的内容, 类的`prototype`内容也会发生相应改变

### 一个简单利用的例子

有一个类a

```js
function a() {
    this.test = 1;
}
```

实例化一个对象obj

```js
var obj = new a();
```

此时查看ob的内容

![](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20230709065433514.png)

修改a类的原型，添加一个属性test1，令其值为123

```js
a.prototype.test1 = 123;
```

![image-20230709065519337](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20230709065519337.png)

再次查看obj的内容，多了一个test1

![image-20230709065531693](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20230709065531693.png)

访问obj.test1

![image-20230709065546009](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20230709065546009.png)

再实例化一个a的对象

```js
var obj1 = new a();
```

访问obj.test1，发现也是123

![image-20230709065612722](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20230709065612722.png)

然后尝试通过obj1的`.__proto__`属性来修改test1的值

```js
obj1.__proto__.test1 = 124;
```

此时访问obj.test1，发现也被修改成了124

obj，obj.test1也随之改变

![image-20230709065701743](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20230709065701743.png)

查看a的属性

![image-20230709065737398](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20230709065737398.png)

通过obj1中`.__proto__`属性添加一个新属性，和上面修改a类的原型的过程也是一样的

添加新属性test2

```js
obj1.__proto__.test2 = 111;
```

![image-20230709065815620](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20230709065815620.png)

可以发现obj中也出现了新属性test2, 并且a类中也出现了新属性test2

![image-20230709065827794](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20230709065827794.png)

### 进一步利用

先实例化一个字典对象，叫obj，内有key名为test，test的value是123

```js
var obj = {"test": 123};
```

然后通过obj的`.__proto__`属性为test重新赋值

```js
obj.__proto__.test = 2;
```

再实例化一个空字典对象，叫ooo

```js
var ooo = {};
```

查看ooo的test属性，为2

![image-20230709070125145](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20230709070125145.png)

因为Object类的test属性已经被污染，而对象ooo和obj同属Object类

再看obj的test属性的值，为123

![image-20230709070144611](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20230709070144611.png)

### 查找顺序

> 所有类对象在实例化的时候将会拥有prototype中的属性和方法，这个特性被用来实现JavaScript中的继承机制。
>
> 比如：
>
> ```js
> function Father() {
>  this.first_name = 'Donald'
>  this.last_name = 'Trump'
> }
> 
> function Son() {
>  this.first_name = 'Melania'
> }
> 
> Son.prototype = new Father()
> 
> let son = new Son()
> console.log(`Name: ${son.first_name} ${son.last_name}`)
> ```
>
> Son类继承了Father类的last_name属性，最后输出的是Name: Melania Trump。
>
> 总结一下，对于对象son，在调用son.last_name的时候，实际上JavaScript引擎会进行如下操作：
>
> - 在对象son中寻找last_name
>
> - 如果找不到，则在son.__proto__中寻找last_name
>
> - 如果仍然找不到，则继续在son.__proto__.__proto__中寻找last_name
>
> - 依次寻找，直到找到null结束。比如，Object.prototype的__proto__就是null
>   ![image-20230709070415443](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20230709070415443.png)
>
>   https://www.leavesongs.com/PENETRATION/javascript-prototype-pollution-attack.html

比如说此处的obj

利用.__proto__修改值后的test属性在当前对象的test属性下面（也就是在当前对象所绑定的prototype中），

所以优先读取当前对象下的test属性，即未被修改的值123

![image-20230709070456765](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20230709070456765.png)

而ooo对象由于当前属性中没有test属性，只能从它绑定的prototype中找test对象（或下一级的prototype），

没找到返回undefined

![image-20230709070505185](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20230709070505185.png)

## 【参考资料】

**PHITHON**《[深入理解 JavaScript Prototype 污染攻击](https://www.leavesongs.com/PENETRATION/javascript-prototype-pollution-attack.html)》

**depy**《[深入理解原型链污染漏洞]()》
