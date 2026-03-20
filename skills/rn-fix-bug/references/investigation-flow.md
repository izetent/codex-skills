# Investigation Flow

Use this before changing code for a bug.

## Minimum bug definition

Record:

- symptom
- trigger condition
- affected area
- reproducible path
- whether it is deterministic or intermittent

## Evidence-first order

1. existing logs
2. reproducible runtime state
3. call chain or event chain
4. data inputs
5. side effects
6. fallback instrumentation

## Root cause versus symptom

Examples:

- symptom: screen stays loading
- root cause: loading state never resets after native callback failure

- symptom: player size is wrong
- root cause: RN host size and native viewport size are treated as identical

## Stop conditions

Do not edit yet if:

- you cannot explain the trigger path
- you cannot identify the owning layer
- you cannot point to evidence
