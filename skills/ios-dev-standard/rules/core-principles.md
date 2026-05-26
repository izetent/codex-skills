# Core Principles

## 证据优先

先确认现象、路径、影响范围和已有代码，再改实现。

检验：这次修改前是否能说出“为什么问题属于这一层”？

## 最小责任层修改

只改真正负责问题的层，不顺手重构无关代码。

检验：每个改动文件是否都能直接对应用户目标或根因？

## 状态单一来源

跨页面共享状态必须归 Session、Repository、Runtime 或明确 store。

检验：是否存在两个页面长期维护同一份用户态、登录态、会员态或同步态？

## 一次性事件不进长期状态

导航、Toast、Dialog、权限结果、支付结果只通过 event/effect/coordinator action 消费。

检验：旋转、重建、重新订阅时是否会重复触发同一事件？

## 页面保持薄

Screen/ViewController 只做 UI 编排、事件绑定和展示。

检验：页面中是否出现网络 client、数据库、Keychain、复杂业务规则？

## 设计系统优先

样式先找 token、主题、共享组件。

检验：是否新增了散落色值、字号、按钮样式、Loading、Empty 或 Error？

## 自适应优先

布局用 Safe Area、Layout、Size Class、Window Size、Dynamic Type。

检验：小屏、iPad、横屏、字体放大、键盘是否仍然成立？
