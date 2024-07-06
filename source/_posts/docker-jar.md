---
title: jar包docker镜像作成
date: 2023/08/07
tags: docker,打包,镜像
categories: 运维
description:  制作一个docker镜像，无需在主机中安装且这样统一了后端环境。
keywords: docker,打包,镜像,前端
cover: /img/md/docker.png
---

# jar项目打包成docker镜像部署

## 介绍
部署jar项目，可以mvn clean package之后，直接放到启动路径下即可，今天给大家介绍创建docker镜像，使用docker镜像启动容器运行部署jar项目的方式，可以尝试尝试，原理和使用直接拖动部署一样，不过是使用的docker容器而已，内部还是使用的是jdk作为基础镜像。

## docker安装
可以参考[docker-linux安装教程](https://xiaoweixiaoyun.github.io/2022/08/07/docker-install/)

## 编写dockerfile并发布
```shell
FROM maven:3.6.3-openjdk-11-slim  AS builder

WORKDIR "/server"

# 主要文件
COPY ./settings.xml /tmp/ck-web-back/settings.xml
COPY ./pom.xml /tmp/ck-web-back/pom.xml
COPY ./src /tmp/ck-web-back/src/

# package jar
RUN cd /tmp/ck-web-back && mvn clean package --settings ./settings.xml -Dmaven.test.skip=true

# Second stage: minimal runtime environment
FROM openjdk:11.0.16

RUN ln -snf /usr/share/zoneinfo/Asia/Tokyo /etc/localtime && echo Asia/Tokyo > /etc/timezone
RUN sed -i 's/TLSv1, TLSv1.1,//' /usr/local/openjdk-11/conf/security/java.security
RUN sed -i 's/3DES_EDE_CBC,//' /usr/local/openjdk-11/conf/security/java.security

# copy jar from the first stage
COPY --from=builder /tmp/ck-web-back/target/centralkitchen.jar /root/centralkitchen.jar

CMD [ "java", "-jar", "/root/centralkitchen.jar" ]

EXPOSE 8083

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