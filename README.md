# rn-mobile-workflow

`rn-mobile-workflow` is a Codex skill for React Native mobile projects that also include Android and iOS native code.

It is designed for real project work rather than generic framework explanation. The skill helps Codex:

- separate RN, bridge, Android, and iOS ownership
- debug cross-platform behavior mismatches
- analyze native bridge issues
- investigate playback, feed, scroll, and rendering performance
- review build, Pod, Gradle, and native integration failures
- keep fixes small and rooted in actual causes

## When to use it

Use this skill when a task involves one or more of the following:

- React Native screens or state flow
- Android native code
- iOS native code
- Native Modules or Native Components
- JSI, Fabric, or TurboModule integration
- list, feed, animation, rendering, or playback performance
- layout mismatches between RN host size and native render size
- deciding whether a bug belongs in RN or native

## Repository structure

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

## What the skill emphasizes

- root-cause analysis before edits
- clear ownership boundaries
- minimal, targeted fixes
- avoiding delay-based or fallback-based patches
- keeping high-frequency rendering and timing-sensitive paths native

## Install in Codex

### Option 1: install from GitHub

If your Codex environment supports skill installation from GitHub, install this repository as a skill.

Repository URL:

```text
https://github.com/izetent/rn-mobile-workflow.git
```

### Option 2: clone into the local skills directory

```bash
git clone https://github.com/izetent/rn-mobile-workflow.git ~/.codex/skills/rn-mobile-workflow
```

Then restart Codex.

## How to trigger it

The most reliable way is to name it explicitly:

```text
Use rn-mobile-workflow to debug this React Native bridge issue.
```

Example prompts:

```text
Use rn-mobile-workflow to analyze why this RN feed stutters on Android but not iOS.

Use rn-mobile-workflow to review this TurboModule change and identify the likely ownership boundary issue.

Use rn-mobile-workflow to determine whether this layout bug belongs to RN, bridge, Android, or iOS.
```

## Language

The skill content is written in English to make it easier to reuse in public GitHub workflows and multi-team environments.

For a Chinese overview, see [README.zh-CN.md](./README.zh-CN.md).
