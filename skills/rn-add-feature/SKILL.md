---
name: rn-add-feature
description: Use for adding a feature to a React Native mobile project. Clarify the feature boundary first, decide whether the work belongs in RN, bridge, Android, or iOS, keep the implementation incremental, avoid broad architectural churn, and verify the new path and nearby impact after implementation.
---

# RN Add Feature

Use this skill when the main task is to add or extend functionality in a React Native mobile project.

## Core rules

- Clarify the feature scope before editing.
- Decide which layer should own the feature:
  - RN
  - bridge
  - Android native
  - iOS native
- Prefer the smallest incremental implementation.
- Avoid broad refactors unless the feature genuinely requires them.
- Verify the new path after implementation.

## First pass

1. Define the feature:
   - goal
   - user path
   - affected screens or modules
   - affected platform or platforms

2. Read only the relevant reference:
   - feature planning: `references/feature-planning.md`
   - implementation boundaries: `references/layer-boundaries.md`
   - validation checklist: `references/feature-validation.md`

3. Before editing, state:
   - where the feature belongs
   - why that layer is appropriate
   - what the minimum implementation scope is

## Editing rules

- Reuse existing patterns if they are already established in the repo.
- Add the smallest necessary API surface.
- Keep feature state ownership explicit.
- Avoid speculative abstractions.

## Final verification

Always report:

- what was added
- why the chosen layer is correct
- what was verified
- what remains unverified
