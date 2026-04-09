---
name: android-architecture-bootstrap
description: Use for designing, reviewing, or bootstrapping a production-grade native Android architecture in Kotlin projects. Good for new projects, monolith-to-modular migrations, module blueprint design, multi-app family architecture, build-logic and Gradle governance, dependency locking, flavor capability matrix design, test infrastructure planning, data and state modeling, performance baseline planning, compatibility adaptation, observability, security, release strategy, and architecture reviews. Start by clarifying product scope, team size, device support, app family shape, offline requirements, distribution constraints, and integration complexity; then choose the smallest enforceable architecture and define compile-time rules before implementation.
---

# Android 架构搭建

当任务属于下面场景时使用本 skill：

- 从 0 到 1 搭建原生 Android 项目架构
- 把单模块项目升级为生产级多模块架构
- 设计模块图、依赖方向、分层与目录规范
- 设计多 App 同仓、手机 + Wear + Automotive 等设备族架构
- 规划 build logic、版本管理、依赖治理、CI 质量门禁
- 设计 flavor / capability matrix、渠道差异、开关策略
- 设计数据建模、缓存、同步、状态流方案
- 设计测试基础设施、testFixtures、testing-unit、testharness
- 输出标准目录模板、模块命名规范、脚手架落地建议
- 设计性能、兼容、稳定性、安全、发布治理
- 对现有 Android 架构做生产级评审和整改路线图

## 最高优先级规则

- 架构先服务业务、团队和发布节奏，不服务抽象炫技。
- 先界定约束，再定架构；没有上下文时先写明假设，不盲目套模板。
- 优先选择最小但可扩展的架构，不为了未来想象一次性过度拆分。
- 模块边界、依赖方向、质量门禁要尽量固化成工程规则，不靠口头约定。
- 先定义组合根、状态真相源、数据真相源、依赖方向，再开始实现。
- 性能、兼容、稳定性、安全、发布治理必须在架构阶段进入设计，不要等上线前补洞。
- 若是存量项目演进，优先增量迁移，不建议无证据整仓重写。
- `common` / `shared` 不是默认垃圾桶；共享面必须小而稳定，并控制对外暴露的 API 面。
- flavor 不只是渠道命名；若承载能力差异，必须按 capability matrix 设计，而不是在业务代码里到处写分支。

## 使用流程

1. 先界定项目上下文：
   - 产品类型：工具、内容、电商、社交、音视频、企业协作、超级 App
   - 产品形态：单 App、双 App、App 家族、多端同仓
   - 团队规模：1 到 3 人、4 到 10 人、10 人以上
   - 生命周期：新项目、0 到 1、增长期、重构期、并行维护期
   - 设备和系统范围：手机、平板、折叠屏、Wear、Automotive、TV、专用设备
   - 构建与发布：单渠道、多环境、多 flavor、灰度、A/B、远程开关
   - 离线复杂度：在线优先、离线优先、重同步、后台任务密集
   - 合规和安全：登录、支付、隐私、文件、WebView、企业数据

2. 再选择架构基线：
   - 小团队轻量基线
   - 中大型团队模块化基线
   - Brownfield 渐进迁移基线
   - 多 App / 多端设备族基线
   - 超大规模强治理基线

3. 设计模块骨架与边界：
   - 组合根
   - app shell 切分方式
   - feature 切分方式
   - core、platform、common 的归属
   - design system 与 resources
   - api / impl / internal 是否需要

4. 设计工程治理：
   - version catalog
   - build-logic / convention plugin
   - repository whitelist
   - dependency locking
   - 自定义 lint / build rule
   - 依赖准入和模块模板
   - CI 任务和质量门禁
   - 覆盖率与质量平台聚合

5. 设计数据与状态：
   - Domain model、DTO、Local model、Ui model
   - Repository 边界
   - 单一事实源
   - 缓存和同步策略
   - UiState / Effect / Action 组织

6. 设计测试与发布基础设施：
   - testing-unit / testFixtures
   - testharness 是否需要
   - release engineering
   - artifact 命名和输出治理
   - 映射文件、符号文件、发布说明

7. 设计非功能架构：
   - 启动性能与性能预算
   - 兼容适配矩阵
   - 安全边界
   - 可观测性
   - 发布、灰度、回滚能力

8. 最后输出完整方案：
   - 架构目标
   - 模块树
   - 依赖规则
   - 数据设计
   - 状态设计
   - 工程治理
   - 测试与发布基础设施
   - 性能 / 兼容 / 安全 / 发布策略
   - 分阶段落地路线图

## 参考资料选择

按需读取下面 reference，不要一次性全读：

- 项目范围与架构基线：`references/scoping-and-topology.md`
- 模块蓝图与边界规则：`references/module-blueprint-and-boundary-rules.md`
- Build Logic 与 Gradle 治理：`references/build-logic-and-gradle-governance.md`
- UI、状态、导航与设计系统：`references/ui-state-navigation-and-design-system.md`
- 数据建模、缓存与同步：`references/data-modeling-cache-and-sync.md`
- 性能、兼容与平台能力层：`references/performance-compatibility-and-platform.md`
- 安全、可观测性与发布治理：`references/security-observability-and-release.md`
- 多 App 与设备族架构：`references/multi-app-and-device-family-architecture.md`
- 依赖治理与锁文件：`references/dependency-governance-and-locking.md`
- 质量流水线与覆盖率：`references/quality-pipeline-and-coverage-strategy.md`
- Flavor 能力矩阵：`references/flavor-capability-matrix.md`
- 测试基础设施与 testharness：`references/test-infrastructure-and-testharness.md`
- 发布工程与制品治理：`references/release-engineering-and-artifact-governance.md`
- 标准目录模板与模块命名：`references/project-template-and-module-naming.md`
- 输出模板与评审清单：`references/architecture-delivery-checklist.md`

## 快速决策规则

- 需求和团队还小：先用轻量模块化，不要一开始铺太多 `api / impl / internal`。
- 业务域多、多人并行开发：优先 feature 模块化，并用 contract 或 `api / impl` 管住依赖。
- 有手机 + Wear + Automotive 或多 App 家族：优先拆 app shell 和 common / core / feature，不要把所有差异压进一个 app 模块。
- 构建越来越慢、规则越来越靠 Review 才发现：优先补 build logic、lint、依赖规则插件。
- 仓库源、依赖版本、CVE 修复越来越混乱：优先补 repository whitelist、dependency locking、BOM 和约束治理。
- 页面多且状态复杂：默认 `ViewModel + UiState + Action + Effect`，避免多份状态真相源。
- 离线、同步、文件、下载、推送、支付、WebView 很重：尽早抽 platform 能力层。
- 需要 `full/minimal`、`fdroid/standard`、`gms/non-gms` 差异：优先设计 flavor capability matrix，而不是到处写运行时分支。
- 集成链路难测、能力接近独立产品：优先考虑 `testFixtures`、`testing-unit` 和 `testharness`。
- 兼容设备面广：适配矩阵和窗口分级必须在架构文档中明确，不允许后补。
- 无法一次性重构：做迁移路线图，先把新增代码接到新边界里，再逐步抽离旧实现。

## 默认执行标准

- 默认使用 Kotlin。
- 默认 Compose 优先；已有 XML 体系则允许双轨并存，不强行推翻。
- 默认单 Activity + 多 feature route；若历史 Activity 链路稳定，可保留 Activity contract。
- 默认 `ViewModel + StateFlow` 管屏幕状态。
- 默认 UseCase 或明确业务编排层连接 UI 与 Repository。
- 默认 Hilt 或现有稳定 Dagger 体系。
- 默认 `Room + DataStore + WorkManager + Coroutines + Flow` 作为基础设施优先选项。
- 默认 `version catalog + build-logic + convention plugin + 自定义 lint`。
- 默认开启 repository mode 管控并优先使用 dependency locking。
- 默认要求静态检查、聚合覆盖率、测试报告和质量平台能接入 CI。
- 默认要求 `Baseline Profile + Macrobenchmark` 进入性能基建。
- 默认要求多环境、监控、feature flag、灰度与回滚能力可落地。
- 默认考虑 `testing-unit`、`testFixtures` 与必要时的 `testharness`。

## 输出要求

架构类任务的最终输出，至少包含：

- 项目背景与关键约束
- 架构目标与不做什么
- 推荐模块树和目录结构
- 单 App / 多 App / 多端设备族拓扑
- 依赖方向与禁止规则
- 数据建模和状态建模方案
- Build 和质量治理方案
- 测试与发布基础设施方案
- 标准目录模板与模块命名规范
- 性能、兼容、安全、发布策略
- 分阶段落地计划
- 风险与取舍

## 明确禁止

- 不问业务边界就直接套大而全模板
- 一上来把项目拆成大量无 owner 的空模块
- `app` 模块持续堆业务实现，最后变成第二个单体
- `common` / `shared` 模块无限膨胀，最后变成第二个单体
- feature 之间互相直接依赖 impl
- 把 DTO、数据库模型、UiState 混成一层
- 用文档描述边界，却不落 build rule / lint / convention plugin
- 把 flavor 当成命名层，而不是能力矩阵设计问题
- 把性能、兼容、安全、发布当成上线前临时 checklist
- 以一次性大重构替代可回滚的渐进迁移

## 与实现类 skill 的关系

本 skill 负责项目级架构设计与治理。
若任务进入具体页面实现、Bug 修复、页面拆分、状态调整、适配修复，可再配合 `android-dev-standard` 一类的实现规范 skill 使用。
