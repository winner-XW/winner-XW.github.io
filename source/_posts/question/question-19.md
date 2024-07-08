---
title: 简述什么是迭代器(Iterator)？
date: 2024/04/08
tags: [Java,中级]
categories: 后端-面试题库
description: 简述什么是迭代器(Iterator)？
cover: /img/md/java.png
---


## 迭代器
>迭代器（Iterator）是一种设计模式，Java 中的迭代器是集合框架中的一个接口，它可以让程序员遍历集合中的元素而无需暴露集合的内部结构。使用迭代器可以遍历任何类型的集合，例如 List、Set 和 Map 等。

通过调用集合类的 iterator() 方法可以获取一个迭代器，并使用 hasNext() 方法判断是否还有下一个元素，如果有，则使用 next() 方法获取下一个元素。使用迭代器的好处在于遍历集合时不需要了解集合内部的结构，从而让代码更具可维护性和可重用性。

迭代器还具有一些额外的功能，比如支持 remove() 方法来删除迭代器返回的最后一个元素，以及可以使用 forEachRemaining() 方法来迭代集合中余下的所有元素等。

>注意的是，一旦使用了迭代器进行遍历，就不能在遍历时修改集合中的元素，否则可能会导致不可预知的行为。如果需要修改集合中的元素，应该使用集合提供的遍历方式（如 for-each 循环）来进行遍历，或者使用列表迭代器（ListIterator）来对列表进行修改。

## Java为什么不直接实现Iterator接口，而是实现Iterable？
Iterator是迭代器类，而Iterable是接口。好多类都实现了Iterable接口，这样对象就可以调用iterator()方法。
1. Iterator接口的核心方法next()或者hasNext() 是依赖于迭代器的当前迭代位置的。如果Collection直接实现Iterator接口，势必导致集合对象中包含当前迭代位置的数据(指针)。
2. 当集合在不同方法间被传递时，由于当前迭代位置不可预置，那么next()方法的结果会变成不可预知。除非再为Iterator接口添加一个reset()方法，用来重置当前迭代位置。
3. Collection也只能同时存在一个当前迭代位置。而Iterable则不然，每次调用都会返回一个从头开始计数的迭代器。多个迭代器是互不干扰的。

## Iterator和ListIterator的区别是什么？
1. 使用范围不同，iterator可以应用于所有的集合，Set、List和Map以及这些集合的子类型。而ListIterator只能用于List及其子类型。
2. ListIterator有add方法，可以向List中添加对象，而Iterator不能。
3. ListIterator和Iterator都有hasNext()和next()方法，可以实现顺序向后遍历，但是ListIterator有hasPrevious()和previous()方法，可以实现逆向遍历，但是iterator不可以。
4. ListIterator可以定位当前索引的位置，nextIndex()和previousIndex()可以实现。Iterator没有此功能。
5. 都可以实现删除操作，但是ListIterator可以实现对象的修改，set()方法可以实现。Iterator仅能遍历，不能实现修改。