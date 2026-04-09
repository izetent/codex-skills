# UI、状态、导航与设计系统

## UI 架构基线

默认建议：

- 新页面 Compose 优先
- 单 Activity 优先
- 页面状态统一由 ViewModel 持有
- 页面采用单向数据流
- 共享样式全部通过 design system 和 token 提供

若项目已有稳定 XML 体系，可增量演进，而不是强制一刀切迁移。

## 页面组织建议

复杂页面推荐结构：

```text
Host
Route
ViewModel
Screen
Content
Leaf Components
```

职责：

- Host：生命周期和入口
- Route：接参数、收状态、传事件
- ViewModel：动作处理与状态编排
- Screen：页面级结构、空态、错误态、弹窗
- Content：主体渲染
- Leaf：纯展示组件

## 状态模型建议

默认使用：

- `UiState`：持续状态
- `Action`：用户动作或页面动作
- `Effect` / `Command`：一次性事件

建议：

- 一个页面一个主 `UiState`
- 能推导的值不重复存一份
- 页面级 loading、error、dialog、sheet 进入统一状态模型
- 不在多个组件各自维护业务真相源

## 导航设计建议

### Compose 项目

优先：

- feature 自己暴露 destination 或 route contract
- 参数使用稳定的 contract
- deep link 单独管理

### 多 Activity 或混合项目

优先：

- 统一 screen params 或 starter contract
- 调用方只依赖参数，不依赖 Activity 实现类

## 设计系统建议

至少包括：

- color
- typography
- spacing
- shape
- elevation
- iconography
- common components
- feedback components

规则：

- 业务页面不直接写一套新颜色和间距
- Dialog、BottomSheet、Button、ListItem、Input 优先统一组件
- 大字体、暗黑模式、RTL、状态栏和 IME inset 一开始就进入组件能力

## 自适配建议

优先顺序：

1. 导航形态切换
2. 容器宽度与布局约束
3. 内容密度调整
4. 必要时再切不同布局模式

不要一上来复制一整套平板页面。

## 可访问性建议

- 触控热区满足最小要求
- 文本层级和对比度明确
- TalkBack 标签和顺序可读
- 字体缩放不炸布局
- 键盘和焦点路径可用

## 不推荐做法

- 在 Composable 里直接拉接口、直接调 DAO
- 每个组件自己偷偷维护业务状态
- 页面到处散落零散布尔值决定 UI
- 直接在业务页面硬编码颜色、字号、圆角
