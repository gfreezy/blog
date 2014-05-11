---
layout: post
title: css和jquery里面的height属性
tags: 技术 css height
---
* 获取浏览器窗口的可见高度用 `document.body.clientHeight`
* 获取当前网页的高度用 `document.height`

** height %100是相对于父元素的高度来设置的。 **

jquery获取height属性的几个方法

* `$('').height()` 只获取元素的大小，不包括padding，border，margin
* `$('').innerHeight()` 包括padding
* `$('').outerHeight()` 包括padding和border
* `$('').outerHeight(true)` 包括padding，border，margin
