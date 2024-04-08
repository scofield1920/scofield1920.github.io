# 《拼谷助手》抢谷子脚本


`拼谷助手`这个QQ小程序在电脑端访问会参数错误，只能用手机端进行访问，需要用bp对手机流量进行抓包

<!--more-->

## 使用burpsuite抓取手机app流量

**前提条件**：

- 电脑和手机连接同一个WIFI，即同一个局网下
- 电脑装有burpsuit软件
- 安卓手机（也可以使用安卓模拟器）

### PC端配置

电脑开一下热点，用手机连上

![image-20240323233429344](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20240323233429344.png?imageSlim)

然后在终端输入`ipconfig`记录一下热点局域网网卡ip

![image-20240323233601392](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20240323233601392.png?imageSlim)

然后在burpsuite中添加代理设置

![image-20240323233744645](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20240323233744645.png?imageSlim)

随后勾选代理，同时把本地的127.0.0.1代理取消即可，然后导出CA证书

![image-20240323233958743](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20240323233958743.png?imageSlim)

导出证书后，把证书文件`CA.crt`传到手机里，在手机里安装bp的证书

### 手机端配置

手机【设置】--【更多设置】--【安全】--【从手机U盘和SD卡安装】

或者直接在设置中搜索证书，选择`安装证书`

![qq_pic_merged_1711208477888](C:\Users\scofi\Downloads/qq_pic_merged_1711208477888.jpg)

然后用手机连接电脑的热点信号，并在代理设置`手动`，添加在电脑端查到的热点网卡地址，端口跟起初在bp中绑定的端口相同，这里为8081

![Screenshot_2024-03-23-23-45-11-302_com.android.se](C:\Users\scofi\Downloads/Screenshot_2024-03-23-23-45-11-302_com.android.se.jpg)

### PC端burpsuite抓包

随后在burpsuite就可以看到手机的流量

![image-20240323234733093](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20240323234733093.png?imageSlim)

在代理模块可以抓包拦截

![image-20240323234937777](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20240323234937777.png?imageSlim)

## 开始抢谷子

开启拦截，在手机端打开拼谷助手

（将无关的数据包通通放行即可，直到我们要抓取的流量包）

![image-20240323235118023](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20240323235118023.png?imageSlim)

### 抓取get_goods_info

到主页面，点击我们将要抢的谷子

![image-20240323235349814](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20240323235349814.png?imageSlim)

一路放行，直到出现这个流量包，鼠标右键-->拦截-->该请求的响应

![image-20240323235739317](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20240323235739317.png?imageSlim)

然后一路放行，直到出现对应请求包的响应包，如下

![image-20240324000223788](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20240324000223788.png?imageSlim)

我们需要从上述相应包中提取关键参数，修改到下单post包

### 关于另外三个字段的信息

```
ownerUserId，ownerUserId_和createUserId_
```

`ownerUserId`和`ownerUserId_`除了下单的post包之外是抓不到的，而且`ownerUserId_`和`createUserId_`值是相同的。由于在同一个拼谷团中，发布谷子的团长不变，所以在同一个团中，每个谷子下单post包中，这三个键的值是固定不变的，经过测试，需要在同一个团中下单一次谷子（无论强没抢到，只要抓到下单post包即可），拿到下单post包中的这三个键的信息，就可以在这个团中一直抢谷子。

### 修改下单post包

测试的时候抓到的下单post包，可以直接用：

```http
POST /web?env=pro-2gis2vsrb5a3b312 HTTP/2
Host: tcb-api.tencentcloudapi.com
Referer: https://appservice.qq.com/1112117769/1.25.1/page-frame.html
User-Agent: Mozilla%2F5.0+%28Linux%3B+Android+13%3B+22041216C+Build%2FTP1A.220624.014%3B+wv%29+AppleWebKit%2F537.36+%28KHTML%2C+like+Gecko%29+Version%2F4.0+Chrome%2F122.0.6261.119+Mobile+Safari%2F537.36 QQ/9.0.15.14970 V1_AND_SQ_9.0.15_5626_YYB_D QQ/MiniApp
Content-Type: application/json;charset=UTF-8
X-Sdk-Version: tcb-qq-sdk/1.0.3
Content-Length: 836
Accept-Encoding: gzip, deflate, br

{"action":"functions.invokeFunction","loginType":"QQ-MINI","ticket":"eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJkYXRhIjoie1wiZW52SWRcIjpcInByby0yZ2lzMnZzcmI1YTNiMzEyXCIsXCJxcUFwcElkXCI6XCIxMTEyMTE3NzY5XCIsXCJvcGVuSWRcIjpcIjkxRDdBMDM3OTUzNTQxQ0RGOUI5QTMzOTZBOUQ4RTQ5XCIsXCJ1dWlkXCI6XCI0NDU0ZWI4ZTYxMjE0YmIyODliMTlmMDA2M2RiYTZlYVwifSIsImlhdCI6MTcxMTIwODk5OSwiZXhwIjoxNzExMjE2MTk5fQ.QphmoffNQbsMWZbpOqNIwXXAtNGpC0aBHmEu7Bp5vaE","env":"pro-2gis2vsrb5a3b312","dataVersion":"2019-08-16","function_name":"addOrder","request_data":"{\"createUserId_\":\"79069e4330504574a5b9a3126ca23cc9\",\"groupId\":\"T332000312\",\"goodsId\":\"G3320003121711206852431WTEXN\",\"ownerUserId\":\"7859292733\",\"ownerUserId_\":\"79069e4330504574a5b9a3126ca23cc9\",\"source\":\"own\",\"orderList\":[{\"itemId\":\"30a628b6235c46e9a8b7e15fd42fdbb0\",\"orderNum\":1}]}"}
```

对照刚抓到的谷子的get_group_info响应包和get_goods_info相应包，需要修改下单post包请求体中以下参数

```js
{
\"createUserId_\":\"79069e4330504574a5b9a3126ca23cc9\",
\"groupId\":\"T332000312\",
\"goodsId\":\"G3320003121711206852431WTEXN\",
\"ownerUserId\":\"7859292733\",
\"ownerUserId_\":\"79069e4330504574a5b9a3126ca23cc9\",
\"source\":\"own\",
\"orderList\":[{\"itemId\":\"30a628b6235c46e9a8b7e15fd42fdbb0\",
\"orderNum\":1}]}"
}
```

（`ownerUserId`和`ownerUserId_`在`get_group_info`响应包，其他的都在`get_goods_info`响应包）

### intruder发包测试

请求体改好之后放入intruder模块进行测试

![image-20240324002640417](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20240324002640417.png?imageSlim)

清除payload，并在payload选项中，payload类型选择null，无限重复

![image-20240324002605729](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20240324002605729.png?imageSlim)

改好之后点击右上角`开始攻击`，进行测试

在intruder模块中点击`响应`，在回显体中如果有`拼谷未开始`字符，则说明测试成功，可以抢谷

![image-20240324010156596](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20240324010156596.png?imageSlim)

## 正式开抢

测试成功之后，等到要抢的谷子即将开始之前，点击`开始攻击`，就可以抢谷，为防止发包量过多，可以等到谷子开放开始三秒左右就点暂停

## 总结

`开始抢谷子`流程总结一下就是：①放行无关流量包②抓到必要参数③intruder发包

因为每个谷子的itemid等参数不同，所以每次抢新谷子都要走一遍`开始抢谷子`环节来修改下单post包的请求体

将信息改入以下python脚本，当抢到谷子，脚本自动停止执行

`XXX`位置需要手动填入数据

```python
import sys
import json
import requests
import re

while True:

        data = {'action': 'functions.invokeFunction',
                'loginType': 'QQ-MINI',
                'ticket': 'XXX',
                'env': 'pro-2gis2vsrb5a3b312',
                'dataVersion': '2019-08-16',
                'function_name': 'addOrder',
                'request_data': "{\"createUserId_\":\"XXX\",\"groupId\":\"XXX\",\"goodsId\":\"XXX\",\"ownerUserId\":\"XXX\",\"ownerUserId_\":\"XXX\",\"source\":\"own\",\"orderList\":[{\"itemId\":\"XXX\",\"orderNum\":1}]}"
                }

        headers = {
            'Referer': 'https://appservice.qq.com/1112117769/1.25.1/page-frame.html',
            'User-Agent': 'Mozilla%2F5.0+%28Linux%3B+Android+13%3B+22041216C+Build%2FTP1A.220624.014%3B+wv%29+AppleWebKit          %2F537.36+%28KHTML%2C+like+Gecko%29+Version%2F4.0+Chrome%2F122.0.6261.119+Mobile+Safari%2F537.36 QQ/            9.0.15.14970 V1_AND_SQ_9.0.15_5626_YYB_D QQ/MiniApp',
            'Content-Type': 'application/json;charset=UTF-8',
            'X-Sdk-Version': 'tcb-qq-sdk/1.0.3',
            'Content-Length': '836',
            'Accept-Encoding': 'gzip, deflate, br'
        }

        res = requests.post("https://tcb-api.tencentcloudapi.com/web?env=pro-2gis2vsrb5a3b312",
                            proxies={'http': "http://127.0.0.1:8080"}, data=json.dumps(data), headers=headers)
        data = res.json()
        json_data = json.loads(data['data']['response_data'])
        print(json_data)
        reg = str(json_data)
        if 'True' in reg:
            print('ok')
            sys.exit(0)
```


