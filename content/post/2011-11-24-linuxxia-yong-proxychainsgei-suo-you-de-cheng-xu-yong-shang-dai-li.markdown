---
layout: post
title: Linux下用proxychains给所有的程序用上代理
tags: 技术 proxy linux
date: 2011-11-24
---
**Archlinux** 下，只需要`yaourt -S proxychains`就能安装完毕，然后编辑`/etc/proxychains.conf`，修改proxy的地址为`127.0.0.1`，端口为7070。

然后在本地开启ssh代理，`ssh -CfNg -D 127.0.0.1:7070 gfreezy@norida.me`。一切的准备工作就完成了。

以后所有需要通过ssh代理来访问网络的程序，只要在命令前面加`proxychains`就可以了。如访问twitter，只需`proxychains wget twitter.com`就能获得twitter的首页了。
