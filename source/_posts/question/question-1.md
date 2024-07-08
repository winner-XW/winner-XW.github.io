---
title: 什么是PromiseLike？
date: 2023/02/06
tags: [前端,初级]
categories: 前端-面试题库
description: PromiseLike是一个用于表示类似于Promise的对象的接口
cover: /img/md/js.jpg
--- 

>PromiseLike是一个用于表示类似于Promise的对象的接口

# 代码实现
```javascript
/**
 * 判断一个值是不是PromiseLike
 */
function isPromiseLike(value) {
  return (value !== null 
  && (typeof value === 'object' || typeof value === 'function') 
  && typeof value.then === 'function')
}
```
