---
title: Javascipt中async await 和promise和generator有什么区别
date: 2024/04/07
tags: [前端,高级]
categories: 前端面试
description: Javascipt中async await 和promise和generator有什么区别
cover: /img/md/js.jpg
---

## Promise
>Promise 是异步编程的一种解决方案，比传统的解决方案——回调函数和事件——更合理和更强大。所谓Promise，简单说就是一个容器，里面保存着某个未来才会结束的事件（通常是一个异步操作）的结果。

### 特点：
1. 对象的状态不受外界影响。Promise对象代表一个异步操作，有三种状态：pending（进行中）、fulfilled（已成功）和rejected（已失败）。
2. 一旦状态改变，就不会再变，任何时候都可以得到这个结果。

### 缺点
1. 无法取消Promise，一旦新建它就会立即执行，无法中途取消。
2. 如果不设置回调函数，Promise内部抛出的错误，不会反应到外部。
3. 当处于pending状态时，无法得知目前进展到哪一个阶段（刚刚开始还是即将完成）。

## generator/yield
>Generator 函数是 ES6 提供的一种异步编程解决方案，语法行为与传统函数完全不同。

### 语法上
首先可以把它理解成，Generator 函数是一个状态机，封装了多个内部状态。
### 形式上
Generator 函数是一个普通函数，但是有两个特征。
1. function关键字与函数名之间有一个星号；
2. 函数体内部使用yield表达式，定义不同的内部状态（yield在英语里的意思就是“产出”）。
 
Generator 函数的调用方法与普通函数一样，也是在函数名后面加上一对圆括号。
不同的是，调用 Generator 函数后，该函数并不执行，返回的也不是函数运行结果，而是一个指向内部状态的指针对象，也就是遍历器对象（Iterator Object）。
下一步，必须调用遍历器对象的next方法，使得指针移向下一个状态。也就是说，每次调用next方法，内部指针就从函数头部或上一次停下来的地方开始执行，直到遇到下一个yield表达式（或return语句）为止。
yield表达式后面的表达式，只有当调用next方法、内部指针指向该语句时才会执行，因此等于为 JavaScript 提供了手动的“惰性求值”（Lazy Evaluation）的语法功能。


## async/await
>async函数就是将 Generator 函数的星号（*）替换成async，将yield替换成await，仅此而已。

### async函数对 Generator 函数的改进
1. 内置执行器: async函数自带执行器,使用方法为 asyncReadFile()
2. 更好的语义: async表示函数里有异步操作,await表示紧跟再后面的表达式需要等待结果
3. 更广的适用性: yield命令后,只能是Thunk函数或Promise对象,而async函数的await命令后面,可以是Promise对象和原始类型的值
4. 返回值是Promise对象,可以使用then方法指定下一步操作

### 使用注意点
1. await命令后面的Promise对象，运行结果可能是rejected，所以最好把await命令放在try...catch代码块中。
2. 多个await命令后面的异步操作，如果不存在继发关系（比较耗时），最好让它们同时触发。
3. await命令只能用在async函数之中，如果用在普通函数，就会报错。

## 总结
 Promise 的写法比回调函数的写法大大改进，但是一眼看上去，代码完全都是 Promise 的 API（then、catch等等），操作本身的语义反而不容易看出来。
 Generator 函数语义比 Promise 写法更清晰，这个写法的问题在于，必须有一个任务运行器，自动执行 Generator 函数。
 Async 函数的实现最简洁，最符合语义，几乎没有语义不相关的代码。
 它将 Generator 写法中的自动执行器，改在语言层面提供，不暴露给用户，因此代码量最少。
 如果使用 Generator 写法，自动执行器需要用户自己提供。