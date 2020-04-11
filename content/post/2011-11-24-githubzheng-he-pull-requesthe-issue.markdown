---
layout: post
title: Github整合Pull Request和Issue
tags: 技术 github pr
date: 2011-11-24
---
我们把Github的Issue功能用来做计划，每次一个新功能完成，都会提交一个Pull Request。
提交一个Pull Request会自动新建一个Issue，但是原来已经存在一个Issue了，这样就有2
个相同内容的Issue。今天Google了下，发现只要的提交Pull Request的时候，在Commit信息
里面加入

    close, closes, closed, fixes, fixed

这些关键词，比如  "this commit fixes #116"，Github会自动关联Issue和Pull Request。
