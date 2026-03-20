# Native Bridge Rules

Use this file when the issue touches Native Modules, Native Components, JSI, Fabric, TurboModules, or any JS-to-native control path.

## Ownership rules

- Use stable `itemId` over `index` for business identity.
- Decide a single source of truth before editing.
- Keep high-frequency visual sync out of the classic bridge.
- Keep timing-sensitive playback and scrolling logic native.
- Keep business overlay UI and low-frequency product state in RN.

## Before editing bridge code

Identify:

- who owns the state
- who is allowed to mutate it
- who emits events
- who consumes commands
- what thread each side assumes
- whether commands can arrive out of order

## Event guidance

- Classic bridge is acceptable for low-frequency events.
- Do not use classic bridge for frame-by-frame position or animation sync.
- If visual sync must track native scroll, use a UI-thread or JSI-backed path.

## Command guidance

- Make commands idempotent where practical.
- Prefer explicit commands like `setData`, `patchItems`, `scrollToItem`, `pauseCurrent`, `resumeCurrent`.
- Avoid exposing low-level item bind and preload commands to JS unless JS truly owns the list kernel.

## Common root causes

- two layers both think they own the same list state
- commands based on stale index values
- event order not matching command order
- JS deciding timing-sensitive transitions after native scroll already moved on
