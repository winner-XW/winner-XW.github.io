---
title: CSS 开头的全局标准代码
date: 2021/03/24
tags: CSS,基础,共通
categories: CSS
description: 布局是把页面分成一块一块，按左中右、上中下等排列。
keywords: CSS,基础,共通
cover: /img/md/css.jpg
---

# PC
## CSS
```css
*{padding:0;margin:0;}
div,dl,dt,dd,form,h1,h2,h3,h4,h5,h6,img,ol,ul,li,table,th,td,p,span,a{border:0;}
img,input{border:none;vertical-align:middle;}
body{font-family:Tahoma,Arial,Helvetica,"宋体";font-size:12px;text-align:center;background:#FFF;color:#000;}
html{overflow-y:scroll;}
ul,ol{list-style-type:none;}
th,td,input{font-size:12px;}
h3{font-size:14px;}
button{border:none;cursor:pointer;font-size:12px;background-color:transparent;}
select{border-width:1px;_zoom:1;border-style:solid;padding-top:2px;font-size:12px;}
.clear{clear:both;font-size:1px;height:0;visibility:hidden;line-height:0;}
.clearfix:after{content:"";display:block;clear:both;}
.clearfix{zoom:1;}
a:link,a:visited{text-decoration:none;color:#333;}
a:hover,a:active{text-decoration:underline;color:#f60;}
```

# 移动端
## CSS
```css
html{-ms-text-size-adjust:100%;-webkit-text-size-adjust:100%}
body{line-height:1.6;font-family:"Helvetica Neue",Helvetica,Arial,sans-serif}
body,h1,h2,h3,h4,p,ul,ol,dl,dd,fieldset,textarea{margin:0}
fieldset,legend,textarea,input,button{padding:0}
button,input,select,textarea{font-family:inherit;font-size:100%;margin:0;*font-family:"Helvetica Neue",Helvetica,Arial,sans-serif}
ul,ol{padding-left:0;list-style-type:none}
a img,fieldset{border:0}
a{text-decoration:none}
```