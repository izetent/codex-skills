# 事件和命令边界

判断什么应该是事件、什么应该是命令时读取本文件。

## 命令

好的命令示例：

- `setData(items)`
- `appendData(items)`
- `patchItems(items)`
- `removeItems(itemIds)`
- `scrollToItem(itemId)`
- `pauseCurrent()`
- `resumeCurrent()`

命令应该：

- 明确表达意图
- 在可行时保持幂等
- 不依赖隐藏的原生状态

## 事件

好的事件示例：

- `onCurrentItemChange`
- `onReachEnd`
- `onPlayStateChange`
- `onError`

事件应该：

- 描述已经发生了什么
- 避免要求 JS 立刻发送纠正时序的命令

## 避免

- 通过 classic bridge 事件流做逐帧视觉同步
- 让 JS 被迫重建原生内部状态的事件 payload
- 隐藏副作用的命令名
