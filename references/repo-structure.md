# Repository Discovery

Use this file at the start of work when the repo layout is not already known.

## What to identify first

- JS package manager: `yarn`, `npm`, `pnpm`, or `bun`
- RN app entrypoints
- shared packages or monorepo structure
- Android app and native module locations
- iOS app, Pod, and native module locations
- generated code locations
- test and lint entrypoints
- build and release scripts

## Fast discovery commands

Use fast reads before opening many files:

```bash
rg --files .
rg -n "\"react-native\"|expo|workspaces|turbo|lerna|nx" package.json .
rg -n "include\\(|project\\(" android/settings.gradle android/settings.gradle.kts
rg -n "pod|target|use_frameworks!" ios/Podfile ios/**/*.podspec
rg -n "TurboModule|Fabric|codegen|NativeModules|requireNativeComponent" .
```

## Files that usually matter

- `package.json`
- `metro.config.*`
- `babel.config.*`
- `android/settings.gradle*`
- `android/build.gradle*`
- `android/app/build.gradle*`
- `ios/Podfile`
- `ios/*/*.xcodeproj`
- `react-native.config.js`

## Output you want before changing code

Write down:

- where RN UI code lives
- where Android native code lives
- where iOS native code lives
- how the app runs locally
- how tests or lint checks run
- whether the repo uses the new architecture, JSI, or Fabric
