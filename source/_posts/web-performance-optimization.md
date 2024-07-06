---
title: web性能优化
date: 2021/04/04
tags: 前端,优化
categories: WEB
description: Web 性能优化就是用户觉得页面加载很快，用户从输入URL（网址）到页面在浏览器上加载出来的时间很短。
keywords: 前端,优化,web性能优化
cover: /img/md/web.png
---

# web性能优化
>基于现代Web前端框架的应用，其原理是通过浏览器向服务器发送网络请求，获取必要的index.html和打包好的JS、CSS等资源，在浏览器内执行JS，动态获取数据并渲染页面，从而将结果呈现给用户。

## 思路

![网页渲染过程](/img/md/pictures/ea84ee35fdc2b00983fd4a02231421a1.png)

在这个过程中，有两个步骤可能较为耗时：一个是`网络资源的加载`，另一个是`浏览器内代码执行`和`DOM渲染`。

针对上述两种耗时的情况，常见的优化方向有：
- 缩短请求耗时
- 减少重排重绘
- 改善JS性能

## 具体实现

### 缩短请求耗时

#### 优化打包资源
>减少或延迟模块引用，以减少网络负荷。

常用工具：  
webpack  
webpack-bundle-analyzer可视化分析工具

常用方法：  
- 减小体积：减少非必要的import；压缩JS代码；配置服务器gzip等；使用WebP图片；
- 按需加载：可根据“路由”、“是否可见”按需加载JS代码，减少初次加载JS体积。比如可以使用import()进行代码分割，按需加载；
- 分开打包：利用浏览器缓存机制，依据模块更新频率分层打包。
  
其他方法：

- 雪碧图：每个HTTP/1.1请求都是独立的TCP连接，最大6个并发，所以合并图片资源可以优化加载速度。HTTP/2已经不需要这么做了。

#### CDN加速
>通过分布式的边缘网络节点，缩短资源到终端用户的访问延迟。

常用工具：
- Cloudflare
- AWS CloudFront
- Aliyun CDN

常用方法：  
加速图片、视频等大体积文件


#### 浏览器缓存
>避免重复传输相同的数据，节省网络带宽，加速资源获取。

常用工具：
- Nginx

常用方法：

可以通过设置HTTP Header来控制缓存策略，一般有如下几种。
- 强缓存
- Expires：HTTP/1.0
- Cache-Control：HTTP/1.1
- 协商缓存
- ETag + If-None-Match
- Last-Modified + If-Modified-Since

#### 更高版本的HTTP
>使用高版本HTTP提升性能。

常用工具：
- HTTP/2

HTTP/2较HTTP/1.1最大的改进在于：

- 多路复用：单一TCP连接，多HTTP请求，有Demo；
- 头部压缩：减少HTTP头体积；
- 请求优先级：优先获取重要的数据；
- 服务端推送：主动推送CSS等静态资源。

其他方法：  
HTTP/3：基于UDP，有很多方面的性能改进，如多路复用无队头阻塞，响应更快。

#### Web Socket
>解决HTTP协议无法实时通信的问题。

Web Socket是一条有状态的TCP长连接，用于实现实时通信、实时响应。

#### 服务器端渲染（SSR）
>第一次访问时，服务器端直接返回渲染好的页面。

一般流程：
- 浏览器向 URL 发送请求；
- 服务器端返回“空白”index.html；
- 浏览器不能呈现页面，需要继续下载依赖；
- 加载所有脚本后，组件才能被渲染。

SSR流程：
- 浏览器向 URL 发送请求；
- 服务器端执行JS完成首屏渲染并返回；
- 浏览器直接呈现页面，然后继续下载其他依赖；
- 加载所有脚本后，组件将再次在客户端呈现。它将对现有View进行合并。

常用工具：
- Node.js，用于服务器端执行代码，输出HTML给浏览器，支持所有主流前端框架
- Next.js，用于服务器端渲染React的框架
- gatsby，用React生成静态网站的工具

除了可以提升页面用户体验，还能应用于`SEO`。

### 减少重排重绘
>除了网络资源以外，另一个影响前端性能的因素就是前端页面的渲染绘制效率。
虽然不同的前端框架有一些差异，但整体的优化思路是一致的，这里将以React举例。


#### 减少渲染量
>不渲染未展示的部分。

常用工具：
- react-window
- react-loadable
- JS原生，如IntersectionObserver
- 框架提供，如React.lazy、react-intersection-observer

常用方法：
- 虚拟列表：只渲染可见区；
- 惰性加载：无限滚动；
- 按需加载：页面只在切换过去时才加载。

#### 减少渲染次数
>避免重复的渲染。

常用工具：
- lodash
- JS或框架自带


常用方法：
- 防抖与节流；
- 对于React函数组件来说，合理使用副作用，拆分无关联的副作用；
- 对于React类组件来说，可以使用shouldComponentUpdate或使用PureComponent来优化渲染；
- 利用缓存，如React.memo；
- 使用requestAnimationFrame替代setInterval执行动画。


### 改善JS性能
>因为浏览器是单线程异步模型，长时间的运算会阻塞渲染过程，所以改善复杂运算有助于改善前端的整体性能。

#### 缓存复杂计算
>避免重复计算。

常用方法：

对于React函数组件来说，可以使用useMemo缓存复杂计算值。
举例如下，memoizedValue需要经过复杂计算才能得到，此时就可以使用useMemo缓存，仅仅在输入参数发生变化时才重新计算，避免计算阻塞页面渲染，从而避免页面卡顿。
``` javascript
const MyFunctionalComponent = () => {
  const memoizedValue = useMemo(() => {
    computeExpensiveValue(a, b);
  }, [a, b]);
  return <AComponent value={memoizedValue}/>;
}

```

但useMemo自身也有性能消耗，需要视情况使用，某些场景可以利用React的渲染机制避免性能问题，可以参考[《Before You memo()》](https://overreacted.io/before-you-memo/)。


#### Web Worker

>多线程思想。

常用方法：
- Dedicated Workers，处理与UI无关的密集型数学计算：大数据集合排序、数据压缩、音视频处理；
- Service Worker，服务端推送，或者PWA中配合CacheStorage在前端控制缓存资源；
- Shared Worker，Tab间通信。

JS语言在设计之初就是单线程异步模型，好处是可以高效处理I/O操作，但坏处是无法利用多核CPU。

Web Worker会启动系统级别的线程，可进行多线程编程，发挥多核的性能。

#### Web Assembly
>将复杂的计算逻辑编译为Web Assembly，避免JS类型推断过程中的性能开销，可用于性能的极限优化。

## 总结

\{% label 导致前端性能问题的因素是多方面的。 blue %\}

如果是前端资源加载慢，导致页面慢，则应该考虑如何缩短请求耗时。而如果是前端页面逻辑笨重，UI数据量太大，则可以试着从减少重排重绘的角度去优化。对于耗时长的复杂计算，缓存计算结果往往是见效较快的优化方式。

最后需要注意的是，在实际应用开发过程中，因为受限于开发成本，所以需要平衡优化所花的代价与其对应产生的成效。可以有针对性地对性能瓶颈进行分析和处理，同时也需要避免引入不必要的优化措施，以确保最终优化效果。