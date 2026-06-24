# 并发、生命周期、性能、稳定性

## 目录

- Swift 并发
- 异步竞态处理
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
- 不为单个场景引入大而全的 `TaskManager`、全局请求协调器或通用兜底层；先用最窄责任层的取消、请求身份和状态约束解决。
- 不用延时、强制刷新、静默重试、重复请求或 fallback 掩盖竞态。

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

## 异步竞态处理

竞态处理目标：**保证最后写入 UI 的结果仍然对应当前页面、当前输入、当前会话和当前请求意图。**

常见场景和处理：

| 场景 | 标准处理 |
| --- | --- |
| 搜索词变化 | 取消旧搜索任务；使用 query snapshot 或 requestID；只应用最新 query 的结果 |
| 筛选条件变化 | 保存 filter snapshot；返回后确认 filter 未变化再写 state |
| 下拉刷新 | 取消旧 refresh，或用 refresh requestID 忽略旧结果 |
| 分页加载 | 按当前 query/cursor 绑定请求；旧 query 的分页结果不能 append 到新列表 |
| 页面切换或销毁 | 取消页面任务；返回后确认任务未取消再写状态 |
| 重复点击提交 | 用 `isSubmitting` 禁止重复提交；必要时后端使用 idempotency key |
| 共享缓存写入 | Repository / Store 使用 actor 或明确串行策略 |

推荐顺序：

```text
能取消旧任务 -> 先取消
不能完全取消 -> 加 requestID / generation token
依赖输入 -> 捕获 input snapshot 并在写 state 前比较
影响共享状态 -> 由 Repository / Store 串行写入
非幂等提交 -> isSubmitting + 服务端幂等策略
```

错误：

```swift
func search(_ keyword: String) {
    Task {
        try? await Task.sleep(nanoseconds: 300_000_000)
        let result = try await searchUseCase.execute(keyword)
        state.items = result.map(mapper.map)
    }
}
```

问题：

- 延时不是竞态处理。
- 多个搜索任务仍会并发返回。
- 旧 keyword 的结果可能覆盖新 keyword。

正确：

```swift
@MainActor
final class SearchViewModel: ObservableObject {
    @Published private(set) var state = SearchViewState()

    private let searchUseCase: SearchExercisesUseCase
    private var searchTask: Task<Void, Never>?
    private var searchRequestID = 0

    func send(_ action: SearchViewAction) {
        switch action {
        case let .keywordChanged(keyword):
            state.keyword = keyword
            startSearch(keyword: keyword)
        }
    }

    private func startSearch(keyword: String) {
        searchTask?.cancel()
        searchRequestID += 1
        let requestID = searchRequestID
        let keywordSnapshot = keyword

        searchTask = Task { [weak self] in
            guard let self else { return }
            await self.search(
                keyword: keywordSnapshot,
                requestID: requestID
            )
        }
    }

    private func search(keyword: String, requestID: Int) async {
        state.isLoading = true
        do {
            let result = try await searchUseCase.execute(keyword)
            guard requestID == searchRequestID, keyword == state.keyword else { return }
            state.items = result.map(mapper.map)
            state.errorKey = nil
        } catch is CancellationError {
            return
        } catch {
            guard requestID == searchRequestID else { return }
            state.errorKey = "search.error.load_failed"
        }
        guard requestID == searchRequestID else { return }
        state.isLoading = false
    }
}
```

非幂等提交错误：

```swift
func submit() {
    Task {
        try await createOrder.execute(state.form)
        eventHandler?(.created)
    }
}
```

正确：

```swift
func submit() {
    guard !state.isSubmitting else { return }
    state.isSubmitting = true
    submitTask?.cancel()
    let form = state.form

    submitTask = Task { [weak self] in
        await self?.submit(form)
    }
}

private func submit(_ form: OrderFormState) async {
    defer { state.isSubmitting = false }
    do {
        let order = try await createOrder.execute(form.makeInput())
        state.order = mapper.map(order)
        eventHandler?(.created(order.id))
    } catch {
        state.errorKey = "order.error.create_failed"
    }
}
```

禁止：

- 为竞态加固定延时。
- 请求失败后无条件自动重试。
- 每次 `onAppear` 强制重拉来掩盖状态源错误。
- 旧请求返回后不检查当前输入、当前 requestID、当前会话。
- 为单一页面创建过度通用的请求调度框架。
- 在多个页面各自解决同一份共享数据的并发写入。

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
