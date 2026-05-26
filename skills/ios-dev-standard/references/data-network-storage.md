# 网络、缓存、存储、鉴权

## 目录

- 网络层
- Repository
- DTO 与 Mapper
- 缓存
- 存储
- 鉴权和会话
- 错误处理

## 网络层

推荐：

```text
Core/Network/
  HTTPClient.swift
  APIRequest.swift
  APIResponse.swift
  APIError.swift
  AuthInterceptor.swift
  RequestLogger.swift
  NetworkReachability.swift
```

规则：

- 页面不直接创建网络 client。
- ViewModel 不拼完整 URL。
- token 注入统一。
- token 刷新统一。
- 登录失效统一。
- 错误码统一映射。
- 日志脱敏。
- 重试按接口语义设计，不全局乱重试。

## Repository

Repository 负责：

- remote/local/cache 编排。
- 数据刷新策略。
- 离线策略。
- 业务错误转换。
- 写入共享状态源。

ViewModel 只调用 UseCase 或明确业务编排层，不直接知道 API 和数据库。

## DTO 与 Mapper

规则：

- DTO 只在 Data 层。
- DTO 不传到 UI。
- Domain model 表达业务。
- UI model 表达展示。
- 后端字段变化不应扩散到多个页面。

推荐流向：

```text
DTO -> Domain Entity -> UI Model
```

## 缓存

必须定义：

- freshness。
- 过期策略。
- 手动刷新策略。
- cache-first / network-first / stale-while-revalidate。
- 冲突处理。
- 清理策略。

禁止：

- 页面自己维护长期缓存。
- 多个页面各自缓存同一份共享数据。
- 没有失效策略的全局字典。

## 存储

边界：

- Keychain：token、密钥、敏感凭据。
- UserDefaults：轻量偏好和非敏感设置。
- Database：业务数据、离线数据、可查询数据。
- FileStore：文件、媒体、大对象。
- Memory/Disk Cache：可重新获取的派生数据。

规则：

- 敏感数据不进 UserDefaults。
- 数据迁移必须可验证。
- 页面不直接读写旧存储。
- 存储错误要有恢复策略。

## 鉴权和会话

Session 层负责：

- 当前登录态。
- 当前用户。
- token 状态。
- 登录过期事件。
- logout 清理。
- 账号切换。

登录成功：

```text
API success
-> save token securely
-> update SessionStore
-> repositories observe or refresh
-> UI passively updates
```

## 错误处理

统一映射：

- 网络不可用。
- 超时。
- 服务器错误。
- 登录失效。
- 权限不足。
- 数据解析失败。
- 缓存不可用。

UI 展示：

- 可恢复错误给 Retry。
- 不可恢复错误给明确说明。
- 表单错误定位到字段。
- 全局错误谨慎使用 Toast，避免刷屏。
