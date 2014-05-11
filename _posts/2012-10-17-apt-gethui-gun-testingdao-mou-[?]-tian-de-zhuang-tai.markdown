---
title: apt-get回滚testing到某一天的状态
tags: debian apt-get
---
公司的服务器用的是Debian的testing版本，上面的MySQL是在3月份装的，是5.1的版本。因为最近要给MySQL加一个cluster，所以需要在新的虚拟机C上安装MySQL环境。

服务器某台A虚拟机安装了apt-cache-ng，所有其余的机器的apt源都指向这台机器。由于我的手欠，在A上面执行了

    apt-get update

导致testing库更新到了最新的代码。

然后，纠结的地方到了，apt-get安装到的MySQL是5.5版本。我能做的只有两个方法：

1. 把生产环境中5.1的MySQL升级
2. 想办法安装5.1版本的MySQL

<!--more-->
第一个方法风险太大，而且升级还要停机，代价过高，直接pass了。这样就只剩下第二个办法了。于是乎，Google+Stackoverflow，发现了apt-get是可以安装指定版本的软件的：

    apt-get install mysql-server=5.1

正高兴呢，发现apt-get报错说找不到5.1版本的MySQL,又撞墙上了。

接下来的问题就是想办法让apt-get能够找到低版本的MySQL。又祭出Google+Stackoverflow一阵乱搜，功夫不负有心人，终于找到了一个神网站：[http://snapshot.debian.org/](http://snapshot.debian.org/)。

它竟然把2005年到现在为止每一次debian的apt-get仓库镜像保存下来。也就是说，我可以在在这里找回A上面原本的apt包状态。按照说明，将source.lst改为：

    deb http://snapshot.debian.org/archive/debian/20120320/ testing main
    deb-src http://snapshot.debian.org/archive/debian/20120320/ testing main
    deb http://snapshot.debian.org/archive/debian-security/20120320/ testing/updates main
    deb-src http://snapshot.debian.org/archive/debian-security/20120320/ testing/updates main

20120320是我想恢复snapshot的时间点，testing是我的版本，接着执行：

    apt-get -o Acquire::Check-Valid-Until=false update
    apt-get install mysql-server

终于找回了5.1版本的MySQL了。
