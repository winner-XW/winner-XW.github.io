---
title: for、forEach和map的区别?
date: 2023/02/08
tags: [前端,中级]
categories: 前端-面试题库
description: for循环与forEach 的区别?
cover: /img/md/js.jpg
---

# for和forEach的不同点
1. for 循环可以使用 break 跳出循环，但 forEach 不能。
2. for 循环可以控制循环起点（i初始化的数字决定循环的起点）， forEach 只能默认从索引 0 开始。
3. for 循环过程中支持修改索引（修改 i ），但 forEach 做不到（底层控制 index 自增，无法左右它）。

# map和foreach的共同点
1. 都是循环遍历数组中的每一项。
2. forEach()和map()里面每一次执行匿名函数都支持3个参数：数组中的当前项item,当前项的索引index,原始数组input。
3. 匿名函数中的this都是指Window。
4. 只能遍历数组。

# map和foreach的不同点
1. forEach()：没有返回值，即返回值为undefined
理论上这个方法是没有返回值的，仅仅是遍历数组中的每一项，不对原来数组进行修改；但是可以自己通过数组的索引来修改原来的数组，或当数组项为对象时修改对象中的值；
2. map()：有返回值，可以return 出来。
区别：map的回调函数中支持return返回值；return的是啥，相当于把数组中的这一项变为啥（并不影响原来的数组，只是相当于把原数组克隆一份，把克隆的这一份的数组中的对应项改变了）；
3. forEach()返回值是undefined，不可以链式调用。
4. map()返回一个新数组，原数组不会改变。