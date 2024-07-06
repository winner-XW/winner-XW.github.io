---
title: js几种循环方式
date: 2021/06/05
tags: 前端,JS,循环
categories: JS
description: 循环可以将代码块执行指定的次数
keywords: 前端,js,循环,for
cover: /img/md/js.jpg
---

# for循环
>最基本的循环方式，不多说。这种最基本的循环才是速度最快的，效率最高的。

```javascript
for(var i = 0;i<5;i++){
  console.log(i)
}
```

# for in循环
>用来遍历对象的。要知道JavaScript对象的所有属性都是字符串，不过属性对应的值可以是任意数据类型。（注意：遍历时不仅能读取对象自身上面的成员属性，也能遍历出对象的原型属性）

```javascript
let obj = {a:1, b:2, c:3};
for (let prop in obj) {  //prop指对象的属性名
  //输出: a,1 b,2 c,3
  console.log(prop, obj[prop]);
}   
```

# for of循环
>作为ES6新增的循环方法，这个方法避开了for-in循环的所有缺陷。而且，它可以正确响应break、continue和return语句。for-of循环不仅支持数组，还支持大多数类数组对象，例如DOM NodeList对象。但是for of也有一个致命伤，就像例子看到的，没有索引。对，这是优点也是缺点。遍历数组对象，直接就是item.属性(或者item[属性]),而不用像for循环那样arr[index].属性(arrindex)。但是你有的时候真的就得用到index。不好意思，只能把数组转成Map()。但我觉得真的需要用到index，还是换成forEach吧。

```javascript
let arr = ['123','qwewq','sfds'];
for(let item of arr){
  //输出 '123' 'qwewq' 'sfds'
  console.log(item); //item指的的就是数组每一项的值。不是索引。
}
```

# forEach循环
>里面没办法用break跳出循环。而且在IE中无法实现，需要做兼容处理。没有 return 返回值。

```javascript
let arr = ['123','qwewq','sfds'];
myArray.forEach(function (value, index) {
  // 输出结果 '123',1  'qwewq',2  'sfds',3
  console.log(value,index);
});
```

# map循环
>将原有的数组映射成一个新数组，不操作原数组，返回新数组，回调函数中返回什么这一项就是什么。forEach、map都是ECMA5新增数组的方法。map支持return。

```javascript
let arr = ['123','qwewq','sfds'];
arr.map(function(value,index){
  // 输出结果 '123',1  'qwewq',2  'sfds',3
  console.log(value,index);
});
```

# 性能排序
for > for-of > forEach > filter > map > for-in