---
title: Java线程的创建方式
date: 2024/03/21
tags: java,线程
categories: JAVA
description: Java线程的创建方式
keywords: java,线程
cover: /img/md/java.png
---


## 继承Thread类
> 这是创建线程的一种最基本方法。你可以创建一个新类，该类继承自java.lang.Thread类，并重写run()方法。然后创建该类的实例，并调用它的start()方法来启动线程。

```java
class MyThread extends Thread {
    @Override
    public void run() {
        // 线程执行的代码
    }
}

public class Main {
    public static void main(String[] args) {
        MyThread myThread = new MyThread();
        myThread.start();
    }
}
```
## 实现Runnable接口
> 另一种创建线程的方法是实现java.lang.Runnable接口。你需要重写run()方法，并将实现Runnable接口的类的实例传递给Thread对象。然后，通过Thread对象的start()方法启动线程。

```java
class MyRunnable implements Runnable {
    @Override
    public void run() {
        // 线程执行的代码
    }
}

public class Main {
    public static void main(String[] args) {
        MyRunnable myRunnable = new MyRunnable();
        Thread thread = new Thread(myRunnable);
        thread.start();
    }
}

```

## 使用Executor框架
> 从Java 5开始，可以使用java.util.concurrent包中的Executor框架来管理线程。这个框架提供了线程池等高级功能，可以简化线程的使用和管理。

```java
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;

public class Main {
    public static void main(String[] args) {
        ExecutorService executorService = Executors.newFixedThreadPool(10);
        executorService.execute(new MyRunnable());
        executorService.shutdown();
    }
}

```

## 使用Callable和Future
> 如果你需要在执行线程任务时获取返回结果，可以使用java.util.concurrent.Callable接口代替Runnable接口。同时，可以使用Future对象来获取线程执行的结果。

```java
import java.util.concurrent.Callable;
import java.util.concurrent.FutureTask;

class MyCallable implements Callable<Integer> {
    @Override
    public Integer call() {
        // 线程执行的代码
        return 1;
    }
}

public class Main {
    public static void main(String[] args) {
        FutureTask<Integer> futureTask = new FutureTask<>(new MyCallable());
        Thread thread = new Thread(futureTask);
        thread.start();
        try {
            Integer result = futureTask.get();
            System.out.println("Result: " + result);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
```

每种创建线程的方法都有其适用场景。
1. 继承Thread类方式简单直观，但会导致类层次结构变得复杂。
2. 实现Runnable接口方式更加灵活，允许同一个类实现多个接口。
3. 使用Executor框架可以更高效地管理线程，适用于需要大量短生命周期线程的场景。
4. 使用Callable和Future可以方便地获取线程执行的结果。