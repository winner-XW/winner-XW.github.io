---
title: 系统架构设计师-学习第一天
date: 2023/12/27
tags: 软考知识
categories: 软考知识
description:  2024年度目标，加油一起学习吧。
cover: /img/md/architecture.jpeg
---
# 绪论
> 系统架构设计师（System Architecture Designer），决定系统健壮性和生命周期的长短。
## 系统架构概述
- 1946年世界第一台计算机诞生
- 电子数字积分器和计算机（ENIAC）
- 离散变量自动电子计算机（EDVAC）（冯.若依曼）
### 系统架构的定义及发展历程
> 是系统的一种整体的高层次的结构表示，是系统的骨架和根基，支撑和链接各个部分，我们通常把架构设计作为系统开发过程中需求分析阶段后的一个关键步骤，也不是不可或缺的工作要点。

1. 软件架构发展阶段
- 基础研究阶段（1968-1994年）
- 概念体系和核心技术形成阶段（1999-2000年）
- 理论体系完善与发展阶段（1996年至今）
- 普及应用阶段（2000年至今）

2. 架构设计的作用
- 解决相对复杂的需求分析问题
- 解决非功能属性在系统占据重要位置的设计问题
- 解决生命周期长、扩展性需求高的系统整体结果问题
- 解决系统基于组件需要的集成问题
- 解决业务流程再造难得问题

3. 模块化开发规则
- 最高模块内聚
- 最低耦合
- 模块大小适度
- 模块调用链的深度不可过多
- 接口简单、精炼，具有信息隐藏能力
- 尽可能地复用已有模块

![传统MIS系统软甲架构](/img/md/architecture/image2.png)

4. 软件架构影响软件开发的各个阶段
- 需求阶段：把软件架构有的概念引入需求分析阶段，有助于保证需求规约和系统收割机之间的可追踪性和一致性。
- 设计阶段：设计阶段是软件架构最早和最多的阶段。
- 实现阶段：将设计阶段设计的算法及数据类型用程序设计语言进行表示，满足设计、架构和需求分析的要求，从而得到满足设计需求的目标系统。
- 维护阶段：为了保证软具有良好的维护性，在软件架构中针对维护性目标进行分析时，需要对一些有关维护性的属性（如可扩展性、可替换性）进行规定。

### 软件架构的常用分类和建模方式
1. 软件架构的常用分类
- 分层结构（最常见的四层结构，也是事实上的标准架构）
  - 表现层：用户界面，负责视觉和用户互动
  - 业务层：实行业务逻辑
  - 持久层：提供数据，SQL语句就放在这一层
  - 数据库：保存数据
> 有的项目在逻辑层和持久层中间加了一层服务层（Service），提供不同业务逻辑需要的一些通用接口。用户的请求将依次通过这四层的处理，不能跳过其中的任何一层。

- 事件驱动架构（Event-driven Architecture：是通过事件进行通信的软件架构）
  - 事件队列（Event Queue）：接受事件的入口。
  - 分发器（Event Mediator）：将不同的事件分发到不同的业务逻辑单元。
  - 事件通道（Event Channel）：分发器与处理器中间的联系渠道。
  - 事件处理器（Event Processor）：实现业务逻辑，处理完成后会发出事件，触发下一步操作。
> 对于简单的项目，事件队列、分发器和事件通道可以合为一体，整个软件就分成事件代理和事件处理器两部分。

- 微核架构（Microkernel Architecture：又称为插件架构（Plug-in Architecture），是指软件内核相对较小，主要功能和业务逻辑都通过插件实现）
> 内核（Core）通常只包含系统运行的最小功能。插件则是相互独立的，插件之间的通信减少到最低，避免出现互相依赖的问题。

- 微服务架构（Microservices Architecture：每一个服务就是一个独立的部署单元，这些单元是分布式的，互相解耦，通过远程通信协议（比如REST、SOAP）联系）。
  - RESTFUL API模式：服务通过API提供，云服务就属于这一类；
  - RESTFUL 应用模式：服务通过传统的网路协议或者应用协议提供，背后通常是一个多功能的应用程序，常见于企业内部。
  - 集中消息模式：采用消息代理（Message Broker）可以实现消息队列、负载均衡、统一日志和异常处理，缺点是会出现单点失败，消息代理可能要做集群。

- 云架构（Cloud Architecture：主要解决扩展性和比并发的问题，也是最容易扩展的架构；由于每个处理都在内存里，需要进行数据持久化。）
  - 处理单元（Processing Unit）：实现业务逻辑。
  - 虚拟中间件（Virtualized Middleware）：负责通信、保持回话控制（sessions）、数据复制、分布式处理和处理单元的部署。
    - 消息中间件（Messaging Grid）：管理用户请求和回话控制（sessions），当一个请求进来以后，它决定分配给哪一个处理单元。
    - 数据中间件（Data Grid）：将数据复制到每一个处理单元，即数据同步。
    - 处理中间件（Processing Grid）：可选，如果一个请求涉及不同类型的处理单元，该中间件负责协调处理单元。
    - 部署中间件（Deploement Manager）：负责处理单元的启动和关闭，监控负载和响应时间，当负载增加，就新启动处理单元，负载减少，就关闭处理单元。
2. 系统架构的常用建模方法
  - 结构模型
  - 框架模型
  - 动态模型
  - 过程模型