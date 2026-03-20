# iOS Debug Flow

Use this for iOS-only native issues, Pod failures, runtime crashes, frame mismatches, and rendering bugs.

## Diagnose before editing

- Separate build failure, runtime crash, and rendering mismatch.
- Confirm whether the issue reproduces on simulator, device, or both.
- Confirm whether the issue is root view sizing, child frame sizing, or content render mode.

## Inspect in this order

1. Xcode build error
2. Pod integration and versions
3. runtime stack trace or device log
4. root view frame and subview frame assignment
5. main-thread UI assumptions
6. host layout versus actual video viewport
7. simulator-only versus device-only divergence

## Files that often matter

- `ios/Podfile`
- `*.podspec`
- native view or view controller wrappers
- Objective-C or Swift bridge files

## Common root causes

- Pod version conflict
- stale Pods or generated headers
- frame assignment happening at the wrong lifecycle point
- host view and content viewport being treated as identical
- incorrect reuse or lifecycle handling for native views

## Avoid

- guessing at Pod issues without reading the actual install or build failure
- using fallback frames to hide ownership bugs
- treating a native cell object as a stable root container unless the framework explicitly supports it
