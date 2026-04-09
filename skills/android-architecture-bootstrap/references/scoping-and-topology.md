# 项目范围与架构基线

## 适用场景

- 新项目立项
- 单模块项目准备升级
- 需要判断该拆到什么程度
- 需要给团队选一套能落地的架构基线

## 先确认的 10 个问题

1. 这个 App 的主业务域有几个
2. 团队现在和半年后的规模大概多少
3. 是否多人并行开发同一条主链路
4. 是否需要多环境、多渠道、多 flavor
5. 是否有明显的离线、同步、下载、上传、推送、WebView、支付能力
6. 是否支持平板、折叠屏、横屏、外接键盘、大字体、RTL
7. 是否需要严格埋点、灰度、远程开关、合规审计
8. 是否要长期维护存量代码并逐步迁移
9. 构建速度和 CI 时间是否已经成为痛点
10. 是否需要插件点、内部开关、企业版 / 海外版 / 定制版差异化能力

## 架构目标写法

推荐把目标写成 5 到 8 条可验证陈述：

- feature 可独立开发和回归
- 模块依赖方向清晰，跨业务依赖只能走 contract
- 数据真相源明确，不允许页面自行拼接底层数据源
- 启动、列表、同步链路有性能预算和监控
- 兼容策略覆盖目标设备矩阵
- 新增模块和页面有统一模板和门禁

## 基线选择建议

### 基线 A：小团队轻量型

适合：

- 1 到 3 人
- 业务域不多
- 0 到 1 速度优先
- 未来可能扩展但目前复杂度不高

推荐结构：

```text
app
build-logic
core
feature
platform
resources
benchmark
```

规则：

- 先不强上 `api / impl / internal`
- feature 间尽量通过 domain contract 或 navigation contract 解耦
- 先把 build-logic、版本管理、状态建模、性能基建搭起来

### 基线 B：中型团队模块化

适合：

- 4 到 10 人
- 多个业务域并行
- 页面和平台能力逐渐复杂

推荐结构：

```text
app
build-logic
core
feature/<name>-api
feature/<name>-impl
platform
resources/design-system
benchmark
lint-rules
```

规则：

- 外部依赖 feature 时只依赖 `api`
- `app` 是唯一组合根
- 架构规则开始编译期固化

### 基线 C：大型强治理型

适合：

- 10 人以上
- 多团队并行
- 多环境、多渠道、多平台能力、灰度和可观测性要求高

推荐结构：

```text
app
build-logic
lint-rules
core
platform
feature/<name>-api
feature/<name>-impl
feature/<name>-internal
resources/design-system
benchmark
quality
```

规则：

- 依赖方向、模块模板、lint、质量门禁必须工程化
- 内部能力、实验能力和公开能力分层
- 关键基建有 owner

### 基线 D：Brownfield 渐进迁移型

适合：

- 已有大体量存量项目
- 不能停下业务线重写

规则：

- 先定义新边界，再要求新增代码走新边界
- 以功能域为单位迁移，不按目录大搬家
- 先迁移入口、依赖方向、数据源，再考虑统一风格
- 每一轮迁移必须可回滚

## 不要过度模块化的信号

- 模块多于实际 owner 数量
- 每次改一个小需求要跨十几个空壳模块
- `api` 里没有稳定契约，只有转发代码
- 构建更慢、定位更难、边界并没有更清晰

## 推荐输出

在真正设计前，先输出：

- 项目约束摘要
- 建议采用哪条基线
- 选择理由
- 不选其他基线的理由
