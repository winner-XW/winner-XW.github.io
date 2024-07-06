---
title: Nginx配置https服务器​
date: 2024/03/25
tags: [安装,Nginx,SSL]
categories: NGINX
description: nginx配置https服务器​
cover: /img/md/nginx.png
---

# windows环境

## 安装nginx
1. nginx官网[下载nginx](https://nginx.org/en/download.html)
2. 解压nginx
3. 运行并验证`start nginx`是否成功

## 安装 OpenSSL（创建证书）
1. 下载[OpenSSL](https://slproweb.com/products/Win32OpenSSL.html)
2. 安装OpenSSL
3. 配置环境变量
	3.1 Path -> `C:\Program Files\OpenSSL-Win64\bin`
	3.2 添加OPENSSL_CONE = `C:\Program Files\OpenSSL-Win64\openssl.cnf`

## 生成https证书
1. 生成https证书
2. 创建文件夹管理证书`C:\nginx\ssl\`
3. 创建私钥`openssl genrsa -out C:\nginx\ssl\nginx.key 2048` // nginx 私钥名字
4. 创建证书`openssl req -new -key C:\nginx\ssl\nginx.key -out C:\nginx\ssl\nginx.csr`
5. 复制nginx.key并重命名nginx.key.org
6. 删除密码`openssl rsa -in C:\nginx\ssl\nginx.key.org -out C:\nginx\ssl\nginx.key`
7. 生成crt证书`openssl x509 -req -days 365 -in C:\nginx\ssl\nginx.csr -signkey C:\nginx\ssl\nginx.key -out C:\nginx\ssl\nginx.crt`

## nginx 配置并重新启动

### 修改nginx.conf  
```nginx
upstream nodejs__upstream2 {
	server 127.0.0.1:8080; # 需要监听的端口名 我用的
	keepalive 64;
}

server {
	listen 443 ssl;
	server_name dev.kt.looklook.cn; #配置的https的域名或者IP

	ssl_certificate      C://nginx//ssl//nginx.crt;  # 这个是证书的crt文件所在目录
	ssl_certificate_key  C://nginx//ssl//nginx.key;  # 这个是证书key文件所在目录

	ssl_session_cache    shared:SSL:1m;
	ssl_session_timeout  5m;

	ssl_ciphers  HIGH:!aNULL:!MD5;
	ssl_prefer_server_ciphers  on;

	location / {
		proxy_set_header   X-Real-IP            $remote_addr;
		proxy_set_header   X-Forwarded-For  $proxy_add_x_forwarded_for;
		proxy_set_header   Host                   $http_host;
		proxy_set_header   X-NginX-Proxy    true;
		proxy_set_header   Connection "";
		proxy_http_version 1.1;
		proxy_pass         http://nodejs__upstream2;
	}
}
```

### 重启nginx
```nginx
nginx -s reload
```
	
### 配置host文件
`C:\Windows\System32\drivers\etc`路径下添加`127.0.0.1 dev.kt.looklook.cn`