---
title: scrapy could not parse some html page correctly
tags: scrapy python
---
在用Scrapy爬取淘宝的搜索结果时，发现很多的页面通过*XPathSelector*转换后丢失了很多的数据，只留下了一小部分的页面。

起初是以为淘宝用了JS来动态加载搜索结果，用*Chrome Develop Tool*禁用了*JS*，发现还是没有丢失页面数据。也查了下，没有使用跳转。然后用`scrapy shell url`来测试这个URL，`hxs.extract()`的结果要比`response.body`中的内容少了一个数量级。

问题出在了*lxml*的处理上。淘宝的页面是使用GBK编码的，所以scrapy的encoding处理出了问题。Google之，终于在[stackoverflow](http://stackoverflow.com/questions/12084033/scrapy-couldnt-parse-some-html-file-correctly)上面找到了一篇文章。按照它上面说的加上encoding处理后，问题解决了。

看样子以后爬国内的页面可要长点心了，一个页面编码问题卡了我一整天。

附上处理encoding的代码：

```python
import charset

def parse(self, response):

		encoding = chardet.detect(response.body)['encoding']
		if encoding != 'utf-8':
				response.body = response.body.decode(encoding, 'replace').encode('utf-8')

		hxs = HtmlXPathSelector(response)
		data = hxs.select("//div[@id='param-more']").extract()
		#print encoding
		print data
```
