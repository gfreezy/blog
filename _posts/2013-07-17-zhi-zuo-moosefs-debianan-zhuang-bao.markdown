---
layout: post
title: 制作moosefs_debian安装包
tags: 技术 moosefs debian
---
Moosefs一共可以分为**master** **chunkserver** **client** 三个应用程序，需要分别制作3个debian安装包。

## 准备工作
1. 确保*fuse*已经安装
1. 安装*checkinstall*

		apt-get install checkinstall

1. 从[moosefs](www.moosefs.com)下载源代码*mfs-1.6.27.tar.gz*。
1. 创建用于编译的mfs帐号和用户组

		# groupadd mfs
		# useradd -g mfs mfs

1. 解压源代码，并切换目录

		# tar xvzf mfs-1.6.27.tar.gz
		# cd mfs-1.6.27

## 制作Master安装包
1. 配置

		# ./configure --prefix=/usr --sysconfdir=/etc --localstatedir=/var/lib --with-default-user=mfs --with-default-group=mfs --disable-mfschunkserver --disable-mfsmount

1. 编译,`-j4`是为了让*make*充分利用多核CPU

		# make -j4

1. 使用*checkinstall*自动生成debian安装包

		# checkinstall

<!--more-->
	这里会提示

		The package documentation directory ./doc-pak does not exist.
		Should I create a default set of package docs? [y]:**

	回答 **y**。
	然后，*checkinstall*会询问你生成的安装包的名字，版本号，描述等信息
	![checkinstall_ask](http://www.falkotimme.com/howtos/checkinstall/images/1.gif)

	我们用**moosefs-master**来做安装包的名字。填写完毕后，直接回车就开始制作debian安装包。如果没有异常发生，则会在当前目录下多一个*moosefs-master_1.6.27-1_amd64.deb*的文件，并且*makeinstall*已经自动帮我们安装好了。

## 制作chunckserver安装包
1. 重新解压*mfs-1.6.27.tar.gz*，并切换目录
1. 配置

		# ./configure --prefix=/usr --sysconfdir=/etc --localstatedir=/var/lib --with-default-user=mfs --with-default-group=mfs --disable-mfsmaster --disable-mfscgiserv --disable-mfsmount --disable-mfscgi

1. 编辑`doc/Makefile`，删除261行处*general_mans*等号后面的值，变成如下所示

		...
		253 target = x86_64-unknown-linux-gnu
		254 target_alias =
		255 target_cpu = x86_64
		256 target_os = linux-gnu
		257 target_vendor = unknown
		258 top_build_prefix = ../
		259 top_builddir = ..
		260 top_srcdir = ..
		261 general_mans =
		262 chunkserver_mans = mfschunkserver.8 mfschunkserver.cfg.5 mfshdd.cfg.5
		263 master_mans = mfsmaster.8 mfsmetarestore.8 mfsmaster.cfg.5 mfsexports.cfg.5     mfstopology.cfg.5 mfsmetalogger.8 mfscgiserv.8 mfsmetalogger.cfg.5
		264 mount_mans = \
		265     mfsmount.8 mfstools.1 \
		266     mfscheckfile.1 mfsdirinfo.1 mfsfileinfo.1 mfsfilerepair.1 \
		267     mfsgetgoal.1 mfsgettrashtime.1 mfsrgetgoal.1 mfsrgettrashtime.1 \
		268     mfsrsetgoal.1 mfsrsettrashtime.1 mfssetgoal.1 mfssettrashtime.1 \
		269     mfsgeteattr.1 mfsseteattr.1 mfsdeleattr.1 \
		270     mfsappendchunks.1 mfsmakesnapshot.1
		...

	这是因为有部分文档会被包含到多个安装包里面，导致文件冲突。所以我们将这些通用的文档只包含在*master*的安装包里面。

1. 编译

		# make -j4

1. 使用*checkinstall*自动生成debian安装包，这里步骤同创建*master*安装包

		# checkinstall

	我们用**moosefs-chunkserver**来做安装包的名字。填写完毕后，直接回车就开始制作debian安装包。如果没有异常发生，则会在当前目录下多一个*moosefs-chunkserver_1.6.27-1_amd64.deb*的文件，并且*makeinstall*已经自动帮我们安装好了。

## 创建client安装包
1. *client*安装包的制作方法除了配置的参数有改动，与*chunkserver*基本一样。重新解压*mfs-1.6.27.tar.gz*，并切换目录
1. 配置，这里我们加了*--enable-mfsmount*，来强制开启编译*client*

		# ./configure --prefix=/usr --sysconfdir=/etc --localstatedir=/var/lib --with-default-user=mfs --with-default-group=mfs --disable-mfsmaster --disable-mfschunkserver --disable-mfscgiserv --enable-mfsmount --disable-mfscgi

	如果你的机器上没有安装*fuse*，这里会报错。

1. 编辑`doc/Makefile`，删除261行处*general_mans*等号后面的值，变成如下所示

		...
		253 target = x86_64-unknown-linux-gnu
		254 target_alias =
		255 target_cpu = x86_64
		256 target_os = linux-gnu
		257 target_vendor = unknown
		258 top_build_prefix = ../
		259 top_builddir = ..
		260 top_srcdir = ..
		261 general_mans =
		262 chunkserver_mans = mfschunkserver.8 mfschunkserver.cfg.5 mfshdd.cfg.5
		263 master_mans = mfsmaster.8 mfsmetarestore.8 mfsmaster.cfg.5 mfsexports.cfg.5     mfstopology.cfg.5 mfsmetalogger.8 mfscgiserv.8 mfsmetalogger.cfg.5
		264 mount_mans = \
		265     mfsmount.8 mfstools.1 \
		266     mfscheckfile.1 mfsdirinfo.1 mfsfileinfo.1 mfsfilerepair.1 \
		267     mfsgetgoal.1 mfsgettrashtime.1 mfsrgetgoal.1 mfsrgettrashtime.1 \
		268     mfsrsetgoal.1 mfsrsettrashtime.1 mfssetgoal.1 mfssettrashtime.1 \
		269     mfsgeteattr.1 mfsseteattr.1 mfsdeleattr.1 \
		270     mfsappendchunks.1 mfsmakesnapshot.1
		...

	这里编译*chunkserver*。
1. 编译

		# make -j4

1. 使用*checkinstall*自动生成debian安装包，这里步骤同创建*master*安装包

		# checkinstall

	我们用**moosefs-client**来做安装包的名字。填写完毕后，直接回车就开始制作debian安装包。如果没有异常发生，则会在当前目录下多一个*moosefs-client_1.6.27-1_amd64.deb*的文件，并且*makeinstall*已经自动帮我们安装好了。
