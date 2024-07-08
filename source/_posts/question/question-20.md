---
title: 请描述JDK和JRE的区别？
date: 2024/04/08
tags: [Java,初级]
categories: 后端-面试题库
description: 请描述JDK和JRE的区别？
cover: /img/md/java.png
---

1. JDK：全称Java Development Kit，翻译为Java开发工具包，提供Java的开发和运行环境，是整个Java的核心。目前各大主流公司都有自己的jdk，比如oracle jdk（注意，生产环境使用时需要注意法律风险）、openjdk（目前生产环境主流的jdk）、dragonwell（阿里家的jdk，在金融电商物流方面做了优化）、zulujdk（巨硬家的jdk）等等

2. JRE：全称Java Runtime Environment，Java运行时环境，为Java提供运行所需的环境
总的来说，JDK包含JRE，JAVA源码的编译器javac，监控工具jconsole，分析工具jvisualvm
总结，如果你需要运行Java程序（类似我的世界那种），只需要安装JRE；如果你需要程序开发，那么需要安装JDK就行了，不需要再重复安装JRE。