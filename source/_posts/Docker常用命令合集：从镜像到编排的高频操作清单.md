---
title: Docker常用命令合集：从镜像到编排的高频操作清单
date: 2026-04-14
tags: [Docker, 容器, DevOps, 运维, Docker Compose]
categories: 理论知识-运维
description: 一次性梳理Docker日常高频命令，覆盖镜像、容器、网络、数据卷和Compose的核心操作。
cover: /images/cover/docker-common-commands-guide.svg
---

## 描述

Docker把应用与运行环境封装到容器中，解决了“本地能跑、线上不行”的一致性问题。但在实际开发与运维中，命令数量多、选项细节杂，常见现象是“会用几个命令，却很难系统排障”。本文按实际操作链路整理一套高频命令清单，从镜像拉取到容器排查、从网络连接到多服务编排，帮助你在日常工作中快速定位并执行正确命令。

## 正文

### 1. 环境与版本信息

先确认Docker引擎和客户端是否正常，避免后续问题由环境本身引起。

```bash
# 查看客户端与服务端版本
docker version
# 查看运行时详细信息（存储驱动、Cgroup、镜像数等）
docker info
# 查看当前可用的Docker上下文
docker context ls
```

| 命令 | 作用 | 典型场景 |
| --- | --- | --- |
| `docker version` | 查看Client/Server版本 | 确认API兼容性 |
| `docker info` | 查看运行时信息 | 排查驱动、存储、Cgroup问题 |
| `docker context ls` | 查看上下文 | 切换本地/远程Docker环境 |

### 2. 镜像管理命令

镜像是容器运行基础，常见操作是搜索、拉取、查看、删除与构建。

```bash
# 在镜像仓库搜索nginx相关镜像
docker search nginx
# 拉取指定版本镜像
docker pull nginx:1.27
# 列出本地镜像
docker images
# 查看镜像详细元数据
docker image inspect nginx:1.27
# 删除本地镜像
docker rmi nginx:1.27
# 使用当前目录Dockerfile构建镜像
docker build -t myapp:1.0 .
# 给镜像打上可推送到私有仓库的标签
docker tag myapp:1.0 registry.example.com/team/myapp:1.0
# 推送镜像到远程仓库
docker push registry.example.com/team/myapp:1.0
```

实践建议：

- 拉取时尽量指定明确标签，避免`latest`造成不可预期升级。
- 构建镜像时控制上下文体积，配合`.dockerignore`减少传输与缓存失效。
- 推送私有仓库前先执行`docker login`，并确认命名空间权限。

### 3. 容器生命周期命令

开发调试阶段的核心是“创建、启动、观察、进入、停止、删除”。

```bash
# 后台启动容器并映射端口
docker run -d --name web -p 8080:80 nginx:1.27
# 查看运行中的容器
docker ps
# 查看所有容器（含已停止）
docker ps -a
# 启动已停止容器
docker start web
# 停止运行中的容器
docker stop web
# 重启容器
docker restart web
# 删除已停止容器
docker rm web
```

常用补充命令：

```bash
# 持续跟踪容器日志，最多显示最近200行
docker logs -f --tail=200 web
# 进入容器交互式终端
docker exec -it web /bin/sh
# 从本地复制文件到容器
docker cp ./app.conf web:/etc/nginx/conf.d/app.conf
# 实时查看容器资源占用
docker stats
# 查看容器内正在运行的进程
docker top web
```

| 命令 | 核心价值 |
| --- | --- |
| `docker logs` | 快速定位启动失败、端口占用、配置错误 |
| `docker exec` | 进入容器做在线排障与配置验证 |
| `docker stats` | 实时观察CPU/内存，识别资源异常 |
| `docker cp` | 本地与容器间快速传输文件 |

### 4. 网络与数据卷命令

容器间通信与数据持久化，是服务可用性的关键基础。

```bash
# 列出所有Docker网络
docker network ls
# 创建自定义网络
docker network create app-net
# 查看网络详情（子网、已连接容器）
docker network inspect app-net
# 将容器连接到指定网络
docker network connect app-net web
# 删除未使用网络
docker network rm app-net

# 列出所有数据卷
docker volume ls
# 创建数据卷
docker volume create pgdata
# 查看数据卷详情
docker volume inspect pgdata
# 启动PostgreSQL并挂载数据卷持久化数据
docker run -d --name pg -e POSTGRES_PASSWORD=123456 -v pgdata:/var/lib/postgresql/data postgres:16
# 删除未被使用的数据卷
docker volume rm pgdata
```

使用要点：

- 多容器互联优先使用自定义网络，容器名可直接作为DNS名称访问。
- 数据库、消息队列等状态服务必须挂载数据卷，避免容器删除后数据丢失。
- 清理前先确认数据卷是否仍被引用，避免误删业务数据。

### 5. 资源清理与故障排查

长时间开发后，未使用资源会持续占用磁盘与缓存，建议定期清理。

```bash
# 查看镜像、容器、卷占用的磁盘空间
docker system df
# 删除所有已停止容器
docker container prune
# 删除所有未被容器使用的镜像
docker image prune -a
# 删除未使用数据卷
docker volume prune
# 删除未使用网络
docker network prune
# 一次性清理未使用资源（含卷）
docker system prune -a --volumes
```

排障高频组合：

```bash
# 查看容器状态，确认是否异常退出
docker ps -a
# 查看容器完整配置与运行参数
docker inspect web
# 查看最近30分钟日志
docker logs --since=30m web
# 查看最近10分钟Docker事件流
docker events --since 10m
```

说明：

- `docker inspect`可查看容器完整配置、网络、挂载与启动参数。
- `docker events`适合追踪容器重启、停止、健康检查变更等时间线问题。

### 6. Docker Compose常用命令

当服务超过1个时，建议使用Compose统一描述和启动。

```bash
# 后台启动compose定义的所有服务
docker compose up -d
# 查看compose服务状态
docker compose ps
# 持续查看api服务日志
docker compose logs -f api
# 进入api服务容器执行shell
docker compose exec api sh
# 重启api服务
docker compose restart api
# 停止并删除compose相关容器和网络
docker compose down
# 停止并删除compose资源，同时删除卷
docker compose down -v
```

| 命令 | 作用 |
| --- | --- |
| `docker compose up -d` | 后台启动所有服务 |
| `docker compose logs -f` | 聚合查看服务日志 |
| `docker compose exec` | 进入指定服务容器 |
| `docker compose down -v` | 停止并删除容器、网络与匿名卷 |

## 可执行

下面是一组可在本地直接演练的命令，快速覆盖镜像、容器、网络和清理流程。

```bash
# 1) 拉取并运行Nginx
docker pull nginx:1.27
docker run -d --name demo-nginx -p 8080:80 nginx:1.27

# 2) 查看状态与日志
docker ps
docker logs --tail=50 demo-nginx

# 3) 进入容器验证配置
docker exec -it demo-nginx /bin/sh

# 4) 创建网络并挂接容器
docker network create demo-net
docker network connect demo-net demo-nginx
docker network inspect demo-net

# 5) 清理演练资源
docker rm -f demo-nginx
docker network rm demo-net
docker image rm nginx:1.27
```

## 小结

Docker命令学习的关键不是“记全”，而是建立稳定的操作路径：先确认环境，再管理镜像与容器，随后检查网络与数据卷，最后形成可复用的Compose编排与清理习惯。把这套命令清单固化为团队Runbook后，容器故障定位效率和环境交付一致性都会明显提升。
