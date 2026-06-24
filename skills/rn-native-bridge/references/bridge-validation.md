# 桥接验证

桥接相关任务收口前必须读取本文件。

## 必须明确验证

- RN 侧 API 形态
- Android 侧 API 形态
- iOS 侧 API 形态
- 涉及 TurboModule 或 Fabric 时的生成代码
- 事件名和 payload 结构的向后兼容性
- 命令顺序假设
- 修改布局相关字段后的尺寸行为

## 必须清楚说明

- contract 改了什么
- 是否有调用点必须同步修改
- Android 和 iOS 行为是否仍一致
- 是否仍有时序敏感路径未验证
