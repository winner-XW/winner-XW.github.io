---
title: 浏览器渲染原理，回流，重绘的概念和原理 ？
date: 2024/04/07
tags: [前端,高级]
categories: 前端面试
description:  浏览器渲染原理，回流，重绘的概念和原理 ？
cover: /img/md/web.png
---

# 浏览器的渲染机制
1. 浏览器的渲染机制一般分为以下几个步骤:
2. 处理 HTML 并构建 DOM 树。
3. 处理 CSS 构建 CSSOM 树。
4. 将 DOM 与 CSSOM 合并成一个渲染树。
5. 根据渲染树来布局，计算每个节点的位置。
6. 调用 GPU 绘制，合成图层，显示在屏幕上。

# 重绘与回流
## 重绘
当元素样式的改变不影响布局时，浏览器将使用重绘对元素进行更新，此时由于只需要UI层面的重新像素绘制，因此损耗较少
## 回流
当元素的尺寸、结构或触发某些属性时，浏览器会重新渲染页面，称为回流。此时，浏览器需要重新经过计算，计算后还需要重新页面布局，因此是较重的操作。会触发回流的操作:
– 页面初次渲染 – 浏览器窗口大小改变 – 元素尺寸、位置、内容发生改变 – 元素字体大小变化 – 添加或者删除可见的 dom 元素 – 激活 CSS 伪类（例如：:hover） – 查询某些属性或调用某些方法： – clientWidth、clientHeight、clientTop、clientLeft – offsetWidth、offsetHeight、offsetTop、offsetLeft – scrollWidth、scrollHeight、scrollTop、scrollLeft – getComputedStyle() – getBoundingClientRect() – scrollTo()

>总结:
回流必定触发重绘，重绘不一定触发回流。重绘的开销较小，回流的代价较高。所以尽量减少触发回流的操作, 以达到更好的性能