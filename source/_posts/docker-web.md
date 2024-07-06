---
title: 前端代码docker镜像作成
date: 2022/12/07
tags: docker,打包,镜像
categories: 运维
description:  制作一个docker镜像，无需在主机中安装且这样统一了前端环境。
keywords: docker,打包,镜像,后端
cover: /img/md/docker.png
---

# Vue项目打包成docker镜像部署(以vue举例)

## 介绍
部署Vue项目，可以build之后，直接放到nginx下面即可，今天给大家介绍创建docker镜像，使用docker镜像启动容器运行部署Vue项目的方式，可以尝试尝试，原理和使用nginx部署一样，不过是使用的docker容器而已，内部还是使用的是nginx作为基础镜像。

## docker安装
可以参考[docker-linux安装教程](https://xiaoweixiaoyun.github.io/2022/08/07/docker-install/)

## 编写dockerfile并发布
```shell
# dokcerfile
# build stage
FROM node:lts-alpine as build-stage
WORKDIR /app
COPY package*.json ./
# sass单独设置拉取地址（速度快的话可以不用）
RUN npm set sass_binary_site https://npm.taobao.org/mirrors/node-sass
RUN npm config set registry https://registry.npm.taobao.org/
RUN npm install
COPY . .
RUN npm run build

# production stafe 
FROM nginx:stable-alpine as production-stage
COPY --from=build-stage /app/dist /usr/share/nginx/html
# 删除原本的默认配置
RUN rm /etc/nginx/conf.d/default.conf
# 从名为builder的阶段，复制nginx配置文件到/etc/nginx/conf.d/
COPY --from=builder /app/nginx.conf /etc/nginx/conf.d/

# # 添加时区环境变量，亚洲，上海
ENV TimeZone=Asia/Shanghai

EXPOSE 80
CMD ["nginx","-g","Daemon off;"]
```

- FROM node:lts-alpine as build-stage 基于node lst-alpine(版本号) 版本镜像 并通过构建阶段命名为build-stage
- WORKDIR /app 将工作区设为app与其他系统文件隔离
- COPY package*.json ./ 将package.json 与package-lock.json 到/app目录
- RUN npm install 运行npm install 在容器中安装依赖
- COPY . . 拷贝其他文件到 /app 分两次拷贝是因为要保持node_modules一致
- RUN npm run build :运行npm run build（执行环境）

将构建分为两个阶段，第一阶段基于node镜像，第二阶段基于Nginx 镜像

- FROM nginx:stable-alpine as production-stage 基于nginx stable-alpine 版本镜像 并将有nginx 的环境阶段命名为productuion-stage
- COPY --from=build-stage /app/dist /usr/share/nginx/html 通过–from 参数可以引用build-stage 阶段生成的产物，并将其复制到 /usr/share/nginx/html
- EXPOSE 80: 容器对外暴漏80端口
- CMD ["nginx" ,"-g","daemon off"] 容器创建时运行 nginx -g daemon off 命令 一旦COM对映命令结束 容器就会被销毁 所以通过daemon off rang Nginx 一直在前台运行

## 编写nginx默认配置
```shell
server {
    listen       9099;
    server_name  localhost;
    client_max_body_size 10M;

    location / {
        root   /usr/share/nginx/html;
        index  index.html index.htm;
    }

    error_page   500 502 503 504  /50x.html;
    location = /50x.html {
        root   html;
    }

    gzip on;
    gzip_min_length 1k;
    gzip_buffers 16 64k;
    gzip_http_version 1.1;
    gzip_comp_level 9;
    gzip_types text/plain text/css text/javascript application/json application/javascript application/x-javascript application/xml application/x-httpd-php image/jpeg image/gif image/png font/ttf font/otf image/svg+xml;
    gzip_vary on;   
}
```

## 创建Docker镜像
```shell
docker build . -t dokcerImage:last
```
- docker build 创建Docker镜像
- . 使用当前目录下的Dockerfile文件
- -t 使用tag 标记版本
- dockerImage:last 创建名为dockerImage的镜像，并标记为last（最新）版本

## 创建Docker 容器
```shell
docker run -d -p 80:80 --name dockerContainer dockerImage:last
```

- docker run :创建并运行docker容器
- -d 后台运行
- 80:80 将当前服务的80端口（冒号前的80），映射到容器的80端口（冒号后的80）
- –name 给容器命名，便于之后定位容器
- dockerImage:last 基于dockerImage 最新版本镜像创建的容器