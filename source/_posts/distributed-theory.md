---
title: 分布式基础理论 CAP & BASE
date: 2024/09/10
tags: [Java,SPRING,CAP,BASE]
categories: 后端-知识学习
description: CAP和BASE理论可以说是分布式系统的基础理论了，只要面试的时候遇到分布式的问题，基本上都会问到这两个理论。但是好多没毕业的同学，或者参加工作时间不长的同学，可能没有在实际开发中接触过分布式系统，这种情况我的建议是多看优质博客，自己多思考，然后找一些开源的项目看一下理论的实际运用。当然有相关经验的同学也可以复习巩固一下。
cover: /img/md/spring.jpg
---

# CAP定理

CAP定理又被称为布鲁尔定理，是加州大学计算机科学家埃里克·布鲁尔提出来的猜想，后来被证明成为分布式计算领域公认的定理。不过布鲁尔在出来CAP的时候并没有对CAP三者（Consistency，Availability，Partition tolerance）进行详细的定义，所以在网上也出现了不少对CAP不同解读的声音。

CAP定理在发展中经历过两个版本，后一个版本比较完善，我们以第二个版本为准：在一个分布式系统中（指互相连接并共享数据的节点集合）中，当涉及到读写操作时，只能保证一致性（Consistence）、可用性（Availability）、分区容错性（Partition Tolerance）三者中的两个，另外一个必须被牺牲。

其中的关系如下图所示：
![关系图解](/img/md/distributed-theory/00e93901213fb80e6d6f150ff6bf4822b8389422.webp)

## 一致性、可用性、分区容错性的具体体现是什么。
- 一致性(Consistence) , 这个是针对数据来说的，比如数据库MySQL中的数据，一个分布式系统中，某个节点修改了一个数据，那么之后其他所有节点读取这条数据的时候，得到的一定是最新的数据。
- 可用性(Availability)，分布式系统中某些节点挂掉了，但是不会影响整体的业务，比如 C 这个微服务，有10个实例组成一个集群，其中5个挂了，另外5个正常，这种情况下整个系统还是可用的，不会因为挂了那5个，导致系统整体不可用。
- 分区容错性(Partition Tolerance)，分布式系统出现网络分区的时候，仍然能够对外提供服务。

## 什么是网络分区？
分布式系统中，多个节点之前的网络本来是连通的，但是因为某些故障（比如部分节点网络出了问题）某些节点之间不连通了，整个网络就分成了几块区域，这就叫网络分区。
![网络分区](/img/md/distributed-theory/9345d688d43f8794f4a5240b127569f81bd53a33.webp)

## 只能三选二？
我在网上看了一些博客，有些说这三个特性只能三选二，不可能同时满足。这其实是一个具有误导性质的说法。

因为在分布式系统中，网络不是100%可靠的，网络分区是必选项，也就是P是必选的，如果我们不选P，选CA，这个时候如果网络发生了分区，那么为了保证C，系统就会禁止写入数据，这样就与A产生了冲突，如果为了保证A，那么正常的分区可以写入数据，有故障的分区就不能写入了，这就与C产生了冲突。

简单来说，就是P是必须要实现的，因为网络不是100%可靠的，在此基础上C 和 A 二选一组成 CP 或者 AP 架构。
比如Zookeeper 是CP架构，Eureka是AP架构，Nacos 不仅支持 CP 架构也支持 AP 架构。

对于服务注册来说，针对同一个服务，即使注册中心的不同节点保存的服务注册信息不相同，也并不会造成灾难性的后果，对于服务消费者来说，能消费才是最重要的，就算拿到的数据不是最新的数据，消费者本身也可以进行尝试失败重试。总比为了追求数据的一致性而获取不到实例信息整个服务不可用要好。
所以，对于服务注册来说，可用性比数据一致性更加的重要，选择AP。

## CAP的实际应用
### 注册中心

注册中心主要做两件事：
1. 服务注册：实例把自身的信息给注册中心，信息包括服务的IP地址和服务Port，以及暴露服务自身状态和访问协议信息。
2. 服务发现：实例请求注册中心，拿到想要请求的服务信息，IP+Port，就可以访问具体的实例了。
![注册中心](/img/md/distributed-theory/738b4710b912c8fc6b3d3832436df549d48821fa.webp)

常见的注册中心组件有：Zookeeper、Eureka、Nacos等等，我们以Zookeeper和Eureka为例，分别说明一下CP和AP。
Zookeeper 保证的是CP。任何时刻对Zookeeper的读请求都能得到一致的结果，但是zookeeper不`能保证服务的可用性，比如在选举Leader的时候，或者一半以上的机器不可用，那么整个系统就是不可用状态。
Eureka保证的是AP。因为在设计的时候就是优先保证AP，而且Eureka集群中没有Leader节点，每个节点都是一样的，所以Eureka可以做到只要有一个节点可用，那么系统就是可用的，只不过这个节点上的数据不能保证是最新的。

## 小结
对于服务注册来说，针对同一个服务，即使注册中心的不同节点保存的服务注册信息不相同，也并不会造成灾难性的后果，对于服务消费者来说，能消费才是最重要的，就算拿到的数据不是最新的数据，消费者本身也可以进行尝试失败重试。总比为了追求数据的一致性而获取不到实例信息整个服务不可用要好。
所以，对于服务注册来说，可用性比数据一致性更加的重要，一般选择AP。

# BASE理论
BASE 是 Basically Available（基本可用）、Soft-state（软状态） 和 Eventually Consistent（最终一致性） 三个短语的缩写。BASE 理论是对 CAP 中一致性 C 和可用性 A 权衡的结果，其来源于对大规模互联网系统分布式实践的总结，是基于 CAP 定理逐步演化而来的，它大大降低了我们对系统的要求。

BASE理论本质上是对CAP的延伸和补充，是对CAP中的AP方案的一个补充，即在选择AP方案的情况下，如何更好地最终达到C。

## BASE理论三要素
![BASE理论三要素](/img/md/distributed-theory/6c224f4a20a4462369d52591274c15020df3d7a5.webp)
- 基本可用：出现故障的时候，允许损失部分可用性，即，保证核心可用
如，电商大促时，为了应对访问量激增，部分用户可能会被引导到降级页面，服务层也可能只提供降级服务。

- 软状态：允许系统存在中间状态，而该中间状态不会影响系统整体可用性。
软状态本质上是一种弱一致性，允许的软状态不能违背“基本可用”的要求。如，分布式存储中一般一份数据至少会有三个副本，允许不同节点间副本同步的延时（某些时刻副本数低于3）。

- 最终一致性：系统中的所有数据副本经过一定时间后，最终能够达到一致的状态。
最终一致性强调的是系统中所有的数据副本，在经过一段时间的同步后，最终能够达到一个一致的状态。因此，最终一致性的本质是需要系统保证最终数据能够达到一致，而不需要实时保证系统数据的强一致性。

分布式中的一致性有三种级别：
1. 强一致性：系统在某个节点中写入或修改了数据，那么之后在任意节点读取到的数据都是最新的数据。
2. 弱一致性：不一定能读到最新的值，也不能保证在一定时间后读取到的数据是最新的，只会尽量在某个时刻达到数据一致的状态。
3. 最终一致性：弱一致性的升级版，可以保证在一定时间内达到数据的最终一致性。

一般常用的是最终一致性，但是也有一些对一致性要求比较高的，比如银行的交易系统，这种要保证强一致性。

# 总结
在分布式架构中，是无法脱离CAP理论的，因为网络永远不能100%可靠，硬件也会老化，软件可能出现BUG，所以分区容错性(Partition Tolerance)是避不开的，只要是分布式，只要是集群，都面临着选AP或者CP，如果你都想要，那只能对一致性做出一些妥协，也就是引入BASE理论，在业务允许的情况下实现最终一致性。

究竟是选择AP还是CP，在于业务，比如涉及到金钱交易，库存相关的会优先考虑CP模型，而例如社区发帖，评论这种相关的可以选择AP模型。总之选什么模型是由业务来决定的。