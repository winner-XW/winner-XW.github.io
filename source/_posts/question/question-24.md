---
title: 说明public static void main(String args[])这段声明里每个关键字什么作用？
date: 2024/04/08
tags: [Java,高级]
categories: 后端-面试题库
description: 说明public static void main(String args[])这段声明里每个关键字什么作用？
cover: /img/md/java.png
---

1. public表示权限修饰符，表明任何类或对象都可以访问这个方法；
2. static表示main()方法是一个静态方法，即方法中的代码是存储在静态存储区的，只要类被加载后，就可以使用该方法而不需要通过实例化对象来访问；
3. void表示该方法没有返回值；
4. main是JVM识别的特殊方法名，是程序的入口方法。
5. String 类来创建和操作字符串