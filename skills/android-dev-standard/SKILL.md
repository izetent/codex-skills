---
name: android-dev-standard
description: Use for native Android development tasks in Kotlin projects, especially when the work involves modularization, architecture, feature development, bug fixing, page decomposition, Compose or XML UI structure, adaptive layout, data flow, testing, or code review. Prioritize root-cause analysis before edits, keep changes minimal and direct, enforce module boundaries, and verify the original path plus nearby regressions.
---

# Android 开发规范

当任务属于原生 Android 工程时使用本 skill，包括：

- 功能开发
- Bug 修复
- 模块化和架构调整
- 复杂页面拆分
- Compose 或 XML 页面开发
- 自适应布局问题
- 状态流、数据层、仓储层设计
- 测试补充
- 代码评审

## 最高优先级规则

- 先定位根因，再做最小修改。
- 没有证据前，不直接改代码。
- 修改必须小、准、稳，只改真正负责该问题的代码。
- 不允许靠大量 fallback、重复状态、延时、重试、强刷来掩盖问题。
- 模块边界、依赖方向、UI 规范要尽量通过工程规则固化，不靠口头约定。
- 样式优先走设计系统、主题和共享组件，不在业务页面随意写一套。
- 修改后必须验证原始路径和邻近回归路径。

## 使用流程

1. 先判断任务类型：
   - 修 Bug
   - 做功能
   - 调整架构或模块
   - 拆复杂页面
   - 改自适应布局
   - 做 Review

2. 修改前先说清楚：
   - 现象或目标
   - 触发路径
   - 影响范围
   - 所在模块和层级
   - 已有证据

3. 按需读取 reference：
   - 两个开源项目精华汇总：`references/open-source-project-synthesis.md`
   - 根因定位与修改规则：`references/root-cause-and-modification.md`
   - 模块化与分层规则：`references/modularization-and-architecture.md`
   - 页面拆分与状态归属：`references/page-splitting-and-state.md`
   - 自适应布局与样式规范：`references/adaptive-layout-and-styling.md`
   - 组件、ViewModel、数据层开发规则：`references/component-state-and-data-layer.md`
   - 项目对齐与交互细节：`references/project-alignment-and-interaction-details.md`
   - 官方主流库使用建议：`references/official-library-recommendations.md`
   - 性能、稳定性与安全：`references/performance-stability-and-security.md`
   - 测试、Review、提交协作：`references/quality-and-collaboration.md`

4. 动手前必须明确：
   - 当前根因判断或改动边界
   - 支撑该判断的证据
   - 为什么这是最小必要修改

5. 完成后必须说明：
   - 改了什么
   - 为什么这样能解决根因或满足目标
   - 做了哪些验证
   - 还有什么未验证

## 决策规则

- 根因不清楚，先排查，不猜。
- 跨模块改动，先定义边界和依赖方向，再写代码。
- 页面太大，按职责和状态归属拆，不按文件行数硬拆。
- 适配问题优先靠窗口信息、约束和主题 token 解决，不优先写死设备分支。
- 数据层问题优先修仓储、网关、状态源，不在 UI 层做掩盖。
- 若项目已存在设计系统、导航、DI、主题、命名、目录约定，优先沿用项目现状，不把 skill 当成强制覆盖模板。
- 表单和输入交互要补齐键盘、焦点、IME action、滚动时关闭键盘等细节，但必须和当前页面交互预期一致，不能生硬加行为。
- 公共规则如果经常靠 Review 才发现，优先考虑补 lint、build rule、约定插件。
- 如果存在多个可行方案且取舍明显，先把方案说清楚，再改。

## 最终输出要求

实现类任务的收口说明，至少包含：

- 问题或目标
- 根因或架构判断
- 最小改动范围
- 验证方式
- 剩余风险

## 默认执行标准

- 默认使用 Kotlin。
- 默认优先 Compose；若项目已有 XML 体系且页面属于旧链路，则遵循现有体系，不强行迁移。
- 默认使用 `ViewModel + UiState + Flow/StateFlow` 组织页面状态。
- 默认通过 UseCase 或明确业务编排层衔接 UI 与 Repository。
- 默认通过 Hilt / Dagger 等 DI 体系管理依赖，不手写 Service Locator。
- 默认要求测试至少覆盖本次修改的直接行为和一条邻近回归路径。

## 明确禁止

- 未定位问题就直接修改实现
- 为了一个局部问题顺手改一大片无关代码
- 用魔法值、延时、重试、强制重建页面解决本质问题
- 在 feature 页面中直接操作数据库、网络接口、SDK 大对象
- 在多个地方维护同一份页面状态
- 仅以“测试环境没复现了”作为修复完成依据
