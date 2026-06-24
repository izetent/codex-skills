# 原生 iOS 能力封装与业务调用边界

## 目录

- 适用范围
- 核心原则
- 分层落点
- 业务调用形态
- 常见能力边界
- 目录建议
- 错误写法与正确写法
- Review 强制检查

## 适用范围

用于原生 iOS 中所有“基础能力、平台能力、第三方能力、跨页面能力”的封装设计。包括但不限于网络请求、埋点、权限、定位、支付、分享、推送、深链、WebView、播放器、缓存、存储、日志、配置和第三方 SDK。

本文件表达的是通用思维：**业务代码只调用语义化能力，不能直接触碰底层实现细节。**

## 核心原则

- 业务层调用“做什么”，基础设施层处理“怎么做”。
- 业务代码保持干净简洁，但不靠过度设计、兜底 fallback、延时或强刷掩盖状态和并发问题。
- 页面、Section、Row、Component 不知道 URL、SDK、数据库、Keychain、系统 API 细节。
- ViewModel 可以调用 UseCase、Repository protocol、AnalyticsTracking、PermissionRequesting 等语义化接口，但不直接调用底层 client 或第三方 SDK。
- Core 提供无业务基础能力，Data 提供业务数据实现，Domain 提供业务协议和规则，Feature 只做页面状态和用户意图编排。
- 第三方 SDK 只能在 adapter / provider 层直接 import。
- 业务代码中出现 `post(...)`、`request(...)`、`ThirdPartySDK.xxx(...)`、`UserDefaults.standard`、`Keychain`、`CLLocationManager` 等底层细节时，默认先判定为层级错误。
- 例外必须有明确理由，例如极小工具 App、系统示例、临时代码；并说明影响范围和移除条件。

## 分层落点

```text
Feature
  Screen / ViewController / Section / Row
  ViewModel
  ViewState / ViewAction / ViewEvent

Domain
  UseCase
  Repository protocol
  业务 Entity / 业务错误

Data
  Remote API
  LocalDataSource
  DTO
  Mapper
  Repository implementation

Core
  Network
  Analytics
  Permission
  Storage
  Keychain
  Logger
  Configuration
  SDK Adapter
```

依赖方向：

```text
Feature -> Domain protocol / Core protocol
Domain -> 不依赖 Feature、Data、第三方 SDK
Data -> Domain + Core
Core -> 不依赖 Feature 业务
```

## 业务调用形态

业务侧应该出现：

```swift
send(.saveTapped)
analytics.track(.profileSaved(source: .settings))
try await updateProfile.execute(input)
try await favoriteRepository.toggleFavorite(id)
permissionRequester.request(.photoLibrary)
router.open(.exerciseDetail(id))
```

业务侧不应该出现：

```swift
post("/user/profile", params)
URLSession.shared.data(from: url)
ThirdPartyAnalytics.track("xxx", params)
UserDefaults.standard.set(value, forKey: key)
Keychain.set(token)
CLLocationManager().requestWhenInUseAuthorization()
UIApplication.shared.open(url)
```

判断标准：

- 方法名是否表达业务语义，而不是技术动作。
- 调用方是否知道底层路径、SDK 名、存储 key、系统类型。
- 替换第三方 SDK 或接口路径时，Feature 是否无需修改。
- 是否能在测试中用 fake protocol 替换该能力。
- 是否用最窄责任层解决问题，而不是为单点场景制造大而全的 manager、helper 或 fallback。

## 常见能力边界

| 能力 | 业务层调用 | 封装层 |
| --- | --- | --- |
| 网络请求 | `loadProfile.execute()` / `repository.fetchProfile()` | `Data/Remote` + `Core/Network` |
| 埋点 | `analytics.track(.screenViewed(.profile))` | `Core/Analytics` adapter |
| 权限 | `permissionRequester.request(.camera)` | `Core/Permission` |
| 存储偏好 | `settingsStore.updateTheme(.dark)` | `Runtime` / `Core/Storage` |
| 敏感凭据 | `sessionRepository.saveToken(token)` | `Core/Keychain` |
| 分享 | `sharePresenter.present(.exercise(id))` | `Core/Share` / Coordinator |
| 支付 | `purchaseUseCase.purchase(productID)` | `Core/Purchase` adapter + Domain UseCase |
| 推送 | `pushRegistration.registerIfAllowed()` | `Core/Push` |
| 深链 | `deepLinkHandler.handle(url)` | App / Coordinator |
| WebView JS bridge | `webBridge.send(.close)` | `Core/WebBridge` |
| 播放器 | `playerController.play(item)` | `Core/Media` adapter |
| 日志 | `logger.error("profile_load_failed")` | `Core/Logger` |

## 目录建议

网络：

```text
Core/Network/
  HTTPClient.swift
  APIRequest.swift
  APIError.swift

Data/Remote/User/
  UserAPI.swift
  UserDTO.swift
  UserRequestDTO.swift
```

埋点：

```text
Core/Analytics/
  AnalyticsTracking.swift
  AnalyticsEvent.swift
  AnalyticsPayload.swift
  AnalyticsProvider.swift
  ThirdPartyAnalyticsAdapter.swift
```

权限：

```text
Core/Permission/
  PermissionRequesting.swift
  PermissionType.swift
  PermissionStatus.swift
  SystemPermissionRequester.swift
```

存储：

```text
Core/Storage/
  UserDefaultsStore.swift

Core/Keychain/
  KeychainStore.swift

Data/Local/
  FavoriteLocalDataSource.swift
```

## 错误写法与正确写法

### 1. 页面直接发请求

错误：

```swift
Button("Save") {
    Task {
        try await httpClient.post("/user/profile", body: params)
    }
}
```

正确：

```swift
Button("Save") {
    send(.saveTapped)
}
```

```swift
@MainActor
final class ProfileViewModel: ObservableObject {
    private let updateProfile: UpdateProfileUseCase

    func send(_ action: ProfileViewAction) {
        switch action {
        case .saveTapped:
            saveTask = Task { await save() }
        }
    }
}
```

### 2. ViewModel 拼接口路径

错误：

```swift
try await httpClient.post("/user/profile", body: request)
```

正确：

```swift
try await updateProfile.execute(input)
```

```swift
struct UserAPI {
    func updateProfile(_ request: UserProfileRequestDTO) async throws -> UserProfileDTO {
        try await httpClient.post(APIRequest(path: "/user/profile", body: request))
    }
}
```

接口 path 只在 `Data/Remote`。

### 3. 页面直接调用第三方埋点

错误：

```swift
ThirdPartyAnalytics.track("favorite_click", ["id": exerciseID.rawValue])
```

正确：

```swift
analytics.track(.favoriteTapped(exerciseID: exerciseID, source: .detail))
```

第三方 SDK 调用只在 `ThirdPartyAnalyticsAdapter`。

### 4. 页面直接写本地偏好

错误：

```swift
UserDefaults.standard.set("dark", forKey: "theme")
```

正确：

```swift
runtimeStore.updateThemePreference(.dark)
```

### 5. Feature 直接 import SDK

错误：

```swift
import SomePaymentSDK

final class CheckoutViewModel: ObservableObject {
    func pay() {
        SomePaymentSDK.pay(...)
    }
}
```

正确：

```swift
protocol PurchaseProcessing {
    func purchase(_ productID: ProductID) async throws -> PurchaseResult
}
```

```swift
final class SomePaymentAdapter: PurchaseProcessing {
    func purchase(_ productID: ProductID) async throws -> PurchaseResult {
        try await sdk.purchase(productID.rawValue)
    }
}
```

ViewModel 只依赖 `PurchaseProcessing` 或 UseCase。

## Review 强制检查

实现或评审涉及任何平台能力、基础能力、第三方能力时必须检查：

- Feature 中是否出现 URL、接口 path、HTTP method、header、query。
- Feature 中是否出现第三方 SDK import。
- Feature 中是否直接调用系统 API、数据库、Keychain、UserDefaults。
- ViewModel 方法名是否表达业务语义，而不是 `postUser`、`requestData` 这类技术动作。
- 是否有 protocol 隔离能力，测试能否替换 fake。
- 第三方 SDK 替换时，Feature 是否无需修改。
- 埋点事件名、公共参数、脱敏、隐私同意是否统一收口。
- 权限请求是否有业务上下文，是否统一处理授权状态。
- 本地存储 key 是否集中管理，敏感数据是否进入 Keychain。
- 失败、取消、权限拒绝、SDK 不可用是否有统一错误映射。
