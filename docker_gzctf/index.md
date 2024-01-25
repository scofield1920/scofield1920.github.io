# GZCTF搭建


环境：Ubuntu20.04

### docker安装

1.更新系统软件包列表：

```
sudo apt update
```

2.安装必要的依赖项：

```
sudo apt install apt-transport-https ca-certificates curl software-properties-common
```

3.添加 Docker GPG 密钥：

```
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
```

4.设置 Docker 存储库：
对于 x86_64（通常为 64 位）系统：

```
echo "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
```

对于 ARMhf（如 Raspberry Pi）或其他特定体系结构的系统，请根据官方文档中提供的指南选择正确的存储库。

5.更新软件包索引并安装 Docker CE（社区版）：

```
sudo apt update
sudo apt install docker-ce docker-ce-cli containerd.io
```

6.将当前用户添加到 `docker` 组（无需重启）：

```
sudo usermod -aG docker $USER
```

7.注销并重新登录以使用户组变更生效。

若出现下面的报错：

```sh
[xxxx@xxxx ~]$ docker ps
Got permission denied while trying to connect to the Docker daemon socket at unix:///var/run/docker.sock: Get "http://%2Fvar%2Frun%2Fdocker.sock/v1.24/containers/json": dial unix /var/run/docker.sock: connect: permission denied
```

问题出在用户为访问/var/run/docker.sock的权限，只需给用户增加权限即可。命令行输入：

```sh
sudo chown root:docker /var/run/docker.sock	# 修改docker.sock权限为root:docker
sudo groupadd docker          				# 添加docker用户组 
sudo gpasswd -a $USER docker  				# 将当前用户添加至docker用户组
newgrp docker                 				# 更新docker用户组
```

### GZCTF部署

新建一个文件夹gzctf，创建两个文件`appsettings.json`，`docker-compose.yml`

`appsettings.json`写入：

```json
{
  "AllowedHosts": "*",
  "ConnectionStrings": {
    "Database": "Host=db:5432;Database=gzctf;Username=postgres;Password=kunkk"
  },
  "EmailConfig": {
    "SendMailAddress": "a@a.com",
    "UserName": "",
    "Password": "",
    "Smtp": {
      "Host": "localhost",
      "Port": 587
    }
  },
  "XorKey": "xxxx",
  "ContainerProvider": {
    "Type": "Docker", // or "Kubernetes"
    "PortMappingType": "Default", // or "PlatformProxy"
    "EnableTrafficCapture": false,
    "PublicEntry": "ctf.example.com", // or "xxx.xxx.xxx.xxx"
    // optional
    "DockerConfig": {
      "SwarmMode": false,
      "Uri": "unix:///var/run/docker.sock"
    }
  },
  "RequestLogging": false,
  "DisableRateLimit": true,
  "RegistryConfig": {
    "UserName": "",
    "Password": "",
    "ServerAddress": ""
  },
  "CaptchaConfig": {
    "Provider": "None", // or "CloudflareTurnstile" or "GoogleRecaptcha"
    "SiteKey": "111",
    "SecretKey": "111",
    // optional
    "GoogleRecaptcha": {
      "VerifyAPIAddress": "https://www.recaptcha.net/recaptcha/api/siteverify",
      "RecaptchaThreshold": "0.5"
    }
  },
  "ForwardedOptions": {
    "ForwardedHeaders": 5,
    "ForwardLimit": 1,
    "TrustedNetworks": ["192.168.12.0/8"]
  }
}
```

`docker-compose.yml`写入：

```yml
version: "3.0"
services:
  gzctf:
    image: gztime/gzctf:latest
    restart: always
    environment:
      - "GZCTF_ADMIN_PASSWORD=MYpassword123"
    ports:
      - "80:80"
    volumes:
      - "./data/files:/app/files"
      - "./appsettings.json:/app/appsettings.json:ro"
      # - "./k8sconfig.yaml:/app/k8sconfig.yaml:ro" # this is required for k8s deployment
      - "/var/run/docker.sock:/var/run/docker.sock" # this is required for docker deployment
    depends_on:
      - db
 
  db:
    image: postgres:alpine
    restart: always
    environment:
      - "POSTGRES_PASSWORD=kunkk"
    volumes:
      - "./data/db:/var/lib/postgresql/data"
```

然后在gzctf文件夹中执行：

```
docker-compose up -d
```

随后`docker ps`查看容器ID：

```
sco@sco-virtual-machine:~/gzctf$ docker ps
CONTAINER ID   IMAGE                 COMMAND                  CREATED          STATUS                            PORTS                               NAMES
ce2011ceac5a   gztime/gzctf:latest   "dotnet GZCTF.dll"       13 minutes ago   Up 4 seconds (health: starting)   0.0.0.0:80->80/tcp, :::80->80/tcp   gzctf-gzctf-1
7a335b65fdd2   postgres:alpine       "docker-entrypoint.s…"   13 minutes ago   Up 3 seconds                      5432/tcp                            gzctf-db-1
```

使用`docker logs 7a335b65fdd2`查看数据库日志

随后访问`https://127.0.0.1:80`

![image-20240124140527104](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20240124140527104.png)

相关题目补充后面再写......

### 注意事项

第一次启动之后docker中postgresql的密码不能再做修改，改成其他密码会认证失败
平台初始管理员账号Admin密码要稍微复杂点

### 附录

postgresql相关命令：

```sh
docker compose exec db psql -U postgres

psql -U postgres -W

psql (15.2)
Type "help" for help.
 
postgres=# \c gzctf
You are now connected to database "gzctf" as user "postgres".
gzctf=# #do your sql query
```

进入docker容器：

```sh
docker exec -it gzctf-db-1 bash
```

参考笔记：

gzctf：

https://docs.ctf.gzti.me/quick-start

https://blog.csdn.net/qq_41738909/article/details/133660399

https://blog.csdn.net/a142151/article/details/130944500

https://wdh.hk/tech/ctf/%E6%96%B0%E7%9F%A5/GZCTF%E9%83%A8%E7%BD%B2%E7%AC%94%E8%AE%B0.html

ctfd:

https://blog.csdn.net/Myon5/article/details/134540207

