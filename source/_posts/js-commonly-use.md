---
title: js中数组处理常用方法
date: 2021/06/06
tags: 前端,JS,工具类
categories: JS
description: 加快开发速度，提高开发精度
keywords: 前端,js,工具
cover: /img/md/js.jpg
---

# filter(不会改变原始数组)
>通过 callback 测试的元素会被跳过，不会被包含在新数组中。筛选出过滤出数组中符合条件的项，组成新数组。

```javascript
var arr = [2,3,4,5,6]
var morearr = arr.filter(function (number) {
    return number > 3
})
```

# every
>用于检测数组中的所有元素是否都满足指定条件（该条件为一个函数）。如果有一项不满足条件，则表达式返回false,剩余的项将不会再执行检测；如果遍历完数组后，每一项都符合条件，则返回true。

```javascript
array.every(function(currentValue,index,arr), thisValue)
```
参数说明：

第一个参数为一个回调函数，必传，数组中的每一项都会遍历执行该函数。  
currentValue：必传，当前项的值  
index：选传，当前项的索引值  
arr：选传，当前项所属的数组对象  
第二个参数thisValue为可选参数，回调函数中的this会指向该参数对象。

```javascript
var arr = [1000, 2000, 3000]
var flag = arr.every(function (a, b, c) {
    console.log(a + "===" + b + "====" + c) //1000===0====1000,2000,3000
    return a > 2000;//数组中的每个元素的值都要大于2000的情况,最后才返回true
})
console.log(flag)   //false
```

# some
>用于检测数组中的元素是否满足指定条件（函数提供）。如果有一个元素满足条件，则表达式返回true, 剩余的元素不会再执行检测。如果没有满足条件的元素，则返回false。

```javascript
var arr = [1000, 2000, 3000]
var flag = arr.some(function (a, b, c) {
    console.log(a + "===" + b + "====" + c) //1000===0====1000,2000,3000
    return a > 2000;//如果有一个元素满足条件，则表达式返回true
})
console.log(flag)   //true
```

# findIndex
>返回一个索引【下标】

```javascript

var arr7 = [
  { id: 1, name: 'lining', price: 100, num: 1 },
  { id: 2, name: 'anta', price: 200, num: 2 },
  { id: 3, name: 'nike', price: 300, num: 3 },
  { id: 4, name: 'tebu', price: 400, num: 1 },
]
var index = arr7.findIndex((item) => {
  return item.id === 1
})
 
console.log(index) //0

```

# find
>返回一个对象

```javascript
var arr8 = [
  { id: 1, name: 'lining', price: 100, num: 1 },
  { id: 2, name: 'anta', price: 200, num: 2 },
  { id: 3, name: 'nike', price: 300, num: 3 },
  { id: 4, name: 'tebu', price: 400, num: 1 },
]
 
var obj = arr8.find((item) => {
  return item.id === 2
})
 
console.log(obj) //{ id: 2, name: 'anta', price: 200, num: 2 }
```

# splice
>1个参数：截取数组中的数据返回一个新的数组，会影响原数组;从当前参数的索引开始往后截取;打印原数组返回的是没有被截取的部分数组  
2个参数：从参数1开始，到参数2的前一位结束 ，包头不包尾

```javascript
var arr9 = ['a', 'b', 'c', 'd', 'e', 'f']
console.log(arr9.splice(0, 3)) //[ 'a', 'b', 'c' ]
console.log(arr9) //[ 'd', 'e', 'f' ]
```