---
title: Vue常用工具类-全局过滤器filter
date: 2021/07/16
tags: filter,过滤
categories: Vue
description: 定义一个全局的过滤器，实现快速，准确处理数据
keywords: filter,过滤
cover: /img/md/vue.jpg
---

# 介绍
>在项目中经常使用过滤器对数据进行格式化后显示在页面上，比如日期格式转化，数值转换成状态文字等过滤器，如果在每个.vue页面都复制同一个过滤器进行使用，虽然是没问题，但是如果过滤器方法中，需要追加新的情况判断或出现Bug时就要将每个.vue内的过滤器进行修改，既费时又费力，所以为了项目维护，可以优先考虑定义全局过滤器。

# vue实现代码（日期格式转化、保留小数位）

## 创建filter.js
```javascript
/**
 * 时间戳转日期格式
 * @param data {number} 时间戳
 * @param format {string} 时间格式[完整格式：yyyy-MM-dd HH:mm:ss，默认yyyy-MM-dd]
 * @param implementText {string} 缺省文字
 */
exports.timeFormat = (data, format, implementText) => {
  if (data === null || data === '' || data === undefined) {
    return implementText || '';
  }
  format = format || 'yyyy-MM-dd';
  let week = [
    '星期日',
    '星期一',
    '星期二',
    '星期三',
    '星期四',
    '星期五',
    '星期六'
  ];
  let date = new Date(data);
  let o = {
    'M+': date.getMonth() + 1,
    'd+': date.getDate(),
    'h+': date.getHours() % 12,
    'H+': date.getHours(),
    'm+': date.getMinutes(),
    's+': date.getSeconds(),
    'q+': Math.floor((date.getMonth() + 3) / 3),
    'S+': date.getMilliseconds(),
    'W+': week[date.getDay()]
  };
  if (/(y+)/.test(format))
    format = format.replace(
      RegExp.$1,
      (date.getFullYear() + '').substr(4 - RegExp.$1.length)
    );
  for (let k in o)
    if (new RegExp('(' + k + ')').test(format))
      format = format.replace(
        RegExp.$1,
        RegExp.$1.length === 1 ? o[k] : ('00' + o[k]).substr(('' + o[k]).length)
      );
  return format;
};

/**
 * 保留小数位
 * @param data 数值
 * @param len 保留的位数
 */
exports.toFixed = (data, len) => {
  if (data) {
    typeof data === 'string' ? (data = Number(data)) : null;
    return data ? data.toFixed(len || 2) : data;
  } else {
    return 0;
  }
};
```

## 全局注册
```javascript
//全局过滤器
import * as filters from '...../filter.js'
Object.keys(filters).forEach(k => Vue.filter(k, filters[k]));
```

## 全局使用
```javascript
{{ item.startTime | timeFormat('yyyy-MM-dd HH:mm') }}
{{ item.endTime | timeFormat('HH:mm') }}

{{ item.one | toFixed(1) }}
{{ item.two | toFixed(2) }}
```