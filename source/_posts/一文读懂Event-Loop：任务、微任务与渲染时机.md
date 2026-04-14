---
title: 一文读懂Event Loop：任务、微任务与渲染时机
date: 2026-04-14
tags: [JavaScript, Event Loop, 宏任务, 微任务, 浏览器渲染]
categories: 理论知识-前端
description: 从执行栈、任务队列到渲染阶段，系统理解Event Loop的调度顺序与实战影响。
cover: /images/cover/event-loop-guide-cover.svg
---

JavaScript是单线程语言，但浏览器中的异步行为却非常丰富。很多线上问题并不是“不会写异步”，而是对执行顺序理解不完整：为什么`Promise.then`总比`setTimeout`先执行，为什么页面偶尔会“卡一下”，为什么同样的代码在Node.js和浏览器里顺序不同。要回答这些问题，核心都绕不开`Event Loop`。

## Event Loop到底解决了什么问题

JavaScript一次只能执行一个调用栈中的任务。如果所有操作都同步执行，网络请求、计时器、用户交互都将阻塞主线程。`Event Loop`负责在“调用栈清空后”调度待执行任务，使同步代码与异步回调可以有序协作。

可以把运行时拆成四个关键部件：

- **Call Stack（调用栈）**：当前正在执行的函数。
- **Web APIs / Host APIs**：`setTimeout`、`fetch`、DOM事件等由宿主环境提供。
- **Task Queue（任务队列）**：也常称宏任务队列，存放计时器、I/O、事件回调等。
- **Microtask Queue（微任务队列）**：存放`Promise.then`、`queueMicrotask`、`MutationObserver`回调。

![Event Loop示意图](/images/cover/event-loop-guide-cover.svg)

## 一轮循环的执行顺序

在浏览器中，一次典型调度可概括为：

1. 执行一个宏任务（例如整段脚本、定时器回调、点击事件回调）。
2. 宏任务结束后，立即清空所有微任务。
3. 视情况进入渲染阶段（样式计算、布局、绘制）。
4. 开启下一轮宏任务。

这意味着：**微任务优先级高于下一轮宏任务**。因此`Promise.then`通常会先于`setTimeout(fn, 0)`执行。

## 常见API在队列中的位置

| API/来源 | 队列类型 | 典型说明 |
| --- | --- | --- |
| 整体脚本script | 宏任务 | 页面加载后首先执行 |
| `setTimeout` / `setInterval` | 宏任务 | 到时间后进入任务队列，非“准点执行” |
| DOM事件回调 | 宏任务 | 事件触发后排队执行 |
| `Promise.then/catch/finally` | 微任务 | 当前宏任务结束后立即执行 |
| `queueMicrotask` | 微任务 | 显式投递微任务 |
| `requestAnimationFrame` | 渲染前回调 | 发生在浏览器下一次绘制前 |

## 代码验证：谁先执行

下面示例可直接在浏览器控制台运行：

```js
console.log("script start");

setTimeout(() => {
  console.log("setTimeout");
}, 0);

Promise.resolve()
  .then(() => {
    console.log("promise 1");
  })
  .then(() => {
    console.log("promise 2");
  });

queueMicrotask(() => {
  console.log("queueMicrotask");
});

console.log("script end");
```

预期输出顺序：

1. `script start`
2. `script end`
3. `promise 1`
4. `queueMicrotask`
5. `promise 2`
6. `setTimeout`

解释要点：

- 整段脚本先作为一个宏任务执行。
- 同步日志优先输出。
- 当前宏任务结束后清空微任务队列，微任务之间按入队顺序继续执行。
- 最后才轮到下一轮宏任务中的`setTimeout`回调。

## 可执行示例：避免微任务“饿死”渲染

大量连续微任务会推迟渲染与用户输入响应。下面给出一个可执行的“分片处理”方案，把重计算拆到多个宏任务中：

```html
<!doctype html>
<html lang="zh-CN">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>Event Loop分片处理示例</title>
  <style>
    body { font-family: Arial, sans-serif; padding: 20px; }
    #progress { margin-top: 10px; color: #0f766e; font-weight: bold; }
  </style>
</head>
<body>
  <button id="start">开始计算</button>
  <div id="progress">等待开始</div>

  <script>
    const btn = document.getElementById("start");
    const progress = document.getElementById("progress");

    function chunkedWork(total, chunkSize, onProgress, onDone) {
      let i = 0;

      function runChunk() {
        const end = Math.min(i + chunkSize, total);
        while (i < end) {
          // 模拟CPU计算
          Math.sqrt(i * Math.random());
          i++;
        }

        onProgress(i, total);

        if (i < total) {
          // 交还主线程，给渲染和交互机会
          setTimeout(runChunk, 0);
        } else {
          onDone();
        }
      }

      runChunk();
    }

    btn.addEventListener("click", () => {
      progress.textContent = "计算中...";
      chunkedWork(
        2000000,
        50000,
        (done, total) => {
          progress.textContent = `进度：${Math.floor((done / total) * 100)}%`;
        },
        () => {
          progress.textContent = "完成";
        }
      );
    });
  </script>
</body>
</html>
```

## 实战建议：写异步代码时的三个判断

1. **是否依赖立即状态一致性**：若需要在当前宏任务结束后马上读取更新结果，可用微任务。
2. **是否可能阻塞渲染**：重计算优先分片到宏任务，必要时配合`requestAnimationFrame`。
3. **是否需要稳定时序**：不要假设`setTimeout(fn, 0)`“立刻执行”，它只表示“最早下一轮”。

## 小结

`Event Loop`的本质不是“谁更快”，而是“谁先被调度”。理解“宏任务执行完再清空微任务，再考虑渲染”的顺序后，绝大多数异步时序问题都可以解释。工程实践中，建议把微任务用于轻量状态收敛，把重任务拆分到多个宏任务，既保证时序正确，也保证页面可交互性。
