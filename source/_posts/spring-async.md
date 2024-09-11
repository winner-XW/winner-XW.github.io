---
title: Spring Async
date: 2024/09/10
tags: [Java,SPRING,Async]
categories: 后端-知识学习
description: Async注解用于声明一个方法是异步的。当在方法上加上这个注解时，Spring 将会在一个新的线程中执行该方法，而不会阻塞原始线程。这对于需要进行一些异步操作的场景非常有用，比如在后台执行一些耗时的任务而不影响前台响应。
cover: /img/md/spring.jpg
---

# @Async注解介绍
@Async注解用于声明一个方法是异步的。当在方法上加上这个注解时，Spring 将会在一个新的线程中执行该方法，而不会阻塞原始线程。这对于需要进行一些异步操作的场景非常有用，比如在后台执行一些耗时的任务而不影响前台响应。
```java
@Service
public class MyService {
    @Async
    public void asyncMethod() {
        // 异步执行的代码
    }
}
// 在上面的例子中，asyncMethod 方法使用 @Async 注解标记，表示该方法将在一个独立的线程中执行。
```

## @Async存在的问题或注意事项
### 线程池问题
上面说到，如果直接使用@Async注解，Spring就会直接使用SimpleAsyncTaskExecutor线程池。
既没有重用线程，也没有设置最大线程数，所以在并发量大的时候会产生严重的性能问题！所以一般在生产环境，特别是 toc 的项目，不建议直接使用 @Async 注解，应该使用自定义线程池搭配 @Async 注解一起使用！

### 如何配置@Async的自定义线程池呢？
在Spring中，我们可以通过实现AsyncConfigurer接口或者直接继承AsyncConfigurerSupport类来自定义Async异步线程池；
线程池可以直接使用 JDK 提供的ThreadPoolExecutor或者Spring本身也提供的TaskExecutor的实现类，Spring的实现类有以下五种，其中使用最多的就是 ThreadPoolTaskExecutor。
- SimpleAsyncTaskExecutor：不是真的线程池，这个类不重用线程，每次调用都会创建一个新的线程。
- SyncTaskExecutor：这个类没有实现异步调用，只是一个同步操作。只适用于不需要多线程的地
- ConcurrentTaskExecutor：Executor的适配类，不推荐使用。如果ThreadPoolTaskExecutor不满足要求时，才用考虑使用这个类
- ThreadPoolTaskScheduler：可以使用cron表达式
- ThreadPoolTaskExecutor：最常使用，推荐。其实质是对java.util.concurrent.ThreadPoolExecutor的包装

以ThreadPoolTaskExecutor为例来自定义一个线程池：
```java
@Configuration
@EnableAsync
public class AsyncConfig implements AsyncConfigurer {
    @Bean
    @Override
    public Executor getAsyncExecutor() {
        ThreadPoolTaskExecutor executor = new ThreadPoolTaskExecutor();
        executor.setCorePoolSize(10);
        executor.setMaxPoolSize(20);
        executor.setQueueCapacity(200);
        executor.setThreadNamePrefix("async-");
        executor.initialize();
        return executor;
    }
}
```

### 与@Transactional联用问题
当然，使用@Async还有一些别的注意事项，比如与@Transcational联用时，它们在同一个方法上同时使用时可能导致异步失效。这是因为 @Async 通常会使用一个新的线程，而新线程无法继承原始线程的事务上下文。

解决办法是将@Asyn 注解放在另外的类或者方法上，确保异步方法被另外的代理类包装。这样，异步方法就能够在独立的线程中执行，同时也能够继承事务上下文。
```java
@Service
public class MyService {
    @Async
    public void asyncMethodWithTransaction() {
        transactionalMethod();
    }
    @Transactional
    public void transactionalMethod() {
        // 事务性操作的代码
    }
}
```

### 循环依赖问题
现在有两个类，ServiceA 和 ServiceB 如下：
```java
@Service
public class ServiceA {
 
    private final ServiceB serviceB;
 
    @Autowired
    public ServiceA(ServiceB serviceB) {
        this.serviceB = serviceB;
    }
 
    @Async
    public void asyncMethod() {
        // 异步方法逻辑
    }
}

@Service
public class ServiceB {
 
    private final ServiceA serviceA;
 
    @Autowired
    public ServiceB(ServiceA serviceA) {
        this.serviceA = serviceA;
    }
}
```

其中serviceA、serviceB对象之间相互依赖，serviceA和serviceB总有一个会先实例化，而serviceA或serviceB里面使用了@Async注解，会导致循环依赖异常：
>org.springframework.beans.factory.BeanCurrentlyInCreationException
在springboot中，以上报错被捕捉，抛出的异常是：
>The dependencies of some of the beans in the application context form a cycle

我们知道，spring三级缓存一定程度上解决了循环依赖问题。A对象在实例化之后，属性赋值【opulateBean(beanName, mbd, instanceWrapper)】执行之前，将ObjectFactory添加至三级缓存中，从而使得在B对象实例化后的属性赋值过程中，能从三级缓存拿到ObjectFactory，调用getObject()方法拿到A的引用，B由此能顺利完成初始化并加入到IOC容器。此时A对象完成属性赋值之后，将会执行初始化【initializeBean(beanName, exposedObject, mbd)方法】，重点是@Async注解的处理正是在这地方完成的，其对应的后置处理器AsyncAnnotationBeanPostProcessor，在postProcessAfterInitialization方法中将返回代理对象，此代理对象与B中持有的A对象引用不同，导致了以上报错。

解决办法:
1. 在A类上加@Lazy，保证A对象实例化晚于B对象
2. 不使用@Async注解，通过自定义异步工具类发起异步线程（线程池）
3. 不要让@Async的Bean参与循环依赖