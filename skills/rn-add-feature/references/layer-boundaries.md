# Layer Boundaries

Use this when deciding whether the feature should live in RN or native.

## RN should usually own

- business UI
- page composition
- product logic
- low-frequency state

## Native should usually own

- hardware-backed features
- high-frequency rendering
- playback kernels
- scroll kernels
- timing-sensitive visual control

## Bridge should only expose what RN actually needs

- explicit commands
- explicit events
- stable identity fields

Avoid exposing native internal timing details unless absolutely necessary.
