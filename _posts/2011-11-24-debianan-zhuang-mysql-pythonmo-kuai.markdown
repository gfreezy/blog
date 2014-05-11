---
layout: post
title: debian安装mysql-python模块
tags: 技术 debian mysql python
---
直接 `pip install mysql-python` 提示 mysql-config 未找到，google了下，发现要先安装`libmysql++-dev`。

    apt-get install limysql++-dev
    pip install mysql-python

安装完成，可以在python中用mysql了。
