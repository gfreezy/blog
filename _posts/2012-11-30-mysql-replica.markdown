---
layout: post
title: MySQL replica
tags: mysql database replica
---
昨天终于把拖了很久的MySQL replica给做了。一共有两台服务器，一台是MySQL master，hostname是fig，还有一台是即将作为slave的，hostname为pistachio。两台机器装有相同版本的MySQL。

##基本步骤


1. 开启master fig的 *binary log* ，修改 *my.cnf* ，增加如下的配置

		[mysqld]
		log-bin=mysql-bin
		server-id=1

2. 在master上面为replica新建一个账号

		mysql> CREATE USER 'repl'@'%.mydomain.com' IDENTIFIED BY 'slavepass';
		mysql> GRANT REPLICATION SLAVE ON *.* TO 'repl'@'%.mydomain.com';

	<!--more-->

3. 获取master的 *binary log coordinates*

	* 登陆MySQL，读锁定数据库

			mysql> FLUSH TABLES WITH READ LOCK;

	* 另外开一个MySQL链接，获取master的状态

			mysql > SHOW MASTER STATUS;
			+------------------+----------+--------------+------------------+
			| File             | Position | Binlog_Do_DB | Binlog_Ignore_DB |
			+------------------+----------+--------------+------------------+
			| mysql-bin.000003 | 73       | test         | manual,mysql     |
			+------------------+----------+--------------+------------------+

		这里需要记录下这几个数据，如果跟我一样之前没有开启
		*binary log* ，则这里会显示为空。那File就做是''，Position
		为4。这两个数据会在后面用到。

4. 关闭master

		shell> mysqladmin shutdown

5. 将master的数据同步到slave上面，我这里使用的是rsync

		shell> rsync -avz --recursive /var/lib/mysql/ pistachio:/var/lib/mysql/

	这个过程视你MySQL数据库的大小而定，我这master有10G左右，花了10来分钟。这之间要保持master是关闭的状态。

6. 启动master服务器

		shell> /etc/init.d/mysql start

7. 配置slave的MySQL配置，将master的配置复制到slave上面，然后修改 *server-id* ，并配置slave不启动 *replication* ，而且数据只读

		[mysqld]
		server-id=2
		skip-slave-start
		read-only

8. 启动slave的MySQL，并根据之前在master获取的信息设置master信息

		mysql> CHANGE MASTER TO
	    ->     MASTER_HOST='fig',
	    ->     MASTER_USER='repl',
	    ->     MASTER_PASSWORD='slavepass',
	    ->     MASTER_LOG_FILE='',
	    ->     MASTER_LOG_POS=4;

	因为我之前master没有开启 *binary log* ，所以 *MASTER_LOG_FILE* 为 *''* ， *MASTER_LOG_POS* 为 *4*。

9. 开启slave的replica

		mysql> START SLAVE;

10. 回到之前设置 *READ LOCK* 的session，取消 *READ LOCK*

		mysql> UNLOCK TABLES;

11. 将slave配置文件里面的

		skip-slave-start

	删除，这样以后每次slave MySQL启动的时候就会自动同步master的数据。


##测试
1. 在master里面插入一条数据

		mysql> insert into test value(1, 2);

2. 到slave里面查询

		mysql> select * from test;

	如果有上面那条数据，则说明replica已经设置成功了。

##其他问题
因为我们的机器设置

	[mysqld]
	transaction-isolation  = READ-COMMITTED

而 *binary log* 默认的格式为 *statement* 。我们的MySQL版本5.1.61不支持，Google后发现修改 *binary log*的format即可，再master和slave上面都增加下面的配置，并重启

	[mysqld]
	binlog-format = 'ROW'

##参考链接
[http://dev.mysql.com/doc/refman/5.0/en/replication-howto.html](http://dev.mysql.com/doc/refman/5.0/en/replication-howto.html)
