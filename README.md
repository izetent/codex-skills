# rn-mobile-workflow

This repository is a multi-skill Codex repository for React Native mobile development, especially projects that also include Android and iOS native code.

It currently contains two skills:

- `skills/rn-mobile-workflow`
- `skills/rn-native-bridge`
- `skills/rn-fix-bug`
- `skills/rn-add-feature`

## Skills

### `rn-mobile-workflow`

Use for end-to-end React Native mobile work across RN, Android, and iOS.

Focus:

- root-cause-first debugging
- separating RN, bridge, Android, and iOS ownership
- build and integration issues
- feed, playback, scroll, and rendering performance
- deciding whether a bug belongs in RN or native

Path:

```text
skills/rn-mobile-workflow
```

### `rn-native-bridge`

Use for bridge-specific work involving Native Modules, Native Components, TurboModules, Fabric, JSI, event design, command design, viewport sizing, and cross-layer ownership.

Focus:

- bridge API shape
- event and command boundaries
- index versus stable identity
- host size versus native viewport size
- high-frequency visual sync ownership
- bridge lifecycle and thread expectations

Path:

```text
skills/rn-native-bridge
```

### `rn-fix-bug`

Use for React Native mobile bug fixing.

Focus:

- root cause versus symptom
- evidence-first debugging
- temporary logging and narrow instrumentation
- direct minimal fixes when the cause is clear
- option comparison when multiple fixes are valid
- regression-aware verification

Path:

```text
skills/rn-fix-bug
```

### `rn-add-feature`

Use for feature work in React Native mobile projects.

Focus:

- define the feature boundary first
- decide whether it belongs in RN, bridge, Android, or iOS
- keep the implementation incremental
- avoid unnecessary architecture churn
- verify the new path after implementation

Path:

```text
skills/rn-add-feature
```

## Repository structure

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

## Install in Codex

If your Codex environment supports GitHub skill installation by repository path, install the specific skill directory you want.

Repository:

```text
https://github.com/izetent/rn-mobile-workflow.git
```

Skill paths:

```text
skills/rn-mobile-workflow
skills/rn-native-bridge
skills/rn-fix-bug
skills/rn-add-feature
```

If you install manually, clone the repo and copy the skill directory you need into your local Codex skills directory.

Example:

```bash
git clone https://github.com/izetent/rn-mobile-workflow.git /tmp/rn-mobile-workflow
cp -R /tmp/rn-mobile-workflow/skills/rn-mobile-workflow ~/.codex/skills/rn-mobile-workflow
cp -R /tmp/rn-mobile-workflow/skills/rn-native-bridge ~/.codex/skills/rn-native-bridge
cp -R /tmp/rn-mobile-workflow/skills/rn-fix-bug ~/.codex/skills/rn-fix-bug
cp -R /tmp/rn-mobile-workflow/skills/rn-add-feature ~/.codex/skills/rn-add-feature
```

Then restart Codex.

## Trigger examples

```text
Use rn-mobile-workflow to analyze why this RN feed stutters on Android but not iOS.

Use rn-native-bridge to review this TurboModule API design.

Use rn-native-bridge to determine whether this layout mismatch is caused by RN host size, native viewport size, or content render mode.

Use rn-fix-bug to investigate this bug before editing, add temporary logs if needed, and only fix it after the root cause is confirmed.

Use rn-add-feature to implement this new feature with the smallest correct RN or native boundary.
```

## Language

The skills are written in English for broader reuse.  
For a Chinese overview, see [README.zh-CN.md](./README.zh-CN.md).
