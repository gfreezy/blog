---
layout: post
title: nginx location and proxy_pass
tags: nginx location proxy_pass
---
*Nginx*的*location*的格式为

	location [=|~|~*|^~] uri { … }

* `=`表示完全匹配*uri*
* `^~`表示以*uri*打头
* `~`表示正则匹配*uri*，且不区分大小写
* `~*`表示正则匹配*uri*，但是区分大小写

*Nginx*匹配*location*时，有一定的优先级，`=`优先级最高，其次`^~`，最后是`~`和`~*`。同一类型的匹配按照出现的先后顺序匹配。

下面是一个例子，来自[http://wiki.nginx.org/HttpCoreModule#location](http://wiki.nginx.org/HttpCoreModule#location)

	location  = / {
  		# matches the query / only.
  		[ configuration A ]
	}
	location  / {
  		# matches any query, since all queries begin with /, but regular
  		# expressions and any longer conventional blocks will be
  		# matched first.
  		[ configuration B ]
	}
	location ^~ /images/ {
		# matches any query beginning with /images/ and halts searching,
		# so regular expressions will not be checked.
		[ configuration C ]
	}
	location ~* \.(gif|jpg|jpeg)$ {
		# matches any request ending in gif, jpg, or jpeg. However, all
		# requests to the /images/ directory will be handled by
		# Configuration C.
		[ configuration D ]
	}

<!--more-->

不同请求的结果如下：

* / -> configuration A
* /documents/document.html -> configuration B
* /images/1.gif -> configuration C
* /documents/1.jpg -> configuration D

`=`和`^~`都算字符常量匹配，而`~`和`~*`算正则匹配。这个在下面的*proxy_pass*需要用到。

*proxy_pass*的格式为：

	location match {
		proxy_pass target
	}

*proxy_pass*的参数*target*由两部分组成，服务器地址和路径。如：

*  `http://baidu.com`的服务器地址*server*为`http://baidu.com`，*path*路径为空
*  `http://baidu.com/`的服务器地址*server*为`http://baidu.com`，路径*path*为`/`
*  `http://baidu.com/search`的服务器地址*server*为`http://baidu.com`，路径*path*为`/search`

*location*的参数*match*为需要匹配到路径，它将一个URL分成了两部分，一部分是需要匹配的*match*，还有是剩下的*left*。如

	location ~ /search {}

分别用不同的URL去匹配，得到的结果是

* `/search` *match*为`/search`，*left*为空
* `/search/` *match*为`/search`，*left*为`/`
* `/serach/picture` *match*为`/search`，*left*为`/picture`

当将这两个结合在一起跳转时，跳转的地址为：

* *match* 不为正则表达时：
	1. *path* 为空时：*server* + *match* + *left*
	2. *path* 不为空时：*server* + *path* + *left*
* *match* 为正则表达时，*proxy_pass*的参数必须只包含服务器地址，而不能有路径，地址为：*server* + *match* + *left*

下面是一个最普通的例子：

    location /a {
    	proxy_pass http://cc;
    }

    location /b {
    	proxy_pass http://cc/;
    }

    location /c/ {
    	proxy_pass http://cc;
    }

	location  /d/ {
  		proxy_pass   http://cc/;
  	}

分别用不同的URL去请求，跳转地址为：

* /a/e -> http://cc/a/e
* /b/e -> http://cc//e
* /c/e -> http://cc/c/e
* /d/e -> http://cc/e


