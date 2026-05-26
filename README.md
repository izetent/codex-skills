# codex-skills

`codex-skills` 是一个面向移动端和通用工程开发的 Codex 多技能仓库。当前覆盖三类主要开发经验：

- Android 原生：Kotlin、Compose/XML、生命周期、状态归属、模块治理、架构设计。
- iOS 原生：Swift、SwiftUI/UIKit、并发、生命周期、数据网络存储、工程质量。
- React Native：RN 与原生桥接、Android parity、跨层事件/命令、尺寸同步。

同时仓库提供通用功能开发和缺陷修复规范，用于所有框架下的需求拆解、边界设计、影响面控制、精准修改和验证闭环。

当前仓库包含以下 skill：

- `skills/add-feature`
- `skills/fix-bug`
- `skills/android-dev-standard`
- `skills/android-architecture-bootstrap`
- `skills/ios-dev-standard`
- `skills/rn-native-bridge`
- `skills/rn-android-parity`

## 当前包含的 skill

### `add-feature`

用于任何软件项目的新功能开发或既有功能扩展。

重点包括：

- 先理解需求核心和用户路径
- 检查是否已有相同或相似能力
- 设计清晰边界和影响范围
- 用最小、精准、可验证的实现完成需求
- 避免冗余设计、过度抽象和无关重构
- 验证新路径与相邻旧业务路径

路径：

```text
skills/add-feature
```

### `fix-bug`

用于任何软件项目的缺陷修复。

重点包括：

- 编辑前先复现和收集证据
- 区分根因和表象
- 识别责任层和影响范围
- 根因明确时做最小、精准修复
- 多种可行方案时先比较取舍
- 验证原始复现路径和相邻回归路径

路径：

```text
skills/fix-bug
```

### `android-dev-standard`

用于 Android 原生 Kotlin 项目的功能开发、缺陷修复、页面拆分、状态治理、Compose/XML UI、测试验证和代码审查。

重点包括：

- 生命周期和进程重建
- 状态归属和一次性事件
- Compose / XML 页面实现
- 模块边界和共享能力
- 网络、存储、权限和系统限制
- 编译、测试和回归验证

路径：

```text
skills/android-dev-standard
```

### `android-architecture-bootstrap`

用于 Android 架构设计、模块治理、build logic、依赖治理、启动链路、能力矩阵和长期架构收口。

重点包括：

- 最小可执行架构
- app / core / feature 边界
- 启动与初始化归属
- 构建治理和依赖约束
- 测试基础设施和性能基线

路径：

```text
skills/android-architecture-bootstrap
```

### `ios-dev-standard`

用于 iOS 原生项目的功能开发、缺陷修复、工程搭建、界面适配、并发和代码审查。

重点包括：

- Swift / SwiftUI / UIKit 基础规则
- 架构、状态和导航归属
- 并发、生命周期和性能
- 数据、网络和存储
- 多设备适配、可访问性和质量交付

路径：

```text
skills/ios-dev-standard
```

### `rn-native-bridge`

用于 React Native 与原生层桥接专项问题，重点处理 Native Module、Native Component、TurboModule、Fabric、JSI、事件设计、命令设计、尺寸同步、跨层 ownership 等问题。

重点包括：

- bridge API 设计
- 事件和命令边界
- index 与稳定 itemId 的边界
- RN host size 与 native viewport size 的拆分
- 高频视觉同步的归属
- bridge 生命周期和线程模型

路径：

```text
skills/rn-native-bridge
```

### `rn-android-parity`

用于将 React Native 页面或组件严格迁移、还原或修复到 Android 原生实现，强调 1:1 对照、最小修改和运行时适配。

重点包括：

- RN 与 Android 原生实现对照
- 样式、布局、缩放和安全区还原
- 列表、播放、滚动和交互一致性
- 禁止硬编码和无依据重写
- 原路径与邻近路径验证

路径：

```text
skills/rn-android-parity
```

## 仓库结构

```text
skills/
  add-feature/
    SKILL.md
    references/
    agents/
  fix-bug/
    SKILL.md
    references/
    agents/
  android-dev-standard/
    SKILL.md
    references/
  android-architecture-bootstrap/
    SKILL.md
  ios-dev-standard/
    SKILL.md
    references/
    workflows/
  rn-native-bridge/
    SKILL.md
    references/
    agents/
  rn-android-parity/
    SKILL.md
README.md
```

## 如何在 Codex 中安装

如果你的 Codex 环境支持按 GitHub 仓库路径安装 skill，可以安装对应的子目录。

仓库地址：

```text
https://github.com/izetent/codex-skills.git
```

skill 路径：

```text
skills/add-feature
skills/fix-bug
skills/android-dev-standard
skills/android-architecture-bootstrap
skills/ios-dev-standard
skills/rn-native-bridge
skills/rn-android-parity
```

如果你使用手动安装，可以先克隆仓库，再把需要的 skill 目录拷贝到本地 skills 目录。

示例：

```bash
git clone https://github.com/izetent/codex-skills.git /tmp/codex-skills
cp -R /tmp/codex-skills/skills/fix-bug ~/.codex/skills/fix-bug
cp -R /tmp/codex-skills/skills/add-feature ~/.codex/skills/add-feature
cp -R /tmp/codex-skills/skills/android-dev-standard ~/.codex/skills/android-dev-standard
cp -R /tmp/codex-skills/skills/android-architecture-bootstrap ~/.codex/skills/android-architecture-bootstrap
cp -R /tmp/codex-skills/skills/ios-dev-standard ~/.codex/skills/ios-dev-standard
cp -R /tmp/codex-skills/skills/rn-native-bridge ~/.codex/skills/rn-native-bridge
cp -R /tmp/codex-skills/skills/rn-android-parity ~/.codex/skills/rn-android-parity
```

然后重启 Codex。

## 触发示例

```text
使用 fix-bug 修复这个缺陷。编辑前先复现并收集证据，确认根因后再做最小修复。

使用 add-feature 实现这个新功能。先拆分需求、检查既有能力、设计边界和影响范围。

使用 android-dev-standard 修复这个 Compose 页面状态重复消费问题。

使用 ios-dev-standard 评审这个 SwiftUI 页面状态和并发实现。

使用 rn-native-bridge 评审这个 TurboModule API 设计。

使用 rn-native-bridge 判断这个布局不一致是 RN host size、native viewport size 还是内容渲染模式导致的。
```

## 语言说明

当前通用 skill 主体使用中文，便于中文团队稳定执行规范。技术标识、命令、文件路径和框架名保留原文。
