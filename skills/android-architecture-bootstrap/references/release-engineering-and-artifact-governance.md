# 发布工程与制品治理

## 目标

发布治理要让版本、签名、产物命名、灰度、说明和回滚都有稳定落点。

## 版本治理

提前定义：

- versionName 来源
- versionCode 来源
- 本地构建与 CI 构建策略
- beta / release / internal 的命名规则

## 签名与凭据

推荐：

- release keystore 通过环境变量或 CI secret 注入
- 本地只保留 debug 签名
- 不把真实签名材料提交仓库

## 制品命名

建议：

- APK / AAB 输出名与 applicationId、flavor、buildType 有稳定映射
- 同一产品家族的产物命名规则一致
- testharness、wear、automotive 产物可一眼区分

## 发布说明与分发

- release notes 来源明确
- Beta / 内部分发的分组策略明确
- 映射文件、native symbol、baseline profile 等产物归档明确

## 灰度与回滚

必须回答：

- 如何灰度
- 如何快速停用高风险能力
- 如何回滚版本或熔断功能
- 哪些信息可帮助定位线上问题

## 构建兼容性

- 配置缓存友好
- 版本文件生成有明确用途
- 发布任务不要隐式依赖本地环境状态

## 常见错误

- 版本号策略本地和 CI 不一致
- 产物命名混乱，发布时人工判断
- release 与 beta 差异写死在多个地方
- 映射文件和符号文件没有归档，线上崩溃难以还原
