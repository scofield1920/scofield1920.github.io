# 星盟免杀基础


星盟面纱基础

<!--more-->

## 测试环境搭建

360对大于50mb压缩包不查杀（软件性能受限）

但解压时会进行扫描



本地多引擎检测：虚拟机不同快照环境检测

火绒（静态），360（动态），360天擎，卡巴斯基

绕360查杀需要过本地

## 杀软查杀技术

### 检测方式

#### 1.静态分析

通过对文件特征、内存进行扫描，可以检测恶意软件的静态特征。

文件静态特征、内存静态特征查杀技术

- 特征码：杀软通过查找恶意软件特有的二进制模式来识别

​		VirTest 5.0

- 熵值检测：高熵值可能表明文件经过了加密或压缩

​		pestudio，熵值大于7，高度混淆

-  文件信誉度：如360晶核对白文件的信誉度评估

- 导出表IAT隐藏：修改导入地址表（IAT）以隐藏函数调用

​		StudyPE+ （x64）1.11 build112

- 加壳脱壳：增加额外层防止直接读取原始代码（VMP加壳）

####  2.动态分析

通过hook技术可以实现对任意程序的监控，监控关键API调用等。

主动防御、沙箱等查杀技术。

- 沙箱：模拟运行环境以观察程序的行为。

  识别沙箱：检测本地环境是否安装微信等社交软件

- 启发式扫描：杀软如果发现可以输入的参数会进行随机参数输入测试

- 云查杀：使用云端数据库来检测未知威胁。

- 进程调用链：监控进程之间的交互以发现异常行为。

- API Hook技术：监控API调用来检测潜在的恶意活动。

  (unhook/syscall/VEH)

#### 3.行为分析

沙箱里可以监视木马程序的行为。

- 杀软排除项：某些安全软件允许用户定义例外规则。(编译目录、白名单)
- 关闭杀毒软件：检测是否有试图关闭或禁用安全软件的动作。(w3C服务、BYOVD技术)
- 释放文件：进行文件读写。
- 网路连接：存在网络请求。
- 修改注册表：检测对系统注册表的非正常修改。
- 线程远程注入：监控是否有向其他进程注入代码的行为。
- 进程替换/内存隐藏：检查是否存在未授权的进程替换或内存区域隐藏。(PAGE GUARD)
- 堆栈欺骗：干扰堆栈跟踪，使得调试器难以跟随执行流程。
- 反分析：反虚拟机、反调试。
- 提权绕过：监控是否有尝试提升权限的行为。(烂土豆)

#### 4.其他分析

- 开发过程中避免安装某些安全软件：防止源代码泄露或受到不必要的监视。
- 某些安全软件采用机器学习引擎(如QVM)，利用一套智能算法学习海量的病毒文件以及正常文件，得出数据模型区分病毒和正常文件，不断适应新的病毒变化。

### 特征码查杀方式

大型APT组织的攻击样本对啊看那个动态扫描能力强，通过特征码有几率捕获APT事件样本。

#### 修改特征码

virusTest

#### 多态病毒

使用通常的特征码扫描无法检测的病毒。

避免被检测的方法：

- 使用不固定的密钥或随机数加密病毒代码
- 在病毒运行过程中改变病毒代码

## AI介入安全

Qvm对抗

加入一些白文件特征进行伪造
