# 质量流水线与覆盖率

## 目标

质量体系不是只跑单测，而是让静态检查、覆盖率、测试报告和质量平台能形成自动闭环。

## 推荐组件

- 格式检查：ktlint / spotless
- 静态检查：detekt / Android Lint / 自定义 Lint
- 覆盖率：kover / jacoco 聚合
- 质量平台：SonarQube / SonarCloud 或等价平台
- PR 门禁：快速门禁 + 合并前门禁 + 发布前门禁

## 推荐分层

### 快速门禁

- changed files 格式检查
- detekt / lint 基础检查
- 核心模块单测

### 合并前门禁

- 全量模块单测
- 聚合覆盖率报告
- 关键 app variant 构建
- 关键 lint / custom lint

### 发布前门禁

- 关键 UI 冒烟
- 性能回归
- 包体与崩溃指标检查
- 基线 profile / screenshot / 合规检查

## 覆盖率策略

建议：

- 按模块收集
- 按变体聚合
- 明确排除 generated、preview、DI、纯模型、主题资源类
- 覆盖率是辅助信号，不用单一百分比绑死质量

## pre-commit 建议

适合：

- 团队提交频繁
- detekt / lint 成本适中

规则：

- precommit 优先跑 staged files
- 不要把过重的全量任务塞进提交钩子
- 真正强制门禁仍在 CI

## 测试执行稳定性

- 统一 JUnit 版本与平台
- 对 JVM tests 设置合理 heap、fork、parallel 参数
- Locale、timezone、dispatcher 尽量固定
- flaky test 必须单独治理，不要长期接受不稳定

## 报告与产物

- lint 报告
- 覆盖率 XML / HTML
- test 报告
- 质量平台上传产物
- 性能与截图类报告

## 常见错误

- 只看覆盖率数字，不看测试价值
- 每个模块各自配置一套静态检查
- precommit 过重导致开发者绕过
- 质量门禁没有分层，所有任务都在每次 PR 全量跑
