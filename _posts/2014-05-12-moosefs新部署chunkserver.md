---
layout: post
title: moosefs新部署chunkserver
tagline: null
category: null
tags: []
published: true
---
1. 在 `/etc/apt/source.lst` 里面加入

  deb     http://apt-repo:3143/ /
  
2. 运行一下命令来安装 moosefs 相关的包

  apt-get update
  apt-get install moosefs-chunkserver moosefs-client moosefs-master
  
3. 修改配置文件

  * chunkserver

      cd /etc/mfs
      cp mfschunkserver.cfg.dist mfschunkserver.cfg
    
    因为我在 DNS 里面配置了 `mfsmaster` 指向 master 的 ip ，所以我们
    不需要对 mfschunkserver 的配置进行修改。
    
      cd /etc/mfs
      cp  mfshdd.cfg.dist mfshdd.cfg
      vim mfshdd.cfg
      
    在 mfshdd.cfg 里面加入存放数据的目录。
      
4. 增加启动脚本

    wget https://gist.githubusercontent.com/gfreezy/f1dc2ee1620b2cbe970f/raw/65dce19ebd768571ce0f258916743ca4999e11fb/gistfile1.sh -O /etc/init.d/mfschunkserver
    chmod +x /etc/init.d/mfschunkserver
    update-rc.d mfschunkserver defaults
  
  {% gist gfreezy/f1dc2ee1620b2cbe970f %}
  
5. 启动 `mfschunkserver`



--------------------
在启动 mfschunkserver 的时候如果遇到权限问题，则把相应的目录的 owner 改为 `mfs`

  chown mfs:mfs /var/lib/mfs
  