# 测试基础设施与 testharness

## 目标

生产级项目要让测试能力模块化，而不是每个模块自己拼一套 fake、fixture、dispatcher、helper。

## 推荐构成

- `testing-unit`：共享单测工具
- `testFixtures`：模块内可复用测试资源
- fake / stub / fixture / builder 工具
- test dispatcher、test clock、test scope
- `testharness`：用于复杂集成链路的独立测试壳

## `testing-unit` 适合放什么

- 通用断言
- coroutine test 工具
- fake logger、fake navigator
- 通用 builder、fixture
- robolectric / instrumentation 的统一配置帮助类

## `testFixtures` 适合放什么

- 当前模块私有但可被其他模块测试复用的辅助代码
- compose test 组件
- feature contract 的测试实现
- 模块级 fake repository

## 什么时候需要 `testharness`

满足下面一类即可考虑：

- 某能力链路接近独立产品
- 需要独立的认证、权限、系统交互演示
- 复杂 SDK 集成需要稳定验证壳
- 正式 app 太重，不适合做专用验证入口

## `testharness` 规则

- 它是测试与验证产品，不是业务主壳
- 只依赖必要模块
- 清单、权限、包名、输出产物单独治理
- 不把正式发布逻辑反向绑进 testharness

## 测试层级建议

- module unit tests
- feature integration tests
- app shell smoke tests
- benchmark / screenshot / instrumentation tests
- 必要时独立 testharness manual + automated verification

## 常见错误

- 每个模块各自维护一套 fake 和 fixture
- 测试工具散落在正式代码目录
- testharness 逐渐变成第二个正式 app
- 没有共享 dispatcher / clock，测试越来越不稳定
