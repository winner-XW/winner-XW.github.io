---
title: iphoneX样式适配
date: 2021/12/24
tags: CSS,刘海
categories: CSS
description: 在手机的迭代更新中越来越多的手机不断的更新出世，各种样式层出不起。
keywords: CSS,刘海
cover: /img/md/css.jpg
---

# 问题描述
>iPhoneX由于新增了刘海以及取消了按键采用了小黑条的形式，导致会出现以下的问题：样式边缘出现了空白（没有覆盖整个可视区域）

![可视区域](/img/md/css-iphoneX/default-inset-behavior.png)

我们可以通过meta设置解决这个问题
```html
<meta name='viewport' content='initial-scale=1, viewport-fit=cover'>
```

![全屏模式](/img/md/css-iphoneX/viewport-fit-cover.png)

于是出现了新的问题，部分内容被刘海和黑条遮盖了，接下来就有两种解决方案：

# 多媒体查询
```css
//iphoneX、iphoneXs
@media only screen and (device-width: 375px) and (device-height: 812px) and (-webkit-device-pixel-ratio: 3) {
}
即: 设备屏幕可见宽度为375px， 可见高度为812px及设备像素比为3
 
//iphone Xs Max
@media only screen and (device-width: 414px) and (device-height: 896px) and (-webkit-device-pixel-ratio:3) {
}
 
//iphone XR
@media only screen and (device-width: 414px) and (device-height: 896px) and (-webkit-device-pixel-ratio:2) {
}

//横屏
@media all and (orientation : landscape) { 
} 
 
//竖屏
@media all and (orientation : portrait){ 
}
```

# 苹果特定变量
>`env()`最初由iOS浏览器提供，用于允许开发人员将其内容放置在视口的安全区域中，该规范中定义的`safe-area-inset-*` 值可用于确保内容即使在非矩形的视区中也可以完全显示。

![全屏模式](/img/md/css-iphoneX/safe-areas-1.png)

注意：viewport-fit=cover和env(safe-area-inset-bottom)需要一起使用

```html
<meta name='viewport' content='initial-scale=1, viewport-fit=cover'>
```

```css
// @supports意为支持
// bottom: constant(safe-area-inset-bottom)) 或 bottom: env(safe-area-inset-bottom)
// 语法的话，以下css可用
  
@supports (bottom: constant(safe-area-inset-bottom)) or (bottom: env(safe-area-inset-bottom)) {
  .iphone-x::after { // 给需要适配黑条的内容加上 iphone-x 的 class
    display: block;
    content: "";
    padding-bottom: constant(safe-area-inset-bottom); /* 兼容 iOS < 11.2 */
    padding-bottom: env(safe-area-inset-bottom); /* 兼容 iOS >= 11.2 */
  }
}
```

以上适用于手机端底部设置tab栏，给tab加上特定的padding-bottom


官方给出了另一种css方案来解决整体的遮盖问题：

![全屏模式](/img/md/css-iphoneX/viewport-fit-cover.png)

以下只解决了横版问题，竖屏时文章的padding仍然有问题（顶头了）：
```css
.post {
    padding: 12px;
    padding-left: env(safe-area-inset-left);
    padding-right: env(safe-area-inset-right);
}
```

max()好用，但是太新了，需要注意自己浏览器的支持情况！
```css
@supports(padding: max(0px)) { // @supports意为支持padding max语法的话，以下css可用
    .post {
        padding-left: max(12px, env(safe-area-inset-left));
        padding-right: max(12px, env(safe-area-inset-right));
    }
}
```