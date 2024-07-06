---
title: Springboot整合Hutool自定义注解实现数据脱敏
date: 2023/11/02
tags: JAVA,SPRINGBOOT,脱敏
categories: JAVA
description: 我们在项目中会处理敏感数据（如手机号、身份证号、姓名、地址等）时，通常需要对这些数据进行脱敏，以确保数据隐私和安全。
keywords: JAVA,SPRINGBOOT,脱敏
cover: /img/md/spring.jpg
---

# 什么是数据脱敏
数据脱敏（Data Masking），也称为数据遮蔽或数据隐藏，是一种数据保护技术，用于处理和存储敏感数据时，以减少或消除数据中的敏感信息，从而保护数据的隐私和安全。数据脱敏的主要目的是在保持数据可用性的同时，减少数据泄露和滥用的风险。
数据脱敏一般指数据库正常存储，返回前端时进行数据库处理！

# Hutool简介
Hutool是一个小而全的Java工具类库，通过静态方法封装，降低相关API的学习成本，提高工作效率，使Java拥有函数式语言般的优雅。
Hutool是项目中“util”包友好的替代，它节省了开发人员对项目中公用类和公用工具方法的封装时间，使开发专注于业务，同时可以最大限度的避免封装不完善带来的bug。
虽然Hutool可能会有一些bug，比起小编写的还是强上不少的，所以选定它来！
现在最新版为：5.8.16，我们直接使用最新的，bug会少一些，功能会完善一些！
支持的脱敏规则：

- 用户id
- 中文姓名
- 身份证号
- 座机号
- 手机号
- 地址
- 电子邮件
- 密码
- 中国大陆车牌，包含普通车辆、新能源车辆
- 银行卡

# 实战整合

## 导入依赖
```xml
<dependency>
    <groupId>cn.hutool</groupId>
    <artifactId>hutool-all</artifactId>
    <version>5.8.16</version>
</dependency>

```

## 自定义注解
@JsonSerialize(using = SensitiveInfoSerializer.class)用于指定在序列化时应该使用哪个自定义序列化器类
需要和下面的注解搭配使用SensitiveInfoSerializer我们自定义的序列化器才会生效
@JacksonAnnotationsInside 主要用于标记其他自定义注解，这意味着你可以在一个 Jackson 注解内部使用其他自定义注解，以组合各种注解来实现更复杂的序列化和反序列化逻辑。

```java
@JacksonAnnotationsInside
@JsonSerialize(using = SensitiveInfoSerializer.class)
@Retention(RetentionPolicy.RUNTIME)
@Target(ElementType.FIELD)
public @interface Desensitization {

    DesensitizationType type() default DesensitizationType.DEFAULT;

    /**
     * 前置不需要打码的长度
     */
    int prefixLen() default 0;

    /**
     * 后置不需要打码的长度
     */
    int suffixLen() default 0;

    /**
     * 遮罩字符
     */
    String maskingChar() default "*";
}
```

## 支持类型枚举
```java
 */
public enum DesensitizationType {
    // 自定义规则
    CUSTOMIZE_RULE,
    // 默认的
    DEFAULT,
    //用户id
    USER_ID,
    //中文名
    CHINESE_NAME,
    //身份证号
    ID_CARD,
    //座机号
    FIXED_PHONE,
    //手机号
    MOBILE_PHONE,
    //地址
    ADDRESS,
    //电子邮件
    EMAIL,
    //密码
    PASSWORD,
    //中国大陆车牌，包含普通车辆、新能源车辆
    CAR_LICENSE,
    //银行卡
    BANK_CARD
}
```
## 自定义序列化器
关于自定义的规则，大家可以根据自己的需求来写工具类，我这里简单使用Hutool的工具来了！
StrUtil.replace(value, prefixLen, suffixLen, maskingChar)
StrUtil.hide(value, prefixLen, suffixLen)
createContextual 方法首先在序列化过程开始时被调用，返回的序列化器实例将用于后续的序列化过程。
serialize 方法责实际的序列化逻辑，将字段的值转换为JSON，并可以在其中执行自定义的脱敏逻辑。

```java
/**
 * 数据脱敏序列化器
 *
 */
public class SensitiveInfoSerializer extends JsonSerializer<String> implements ContextualSerializer {

    private boolean useMasking = false;
    private DesensitizationType type;
    private int prefixLen;
    private int suffixLen;
    private String maskingChar;

    @Override
    public void serialize(String value, JsonGenerator gen, SerializerProvider serializers) throws IOException {
        if (useMasking && value != null) {
            switch (type) {
                case MOBILE_PHONE:
                    gen.writeString(DesensitizedUtil.mobilePhone(value));
                    break;
                case ID_CARD:
                    gen.writeString(DesensitizedUtil.idCardNum(value, prefixLen, suffixLen));
                    break;
                case CUSTOMIZE_RULE:
//                    gen.writeString(StrUtil.replace(value, prefixLen, suffixLen, maskingChar));
                    gen.writeString(StrUtil.hide(value, prefixLen, suffixLen));
                    break;
                case CHINESE_NAME:
                    gen.writeString(DesensitizedUtil.chineseName(value));
                    break;
                case DEFAULT:
                    gen.writeString(value);
                default:
                    gen.writeString(value);
            }
        } else {
            gen.writeObject(value);
        }
    }

    @Override
    public JsonSerializer<?> createContextual(SerializerProvider prov, BeanProperty property) {
        if (property != null) {
            Desensitization desensitization = property.getAnnotation(Desensitization.class);
            if (desensitization != null) {
                this.type = desensitization.type();
                this.prefixLen = desensitization.prefixLen();
                this.suffixLen = desensitization.suffixLen();
                this.maskingChar = desensitization.maskingChar();
                useMasking = true;
            }
        }
        return this;
    }
}
```

## 实体类应用
```java
@Data
public class User {

    @Desensitization(type = DesensitizationType.ID_CARD,prefixLen = 6,suffixLen = 16)
    private String cardId;

    @Desensitization(type = DesensitizationType.CHINESE_NAME)
    private String name;

    @Desensitization(type = DesensitizationType.MOBILE_PHONE)
    private String phone;

    @Desensitization(type = DesensitizationType.CUSTOMIZE_RULE,prefixLen = 3,suffixLen = 6)
    private String info;
}
```

# 总结
本文通过Spring Boot与Hutool库的结合使用自定义注解，提供了一个简单而强大的方式来实现数据脱敏。希望能帮助到你，成功地实现数据脱敏功能，并提高应用程序的安全性。

本次例子脱敏选项没有演示全，大家可以自行补充完成，成为你们需要的数据脱敏策略，从而完美的处理用户数据脱敏问题！