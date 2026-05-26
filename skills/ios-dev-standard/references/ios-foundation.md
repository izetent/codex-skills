# iOS 基础能力要求

## 目录

- Swift
- SwiftUI
- UIKit
- 系统能力
- 常见基础错误

## Swift

必须正确使用：

- 值类型和引用类型。
- Optional 和错误处理。
- Protocol、泛型、associated type。
- Access Control。
- ARC、循环引用、弱引用。
- `Codable`、`Equatable`、`Hashable`。
- `async/await`、`Task`、`actor`、`MainActor`。
- `Sendable` 和并发安全边界。

注意：

- 不滥用 force unwrap。
- 不把可变 class 随意跨线程传递。
- 不在 init 做网络、数据库、重 IO。
- 不吞错误。

## SwiftUI

掌握：

- `View` 是状态到 UI 的映射。
- `@State`、`@Binding`、`@StateObject`、`@ObservedObject`、`@Environment`。
- Observation 或 `ObservableObject`。
- `NavigationStack`、`sheet`、`fullScreenCover`。
- `.task(id:)`、`onAppear`、`onDisappear`。
- `ViewModifier`、Preview、mock 数据。

规则：

- `body` 不发请求。
- View 不持有复杂业务对象。
- 本地视觉状态用 `@State`，业务状态进 ViewModel。
- 导航和弹窗通过事件输出。
- 避免滥用 `GeometryReader`。

## UIKit

掌握：

- ViewController 生命周期。
- Auto Layout。
- Safe Area、Layout Margins、Readable Content Guide。
- Table/Collection View 复用。
- Diffable Data Source。
- Navigation、Tab、Modal。
- ScrollView 和键盘。
- Trait Collection。
- Dynamic Type。
- Accessibility。

规则：

- ViewController 薄。
- Cell 不发请求。
- Cell 复用必须重置状态。
- 不靠屏幕宽高写主要布局。
- 生命周期方法只做对应生命周期该做的事。

## 系统能力

必须按系统限制设计：

- Push Notification。
- Background Tasks。
- Keychain。
- App Group。
- Share Extension。
- Notification Service Extension。
- Universal Link。
- URL Scheme。
- Photo、Camera、Location 权限。
- Local Authentication。
- StoreKit。
- Files。

规则：

- 扩展进程不能假设主 App 已启动。
- 权限状态变化必须可恢复。
- 后台任务不能用页面协程替代。
- Universal Link 同时处理冷启动和热启动。
- 敏感数据不进 UserDefaults。

## 常见基础错误

- `Task {}` 无生命周期。
- 非主线程更新 UI 状态。
- `NotificationCenter` observer 不释放。
- Combine subscription 泄漏。
- Timer 持有 self。
- 大图同步解码。
- 主线程 JSON 大解析。
- 只适配默认字体和单一设备。
