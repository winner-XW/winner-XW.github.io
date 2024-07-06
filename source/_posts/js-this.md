---
title: Js中的this指向
date: 2022/09/16
tags: 前端,JS,this
categories: JS
description: 任何一门语言中，相信this的指向问题都是一个重点，js也不例外
keywords: 前端,JS,this
cover: /img/md/js.jpg
---

# 函数内的this
> 普通函数内的this分为两种情况，严格模式下和非严格模式下。

## 严格模式下
```javascript
function test() {
  'use strict'
  console.log(this);
}
test(); //undefined
window.test(); //window
```
## 非严格模式下

```javascript
function test() {
  console.log(this);
}
test(); //window
window.test(); //window
```
> 在普通函数中this指向window、匿名函数的this也指向的是window

# 对象中的this
> 对象内部方法的this指向调用这些方法的对象，也就是谁调用就指向谁

```javascript
let obj = {
  name: 'test',
  skill: function() {
    name: 'test2',
    console.log(this.name);
  }
}
obj.skill(); //test
```
> 函数的定义位置不影响其this指向，this指向只和调用函数的对象有关。
> 多层嵌套的对象，内部方法的this指向离被调用函数最近的对象。

# 箭头函数中的this
> 箭头函数：this指向于函数作用域所用的对象。

- 箭头函数的重要特征：箭头函数中没有this和arguments，是真的没有！
- 箭头函数没有自己的this指向，它会捕获自己定义所处的外层执行环境，并且继承这个this值,指向当前定义时所在的对象。箭头函数的this指向在被定义的时候就确定了，之后永远都不会改变。即使使用call()、apply()、bind()等方法改变this指向也不可以。

```javascript
let obj = {
  name: 'test',
  functions: () => {
    console.log(this);
  }
}
obj.functions(); //window
```

# 构造函数中的this
> 构造函数中的this是指向实例。

```javascript
function Person(name,age,sex) {
  this.name = name;
  this.age = age;
  this.sex = sex;
}
let p = new Person('wcc',18,'boy');
console.log(p.name); //wcc
console.log(p.age); //18
console.log(p.sex); //boy
```

# 原型链中的this
> this这个值在一个继承机制中，仍然是指向它原本属于的对象，而不是从原型链上找到它时，它所属于的对象。

# 改变this指向的方法
## call
> `call(a, b, c)`方法接收三个参数，第一个是this指向，第二个，三个是传递给函数的实参，可以是数字，字符串，数组等类型的数据类型都可以。

```javascript
//定义函数
function fn(n1,n2){
   console.log(this);  
   console.log(n1,n2)
}
//调用call()方法
fn.call();//=>this:window;
let obj = {fn:fn};
fn.call(obj);//=>this:obj;n1,n2:undefined
fn.call(1,2);//=>this: 1;n1=2,n2=undefined;
fn.call(obj,1,2);//=>this: obj;n1=1,n2=2;

//Call方法的几个特殊属性
//非严格模式下
fn.call(undefined);//this=>window
fn.call(null);//this=>window
//严格模式下
"use strict"
fn.call(undefined);//this=>undefined
fn.call(null);//this=>null

```

## apply
> `apply(a, [b])`和call基本上一致，唯一区别在于传参方式，apply把需要传递给fn()的参数放到一个数组（或者类数组）中传递进去，虽然写的是一个数组，但是也相当于给fn()一个个的传递。
> 
```javascript
//apply方法的使用和call方法基本相同，唯一的区别是，apply方法传参要求是数组类型的，数组内可以任意形式的数据
function fn (n1,n2){
    console.log(this);
    console.log(n1,n2)
    console.log(arguments)
}
let obj = {fn:fn};
//调用apply()方法
fn.applay(obj,[1,2]);
fn.applay(obj,1,2)；//报错

fn.applay(obj,[11,'apply',{a:123}]);//注意第二个参数必须是数组，否则会报错
```

## bind

> bind（a, b, c）：语法和call一模一样，区别在于立即执行还是等待执行，bind不兼容IE6~8
> bind与call的唯一区别就是call直接改变函数test的指向，而bind是生成了一个新函数test2()，该函数改变了指向。
```javascript
//call()方法：改变fn中的this，并且把fn立即执行
fn.call(obj, 1, 2); 
//bind()方法：改变fn中的this，fn并不执行
fn.bind(obj, 1, 2); 
```
```javascript
//bind和call方法调用形式类似，但是原理完全不同
fn.call(obj,10,20);//=>fn先执行，将fn内的this指向obj，并且把参数10,20传递给fn

fn.bind(obj,10,20)//bind是先将fn中的this指向obj，并且将参数10,20预先传递给fn，但是此时的fn并没有被执行，只有fn执行时this指向和传递参数才有作用
fn.bind(obj,10,20);//=>不会有任何输出
fn.bind(obj,10,20)();//=>调用后才会有输出

//=>需求：点击box这个盒子的时候，需要执行fn，并且让fn中的this指向obj
oBox.onclick=fn; //=>点击的时候执行了fn,但此时fn中的this是oBox

oBox.onclick=fn.call(opp); //=>绑定事件的时候就已经把fn立即执行了(call本身就是立即执行函数),然后把fn执行的返回值绑定给事件

oBox.onclick=fn.bind(opp);
//=>fn.bind(opp)：fn调取Function.prototype上的bind方法，执行这个/* 
 * function(){
 *     fn.call(opp);
 * }
 */
oBox.onclick=function(){
   //=>this:oBox
    fn.call(opp);
}

```

相同点：
- call、apply和bind都是JS函数的公有的内部方法，他们都是重置函数的this，改变函数的执行环节。

不同点：
- bind是创建一个新的函数，而call和aplay是用来调用函数；
- call和apply作用一样，只不过call为函数提供的参数是一个个地罗列出来，而apply为函数提供的参数是一个数组
