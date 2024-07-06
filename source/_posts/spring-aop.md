---
title: Spring AOP
date: 2023/08/02
tags: JAVA,SPRING,AOP
categories: JAVA
description: 如果说IOC是Spring 的核心，那么面向切面编程AOP就是Spring 另外一个最为重要的核心。
keywords: JAVA,SPRING,AOP
cover: /img/md/spring.jpg
---

# AOP的定义
AOP （Aspect Orient Programming）,直译过来就是 面向切面编程,AOP 是一种编程思想，是面向对象编程（OOP）的一种补充。

面向切面编程，实现在不修改源代码的情况下给程序动态统一添加额外功能的一种技术，如下图所示：
![AOP图解](/img/md/spring-aop/d353c269ee2b4228b29cc70b049877ea.png)

AOP可以拦截指定的方法并且对方法增强，而且无需侵入到业务代码中，使业务与非业务处理逻辑分离，比如Spring的事务，通过事务的注解配置，Spring会自动在业务方法中开启、提交业务，并且在业务处理失败时，执行相应的回滚策略。

# AOP的作用

AOP 采取横向抽取机制（动态代理），取代了传统纵向继承机制的重复性代码，其应用主要体现在事务处理、日志管理、权限控制、异常处理等方面。

主要作用是分离功能性需求和非功能性需求，使开发人员可以集中处理某一个关注点或者横切逻辑，减少对业务代码的侵入，增强代码的可读性和可维护性。

简单的说，AOP 的作用就是保证开发者在不修改源代码的前提下，为系统中的业务组件添加某种通用功能。

# AOP的应用场景
AOP可以拦截指定的方法，并且对方法增强，比如：事务、日志、权限、性能监测等增强，而且无需侵入到业务代码中，使业务与非业务处理逻辑分离。

# AOP核心概念
![AOP术语](/img/md/spring-aop/299bbecec9784800a4a1690653814b68.png)

# AOP通知分类
![AOP通知](/img/md/spring-aop/502119ede09f499fa52a920794e413d7.png)