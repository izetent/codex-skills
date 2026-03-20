# Real-Device Logs

Use this when debugging on physical Android or iOS devices.

## Android device logs

### Typical workflow

1. Connect the device by USB.
2. Enable developer options and USB debugging on the device.
3. Confirm the device is visible:

```bash
adb devices
```

4. Stream logs:

```bash
adb logcat
```

### Useful variants

Filter by app process after finding the pid:

```bash
adb shell pidof <your.package.name>
adb logcat --pid=<pid>
```

Filter by tag:

```bash
adb logcat ReactNativeJS:* ReactNative:* chromium:* *:S
```

Save logs to a file:

```bash
adb logcat > android-device.log
```

Clear old logs before repro:

```bash
adb logcat -c
adb logcat
```

### What to capture

- crash stack
- warnings right before failure
- bridge command and event ordering
- layout measurements if the issue is visual
- network or playback state transitions if relevant

## iOS device logs

### Option 1: Xcode Devices and Simulators

1. Connect the iPhone by USB.
2. Open Xcode.
3. Open `Window > Devices and Simulators`.
4. Select the device.
5. Open the device console or view logs while reproducing.

### Option 2: macOS Console app

1. Connect the iPhone.
2. Open the Console app on macOS.
3. Select the connected device in the sidebar.
4. Filter by app process, bundle id, or custom log prefix.

### Option 3: command-line device logs

If your environment includes device tooling, stream logs with the available command-line utility for the connected iPhone. The exact tool may vary by team setup.

## What to log on real devices

- app lifecycle events
- bridge command and callback timing
- native view frame or viewport values
- player state transitions
- request and response identifiers

## Rule

Real-device debugging is most useful when:

- the bug does not reproduce on simulator or emulator
- performance differs from simulator or emulator
- camera, audio, playback, or hardware-backed rendering is involved
