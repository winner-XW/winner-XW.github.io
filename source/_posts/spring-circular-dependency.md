---
title: Spring如何解决循环依赖
date: 2023/08/14
tags: JAVA,SPRING,循环依赖
categories: JAVA
description: Spring如何解决循环依赖，是面试中经常问到的题目，今天我们就来分享一下spring是如何解决循环依赖问题的。
keywords: JAVA,SPRING,循环依赖
cover: /img/md/spring.jpg
---

# 前言
Spring的解决循环依赖是有前置条件的，要解决循环依赖我们首先要了解Spring Bean对象的创建过程和依赖注入的方式。

# 什么是循环依赖
通俗来讲，就是A依赖B或者B依赖A，或者C依赖自己本身，或是三个以上，例如A依赖B，B依赖C，C又依赖A。如下图：
![循环依赖图解](/img/md/spring-circular-dependency/efbac14bcc9445d48308403ce0edf80b.png)

# Spring实例Bean的本质
Spring在实例化一个bean的时候，是首先递归的实例化其所依赖的所有bean，直到某个bean没有依赖其他bean，此时就会将该实例返回，然后反递归的将获取到的bean设置为各个上层bean的属性的。

# 循环依赖主要场景 
![循环依赖场景](/img/md/spring-circular-dependency/fe206631c4b046a0a058b20461dbb318.png)

# 什么情况下循环依赖可以被解决

> Spring解决循环依赖是有前置条件的

出现循环依赖的Bean必须要是单例(singleton)，如果依赖prototype则完全不会有此需求。
依赖注入的方式不能全是构造器注入的方式。
![循环依赖解决情况](/img/md/spring-circular-dependency/d1a61853fd3348fb94b65ab10dc9fdf3.png)

# 解决方式
Spring是通过三级缓存来解决上述问题的：

一级缓存： singletonObjects存储的是所有创建好了的单例Bean
二级缓存：earlySingletonObjects完成实例化，但是还未进行属性注入及初始化的对象
三级缓存：singletonFactories提前暴露的一个单例工厂，二级缓存中存储的就是从这个工厂中获取到的对象。
 

三级缓存解决循环依赖流程：

1. 获取A时首先会尝试从一级缓存singletonObjects 中获取；
2. 获取不到就再从二级缓存earlySingletonObjects中获取；
3. 若是还没有则尝试从三级缓存singletonFactories获取；
4. 还是没有获取到则再尝试创建A对象
5. 会执行doGetBean->createBean->createBeanInstance并使用构造器实例化
6. 在尝试给A进行初始化时，由于B不存在无法完成初始化，则将半成品A放入第二级缓存中，进入B的创建流程。
7. 与先前过程相似，在第三级缓存中放入beanName和表达式sharedInstance，进入B的初始化过程
8. 由于在第二级缓存中可以找到A，则B可以完成初始化，将成品Bean放入一级缓存中备用，删除三级缓存中的B
9. 同时完成A的初始化，并删除二级缓存中的半成品A

具体流程图如下： 
![循环依赖解决情况](/img/md/spring-circular-dependency/e0842591fdcd47c282f3649fe565859b.png)

# 总结

Spring通过三级缓存解决了循环依赖，其中一级缓存为单例池（singletonObjects），二级缓存为早期曝光对象earlySingletonObjects，三级缓存为早期曝光对象工厂（singletonFactories）。
当A、B两个类发生循环引用时，在A完成实例化后，就使用实例化后的对象去创建一个对象工厂，添加到三级缓存中，如果A被AOP代理，那么通过这个工厂获取到的就是A代理后的对象，如果A没有被AOP代理，那么这个工厂获取到的就是A实例化的对象。
当A进行属性注入时，会去创建B，同时B又依赖了A，所以创建B的同时又会去调用getBean(a)来获取需要的依赖，此时的getBean(a)会从缓存中获取。

- 先获取到三级缓存中的工厂；
- 调用对象工工厂的getObject方法来获取到对应的对象，得到这个对象后将其注入到B中。紧接着B会走完它的生命周期流程，包括初始化、后置处理器等。
- 当B创建完后，会将B再注入到A中，此时A再完成它的整个生命周期。