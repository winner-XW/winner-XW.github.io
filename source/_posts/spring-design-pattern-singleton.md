---
title: Spring设计模式-单例模式
date: 2022/01/14
tags: JAVA,SPRING,设计模式
categories: JAVA
description: 设计模式是软件开发的重要组成部分。这些解决方案不仅解决了反复出现的问题，而且还通过识别通用模式来帮助开发人员了解框架的设计。
keywords: JAVA,SPRING,设计模式
cover: /img/md/spring.jpg
---

# 单例模式
> 单例模式是一种确保每个应用程序仅存在一个对象实例的机制。在管理共享资源或提供跨领域服务（例如日志记录）时，此模式很有用。

## 优点和缺点
### 优点:
- 单例模式可以保证内存里只有一个实例，减少了内存的开销。
- 可以避免对资源的多重占用。
- 单例模式设置全局的访问点，可以优化和共享资源的访问。

### 缺点:
- 单例模式一般没有接口，扩展困难，如果要扩展，则除了修改原来的代码，没有第二种途径，违背开闭原则。
- 在并发测试中，单例模式不利于代码调试。在调试过程中。如果单例中的代码没有执行完，也不能拟生成一个新的对象。
- 单例模式的功能代码通常写在一个类中，如果功能设计不合理，则很容易违背单一职责原则。

## 应用
> 开发工具类库中的很多工具类都应用了单例模式，比例线程池、缓存、日志对象、Bean等，它们都只需要创建一个对象。

### 饿汉式
```java
public class Singleton {
    private static final Singleton singleton = new Singleton();
    private Singleton() {
    }
    public static Singleton getInstance() {
        return singleton;
    }
}
```

### 懒汉式
```java
public class Singleton {
    private static Singleton singleton = null;
    private Singleton() {
    }
    public static Singleton getInstance() {
        if(singleton == null) {
            return new Singleton();
        }
        return singleton;
    }
}
```

### 饿汉式（加锁）
```java
public class Singleton {
    private static Singleton singleton = null;
    private Singleton() {
    }
    public static Singleton getInstance() {
        if(singleton == null) {
            synchronized (singleton) {
                if(singleton == null) { 
                    return new Singleton();
                }
                return singleton;
            }
        }
        return singleton;
    }
}
```