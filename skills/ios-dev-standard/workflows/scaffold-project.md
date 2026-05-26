# Scaffold Project Workflow

1. 明确产品规模、UI 技术栈、是否需要离线、是否多账号、是否有扩展进程。
2. 建立根目录：
   - `App`
   - `Core`
   - `Domain`
   - `Data`
   - `Session`
   - `Features`
   - `Shared`
   - `Resources`
   - `Configs`
   - `Tests`
   - `Tools`
3. 先实现最小基础设施：
   - Theme token
   - DesignSystem 基础按钮和输入框
   - Toast/Dialog/Loading/Empty/Error
   - HTTPClient 协议
   - Keychain/UserDefaults wrapper
   - SessionStore
   - Logger
4. 建立首个 Feature，作为模板页面。
5. 添加 README 或内部说明，说明新需求文件落点。
6. 跑编译，保证空架子可运行。

检验：新增一个普通页面时，是否无需重新设计目录和全局组件？
