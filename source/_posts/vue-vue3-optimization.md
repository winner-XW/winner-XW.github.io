---
title: vue3 在哪些方面做了性能提升？
date: 2022/06/16
tags: 性能,优化
categories: Vue
description: 尤大大在介绍vue3说客户端的渲染效率比vue2提升了1.3-2倍, SSR渲染效率比 vue2 提升了2-3倍。
keywords: 性能,优化
cover: /img/md/vue.jpg
---

# 编译阶优化段
>在Vue2中，每个组件实例都对应一个 watcher 实例，它会在组件渲染的过程中把用到的数据property记录为依赖，当依赖发生改变，触发setter，则会通知watcher，从而使关联的组件重新渲染


![watcher](/img/md/vue3-optimization/523224-763c89229f3c2925.webp)

假如一个vue组件有如下模板结构：

```javascript
<template>
  <div id="content">
      <p class="text">静态文本</p>
      <p class="text">静态文本</p>
      <p class="text">{{ message }}</p>
      <p class="text">静态文本</p>
      ...
      <p class="text">静态文本</p>
  </div>
</template>
```

>可以看到，组件内部只有一个动态节点，剩余一堆都是静态节点，所以这里很多 diff 和遍历其实都是不需要的，会造成性能浪费。因此，Vue3在编译阶段，做了进一步优化。


# 优化方案

## diff算法优化
>vue3在diff算法中相比vue2增加了静态标记关于这个静态标记，其作用是为了会发生变化的地方添加一个flag标记，下次发生变化的时候直接找该地方进行比较，如下图

![diff](/img/md/vue3-optimization/523224-a6ac51a05c59d316.webp)

### PatchFlag
>PatchFlag 是对 Block Tree 进一步优化, 在对比单个节点的时, 会对比属性, 内容等等。

```javascript
export const enum PatchFlags {
  TEXT = 1,// 动态的文本节点
  CLASS = 1 << 1,  // 2 动态的 class
  STYLE = 1 << 2,  // 4 动态的 style
  PROPS = 1 << 3,  // 8 动态属性，不包括类名和样式
  FULL_PROPS = 1 << 4,  // 16 动态 key，当 key 变化时需要完整的 diff 算法做比较
  HYDRATE_EVENTS = 1 << 5,  // 32 表示带有事件监听器的节点
  STABLE_FRAGMENT = 1 << 6,   // 64 一个不会改变子节点顺序的 Fragment
  KEYED_FRAGMENT = 1 << 7, // 128 带有 key 属性的 Fragment
  UNKEYED_FRAGMENT = 1 << 8, // 256 子节点没有 key 的 Fragment
  NEED_PATCH = 1 << 9,   // 512
  DYNAMIC_SLOTS = 1 << 10,  // 动态 solt
  HOISTED = -1,  // 特殊标志是负整数表示永远不会用作 diff
  BAIL = -2 // 一个特殊的标志，指代差异算法
}
```

>vue2 在单个节点对比时不知道那些是要对比的所以全部对比一次  
vue3 就知道那些属性是动态的, 每次更新只对比动态的属性

## 静态提升
>Vue3中对不参与更新的元素，会做静态提升，只会被创建一次，在渲染时直接复用这样就免去了重复的创建节点，大型应用会受益于这个改动，免去了重复的创建操作，优化了运行时候的内存占用

```javascript
<span>你好</span>
<div>{{ message }}</div>
```

没有做静态提升之前
```javascript
export function render(_ctx, _cache, $props, $setup, $data, $options) {
  return (_openBlock(), _createBlock(_Fragment, null, [
    _createVNode("span", null, "你好"),
    _createVNode("div", null, _toDisplayString(_ctx.message), 1 /* TEXT */)
  ], 64 /* STABLE_FRAGMENT */))
}
```
```javascript
const _hoisted_1 = /*#__PURE__*/_createVNode("span", null, "你好", -1 /* HOISTED */)
 
export function render(_ctx, _cache, $props, $setup, $data, $options) {
  return (_openBlock(), _createBlock(_Fragment, null, [
    _hoisted_1,
    _createVNode("div", null, _toDisplayString(_ctx.message), 1 /* TEXT */)
  ], 64 /* STABLE_FRAGMENT */))
}
 
// Check the console for the AST
```
>静态内容_hoisted_1被放置在render 函数外，每次渲染的时候只要取 _hoisted_1 即可同时 _hoisted_1 被打上了 PatchFlag ，静态标记值为 -1 ，特殊标志是负整数表示永远不会用于 Diff

## 预字符串化
>在平时vue开发过程中，组件当中没有特别多的动态元素，大多都是静态元素。比如：
```html
  <div class="menu-bar-container">
    <div class="logo">
      <h1>法医</h1>
    </div>
    <ul class="nav">
      <li><a href="">menu</a></li>
      <li><a href="">menu</a></li>
      <li><a href="">menu</a></li>
      <li><a href="">menu</a></li>
      <li><a href="">menu</a></li>
    </ul>
  </div>
  <div class="user">
    <span>{{user.name}}</span>
  </div>
```
在这个组件中，除了span元素是动态元素之外，其余都是静态节点，一般可以说是动静比，动态内容 / 静态内容，比例越小，静态内容越多，比例越大，动态内容越多，vue3的编译器它会非常智能地发现这一点，当编译器遇到大量连续的静态内容，会直接将它编译为一个普通字符串节点，因为它知道这些内容永远不会变化，都是静态节点。

>注意：必须是大量连续的静态内容才可以预字符串化哦，切记！目前是连续20个静态节点才会预字符串化

然而在vue2中，每个元素都会变成虚拟节点，一大堆的虚拟节点😱，这些全都是静态节点，在vue3中它会智能地发现这一点。如下图所示，我们可以很明显的感受到vue3的巨大性能提升

![虚拟节点](/img/md/vue3-optimization/523224-76e4a864396e4a7e.webp)

## 缓存事件处理函数

比如存在如下事件处理函数
`<button @click="count++">plus</button>`

对比vue2和vue3的处理方式

```javascript
// vue2处理方式render(ctx){
return createVNode("button",{
    onclick:function($event){
        ctx.count++;
    }
})

//vue3 处理方式render(ctx,_cache){
return createVNode("button",{
    onclick:cache[0] || (cache[0] =>($event) =>(ctx.count++))
})
```
在vue2中创建一个虚拟节点button，属性里面多了一个事件onclick，内容就是count++。在vue3中会认为这里的事件处理是不会变化的，不是说这次渲染是事件函数，下次就变成别的，于是vue3会智能地发现这一点，会做缓存处理，它首先会看一看缓存里面有没有这个事件函数，有的话直接返回，没有的话就直接赋值为一个count++函数，保证事件处理函数只生成一次。

## SSR优化

>当静态内容大到一定量级时候，会用createStaticVNode方法在客户端去生成一个static node，这些静态node，会被直接innerHtml，就不需要创建对象，然后根据对象渲染。

编译前

```html
<div>
 <div>
  <span>你好</span>
 </div>
 ...  // 很多个静态属性
 <div>
  <span>{{ message }}</span>
 </div>
</div>
```

编译后
```javascript
import { mergeProps as _mergeProps } from "vue"import { ssrRenderAttrs as _ssrRenderAttrs, ssrInterpolate as _ssrInterpolate } from "@vue/server-renderer"
 
export function ssrRender(_ctx, _push, _parent, _attrs, $props, $setup, $data, $options) {
  const _cssVars = { style: { color: _ctx.color }}
  _push(`<div${
    _ssrRenderAttrs(_mergeProps(_attrs, _cssVars))
  }><div><span>你好</span>...<div><span>你好</span><div><span>${
    _ssrInterpolate(_ctx.message)
  }</span></div></div>`)
}

```

### 源码体积有优化
>与Vue2相比较，Vue3整体体积变小了，移除了一些比较冷门的feature：如 keyCode 支持作为 v-on 的修饰符、on、off 和 $once 实例方法、filter过滤、内联模板等。tree-shaking 依赖 ES2015 模块语法的静态结构（即 import 和 export），通过编译阶段的静态分析，找到没有引入的模块并打上标记。任何一个函数，如ref、reavtived、computed等，仅仅在用到的时候才打包，没用到的模块都被摇掉，打包的整体体积变小。

```javascript
import { computed, defineComponent, ref } from 'vue';
export default defineComponent({
    setup(props, context) {
        const age = ref(18)
 
        let state = reactive({
            name: 'test'
        })
 
        const readOnlyAge = computed(() => age.value++) // 19
 
        return {
            age,
            state,
            readOnlyAge
        }
    }
});
```

### 响应式实现优化

改用proxy api做数据劫持

- Vue.js 2.x 内部是通过 Object.defineProperty 这个 API 去劫持数据的 getter 和 setter 来实现响应式的。这个 API 有一些缺陷，它必须预先知道要拦截的 key 是什么，所以它并不能检测对象属性的添加和删除。
- Vue.js 3.0 使用了 Proxy API 做数据劫持，它劫持的是整个对象，自然对于对象的属性的增加和删除都能检测到。

响应式是惰性的

- 在 Vue.js 2.x 中，对于一个深层属性嵌套的对象，要劫持它内部深层次的变化，就需要递归遍历这个对象，执行 Object.defineProperty 把每一层对象数据都变成响应式的，这无疑会有很大的性能消耗。
- 在 Vue.js 3.0 中，使用 Proxy API 并不能监听到对象内部深层次的属性变化，因此它的处理方式是在 getter 中去递归响应式，这样的好处是真正访问到的内部属性才会变成响应式，简单的可以说是按需实现响应式，就没有那么大的性能消耗。

>另外除了以上几点，vue3.0能更好的支持TS 、  
Custom Renderer API：暴露了自定义渲染API、  
Fragment，Teleport(Protal)，Suspense：更先进的组件