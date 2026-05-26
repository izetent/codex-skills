# UI Adaptation Workflow

1. 明确设计意图：
   - 信息层级
   - 主操作
   - 次操作
   - 内容密度
   - 视觉风格
2. 查找现有 token 和组件。
3. 实现布局：
   - SwiftUI Layout 或 Auto Layout
   - Safe Area
   - Layout Margins
   - Readable Content Guide
   - Size Class / Window Size
4. 补全状态：
   - Loading
   - Empty
   - Error
   - Disabled
   - Selected
   - Pressed
5. 检查适配：
   - 小屏
   - 大屏
   - iPad
   - 横屏
   - Dynamic Type
   - Dark Mode
   - 键盘
   - 长文案
   - VoiceOver
6. 视觉敏感变更补截图或明确人工检查项。

检验：切到大字体和小屏时，核心操作是否仍可见可点？
