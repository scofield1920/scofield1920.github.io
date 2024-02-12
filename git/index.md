# Git


一小时Git基础速成

<!--more-->

## 0x1版本控制

在开发过长中用于管理我们对文件、目录或工程能内容的修改历史，方便查看更改历史记录，备份以便恢复以前的版本的软件工程技术。

- 实现跨区域多人协同开发
- 追踪和记载一个或多个



Git SVN CVS.....

## 0x2版本控制分类

**1.本地版本控制 RCS**

记录文件每次的更新，对每个版本做一个快照，适合个人使用，如RCS

![image-20231114092631020](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20231114092631020.png)

**2.集中式版本控制 SVN**

所有的版本数据都放在服务器上，协同开发者从服务器上同步更新或上传自己的修改

![image-20231114092700597](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20231114092700597.png)

**3.分布式版本控制 Git**

所有的版本信息都同步到本地的每个用户，本地可以查看所有版本历史，可以离线在本地提交，只需在联网时push到相应的服务器或其他用户。

![image-20231114092614197](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20231114092614197.png)

## 0x3 Git启动

Git Bash：Unix与Linux风格的命令行，使用最多，最推荐

Git CMD：Windows风格命令行

Git GUI：图形界面的Git，不是很建议

## 0x4 Git配置

查看配置

```
git config -l
```

查看当前用户（global）配置

```
git config --global --list
//用户名和密码是必须配置的
```

查看系统配置

```
git config --system --list
```

Git相关的配置文件

(1)`Git\etc\gitconfig`				Git安装目录下的gitconfig

(2)`c:\User\Administrator\.gitconfig`	只适用于当前登录用户的配置



**设置用户名**

```
git config --global user.name "scofield"
```

**配置邮箱**

```
git config --global user.email "xxx@xxx.com"
```

## 0x5 Git基础理论

### 工作区域

Git本地有三个工作区域，工作目录(Working Directory)、暂存区(Stage/Index)、资源库(Repository或Git Directory)。如果再加上远程的git仓库(Remote Directory)就可以分为四个工作区域。文件在这四个区域之间的转换关系如下：

![image-20231114105500190](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20231114105500190.png)

working：工作区，平时存放代码的地方

Index/Stage：暂存区，用于临时存放改动

Repository：仓库去（或本地仓库），安全存放数据的位置，这里有提交到所有版本的数据，其中HEAD指向最新放入仓库的版本

Remote：远程仓库，托管代码的服务器

![image-20231114115004249](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20231114115004249.png)

- Directory：使用Git管理的一个目录，也就是一个仓库，包含我们的工作空间和Git的管理空间
- WorkSpace：需要通过Git进行版本控制的目录和文件，这些目录和文件组成了工作空间
- .git：存放Git管理信息的目录，初始化仓库的时候自动创建
- Index/Stage：暂存区，或者叫做待提交更新区，在提交进入repo之前，我们可以把所有的更新放在暂存区
- Local Repo：本地仓库，一个存放在本地的版本库；HEAD只是当前的开发分支（branch）
- Stash：隐藏，是一个工作状态的保存栈，用于保存/回复WorkSpace中的临时状态

### 工作原理

1.在工作目录中添加，修改文件

2.将需要进行版本管理的文件放入暂存区域

3.将暂存区域的文件提交到git仓库

因此，git管理的文件有三种状态：已修改（modified），已暂存（staged），已提交（committed）

## 0x6 Git项目搭建

**创建工作目录与常用指令**

工作目录（WorkSpace），建议不要有中文

![image-20231114135545952](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20231114135545952.png)

**本地仓库搭建**

一种是创建全新仓库，另一种是克隆远程仓库 

创建全新的仓库，需要使用Git管理的项目的根目录执行

```
git init
//在当前目录新建一个Git代码库
```

**克隆远程仓库**

将远程服务器上的仓库完全镜像一份至本地

```
git clone [url]
//克隆一个项目和它的整个代码历史(版本信息)
```

## 0x7 Git文件操作

文件的四种状态：

- Untracked：未跟踪，此文件在文件夹中，但没有加入到git库，不参与版本控制，通过`git add`，状态变为`Staged`
- Unmodify：文件已入库，未修改，即版本库中的文件快照内容与文件夹中完全一致，这种类型的文件有两种去处，如果他被修改，而变为`modified`，如果使用`git rm`移出版本库，则成为`untracked`文件
- Modified：文件已修改，没有进行其他操作，通过`git add`可进入暂存`staged`状态，使用`git checkout`则丢弃修改过的，返回`unmodify`的状态，即从库中取出文件，覆盖当前修改
- Staged：暂存状态，执行`git commit`则将修改同步到库中，这时库中的文件和本地文件又变为一致，文件为`Unmodify`状态，执行`git reset HEAD filename`取消暂存，文件状态为`Modified`

### 查看文件状态

```
#查看指定文件状态
git status [filename]

#查看所有文件状态
git status

#git add .		添加所有文件到暂存区
#git commit -m	"消息内容" 提交暂存区中的文件内容到本地仓库 -m 提交信息 
```

### 忽略文件

有时候我们不想把某些文件纳入版本控制中，比如数据库文件，临时文件等

在主目录下建立".gitignore"文件，此文件有如下规则：

- 忽略文件中的空行或以井号（#）开始的行
- 可以使用Linux通配符
- 如果名称最前面有一个感叹号（!），表示例外规则，将不被忽略
- 如果名称的最前面是一个路径分隔符（/），表示要忽略的文件在此目录下，而子目录中的文件不忽略
- 如果名称最后面是一个路径分隔符（/），表示要忽略的是此目录下该名称的子目录，而非文件

```
#为注释
!lib.txt	#lib.txt文件除外
/temp		#进忽略项目根目录下的文件，不包括其他目录temp
build/		#忽略build/目录下的所有文件
```

### 注册github

略

### 设置本机绑定ssh公钥

实现免密登录

```
#进入C:\User\Administrator\.ssh 目录
#生成公钥
ssh-keygen
```

随后将公钥信息public key添加到github即可

## 0x8 Git分支

![image-20231114181640361](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20231114181640361.png)

git分支中常用命令：

```
#列出所有本地分支
git branch

#列出所有远程分支
git branch -r 

#新建一个分支，但依然停留在当前分支
git branch [branch_name]

#新建一个分支，并切换到该分支
git checkout -b [branch]

#合并指定分支到当前分支
git merge [branch]

#删除分支
git branch -d [branch_name]

#删除远程分支
git push origin --delete [branch_name]
git branch -dr [remote/branch]
```

## 0x9 git挂代理

​	Git代理有两种设置方式，分别是全局代理和只对Github代理，建议只对github 代理。
　代理协议也有两种，分别是使用http代理和使用socks5代理，建议使用socks5代理。
注意下面代码的端口号需要根据你自己的代理端口设定，比如我的代理socks端口是6987.
全局设置（不推荐）

```
#使用http代理 
git config --global http.proxy http://127.0.0.1:58591
git config --global https.proxy https://127.0.0.1:58591
#使用socks5代理
git config --global http.proxy socks5://127.0.0.1:51837
git config --global https.proxy socks5://127.0.0.1:51837
```


只设置 Github 的代理

```
git config --global http.https://github.com.proxy socks5://127.0.0.1:6986
git config --global https.https://github.com.proxy socks5://127.0.0.1:6986
```


取消代理

```
git config --global --unset http.proxy 
git config --global --unset https.proxy
```

参考：
https://blog.csdn.net/qq_33406021/article/details/130199208

