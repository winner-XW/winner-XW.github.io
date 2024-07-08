---
title: Vsftp-CentOS安装教程
date: 2024/07/08
tags: [Vsftp,安装]
categories: 运维-安装教程
description: Vsftp-CentOS安装教程
cover: /img/md/ftp.png
---


# 介绍
在CentOS系统上安装和配置vsftpd服务器是一个相对简单的过程，可以让你搭建一个功能强大的FTP服务器。以下是详细的步骤和说明，帮助你在CentOS上安装vsftpd并进行基本配置。

# 安装vsftpd
```bash
# 第一种
sudo apt-get update
sudo apt-get install vsftpd

# 第二种
sudo yum install vsftpd -y

# 检查是否安装成功
sudo vsftpd -v
```

# 启动vsftpd服务
```bash
# 启动服务
sudo systemctl start vsftpd
# 关闭服务
sudo systemctl stop vsftpd
# 设置开机启动
sudo systemctl enable vsftpd
# 重启服务
sudo systemctl restart vsftpd
```

# 配置vsftpd
```bash
sudo cp /etc/vsftpd/vsftpd.conf /etc/vsftpd/vsftpd.conf.bak

# 使用文本编辑器打开配置文件
sudo vi /etc/vsftpd/vsftpd.conf
```
根据你的需求修改配置选项。以下是一些常用的配置项及其说明：
```bash
anonymous_enable=YES: 允许匿名用户访问FTP服务器。
anon_umask=022: 设置匿名用户上传文件的默认权限掩码值。
anon_root=/var/ftp: 设置匿名用户的FTP根目录。
anon_upload_enable=YES: 允许匿名用户上传文件。
anon_mkdir_write_enable=YES: 允许匿名用户创建目录并写入。
anon_other_write_enable=YES: 允许匿名用户进行文件改名、覆盖及删除等操作。
```

对于基于用户验证的FTP服务，你可以设置以下选项：
```bash
local_enable=YES: 允许本地用户访问FTP服务器。
local_umask=022: 设置本地用户上传文件的默认权限掩码值。
local_root=/var/ftp: 设置本地用户的FTP根目录（默认为用户的宿主目录）。
chroot_local_user=YES: 将FTP本地用户禁锢在其宿主目录中。
allow_writeable_chroot=YES: 允许被限制用户的主目录具有写权限。
```

# 配置防火墙
```bash
# 第一种
sudo firewall-cmd --zone=public --add-port=21/tcp --permanent
sudo firewall-cmd --reload

# 第二种
sudo iptables -I INPUT -p tcp --dport 8080 -j ACCEPT

# 查看端口开放
ss -tuln | grep :80
netstat -tuln | grep :80
```

# 设置ftp用户
```bash
# 设置用户目录
sudo mkdir /var/ftp/data/announcement
# 设置目录权限
sudo chmod -R 777 /var/ftp/
chmod a-w /var/ftp/data

# 添加用户
sudo useradd -d /var/ftp/data/announcement -s /bin/bash announcement
# 设置用户密码
sudo passwd announcement
```

# 注意事项
>- 确保你的CentOS系统上的SELinux设置不会阻止FTP操作。
>- 如果你更改了监听端口或使用了非标准配置，请确保相应的防火墙规则和SELinux策略已经更新。
>- 出于安全考虑，建议不要允许匿名访问或限制匿名用户的权限。
>- 请定期更新vsftpd和系统，以确保安全漏洞得到修复。