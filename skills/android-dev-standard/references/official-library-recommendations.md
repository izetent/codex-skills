# 官方主流库使用建议

## 目标

这份建议用于约束“优先使用 Android 官方推荐或主流 Jetpack 方案”，避免在没有必要的情况下引入非主流基础库。

不在这里写死版本号，只写库和适用边界。版本请跟随项目现有 catalog、BOM 或依赖管理方式。

## 架构与状态

优先建议：

- `ViewModel`
- Kotlin `coroutines`
- Kotlin `Flow` / `StateFlow`
- `collectAsStateWithLifecycle`

适用：

- 屏幕级状态持有
- 生命周期感知状态收集
- 单向数据流

不推荐：

- 新页面继续以 `LiveData` 作为默认主状态流
- 在可复用小组件里创建 ViewModel

## 数据存储

小型配置、偏好、轻量键值数据：

- `DataStore`

结构化本地数据、需要查询和关系约束：

- `Room`

不推荐：

- 新功能默认继续使用 `SharedPreferences`
- 直接裸写 SQLite API 作为默认方案

## 后台任务

持久化后台任务、可跨重启保留的工作：

- `WorkManager`

不推荐：

- 自己维护零散的后台轮询调度作为默认长期方案

## 分页与列表

数据量大、按页加载：

- `Paging 3`

不推荐：

- 页面层自己手搓分页状态、去重、下一页判断，除非场景非常简单且明确不值得引入 Paging

## 依赖注入

官方主流推荐：

- `Hilt`

若项目已基于 Dagger 或等价主流 DI 深度建设，则优先兼容现有体系，不做无意义迁移。

不推荐：

- 手写全局单例容器作为默认架构

## UI

新页面优先：

- `Jetpack Compose`
- Material 3 组件

大屏 / 自适应场景优先关注：

- Compose Material 3 Adaptive
- `currentWindowAdaptiveInfo`
- Navigation Suite 相关能力

如果项目仍以 Views / XML 为主，则新规则应“增量对齐项目”，而不是强制推翻。

## 导航

如果项目已用 Jetpack Navigation，优先延续现有方式。

Compose 场景：

- Compose Navigation 或项目现有导航框架

View 场景：

- Navigation Component 或项目现有稳定导航方案

## 输入与键盘

Compose 场景优先使用官方能力：

- `TextField`
- `KeyboardOptions`
- `ImeAction`
- `KeyboardActions`
- `LocalSoftwareKeyboardController`
- `LocalFocusManager`

View 场景优先使用：

- `inputType`
- `imeOptions`
- `SoftwareKeyboardControllerCompat`

## 选型原则

1. 先看项目现状。
2. 再看 Android 官方推荐是否匹配场景。
3. 如果项目已有稳定主流方案，优先兼容。
4. 只有当现状明显落后、维护成本高、且本次任务边界合适时，才推动替换。

## 简要选型表

- 屏幕状态持有：`ViewModel`
- 异步与层间通信：`coroutines` + `Flow`
- 轻量本地配置：`DataStore`
- 结构化本地存储：`Room`
- 持久后台任务：`WorkManager`
- 大列表分页：`Paging 3`
- 依赖注入：`Hilt`
- 新页面 UI：`Compose`
- 大屏自适应：Material 3 Adaptive
