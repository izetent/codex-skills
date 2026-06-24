# 原生 iOS 页面设计、拆分与页面数据治理

## 目录

- 适用范围
- 核心结论
- 页面设计落地顺序
- 复杂页面拆分标准
- 拆分决策树
- 页面文件结构
- ViewModel 拆分标准
- 页面数据治理
- 复杂页面示例
- 错误写法与正确写法
- Review 强制检查

## 适用范围

用于原生 iOS SwiftUI、UIKit 或混合页面的设计稿落地、复杂页面拆分、页面状态设计、页面数据管理和代码审查。若任务涉及“复杂页面怎么拆”“按功能还是模块拆”“数据放页面还是全局还是本地”“设计稿如何还原成页面结构”，必须读取本文件。

## 核心结论

- 页面拆分优先按**用户任务 + 状态归属 + 视觉区域**，不是单纯按文件行数，也不是按后端接口或数据表拆。
- “功能模块”只有在有独立用户任务、独立状态、独立生命周期或可复用边界时才成立。
- 一个页面默认只有一个主 `Screen` 和一个主 `ViewModel`；只有子区域具备独立加载、独立提交、独立缓存、独立导航流或跨页面复用时，才拆子 ViewModel。
- 页面数据先判断“谁拥有、活多久、是否共享、是否可恢复、是否持久化”，再决定放 `@State`、`ViewState`、`Runtime/Session`、Repository、LocalDataSource、Keychain 或 UserDefaults。
- 网络、埋点、权限、支付、分享、存储、第三方 SDK 等基础能力先读 `native-ios-capability-boundaries.md`；页面只调用语义化能力，不直接触碰底层实现。
- 设计稿还原不是复制像素，而是还原信息层级、交互优先级、视觉密度、状态完整性和 iOS 自适应能力。

## 页面设计落地顺序

实现复杂页面前，先写出这 6 件事：

1. 页面目标：用户来到这个页面要完成什么。
2. 主路径：最常见的操作路径是什么。
3. 信息层级：哪些信息首屏必须看见，哪些可以折叠或延后。
4. 操作层级：主操作、次操作、危险操作分别是什么。
5. 状态集合：loading、empty、error、disabled、selected、pressed、editing、submitting。
6. 数据来源：远端、本地缓存、页面输入、共享状态、系统能力分别来自哪里。

设计稿落成代码时按这个顺序：

```text
用户任务
-> 页面状态模型
-> 页面骨架
-> Section 拆分
-> Row / Cell / Component
-> 样式 token
-> Loading / Empty / Error / Disabled / Selected / Pressed
-> 小屏 / iPad / 横屏 / Dynamic Type / Dark Mode / VoiceOver
```

禁止：

- 先照着设计稿从上到下堆 View，再回头补状态。
- 先写固定尺寸，最后再“适配”。
- 把接口字段直接当 UI 结构。
- 用一个大 `body` 同时承载布局、业务判断、数据转换和弹窗。

## 复杂页面拆分标准

页面需要拆分的信号：

- 页面有 3 个以上稳定视觉区域。
- 页面有 2 条以上用户任务路径，如浏览、筛选、编辑、提交。
- 页面有多个状态域，如列表加载、表单编辑、弹窗选择、底部操作。
- 同一个 row、card、toolbar、empty/error 形态第三次出现。
- `Screen` 的 `body` 需要滚动很久才能看完页面结构。
- ViewModel 同时处理加载、搜索、编辑、提交、分页、弹窗和导航。
- 任一子区域可以被其他页面复用，或业务上有独立语义名称。

拆分优先级：

```text
Screen 骨架
-> Section
-> Row / Cell
-> Feature Component
-> Shared Component
-> DesignSystem Component
```

拆分依据：

- 按用户任务拆：例如搜索区、结果区、编辑区、提交区。
- 按状态域拆：例如 loading 容器、列表状态、表单草稿、sheet 状态。
- 按视觉结构拆：例如 Header、FilterBar、Content、Footer、Toolbar。
- 按复用边界拆：第三次重复再评估抽到 Shared 或 DesignSystem。

不要这样拆：

- 按接口拆 UI：`UserAPIPanel`、`OrderDTOView`。
- 按技术控件拆业务：`VStackPart1`、`TopHStackView`。
- 按行数机械拆：`FirstHalfView`、`SecondHalfView`。
- 每个小组件都配一个 ViewModel。
- 为了“模块化”让兄弟组件互相持有状态。

## 拆分决策树

遇到一个复杂区域，按顺序判断：

```text
它是否表达独立用户任务？
  是 -> 拆成 Section 或子 Feature 组件
  否 -> 继续

它是否有独立 loading / error / empty / submitting 状态？
  是 -> 拆成 Section，并让父 ViewState 持有该状态切片
  否 -> 继续

它是否需要独立请求、分页、订阅、播放器、Timer 或生命周期释放？
  是 -> 可考虑子 ViewModel 或独立 Coordinator，但必须说明所有权
  否 -> 继续

它是否跨页面复用？
  是 -> 第一次放 Feature，第二次保持一致，第三次评估 Shared / DesignSystem
  否 -> 继续

它是否只是排版细节？
  是 -> 保持为 private subview 或小函数，不制造新状态源
```

## 页面文件结构

SwiftUI 推荐：

```text
Features/FeatureName/
  FeatureNameScreen.swift          页面骨架、状态绑定、事件转发
  FeatureNameViewModel.swift       action 处理、状态更新、事件输出
  FeatureNameModels.swift          ViewState / ViewAction / ViewEvent / UI Model
  Mapper/
    FeatureNameFeatureMapper.swift Domain -> UI Model
  Sections/
    FeatureHeaderSection.swift
    FeatureFilterSection.swift
    FeatureContentSection.swift
    FeatureFooterSection.swift
  Rows/
    FeatureItemRow.swift
  Components/
    FeatureLocalComponent.swift
```

UIKit 推荐：

```text
Features/FeatureName/
  Controller/
  ViewModel/
  View/
  Section/
  Cell/
  Model/
  Mapper/
  Coordinator/
```

规则：

- `Screen` / `ViewController` 负责组装，不负责业务判断。
- `Section` 可以组合多个 row，但不持有长期业务状态。
- `Row` / `Cell` 必须由稳定 UI model 驱动。
- `Component` API 传语义参数，如 `style`、`state`、`title`、`icon`，不让调用方传散落颜色和尺寸。
- `Mapper` 只做展示转换，不发请求，不写缓存。

## ViewModel 拆分标准

默认一个页面一个主 ViewModel。

保持一个 ViewModel 的情况：

- 子区域只展示父 state 的一部分。
- 子区域只把点击事件转发给父页面。
- 子区域没有独立请求、分页、提交、订阅或资源释放。
- 子区域离开页面后没有独立存在意义。

可以拆子 ViewModel 的情况：

- 子区域有独立生命周期，例如播放器、地图、编辑器、长连接。
- 子区域有独立数据流，例如独立分页列表、独立搜索、独立提交。
- 子区域可以作为完整业务组件跨页面复用。
- 子区域需要独立测试复杂状态机。

禁止：

- 每个 Section 一个 ViewModel。
- 子 ViewModel 直接修改父 ViewState。
- 父子 ViewModel 各自维护同一份共享数据。
- 子 ViewModel 持有 View、ViewController、NavigationController。

## 页面数据治理

设计页面数据前，先回答：

```text
这份数据是谁的真相源？
是否只影响当前控件？
是否当前页面可恢复渲染需要？
是否多个页面共享？
是否需要离线或持久化？
是否敏感？
是否来自接口 DTO？
是否只是展示派生数据？
```

放置规则：

| 数据类型 | 放置位置 | 示例 |
| --- | --- | --- |
| 控件瞬时状态 | `@State` / 局部 UIKit state | 当前焦点、临时展开、局部动画 |
| 页面渲染状态 | `FeatureViewState` | loading、error、列表 UI model、筛选条件、选中项 |
| 页面输入草稿 | `FeatureViewState` 或表单 draft model | 输入框内容、选择器临时选择 |
| 一次性事件 | `ViewEvent` / Coordinator action | 导航、Toast、Sheet、Dialog |
| 跨页面共享状态 | `Runtime` / `Session` / 明确 Store | 登录态、当前用户、主题、语言、会员态 |
| 业务数据真相源 | Repository | 收藏、训练计划、订单、离线业务数据 |
| 本地业务存储 | `Data/Local` | 数据库、文件、本地数据源 |
| 轻量偏好 | UserDefaults wrapper | 主题、语言、非敏感开关 |
| 敏感凭据 | Keychain wrapper | token、refresh token、密钥 |
| 接口结构 | `Data/DTO` | 后端 response、request DTO |
| 展示派生数据 | Feature Mapper 后的 UI model | title、subtitle、badge、formatted date |

数据流必须是：

```text
Remote DTO / Local Record
-> Data Mapper
-> Domain Entity
-> UseCase / Repository
-> Feature Mapper
-> UI Model
-> ViewState
-> View
```

页面不关心数据来自网络、缓存还是本地。页面只关心当前 `ViewState`。

## 复杂页面示例

例如“训练计划详情页”：

```text
PlanDetailScreen
  HeaderSection              日期、标题、完成状态
  SummarySection             总量、时长、动作数
  ExerciseListSection        当天动作列表
    ExercisePlanRow
  EmptyPlanSection           空状态
  EditingToolbarSection      编辑模式底部栏
  AddExerciseSheet           添加动作弹窗
```

数据归属：

```text
selectedDate
-> ViewState，因为它是页面筛选条件

trainingItems
-> Repository 真相源，ViewState 只持有 UI model 投影

isEditing
-> ViewState，因为它是页面渲染状态

draft item input
-> ViewState draft model，提交成功后写 Repository

template / session persisted data
-> Repository + LocalDataSource

navigateToExerciseDetail
-> ViewEvent

showCreatedToast
-> ViewEvent
```

## 错误写法与正确写法

### 1. 按视觉堆一个大页面

错误：

```swift
struct PlanDetailScreen: View {
    var body: some View {
        ScrollView {
            VStack {
                // header 80 行
                // summary 60 行
                // list 160 行
                // empty/error/loading 判断散落在中间
                // sheet 和 toolbar 也写在这里
            }
        }
    }
}
```

正确：

```swift
struct PlanDetailScreen: View {
    @ObservedObject var viewModel: PlanDetailViewModel

    var body: some View {
        ScrollView {
            VStack(spacing: AppSpacing.lg) {
                PlanHeaderSection(viewData: state.header)
                PlanSummarySection(viewData: state.summary)
                PlanExerciseListSection(
                    items: state.items,
                    onAction: send
                )
            }
            .padding(.horizontal, AppSpacing.screenHorizontal)
        }
        .overlay(alignment: .bottom) {
            PlanEditingToolbarSection(state: state.editingToolbar, onAction: send)
        }
    }
}
```

### 2. 子组件自己拉数据

错误：

```swift
struct ExerciseListSection: View {
    @State private var items: [ExerciseDTO] = []

    var body: some View {
        List(items) { item in
            Text(item.name)
        }
        .task {
            items = try await api.fetchExercises()
        }
    }
}
```

正确：

```swift
struct ExerciseListSection: View {
    let items: [ExerciseRowViewData]
    let onAction: (PlanDetailViewAction) -> Void
}
```

请求由 `ViewModel -> UseCase -> Repository` 发起，Section 只渲染。

### 3. 按“模块”拆出重复状态

错误：

```swift
final class HeaderViewModel: ObservableObject {
    @Published var selectedDate: Date
}

final class ListViewModel: ObservableObject {
    @Published var selectedDate: Date
}
```

正确：

```swift
struct PlanDetailViewState: Equatable {
    var selectedDate: Date
    var header: PlanHeaderViewData
    var exercises: [ExerciseRowViewData]
}
```

`selectedDate` 由页面主 ViewModel 单一维护，各 Section 接收投影。

### 4. 提交成功后只改页面数组

错误：

```swift
state.items.append(newItemViewData)
eventHandler?(.showToast("Added"))
```

正确：

```swift
let updatedSession = try await addExercise.execute(input)
state = mapper.map(updatedSession)
eventHandler?(.showToast("Added"))
```

成功链路先写 Repository 真相源，再用返回的 Domain Entity 或重新加载结果更新页面投影。

## Review 强制检查

复杂页面实现或评审时必须检查：

- 页面是否能用一句话说清主用户任务。
- 页面是否按用户任务、状态域和视觉区域拆分，而不是按接口或行数拆。
- `Screen` 是否仍然只是骨架、绑定和转发。
- 每个 Section 是否有清晰语义名称。
- 子 ViewModel 是否有独立生命周期或独立数据流的充分理由。
- 页面是否存在多个状态源维护同一份数据。
- 页面是否直接持有 DTO、API、数据库、Keychain 或 UserDefaults。
- 表单草稿、筛选条件、选中项是否在 `ViewState` 中可恢复。
- 一次性事件是否走 `ViewEvent`。
- 持久化数据是否先写 Repository，再刷新 UI 投影。
- Loading、Empty、Error、Disabled、Selected、Pressed 是否由状态驱动。
- 页面在小屏、iPad、横屏、Dynamic Type、Dark Mode、键盘和 VoiceOver 下是否仍然成立。
