---
title: Spring设计模式-责任链模式
date: 2024/09/10
tags: [Java,Spring,责任链模式]
categories: 后端-知识学习
description: 设计模式是软件开发的重要组成部分。这些解决方案不仅解决了反复出现的问题，而且还通过识别通用模式来帮助开发人员了解框架的设计。
cover: /img/md/spring.jpg
---

# 责任链模式
> 责任链模式是一种行为设计模式，它允许你创建一系列对象，使每个对象都有机会处理请求。在该模式中，请求沿着对象链传递，直到最后一个责任链对象为止，。

## 责任链模式的要点
1. Handler 接口：定义了处理请求的接口，通常包含一个处理请求的方法。
2. ConcreteHandler 具体处理者类：实现了处理请求的方法，并决定是否自行处理请求或将请求传递给下一个处理者。
3. Client 客户端：创建责任链，并将请求发送到链中的第一个处理者。
在 Spring 框架中，责任链模式经常被用于实现过滤器、拦截器等功能，例如在 Spring Security 中就有一个基于责任链模式的安全过滤器链。

## 责任链模式在项目中可以用来做什么？
1. 校验用户的权限：token权限、URL权限、是否已经被管理员禁用；
2. 校验短信的数据：是否手机号码在黑名单里、参数是否合法、平台的短信功能是否开启
3. 支付回调：验签、订单状态更新、发送通知告知用户支付成功、统计订单支付成功数量、金额。

# 案例
验签、订单状态更新、发送通知告知用户支付成功、统计订单支付成功数量、金额这几个步骤进行拆分，每个步骤都是一个链条，具体代码如下：
1. 定义支付回调上下文类，用于获取各个阶段的结果，即是否处理成功；
```java
// 支付回调上下文类
@Data
class PaymentCallbackContext {
    // 签名是否有效
    private boolean signatureValid;
    // 订单状态是否更新
    private boolean orderStatusUpdated;
    // 通知是否发送
    private boolean notificationSent;
 
    public boolean isSignatureValid() {
        return signatureValid;
    }
 
    public boolean isOrderStatusUpdated() {
        return orderStatusUpdated;
    }
 
    public boolean isNotificationSent() {
        return notificationSent;
    }
 
}
```
2. 定义支付回调接口，后面每一个流程都需要实现这个接口
```java
// 支付回调处理
public interface PaymentCallbackHandler {
    // 设置下一个责任链
    void setNext(PaymentCallbackHandler handler);
    // 方法处理
    void handle(PaymentCallbackContext context);
}
```
3. 验签处理，一般通过特定的算法和公钥进行加密对比验证
```java
/**
 * 验签处理
 */
@Data
public class SignatureValidator implements PaymentCallbackHandler {
    private PaymentCallbackHandler nextHandler;
 
    @Override
    public void setNext(PaymentCallbackHandler handler) {
        this.nextHandler = handler;
    }
 
    @Override
    public void handle(PaymentCallbackContext context) {
        System.out.println("验证签名...");
        // 验签逻辑
        context.setSignatureValid(true);
        // 传递给下一个处理器
        PaymentCallbackHandler nextHandler = new OrderStatusUpdater();
            nextHandler.handle(context);
    }
}
```
4. 下一个执行链：更新订单状态处理
```java
/**
 * 订单状态更新
 */
@Data
public class OrderStatusUpdater implements PaymentCallbackHandler {
    private PaymentCallbackHandler nextHandler;
 
    @Override
    public void setNext(PaymentCallbackHandler handler) {
        this.nextHandler = handler;
    }
 
    @Override
    public void handle(PaymentCallbackContext context) {
        if (context.isSignatureValid()) {
            System.out.println("更新订单状态...");
            // 更新订单状态逻辑
            context.setOrderStatusUpdated(true);
            // 传递给下一个处理器
            if (nextHandler != null) {
                nextHandler.handle(context);
            }
        } else {
            System.out.println("验签未通过，无法更新订单状态。");
        }
    }
}
```
5. 下一个执行链：发送通知，告知用户支付成功
```java
/**
 * 发送通知处理器
 */
@Data
public class NotificationSender implements PaymentCallbackHandler {
    private PaymentCallbackHandler nextHandler;
 
    @Override
    public void setNext(PaymentCallbackHandler handler) {
        this.nextHandler = handler;
    }
 
    @Override
    public void handle(PaymentCallbackContext context) {
        if (context.isOrderStatusUpdated()) {
            System.out.println("发送支付成功通知...");
            // 发送通知逻辑
            context.setNotificationSent(true);
        } else {
            System.out.println("订单状态未更新，无法发送通知。");
        }
    }
}
```
6. 下一个执行链：统计订单支付成功的数量和金额
```java
/**
 * 实现统计处理器
 */
@Data
public class StatisticsCollector implements PaymentCallbackHandler {
    private PaymentCallbackHandler nextHandler;
 
    @Override
    public void setNext(PaymentCallbackHandler handler) {
        this.nextHandler = handler;
    }
 
    @Override
    public void handle(PaymentCallbackContext context) {
        if (context.isNotificationSent()) {
            System.out.println("统计订单支付成功数量和金额...");
            // 统计逻辑
        } else {
            System.out.println("未发送通知，无法统计订单信息。");
        }
    }
 
}
```

7. 最后，进行测试，指定各个链条之间的顺序，调用第一个责任链即可，它就会自动执行后续的责任链，代码如下：
```java
public class test {
    public static void main(String[] args) {
        new test().startPaymentCallback();
    }
 
    private void startPaymentCallback() {
        // 创建处理器实例
        PaymentCallbackHandler signatureValidator = new SignatureValidator();
        PaymentCallbackHandler orderStatusUpdater = new OrderStatusUpdater();
        PaymentCallbackHandler notificationSender = new NotificationSender();
        PaymentCallbackHandler statisticsCollector = new StatisticsCollector();
 
        // 构建责任链
        signatureValidator.setNext(orderStatusUpdater);
        orderStatusUpdater.setNext(notificationSender);
        notificationSender.setNext(statisticsCollector);
 
        // 执行责任链
        signatureValidator.handle(new PaymentCallbackContext());
    }
}
```

# 总结
将支付回调的各个步骤使用责任链模式进行拆分以后，有很多优点：
1. 解耦合：你无需关注你的下一个链条是如何实现的，只需要把自己的模块实现好即可，并且链条之间的顺序可以随意切换，在构建责任链时指定Next即可，无需去各个实现类中进行修改代码；
2. 高可扩展性：当需要新增加或者修改支付回调处理的步骤时，可以通过添加新的处理器来实现，而无需修改已有的代码。
3. 提高可读性：每一个步骤的实现代码都在独立的类中实现，这样可以更容易地理解和调试代码，不像很多业务代码一样，一大堆业务处理逻辑放在一个方法里面调来调去，很容易搞迷糊。

但是他也有一些注意事项，如下：
1. 可能造成循环调用： 如果责任链的 setNext() 设置不当，就可能会导致循环调用，栈溢出StackOverFlow;
2. 不一定适合所有情况： 责任链模式可以提高系统的灵活性和可扩展性，但是会增加代码的复杂性和代码量。在一些简单的场景下，使用责任链模式可能会显得过于复杂，也没必要；
3. 适合场景：整体的业务流程场景较为复杂，并且每个步骤之间都是有序的，需要根据不同的条件选择不同的处理流程时，责任链模式可以提供一种灵活的解决方案。