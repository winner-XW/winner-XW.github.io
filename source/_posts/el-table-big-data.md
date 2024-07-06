---
title: vue2 Element-UI 表格大数据加载渲染慢问题
date: 2022/01/07
tags: vue,大数据，渲染卡顿
categories: Element-UI
description: 页面数据量大，在没有分页的情况下操作表格，导致渲染卡顿，甚至奔溃。
keywords: vue,大数据,渲染卡顿
cover: /img/md/vue.jpg
---

# 思想
>假设全部数据为initTable(数组)，现在使用一个tableData（数组），tableData = initTable.slice(scorll, scorll+ displayCount)，scroll表示当前滚动到的index， displayCount表示要展示的行数。把tableData设为el-table的数据源，只渲染该部分数据。通过对表格添加滚动事件监听，来动态更新scroll，并且对scroll添加watch，当scroll发生变化，就自动更新tableData。采用虚拟滑动条方式触发。

# 创建指令

## 创建文件夹el-table，在其下面创建loadmore.js

内容如下：
```javascript
import Vue from 'vue'
let flag = true // 控制返回频度，以免内存消耗过大

export default {
  bind(el, binding, vnode) {
    const {
      arg
    } = binding;
    const a = '<div class="content-height" style="height: 0px;">&nbsp;</div>';
    const divHtml = Vue.extend({
      template: a
    });
    el.children[0].appendChild(new divHtml().$mount().$el);

    const sco = el.querySelector('.fictitious');
    const cellHeihgt = parseInt((arg && arg[0])) || 50;
    sco.addEventListener('scroll', throttle(function () {
      binding.value(Math.floor(sco.scrollTop / cellHeihgt), Math.floor(sco.clientHeight / cellHeihgt));
    }, 300));

    document.addEventListener('mousewheel', function (ev) {
      var ev = window.event || ev;
      sco.scrollTop = -ev.wheelDelta*2 + sco.scrollTop;
    });
  },
  update: (el, binding) => {
    const {
      arg
    } = binding;
    const cellHeihgt = parseInt((arg && arg[0])) || 50;
    if (arg[0] * arg[1] > 0) {
      const contentHeight = el.querySelector('.content-height');
      const sco = el.querySelector('.fictitious');
      contentHeight.style.height = arg[0] * (arg[1] + 1) + 'px';
      if (flag) {
        binding.value(0, Math.floor((window.innerHeight - 316) / cellHeihgt));
        flag = false;
      }
    } else {
      flag = true;
    }
  }
}

// 节流
function throttle(fn, wait) {
  var timer = null;
  return function () {
    var context = this;
    var args = arguments;
    if (!timer) {
      timer = setTimeout(function () {
        fn.apply(context, args);
        timer = null;
      }, wait);
    }
  };
}
```
- fictitious：滑动条class
- content-height：滑动内容区


## 注册指令（main.js引入文件）
```javascript
// 引入
import loadmore from '...../el-table/loadmore'
// 注册
Vue.directive('el-table-loadmore', loadmore)
```

# 创建滑动条外壳

在el-table的父层添加一下代码

```html
<div style="position: relative; padding-right: 12px;" v-el-table-loadmore:[[rowHeight,initTable.length]]="loadMore">
    <div style="position: absolute;right: 0;margin-top: 49px;height: calc(100vh - 316px);overflow-y: auto;width: 12px;" class="fictitious" v-show="scollShow">
    </div>
    <el-table :key="key"></el-table>
</div>

<script>
function loadMore(firstIndex, countPage) {
    var arr = []
    for (let index = firstIndex; index < this.initTable.length; index++) {
        const element = this.initTable[index];
        if (index < firstIndex + countPage) {
            arr.push(element);
        }
    }
    this.tableData = JSON.parse(JSON.stringify(arr));
    this.key = !this.key;
}
</script>

<style>
    /* 浏览器式样 */
  .fictitious::-webkit-scrollbar-track-piece {
    background-color: #f8f8f8;
  }

  .fictitious::-webkit-scrollbar {
    width: 12px;
  }

  .fictitious::-webkit-scrollbar-thumb {
    background-color: #dddddd;
    border-radius: 100px;
  }

  .fictitious::-webkit-scrollbar-thumb:hover {
    background-color: #bbb;
  }
</style>
```
注： height: calc(100vh - 316px) 设置滑动条高度

- key：重新渲染表格
- rowHeight: 表示每行的高度
- initTable： 全部数据
- loadMore： 滑动触发方法 （参数1：开始展示行，参数2：展示的条数）
- scollShow：显示滚动条否
