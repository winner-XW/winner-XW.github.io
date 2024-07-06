---
title: 数组对象分组引发的思考
date: 2023/08/06
tags: 前端,JS,闭包
categories: JS
description: 根据特定的key完成数组分组
keywords: 前端,JS,分组
cover: /img/md/js.jpg
---

# 通常做法
>循环数组，找到指定相同的key，进行分组

比如下面的代码：

```javascript
const people = [
  {name: 'test1', age: 25, sex:'male', tel: '17853538076'},
  {name: 'test2', age: 23, sex:'female', tel: '17853538071'},
  {name: 'test3', age: 22, sex:'male', tel: '17853538072'},
  {name: 'test4', age: 25, sex:'female', tel: '17853538073'},
  {name: 'test5', age: 22, sex:'male', tel: '17853538077'}
]
function groupBy(arr, propName) {
  const result = {};
  for (const item of arr) {
    const key = item[propName];
    if (!result[key]) {
      result[key] = [];
    }
    result[key].push(item);
  }
  return result;
}
// 根据姓名分组
groupBy(people, 'sex');
// 根据年龄分组
groupBy(people, 'age');

```

# 针对数组对象组合式分组怎么去做？
> 我们发现共同方法里面变化的值主要是key，那我们可以动态的去找key，利用函数的方式，最后参数归一化处理，利用基本数据类型判断即可。

比如下面的代码：

```javascript
const people = [
  {name: 'test1', age: 25, sex:'male', tel: '17853538076', address: {
    provice: '山东省',
    city: '聊城市'
  }},
  {name: 'test2', age: 23, sex:'female', tel: '17853538071', address: {
    provice: '山东省',
    city: '烟台市'
  }},
  {name: 'test3', age: 22, sex:'male', tel: '17853538072', address: {
    provice: '山东省',
    city: '聊城市'
  }},
  {name: 'test4', age: 25, sex:'female', tel: '17853538073', address: {
    provice: '山东省',
    city: '聊城市'
  }},
  {name: 'test5', age: 22, sex:'male', tel: '17853538077', address: {
    provice: '山东省',
    city: '烟台市'
  }}
]
function groupBy(arr, generateKey) {
  if (typeof generateKey === 'string') {
    const propName = generateKey;
    generateKey = (item) => item[propName];
  }
  const result = {};
  for (const item of arr) {
    const key = generateKey(item);
    if (!result[key]) {
      result[key] = [];
    }
    result[key].push(item);
  }
  return result;
}
// 根据年龄分组
groupBy(people, 'age');

// 根据年龄性别分组
groupBy(people, (item) => `${item.age}-${item.sex}`);

// 根据省份分组
groupBy(people, (item) => item.address.provice);

// 根据城市分组
groupBy(people, (item) => item.address.city);
```
