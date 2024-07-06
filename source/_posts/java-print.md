---
title: 实现在CS端调用本地打印机服务打印PDF的功能
date: 2023/11/07
tags: java,打印机,打印,自定义打印,打印参数
categories: JAVA
description: 实现在CS端调用本地打印机服务打印PDF的功能
keywords: java,打印机,打印,自定义打印,打印参数
cover: /img/md/java.png
---

## 项目描述
实现在CS端调用本地打印机服务打印PDF的功能

## 依赖项
> 1. 运行环境：jdk8及以上
> 2. 导入依赖：[pdfbox](https://github.com/apache/pdfbox/tree/trunk/pdfbox)
> 3. 导入工具类：PrintUtil.java

maven导入依赖示例：
```xml
<dependency>
    <groupId>org.apache.pdfbox</groupId>
    <artifactId>pdfbox</artifactId>
    <version>2.0.27</version>
</dependency>
```

## 使用说明
### 获取打印机服务列表
> 调用工具类`PrintUtil.java`中`PrintUtil.selectPrintService()`的方法

### 执行打印
> 调用工具类`PrintUtil.java`中`PrintUtil.print()`的方法


参数说明：
| 参数 | 类型 | 值 | 是否必须 | 说明 |
| --- | --- | --- | --- | --- |
| filepath | String | 例："test.pdf" | Yes | 文件地址 |
| printService | PrintService | - | Yes | 打印服务 |
| scaling | Scaling | 实际大小：Scaling.ACTUAL_SIZE； 缩小：Scaling.SHRINK_TO_FIT； 拉伸：Scaling.STRETCH_TO_FIT； 适应：Scaling.SCALE_TO_FIT | Yes | 缩放形式 |
| copies | Integer | 例：1 | Yes | 打印份数 |
| orientation | int | 竖：PageFormat.PORTRAIT；横：PageFormat.LANDSCAPE；反转：PageFormat.REVERSE_LANDSCAPE | Yes | 方向 |
| sides | Attribute | 单面打印：Sides.ONE_SIDED；双面打印：Sides.DUPLEX； | Yes | 单双页 |
| mediaSizeName | Attribute | 纸张大小：MediaSizeName.ISO_A4；…… | Yes | 纸张大小 |
| width | int | 例：595（A4） | Yes | 纸张宽度像素 |
| height | int | 例：842（A4） | Yes | 纸张高度像素 |
| marginLeft | int | 例：12 | Yes | 距左边距离 |
| marginRight | int | 例：12 | Yes | 距右边距离 |
| marginTop | int | 例：12 | Yes | 距上边距离 |
| marginBottom | int | 例：12 | Yes | 距下边距离 |


返回说明：
| 值 | 说明 |
| --- | --- |
| true | 打印成功 |
| false | 打印失败 |


## 使用示例

```java
// 1.获取服务列表
HashMap<String, PrintService> printServiceHashMap = PrintUtil.selectPrintService();
// 2.调用打印
boolean flag = PrintUtil.print(filepath, printServiceHashMap.get("导出为WPS PDF"), Scaling.ACTUAL_SIZE, 1,
        PageFormat.PORTRAIT, Sides.ONE_SIDED,
        MediaSizeName.ISO_A4, 595, 842,
        12, 12, 12, 12);
// 3.返回结果
System.out.println(flag);
```

## 下载链接
[Printer.zip](/file/Printer.zip)

## 效果演示
![Dingtalk_20231120144615.jpg](/img/md/java-print/Dingtalk_20231120144615.jpg)