# 多 App 与设备族架构

## 适用场景

- 同仓维护多个 Android App
- 手机 + Wear + Automotive 并行
- 主应用 + 认证器 + 桥接器 + 测试壳
- 一套核心能力要被多个壳复用

## 核心原则

多 App 同仓时，先拆 `app shell`，再拆共享能力；不要先把所有能力扔进一个 `common` 再慢慢收拾。

## 典型形态

### 形态 A：单主 App

适合：

- 单一手机产品
- 没有独立 wearable / automotive / authenticator 产品线

### 形态 B：主 App + 轻量附属 App

适合：

- 主 App 之外还有独立认证器、桥接器、测试壳
- 附属 App 生命周期和发布节奏与主 App 接近

推荐结构：

```text
app/
authenticator/
authenticatorbridge/
testharness/
core/
feature/
platform/
ui/
```

### 形态 C：设备族同仓

适合：

- 手机、Wear、Automotive 共用一部分能力
- 平台能力、设计系统、数据层有明显复用

推荐结构：

```text
app/
wear/
automotive/
common/
core/
feature/
platform/
resources/
```

## app shell 规则

每个 app shell 只负责：

- Application 入口
- 该壳自己的导航根
- 该壳的依赖装配
- 该壳的 flavor、签名、清单与发布配置
- 设备形态特有 UI 和系统集成

不负责：

- 通用业务实现
- 通用数据层
- 通用设计系统

## `common` 的使用边界

`common` 只在下面场景成立：

- 真正跨多个 app shell 复用
- 生命周期与壳解耦
- 不依赖某个具体壳的清单、权限、入口

如果只是单个 app shell 在用，不要提前放 `common`。

## 设备族差异处理

优先分三层：

1. 共享业务与数据
2. 共享交互 contract
3. 设备特有入口和 UI

不要把设备差异全部推到共享模块里做大量 `if`。

## 依赖规则

- app shell 依赖 shared feature / common / core / platform
- shell 之间不互相依赖实现
- common 不依赖具体 app shell
- 设备特有模块只暴露必要 contract，不回灌主壳实现

## 什么时候要独立 app shell

满足任一条件可考虑独立：

- 独立上架或独立发布
- 独立权限和清单差异明显
- 独立测试与验证链路
- 独立品牌或合规要求
- 体量和 owner 已经接近独立产品

## 什么时候只做 feature / module 即可

- 只是主 App 内的一条能力
- 没有独立入口
- 没有独立发布或设备壳
- 生命周期和权限差异不大

## 常见错误

- 所有设备形态都塞进一个 app module
- 先建 `common`，再把所有东西塞进去
- 多个 app shell 之间直接互调实现
- 测试壳和正式壳混用发布与依赖配置
