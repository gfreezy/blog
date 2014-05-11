---
layout: post
title: Python urllib2的timeout的问题
---
** 参考[How Python’s urllib2 Bit Me](http://www.somethinkodd.com/oddthinking/2010/05/01/how-pythons-urllib-bit-me/) **

python的 `urllib2` 包默认并不设置 **timeout** 的时间，它把这个问题向下传递到 `httplib` 包，而 `httplib` 包自己也不处理这个问题， 它也向下传递，到了 `socket` 库。由于 `socket` 是非常通用的一个库，从进程调用到抓取网页都会用到，所以它不知道该给 **timeout** 设置成什么，于是干脆设置了 **forever**。然后，就导致了在抓取网页的时候整个程序hang住。

解决的方法也很简单，在`urllib2.open`的时候加上timeout参数就ok了。

    headers = {}
    url = '...'
    request = urllib2.Request(url, None, headers)
    response = urllib2.urlopen(request, timeout=60)
