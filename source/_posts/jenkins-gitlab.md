---
title: Jenkins-Docker
date: 2023/08/15
password: luoping123
tags: [Jenkins,Docker,CI/CD]
categories: 运维-运维效率
description:  节约每次上线部署时间，提高作业效率，保证正确性。
cover: /img/md/jenkins.png
---

# 设置参数
## 设置分支参数：branch（develop）、server（***.***.**.**）
## 设置工程名参数：project（***-back、***-web）

## 编写生成镜像脚本（web举例）
```shell
# Build Steps
# 执行 shell
echo "tag=$(date +%Y%m%d).${BUILD_NUMBER}.${branch}" > /tmp/jenkins-env-***-web-tag

# 注入环境变量
# 属性文件路劲
/tmp/jenkins-env-***-web-tag

# 执行 shell
rm -rf ***-web
git clone https://用户名:密码@code.trechina.cn/gitlab/project-trial/hbs/***-web.git

cd ***-web
git checkout $branch

cd ***-web
docker build -t code.trechina.cn/project-trial/hbs/***-web:${tag} .

docker login code.trechina.cn -u 用户名 -p 密码
docker push code.trechina.cn/project-trial/hbs/***-web:${tag}
docker logout code.trechina.cn


# 构建后操作
announcement-deploy
# 参数传递
server=${server}
app=web
tag=${tag}
```

## 编写容器启动脚本（docker-compose.yml）[下载地址](/file/conf.zip)
```shell
version: "3.8"

services:
  ***view:
    image: docker环境服务器地址/project-trial/md/control/***-web:2023081509515721
    restart: always
    tty: true
    network_mode: host
  ***api:
    image: docker环境服务器地址/project-trial/md/control/***-back:2023081509530949
    restart: always
    tty: true
    network_mode: host
    environment:
      - active=dev
    volumes:
      - ./logs/api:/logs
      - ./conf/api:/config
  nginx:
    image: nginx
    container_name: logisticsif-gateway
    restart: always
    volumes:
      - ./conf/nginx/conf.d/default.conf:/etc/nginx/conf.d/default.conf
      - ./conf/nginx/etc/localtime:/etc/localtime
      - ./conf/nginx/etc/timezone:/etc/timezone
      - ./logs/nginx:/var/log/nginx
    depends_on:
      - ***view
      - ***api
    network_mode: host
```


## 调用容器启动脚本
### 设置分支参数：server、app（web/back）、tag
```shell
ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null systemuser@${server} "docker login code.trechina.cn -u 用户名 -p 密码"
ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null systemuser@${server} "sed -i 's|\(image: code.trechina.cn/project-trial/hbs/***-'${app}':\).*|\1'${tag}'|' /home/systemuser/announcement/docker-compose.yaml"
ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null systemuser@${server} "cd /home/systemuser/announcement/ && docker compose up -d"
ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null systemuser@${server} "docker logout code.trechina.cn"
```

## 截图说明

## 注意事项
> ssh链接报错：-o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null  
ssh服务端需要添加客服端秘钥
