---
title: PostgreSQL索引指南：原理、实战与类型比较
date: 2026-04-14
tags: [PostgreSQL, 索引, 数据库性能, B-Tree, EXPLAIN]
categories: 理论知识-数据库
description: 系统讲清PostgreSQL索引的工作机制、典型用法与索引类型对比，帮助你做出更稳妥的建索引决策。
cover: /images/cover/postgresql-index-guide.svg
---

## 描述

在PostgreSQL中，索引的核心价值是用额外的存储与写入成本，换取更快的查询性能。很多项目在出现慢SQL时才开始补索引，但如果不了解索引类型、扫描方式和代价模型，就容易出现“建了索引但查询仍慢”的情况。本文从原理、示例和类型比较三个角度，建立一套可落地的索引认知框架。

## 正文

### 什么是索引

可以把索引理解为“有序目录”。没有索引时，数据库通常需要全表扫描；有合适索引时，优化器可以先定位到更小的数据范围，再回表或直接返回结果，从而显著降低I/O与CPU消耗。

一个索引是否“有效”，取决于三件事：

- 查询条件是否命中索引前导列；
- 谓词选择性是否足够高（过滤后剩余数据量小）；
- 优化器估算成本后是否愿意使用该索引。

### B-Tree索引：默认且最常用

`B-Tree`是PostgreSQL默认索引类型，适用于等值查询、范围查询和排序场景。

```sql
CREATE TABLE orders (
  id BIGSERIAL PRIMARY KEY,
  user_id BIGINT NOT NULL,
  status TEXT NOT NULL,
  total_amount NUMERIC(12,2) NOT NULL,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- 单列索引：常见过滤条件
CREATE INDEX idx_orders_user_id ON orders(user_id);

-- 复合索引：匹配 where + order by
CREATE INDEX idx_orders_user_created ON orders(user_id, created_at DESC);
```

当查询为以下形式时，复合索引通常比两个单列索引更稳定：

```sql
SELECT id, total_amount, created_at
FROM orders
WHERE user_id = 1024
ORDER BY created_at DESC
LIMIT 20;
```

### PostgreSQL常见索引类型比较

| 索引类型 | 典型场景 | 优势 | 局限 |
| --- | --- | --- | --- |
| B-Tree | 等值、范围、排序、唯一约束 | 通用性强，优化器支持成熟 | 对模糊包含、数组包含不擅长 |
| Hash | 等值匹配 | 等值查询语义直接 | 场景窄，工程中使用较少 |
| GIN | 全文检索、JSONB、数组包含 | 多值字段检索能力强 | 写入与维护成本较高 |
| GiST | 几何、地理、相似度检索 | 支持复杂数据类型与距离类查询 | 设计与调优复杂度较高 |
| BRIN | 超大表且数据与物理顺序相关 | 体积小、建索引快 | 精度较粗，依赖数据分布 |

### 示例：JSONB与全文场景为什么偏向GIN

当业务表有`jsonb`字段并存在“键值包含”检索时，`GIN`通常优于`B-Tree`。

```sql
CREATE TABLE events (
  id BIGSERIAL PRIMARY KEY,
  payload JSONB NOT NULL,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_events_payload_gin ON events USING GIN (payload);

-- 查询包含特定键值
SELECT id
FROM events
WHERE payload @> '{"channel":"app"}';
```

如果改用`B-Tree`直接索引整个`payload`列，通常难以高效支持`@>`这类包含操作；这正是“索引类型应和操作符匹配”的典型例子。

### 什么时候不该急着建索引

- 表很小且查询频率低，全表扫描成本可接受；
- 写多读少，过多索引会明显放大写入延迟；
- 查询条件经常变化，索引命中率低；
- 统计信息陈旧导致误判，应先`ANALYZE`再评估。

## 可执行

下面是一套可直接在测试库验证的索引实验脚本：先构造数据，再用`EXPLAIN (ANALYZE, BUFFERS)`对比建索引前后执行计划。

```sql
DROP TABLE IF EXISTS orders_bench;

CREATE TABLE orders_bench (
  id BIGSERIAL PRIMARY KEY,
  user_id BIGINT NOT NULL,
  status TEXT NOT NULL,
  total_amount NUMERIC(12,2) NOT NULL,
  created_at TIMESTAMPTZ NOT NULL
);

INSERT INTO orders_bench (user_id, status, total_amount, created_at)
SELECT
  (random() * 100000)::BIGINT,
  (ARRAY['pending', 'paid', 'canceled'])[1 + (random() * 2)::INT],
  (random() * 2000)::NUMERIC(12,2),
  NOW() - ((random() * 365)::INT || ' days')::INTERVAL
FROM generate_series(1, 1000000);

ANALYZE orders_bench;

-- 建索引前
EXPLAIN (ANALYZE, BUFFERS)
SELECT id, total_amount, created_at
FROM orders_bench
WHERE user_id = 9527
ORDER BY created_at DESC
LIMIT 20;

-- 建复合索引
CREATE INDEX idx_orders_bench_user_created
ON orders_bench(user_id, created_at DESC);

ANALYZE orders_bench;

-- 建索引后再对比
EXPLAIN (ANALYZE, BUFFERS)
SELECT id, total_amount, created_at
FROM orders_bench
WHERE user_id = 9527
ORDER BY created_at DESC
LIMIT 20;
```

观察重点：

- 扫描类型是否从`Seq Scan`变为`Index Scan`或`Bitmap Heap Scan`；
- 总耗时与共享缓冲区读取是否下降；
- 在不同`user_id`分布下，计划是否稳定。

## 小结

PostgreSQL索引不是“越多越好”，而是“是否与查询模式匹配”。工程实践中，可按以下顺序决策：先识别高频慢查询，再根据谓词和操作符选择索引类型，最后用`EXPLAIN (ANALYZE, BUFFERS)`做实测验证。把索引设计从“经验补丁”升级为“证据驱动”，性能优化会更可控，也更可复用。
