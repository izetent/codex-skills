# Android Debug Flow

Use this for Android-only native issues, Gradle failures, layout mismatches, rendering bugs, and performance problems.

## Diagnose before editing

- Separate build-time failure from runtime failure.
- Confirm whether the bug is Android-only or only easier to reproduce on Android.
- Confirm whether the issue is in RN host layout, native container layout, or player rendering.

## Inspect in this order

1. Gradle error or logcat error
2. ABI, dependency, or packaging mismatch
3. activity, fragment, and view lifecycle
4. host view measurement and layout
5. native container versus actual render viewport
6. thread assumptions
7. debug-only versus release-only behavior

## Commands worth running

```bash
cd android && ./gradlew tasks
cd android && ./gradlew assembleDebug
adb logcat
```

## Common root causes

- Gradle plugin or Kotlin mismatch
- stale generated code
- wrong view measurement assumptions
- RN host size driving the wrong native child size
- TextureView or SurfaceView container mismatch
- lifecycle callback not aligned with RN screen lifecycle

## Avoid

- patching release failures without reading the real Gradle task failure
- treating host size and video viewport as the same thing
- moving timing-sensitive playback decisions into JS
