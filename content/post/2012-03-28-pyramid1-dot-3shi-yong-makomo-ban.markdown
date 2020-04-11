---
layout: post
title: pyramid1.3使用mako模板
date: 2012-03-28
comments: true
tags: 技术 pyramid mako
---
Pyramid的pt模板文件可以使用相对路径来查找，如下

    @view_config(route_name='home', renderer=templates/mytemplate.pt')

但是Pyramid的Mako模板不支持用相对路径，你必须使用绝对路径

    @view_config(route_name='home', renderer='translatform:templates/mytemplate.mako')

或者，可以在 `productioin.ini` 文件里面加入
`mako.directory=translatform:/` ，这样就可以用相对路径来定位mako模板了。
