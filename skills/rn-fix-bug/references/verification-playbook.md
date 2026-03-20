# Verification Playbook

Use this after editing.

## Minimum close-out

Verify:

- the original reproduction path
- the exact symptom no longer occurs
- nearby regression paths
- affected platform or platforms

## Good regression targets

- the same screen with a different data shape
- the same flow after app background or foreground
- adjacent list items or adjacent navigation states
- Android and iOS parity if the bug touches shared logic or bridge code

## If validation is incomplete

Say explicitly:

- what was not run
- why it was not run
- what risk remains
