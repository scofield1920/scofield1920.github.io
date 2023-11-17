# web流量审计与日志分析


web流量审计与日志分析基础

<!--more-->

## web日志分析基础：

这里以Apache日志分析为例：
Apache日志大致分为两类：**访问日志**和**错误日志**

![image-20230613155143502](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20230613155143502.png)

### 访问日志记录的过程：

- 客户端向[web服务](https://so.csdn.net/so/search?q=web服务&spm=1001.2101.3001.7020)器发送请求，请求中包含客户端的IP、浏览器类型(User-Agent)、请示的URL等信息

- web服务器向客户端返回请示的页面
- web服务器同时将访问信息和状态信息记录到日志文件中

Apache的访问日志目录在其配置文件中已经定义好了，CentOS中apache的配置文件位置为`/etc/httpd/conf/httpd.conf`,默认的访问日志存放在`/var/log/httpd/access_log`中

我的站点面是用宝塔创建的，具体站点Apache日志在上面的图片中可见

### 访问日志格式分析:

apache中访问日志功能由mod_log_config模块提供，以默认的[CLF](https://so.csdn.net/so/search?q=CLF&spm=1001.2101.3001.7020)来记录访问日志，如LogFormat "%h%l%u%t %r"

付一张图片，来自我的公网服务器网站Apache流量

![1111](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/1111.png)


![image-20230613160547670](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20230613160547670.png)

### Web日志统计:

#### 查看访问IP

```bash
cat access_log | awk '{print $1}'
```

**awk '{print $1}'** - 每行按空格或TAB分割，输出文本中的第1项，因为在access_log中的IP是第一项，所以这里用$1表示

#### 打印每一重复行出现的次数

```bash
cat access_log | awk '{print $1}' | sort | uniq -c
```

**uniq**用于检查及删除文本中重复出现的行列，一般与sort结合使用

-c - 在每列旁边显示该行重复出现的次数

排序并统计行数

```
cat access_log | awk '{print $1}' | sort | uniq -c | sort -rn | wc -l
```

sort 用于对文本文件内容进行排序，默认以ASCII码的次序排列

-r 以相反的顺序来排序

-n 依照数值的大小排序

wc用于打印文件的文本行数、单词数、字节数等

-l 打印指定文件的文本行数

#### 显示访问前10位的IP地址

```
cat access_log | awk '{print $1}' | sort | uniq -c | sort -rn | heade -10
```

##### 显示指定时间以后的日志

```
cat access_log | awk '$4>="[10/Apr/2022:01:00:01]"' access_log
```

##### 找出访问量最大的IP，并封掉

```
cat access_log | awk '{print $1}' | sort | uniq -c | sort -rn | more

iptables -I INPUT -s 192.168.1.10 -j DROP

iptables -I INPUT -s 192.168.1.0/24 -j DROP
```

##### 找出下载最多的文件

```
cat access_log | awk '($7 ~/.exe/){print $10 "" $1 "" $4 "" $7}' | sort -n | uniq -c | sort -nr | head -10
```

或找出文件大于10MB的文件：

```
cat access_log | awk '($10 > 10000000 && $7 ~/.exe){print $7}' | sort -n | uniq -c | sort -nr | head -10
```

##### 简单统计流量

```
cat access_log | awk '{sum+=$10}'
```

##### 统计401访问拒绝的数量

```
cat access_log | awk '(/401/)' | wc -l
```

##### 查看某一时间内的IP连接情况

```
grep "2022:04" access_log | awk '{print $4}' | sort | uniq -c | sort -nr
```

### 错误日志分析:

默认的错误日志位置/var/log/httpd/error_log

错误日志记录了服务器运行期间遇到的各种故障，以及一些普通的诊断信息，如服务器启动/关闭的时间

日志文件记录信息级别的高低，控制日志文件记录信息的数量和类型，这是通过LogLevel指令实现的，该指令默认设置的级别是error

级别越高，记录的信息越多，日志量越大
![image-20230613161026111](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20230613161026111.png)

最常见的错误日志文件有两类：

- 文档错误

  文档错误和服务器应答中的400系列代码对应，最常见的是404错误

- CGI错误

  CGI程序输出到STDERR(Standard Error,标准错误设备)的所有内容都将直接进入错误日志

---

日志截图中画出的部分是Mozi僵尸网络的攻击payload，具体请看：

https://blog.netlab.360.com/p2p-botnet-mozi/

https://cloud.tencent.com/developer/article/1708178

## 日志行为分析：

##### 检索包含关键词为“Hello World”的请求：

![image-20230615215420906](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20230615215420906.png)

##### 检索包含关键词为“/etc/passwd”的请求：

很明显是本地文件包含尝试

![image-20230615215559481](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20230615215559481.png)


