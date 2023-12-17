# ctfhub_信息泄露wp


早期做CTFHub的入门题wp

<!--more-->

### 【目录遍历】

emm挨着找吧

#### 【PHPINFO】

ctrl+f，搜索flag

### 【备份文件下载】

#### （网站源码）

```
python dirsearch.py -u http://challenge-386c567a8c9e211f.sandbox.ctfhub.com:10800/ -e *
```

#### （ bak文件）

bak文件是备份文件，一般在原有的扩展名后添加.bak，提示说flag在index.php源码中，但我们直接在网址后添加php文件名查找时发现并未找到该文件

![image-20221226194934249](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20221226194934249.png)

![image-20221226195007886](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20221226195007886.png)

#### （vim缓存）

当正常关闭vim时，缓存文件会被删除，但当vim异常退出时，缓存文件是未被删除的，我们就可以通过恢复未被处理缓存文件来获取原始文件的内容。第一次非正常退出vim时会生成一个swp文件，第二次非正常退出会生成一个swp文件，第三次非正常退出会生成一个swp文件。因此我们可以通过访问.index.php.swp来得到缓存文件

![image-20221226195130368](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20221226195130368.png)

```
使用vim -r index.php.swp命令来恢复原文件
```

#### (.DS_Store)

直接在网址后添加.DS_Store得到文件

![image-20221226195311628](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20221226195311628.png)

使用cat DS_Store命令来查看文件，发现了一个txt文件

把这个文件复制下来添加到地址后得到flag

### 【Git泄露】

#### （log）

利用GitHacker工具

```
githacker --url http://xxxxx/.git/ --output-folder result
```

然后进入目录进行：

git log

![image-20221226201544074](C:\Users\Scofield_Lee\AppData\Roaming\Typora\typora-user-images\image-20221226201544074.png)

```
git diff 3e25d        或者      git diff HEAD^
```

![image-20221226201644100](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20221226201644100.png)

#### （stash）

- git 泄露 `.git/refs/stash`
- stash 用于保存 git 工作状态到 git 栈，在需要的时候再恢复。

先进行githacker，然后git stash list发现有stash

![image-20221226201823174](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20221226201823174.png)

执行git stash apply或者git stash pop

![image-20221226202016806](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20221226202016806.png)

#### （index）

直接githacker扒目录

### 【svn泄露】

<img src="https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20221227113732150.png" alt="image-20221227113732150" style="zoom:67%;" />

使用dvcs-ripper工具

```
./rip-svn.pl -u http://challenge-4c86874278e5cd1d.sandbox.ctfhub.com:10800/.svn
```

![image-20221227114024648](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20221227114024648.png)

然后进入工具目录下的.svn文件夹

```
cat wc.db
```

内容太多，利用搜索

```
cat wc.db | grep -a flag
```

```
┌──(root㉿kali)-[/home/kali/dvcs-ripper/.svn]
└─# cat wc.db |grep -a flag 
normaldir()infinity��å~%index.htmlindex.htmlnormalfile$sha1$bf45c36a4dfb73378247a6311eac4f80f48fcb92���Á�root���X۾63▒
�����4  flag_1690618925.txt     index.html
index.html18925.txt
```

发现疑似文件，执行

```
curl http://challenge-4c86874278e5cd1d.sandbox.ctfhub.com:10800/flag_1690618925.txt
```

```
curl http://challenge-4c86874278e5cd1d.sandbox.ctfhub.com:10800/index.html18925.txt
```

都返回404，根据index.html页面提示，flag在旧版本中，
在.svn中，cd pristine

![image-20221227115753287](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20221227115753287.png)

#####  SVN泄露漏洞

​        SVN 全称 Subversion ，是一个开放源代码的版本控制系统，Subversion 在 2000 年由 CollabNet Inc 开发，现在发展成为 Apache 软件基金会的一个项目，同样是一个丰富的开发者和用户社区的一部分。

**SVN泄露漏洞验证方式：intitle:"index of/.svn"**

```
wc.db文件：用SQLiteStudio软件打开 wc.db文件，可以看到 NODES 表，遍历这个表里的每一行，就可以下载到整个项目里的代码了，而且还能得到对应的真实文件名。
```

### 【HG泄露】

![image-20221227123013537](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20221227123013537.png)

使用 dvcs-ripper 工具下载泄露的网站目录

```
./rip-hg.pl -u http://challenge-137f105811083a40.sandbox.ctfhub.com:10800/.hg
```

使用工具过程中出现了一些错误，导致网站源代码没有完整下载。正如网页显示内容中的提示所说，不好使的情况下，试着手工解决。

![image-20221227123326821](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20221227123326821.png)

```
┌──(root㉿kali)-[/home/kali/dvcs-ripper]
└─# tree .hg               
.hg
├── 00changelog.i
├── dirstate
├── last-message.txt
├── requires
├── store
│   ├── 00changelog.i
│   ├── 00manifest.i
│   ├── data
│   ├── fncache
│   └── undo
├── undo.branch
├── undo.desc
└── undo.dirstate
```

通过正则搜索flag相关的文件

![image-20221227123513528](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20221227123513528.png)

然后执行curl

![image-20221227123609254](https://scofield-1313710994.cos.ap-beijing.myqcloud.com/image-20221227123609254.png)

##### HG泄露漏洞

​        Mercurial 是一种轻量级分布式版本控制系统，采用 Python 语言实现，易于学习和使用，扩展性强。其是基于 GNU General Public License (GPL) 授权的开源项目。

        在 Mercurial 轻量级分布式版本控制系统中，本地既可以当做版本库的服务端，也可以当做版本库的客户端。版本库与工作目录不同，版本库存放了所有版本，而工作目录只是因为特定需要存放特定版本。与 SVN 系统不同，SVN 的版本库集中在一台服务器中。这也导致很多初次使用 Mercurial 系统的工作者，因为操作失误导致出现 HG 泄露漏洞的主要原因。

##### 常规文件

robots.txt：记录一些目录和CMS版本信息
readme.md：记录CMS版本信息，有的甚至是GitHub地址
www.zip/rar/tar.gz：往往是网站的备份源码


