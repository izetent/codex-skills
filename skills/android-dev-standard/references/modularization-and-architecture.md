# 模块化与架构规范

## 适用场景

- 新增模块
- 调整分层
- 移动代码归属
- Review 依赖方向
- 新功能落模块

## 核心目标

模块化的目的是约束边界、稳定依赖方向、降低耦合，不是为了把目录拆得更碎。

常见目标分层：

- `app`：组装入口
- `feature`：用户能力切片
- `domain`：业务契约、实体、UseCase
- `data`：仓储实现、网关、持久化
- `core`：公共技术能力、公共 UI 能力
- `resources` / design-system：共享资源和样式 token

## 依赖规则

- `app` 负责组装，不承载具体业务实现。
- feature 依赖稳定接口和公共基础设施，不依赖别的 feature 内部实现。
- feature A 需要 feature B 的能力时，依赖 B 的 contract / api，不依赖 B 的 impl。
- data 实现 domain 契约，domain 不反向依赖 data。
- UI 层不直接操作 Retrofit、Room、SDK facade。
- 只要感觉依赖方向不顺，就先停下来调整边界，不要带着错误方向继续写。

## 各层职责

### `app`

适合放：

- Application 入口
- 导航组装
- DI 组装
- build variant
- 最终 feature 接线

不适合放：

- 页面业务逻辑
- Repository 实现
- 可复用 UI 组件

### `feature`

适合放：

- 页面入口
- ViewModel
- UIState
- feature 内 mapper
- feature 内导航处理
- 明确属于该 feature 的业务编排

不适合放：

- 别的 feature 的实现细节
- 通用 UI 基础组件
- 底层存储细节

### `domain`

适合放：

- 业务实体
- Repository 接口
- UseCase
- 纯业务映射

尽量保持轻 Android 依赖，能纯 Kotlin 就纯 Kotlin。

不适合放：

- Retrofit DTO
- Room Entity
- Android Context
- Activity / Fragment / View 直接依赖

### `data`

适合放：

- Repository 实现
- Room / DAO
- DataStore
- Retrofit / SDK gateway
- Worker 实现
- 持久化映射

不适合放：

- 页面状态
- 与具体页面强绑定的 UI 逻辑

## 推荐依赖关系

```text
app -> feature -> domain
app -> feature -> core
feature -> domain
feature -> core
data -> domain
app -> data
```

如果项目采用 `api / impl` 结构，则优先收敛成：

```text
feature-a-impl -> feature-a-api
feature-b-impl -> feature-b-api
feature-a-impl -> feature-b-api
app -> feature-a-impl
app -> feature-b-impl
```

而不是：

```text
feature-a-impl -> feature-b-impl
```

## 工程化约束

重要规则要尽量写进工具链：

- convention plugin
- architecture plugin
- 自定义 lint
- 模块命名约定

如果一条规则经常靠 code review 才发现，就说明它应该前置到构建期。

## 新功能落地清单

1. 先定义功能边界。
2. 先判断应归属到现有哪个模块。
3. 只有边界稳定时才新增模块。
4. 先定义 contract，再跨模块接实现。
5. 导航注册和 DI 接线放到组装点，不散落到各 feature 内部。
6. 新模块创建后，确认其测试、lint、命名、依赖方向都符合工程默认规则。

## 模块命名建议

- 功能模块：`feature-xxx` 或 `:feature:xxx`
- 公共业务契约：`domain`
- 公共技术能力：`core-xxx` 或 `:core:xxx`
- 资源模块：`resources-xxx`
- 如果采用 `api / impl`：
  - `xxx-api`
  - `xxx-impl`
  - `xxx-internal`
  - `xxx-store`

命名的目标是让归属和边界一眼可见。

## 何时不应该新增模块

- 逻辑只会被一个 feature 使用，且短期没有稳定扩展边界
- 所谓“公共”代码仍频繁随单一页面一起变化
- 抽出来以后依赖方向反而更乱
- 只是为了减少单文件代码量

## 架构评审问题

- 这个能力以后最可能由谁维护
- 谁才是真正的 owner
- 这个 contract 是否稳定到值得抽接口
- 当前抽层是在降低耦合，还是在制造跳转成本

## Review 清单

- 当前依赖方向是否合理
- 这段代码是否放在它真正拥有的模块里
- 有没有实现细节泄露到边界外
- 能否通过接口移除直接耦合
- 所谓“共享代码”是不是其实还没稳定
