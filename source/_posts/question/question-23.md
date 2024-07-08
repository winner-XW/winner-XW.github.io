---
title: 如果要重写一个对象的equals方法,还要考虑什么?
date: 2024/04/08
tags: [Java,高级]
categories: 后端-面试题库
description: 如果要重写一个对象的equals方法,还要考虑什么?
cover: /img/md/java.png
---

# 特点
1. 自反性：x.equals(x)一定返回true
2. 对称性：x.equals(y)返回true当且仅当y.equals(x)
3. 传递性：x.equals(y)且y.equals(z)，则x.equals(z)为true
4. 一致性：若x.equals(y)返回true，则不改变x，y时多次调用x.equals(y)都返回true
5. 对于任意的非空引用值x，x.equals(null)一定返回false。

# 代码实现
```java
public class Point {
	private final int x;
	private final int y;
	public Point(int x, int y) {
		this.x = x;
		this.y = y;
	}
	public boolean equals(Object o) {
		if(!(o instanceof Point))
			return false;
		Point p = (Point)o;
		return p.x == x && p.y == y;
	}
	//...
}
```