# 功能开发流程

1. 定义功能目标、用户路径、成功标准。
2. 判断落点：
   - 页面：`Features/<Feature>`
   - 业务规则：`Domain/UseCases`
   - 数据协议：`Domain/Repositories`
   - 接口实现：`Data/Remote`
   - 缓存/本地：`Data/Local`
   - 共享状态：`Session`
   - 通用 UI：`Shared` 或 `Core/DesignSystem`
3. 定义 `ViewState`、`ViewAction`、`ViewEvent`。
4. 实现 UI 时优先复用设计系统。
5. ViewModel 只调用 UseCase/Repository，不直接访问 API 或数据库。
6. 处理 Loading、Empty、Error。
7. 检查适配和可访问性。
8. 补风险对应测试。
9. 验证新增路径和邻近路径。

检验：这个功能删掉 UI 后，核心业务是否还能通过 UseCase/Repository 测试？
