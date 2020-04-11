---
layout: post
title: win下设置emacs的默认编码
date: 2011-11-24
---
Emacs只能指定新建buffer的默认编码，和读取文件时候的编码寻找顺序。文件写入编码
Emacs会根据文件内容来猜测，并保持原有的编码不变。如想改变写入编码，需手动改变。

    (set-buffer-file-coding-system 'utf-8-unix)
    ;;指定当前buffer的写入编码，只对当前buffer有效，即此命令写在配置文件中无效，只能
    通过M-x来执行

    (setq default-buffer-file-coding-system 'utf-8-unix)
    ;;指定新建buffer的默认编码为utf-8-unix，换行符为unix的方式

    (prefer-coding-system 'utf-8)
    ;;将utf-8放到编码顺序表的最开始，即先从utf-8开始识别编码，此命令可以多次使用，后
    指定的编码先探测

    (set-language-environment 'utf-8)
    ;;指定Emacs的语言环境，按照特定语言环境设置前面的两个变量

Windows默认情况下，可以识别中文，也可以输入中文，但是新建文件的编码为
chinese-gbk-dos，为了改为utf-8，并且换行符为unix格式，在配置文件中加入下面这行。

    (setq default-buffer-file-coding-system 'utf-8-unix)

------------
附上手动修改编码的方法：

* M-x set-buffer-file-coding-system <RET> coding 保存后，文件即是coding编码
* C-x <RET> f coding 保存后，文件为coding编码
* C-x <RET> r coding 以coding编码重新读取文件
* C-x <RET> c coding <RET> 以coding编码执行接下去输入的命令，如
         C-x <RET> c utf-8 <RET> C-x C-f a.txt <RET> 用utf-8编码打开a.txt文件
