# mailx通过外部SMTP发邮件


mailx配置outlook SMTP方式发送邮件 

<!--more-->

首先我们在outlook中查看SMTP信息

![image-20231203152856526](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20231203152856526.png)

![image-20231203152922986](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20231203152922986.png)

然后在/etc/mail.rc里加入账号等信息

![image-20231203153213986](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20231203153213986.png)

在文件最后添加信息：

![image-20231206200801321](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20231206200801321.png)

登录密码这里，为避免直接输入账户密码，可以在Microsoft安全设置中开启双重验证并添加一个应用密码

**创建存放证书的目录**

```
mkdir -p /etc/pki/nssdb/
```

**测试mail命令**

```
echo "testcontent" | mailx -v -s "testtitle" scofield_1920@outlook.com
```

> testcontent 要发送的邮件内容，多行内容要写""里。
>
> testtitle 发送邮件的标题。
>
> scofield_1920@outlook.com 是对方接收邮件的账号。
>
> -s	给邮件追加主题 
> -a	发送邮件附件，多个附件使用多次-a选项即可 
> -b	指定密件抄送的收信人地址 
> -c	指定抄送的收信人地址
> -v    显示详细信息，一般是调试连通性的时候使用

在set smtp一栏一定要在域名后添加端口号，不然会出现以下情况：

![image-20231206111358938](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20231206111358938.png)

![image-20231206104830806](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20231206104830806.png)

正常状态：

![image-20231206201248678](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20231206201248678.png)

在目标邮箱收到了测试邮件：

![image-20231206201333313](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20231206201333313.png)


