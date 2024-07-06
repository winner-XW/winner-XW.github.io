---
title: Spring设计模式-工厂模式
date: 2022/02/14
tags: JAVA,SPRING,设计模式
categories: JAVA
description: 设计模式是软件开发的重要组成部分。这些解决方案不仅解决了反复出现的问题，而且还通过识别通用模式来帮助开发人员了解框架的设计。
keywords: JAVA,SPRING,设计模式
cover: /img/md/spring.jpg
---

# 工厂模式
> 工厂模式是一种在工程中广泛应用的设计模式，对代码的解耦合起到了很大的作用。在Spring使用开发中，我们可以将Spring理解成封装了我们工程中大量重复代码的一种工具，Spring中最为重要的组件就是IOC，而IOC中非常重要的部分就是应用了工厂模式的代码。

## 工厂模式的分类

1. 简单工厂模式（ simple Factory）  
又叫做静态工厂方法（StaticFactory Method） 模式， 但不属于 23 种设计模式之一。  
简单工厂模式的实质是由一个工厂类根据传入的参数， 动态决定应该创建哪一个产品类。
2. 工厂方法模式（Factory Method）  
通常由应用程序直接使用 new 创建新的对象， 为了将对象的创建和使用相分离， 采用工厂方法模式方法,即应用程序将对象的创建及初始化职责交给工厂对象
3. 抽象工厂模式（abstract Factory）  
主要创建一个产品族，不同工厂继承父类的抽象工厂创建不同的产品族。

### 1. 简单工厂模式（ simple Factory）  

接口类car
```java
/**
 * @Project: spring
 * @description:  实现车子的接口
 * @author: sunkang
 * @create: 2018-08-29 23:06
 * @ModificationHistory who      when       What
 **/
public interface Car {
    String getName();
}
```

有三个具体的实现类
```java
/**
 * @Project: spring
 * @description:  奥迪车
 * @author: sunkang
 * @create: 2018-08-29 23:07
 * @ModificationHistory who      when       What
 **/
public class Audi implements Car {
    @Override
    public String getName() {
        return "audi";
    }
}

/**
 * @Project: spring
 * @description:奔驰车
 * @author: sunkang
 * @create: 2018-08-29 23:08
 * @ModificationHistory who      when       What
 **/
public class Benz implements Car {
    @Override
    public String getName() {
        return "benz";
    }
}

/**
 * @Project: spring
 * @description: 宝马车
 * @author: sunkang
 * @create: 2018-08-29 23:08
 * @ModificationHistory who      when       What
 **/
public class Bmw implements Car {
    @Override
    public String getName() {
        return "bmw";
    }
}
```

简单工厂的方法：
```java
/**
 * @Project: spring
 * @description: 简单工厂 根据传入不同的参数得到不同对象
 * @author: sunkang
 * @create: 2018-08-29 23:10
 * @ModificationHistory who      when       What
 **/
public class SimpleFactory  {
    public Car getCar(String name){
        if("BMW".equalsIgnoreCase(name)){
            return new Bmw();
        }else if("Benz".equalsIgnoreCase(name)){
            return new Benz();
        }else if("Audi".equalsIgnoreCase(name)){
            return new Audi();
        }else{
            System.out.println("这个产品产不出来");
            return null;
        }
    }
}
```


### 2. 工厂方法模式（Factory Method）
```java
/**
 * @Project: spring 
 * @description:  造车工厂的接口
 * @author: sunkang
 * @create: 2018-08-30 22:33
 * @ModificationHistory who      when       What
 **/
public interface Factory {
     Car getCar();
}

/**
 *生产奥迪的工厂
 */
public class AudiFactory implements Factory {
    @Override
    public Car getCar() {
        return new Audi();
    }
}

/**
 *生产奔驰的工厂
 */
public class BenzFactory implements Factory {
    @Override
    public Car getCar() {
        return new Benz();
    }
}

/**
 * 生产宝马的工厂
 */
public class BmwFactory implements Factory {
    @Override
    public Car getCar() {
        return new Bmw();
    }
}
```

```java
/**
 * 工厂方法的测试类
 */
public class FactoryTest {
    public static void main(String[] args) {
        //1.首先先创建一个奥迪工厂出来
        Factory factory = new AudiFactory();
        //2.然后根据工厂得到奥迪车，具体的造车工厂交给工厂来完成
        System.out.println(factory.getCar());
        factory = new BmwFactory();
        System.out.println(factory.getCar());
    }
}
```

### 3. 抽象工厂模式（abstract Factory）

抽象工厂
```java
public abstract class AbstractFactory {
  /**
   * 得到奥迪的车
   * @return
   */
  public abstract Car getAudiCar();
  /**
   * 得到奔驰的车
   * @return
   */
  public abstract Car getBenzCar();
  /**
   * 得到宝马的车
   * @return
   */
  public abstract Car getBmwCar();
}
```

抽象工厂的具体实现
```java
/**
 * @Project: spring
 * @description:  抽象工厂的具体实现
 * @author: sunkang
 * @create: 2018-09-01 19:37
 * @ModificationHistory who      when       What
 **/
public class CarFactory extends  AbstractFactory {
    @Override
    public Car getAudiCar() {
        return new Audi();
    }
    @Override
    public Car getBenzCar() {
        return new Benz();
    }
    @Override
    public Car getBmwCar() {
        return new Bmw();
    }
}
```

```java
public class AbstractFactoryTest {
    public static void main(String[] args) {
        //1.先创建具体抽象工厂
        AbstractFactory abstractFactory = new CarFactory();
        //2.根据具体的抽象工厂得到车
        Car audi  = abstractFactory.getAudiCar();
        System.out.println(audi.getName());
    }
}
```

## 工厂模式在spring中的体现

>Spring Bean 的创建是典型的工厂模式， 这一系列的 Bean 工厂， 也即 IOC 容器为开发者管理对象间的依赖关系提供了很多便利和基础服务， 在 Spring 中有许多的 IOC 容器的实现供用户选择和使用。

## BeanFactory和FactoryBean的区别

### BeanFactory
>用于访问Spring bean容器的根接口。这是Spring bean容器的基本客户端视图。原来是获取Spring Bean的接口，也就是IoC容器。  
原来我们更常用的ApplicationContext就是一个BeanFactory。我们通过bean的名称或者类型都可以从BeanFactory来获取bean。

### FactoryBean
>FactoryBean 也是接口，为IOC容器中Bean的实现提供了更加灵活的方式，FactoryBean在IOC容器的基础上给Bean的实现加上了一个简单的工厂模式和装饰模式，我们可以在getObject()方法中灵活配置。

### 区别
>FactoryBean是个Bean.在Spring中，所有的Bean都是由BeanFactory(也就是IOC容器)来进行管理的。但对FactoryBean而言，这个Bean不是简单的Bean，而是一个能生产或者修饰对象生成的工厂Bean,它的实现与设计模式中的工厂模式和修饰器模式类似。