# 架构、分层、状态归属

## 目录

- 分层职责
- 依赖方向
- 页面状态
- 共享状态
- 一次性事件
- Coordinator
- 拆分标准

## 分层职责

```text
App
  启动、窗口、根导航、依赖组装、生命周期转发。

Core
  网络、存储、缓存、Keychain、日志、配置、主题、设计系统、国际化。

Domain
  业务实体、UseCase、Repository 协议、业务错误。

Data
  DTO、API、本地数据源、Mapper、Repository 实现。

Session
  登录态、当前用户、token 状态、会员状态、跨页面共享状态。

Features
  业务页面、ViewModel、页面状态、页面组件。

Shared
  跨页面 UI 和展示原语。
```

## 依赖方向

```text
App -> Features/Data/Domain/Session/Core/Shared
Features -> Domain/Session/Core/Shared
Data -> Domain/Core/Session
Shared -> Core Theme/DesignSystem
Domain -> 不依赖 UI，不依赖具体 Data 实现
Core -> 不依赖业务 Feature
```

禁止：

- `Domain -> Features`
- `Core -> Features`
- `Shared -> Features`
- 页面直接依赖 API 实现。
- 页面直接依赖数据库实现。
- ViewModel 持有 ViewController、NavigationController 或 View。

## 页面状态

推荐模型：

```swift
struct ProfileViewState: Equatable {
    var isLoading = false
    var displayName = ""
    var avatarURL: URL?
    var errorMessage: String?
}

enum ProfileViewAction {
    case appeared
    case refresh
    case editTapped
}

enum ProfileViewEvent {
    case showToast(String)
    case openEditor
}
```

规则：

- `ViewState` 可重绘、可恢复。
- `ViewAction` 表示用户意图或生命周期输入。
- `ViewEvent` 表示一次性事件。
- ViewModel 处理 action，更新 state，输出 event。

## 共享状态

适合进 `Session` 或明确共享 store：

- 登录态。
- 当前用户。
- token 状态。
- 会员/订阅状态。
- 当前团队、站点、工作区。
- 全局配置和实验开关。
- 同步运行时状态。

规则：

- 共享状态只有一个写入源。
- 页面只观察，不各自缓存长期副本。
- 成功链路先更新共享状态，再让页面被动刷新。

## 一次性事件

这些不能放进长期 `ViewState`：

- 导航。
- Toast。
- Alert/Dialog。
- Sheet。
- 支付结果。
- 权限结果。
- 外部 App 跳转。
- 登录失效跳转。

原因：

- 旋转屏幕、页面重建、重新订阅可能导致重复消费。

## Coordinator

职责：

- Push、present、dismiss。
- Sheet/full screen 展示。
- Flow 级页面组装。
- 将 ViewModel 事件转为导航动作。

禁止：

- 写网络请求。
- 写业务规则。
- 修改共享业务状态。
- 变成全局上帝对象。

## 拆分标准

需要拆：

- 单文件超过约 300 行。
- 单方法超过约 50 行。
- 页面有三个以上视觉 section。
- ViewController 同时写布局、网络、缓存、导航、弹窗。
- 第三处重复 UI 或逻辑出现。

拆分方向：

- `Components/`
- `Sections/`
- `Cells/`
- `Mapper/`
- `Coordinator/`
- `ViewModel/`
- `Tests/`
