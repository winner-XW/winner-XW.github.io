---
title: 如何将String类型转化成Number类型？
date: 2024/04/08
tags: [Java,初级]
categories: 后端面试
description: 如何将String类型转化成Number类型？
cover: /img/md/java.png
---

## 使用Integer.parseInt()
如果你知道字符串表示的是一个整数，可以使用Integer.parseInt()方法：

```java
String numberStr = "123";
int number = Integer.parseInt(numberStr);
使用Double.parseDouble()
如果字符串表示的是一个浮点数，可以使用Double.parseDouble()方法：
```
```java
String numberStr = "123.456";
double number = Double.parseDouble(numberStr);
```

## 使用new Integer() 或 new Double()
这种方法已经被视为过时，不推荐使用，但仍可作为参考：

```java
String numberStr = "123";
Integer number = new Integer(numberStr);  // 整数
Double number = new Double(numberStr);    // 浮点数
```


## 使用NumberFormat
如果你需要进行更复杂的数字格式转换，可以使用NumberFormat类：

```java
import java.text.NumberFormat;

NumberFormat format = NumberFormat.getInstance();
format.setGroupingUsed(false);
try {
    Number number = format.parse(numberStr);
} catch (ParseException e) {
    e.printStackTrace();
}
```
注意：以上方法在转换失败时（如字符串不表示有效数字），会抛出异常（如NumberFormatException）。因此，在使用这些方法时，最好进行适当的异常处理。