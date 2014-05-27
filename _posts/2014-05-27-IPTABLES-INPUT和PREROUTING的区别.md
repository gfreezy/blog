---
layout: post
title: IPTABLES INPUT和PREROUTING的区别
tagline: null
category: null
tags: []
published: true
---
之前一直以为 iptables 的 input 链是用来判断是否允许 ip 包进入（不管这个 ip 包的目标地址是不是本机）， prerouting 链是用来做 ip 包转发的。

我们之前的架构是网管机器 maize 通过 iptables 把 80 端口的 ip 包全部转发到内网 carrot 机器的 nginx 上面。有一阵爬虫特别多，我们就把他们在 nginx 里面直接对这些 爬虫的 ip deny了。但是经过 deny 了，这些爬虫的还是会进 nginx 的日志，影响到正常的监控。于是我们就想干脆直接在网关的 iptables 那边 drop 掉，这样 nginx 日志也能干净不少。说干就干

```bash
iptables -A INPUT -s xx.xx.xx.xx/24 -j DROP
```

并把 nginx 里面的 deny 配置给删掉了，我们本以为这样整个世界就清净了。但是流量监控显示，爬虫的流量不但没有下降，反而反弹到之前的量了。直接查看 nginx 的日志，发现这些本应该被屏蔽的 ip ，竟然都在正常爬取内容。小伙伴们都惊呆了。

为什么在 input 链里面 drop 了，还是没有生效。整个世界都不好了。用 iptables + input + drop + not work 等类似的关键字 Google 了好半天也没找出啥有用的信息，只是觉的这个应该跟 iptables 的转发应该有关系。抱着试一试的想法，在 nginx 所在的机器上面运行了这句 drop 的命令，结果生效了，爬虫被成功的屏蔽了。

这个奇怪的问题在一段时间内都没有弄明白，直到有天突然在 [LeeKwen的博客](http://blog.163.com/leekwen@126/blog/static/33166229200981954962/) 上发现了这张图。

![image](/assets/post-images/null-07a8528e-6bd7-43f8-b3a4-291ef2cdfdef.jpg)

我突然觉得上帝对我敞开了大门，豁然开朗。之前的问题也都迎刃而解。

PREROUTING 是机器接受到的每个 ip 包最先被处理的地方，目标端口的转换，目标地址的转换都在这个链做处理。从这往后就开始有 2 条岔路。如果 ip 包的目标地址是本机，那么它会进入到 INPUT 链，根据 INPUT 链的规则，来决定值丢弃还是处理；如果 ip 包的目标地址不是本机，那么就会进入 FORWARD 链，根据 FORWARD 链的规则进行处理，如果 ip 包没有被接受了，那么由本机进行转发（这里需要开启机器的 forward 才能转发，`echo 1 > /proc/sys/net/ipv4/ip_forward `）。

之前的问题是网关 maize 80 端口包在 PREROUTING 链目标 ip 被改成了 carrot 的 ip，所以这个包根本就不会进入到 maize 的 INPUT 链，也就更谈不上被 drop 掉。
如果想要在 maize 上面，实现这一个目的。应该在 FORWARD 链上面加 drop 命令。

```bash
iptables -A FORWARD -s xx.xx.xx.xx/24 -j DROP
```


