---
title: css中position属性和margin设置
tags: 技术 css position
---
position有static(默认),relative,fixed,absolute几个属性，他们作用分别如下：

* static是默认属性，元素位置根据元素在文档中的位置来定位
* relative属性下，可以用top，left，right，bottom来定位。这个定位的依据是文档中原来的位置，即相对于static属性下的位置来定位。它在文档中的位置保留不变，可以覆盖其他元素。
* fixed属性下，根据浏览器窗口来定位，通过top，left，right，bottom来定位
* absolute属性是相对于上一个设置absolute属性的元素来定位，也是top，right，left，bottom来定位

margin设置为负时，此元素即随后的所有元素都会发生位移，此偏移不是相对文档中的位置，而是文档中的位置之间发生变化。
使用margin时，如果没有设置position属性，marging会发生重叠，设置后不会发生重叠。
