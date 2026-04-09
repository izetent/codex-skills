# 标准目录模板与模块命名

## 目标

这份文档用于给新项目或存量重构项目提供一份可直接讨论和落地的目录模板，以及统一的模块命名规范。

它不是强制唯一模板，但应作为默认起点。若项目偏离，需要说明原因。

## 顶层目录模板

推荐默认结构：

```text
app/
app-wear/
app-automotive/
build-logic/
lint-rules/
benchmark/
core/
  common/
  model/
  network/
  database/
  navigation/
  dispatcher/
  testing/
platform/
  permissions/
  notifications/
  downloads/
  upload/
  webview/
  biometrics/
  push/
resources/
  design-system/
  icons/
  strings/
feature/
  home/
  login/
  settings/
  profile/
testing/
  testing-unit/
third-party/
```

## 什么时候需要这些顶层目录

### `app` / `app-*`

适合：

- 正式发布壳
- 不同设备族壳
- 独立上架产品壳

命名建议：

- `app`
- `app-wear`
- `app-automotive`
- `app-enterprise`
- `testharness`

### `build-logic`

必须有。

适合放：

- convention plugins
- 通用 Android / Kotlin / Compose / Hilt / Test 配置
- 统一 flavor 和发布逻辑

### `lint-rules`

团队规模上来后建议尽早有。

适合放：

- 自定义 lint
- 边界治理规则
- 设计系统限制规则

### `benchmark`

有性能要求时建议默认创建。

适合放：

- Macrobenchmark
- Baseline Profile
- 启动和关键链路性能回归

### `core`

只放跨业务稳定基础设施。

命名建议：

- `core:common`
- `core:model`
- `core:network`
- `core:database`
- `core:navigation`
- `core:testing`

不要在 `core` 里放强业务语义模块。

### `platform`

适合放系统能力和外部平台集成。

命名建议：

- `platform:permissions`
- `platform:notifications`
- `platform:downloads`
- `platform:webview`
- `platform:push`

### `resources`

适合放共享资源与设计系统。

命名建议：

- `resources:design-system`
- `resources:icons`
- `resources:strings`

### `feature`

按业务域建目录，不按技术词建目录。

命名建议：

- `feature:home`
- `feature:login`
- `feature:profile`
- `feature:settings`

## feature 模块模板

### 轻量模板

适合：

- 小团队
- 业务稳定
- 暂时不需要 api / impl 分离

```text
feature/
  home/
    src/main/
    src/test/
```

模块名：

- `feature:home`
- `feature:profile`

### 标准模板

适合：

- 中大型团队
- 多 feature 并行
- 需要稳定 contract

```text
feature/
  home/
    home-api/
    home-impl/
```

模块名：

- `feature:home:home-api`
- `feature:home:home-impl`

### 强治理模板

适合：

- 大型团队
- 有内部能力、实验能力、正式能力区分

```text
feature/
  home/
    home-api/
    home-impl/
    home-internal/
```

模块名：

- `feature:home:home-api`
- `feature:home:home-impl`
- `feature:home:home-internal`

## 命名规则

### 顶层规则

- 全部使用小写字母和短横线
- 模块名尽量表达业务或能力，不表达技术细节
- 同一层级命名风格必须统一

推荐：

- `feature:device-center`
- `platform:webview`
- `resources:design-system`

不推荐：

- `feature:userFeatureModule`
- `common-utils2`
- `new_core`

### `api / impl / internal` 规则

- `api`：稳定 contract、接口、入参出参、路由能力
- `impl`：实现、UI、DI、具体业务编排
- `internal`：只给内部版、实验版、debug 或特殊发布链路使用

### `common` / `shared` 规则

除非项目真的有跨壳共享语义，否则优先使用更具体的名字。

推荐：

- `core:common`
- `shared:sync`
- `shared:nodes`

不推荐：

- `shared-all`
- `common2`
- `base`

### `ui` 模块规则

只有当 UI 组件真的跨多个 feature 或 app shell 复用时，才建独立 UI 模块。

推荐：

- `resources:design-system`
- `ui:platform-components`（如果项目明确要单独建 ui 顶层）

不推荐：

- 每个小组件都拆一个模块

## 模块脚手架建议

每个新模块至少固定这些内容：

- 模块 build 文件
- namespace 规则
- 测试依赖模板
- lint / detekt / custom lint 接入
- owner 注释或模块说明
- 若是 Room / benchmark / app shell，带对应模板参数

## namespace 建议

推荐统一：

- `com.company.app.feature.home`
- `com.company.app.platform.push`
- `com.company.app.core.database`

规则：

- namespace 与目录和模块名保持可映射关系
- 不要同目录不同 namespace 风格混用

## 新项目起步建议

### 小团队默认起步

```text
app/
build-logic/
core/
  common/
  model/
resources/
  design-system/
feature/
  home/
  login/
platform/
  permissions/
testing/
  testing-unit/
benchmark/
```

### 中大型团队默认起步

```text
app/
build-logic/
lint-rules/
benchmark/
core/
  common/
  model/
  network/
  database/
  navigation/
  testing/
platform/
  permissions/
  notifications/
  downloads/
resources/
  design-system/
  icons/
  strings/
feature/
  home/
    home-api/
    home-impl/
  login/
    login-api/
    login-impl/
  settings/
    settings-api/
    settings-impl/
testing/
  testing-unit/
```

## 常见错误

- 目录模板还没定，就让团队各自随手建模块
- 业务模块用技术词命名，后面越来越看不懂
- `common`、`base`、`shared` 滥用
- 目录结构和 namespace 完全脱节
- 同一项目里混用 `feature-home`、`home-feature`、`feature:home` 三套风格
