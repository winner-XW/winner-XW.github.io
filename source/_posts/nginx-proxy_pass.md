---
title: Nginx中location匹配规则与proxy_pass代理转发
date: 2024/03/24
tags: [匹配规则,Nginx,代理]
categories: 运维-知识学习
description: Nginx中location匹配规则与proxy_pass代理转发
cover: /img/md/nginx.png
---

# location匹配规则

## 前缀匹配：不带符号
``` nginx
server {
	listen 80;
	server_name 192.168.100.123;
	location /abc {}  
}
#可以匹配到
http://192.168.100.123/abc
http://192.168.100.123/abc?name=zs
http://192.168.100.123/abc/
http://192.168.100.123/abcd

# 下列写法，当输入http://192.168.100.123时匹配到
location / {} 
```

## 精确匹配：符号=：表示精确匹配
``` nginx
server {
	listen 80;
	server_name 192.168.100.123;
	location = /abc {}  
}
#可以匹配到
http://192.168.100.123/abc
http://192.168.100.123/abc?name=zs
#不能匹配到
http://192.168.100.123/abc/
http://192.168.100.123/abcd
```

## 正则匹配：符号~与~*：执行一个正则匹配，前者区分大小写，后者不区分
``` nginx
server {
	listen 80;
	server_name 192.168.100.123;
	location = ~* \.(jpg|png|gif)$  {}
}
```

## 符号^~：一旦匹配到，就不继续匹配
``` nginx
server {
	listen 80;
	server_name 192.168.100.123;
	# 匹配静态文件
	location ^~ /static/ {}
}
```

## 匹配优先级

1.精确匹配 =：如果匹配到，匹配结束，否则往下匹配；  
2.前缀匹配（三种情况）：  
（1）如果匹配到，记录所有成功项，最长项如果有^~，停止匹配；  
（2）如果匹配到，记录所有成功项，最长想如果没有^~，进行正则匹配；  
（3）如果没有匹配到，进行正则匹配  
3.正则匹配 ~与~*：从上往下匹配，以最后一个匹配项为匹配结果  
4.没有匹配项，返回404

参考以下图片：  
![匹配优先级](/img/md/nginx-proxy_pass/v2-700c0f0f0b0e0b0e0b0e0b0e0b0e0b0e_720w.jpg)

# proxy_pass规则
> 访问地址：http://192.168.1.123/test/xxoo.html为例，server_name 为192.168.1.123，其中末尾是否带/有比较多的情况，在使用时需要特别注意

## location带/且proxy_pass带/
```nginx
location /test/ {
	proxy_pass http://192.168.1.123/
}
```
代理地址 http://192.168.1.123/xxoo.html

## location带/且proxy_pass不带/
```nginx
location /test/ {
	proxy_pass http://192.168.1.123;
}
```
代理地址 http://192.168.1.123/test/xxoo.html

## location带/且proxy_pass带二级目录和/
```nginx
location /test/ {
	proxy_pass http://192.168.1.123/api/;
}
```
代理地址 http://192.168.1.123/api/xxoo.html

## location带/且proxy_pass带二级目录不带/
```nginx
location /test/ {
	proxy_pass http://192.168.1.123/api;
}
```
代理地址 http://192.168.1.123/apixxoo.html

## location不带/且proxy_pass带二级目录不带/
```nginx
location /test {
	proxy_pass http://192.168.1.123/api;
}
```
代理地址 http://192.168.1.123/api/xxoo.html

## location不带/且proxy_pass带/
```nginx
location /test {
	proxy_pass http://192.168.1.123/;
}
```
代理地址 http://192.168.1.123//xxoo.html

## location不带/且proxy_pass不带/
```nginx
location /test {
	proxy_pass http://192.168.1.123;
}
```
代理地址http://192.168.1.123/test/xxoo.html

# alias与root
使用alias，当访问/test/时，会到/www/abc/目录下找文件
```nginx
location /test/ {
	alias /www/abc/;
}
```
使用root，当访问/test/时，会到/www/abc/test/目录下找文件（如果没有test目录会报403）
```nginx
location /test/ {
	root /www/abc;
}
```
