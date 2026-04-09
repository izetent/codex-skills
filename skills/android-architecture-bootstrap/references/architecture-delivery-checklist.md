# 输出模板与评审清单

## 架构设计输出模板

至少输出下面内容：

1. 项目背景
   - 产品类型
   - 团队规模
   - 主要业务域
   - 设备范围
   - 发布和合规要求

2. 关键约束
   - 现状问题
   - 不做什么
   - 主要风险

3. 推荐架构基线
   - 采用哪一档基线
   - 为什么这样选

4. 模块树
   - 顶层目录
   - app shell 列表
   - feature 列表
   - core / platform / design-system / benchmark / lint-rules / testing 模块

5. 依赖规则
   - 允许依赖
   - 禁止依赖
   - 哪些规则编译期固化
   - common / shared 的对外暴露边界

6. 数据与状态设计
   - Repository 边界
   - 数据模型分层
   - 缓存与同步策略
   - UiState / Action / Effect

7. 工程与质量治理
   - build-logic
   - repository mode
   - dependency locking
   - lint / detekt / 覆盖率 / 质量平台

8. 测试与发布基础设施
   - testing-unit / testFixtures / testharness
   - flavor matrix
   - artifact 命名与签名策略

9. 标准模板与命名
   - 顶层目录模板
   - 模块命名规则
   - feature / core / platform / testing 脚手架规则

10. 非功能设计
   - 性能预算
   - 兼容矩阵
   - 安全边界
   - 可观测性
   - 发布与回滚

11. 落地路线图
   - 第 1 阶段搭什么
   - 第 2 阶段固化什么
   - 第 3 阶段治理什么

## 架构评审清单

### 业务与范围

- 是否先写清楚了业务域和团队约束
- 是否明确了单 App 还是多 App / 多端设备族
- 是否明确了为什么需要模块化，而不是为了形式

### 模块边界

- `app` 是否仍是唯一组合根或各 app shell 是否各自是组合根
- feature 是否只暴露稳定 contract
- 是否存在跨 feature impl 依赖
- 是否区分了 core、platform、common
- `common` / `shared` 是否存在 API 面失控

### 数据设计

- 是否明确单一事实源
- DTO、Local、Domain、UI 是否分层
- 缓存和同步策略是否可解释

### UI 与状态

- 页面状态是否只有一个主真相源
- 导航 contract 是否稳定
- 设计系统是否能支撑暗黑、大字体、RTL、窗口适配

### 工程治理

- 是否有 build-logic 和统一 convention
- 是否启用了 repository 管控和 dependency locking
- 是否有自定义 lint 或等价编译期约束
- 新模块是否有模板和准入规则
- 是否有聚合覆盖率和质量平台接入

### 测试与发布基础设施

- 是否定义了 flavor capability matrix
- 是否定义了 testing-unit / testFixtures / testharness 边界
- 是否定义了产物命名、签名、发布说明和归档策略

### 非功能

- 是否定义了性能指标和观测方式
- 是否定义了兼容矩阵
- 是否定义了安全边界
- 是否有灰度、回滚、feature flag

## 分阶段落地建议

### Phase 1

- 搭顶层目录
- 建 version catalog
- 建 build-logic
- 建 app / core / feature / platform / design-system 基础模块
- 确定状态流和导航基线
- 开启 repository mode 管控

### Phase 2

- 接第一批真实业务 feature
- 建数据建模和缓存策略
- 补 testing-unit、testFixtures
- 补 Benchmark、Baseline Profile
- 建 CI 快速门禁和聚合覆盖率

### Phase 3

- 补自定义 lint / build rule
- 完成平台能力层抽离
- 建 flavor capability matrix
- 需要时补 testharness
- 建灰度、开关、监控闭环
- 整理迁移文档和模块 owner
