---
title: 解释什么是盒子模型？
date: 2024/04/07
tags: [前端,初级]
categories: 前端-面试题库
description:  解释什么是盒子模型？
cover: /img/md/web.png
---

# 标准盒与怪异盒的区别在于他们的总宽度的计算公式不⼀样。
1. 标准模式下总宽度=width+margin（左右）+padding（左右）border（左右）；
2. 怪异模式下总宽度=width+margin（左右）（就是说width已经包含了padding和border值）。

# 标准模式下如果定义的DOCTYPE缺失，则在ie6、ie7、ie8下汇触发怪异模式。
1. 当设置为box-sizing:content-box时，将采⽤标准模式解析计算，也是默认模式；
2. 当设置为box-sizing:border-box时，将采⽤怪异模式解析计算；