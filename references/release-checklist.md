# Validation And Release Checklist

Use this before closing work or preparing a PR.

## Always verify the changed layer first

- RN changed: verify the affected screen or component path
- Android changed: verify Android build and affected behavior
- iOS changed: verify iOS build and affected behavior
- bridge changed: verify both RN and the affected native platform

## Build and runtime checklist

- lint or typecheck if available
- Android debug build if Android changed
- iOS build if iOS changed
- verify generated code if interface shape changed
- verify runtime path on the affected platform

## Regression checklist

- cross-platform divergence
- navigation lifecycle regressions
- list or playback regressions
- release-only build risk
- signing or dependency fallout

## Final report

State clearly:

- what was changed
- what was validated
- what was not validated
- what residual risk remains
