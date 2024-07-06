---
title: XML和JSON的区别？
date: 2024/04/07
tags: [前端,初级]
categories: 前端面试
description: XML和JSON的区别？
cover: /img/md/web.png
---


# XML的定义
扩展标记语言 (Extensible Markup Language, XML) ，用于标记电子文件使其具有结构性的标记语言，可以用来标记数据、定义数据类型，是一种允许用户对自己的标记语言进行定义的源语言。 XML使用DTD(document type definition)文档类型定义来组织数据；格式统一，跨平台和语言，早已成为业界公认的标准。
XML是标准通用标记语言 (SGML) 的子集，非常适合Web传输。XML提供统一的方法来描述和交换独立于应用程序或供应商的结构化数据。

# JSON的定义
JSON(JavaScript Object Notation)一种轻量级的数据交换格式，具有良好的可读和便于快速编写的特性。可在不同平台之间进行数据交换。JSON采用兼容性很高的、完全独立于语言文本格式，同时也具备类似于C语言的习惯(包括C, C++, C#, Java, JavaScript, Perl, Python等)体系的行为。这些特性使JSON成为理想的数据交换语言。

# 区别
1. 编码方面的区别
JSON的编码更为清晰且冗余更少些，而XML比较适合于标记文档。JSON网站提供了对JSON语法的严格描述，只是描述较简短。JSON更适于进行数据交换处理。

2. 编码可读性之间的区别
XML有明显的优势，毕竟人类的语言更贴近这样的说明结构。JSON读起来更像一个数据块，读起来就比较费解了。不过，我们读起来费解的语言，恰恰是适合机器阅读。