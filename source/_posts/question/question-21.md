---
title: 简述什么是值传递和引用传递？
date: 2024/04/08
tags: [Java,初级]
categories: 后端-面试题库
description: 简述什么是值传递和引用传递？
cover: /img/md/java.png
---

1. 值传递：方法调用时，实际参数把它的值传递给对应的形式参数，方法执行中形式参数值的改变不影响实际参 数的值。

2. 引用传递：也称为传地址。方法调用时，实际参数的引用(地址，而不是参数的值)被传递给方法中相对应的形式参数，在方法执行中，对形式参数的操作实际上就是对实际参数的操作，方法执行中形式参数值的改变将会影响实际参数的值。