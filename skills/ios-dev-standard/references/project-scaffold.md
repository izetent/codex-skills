# 项目架子

## 目录

- 根目录结构
- 每层职责
- Feature 模板
- 全局能力
- 配置和脚本
- 新需求落点

## 根目录结构

默认新项目结构：

```text
ProjectName/
  App/
  Core/
  Domain/
  Data/
  Session/
  Features/
  Shared/
  Resources/
  Configs/
  Tests/
  Tools/
  Docs/
```

小项目可以先保留目录边界，不必立即拆成多个 framework 或 package。只有当复用、编译隔离、团队边界明确时再拆模块。

## 每层职责

```text
App
  AppEntry, AppDelegate/SceneDelegate, RootCoordinator, Bootstrap, DependencyContainer.

Core
  Network, Storage, Cache, Keychain, Theme, DesignSystem, Localization, Logger,
  Analytics, Configuration, Extensions.

Domain
  Entities, Repository protocols, UseCases, business errors.

Data
  DTO, Remote API, LocalDataSource, Mappers, Repository implementations.

Session
  Auth state, current user, token state, shared runtime state.

Features
  Business screens and screen-level state orchestration.

Shared
  Reusable UI and presentation primitives.

Resources
  Assets, localized strings, fonts, privacy manifests.

Configs
  Debug/Staging/Release xcconfig and local secret examples.

Tests
  Unit, snapshot, integration, UI, test support.

Tools
  Setup, lint, format, generation, CI helper scripts.
```

## Feature 模板

SwiftUI：

```text
Features/FeatureName/
  FeatureNameRoute.swift
  FeatureNameCoordinator.swift
  FeatureNameScreen.swift
  FeatureNameViewModel.swift
  FeatureNameModels.swift
  Components/
  Mapper/
  Tests/
```

UIKit：

```text
Features/FeatureName/
  Coordinator/
  Controller/
  ViewModel/
  View/
  Model/
  Mapper/
  Tests/
```

## 全局能力

项目第一天规划：

- AppButton、AppTextField、Avatar、SearchBar、ListRow。
- Toast。
- Dialog。
- Bottom Sheet。
- Full Screen Modal。
- Loading、Empty、Error、Retry。
- Theme token：color、typography、spacing、radius、shadow、motion。
- HTTP client。
- Keychain store。
- UserDefaults store。
- Cache policy。
- Session store。
- Logger。
- Environment config。

## 配置和脚本

建议：

```text
Configs/
  Debug.xcconfig
  Staging.xcconfig
  Release.xcconfig
  Secrets.example.xcconfig

Tools/
  setup.sh
  lint.sh
  format.sh
  test.sh
  generate-feature.sh
```

规则：

- 真实密钥不提交。
- 环境 baseURL 不散落在代码。
- 本地签名和私有配置不污染工程文件。
- 依赖版本锁定。

## 新需求落点

```text
页面 -> Features/<Feature>/
业务规则 -> Domain/UseCases/
业务协议 -> Domain/Repositories/
接口实现 -> Data/Remote/
DTO -> Data/DTO/
模型转换 -> Data/Mappers/ 或 Features/<Feature>/Mapper/
缓存实现 -> Data/Local/ 或 Core/Cache/
共享状态 -> Session/
通用 UI -> Shared/
主题 token -> Core/Theme/
设计系统组件 -> Core/DesignSystem/
测试 -> Tests/ 或 Feature/Tests/
```
