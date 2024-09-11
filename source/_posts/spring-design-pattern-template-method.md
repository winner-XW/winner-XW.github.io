---
title: Spring设计模式-模板方法模式
date: 2024/09/10
tags: [Java,Spring,模板方法模式]
categories: 后端-知识学习
description: 设计模式是软件开发的重要组成部分。这些解决方案不仅解决了反复出现的问题，而且还通过识别通用模式来帮助开发人员了解框架的设计。
cover: /img/md/spring.jpg
---

# 工厂模式
>  模板方法模式用于定义一个算法的框架，并允许子类在不改变该算法结构的情况下重新定义算法中的某些步骤。这种模式提供了一种将算法的通用部分封装在一个模板方法中，而将具体步骤的实现延迟到子类中的方式。

## 模板方法模式的案例？
1. RestTemplate:
在 Spring 框架中，RestTemplate 是用来发送 REST 请求的模板工具类。它使用了模板方法模式，提供了一些通用的方法和工具，使得发送 REST 请求的过程更加简单和灵活。RestTemplate 中的 execute、getForObject、postForObject 等方法构成了模板方法，它们定义了 REST 请求的通用流程，而具体的 HTTP 请求的细节则由不同的实现类来实现。

2. RedisTemplate:
在 Spring Data Redis 中，RedisTemplate 用于执行对 Redis 的各种操作。它同样使用了模板方法模式，定义了一系列对 Redis 的操作方法，如 set、get、delete 等，这些方法构成了模板方法，而底层的 Redis 连接和具体的操作则由实现类来完成。

3. MongoTemplate:
在 Spring Data MongoDB 中，MongoTemplate 用于执行对 MongoDB 的操作。与前面两个类似，MongoTemplate 也采用了模板方法模式，定义了诸如 find、insert、update 等方法，这些方法构成了模板方法，具体的 MongoDB 操作则由实现类来完成。

# 案例
模板方法一般是在设计框架时，将一些固定的方法封装在模板中，那我们就可以直接调用，比如 String response = restTemplate.postForObject(url, request, String.class)，我们只需要传入相应的网址，请求信息，返回格式即可，那在项目中我们可以怎么使用它呢？

1. 首先，定义一个模板抽象类TestTemplate作为测试处理的模板：
```java
public abstract class TestTemplate {
 
    public final void runTest() {
        initialize();
        executeTest();
        cleanup();
    }
 
    protected void initialize() {
        System.out.println("---执行测试用例初始化---");
        System.out.println("---开启测试环境---");
        // 执行其他初始化操作，例如连接数据库、加载配置文件等
    }
 
    protected abstract void executeTest();
 
    protected void cleanup() {
        System.out.println("---开始回收资源---");
        // 执行测试用例结束后的清理工作，例如关闭数据库连接、释放资源等
    }
 
}
```
2. 写一个验证注册场景的测试类，重写excuteTest()方法，并完成注册场景需要测试的细节 
```java
public class RegisterCaseTest extends TestTemplate {
 
    @Override
    protected void executeTest() {
        for (int i = 0; i < 100; i++) {
            System.out.println("随机生成账号密码...");
            System.out.println("验证注册信息");
            System.out.println("注册成功的信息，账号:xxx, 密码：xxx");
            System.out.println("注册失败的信息，账号:xxx, 密码：xxx");
        }
    }
 
}
```
3. 写一个验证登录场景的测试类，重写excuteTest()方法，并完成登录场景需要测试的细节 
```java
public class LoginCaseTest extends TestTemplate{
 
    @Override
    protected void executeTest() {
        System.out.println("验证token！");
        System.out.println("通过账号密码进行信息验证！");
        System.out.println("验证权限！");
        System.out.println("验证加密算法！");
    }
    
}
```
4. 因为runTest()方法已经封装好了所有的流程，所以最后直接调用模板类中的runTest()方法即可开启自动化测试。
```java
public class Test {
    public static void main(String[] args) {
        // 运行注册信息测试工具
        new RegisterCaseTest().runTest();
 
        // 运行登陆信息测试工具
        new LoginCaseTest().runTest();
    }
}
```

# 总结
1. 模板方法模式在项目中的应用是通过定义一个抽象类作为模板，将固定的流程封装在模板方法中，而其中的某些步骤可以由具体子类来实现。这样可以减少重复的代码，并提供一个统一的执行流程，使得开发者可以更方便地编写代码。
2. 一般来说在设计某些框架时会使用，因为整体流程都一致，只有某些步骤需要重写方法，来完成具体细节的实现。如JDBCTemplate,RestTemplate,RedisTemplate,MogoTemplate都是这么干的。
