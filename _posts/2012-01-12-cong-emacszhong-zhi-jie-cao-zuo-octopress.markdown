---
layout: post
title: 从Emacs中直接操作Octopress
tags: emacs
---
前段时间换上了Octopress，也把博客迁到了[Github](https://github.com)上，
但是发文章变的好麻烦，又要`rake new_post[title]`，又要打开编辑器编辑，
然后还要`rake generate && rake deploy`。而且我用zsh，和rvm还不兼容，
每次都要重新开个terminal，用bash来操作。

今天无意间看到了[rbenv](https://github.com/sstephenson/rbenv)，rvm的等
价物，也可以实现ruby的版本管理。看了下，支持zsh，立马装上。切换bash的
问题解决了。

然后开始琢磨Octopress和Emacs的集成的问题。我的想法是直接从Emacs里面新
建、上传、部署，然后Google后找到了
[这个](https://github.com/omo/trivials/blob/master/elisp/trivials.el)。
正好昨天看了会Elisp，今天用上了。仿照着它的代码，我自己写了一个更加完整的。

代码上传到了[Github: https://github.com/gfreezy/octopress-emacs](https://github.com/gfreezy/octopress-emacs)
