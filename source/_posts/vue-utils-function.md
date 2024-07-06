---
title: Vue常用工具类-全局公共函数function
date: 2021/07/07
tags: function,函数
categories: Vue
description: 定义一个全局的函数，实现快速，准确处理事件
keywords: function,函数
cover: /img/md/vue.jpg
---

# 介绍
>如果你需要让一个工具函数在每个组件可用，可以把方法挂载到 Vue.prototype上。

# vue实现代码（获取URL参数, 防抖函数）

## 创建util.js
```javascript
export default {
  /**
   * URL编码;
   * @param {参数} param
   */
  toParams: function(param) {
    let result = '';
    for (let name in param) {
      if (typeof param[name] != 'function') {
        if (param[name] === null) {
          result += '&' + name + '=';
        } else {
          result += '&' + name + '=' + encodeURI(param[name]);
        }
      }
    }
    return result.substring(1);
  };
  /**
   * 防抖函数
   * @param fn 高频函数
   * @param wait 等待时间
   * @returns {Function}
   */
  debounce: function(fn, wait) {
    let context = this,
      args = arguments,
      timer = null;
    return function() {
      context = this;
      args = arguments;
      clearTimeout(timer);
      timer = setTimeout(function() {
        fn.apply(context, args);
      }, wait || 250);
    };
  }
}
```

## 全局注册
```javascript
//全局方法
import util from '..../util.js'
Vue.prototype.util = util;
```

## 全局使用
```javascript
this.util.toParams(name);
this.util.debounce(function, 1000);
```