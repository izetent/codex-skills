---
name: ios-dev-standard
description: "用于 Swift、SwiftUI、UIKit 或混合项目中的原生 iOS 开发任务。适用于项目脚手架、架构设计、功能开发、Bug 修复、页面拆分、自适应布局、设计系统约束、状态归属、网络、缓存、存储、鉴权、并发、生命周期、性能、无障碍、测试、交付和代码审查。要求先调查再修改，保护架构边界，只做最小责任层修改，保证视觉质量，并验证原路径和邻近回归路径。"
---

# iOS 开发规范

使用本 skill 时，把自己当作高级原生 iOS 工程师：先定位问题和层级，再做最小必要实现；同时把架构、状态、生命周期、自适应、设计质量、测试和交付闭环一起考虑。

不要把“页面能显示”当成完成。完成标准是：状态归属正确、系统行为稳定、布局自适应、异常路径可处理、设计一致、关键路径可验证。

## Always Read

每次触发本 skill，先读：

- `rules/core-principles.md`
- `references/gotchas.md`

检验：问自己“这次任务开始前，我是否重新读取了 Always Read 文件，而不是凭上一轮记忆执行？”

## 适用任务

- 新建或整理 iOS 项目架子
- SwiftUI / UIKit 功能开发
- Bug 根因排查和修复
- 页面拆分和复杂页面治理
- 架构、模块、依赖方向调整
- 网络、缓存、存储、鉴权、会话状态设计
- 自适应布局、iPad、横屏、键盘、Dynamic Type、暗黑模式
- 设计系统、全局组件、弹窗、Toast、Loading、Empty、Error
- 并发、生命周期、性能、内存、安全
- 测试补充、代码审查、交付验收

## 最高优先级规则

- 先确认目标、现象、触发路径、影响范围和已有证据。
- 根因不清楚时先排查，不猜改。
- 只改真正负责问题的层，不顺手扩散重构。
- App 壳层只负责启动、窗口、导航宿主、依赖组装、生命周期转发。
- 页面只负责 UI 编排、事件绑定和展示，不直接请求网络、读数据库、读 Keychain。
- 业务代码只调用语义化能力；网络、埋点、权限、支付、分享、存储、第三方 SDK 等底层细节必须收口到 Core/Data/Adapter/Repository。
- 跨页面共享状态必须有单一真相源。
- 导航、Toast、Dialog、权限结果、支付结果等一次性事件不能放进可重放状态。
- 样式优先走主题、设计系统和共享组件。
- 布局优先靠 Safe Area、Auto Layout、SwiftUI Layout、Size Class、窗口尺寸和 Dynamic Type。
- 涉及复杂页面设计、页面拆分、Section/Row/Component 边界、页面数据治理时，必须读取并执行 `references/native-ios-page-composition.md`。
- 涉及原生 iOS 样式、数据归属、状态保留、Tab 列表状态时，必须读取并执行 `references/native-ios-style-data-state.md`，按其中错误写法和正确写法做实现或 Review 判断。
- 涉及组件状态、表单、键盘、本地化、Dynamic Type、无障碍、Loading/Empty/Error 细节时，必须读取并执行 `references/native-ios-ui-detail-checklist.md`。
- 修改后验证原始路径和邻近回归路径。

## 工作流程

1. 判断任务类型和责任层，按 `Common Tasks` 读取对应 workflow 与 reference。

2. 修改前说明：
   - 现象或目标
   - 触发条件和用户路径
   - 影响范围
   - 所在模块和层级
   - 已有证据
   - 最小修改边界

3. 实现时遵守：
   - 沿用现有工程结构、DI、导航、主题、命名和测试方式。
   - 新能力按层落位，不把业务塞到页面或 App 壳层。
   - 复杂页面按职责拆分。
   - 重复第三处 UI 或逻辑必须评估封装。
   - 设计、适配、错误态和可访问性作为实现的一部分。

4. 完成后验证：
   - 编译或相关测试。
   - 原始路径。
   - 一条邻近回归路径。
   - 涉及 UI 时检查小屏、大屏、暗黑、字体放大、键盘和 iPad 影响。

## Common Tasks

| 用户任务 | 必读文件 |
| --- | --- |
| 新建或整理项目架子 | `workflows/scaffold-project.md`, `references/project-scaffold.md` |
| 新增功能 | `workflows/add-feature.md`, `references/task-routing.md`, `references/architecture-state.md` |
| 修 Bug | `workflows/fix-bug.md`, `references/task-routing.md`, `references/gotchas.md` |
| 页面拆分或状态治理 | `workflows/add-feature.md`, `references/architecture-state.md` |
| 复杂页面设计、页面拆分、页面数据治理 | `references/native-ios-page-composition.md` |
| UI 设计还原或适配 | `workflows/ui-adaptation.md`, `references/ui-design-adaptation.md` |
| 原生 iOS 样式、数据归属、状态保留规范 | `references/native-ios-style-data-state.md` |
| UI 细节、组件状态、表单键盘、本地化、无障碍 | `references/native-ios-ui-detail-checklist.md` |
| 能力封装、第三方 SDK、埋点、请求、权限、存储调用边界 | `references/native-ios-capability-boundaries.md` |
| 网络、缓存、存储、鉴权 | `workflows/add-feature.md`, `references/data-network-storage.md` |
| 并发、生命周期、性能 | `workflows/fix-bug.md`, `references/concurrency-lifecycle-performance.md` |
| 代码审查 | `workflows/review.md`, `references/quality-review-delivery.md` |
| 完成交付说明 | `workflows/close-task.md`, `references/quality-review-delivery.md` |
| iOS 基础能力判断 | `references/ios-foundation.md` |

检验：问自己“我读的文件是否和 Common Tasks 对应行一致？如果少读或凭记忆执行，立即回到路由表重读。”

## Auto-Triggers

遇到以下信号时，自动追加读取对应文件：

- 出现 `Task`、`async`、`await`、`MainActor`、`Timer`、`NotificationCenter`、`Combine`：读 `references/concurrency-lifecycle-performance.md`
- 出现“竞态 / race / 异步请求 / 搜索 / 分页 / 刷新 / 重复提交 / requestID / 取消任务 / 旧请求覆盖新状态”：读 `references/concurrency-lifecycle-performance.md`
- 出现 `URLSession`、`token`、`cache`、`Keychain`、`UserDefaults`、`database`：读 `references/data-network-storage.md`
- 出现 `GeometryReader`、`UIScreen.main.bounds`、`safeArea`、`keyboard`、`Dynamic Type`、`iPad`：读 `references/ui-design-adaptation.md`
- 出现“表单 / 输入框 / 键盘 / 焦点 / 本地化 / String Catalog / 无障碍 / VoiceOver / accessibility / Loading / Empty / Error / disabled / selected / pressed / 长文案”：读 `references/native-ios-ui-detail-checklist.md`
- 出现 `Coordinator`、`ViewModel`、`Repository`、`Session`、`UseCase`：读 `references/architecture-state.md`
- 出现“能力封装 / 业务调用 / 第三方 SDK / 埋点 / 权限 / 支付 / 分享 / post / get / request / URL / API path / 系统 API / UserDefaults.standard”：读 `references/native-ios-capability-boundaries.md`
- 出现“复杂页面 / 页面设计 / 页面拆分 / 按功能拆 / 按模块拆 / Section / Row / Component / 页面数据管理 / 表单草稿 / 筛选条件”：读 `references/native-ios-page-composition.md`
- 出现“样式写法 / 数据放哪里 / 固定宽高 / 写死样式 / Tab 状态 / 滚动位置 / 全局状态 / 本地缓存 / 错误写法和正确写法”：读 `references/native-ios-style-data-state.md`
- 出现 “review / 评审 / 看下代码 / 有没有问题”：读 `workflows/review.md`

## Red Flags — Stop And Re-Route

出现以下情况，暂停编辑并重新判断层级：

- 准备在页面里直接发网络请求。
- 准备在 Feature、ViewModel、Section、Row 或 Component 里直接写 URL、接口 path、`post/get/request`、第三方 SDK、系统 API、UserDefaults 或 Keychain。
- 准备在页面里直接读写数据库、Keychain 或旧存储。
- 准备把导航、Toast、Dialog、支付结果、权限结果放进长期 state。
- 准备用延时、强刷、重复请求或 fallback 掩盖问题。
- 准备用 `UIScreen.main.bounds`、固定键盘高度或设备型号分支作为主要布局策略。
- 准备一次改多个无关层。
- 根因不清楚但已经开始写修复代码。

检验：问自己“这次修改是否触发任一 Red Flag？如果触发，我是否已经停止并重新路由？”

## 默认架构

如果用户要求搭建新项目，默认用这个最小可持续架子：

```text
App/
Core/
  Network/
  Storage/
  Cache/
  Keychain/
  Theme/
  DesignSystem/
  Localization/
  Logger/
  Analytics/
  Configuration/
Domain/
  Entities/
  Repositories/
  UseCases/
Data/
  DTO/
  Remote/
  Local/
  Mappers/
  Repositories/
Session/
Features/
Shared/
  Components/
  Toast/
  Dialogs/
  Modals/
  StateViews/
Resources/
Configs/
Tests/
Tools/
```

如果现有项目已有清晰结构，优先沿用现有结构，不强行套模板。

## 默认页面模型

SwiftUI 默认：

```swift
struct ScreenViewState: Equatable {
    var isLoading = false
}

enum ScreenViewAction {
    case appeared
    case primaryTapped
}

enum ScreenViewEvent {
    case showToast(String)
    case navigateNext
}
```

UIKit 默认：

```text
ViewController -> ViewModel -> UseCase/Repository
ViewController -> Coordinator for navigation/presentation
ViewModel -> state output + one-time event output
```

## 明确禁止

- 未定位就直接改实现。
- 为局部问题大范围重构。
- 用延时、强刷、重复状态、fallback 掩盖根因。
- 在页面中直接创建网络 client。
- 在页面中直接读写数据库、Keychain、旧存储。
- 在多个页面维护同一份共享状态。
- 把一次性事件长期放进 ViewState。
- 大量固定宽高、magic offset 或设备型号分支作为主要适配策略。
- 忽略 Dynamic Type、iPad、多窗口、暗黑模式、键盘和可访问性。
- 只用“本机点了一下”作为完成依据。

## Self Check Before Final

- 每一行改动能否追溯到用户目标或根因？
- 是否只改了最窄责任层？
- 是否复用已有结构、主题和组件？
- 是否避免了 gotchas 中列出的常见借口？
- 是否验证原路径和邻近路径？
- 是否明确说明未验证风险？

## 最终输出要求

实现类任务的收口说明至少包含：

- 现象或目标
- 当前 iOS 基线
- 差异落在哪一层
- 根因或架构判断
- 最小修改范围
- 改了哪些文件
- 做了哪些验证
- 剩余风险或待决策项

Review 类任务按严重程度列问题，优先指出 bug、回归风险、状态错误、生命周期问题、设计/适配问题和缺失测试。
