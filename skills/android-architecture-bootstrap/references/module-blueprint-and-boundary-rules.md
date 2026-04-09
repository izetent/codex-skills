# 模块蓝图与边界规则

## 目标

模块化的目的是：

- 稳定依赖方向
- 降低耦合
- 支持多人协作
- 缩小回归面
- 让构建规则和质量门禁有明确落点

不是为了把目录拆碎。

## 推荐模块分类

### `app`

只负责：

- Application
- 导航总装配
- DI 总装配
- build variant 和环境注入
- feature 接线

不负责：

- Repository 实现
- 页面业务细节
- 通用 UI 组件

### `core`

放真正跨业务复用的稳定能力：

- 通用模型和结果类型
- dispatcher / logger / common utils
- 网络基础设施
- 数据库基础设施
- design token 接口
- navigation contract
- testing 工具

### `platform`

放与系统和外部能力强绑定的模块：

- 权限
- 通知
- 文件 / 下载 / 上传
- 媒体采集
- WebView
- 支付
- 推送
- 前台服务
- 后台任务调度

### `feature`

每个用户能力一个 feature 域。

典型结构：

```text
feature/
  account/
    account-api/
    account-impl/
    account-internal/
  feed/
    feed-api/
    feed-impl/
  checkout/
    checkout-api/
    checkout-impl/
```

### `resources` / `design-system`

放：

- 颜色、字体、间距、shape token
- 共享组件
- 图标、插画、字符串资源策略

## 推荐依赖方向

```text
app -> feature-impl
app -> platform
app -> core
feature-impl -> feature-api
feature-impl -> core
feature-impl -> platform-contract 或 platform
feature-a-impl -> feature-b-api
platform -> core
```

## 编译期规则建议

必须考虑通过 build rule 或 lint 固化：

- 只有 `app` 可以依赖 feature impl
- feature 之间只能依赖对方 api / contract
- UI 模块不能直接依赖 Retrofit / DAO / SDK 大对象
- `internal` 模块不能泄漏到正式公开链路
- `api` 模块不允许持有 DI 实现和平台实现
- 除组合根外，不允许依赖 `app`

## 目录模板建议

```text
app/
build-logic/
lint-rules/
core/
  common/
  model/
  network/
  database/
  testing/
  navigation/
platform/
  permissions/
  notifications/
  downloads/
  webview/
resources/
  design-system/
  icons/
  strings/
feature/
  home/
    home-api/
    home-impl/
  profile/
    profile-api/
    profile-impl/
benchmark/
```

## feature 内部建议结构

```text
feature-xxx-impl/
  src/main/kotlin/.../
    di/
    navigation/
    ui/
      route/
      screen/
      component/
      model/
    presentation/
      XxxViewModel
      XxxAction
      XxxEffect
      XxxUiState
    domain-bridge/
      feature specific orchestrator
```

## 不推荐做法

- 一个巨大 `data` 承载所有业务实现
- 一个巨大 `domain` 承载所有 UseCase，最后没人敢动
- feature A 直接 import feature B 的页面实现
- app 模块既是入口又是全部业务实现
- resources 和 design-system 混成杂物间

## 模块 owner 建议

每个模块至少明确：

- owner
- 对外暴露能力
- 禁止暴露内容
- 测试责任
- 发布风险级别
