---
title: Vue常用工具类-Cookie
date: 2021/07/15
tags: cookie,存储
categories: Vue
description: 储存在用户本地终端上的数据
keywords: cookie,存储
cover: /img/md/vue.jpg
---

# 介绍
>一个保存在客户机中的简单的文本文件, 这个文件与特定的 Web 文档关联在一起, 保存了该客户机访问这个Web 文档时的信息, 当客户机再次访问这个 Web 文档时这些信息可供该文档使用。

# 组成
>Cookie是一段不超过4KB的小型文本数据，由一个名称（Name）、一个值（Value）和其它几个用于控制Cookie有效期、安全性、使用范围的可选属性组成。

# vue实现token验证

## 下载
```bash
npm install --save js-cookie
```

## 创建cookie.js
```javascript
import Cookie from 'js-cookie';
// name: cookie存储的名字
// val: 需要存储的数据

function getCookie(name) {
  return Cookie.get(name);
}

function setCookie(name, val) {
  Cookie.set(name, val);
}

function removeCookie(name) {
  Cookie.remove(name);
}

export default {
  getCookie,
  setCookie,
  removeCookie
};
```
