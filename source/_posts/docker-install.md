---
title: docker-linux安装教程
date: 2022/08/07
tags: docker,安装
categories: 运维
description:  Docker 是一个开源的应用容器引擎，让开发者可以打包他们的应用以及依赖包到一个可移植的镜像中，然后发布到任何流行的 Linux或Windows操作系统的机器上，也可以实现虚拟化。容器是完全使用沙箱机制，相互之间不会有任何接口。
keywords: docker,安装
cover: /img/md/docker.png
---


# 介绍
Docker 是一个开源的应用容器引擎，让开发者可以打包他们的应用以及依赖包到一个可移植的镜像中，然后发布到任何流行的 Linux或Windows操作系统的机器上，也可以实现虚拟化。容器是完全使用沙箱机制，相互之间不会有任何接口。

# docker安装
```shell
# 使用'yum-utils'来维护YUM并提高其性能
sudo yum install -y yum-utils device-mapper-persistent-data lvm2
sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
# 默认安装最新版本（不指定版本的情况下）
sudo yum -y install docker-ce docker-ce-cli containerd.io

# 如果想安装指定版本，查找指定的版本进行安装
yum list docker-ce --showduplicates | sort -r

# 1. 重启docker服务
sudo systemctl restart docker

# 2. 修改Daemon
sudo vi /etc/docker/daemon.json
{
  "bip":"172.31.0.1/16"
}

# 3. 创建docker用户组
sudo groupadd docker

# 4. 添加当前用户加入docker用户组
sudo usermod -aG docker ${USER}
sudo chown -R ${USER}:docker /var/run/docker.sock

# 5. **注意：切换或者退出当前账户再从新登入**
docker ps

# 6. 开机自启动 设定
sudo systemctl enable docker
systemctl list-unit-files | grep docker

# 7. 重启docker服务
sudo systemctl restart docker

# 8. docker 自带 compose 命令：docker compose --version
# 创建别名 和之前的【docker-compose】命令统一

alias docker-compose='docker compose'
docker-compose --version
```

# docker-compose安装（上边第8步骤已经作业的情况下，下面就不用安装了）
```shell
# 查看相应的版本
https://github.com/docker/compose/releases

# 下载安装
wget https://github.com/docker/compose/releases/download/v2.16.0/docker-compose-linux-x86_64
sudo mv docker-compose-linux-x86_64 /usr/local/bin/docker-compose
# 赋运行权限
sudo chmod +x /usr/local/bin/docker-compose
sudo ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose

# 查看版本
sudo docker-compose version
```

# docker命令卸载

1. 删除docker所在目录
```shell
rm -rf /etc/docker
rm -rf /run/docker
rm -rf /var/lib/dockershim
rm -rf /var/lib/docker
```

2. Kill掉Docker进程
```shell
ps -ef | grep docker
kill -9 pid
```

3. 卸载docker相关包
```shell
# 查看相关包
yum list installed | grep docker
# 把匹配到的包执行 yum remove 删除
yum remove  containerd.io.x86_64
yum remove docker-ce.x86_64
yum remove docker-ce-cli.x86_64
yum remove docker-ce-rootless-extras.x86_64
yum remove docker-compose-plugin.x86_64
yum remove docker-scan-plugin.x86_64
```