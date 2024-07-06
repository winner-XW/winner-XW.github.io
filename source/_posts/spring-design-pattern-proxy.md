---
title: Spring设计模式-代理模式
date: 2022/02/18
tags: JAVA,SPRING,设计模式
categories: JAVA
description: 设计模式是软件开发的重要组成部分。这些解决方案不仅解决了反复出现的问题，而且还通过识别通用模式来帮助开发人员了解框架的设计。
keywords: JAVA,SPRING,设计模式
cover: /img/md/spring.jpg
---

# 代理模式
> 代理模式给某一个对象提供一个代理对象，并由代理对象控制对原对象的引用。动态代理是SpringAop的底层。

## 代理模式的分类

1. 静态代理  
由程序员创建代理类或特定工具自动生成源代码再对其编译，在程序运行前代理类的 .class 文件就已经存在了。
2. 动态代理  
在程序运行时，运用反射机制动态创建而成。

## 代理模式的优点：
- 可以使真实角色的操作更加纯粹！不用关注一些公共的业务。
- 公共业务交给代理角色，实现了业务的分工
- 公共业务扩展的时候，方便集中管理。

## 静态代理
1. 定义一个接口；
2. 被代理类实现接口；
3. 代理类引用被代理类，并且通过被代理类的方法实现接口。

![代理](/img/md/pictures/2459242-20220927180428179-1120981026.png)
```java
//租房接口
public interface rental {
    void doRental();
}
//房东
public class landlord implements rental{
    @Override
    public void doRental() {
        System.out.println("房东要出租房子");
    }
}
//中介
public class intermediary implements rental{

    private landlord landlord;

    public intermediary(landlord landlord) {
        this.landlord = landlord;
    }
    @Override
    public void doRental() {
        landlord.doRental();
        seeHouse();
        writeContract();
    }

    public void seeHouse() {
        System.out.println("中介带你看房子");
    }

    public void writeContract() {
        System.out.println("中介和你签合同");
    }
}
//租客
public class Tenants {
    public static void main(String[] args) {
        landlord landlord = new landlord();
        intermediary intermediary = new intermediary(landlord);
        intermediary.doRental();
    }
}
```
## 静态代理的缺点：
一个真实角色就会产生一个代理角色，代码量翻倍，开发效率变低。

## 动态代理
1. 接口还是上面的rental接口；
2. 代理类landlord实现接口与静态代理相同；
3. 动态代理没有代理类，而是通过java.lang.reflect.InvocationHandler和java.lang.reflect.Proxy来实现

```java
import java.lang.reflect.InvocationHandler;
import java.lang.reflect.Method;
import java.lang.reflect.Proxy;

public class ProxyInvocationHandler implements InvocationHandler {

    //被代理的接口
    private Object target;

    public void setTarget(Object target) {
        this.target = target;
    }
    //生成得到代理类
    public Object getProxy(){
        return Proxy.newProxyInstance(this.getClass().getClassLoader(),target.getClass().getInterfaces(),this);
    }

    //处理代理实例并返回结果
    @Override
    public Object invoke(Object proxy, Method method, Object[] args) throws Throwable {
        java.lang.Object result = method.invoke(target, args);
        seeHouse();
        writeContract();
        return result;
    }
}
```
这段代码适用于任何接口的动态代理，即拿即用。
我们在上面类中可以随意添加我们需要的方法，此处我将其修改如下：
```java
import java.lang.reflect.InvocationHandler;
import java.lang.reflect.Method;
import java.lang.reflect.Proxy;

public class ProxyInvocationHandler implements InvocationHandler {

    //被代理的接口
    private Object target;

    public void setTarget(Object target) {
        this.target = target;
    }
    //生成得到代理类
    public Object getProxy(){
        return Proxy.newProxyInstance(this.getClass().getClassLoader(),target.getClass().getInterfaces(),this);
    }

    //处理代理实例并返回结果
    @Override
    public Object invoke(Object proxy, Method method, Object[] args) throws Throwable {
        java.lang.Object result = method.invoke(target, args);
        seeHouse();
        writeContract();
        return result;
    }

    public void seeHouse() {
        System.out.println("中介带你看房子");
    }

    public void writeContract() {
        System.out.println("中介和你签合同");
    }
}
```
具体使用
```java
public class Tenants {
    public static void main(String[] args) {
        //被代理类
        landlord landlord = new landlord();
        ProxyInvocationHandler proxyInvocationHandler = new ProxyInvocationHandler();
        //设置动态代理的接口
        proxyInvocationHandler.setTarget(landlord);
        //获取接口
        rental rental = (rental) proxyInvocationHandler.getProxy();
        //执行具体操作
        rental.doRental();
    }
}
```