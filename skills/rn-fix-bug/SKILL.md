---
name: rn-fix-bug
description: Use for React Native mobile bug fixes. Investigate before editing, collect evidence, use logs or add temporary logs when needed, distinguish root cause from symptom, propose options when multiple viable fixes exist, apply direct minimal fixes only when the cause is clear, and always verify the final fix and nearby regressions.
---

# RN Fix Bug

Use this skill when the task is to fix a bug in a React Native, Android, iOS, or bridge-related code path.

## Core rules

- Do not edit code before describing the symptom, trigger path, affected scope, and reproduction path.
- Distinguish root cause from surface behavior.
- If evidence is missing, investigate first.
- If logs are missing, add temporary logs or tracing at the narrowest useful points.
- If multiple viable fixes exist after root-cause analysis, present the options before editing.
- If a single clear cause is identified and the fix is straightforward, make the minimal direct fix.
- After any fix, verify the original bug and nearby regression paths.

## Investigation sequence

1. Define the bug:
   - symptom
   - trigger condition
   - affected platform or layer
   - reproduction path

2. Identify the likely evidence sources:
   - existing logs
   - runtime state transitions
   - call chain
   - network data
   - local storage or cache state
   - native lifecycle events

3. Read only the relevant reference:
   - general investigation flow: `references/investigation-flow.md`
   - logging rules and temporary instrumentation: `references/logging-playbook.md`
   - real-device log collection: `references/real-device-logs.md`
   - fix selection rules: `references/fix-selection.md`
   - validation and regression checks: `references/verification-playbook.md`

4. Before editing, state:
   - current root-cause hypothesis
   - evidence that supports it
   - whether more evidence is still needed

## Editing rules

- Prefer removal of incorrect logic over adding fallback branches.
- Prefer fixing the actual source-of-truth or timing bug over hiding it.
- Avoid retries, delays, force refreshes, and duplicated state unless the root cause truly requires them.
- Remove temporary logging if it is no longer needed after verification, unless keeping it has clear diagnostic value.

## Decision rules

- If there is one clear cause and one clear minimal fix, apply it directly.
- If there are multiple valid fixes with meaningful tradeoffs, present the options first.
- If the cause is still unclear, do not guess. Add evidence collection instead.

## Final verification

Always report:

- what caused the bug
- what evidence confirmed it
- what changed
- how the fix was verified
- what remains unverified
