# Build Logic 与 Gradle 治理

## 目标

生产级 Android 项目必须把工程治理前移到构建系统，而不是把规则留给人工记忆。

## 推荐基建

- `version catalog`
- `build-logic` 或等价 convention plugin 工程
- 统一 Kotlin、AGP、Compose、Hilt、测试、Lint 配置
- 模块模板和依赖模板
- 自定义 lint 或 build rule
- 统一 CI 任务编排

## 目录建议

```text
build-logic/
  convention/
    android-application
    android-library
    android-compose-library
    jvm-library
    android-hilt
    android-room
    android-test
    android-benchmark
lint-rules/
gradle/
  libs.versions.toml
```

## 必须统一的内容

- compileSdk / minSdk / targetSdk
- Java / Kotlin toolchain
- Compose 和 compiler 选项
- 测试框架与覆盖率
- lint 报告和 baseline 策略
- 打包、混淆、签名与变体命名
- 仓库源和依赖解析策略

## 质量门禁建议

至少有：

- 编译成功
- 单元测试
- 自定义 lint
- Kotlin / XML / Compose 规范检查
- 关键模块 API 变更检查
- benchmark 或 baseline profile 更新检查

## 推荐的 CI 任务分层

- 快速门禁：格式、lint、核心单测
- 合并前门禁：全量单测、核心集成测、主要 flavor 构建
- 发布前门禁：性能回归、基线 profile、冒烟测试、包体阈值、混淆映射归档

## 依赖治理建议

- 依赖统一从 version catalog 走
- 新增基础库要有准入标准
- 明确哪些库允许 feature 直接依赖，哪些只能经 core / platform 暴露
- 高风险依赖必须记录 owner 和升级策略

## Build Variant 设计

至少提前定义：

- 环境：dev、qa、staging、prod
- 渠道：play、internal、enterprise 或地域渠道
- 是否需要实验 / internal 能力
- 版本号策略和构建元信息注入

## 建议固化的自定义规则

- 禁止 feature 直接访问数据库或网络底层
- 禁止模块错误依赖方向
- 禁止设计系统外硬编码颜色和间距
- 禁止在非入口模块手动创建全局单例
- 禁止在错误层级使用不允许的注解处理器或插件

## 构建性能建议

- 开启本地和远程缓存时要有明确策略
- 版本和依赖不要到处动态解析
- 拆模块前先看是否真的带来增量收益
- 编译热点模块优先治理 annotation processor、KSP/KAPT 使用和资源体积

## 常见错误

- 每个模块自己配一遍 Android 配置
- 项目越大，规则越分散
- 新模块靠复制旧模块手工删改
- 质量门禁靠 PR 评论提醒而不是自动化
