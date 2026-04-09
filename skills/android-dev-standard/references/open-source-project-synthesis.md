# 两个开源项目精华汇总

这份总结基于当前工作区里的两个 Android 开源项目：

- `mega`
- `DuckDuckGo`

目标不是照搬，而是抽取对真实团队最有价值、最稳定的工程做法。

## 一、路由怎么处理

### `mega` 的做法

`mega` 更接近“模块化 Compose 导航 + feature 注册”的方案。

核心特点：

- 每个 feature 通过 `FeatureDestination` 暴露自己的导航图
- 通过 DI 把 `FeatureDestination` 注入到主导航系统
- 页面导航依赖 `NavKey` 或导航 contract，而不是直接写死页面实现
- DeepLink 也作为独立 handler 注册

优点：

- feature 可以独立注册路由
- 导航边界清晰
- 适合模块很多、Compose 较重的项目

适合你落规则时写成：

- feature 提供导航入口，不直接把页面实现暴露给外部
- 导航参数使用稳定 contract
- DeepLink 和页面路由拆开管理

### `DuckDuckGo` 的做法

`DuckDuckGo` 更接近“Activity 路由 contract + 全局启动器”的方案。

核心特点：

- 页面参数统一实现 `GlobalActivityStarter.ActivityParams`
- 页面通过 `@ContributeToActivityStarter` 注册到启动系统
- 调用方只依赖参数类型，不直接构造 Intent
- 这样可以跨模块解耦页面跳转

优点：

- Activity 跳转强解耦
- 跨模块跳转成本低
- 参数和页面映射关系集中

适合你落规则时写成：

- 项目若以 Activity 为主，可采用统一路由参数 contract
- 调用方依赖 screen params，不依赖具体 Activity 类
- 不要在业务代码里到处手写 Intent

## 路由规范建议

- Compose/单 Activity 项目，优先 `feature destination + nav contract`
- 多 Activity 项目，优先 `screen params + global starter`
- 路由参数必须是稳定、可读、可测试的 contract
- feature 对外暴露“可导航能力”，不暴露页面内部实现
- DeepLink 单独处理，不和普通页面事件混在一起

## 二、弹窗和底部弹层怎么处理

### `mega` 的做法

`mega` 把 Dialog 和 BottomSheet 收敛成共享组件：

- `BaseMegaAlertDialog`
- `ConfirmationDialog`
- `ProgressDialog`
- `FullScreenDialog`
- `MegaModalBottomSheet`

关键精华：

- 是否允许点空白关闭，通过 `dismissOnClickOutside` 明确控制
- 是否允许返回键关闭，也单独控制
- 全屏弹窗直接禁止 outside dismiss
- 页面里优先走统一 Dialog / BottomSheet 组件，而不是随处临时写一版

这类做法的价值很高：

- 风格统一
- 行为统一
- 更容易避免误触和穿透

### `DuckDuckGo` 的做法

`DuckDuckGo` 既有 Compose 设计系统，也保留很多 View/DialogFragment 体系。

精华在于：

- Dialog 仍尽量通过统一 builder 或统一样式构建
- `DialogFragment` 对关键确认类弹窗会显式 `isCancelable = false`
- 设计系统和 lint 限制开发者不要乱用原生 AlertDialog / BottomSheetDialog

## 弹窗规范建议

- 业务项目里应收敛一套统一 Dialog / BottomSheet 封装
- 下面几类弹窗默认不允许点空白关闭：
  - 破坏性确认
  - 关键流程中断确认
  - 加载中 / 处理中
  - 需要用户明确决策的关键弹窗
- 下面几类弹窗可以允许点空白关闭：
  - 轻提示
  - 可取消的信息说明
  - 非关键筛选面板
- 弹窗开关状态不要散落在多个布尔值里，统一归属于页面状态或页面级事件

## 三、如何避免点击穿透、误触、重复点击

两个项目都没有用“玄学兜底”，而是各自用了工程化办法。

### 1. 明确控制 outside dismiss

`mega` 的弹窗封装里把 `dismissOnClickOutside` 作为显式参数控制。

规则：

- 是否允许点外部关闭必须显式设计，不要依赖默认值猜测
- 关键弹窗默认禁止 outside dismiss

### 2. 通过遮罩或容器消费事件

`mega` 在一些容器上使用 `pointerInput` 来拦截或消费手势。

这类能力适合：

- 全局会话保护层
- 点击空白关闭焦点
- 阻止事件继续穿到下层内容

规则：

- 有遮罩层、loading 层、session 阻断层时，事件要被顶层显式消费
- 不要让用户点击穿到底层页面继续触发操作

### 3. 对按钮和操作做去抖

`mega` 同时有 View 层 `debounceClick`，也有 Compose 层 `DebouncedButtonContainer`。

这说明一个成熟规则：

- 重要按钮不要默认允许连续高频点击
- 提交、保存、下载、跳转、购买、确认类按钮，应考虑去抖或点击后短暂禁用

规则：

- 导致重复请求、重复提交、重复导航的操作必须做防抖
- 列表轻操作是否需要去抖，要看业务成本，不能全局一刀切

### 4. 主点击区域和尾部操作区分离

`DuckDuckGo` 的 list item 把主区域点击、尾部 icon 点击分开处理。

这很重要：

- 避免用户点 overflow 时触发整项点击
- 避免二级动作和一级动作互相抢事件

规则：

- 列表项主点击区和 trailing action 区分开
- 主项点击、长按、菜单点击不能互相覆盖

## 四、点击效果该怎么加

两个项目的共性不是“所有可点击都加效果”，而是“可点击区域有明确反馈，但反馈形式服从组件语义”。

### 推荐有点击反馈的场景

- 按钮
- 列表项
- 卡片
- 图标按钮
- 菜单项
- 标签切换项
- 底部弹层操作项

优先方式：

- 走设计系统默认 ripple / pressed state
- 使用共享组件自带点击态

### 需要谨慎处理的场景

- 输入框 trailing icon
- 文本链接
- 很小的图标点击区
- 已经有单独背景装饰的可点击文字

这类场景里，项目中可以看到 `indication = null` 的写法，但那不是默认规则，而是局部特例。

规则：

- 默认可点击内容保留点击反馈
- 只有在局部图标或文字点击会造成视觉噪音、和父容器 ripple 重叠时，才考虑移除默认 indication
- 移除点击背景后，必须还有别的可识别交互信号：
  - 下划线
  - 品牌色
  - 图标变色
  - 光标或焦点变化

## 五、文字点击是否需要移除背景

结论：默认不作为硬规则。

更合理的规则是：

- 如果文字本身就是“链接语义”，可以不做明显背景，但要有文本语义变化，例如下划线、颜色变化
- 如果文字承担“按钮语义”，不建议只做纯文字且无反馈
- 如果可点击文字处在表单说明、协议说明、帮助入口中，可以弱化背景，但不能弱化可发现性

推荐：

- 链接文字：颜色 + 下划线，背景可弱化
- 按钮型文字：仍保留明确 pressed/ripple 或容器反馈

## 六、内存与性能要求怎么提

从两个项目看，真正可执行的性能规则主要是这些：

- 页面状态不要重复缓存多份
- Flow/搜索/刷新类高频事件适当 debounce
- Worker 和后台任务要幂等，避免重复调度
- 页面和导航系统要正确消费 insets，避免重复布局开销和错位
- 长列表、大图、搜索、状态频繁切换优先查状态源与订阅链路

## 性能规则建议

- 搜索输入、筛选输入、通知刷新、状态同步等高频事件可适当 debounce
- 任何 debounce 都必须有明确目标，不能拿来掩盖根因
- 图片浏览、大图预览、长列表、复杂页面切换要重点关注重组频率和内存占用
- 避免页面退出后仍保留大对象、订阅、回调
- Dialog、BottomSheet、全屏蒙层关闭后要及时释放状态

## 七、适合沉淀成团队规范的共识

### 路由

- Compose 多模块项目：feature 提供 destination
- 多 Activity 项目：统一 route params + starter
- 不到处手写 Intent

### 弹窗

- 收敛统一 Dialog / BottomSheet 封装
- outside dismiss 和 back dismiss 显式控制
- 关键流程弹窗默认禁止点空白关闭

### 点击与交互

- 重要操作去抖
- 列表项主点击区和尾部操作区分离
- 默认保留点击反馈，局部特例才移除 indication
- 链接文字弱化背景可以，但不能丢失可发现性

### 防穿透

- 遮罩层显式消费事件
- 关键弹窗和处理态避免穿透到底层
- 输入、搜索、筛选类页面补齐键盘与焦点联动

### 性能与稳定性

- 高频事件适度 debounce
- 后台任务幂等
- 避免重复订阅、重复调度、重复状态源
- 先查链路，再做优化
