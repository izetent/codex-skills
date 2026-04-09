# 页面拆分与状态归属规范

## 适用场景

- 页面文件过大
- Fragment / Activity 逻辑过重
- Compose 页面把状态、导航、渲染混在一起
- 需要安全拆分复杂页面

## 核心原则

页面拆分按职责和状态归属来拆，不按文件长度机械拆。

## 推荐结构

复杂页面建议至少分成：

- Host：`Activity` / `Fragment` / nav destination
- `Route`：接生命周期、读参数、收状态、传事件
- `ViewModel`：持有业务状态，处理动作，发事件
- `Screen`：处理 scaffold、空态、加载态、错误态、弹窗、底部弹层
- `Content`：真正主体内容
- Leaf 组件：item、toolbar、dialog、sheet、tab、card

## 各层职责

### Host

负责：

- Android 入口生命周期
- `setContent`
- fragment arguments
- nav host 挂接

不负责：

- 页面业务逻辑
- Repository 调用
- 大量 UI 分支判断

### Route

负责：

- 按生命周期收集状态
- 绑定参数
- 传递回调

不负责：

- 大片 UI 树
- 复杂状态修改逻辑

### ViewModel

负责：

- `UiState`
- 用户动作处理
- 业务编排
- 一次性事件或命令

不负责：

- View 引用
- 具体布局细节
- 无边界地传 Context

### Screen

负责：

- Scaffold
- 加载态 / 空态 / 错误态切换
- dialog / bottom sheet / snackbar 分支
- 页面级事件消费

### Content 和叶子组件

负责：

- 局部布局
- 渲染
- 事件透传

不负责：

- 跨页面业务判断
- Repository / SDK 直接调用

## 状态建模规则

- 持续状态优先放 `StateFlow`
- 导航、Toast、Snackbar、弹窗结果这类一次性事件，走 command channel 或明确事件包装
- 同一字段不要出现多个可变真相源
- 能推导出来的 UI 值尽量推导，不额外缓存一份

推荐状态结构：

```kotlin
data class XxxUiState(
    val isLoading: Boolean = false,
    val items: List<XxxItem> = emptyList(),
    val error: XxxError? = null,
)
```

不推荐：

```kotlin
var loading = false
var items: MutableList<XxxItem> = mutableListOf()
var errorText: String? = null
```

## 什么时候该拆

出现下面情况就应该考虑拆：

- 一个文件同时负责 route、状态、scaffold、列表、弹窗
- 多种职责会被不同改动频繁触碰
- 页面状态分支多，已经很难推理
- 某些局部组件需要单独 preview 或测试
- 某块内容已经有明显复用趋势

## 推荐拆分形态

### Compose 页面

优先结构：

- `XxxRoute.kt`
- `XxxViewModel.kt`
- `XxxScreen.kt`
- `XxxContent.kt`
- `components/XxxItem.kt`
- `components/XxxDialog.kt`

推荐的 Route 形态：

```kotlin
@Composable
fun XxxRoute(
    viewModel: XxxViewModel = hiltViewModel(),
) {
    val state by viewModel.state.collectAsStateWithLifecycle()
    XxxScreen(
        state = state,
        onAction = viewModel::onAction,
    )
}
```

推荐的 ViewModel 形态：

```kotlin
@HiltViewModel
class XxxViewModel @Inject constructor(
    private val loadXxxUseCase: LoadXxxUseCase,
) : ViewModel() {
    private val _state = MutableStateFlow(XxxUiState())
    val state = _state.asStateFlow()
}
```

### Fragment + Compose

Fragment 只做宿主，不承担页面编排逻辑。

### 传统 XML 页面

按下面边界拆：

- 容器页
- 状态持有者
- 列表适配层
- 事件处理层
- 独立弹窗或面板

但不要为了拆而拆，抽一堆没有稳定职责的中间层。

## 页面拆分顺序建议

如果页面已经很乱，优先按下面顺序拆：

1. 先把业务逻辑移出 Fragment / Activity
2. 再收敛成统一 `UiState`
3. 再拆 Route / Screen
4. 再拆列表项、弹窗、工具栏等叶子组件
5. 最后考虑抽公共组件

## 复杂页面必查项

- 是否同时存在多个 loading 状态源
- 是否存在 UI 直接改 Repository 的逻辑
- 是否存在页面级状态散落在多个 remember / field / adapter 中
- 是否存在弹窗、底部弹层、列表选中状态相互耦合
- 是否可以通过一个 `UiState` 明确表达当前页面阶段

## 明确避免

- 巨型 Fragment 直接调 Repository
- Composable 内直接发网络、读数据库
- 多处布尔值分别控制同一页面状态
- 拆成很多文件，但它们仍共享一份混乱的可变状态
