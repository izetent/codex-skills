---
name: rn-native-bridge
description: "用于 React Native 桥接相关工作，包括 Native Module、Native Component、TurboModule、Fabric、JSI、桥接事件和命令设计、RN 与原生的状态归属边界、宿主尺寸与原生视口尺寸不一致、滚动或播放热路径设计，以及跨平台桥接行为差异。优先明确所有权、稳定身份、低歧义 API，并避免把高频视觉同步放进 classic bridge。"
---

# RN 原生桥接

当主要问题发生在 RN 与原生边界，而不是普通 RN 页面逻辑时，使用本 skill。

## 核心规则

- 先判断问题属于 API 形态、生命周期、线程、事件顺序、尺寸还是状态归属。
- 修改任何桥接代码前，先确定单一真相源。
- 业务归属使用 `itemId` 等稳定身份，不使用 `index` 作为长期身份。
- 高频视觉同步和时序敏感的播放控制不要走 classic bridge。
- 优先使用低歧义的命令和事件 contract，不使用灵活但含义模糊的 payload。

## 第一轮排查

1. 先分类桥接面：
   - Native Module
   - Native Component
   - TurboModule
   - Fabric Component
   - JSI 支撑的同步路径

2. 只读取相关 reference：
   - 桥接设计原则：`references/bridge-design.md`
   - 事件和命令边界：`references/event-command-boundaries.md`
   - 尺寸和视口归属：`references/layout-and-viewport.md`
   - 线程和生命周期：`references/threading-and-lifecycle.md`
   - 验证清单：`references/bridge-validation.md`

3. 编辑前先说明：
   - 哪一侧拥有状态
   - 哪一侧发出事件
   - 哪一侧发送命令
   - 哪些消息可能乱序到达

## 设计指引

- 命令用于表达控制意图。
- 事件用于表达状态观察。
- 不要把事件当成隐藏的命令通道。
- payload 保持小而明确。
- 区分宿主尺寸和真实渲染视口尺寸。
- 命令命名要表达意图，例如：
  - `setData`
  - `patchItems`
  - `scrollToItem`
  - `pauseCurrent`
  - `resumeCurrent`

## 热路径规则

如果操作必须逐帧跟踪原生滚动或渲染，classic bridge 就不是正确路径。应使用原生持有的路径，或 UI 线程 / JSI 支撑的同步路径。

## 验证输出

必须说明：

- 最终状态归属模型
- 桥接 contract 变化
- 向后兼容风险
- 受影响平台
- 已验证内容
