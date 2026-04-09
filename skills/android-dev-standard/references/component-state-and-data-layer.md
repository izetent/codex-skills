# 组件、ViewModel 与数据层规范

## 适用场景

- 编写页面组件
- 编写 ViewModel
- 设计 UseCase
- 设计 Repository / Gateway / Mapper
- 梳理数据流

## 组件开发规则

- 组件优先无状态，状态由上层传入。
- 组件输入输出明确：
  - 输入：state / model / modifier
  - 输出：event callback
- 组件内部只保留纯展示所需的临时状态，不保存业务真相源。
- 组件参数不要塞过多零散布尔值；超过一定复杂度时，优先聚合成 state model。

推荐：

```kotlin
@Composable
fun UserCard(
    state: UserCardState,
    onClick: () -> Unit,
    modifier: Modifier = Modifier,
) { ... }
```

不推荐：

```kotlin
@Composable
fun UserCard(
    userName: String,
    isVip: Boolean,
    isExpired: Boolean,
    showDivider: Boolean,
    isLoading: Boolean,
    ...
) { ... }
```

## ViewModel 规则

- ViewModel 负责状态和动作，不直接负责页面结构。
- 一个页面尽量只有一个主 `UiState`。
- 复杂动作先落到 `onAction(action: XxxAction)`，不要散落一堆零散方法。
- 页面初始化、刷新、重试、切换 tab、弹窗确认都应纳入统一状态流。
- ViewModel 中的依赖优先是 UseCase，其次才是明确边界的 Repository。

推荐：

```kotlin
sealed interface XxxAction {
    data object Load : XxxAction
    data class ClickItem(val id: Long) : XxxAction
}
```

## UseCase 规则

- UseCase 表达一个明确业务动作，不做“大而全工具箱”。
- 命名优先动词短语：
  - `LoadUserProfileUseCase`
  - `ObserveDownloadListUseCase`
  - `UpdateSortOrderUseCase`
- UseCase 可以组合多个 Repository，但不要顺手承担 UI 状态管理。

## Repository 规则

- Repository 接口放 domain 或 contract 层。
- 实现放 data 层。
- Repository 对上提供业务语义，不泄露底层数据源细节。
- 多数据源聚合在 Repository 内完成，不让 ViewModel 自己拼接口和数据库结果。

推荐：

```kotlin
interface UserRepository {
    suspend fun getUser(userId: Long): User
    fun monitorUser(userId: Long): Flow<User>
}
```

不推荐：

```kotlin
class UserViewModel(
    private val api: UserApi,
    private val dao: UserDao,
) : ViewModel()
```

## Mapper 规则

- DTO -> Entity
- Entity -> UiModel
- Persistence Model -> Domain Entity

映射职责要明确，不在 ViewModel 里大段手搓转换。

## API 与数据层规则

- 网络异常、空数据、字段缺失要在数据层或仓储层统一处理语义，不把原始异常样态直接扔给 UI。
- 本地缓存是否参与返回，必须是明确策略，不是隐式顺手加。
- DataStore / Room / 网络并存时，先明确谁是真相源。
- Worker、同步器、轮询器这类异步任务必须幂等。

## 数据流排查清单

- 页面看到的数据来自哪里
- 是否有多份缓存
- 数据更新后谁负责回写 Flow / StateFlow
- 生命周期变化后是否重新订阅
- 是否存在重复 collect、重复 enqueue、重复 observe

## 明确避免

- ViewModel 直接调 Retrofit
- UI 层直接拼接多个数据源
- Repository 返回原始 DTO 给页面
- Mapper 混在 Adapter / Fragment / Composable 里
- 不明确状态源就加本地变量兜底
