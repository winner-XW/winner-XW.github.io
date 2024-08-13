---
title: JavaScript数组
date: 2021/06/06
tags: [数组,JavaScript]
categories: 前端-知识学习
description: 加快开发速度，提高开发精度
cover: /img/md/js.jpg
---


# slice()
1. slice() 方法返回一个新的数组对象，这一对象是一个由 start和 end 决定的原数组的浅拷贝（包括 start，不包括end）。  
2. 原始数组不会被改变。

```javascript
//arr.slice(start, end)
const arr = ['a','b','c','d'];
 
console.log(arr.slice(2));//删除两个，从头开始删
//["c","d"]
 
console.log(arr.slice(2, 3));//只保存（从第二开始数（不包括第二个），数到第三个）
// ["c"]
 
console.log(arr.slice(1, 4));//只保存（从第一开始数（不包括第一个），数到第四个）
//  ["b", "c", "d"]
 
console.log(arr.slice(-2));//保存后面两个
// ["c", "d"]
 
console.log(arr.slice(1, -1));//保存（从第一开始数（不包括第一个），最后一个往前开始数（不包括最后一个)
// ["b", "c"]
 
console.log(animals.slice());
//['a','b','c','d']
```

# splice()
1. splice() 方法通过删除或替换现有元素或者原地添加新的元素来修改数组,并以数组形式返回被修改的内容。array.splice(开始, 结束, 插入, 插入, ...)
2. 此方法会改变原数组。

```javascript
const arr = ['a', 'b', 'c', 'd'];
 
// 从第一个开始（不包括第一个）删除2个
console.log(arr.splice(1, 2));
 
// 从第一个开始（不包括第一个）删除0个，然后在这个位置插入e
console.log(arr.splice(1, 0, 'e'));
// ["a", "e", "b", "c", "d"]
 
//从第三个开始不包括第三个）删除1个，然后在这个位置插入e
console.log(splice(3, 1, 'e'));
// ["a", "b", "c", "e"]
```



# filter()
1. 通过 callback 测试的元素会被跳过，不会被包含在新数组中。筛选出过滤出数组中符合条件的项，组成新数组。
2. 此方法不会改变原数组。

```javascript
var arr = [2,3,4,5,6]
var morearr = arr.filter(function (number) {
    return number > 3
})
```

# push()
1. 尾部添加元素
```javascript
var array = ['a','b'];
console.log(array.push('c'))//['a','b','c']
```

# unshift()
2. 头部添加元素
```javascript
var array = ['a','b'];
console.log(array.unshift('c'))//['c','a','b']
```

# every()
1. 用于检测数组中的所有元素是否都满足指定条件（该条件为一个函数）。如果有一项不满足条件，则表达式返回false,剩余的项将不会再执行检测；如果遍历完数组后，每一项都符合条件，则返回true。

2. 参数说明：
第一个参数为一个回调函数，必传，数组中的每一项都会遍历执行该函数。  
currentValue：必传，当前项的值  
index：选传，当前项的索引值  
arr：选传，当前项所属的数组对象  
第二个参数thisValue为可选参数，回调函数中的this会指向该参数对象。

```javascript
array.every(function(currentValue,index,arr), thisValue)

var arr = [1000, 2000, 3000]
var flag = arr.every(function (a, b, c) {
    console.log(a + "===" + b + "====" + c) //1000===0====1000,2000,3000
    return a > 2000;//数组中的每个元素的值都要大于2000的情况,最后才返回true
})
console.log(flag)   //false
```

# some()
1. 用于检测数组中的元素是否满足指定条件（函数提供）。如果有一个元素满足条件，则表达式返回true, 剩余的元素不会再执行检测。如果没有满足条件的元素，则返回false。
2. some() 不会对空数组进行检测。
3. some() 不会改变原始数组。

```javascript
var arr = [1000, 2000, 3000]
var flag = arr.some(function (a, b, c) {
    console.log(a + "===" + b + "====" + c) //1000===0====1000,2000,3000
    return a > 2000;//如果有一个元素满足条件，则表达式返回true
})
console.log(flag)   //true
```

# findIndex()
1. 返回一个索引【下标】

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

# find()
1. 返回一个对象

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

# concat()
1. 用于合并两个或多个数组。此方法不会更改现有数组，而是返回一个新数组。
```javascript
const arr1 = ['a', 'b'];
const arr2 = ['c', 'd'];
const arr3 = arr1.concat(arr2);
 
console.log(array3);
// ["a", "b", "c", "d"]
 
//或者
console.log(...arr1,..arr2);// ["a", "b", "c", "d"]
```

# copyWithin()
1. 浅复制数组的一部分到同一数组中的另一个位置，并返回它，不会改变原数组的长度
2. arr.copyWithin(替换的位置, 开始位置, 结束位置)
```javascript
const arr1 = ['a', 'b', 'c', 'd', 'e'];
 
//从索引为1的开始到索引为3的（不包括索引为3的）进行删除，然后从后面开始复制，删除多少个就复制多少个，复制都是复制在前面
console.log(arr1.copyWithin(1, 3)); //['a', 'd', 'e', 'd', 'e']
 
 
const arr2 = ['a', 'b', 'c', 'd', 'e'];
 
//删除索引为0的，然后从索引为3的到索引为四（不包括四）的开始复制到删除的位置
console.log(arr2.copyWithin(0, 3, 4));//["d", "b", "c", "d", "e"]
```

# pop()
1. 删除尾部元素
```javascript
var arr = ['a','b','c'];
arr.pop();
console.log(arr);//['a','b'];
```

# shift()
1. 删除头部元素
```javascript
var arr = ['a','b','c'];
arr.shift();
console.log(arr);//['b','c'];
```

# forEach()
1. 对数组的每个元素执行一次给定的函数。
```javascript
const arr = ['a', 'b', 'c'];
 
arr.forEach(v => console.log(v);
 
// "a"
// "b"
// "c"
```


# includes()
1. 用来判断一个数组是否包含一个指定的值，根据情况，如果包含则返回 true，否则返回 false。
```javascript
const arr = ['a', 'b', 'c'];
 
console.log(arr.includes('a'));
//  true
 
console.log(pets.includes('d'));
//false
```

# indexOf()
1. 返回在数组中可以找到一个给定元素的第一个索引，如果不存在，则返回-1。
```javascript
const arr = [1,2,3,2];
 
console.log(beasts.indexOf(1));
//  0
 
// 
console.log(beasts.indexOf(4));
// -1
 
console.log(beasts.indexOf(2,2));
//4
```

# Array.isArray()
1. 用于确定传递的值是否是一个Array
```javascript
 
Array.isArray([1, 2, 3]);
// true
Array.isArray('aa');
// false
Array.isArray("{a:1");
// false
Array.isArray(undefined);
// false
```

# join()
1. 将一个数组（或一个类数组对象）的所有元素连接成一个字符串并返回这个字符串。如果数组只有一个项目，那么将返回该项目而不使用分隔符。
```javascript
const arr = ['a', 'b', 'c'];
 
console.log(arr.join());
//  "a,b,c"
 
console.log(arr.join(''));
//  "abc"
 
console.log(arr.join('-'));
//  "a-b-c"
```

# map()
1. 创建一个新数组，其结果是该数组中的每个元素是调用一次提供的函数后的返回值。
```javascript
const arr = [1, 2, 3];
 
// 
const map1 = arr1.map(x => x * 2);
 
console.log(map1);
//[2, 4, 6]
```


# reverse()
1. 将数组中元素的位置颠倒，并返回该数组。数组的第一个元素会变成最后一个，数组的最后一个元素变成第一个。该方法会改变原数组。
```javascript
const arr1 = [1, 2,3];
 
const reversed = arr1.reverse();
console.log('reversed:', reversed);
//  "reversed:" Array [3,2,1]
```

# fill()
1. 用一个固定值填充一个数组中从起始索引到终止索引内的全部元素。不包括终止索引。
2. arr.fill(填充的值, start, end)
```javascript
const arr1 = [1, 2, 3, 4];
 
console.log(arr1.fill(5, 2, 4));
// expected output: [1, 2, 5, 5]
 
// 保存一个从头开始数，其他都变为2
console.log(arr1.fill(2, 1));
//  [1, 2, 2, 2]
 
console.log(arr1.fill(6));
// [6, 6, 6, 6]
```
