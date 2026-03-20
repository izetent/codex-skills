# rn-mobile-workflow

`rn-mobile-workflow` 是一个面向 React Native 移动端项目的 Codex skill，适用于同时包含 Android 和 iOS 原生代码的仓库。

这个 skill 不是泛泛讲 RN 知识，而是为了真实项目开发场景设计，帮助 Codex：

- 区分 RN、bridge、Android、iOS 的职责边界
- 排查跨端行为不一致问题
- 分析原生桥接问题
- 分析 feed、播放、滚动、渲染性能问题
- 排查 Gradle、Pods、原生集成、构建失败问题
- 优先做小而准的根因修复

## 适用场景

当任务涉及以下任一内容时，建议使用该 skill：

- React Native 页面或状态流问题
- Android 原生代码
- iOS 原生代码
- Native Module / Native Component
- JSI / Fabric / TurboModule 集成
- 列表、feed、动画、渲染、播放性能
- RN 宿主尺寸和原生渲染尺寸不一致
- 判断问题到底属于 RN 还是 Native

## 仓库结构

```text
SKILL.md
references/
  repo-structure.md
  rn-debug-flow.md
  android-debug-flow.md
  ios-debug-flow.md
  native-bridge-rules.md
  performance-checklist.md
  release-checklist.md
agents/
  openai.yaml
```

## 这个 skill 的重点

- 修改前先定位根因
- 明确职责边界
- 优先最小必要修改
- 不鼓励通过延时、重试、兜底逻辑掩盖问题
- 高频渲染和时序敏感链路尽量留在 Native

## 在 Codex 中安装

### 方式一：从 GitHub 安装

如果你的 Codex 环境支持从 GitHub 安装 skill，可直接安装该仓库：

```text
https://github.com/izetent/rn-mobile-workflow.git
```

### 方式二：手动克隆到本地 skills 目录

```bash
git clone https://github.com/izetent/rn-mobile-workflow.git ~/.codex/skills/rn-mobile-workflow
```

然后重启 Codex。

## 在 Codex 中如何触发

最稳的方式是显式点名：

```text
Use rn-mobile-workflow to debug this React Native bridge issue.
```

也可以这样问：

```text
Use rn-mobile-workflow to analyze why this RN feed stutters on Android but not iOS.

Use rn-mobile-workflow to review this TurboModule change and identify the likely ownership boundary issue.

Use rn-mobile-workflow to determine whether this layout bug belongs to RN, bridge, Android, or iOS.
```

## 语言建议

仓库主内容使用英文，便于公开复用和 GitHub 传播；中文说明放在本文件中，方便中文团队快速理解。
