# rn-mobile-workflow

这是一个面向 React Native 移动端开发的 Codex 多技能仓库，重点覆盖同时包含 Android 和 iOS 原生代码的项目。

当前仓库包含两个 skill：

- `skills/rn-mobile-workflow`
- `skills/rn-native-bridge`
- `skills/rn-fix-bug`
- `skills/rn-add-feature`

## 当前包含的 skill

### `rn-mobile-workflow`

用于 React Native、Android、iOS 混合项目的整体开发流程。

重点包括：

- 先定位根因再修改
- 区分 RN、bridge、Android、iOS 的职责边界
- 构建与集成问题排查
- feed、播放、滚动、渲染性能问题
- 判断问题究竟属于 RN 还是 Native

路径：

```text
skills/rn-mobile-workflow
```

### `rn-native-bridge`

用于桥接专项问题，重点处理 Native Module、Native Component、TurboModule、Fabric、JSI、事件设计、命令设计、尺寸同步、跨层 ownership 等问题。

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

### `rn-fix-bug`

用于 React Native 移动端 bug 修复。

重点包括：

- 区分根因和表现
- 证据优先排查
- 临时日志和窄范围埋点
- 根因明确时直接最小修改
- 多种可行方案时先比较再改
- 回归风险验证

路径：

```text
skills/rn-fix-bug
```

### `rn-add-feature`

用于 React Native 移动端新增功能。

重点包括：

- 先明确功能边界
- 先判断归属 RN、bridge、Android 还是 iOS
- 优先做增量实现
- 避免为了一个小功能做大重构
- 修改后验证新增路径

路径：

```text
skills/rn-add-feature
```

## 仓库结构

```text
skills/
  rn-mobile-workflow/
    SKILL.md
    references/
    agents/
  rn-native-bridge/
    SKILL.md
    references/
    agents/
  rn-fix-bug/
    SKILL.md
    references/
    agents/
  rn-add-feature/
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
https://github.com/izetent/rn-mobile-workflow.git
```

skill 路径：

```text
skills/rn-mobile-workflow
skills/rn-native-bridge
skills/rn-fix-bug
skills/rn-add-feature
```

如果你使用手动安装，可以先克隆仓库，再把需要的 skill 目录拷贝到本地 skills 目录。

示例：

```bash
git clone https://github.com/izetent/rn-mobile-workflow.git /tmp/rn-mobile-workflow
cp -R /tmp/rn-mobile-workflow/skills/rn-mobile-workflow ~/.codex/skills/rn-mobile-workflow
cp -R /tmp/rn-mobile-workflow/skills/rn-native-bridge ~/.codex/skills/rn-native-bridge
cp -R /tmp/rn-mobile-workflow/skills/rn-fix-bug ~/.codex/skills/rn-fix-bug
cp -R /tmp/rn-mobile-workflow/skills/rn-add-feature ~/.codex/skills/rn-add-feature
```

然后重启 Codex。

## 触发示例

```text
Use rn-mobile-workflow to analyze why this RN feed stutters on Android but not iOS.

Use rn-native-bridge to review this TurboModule API design.

Use rn-native-bridge to determine whether this layout mismatch is caused by RN host size, native viewport size, or content render mode.

Use rn-fix-bug to investigate this bug before editing, add temporary logs if needed, and only fix it after the root cause is confirmed.

Use rn-add-feature to implement this new feature with the smallest correct RN or native boundary.
```

## 语言说明

skill 主体内容使用英文，便于公开复用；中文说明放在本文件中，方便中文团队快速理解。
