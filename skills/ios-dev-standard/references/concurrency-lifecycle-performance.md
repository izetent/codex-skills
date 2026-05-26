# 并发、生命周期、性能、稳定性

## 目录

- Swift 并发
- 生命周期
- 内存
- 性能
- 稳定性
- 安全

## Swift 并发

规则：

- UI 状态更新在 MainActor。
- 共享可变非 UI 状态使用 actor 或明确串行队列。
- 长任务必须可取消。
- 页面失效后异步结果不能写旧状态。
- 搜索、分页、刷新要处理竞态。
- 不用无主 `Task {}` 承载长期业务。

常见处理：

```swift
@MainActor
final class ProfileViewModel: ObservableObject {
    private var loadTask: Task<Void, Never>?

    func process(_ action: ProfileAction) {
        switch action {
        case .refresh:
            loadTask?.cancel()
            loadTask = Task { await load() }
        }
    }
}
```

## 生命周期

必须考虑：

- App 冷启动。
- 前后台切换。
- Scene 多窗口。
- 页面 push/pop。
- modal dismiss。
- 权限弹窗返回。
- 外部跳转回来。
- 系统回收后恢复。

规则：

- 不依赖“页面不会被释放”。
- 生命周期回调只做对应层级职责。
- 外部回调必须确认当前会话和页面仍有效。

## 内存

检查：

- 闭包捕获 self。
- Timer。
- Notification observer。
- Combine subscription。
- KVO。
- 播放器。
- 图片加载任务。
- 大对象缓存。
- Cell 复用残留。

规则：

- ViewModel 不持有 ViewController/View。
- Coordinator 不长期强持有不该持有的页面。
- 资源型对象退出时释放。

## 性能

关注路径：

- 冷启动。
- 首屏。
- 列表滚动。
- 图片加载。
- 视频播放。
- 大 JSON 解析。
- 数据库查询。
- SwiftUI 重绘范围。

禁止：

- 主线程磁盘 IO。
- 主线程网络。
- 主线程大计算。
- Cell 中同步解码大图。
- 每次滚动重复创建昂贵对象。
- 无节制刷新整个列表。

## 稳定性

常见风险：

- 重复导航。
- 重复请求。
- 事件重复消费。
- 请求返回顺序反转。
- 登录态过期后的旧请求写入。
- 缓存和远端数据覆盖冲突。
- 权限变化后 UI 不更新。

规避：

- 使用稳定 request id 或 query token。
- 更新前检查当前会话。
- 共享状态单一写入。
- 列表使用稳定 item id。
- 错误态和空态明确。

## 安全

规则：

- token 和密钥进 Keychain。
- 日志脱敏。
- 截图、录屏、剪贴板等敏感场景按产品要求处理。
- WebView 白名单、跳转、JS bridge 要严格。
- 文件导出和分享要检查权限和生命周期。
- 本地缓存敏感数据需评估加密和清理策略。
