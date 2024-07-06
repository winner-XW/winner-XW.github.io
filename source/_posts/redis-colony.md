---
title: Redis服务集群配置
date: 2021/08/06
tags: redis,集群
categories: Redis
description: 即远程字典服务，是一个开源的使用ANSI C语言编写、支持网络、可基于内存亦可持久化的日志型、Key-Value数据库，并提供多种语言的API。
keywords: redis,集群
cover: /img/md/redis.jpg
---

# Redis服务集群配置
>介绍安装环境与版本:  
用两台物理机模拟6个节点，一台机器3个节点，创建出3 master、3 salve 环境。  
redis 采用 redis-3.2.1 版本。  
两台Linux物理机都是 CentOS ，一台 CentOS6.5 （IP:172.17.5.87），一台 CentOS6.5（IP:172.17.5.9）。

## 下载并解压
```bash
cd /usr/local/redis
wget http://download.redis.io/releases/redis-3.2.1.tar.gz
tar -zxvf redis-3.2.1.tar.gz
```
## 编译安装
```bash
cd redis-3.2.1
make&make install
```
## 将 redis-trib.rb 复制到 /usr/local/bin 目录下
```bash
cd src
cp redis-trib.rb  /user/local/bin/
```
## 创建Redis节点
首先在172.17.5.87服务器上/usr/local/redis/redis-3.2.1 目录下创建 redis_cluster目录；
```bash
mkdir redis_cluster
```
在 redis_cluster 目录下，创建名为7000、7001、7002的目录，并将 redis.conf 拷贝到这三个目录中
```bash
mkdir 7000 7001 7002
cd ..
cp redis.conf  redis_cluster/7000
cp redis.conf  redis_cluster/7001
cp redis.conf  redis_cluster/7002
```
分别修改这三个配置文件，修改如下内容
```
port  7000                                      //端口7000,7001,7002        
bind 172.17.5.87                                //本机ip 默认ip为127.0.0.1 需要改为其他节点机器可访问的ip 否则创建集群时无法访问对应的端口，无法创建集群      
daemonize    yes                                //redis后台运行
pidfile  /var/run/redis_7000.pid                //pidfile文件对应7000,7001,7002
cluster-enabled  yes                            //开启集群  把注释#去掉
cluster-config-file  nodes_7000.conf            //集群的配置  配置文件首次启动自动生成 7000,7001,7002
cluster-node-timeout  15000                     //请求超时  默认15秒，可自行设置
appendonly  yes                                 //aof日志开启  有需要就开启，它会每次写操作都记录一条日志
```
接着在另外一台机器上（172.17.5.9），的操作重复以上三步，只是把目录改为7003、7004、7005，对应的配置文件也按照这个规则修改即可。

## 启动各个节点

第一台机器上执行
```bash
redis-server redis_cluster/7000/redis.conf
redis-server redis_cluster/7001/redis.conf
redis-server redis_cluster/7002/redis.conf
```

另外一台机器上执行
```bash
redis-server redis_cluster/7003/redis.conf
redis-server redis_cluster/7004/redis.conf
redis-server redis_cluster/7005/redis.conf
```
## 检查 redis 启动情况
一台机器  172.17.5.87
```bash
ps -ef | grep redis
root      9694     1  0 Jul27 ?        00:14:57 redis-server 172.17.5.87:7000 [cluster]   
root      9705     1  0 Jul27 ?        00:15:10 redis-server 172.17.5.87:7001 [cluster]
root     24955     1  0 Aug03 ?        00:03:16 redis-server 172.17.5.87:7002 [cluster]

netstat -tnlp | grep redis
tcp        0      0 172.17.5.87:17000           0.0.0.0:*                   LISTEN      9694/redis-server 1 
tcp        0      0 172.17.5.87:17001           0.0.0.0:*                   LISTEN      9705/redis-server 1 
tcp        0      0 172.17.5.87:17002           0.0.0.0:*                   LISTEN      24955/redis-server  
tcp        0      0 0.0.0.0:6379                0.0.0.0:*                   LISTEN      762/./src/redis-ser 
tcp        0      0 172.17.5.87:7000            0.0.0.0:*                   LISTEN      9694/redis-server 1 
tcp        0      0 172.17.5.87:7001            0.0.0.0:*                   LISTEN      9705/redis-server 1 
tcp        0      0 172.17.5.87:7002            0.0.0.0:*                   LISTEN      24955/redis-server  
```

另一台机器  172.17.5.9
```bash
ps -ef | grep redis
root      9048     1  0 Jul27 ?        00:11:16 redis-server 172.17.5.9:7003 [cluster]    
root      9053     1  0 Jul27 ?        00:11:05 redis-server 172.17.5.9:7004 [cluster]    
root      9058     1  0 Jul27 ?        00:11:09 redis-server 172.17.5.9:7005 [cluster]


netstat -tnlp | grep redis
tcp        0      0 172.17.5.9:17003            0.0.0.0:*                   LISTEN      9048/redis-server 1 
tcp        0      0 172.17.5.9:17004            0.0.0.0:*                   LISTEN      9053/redis-server 1 
tcp        0      0 172.17.5.9:17005            0.0.0.0:*                   LISTEN      9058/redis-server 1 
tcp        0      0 172.17.5.9:7003             0.0.0.0:*                   LISTEN      9048/redis-server 1 
tcp        0      0 172.17.5.9:7004             0.0.0.0:*                   LISTEN      9053/redis-server 1 
tcp        0      0 172.17.5.9:7005             0.0.0.0:*                   LISTEN      9058/redis-server 1
```
## 创建集群
Redis 官方提供了 redis-trib.rb 这个工具，就在解压目录的 src 目录中，第三步中已将它复制到 /usr/local/bin 目录中，可以直接在命令行中使用了。使用下面这个命令即可完成安装。
```bash
redis-trib.rb  create  --replicas  1  172.17.5.87:7000  172.17.5.87:7001  172.17.5.87:7002 172.17.5.9:7003  172.17.5.9:7004  172.17.5.9:7005
```
其中，前三个 ip:port 为第一台机器的节点，剩下三个为第二台机器。

在创建集群时会出现错误，是因为这个工具是用 ruby 实现的，所以需要安装 ruby。安装命令如下：
```bash
yum -y install ruby ruby-devel rubygems rpm-build 

gem install redis
```
安装工具之后再运行 redis-trib.rb 命令，会出现如下提示：

・・・・・・・・・・・

Can I Set the above configuration？（type 'yes' to accept）：
输入 yes 即可，然后出现如下内容，说明安装成功。

## 集群验证
在第一台机器上连接集群的7002端口的节点，在另外一台连接7005节点，连接方式为
```bash
redis-cli -h 172.17.5.87 -c -p 7002     加参数 -C 可连接到集群，因为上面 redis.conf 将 bind 改为了ip地址，所以 -h 参数不可以省略。
```
在7002节点执行命令 set hello world ，执行结果如下：

```bash
172.17.5.87:7002> set hello world
-> Redirected to slot [866] located at 172.17.5.87:7000
OK
172.17.5.87:7000> keys * 
1) "hello"
172.17.5.87:7000> get hello
"world"
172.17.5.87:7000>
```
然后在另外一台7004端口，查看 key 为 hello 的内容， get hello ，执行结果如下：

```bash
# redis-cli -h 172.17.5.9 -c -p 7004
172.17.5.9:7004> keys *
1) "hello"
172.17.5.9:7004> get hello
-> Redirected to slot [866] located at 172.17.5.87:7000
"world"
172.17.5.87:7000>
```
说明集群运作正常。

# 总结
>redis cluster在设计的时候，就考虑到了去中心化，去中间件，也就是说，集群中的每个节点都是平等的关系，都是对等的，每个节点都保存各自的数据和整个集群的状态。每个节点都和其他所有节点连接，而且这些连接保持活跃，这样就保证了我们只需要连接集群中的任意一个节点，就可以获取到其他节点的数据。

>Redis 集群没有并使用传统的一致性哈希来分配数据，而是采用另外一种叫做哈希槽 (hash slot)的方式来分配的。redis cluster 默认分配了 16384 个slot，当我们set一个key 时，会用CRC16算法来取模得到所属的slot，然后将这个key 分到哈希槽区间的节点上，具体算法就是：CRC16(key) % 16384。所以我们在测试的时候看到set 和 get 的时候，直接跳转到了7000端口的节点。

>Redis 集群会把数据存在一个 master 节点，然后在这个 master 和其对应的salve 之间进行数据同步。当读取数据时，也根据一致性哈希算法到对应的 master 节点获取数据。只有当一个master 挂掉之后，才会启动一个对应的 salve 节点，充当 master 。

>需要注意的是：必须要3个或以上的主节点，否则在创建集群时会失败，并且当存活的主节点数小于总节点数的一半时，整个集群就无法提供服务了。