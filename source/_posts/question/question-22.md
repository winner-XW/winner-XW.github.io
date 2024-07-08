---
title: Java中Exception和Error有什么区别？
date: 2024/04/08
tags: [Java,初级]
categories: 后端-面试题库
description: Java中Exception和Error有什么区别？
cover: /img/md/java.png
---

# Exception（异常）
应用程序中可能的可预测、可恢复问题。一般大多数异常表示中度到轻度的问题。异常一般是在特定环境下产生的，通常出现在代码的特定方法和操作中。在 EchoInput 类中，当试图调用 readLine 方法时，可能出现 IOException 异常。
Exception 类有一个重要的子类 RuntimeException。RuntimeException 类及其子类表示“JVM 常用操作”引发的错误。例如，若试图使用空值对象引用、除数为零或数组越界，则分别引发运行时异常（NullPointerException、ArithmeticException）和 ArrayIndexOutOfBoundException。

# Error（错误）
运行应用程序中较严重问题。大多数错误与代码编写者执行的操作无关，而表示代码运行时 JVM（Java 虚拟机）出现的问题。例如，当 JVM 不再有继续执行操作所需的内存资源时，将出现 OutOfMemoryError。

# 处理异常的方式
1. 使用try..catch..finally进行捕获；
2. 在产生异常的方法声明后面写上throws 某一个Exception类型，如throws Exception，将异常抛出到外面一层去。对于运行时异常（runtime exception），可以对其进行处理，也可以不处理。推荐不对运行时异常进行处理。

# 常见的异常
1. ArrayIndexOutOfBoundsException 数组下标越界异常
2. ArithmaticException 算数异常 如除数为零
3. NullPointerException 空指针异常
4. IllegalArgumentException 不合法参数异常

# throw和throws的区别

## throws
>用来声明一个方法可能产生的所有异常，不做任何处理而是将异常往上传，谁调用我我就抛给谁。

1. 用在方法声明后面，跟的是异常类名
2. 可以跟多个异常类名，用逗号隔开
3. 表示抛出异常，由该方法的调用者来处理
4. throws表示出现异常的一种可能性，并不一定会发生这些异常

## throw
>则是用来抛出一个具体的异常类型。

1. 用在方法体内，跟的是异常对象名
2. 只能抛出一个异常对象名
3. 表示抛出异常，由方法体内的语句处理
4. throw则是抛出了异常，执行throw则一定抛出了某种异常  