# 原生 iOS UI 细节落地清单

## 目录

- 适用范围
- 核心要求
- 组件状态矩阵
- 表单、输入和键盘
- 文本、本地化和 Dynamic Type
- 触控、手势和反馈
- Loading、Empty、Error
- 图片、图标和资源
- 无障碍
- Preview 和验证矩阵
- 错误写法与正确写法

## 适用范围

用于原生 iOS 页面和组件的 UI 细节实现、设计稿还原、表单输入、列表项、按钮、状态视图、无障碍、本地化和视觉验收。若任务涉及“页面看起来不精致”“状态没补齐”“键盘遮挡”“字体放大错乱”“按钮点不到”“多语言溢出”“VoiceOver 不可用”，必须读取本文件。

## 核心要求

- UI 不是静态设计稿截图，必须覆盖状态、输入、错误、长文案、可访问性和不同设备。
- 组件 API 传语义参数，不让业务页传散落颜色、字号、圆角、阴影、固定尺寸。
- 文本默认可换行、可放大、可本地化；除非产品明确要求，不用固定高度承载文本。
- 交互元素触控区域默认不小于 44pt。
- 图标按钮必须有 `accessibilityLabel`。
- 颜色不能作为唯一信息来源。
- 状态变化不能造成明显布局跳变，除非这是明确的交互动效。

## 组件状态矩阵

每个可交互组件至少考虑：

| 状态 | 必须处理 |
| --- | --- |
| normal | 默认显示 |
| pressed / highlighted | 按下反馈 |
| disabled | 禁用视觉和不可点击 |
| loading | 防重复点击，显示进度或临时展示 |
| selected | 选中态与 pressed 不混淆 |
| error | 错误提示或边框状态 |
| focused | 输入框、键盘、tvOS / iPad 键盘焦点 |

Button 组件不应只实现 normal 状态。列表项不应只实现普通文本样式，还要考虑 selected、disabled、loading、swipe/action 状态。

## 表单、输入和键盘

表单必须明确：

- 字段类型：文本、数字、邮箱、密码、搜索、多行备注。
- 键盘类型：`keyboardType`。
- 提交动作：`submitLabel` / return key。
- 焦点顺序：下一个字段、提交、收起键盘。
- 校验时机：输入中、失焦、提交时。
- 错误展示：字段级错误优先，不用全局 Toast 代替字段错误。
- 键盘避让：优先滚动容器和系统能力，不手写固定键盘高度。
- 输入草稿：放 `ViewState` 或表单 draft model，提交成功后写 Repository 或共享状态源。

SwiftUI 推荐：

```swift
@FocusState private var focusedField: Field?

TextField(title, text: binding)
    .keyboardType(.emailAddress)
    .submitLabel(.next)
    .focused($focusedField, equals: .email)
    .onSubmit { focusedField = .password }
```

禁止：

- 用固定 bottom padding 猜键盘高度。
- 表单字段错误只用 Toast。
- 密码、邮箱、手机号等敏感信息进入日志或埋点。
- 提交按钮不处理 loading / disabled，导致重复提交。

## 文本、本地化和 Dynamic Type

规则：

- 用户可见文案进入 String Catalog 或项目本地化资源。
- 不用中文或英文原文当业务 key。
- 不拼接多段句子表达复杂文案，优先使用带参数的本地化字符串。
- 文本默认使用系统 text style 或项目 typography token。
- 长文案必须允许换行或有明确截断策略。
- 按钮标题要考虑多语言变长。
- 数字、日期、重量、距离、货币使用格式化器，不手写拼接。

错误：

```swift
Text("Hello, \(name), you have \(count) workouts")
```

正确：

```swift
Text(String(localized: "profile.workout_count \(name) \(count)"))
```

如果项目有封装，应使用项目的本地化 helper 或 String Catalog key。

## 触控、手势和反馈

规则：

- 点击区域默认不小于 44pt。
- 小图标按钮用固定触控区域可以接受，但图标本身不必放大到 44pt。
- 自定义点击热区必须有 VoiceOver label 和 trait。
- pressed 反馈要先于网络请求。
- selected 与 pressed 视觉要能区分。
- destructive 操作需要确认、撤销或系统 swipe destructive 语义，按业务风险选择。
- 列表 swipe action、context menu、EditMode 优先使用系统能力。

## Loading、Empty、Error

页面必须定义状态表：

```text
initial loading
content
empty
error with retry
refreshing with existing content
submitting
partial failure
offline / weak network
```

规则：

- 首次加载和已有内容刷新是不同状态。
- 空态要说明用户下一步能做什么。
- 可恢复错误提供 Retry。
- 不可恢复错误说明原因和下一步。
- 表单错误尽量定位到字段。
- 全局 Toast 谨慎使用，避免错误刷屏。

## 图片、图标和资源

规则：

- 图片资源进入 Assets 或明确资源层。
- Dark Mode 下图标、插画、蒙层要可见。
- 业务图片需要加载中展示、失败态和重试策略。
- 大图不能在主线程同步解码。
- 列表图片加载必须绑定复用生命周期，避免旧图闪回。
- SF Symbols 优先用于系统语义图标。
- 图标不能作为唯一信息来源，必要时搭配文字或可访问性说明。

## 无障碍

必须处理：

- Icon-only button：`accessibilityLabel`。
- 自定义控件：正确 trait，如 button、selected、adjustable。
- 图片有业务含义：提供描述。
- 颜色传达状态时：增加文字、图标或 trait。
- 动态文本：支持 Dynamic Type 和 Bold Text。
- 表单错误：VoiceOver 能读出错误。
- 自定义排序、拖拽、滑动：提供可访问替代路径。

## Preview 和验证矩阵

UI 组件至少准备这些状态，人工检查或 Preview / Snapshot 覆盖：

```text
normal
loading
empty
error
disabled
selected
pressed
long text
English / Chinese / longest supported language
Dynamic Type large
Dark Mode
small iPhone
iPad / Split View
keyboard visible
VoiceOver labels
```

不要求每个小组件都有完整 snapshot，但核心页面、共享组件、复杂表单和状态视图必须能被构造出上述状态。

## 错误写法与正确写法

### 1. 图标按钮无无障碍标签

错误：

```swift
Button {
    send(.closeTapped)
} label: {
    Image(systemName: "xmark")
}
```

正确：

```swift
Button {
    send(.closeTapped)
} label: {
    Image(systemName: "xmark")
}
.frame(width: AppSpacing.touchTarget, height: AppSpacing.touchTarget)
.accessibilityLabel(Text("common.close"))
```

### 2. 表单错误只用 Toast

错误：

```swift
if email.isEmpty {
    eventHandler?(.showToast("Email required"))
}
```

正确：

```swift
state.emailErrorKey = "profile.email.error.required"
```

字段组件根据 `emailErrorKey` 展示错误，并让 VoiceOver 可读。

### 3. 按钮没有提交态

错误：

```swift
AppButton(title: "Save") {
    send(.saveTapped)
}
```

正确：

```swift
AppButton(
    title: String(localized: "common.save"),
    style: .primary,
    state: state.isSubmitting ? .loading : .normal
) {
    send(.saveTapped)
}
.disabled(state.isSubmitting || !state.canSubmit)
```

### 4. 文本固定单行导致多语言截断

错误：

```swift
Text(title)
    .lineLimit(1)
    .frame(height: 24)
```

正确：

```swift
Text(title)
    .font(AppTypography.headline)
    .fixedSize(horizontal: false, vertical: true)
    .frame(maxWidth: .infinity, alignment: .leading)
```
