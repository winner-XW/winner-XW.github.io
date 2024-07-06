---
title: 闭包
date: 2021/08/06
tags: 前端,JS,闭包
categories: JS
description: 闭包就是能够读取其他函数内部变量的函数
keywords: 前端,JS,闭包
cover: /img/md/js.jpg
---

# 什么是闭包？
>由于在Javascript语言中，只有函数内部的子函数才能读取局部变量，闭包就是能够读取其他函数内部变量的函数。所以，在本质上，闭包就是将函数内部和函数外部连接起来的一座桥梁。

比如下面的代码：

```javascript
function f1() {
    var n = 999;
    function f2() {
    console.log(n);
    }
    return f2;
}
var result = f1();
result();//999
```

- 函数f2就被包括在函数f1内部，这时f1内部的所有局部变量，对f2都是可见的。但是反过来就不行，f2内部的局部变量，对f1就是不可见的。
- 这就是Javascript语言特有的"链式作用域"结构（chain scope），子对象会一级一级地向上寻找所有父对象的变量。所以，父对象的所有变量，对子对象都是可见的，反之则不成立。
- 既然f2可以读取f1中的局部变量，那么只要把f2作为返回值，就可以在f1外部读取它的内部变量了。

# 闭包的使用场景

## setTimeout
> 原生的setTimeout传递的第一个函数不能带参数，通过闭包可以实现传参效果。
```javascript
function f1(a) {
    function f2() {
        console.log(a);
    }
    return f2;
}
var fun = f1(1);
setTimeout(fun,1000);//一秒之后打印出1
```

## 回调
>定义行为，然后把它关联到某个用户事件上（点击或者按键）。代码通常会作为一个回调（事件触发时调用的函数）绑定到事件。
比如下面这段代码：

```html
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>测试</title>
</head>
<body>
    <a href="#" id="size-12">12</a>
    <a href="#" id="size-20">20</a>
    <a href="#" id="size-30">30</a>

    <script type="text/javascript">
        function changeSize(size){
            return function(){
                document.body.style.fontSize = size + 'px';
            };
        }

        var size12 = changeSize(12);
        var size14 = changeSize(20);
        var size16 = changeSize(30);

        document.getElementById('size-12').onclick = size12;
        document.getElementById('size-20').onclick = size14;
        document.getElementById('size-30').onclick = size16;

    </script>
</body>
</html>
```
当点击数字时，字体也会变成相应的大小。

## 函数防抖
>在事件被触发n秒后再执行回调，如果在这n秒内又被触发，则重新计时。实现的关键就在于setTimeOut这个函数，由于还需要一个变量来保存计时，考虑维护全局纯净，可以借助闭包来实现。

如下代码所示：
```javascript
/*
* fn [function] 需要防抖的函数
* delay [number] 毫秒，防抖期限值
*/
function debounce(fn,delay){
    let timer = null    //借助闭包
    return function() {
        if(timer){
            clearTimeout(timer) //进入该分支语句，说明当前正在一个计时过程中，并且又触发了相同事件。所以要取消当前的计时，重新开始计时
            timer = setTimeOut(fn,delay) 
        }else{
            timer = setTimeOut(fn,delay) // 进入该分支说明当前并没有在计时，那么就开始一个计时
        }
    }
}
```

## 封装私有变量
>用js创建一个计数器

### 方法1
```javascript
function f1() {
    var sum = 0;
    var obj = {
       inc:function () {
           sum++;
           return sum;
       }
    };
    return obj;
}
let result = f1();
console.log(result.inc());//1
console.log(result.inc());//2
console.log(result.inc());//3
```

在返回的对象中，实现了一个闭包，该闭包携带了局部变量x，并且，从外部代码根本无法访问到变量x。

### 方法2

```javascript
function f1() {
    var sum = 0;
    function f2() {
        sum++;
        return f2;
    }
    f2.valueOf = function () {
        return sum;
    };
    f2.toString = function () {
        return sum+'';
    };
    return f2;
}
//执行函数f1，返回的是函数f2
console.log(+f1());//0
console.log(+f1()())//1 
console.log(+f1()()())//2
```

所有js数据类型都拥有valueOf和toString这两个方法，null除外
valueOf()方法：返回指定对象的原始值。
toString()方法：返回对象的字符串表示。
在数值运算中，优先调用了valueOf，字符串运算中，优先调用toString
sum+' '是一个字符串类型的数据