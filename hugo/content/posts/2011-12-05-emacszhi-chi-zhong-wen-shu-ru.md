---
layout: post
title: emacs支持中文输入
tags: 
- emacs
date: 2011-12-05
---
自己手动编译Emacs24，加入了gtk3的支持。因为我是`en_US.utf8` 的locale，
Emacs默认执行时是不支持ibus的中文输入。必须要 `LC_CTYPE=zh_CN.utf8 emacs`
这样指定locale为zh_CN才能支持中文输入。因为每次都要输入很麻烦，而且从
菜单启动的时候没办法指定。

所以找了个最简单的方法：
<!--more-->
* 把默认的**emacs**文件重命名为**emacs-origin**，`mv /usr/bin/emacs /usr/bin/emacs-origin`
* 新建一个**emacs**的脚本文件，并赋予可执行权限 `chmod +x /usr/bin/emacs`，文件内容如下：
{% highlight bash %}
#!/bin/sh
LC_CTYPE=zh_CN.utf8 /usr/bin/emacs-origin "$@"
{% endhighlight %}
为了不用每次更新Emacs，都要这么操作一遍。于是改了下aur里面的PKGBUILD。
把PKGBUILD，emacs.install，emacs-cn放在同一个文件夹下，然后
`makepkg -C`，就能生成Archlinux的package，安装即可。以后每次要更新
**Emacs**的时候，只要重新`makepkg -C`，再安装就可以了。

------------------
**emacs-cn** **PKGBUILD** **emacs.install**文件分别如下：
{% gist 1433317 %}
