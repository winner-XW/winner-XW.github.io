---
title: GetMapping和RequestMapping的区别
date: 2024/03/21
tags: [Java,初级]
categories: 前端面试
description:  GetMapping和RequestMapping的区别
cover: /img/md/java.png
---


1. @RequestMapping是加在类上面的，所以@RequestMapping是具有类属性的，可以进行GET,POST,PUT或者其他的注解中具有的请求方法。
2. @GetMapping注解相当于标注该请求方法精确到了Get请求方法。@GetMapping是@RequestMapping方法附加了get请求方法。
3. @GetMapping是@RequestMapping的一个延伸，目的是为了提高项目的清晰度。
