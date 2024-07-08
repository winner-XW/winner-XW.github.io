---
title: Vue下载文件需要token校验
date: 2021/12/06
tags: [Vue,下载]
categories: 前端-开发效率
description: 平时下载文件访问后台给的下载链接点击自动下载即可，因文件需要验证身份信息，所以需要在Request headers中塞入token作为身份验证。
cover: /img/md/vue.jpg
---

# 直接下载

## 前端创建超链接
```html
<a :href='"/user/downloadExcel"'>下载模板</a>
```

## 点击事件触发
```javascript
function downloadExcel() {
  window.location.href = "/user/downloadExcel";
} 
```

# token下载
>注：数据返回类型必须为 responseType: 'blob'

>1.数据正常，后台返回 blob 文件流  
2.数据异常，后台返回 blob 类型异常信息

```javascript
const downLoadFile = function (response, fileName){
  if(response.type === 'jsonString' || response.type === 'application/json') {
    let reader = new FileReader();
    reader.readAsText(response, 'utf-8');
    reader.onload = e =>{
      // 后台返回文件下载失败 处理
      const { msg }  = JSON.parse(reader.result);
      this.$Message.error(msg);
    }
  }else {
    if (window.navigator.msSaveOrOpenBlob) { // IE10
        navigator.msSaveBlob(response, fileName);
    }else {
        let $body = document.body;
        let link = document.createElement('a');
        link.style.display = 'none';
        $body.appendChild(link);
        link.href = URL.createObjectURL(response); //创建一个指向该参数对象的url
        link.download = fileName;
        link.click(); // 触发下载
        URL.revokeObjectURL(link.href); // 释放创建的URL
        $body.removeChild(link)
        link = null
    }
  }
}
```