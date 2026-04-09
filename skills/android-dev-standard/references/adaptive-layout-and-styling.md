# 自适应布局与样式规范

## 适用场景

- 新写或修改 Android UI
- 处理手机 / 平板差异
- 支持横竖屏
- 处理系统栏、IME、刘海、手势区
- 编写 Compose 或 XML 布局

## 核心原则

自适应布局优先靠约束、窗口信息、主题 token、共享组件能力来做，不靠大量硬编码设备分支。

## 样式规则

- 颜色、字号、间距、圆角、阴影优先来自设计系统或主题 token。
- 业务页面如果已有 token，不再随意写一套新值。
- 按钮、列表项、AppBar、Dialog、Sheet、Chip、Toggle 优先复用共享组件。
- XML 优先用 theme attribute，不直接写颜色字面量。
- Compose 优先用语义化主题值，不直接到处写原始颜色。

推荐：

```kotlin
Text(
    text = title,
    style = MaterialTheme.typography.titleMedium,
    color = MaterialTheme.colorScheme.onSurface,
)
```

不推荐：

```kotlin
Text(
    text = title,
    fontSize = 17.sp,
    color = Color(0xFF222222),
)
```

## Compose 布局规则

- 页面级结构优先 `Scaffold`
- 系统栏和输入法优先显式处理：
  - `WindowInsets`
  - `consumeWindowInsets`
  - `navigationBarsPadding`
  - `statusBarsPadding`
  - `imePadding`
- 关系复杂时用 `ConstraintLayout`
- 会自动换行的内容用 `FlowRow`
- 用 `weight`、`widthIn`、`heightIn`、最大宽度约束来控制伸缩和溢出
- 文本、标签、筛选项在横屏或大屏场景下要明确最大宽度，避免炸布局

推荐写法：

```kotlin
Row(modifier = Modifier.fillMaxWidth()) {
    Text(
        text = title,
        modifier = Modifier.weight(1f),
        maxLines = 1,
        overflow = TextOverflow.Ellipsis,
    )
    Spacer(modifier = Modifier.width(12.dp))
    Icon(...)
}
```

## XML / View 布局规则

- 非简单排列优先 `ConstraintLayout`
- 避免复杂页面里层层嵌套 `LinearLayout`
- 间距和尺寸用 dimen / theme
- 使用 `start/end`，不用 `left/right`
- 兼顾大字体、RTL、长文案、点击热区

## 尺寸与间距规则

- 列表项、按钮、输入框优先使用统一 spacing token
- 页面左右边距、模块间距、卡片内边距尽量有统一层级
- 不在一个页面里混用多套相近但不同的间距值
- 大屏适配优先调整容器宽度，不优先把字号和间距全部放大

## 适配层级建议

优先按下面顺序适配：

1. 导航和 scaffold 形态切换
2. 容器宽度和布局约束调整
3. 内容密度调整
4. 只有必要时才切换成完全不同的布局模式

## 推荐做法

- 横屏或宽屏时，底部导航切为导航 rail
- 主内容区设置可读性宽度上限
- 筛选项、标签、操作区支持自然换行
- 对话框使用最小 / 最大宽度约束，不写死固定尺寸
- 输入区和底部操作区明确处理 IME 与导航栏 inset
- 列表内容和固定底栏之间明确留出安全区域

## 不推荐做法

- `if (isTablet)` 后复制一整套页面
- 不同设备形态写大量重复 UI
- 用大量固定宽高，刚好只适配一台测试机

## 自适应排查顺序

遇到布局问题时，优先按下面顺序排查：

1. 是否重复消费或遗漏消费 inset
2. 是否存在固定宽高导致溢出
3. 是否缺少 `weight`、`widthIn`、`maxLines`
4. 是否该用 `FlowRow` 却硬塞在单行
5. 是否把手机布局强行照搬到横屏 / 大屏

## Insets 与安全区检查项

至少确认：

- 状态栏是否遮挡
- 导航栏是否遮挡
- IME 是否顶住输入区
- BottomSheet / Snackbar 是否和底部区域冲突
- 刘海 / cutout 是否处理正确

如果父级已经消费过 inset，下游不要重复消费。

## 大页面适配检查清单

- 导航是否会随横竖屏或窗口宽度变化
- 宽屏下正文是否仍可读
- 筛选项、操作区、标签是否能收缩或换行
- 系统 inset 是否只消费一次且位置正确
- 大字体、长文案、本地化下是否仍稳定

## Review 清单

- 样式是否走 token
- 是否存在可以避免的硬编码设备逻辑
- 宽度和溢出行为是否明确
- RTL、大字体、长文案下是否还能工作
