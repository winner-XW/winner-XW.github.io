---
title: JavaScript阻止事件冒泡的方法？
date: 2024/04/07
tags: [前端,初级]
categories: 前端-面试题库
description: JavaScript阻止事件冒泡的方法？
cover: /img/md/js.jpg
---

比如现在有一个子盒子和一个父盒子，子盒子和父盒子二者都有点击事件，但是此时，当我们点击子盒子时，只想让子盒子显示点击事件。这里我们就要用到阻止事件冒泡的方法来隔断父盒子的事件显示。
我们应该怎样阻断父盒子的点击事件呢？

可以直接在子盒子内部的点击事件里面添加stopPropagation()方法
如下所示：
```javascript
son.addEventListener('click',function(e){
alert('son');
e.stopPropagation();
},false)
```
但是需要注意的是：这个方法也有兼容性问题，在低版本浏览器中（IE 6-8 ）通常是利用事件对象cancelBubble属性来操作的。即直接在相应的点击事件里面添加：
`e.cancelBubble = true;`
如果我们想要解决这种兼容性问题，就可以采用下述方法：
```javascript
if(e && e.stopPropagation){
e.stopPropagation();
}else{
window.event.cancelBubble = true;
}
```