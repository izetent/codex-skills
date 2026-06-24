# 原生 iOS 样式、数据、状态硬规范

## 目录

- 适用范围
- 必须遵守
- 页面拆分
- 样式和布局
- 数据归属
- 单向数据流
- Tab、列表和滚动状态
- 提交前强制检查
- 错误写法与正确写法

## 适用范围

用于 SwiftUI、UIKit 或 SwiftUI/UIKit 混合项目中的原生 iOS 开发。目标是把页面结构、样式、数据归属、缓存、状态保留和验证标准落成可执行规范。

## 必须遵守

- 本文件是硬规范，不是建议清单；实现和 Review 时必须按本文件判断是否合规。
- 发现“错误写法”类型的问题，必须修复到“正确写法”方向，或明确写出例外原因、影响范围、验证方式和后续移除条件。
- 不得用“先这样”“页面里最快”“只有这个页面用”“这个设备没问题”作为跳过规范的理由。
- 页面只做 UI 编排、状态展示和事件绑定。
- 业务规则进 Domain / UseCase，不写在 View、ViewController 或 Coordinator。
- 网络、缓存、本地存储、DTO、Mapper、Repository 实现进 Data / Core，不直接进页面。
- 样式走 Theme token 和 DesignSystem，不在业务页面散写颜色、字号、圆角、阴影。
- 布局优先使用 Safe Area、Layout、Auto Layout、Size Class、Readable Content Guide、Dynamic Type。
- 不用固定屏幕宽高、系统栏高度、magic offset 作为主要适配方式。
- 固定宽高只能用于明确固定规格的控件，如 44pt 图标按钮、头像、缩略图比例、画布比例。
- 文本、列表行、表单、弹窗、错误文案不能用固定高度硬塞。
- 一次性事件不能进入长期可重放状态。
- 每个一级 Tab 默认保持自己的导航栈、筛选条件、加载状态、列表数据和滚动位置。
- 数据必须先判断生命周期和作用域，再决定放页面、全局、缓存还是持久化存储。

## 页面拆分

复杂页面的设计稿结构、Section/Row/Component 边界、子 ViewModel 拆分和页面数据治理，先读 `native-ios-page-composition.md`。本节只保留样式和状态硬规范中的基础拆分约束。

SwiftUI 推荐结构：

```text
Features/FeatureName/
  FeatureNameScreen.swift
  FeatureNameViewModel.swift
  FeatureNameModels.swift
  Components/
  Sections/
  Rows/
  Mapper/
```

需要拆分的信号：

- 页面有三个以上视觉 section。
- `body` 已经难以快速看出页面结构。
- 单文件接近 300 行，单方法接近 50 行。
- 页面同时处理布局、数据转换、业务判断、导航、弹窗和请求。
- 第三处重复 UI 或交互逻辑出现。

拆分规则：

- `Screen`：只做页面骨架、状态绑定、事件转发。
- `Sections`：承载页面中的大块视觉区域。
- `Rows` / `Cells`：承载列表项。
- `Components`：承载 Feature 内可复用组件。
- `Mapper`：Domain / Entity 到 UI model 的展示转换。
- `ViewModel`：处理 action，调用 UseCase / Repository protocol，更新 ViewState，发出 ViewEvent。

## 样式和布局

样式优先级：

```text
Design token
-> DesignSystem / Shared component
-> Feature component style
-> 局部 modifier
```

布局优先级：

```text
内容决定尺寸
-> 样式提供约束
-> SwiftUI Layout / Auto Layout 负责排列
-> Safe Area / Layout Margins / Readable Content Guide
-> Size Class / Window Size
-> Dynamic Type
-> 少量运行时测量
-> 固定常量
```

必须检查：

- 小屏、大屏、iPad、Split View、横屏。
- Dynamic Type、Bold Text、长文案、多语言。
- Dark Mode 对比度。
- Safe Area、键盘弹出、Home Indicator。
- Loading、Empty、Error、Disabled、Selected、Pressed。
- VoiceOver label、trait、触控区域。

## 数据归属

按生命周期和作用域判断：

```text
当前控件临时 UI 状态
-> @State / 局部 UIKit state

当前页面可重复渲染状态
-> Feature ViewState

当前页面用户意图
-> ViewAction

导航、Toast、Dialog、Sheet、权限结果、支付结果
-> ViewEvent / Coordinator action

多个页面共享且有唯一真相源
-> Runtime / Session / 明确 Store

需要离线、查询、持久化、缓存策略
-> Repository + LocalDataSource / Cache

token、密钥、敏感凭据
-> Keychain

主题、语言、非敏感轻量偏好
-> UserDefaults

接口返回结构
-> DTO，仅 Data 层可见
```

标准数据流：

```text
DTO
-> Data Mapper
-> Domain Entity
-> Feature Mapper
-> UI Model
-> ViewState
-> View
```

禁止：

- DTO 直接传进 UI。
- 页面直接创建 `URLSession`、HTTP client、数据库对象或 Keychain。
- 页面直接读写长期缓存。
- 多个页面各自维护同一份登录态、用户态、会员态或业务共享数据。
- 使用没有 freshness、过期策略和清理策略的全局字典缓存。

## 单向数据流

SwiftUI 推荐：

```text
ViewState -> Screen -> ViewAction -> ViewModel -> UseCase / Repository -> ViewState
```

UIKit 推荐：

```text
ViewModel state output -> ViewController render
ViewController input -> ViewModel action
ViewModel event output -> Coordinator navigation / presentation
```

规则：

- `ViewState` 只能放可重复渲染状态。
- `ViewAction` 表达用户意图或生命周期输入。
- `ViewEvent` 表达一次性事件。
- 成功链路先更新共享状态源或 Repository，再让页面被动刷新。
- 页面刷新必须由 state 变化驱动，不靠强刷、延时或重复请求掩盖状态错误。

## Tab、列表和滚动状态

一级 Tab 必须默认保留：

- 每个 Tab 的导航栈。
- 已加载列表数据。
- 筛选条件。
- 搜索词。
- 当前选中项。
- 滚动位置。
- Loading / Empty / Error 状态。

实现规则：

- 每个 Tab 的 ViewModel 身份必须稳定。
- SwiftUI 中用 `@StateObject` 或由稳定父层 / Coordinator 注入，不在 `body` 中反复创建。
- 不给 Tab 内容使用变化的 `.id(UUID())` 或等价强制重建。
- 不在 `onAppear` 无条件重置 state 或重新加载数据。
- 刷新必须通过 explicit refresh、invalidation、query 变化或缓存策略触发。
- 列表 item 必须有稳定业务 id。
- 需要精确保留滚动位置时，用 visible item id 或 scroll position 记录，而不是依赖重新请求后自然落位。

## 提交前强制检查

实现或 Review 涉及样式、数据、状态、列表、Tab 时，逐项检查：

- 页面是否只做 UI 编排、状态展示和事件绑定。
- 是否存在页面直接请求网络、读写数据库、读写 UserDefaults / Keychain。
- 页面、ViewModel、Section、Row、Component 中是否出现 URL、接口 path、`post/get/request`、第三方 SDK、系统 API、UserDefaults 或 Keychain。
- DTO 是否被传入 Feature、Runtime、UI 或 ViewState。
- 是否有散落色值、字号、圆角、阴影、magic spacing。
- 固定宽高是否只用于明确固定规格控件。
- 文本、列表行、表单、弹窗是否能承载 Dynamic Type、长文案和多语言。
- 是否使用 Safe Area / Layout / Auto Layout / Size Class，而不是屏幕宽高硬凑。
- Loading、Empty、Error、Disabled、Selected、Pressed 是否完整。
- 一次性事件是否没有进入长期 `ViewState` 或 Runtime。
- 共享状态是否只有一个写入源。
- 本地缓存是否有 freshness、过期、刷新、清理策略。
- Tab 切换后是否保留导航栈、筛选条件、列表数据和滚动位置。
- 列表 item 是否使用稳定业务 id。
- 异步请求是否可取消，旧请求结果是否不会覆盖新状态。
- 修改后是否验证小屏、大屏、iPad、横屏、Dark Mode、Dynamic Type、键盘和 VoiceOver 影响。

## 错误写法与正确写法

### 1. 页面散写样式

错误：

```swift
Text(title)
    .font(.system(size: 15, weight: .semibold))
    .foregroundStyle(Color.blue)
    .padding(.horizontal, 13)
    .padding(.vertical, 9)
    .background(Color.white)
    .clipShape(RoundedRectangle(cornerRadius: 17))
```

正确：

```swift
Text(title)
    .font(AppTypography.button)
    .foregroundStyle(AppColor.Action.primaryText)
    .padding(.horizontal, AppSpacing.md)
    .padding(.vertical, AppSpacing.sm)
    .background(AppColor.Action.primaryBackground)
    .clipShape(RoundedRectangle(cornerRadius: AppRadius.control))
```

更好：

```swift
AppButton(title: title, style: .primary, size: .medium) {
    send(.primaryTapped)
}
```

### 2. 固定高度承载动态文本

错误：

```swift
HStack {
    Text(description)
        .lineLimit(1)
    Spacer()
}
.frame(height: 44)
```

正确：

```swift
HStack(alignment: .firstTextBaseline, spacing: AppSpacing.sm) {
    Text(description)
        .font(AppTypography.body)
        .foregroundStyle(AppColor.Text.primary)
        .fixedSize(horizontal: false, vertical: true)
    Spacer(minLength: AppSpacing.sm)
}
.padding(.vertical, AppSpacing.sm)
.frame(minHeight: AppSpacing.touchTarget)
```

### 3. 用屏幕宽高硬凑布局

错误：

```swift
let width = UIScreen.main.bounds.width

VStack {
    content
}
.frame(width: width - 32)
.offset(y: -18)
```

正确：

```swift
VStack(spacing: AppSpacing.lg) {
    content
}
.frame(maxWidth: .infinity, alignment: .leading)
.padding(.horizontal, AppSpacing.screenHorizontal)
.safeAreaPadding(.bottom, AppSpacing.lg)
```

### 4. 页面直接请求网络

错误：

```swift
.task {
    let url = URL(string: "https://api.example.com/exercises")!
    let (data, _) = try await URLSession.shared.data(from: url)
    exercises = try JSONDecoder().decode([ExerciseDTO].self, from: data)
}
```

正确：

```swift
.task {
    send(.appeared)
}
```

```swift
@MainActor
final class ExercisesViewModel: ObservableObject {
    @Published private(set) var state = ExercisesViewState()

    private let loadExercises: LoadExercisesUseCase

    func send(_ action: ExercisesViewAction) {
        switch action {
        case .appeared:
            loadTask?.cancel()
            loadTask = Task { await load() }
        }
    }
}
```

### 5. DTO 直接进 UI

错误：

```swift
struct ExerciseRow: View {
    let dto: ExerciseDTO

    var body: some View {
        Text(dto.bodyPartName)
    }
}
```

正确：

```swift
struct ExerciseRowViewData: Identifiable, Equatable {
    let id: ExerciseID
    let title: String
    let subtitle: String
}

struct ExerciseRow: View {
    let viewData: ExerciseRowViewData
}
```

### 6. 一次性事件放长期状态

错误：

```swift
struct LoginViewState: Equatable {
    var isLoggedIn = false
    var shouldNavigateHome = false
    var toastMessage: String?
}
```

正确：

```swift
struct LoginViewState: Equatable {
    var isLoading = false
    var errorKey: String?
}

enum LoginViewEvent: Equatable {
    case navigateHome
    case showToast(String)
}
```

### 7. Tab 切换后重置列表

错误：

```swift
struct RootTabs: View {
    var body: some View {
        TabView {
            ExercisesScreen(viewModel: ExercisesViewModel())
                .tabItem { Label("Exercises", systemImage: "figure.strengthtraining.traditional") }
        }
    }
}
```

错误：

```swift
.onAppear {
    viewModel.reset()
    viewModel.send(.appeared)
}
```

正确：

```swift
struct RootTabs: View {
    @StateObject private var exercisesViewModel: ExercisesViewModel

    init(container: AppDependencyContainer) {
        _exercisesViewModel = StateObject(wrappedValue: container.makeExercisesViewModel())
    }

    var body: some View {
        TabView {
            ExercisesScreen(viewModel: exercisesViewModel)
                .tabItem { Label("Exercises", systemImage: "figure.strengthtraining.traditional") }
        }
    }
}
```

正确：

```swift
func send(_ action: ExercisesViewAction) {
    switch action {
    case .appeared:
        guard !didLoadInitialData else { return }
        didLoadInitialData = true
        startLoadTask()
    case .refresh:
        startLoadTask()
    }
}
```

### 8. 页面直接读写本地存储

错误：

```swift
Button("Favorite") {
    UserDefaults.standard.set(true, forKey: "favorite_\(exerciseID)")
}
```

正确：

```swift
Button("Favorite") {
    send(.favoriteTapped)
}
```

```swift
struct ToggleFavoriteExerciseUseCase {
    private let repository: any FavoriteExerciseRepository

    func execute(id: ExerciseID) async throws -> Bool {
        try await repository.toggleFavorite(id)
    }
}
```

### 9. 业务共享状态被多个页面各自缓存

错误：

```swift
final class ProfileViewModel: ObservableObject {
    @Published var currentUser: User?
}

final class SettingsViewModel: ObservableObject {
    @Published var currentUser: User?
}
```

正确：

```swift
@MainActor
final class SessionStore: ObservableObject {
    @Published private(set) var state = SessionState()

    func updateCurrentUser(_ user: User) {
        state.currentUser = user
    }
}
```

页面只观察 `SessionStore` 或通过 UseCase / Repository 获取投影，不各自长期维护副本。

### 10. UIKit 固定 frame 布局

错误：

```swift
titleLabel.frame = CGRect(x: 16, y: 20, width: 220, height: 24)
button.frame = CGRect(x: 16, y: 56, width: 120, height: 44)
```

正确：

```swift
NSLayoutConstraint.activate([
    titleLabel.topAnchor.constraint(equalTo: contentView.layoutMarginsGuide.topAnchor),
    titleLabel.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor),
    titleLabel.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor),
    button.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: AppSpacing.sm),
    button.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor),
    button.bottomAnchor.constraint(equalTo: contentView.layoutMarginsGuide.bottomAnchor)
])
```
