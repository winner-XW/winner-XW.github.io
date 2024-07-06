---
title: js复制函数
date: 2021/06/04
tags: 前端,JS,复制
categories: JS
description: JS一键复制主要应用在银行卡、手机号、验证码等各种场合
keywords: 前端,JS,复制
cover: /img/md/js.jpg
---

# 一键复制函数
```javascript
const copy=(e:any)=>{
  const copyDOM =e.currentTarget;  // 需要复制文字的节点
  const range = document.createRange(); // 创建一个range
  window.getSelection()?.removeAllRanges();   // 清楚页面中已有的selection
  range.selectNode(copyDOM);    // 选中需要复制的节点
  window.getSelection()?.addRange(range);   // 执行选中元素
  const successful = document.execCommand('copy');    // 执行 copy 操作
  if(successful){
      alert('复制成功！')
  }else{
      alert('复制失败，请手动复制！')
  }
  // 移除选中的元素 
  window.getSelection()?.removeAllRanges();
}
```