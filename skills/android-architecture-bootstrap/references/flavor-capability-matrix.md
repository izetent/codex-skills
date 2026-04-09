# Flavor 能力矩阵

## 核心原则

flavor 不是简单渠道名，而是构建时能力差异的表达方式。

当差异是：

- 分发渠道
- GMS / 非 GMS
- full / minimal
- 社区版 / 企业版
- 内部版 / 公版

优先设计 capability matrix，而不是在运行时代码里到处判断。

## 先定义的内容

- flavor dimension 有几个
- 每个 dimension 表达什么差异
- 差异属于依赖、资源、能力、品牌、后端、还是发布
- 哪些能力在编译时裁剪，哪些能力只通过 feature flag 控制

## 常见 dimension

### distribution

- play
- fdroid
- enterprise

### capability

- full
- minimal
- gms
- oss

### environment

- dev
- qa
- prod

## 设计规则

- 一个 flavor dimension 只表达一种差异
- 编译期可裁剪的能力尽量不要留到运行时判断
- flavor 差异大的模块，依赖通过 `fullImplementation` / `minimalImplementation` 等作用域显式表达
- flavor 相关 BuildConfig、applicationIdSuffix、versionNameSuffix 要有统一规则

## 什么时候用 flavor

适合：

- 包名不同
- 上架渠道不同
- 依赖包不同
- 合规能力不同
- 明显要在构建时裁掉能力

## 什么时候不用 flavor

- 单纯 UI 实验开关
- 小流量远程实验
- 运行时可控的业务开关

这类场景优先 feature flag。

## 能力矩阵文档建议

至少列：

- 每个 flavor 的 applicationId
- 关键依赖差异
- 关键能力差异
- 发布渠道
- 测试覆盖范围
- owner

## 常见错误

- 只定义 flavor 名，不定义其真实能力边界
- flavor 和 feature flag 职责混乱
- 大量运行时 `if (isXFlavor)` 散落业务代码
- flavor 差异没有测试和发布策略配套
