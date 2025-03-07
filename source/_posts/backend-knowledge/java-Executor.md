---
title: Java线程池
date: 2024/03/21
tags: [Java,线程池]
categories: 后端-知识学习
description: Java线程池
cover: /img/md/java.png
---

## 线程池的创建
```java
// 创建一个固定大小的线程池
ExecutorService fixedThreadPool = Executors.newFixedThreadPool(10);

// 创建一个单线程的线程池
ExecutorService singleThreadExecutor = Executors.newSingleThreadExecutor();

// 创建一个根据需要调整大小的线程池
ExecutorService cachedThreadPool = Executors.newCachedThreadPool();

// 创建一个计划任务的线程池
ScheduledExecutorService scheduledThreadPool = Executors.newScheduledThreadPool(5);
```


## 提交任务
> 创建线程池后，你可以通过`execute`方`法提交`Runnable`任务，或者通过`submit`方法提交`Callable`任务。`submit`方法会返回一个`Future`对象，你可以使用它来获取任务的结果或检查任务是否已完成。
```java
// 使用execute方法提交Runnable任务
fixedThreadPool.execute(new Runnable() {
    @Override
    public void run() {
        System.out.println("执行Runnable任务");
    }
});

// 使用submit方法提交Callable任务
Future<String> future = cachedThreadPool.submit(new Callable<String>() {
    @Override
    public String call() throws Exception {
        return "执行Callable任务的结果";
    }
});

// 获取Callable任务的执行结果
String result = future.get();

```

## 关闭线程池
> 为了优雅地关闭线程池并释放资源，你应该在完成任务后关闭线程池。这可以通过调用shutdown或shutdownNow方法来实现。
```java
// 关闭线程池，执行以前提交的任务，但不接受新任务
fixedThreadPool.shutdown();

// 尝试停止所有正在执行的任务
fixedThreadPool.shutdownNow();

```
为什么不推荐使用Thread.stop()？
- 突然中断：Thread.stop()方法会突然中断线程，这可能导致当前正在执行的任务的一半无法正常完成，从而引发数据不一致或资源泄漏等问题。
- 资源释放：使用Thread.stop()不会释放线程占用的资源，可能导致资源无法释放。
- 遗留代码：Thread.stop()是一个不推荐使用的遗留方法，Java社区推荐使用线程池的关闭方法来优雅地终止线程。

## 管理任务执行
> 线程池提供了几种方法来管理任务的执行，例如检查线程池是否关闭、等待线程池关闭、获取正在执行的任务列表等。
```java
// 检查线程池是否已经关闭
boolean isShutdown = fixedThreadPool.isShutdown();

// 等待线程池中的所有任务完成
fixedThreadPool.awaitTermination(1, TimeUnit.HOURS);

// 获取线程池中正在执行的任务列表
List<Runnable> runningTasks = fixedThreadPool.shutdownNow();

```

## 线程池的参数
线程池的参数主要用于配置线程池的行为，包括线程数量、任务队列、线程空闲时间等。以下是一些常见的线程池参数及其作用：

### 核心线程数（Core Pool Size）：
核心线程数是指始终在池中保持的线程数量，即使这些线程处于空闲状态。
只有当任务队列满了之后，线程池才会创建超过核心线程数的线程。
### 最大线程数（Maximum Pool Size）：
最大线程数是指线程池中允许的最大线程数。
一旦达到这个数量，线程池会将新提交的任务放入任务队列中，除非任务队列也满了。
### 空闲线程存活时间（Keep-Alive Time）：
空闲线程存活时间是指线程空闲时可以保持的最大时间。
超过这个时间，空闲线程将被终止，直到线程数降至核心线程数。
### 任务队列（Work Queue）：
任务队列用于存放提交给线程池的任务。
线程池通常使用阻塞队列（如LinkedBlockingQueue、ArrayBlockingQueue等）来作为任务队列。
### 线程工厂（Thread Factory）：
线程工厂用于创建新的线程。
通过自定义线程工厂，可以设置线程的名称、组等属性。
### 拒绝策略（Rejected Execution Handler）：
当任务队列满了并且线程数达到最大值时，线程池会采用拒绝策略来处理新提交的任务。
常见的拒绝策略有直接拒绝、抛出异常、将任务放入一个阻塞队列中等。
### 线程优先级（Thread Priority）：
可以通过线程工厂来设置线程的优先级。
默认情况下，新线程的优先级与主线程相同。
### 线程守护（Is Daemon）：
线程池中的线程可以是守护线程或用户线程。
守护线程会在主线程结束后自动终止。
### 指令队列（Command Queue）：
某些线程池实现（如ScheduledThreadPoolExecutor）可能使用指令队列来存储待执行的任务。

```java
ExecutorService executorService = Executors.newFixedThreadPool(10, new ThreadFactory() {
    private int count = 0;

    @Override
    public Thread newThread(Runnable r) {
        Thread t = new Thread(r);
        t.setName("Thread-" + count++);
        return t;
    }
});

```

## 自定义线程池
> 如果需要更高级的线程池特性，你可以通过ThreadPoolExecutor类来创建自定义线程池。
```java
int corePoolSize = 5;
int maximumPoolSize = 10;
long keepAliveTime = 60;
TimeUnit unit = TimeUnit.SECONDS;
BlockingQueue<Runnable> workQueue = new LinkedBlockingQueue<>();
ThreadFactory threadFactory = new ThreadFactory() {
    private int count = 0;
    @Override
    public Thread newThread(Runnable r) {
        Thread t = new Thread(r);
        t.setName("自定义线程-" + count++);
        return t;
    }
};
RejectedExecutionHandler handler = new ThreadPoolExecutor.CallerRunsPolicy();

// 创建自定义线程池
ThreadPoolExecutor executor = new ThreadPoolExecutor(corePoolSize, maximumPoolSize, keepAliveTime, unit, workQueue, threadFactory, handler);
```