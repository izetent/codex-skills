# codex-skills

`codex-skills` 是一个面向工程开发的 Codex 多技能仓库。当前重点覆盖通用功能开发、通用缺陷修复，以及 React Native 与原生层桥接专项问题。

当前仓库包含三个核心 skill：

- `skills/add-feature`
- `skills/fix-bug`
- `skills/rn-native-bridge`

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
  rn-native-bridge/
    SKILL.md
    references/
    agents/
README.md
README.zh-CN.md
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
skills/rn-native-bridge
```

如果你使用手动安装，可以先克隆仓库，再把需要的 skill 目录拷贝到本地 skills 目录。

示例：

```bash
git clone https://github.com/izetent/codex-skills.git /tmp/codex-skills
cp -R /tmp/codex-skills/skills/fix-bug ~/.codex/skills/fix-bug
cp -R /tmp/codex-skills/skills/add-feature ~/.codex/skills/add-feature
cp -R /tmp/codex-skills/skills/rn-native-bridge ~/.codex/skills/rn-native-bridge
```

然后重启 Codex。

## 触发示例

```text
使用 fix-bug 修复这个缺陷。编辑前先复现并收集证据，确认根因后再做最小修复。

使用 add-feature 实现这个新功能。先拆分需求、检查既有能力、设计边界和影响范围。

使用 rn-native-bridge 评审这个 TurboModule API 设计。

使用 rn-native-bridge 判断这个布局不一致是 RN host size、native viewport size 还是内容渲染模式导致的。
```

## 语言说明

当前通用 skill 主体使用中文，便于中文团队稳定执行规范。技术标识、命令、文件路径和框架名保留原文。
