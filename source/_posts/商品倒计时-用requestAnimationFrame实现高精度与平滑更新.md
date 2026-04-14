---
title: 商品倒计时：用requestAnimationFrame实现高精度与平滑更新
date: 2026-04-14
tags: [JavaScript, 倒计时, requestAnimationFrame, 性能优化, 前端]
categories: 场景解决-前端
description: 通过对比setInterval与setTimeout，构建一个基于requestAnimationFrame的高精度商品倒计时方案。
image: /images/background/countdown-raf-cover.svg
---

在电商场景中，商品秒杀、优惠券领取、限时折扣都依赖倒计时。常见实现会使用`setInterval`或递归`setTimeout`，它们简单直接，但在页面卡顿、标签页切换或低性能设备上容易出现时间漂移。
如果希望倒计时在视觉更新上更顺滑、在性能上更可控，可以使用`requestAnimationFrame`驱动渲染，并用“绝对时间差”保证计时准确。

## setInterval与setTimeout的局限

`setInterval(fn, 1000)`看起来每秒执行一次，但它并不保证“精确每1000ms触发”。当主线程繁忙时，回调会排队延后，导致倒计时跳秒或慢半拍。递归`setTimeout`虽然能在每次执行后重新计算下一次触发，但本质上也受事件循环和主线程负载影响。
对于商品倒计时，用户更关心“真实剩余时间”，而不是“函数执行了多少次”。因此，核心应是：

- 以活动截止时间戳作为唯一真值；
- 每次渲染时动态计算`剩余时间 = 截止时间 - 当前时间`；
- 定时机制只负责“何时刷新UI”。

## requestAnimationFrame更适合做什么

`requestAnimationFrame`会在浏览器下一次重绘前调用回调，天然与渲染节奏同步，适合高频更新的界面逻辑。用于倒计时时有三个优势：

- **渲染协同**：避免与浏览器重绘节奏错位，界面更新更自然；
- **性能友好**：浏览器可在不可见场景降频或暂停无意义重绘；
- **可控更新**：可以只在“秒数变化时”更新DOM，减少不必要操作。

注意：`requestAnimationFrame`并不等于“更准确计时器”，准确性来自“每帧都用当前时间重新计算剩余值”。

![倒计时方案对比图](/images/js-timer-methods-compare.svg)

## 实现思路

1. 初始化时记录商品活动结束时间`endTime`（毫秒时间戳）。
2. 在每一帧中计算`remaining = endTime - Date.now()`。
3. 将`remaining`格式化为`HH:mm:ss`展示。
4. 仅当显示秒值发生变化时再更新DOM，降低渲染开销。
5. 当`remaining <= 0`时停止动画循环，并显示“活动已结束”。

![requestAnimationFrame倒计时流程图](/images/js-countdown-architecture.svg)

## 代码块（可执行）

```html
<!doctype html>
<html lang="zh-CN">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>商品倒计时</title>
  <style>
    body { font-family: Arial, sans-serif; padding: 24px; }
    .card { width: 320px; padding: 16px; border: 1px solid #ddd; border-radius: 8px; }
    .name { font-size: 18px; margin-bottom: 8px; }
    .timer { font-size: 28px; color: #e53935; font-weight: bold; }
    .status { margin-top: 8px; color: #666; }
  </style>
</head>
<body>
  <div class="card">
    <div class="name">无线耳机限时折扣</div>
    <div id="timer" class="timer">--:--:--</div>
    <div id="status" class="status">活动进行中</div>
  </div>

  <script>
    function formatDuration(ms) {
      const totalSeconds = Math.max(0, Math.floor(ms / 1000));
      const hours = Math.floor(totalSeconds / 3600);
      const minutes = Math.floor((totalSeconds % 3600) / 60);
      const seconds = totalSeconds % 60;
      const pad = (n) => String(n).padStart(2, "0");
      return `${pad(hours)}:${pad(minutes)}:${pad(seconds)}`;
    }

    class Countdown {
      constructor(endTime, onTick, onEnd) {
        this.endTime = endTime;
        this.onTick = onTick;
        this.onEnd = onEnd;
        this.rafId = null;
        this.lastShownSeconds = null;
      }

      start() {
        const loop = () => {
          const remaining = this.endTime - Date.now();

          if (remaining <= 0) {
            this.onTick(0);
            this.stop();
            this.onEnd && this.onEnd();
            return;
          }

          // 只在“秒”变化时刷新，减少DOM写入
          const shownSeconds = Math.floor(remaining / 1000);
          if (shownSeconds !== this.lastShownSeconds) {
            this.lastShownSeconds = shownSeconds;
            this.onTick(remaining);
          }

          this.rafId = requestAnimationFrame(loop);
        };

        this.rafId = requestAnimationFrame(loop);
      }

      stop() {
        if (this.rafId != null) {
          cancelAnimationFrame(this.rafId);
          this.rafId = null;
        }
      }
    }

    const timerEl = document.getElementById("timer");
    const statusEl = document.getElementById("status");

    // 示例：从现在起倒计时90分钟
    const endTime = Date.now() + 1 * 60 * 1000;

    const countdown = new Countdown(
      endTime,
      (remaining) => {
        timerEl.textContent = formatDuration(remaining);
      },
      () => {
        timerEl.textContent = "00:00:00";
        statusEl.textContent = "活动已结束";
      }
    );

    countdown.start();
  </script>
</body>
</html>
```

## 小结

在商品倒计时场景中，`setInterval`与`setTimeout`适合快速实现，但在复杂运行环境下容易出现更新不稳定。基于`requestAnimationFrame`的方案，将“时间计算”和“界面渲染”解耦：用绝对时间保证准确，用动画帧驱动保证流畅，并通过按秒更新减少性能消耗。
如果页面同时存在多个商品倒计时，建议统一调度一个`requestAnimationFrame`循环批量更新，进一步降低CPU与DOM开销。
