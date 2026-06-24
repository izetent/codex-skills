# 页面、组件、设计、适配

## 目录

- 设计把控
- 共享组件
- SwiftUI 规则
- UIKit 规则
- 自适应布局
- 字体、暗黑、多语言
- 可访问性
- UI 验收

## 设计把控

高级 iOS 实现必须对设计结果负责：

- 信息层级清楚。
- 控件状态完整。
- 间距、字号、颜色、圆角、阴影走 token。
- 点击区域符合系统习惯。
- Loading、Empty、Error、禁用、选中、按下状态完整。
- 视觉不能只在一台设备上成立。

组件状态、表单键盘、本地化、Dynamic Type、无障碍和 Loading/Empty/Error 细节，必须继续读取 `native-ios-ui-detail-checklist.md`。

## 共享组件

项目初期规划：

```text
Shared/
  Components/
    AppButton
    AppTextField
    AppAvatarView
    AppSearchBar
    AppListRow
  Toast/
  Dialogs/
  Modals/
  StateViews/
```

封装规则：

- 第一次局部实现。
- 第二次保持一致。
- 第三次评估抽到 Shared 或 DesignSystem。
- 不为单点场景做复杂泛化。

## SwiftUI 规则

- View 只做状态到 UI 的映射。
- 使用标准 layout 组合，不优先手写测量。
- `.task(id:)` 绑定输入变化，避免重复请求。
- 列表必须有稳定 id。
- Sheet、Dialog、Toast 通过事件驱动。
- Preview 要能构造 loading、empty、error、long text、dark states。
- 谨慎使用透明和模糊材质，优先放在导航层、工具层、浮层，不用于普通内容堆叠。

## UIKit 规则

- ViewController 只做绑定、生命周期、展示。
- 使用 Auto Layout、Safe Area、Layout Margins、Readable Content Guide。
- Cell 复用完整重置。
- 复杂列表优先 diffable data source。
- 键盘避让优先系统能力和滚动容器。
- Dynamic Type 变化后刷新布局。

## 自适应布局

优先级：

```text
Design Token
-> SwiftUI Layout / Auto Layout
-> Safe Area
-> Layout Margins
-> Readable Content Guide
-> Size Class / Window Size
-> Dynamic Type
-> 少量运行时测量
-> 固定常量
```

禁止默认：

- `UIScreen.main.bounds` 做主要布局。
- 手写系统栏高度。
- 固定高度承载动态文字。
- 大量 offset 硬凑。
- 只适配单一手机竖屏。

## 字体、暗黑、多语言

必须检查：

- 字体放大后是否遮挡。
- 文案是否可换行。
- 长词是否破坏布局。
- 暗黑模式对比度是否足够。
- 图片、图标在暗黑模式是否清晰。
- 多语言是否导致按钮超宽。

## 可访问性

- `accessibilityIdentifier` 用于测试。
- `accessibilityLabel` 用于辅助朗读。
- Icon-only button 必须有 label。
- 图片有业务含义时提供描述。
- 触控区域不能过小。
- 自定义控件要有正确 trait。

## UI 验收

完成前检查：

- 小屏。
- 大屏。
- iPad。
- Split View / 多窗口。
- 横屏。
- Dynamic Type。
- Dark Mode。
- Safe Area。
- 键盘弹出。
- Loading/Empty/Error。
- 弱网/离线提示。
- 长文案。
- VoiceOver。
