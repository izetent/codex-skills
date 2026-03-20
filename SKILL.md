---
name: rn-mobile-workflow
description: Use for React Native mobile app work that also involves Android and iOS native code, especially when debugging cross-platform behavior mismatches, native bridge issues, build failures, JSI or Fabric integration, list or playback performance, layout or viewport mismatches, or deciding whether a change belongs in RN or native. Prioritize root-cause analysis before edits, keep changes minimal, and separate RN, bridge, Android, and iOS ownership clearly.
---

# RN Mobile Workflow

Use this skill when working in a React Native repository that includes Android and iOS native code.

## Core rules

- Identify the symptom, trigger path, affected platform, and reproduction path before editing.
- Distinguish root cause from surface behavior.
- Prefer the smallest fix that resolves the actual cause.
- Do not hide timing or ownership bugs with retries, delays, force refreshes, or broad fallback logic.
- Separate RN-layer, bridge-layer, Android-layer, and iOS-layer issues before changing code.

## First pass

1. Classify the problem:
   - RN UI or state flow
   - native bridge or native component
   - Android-only native issue
   - iOS-only native issue
   - build, dependency, signing, or toolchain issue
   - scroll, playback, animation, or rendering performance issue

2. Read only the relevant reference file:
   - Repository discovery: `references/repo-structure.md`
   - RN debugging flow: `references/rn-debug-flow.md`
   - Android debugging flow: `references/android-debug-flow.md`
   - iOS debugging flow: `references/ios-debug-flow.md`
   - bridge ownership rules: `references/native-bridge-rules.md`
   - performance and rendering checklist: `references/performance-checklist.md`
   - validation and release checklist: `references/release-checklist.md`

3. Before editing, state:
   - where the bug likely lives
   - why that layer is the likely cause
   - what evidence supports the conclusion

## Ownership boundaries

- RN should own business UI, product flow, and low-frequency state.
- Native should own high-frequency rendering, playback kernels, scroll kernels, and timing-sensitive control.
- Do not move a native timing problem into JS just to avoid native changes.
- Do not move ordinary product rendering into native unless performance requires it.

## Editing guidance

- For RN issues, inspect props, state ownership, async races, list virtualization, and rerender triggers before editing.
- For bridge issues, inspect type shape, serialization, lifecycle ownership, threading assumptions, and source-of-truth boundaries.
- For Android issues, inspect Gradle configuration, logcat, view measurement, lifecycle callbacks, and rendering containers.
- For iOS issues, inspect Xcode build logs, Pods, frame assignment, view hierarchy, and main-thread assumptions.
- For performance issues, inspect who owns:
  - scroll
  - visible item detection
  - preload timing
  - bind and unbind timing
  - first-frame timing
  - host size versus video viewport size

## Validation

Always report:

- what changed
- why it fixes the root cause
- what was verified
- what remains unverified

If build, simulator, device, or release validation was not run, say so explicitly.
