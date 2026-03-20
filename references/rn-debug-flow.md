# RN Debug Flow

Use this for JS, TS, React, layout, gesture, and low-frequency UI issues.

## Diagnose before editing

- Confirm the exact reproduction path.
- Confirm whether the bug is visual only, state only, or both.
- Identify the source of truth for the broken state.
- Check whether the issue appears on both Android and iOS.

## Inspect in this order

1. Props and state ownership
2. Async races and stale closures
3. Screen lifecycle and navigation lifecycle
4. List virtualization and item identity
5. Gesture ownership
6. Rerender triggers
7. JS-to-native command timing

## Common root causes

- duplicate state copies
- stale closure in async handler
- index used where stable item id is required
- overlay state tied to rerender timing instead of source-of-truth state
- list item reuse with unstable keys
- expensive rerenders in scroll path

## Avoid

- broad `useEffect` syncing just to keep state aligned
- force remounting to hide lifecycle bugs
- adding delays to hide timing issues
- adding defensive copies of the same state in multiple layers
