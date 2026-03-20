# Performance Checklist

Use this for feed, list, playback, animation, scroll, and rendering issues.

## Ask these questions first

- Who owns scroll?
- Who decides the current item?
- Who decides preload timing?
- Who binds and unbinds players?
- Who decides first-frame readiness?
- Is JS involved in the visual hot path?
- Is host size being confused with actual video viewport size?

## Hot-path rules

- Keep scroll kernels native.
- Keep playback kernels native.
- Keep first-frame critical timing native.
- Keep classic bridge out of frame-by-frame sync.
- Keep RN overlay rendering lightweight and bounded to a small window.

## Common causes of poor feed quality

- JS participates in current-item detection
- JS participates in bind and preload timing
- overlay rerenders in the scroll hot path
- unstable list keys
- too many mounted overlay pages
- host container stretched while content viewport logic stays unchanged

## Layout checks

- verify host size
- verify native root container size
- verify actual video viewport size
- verify render mode or content mode
- verify whether the issue is container sizing or content scaling

## Recommended output when reporting

- symptom
- owning layer
- timing chain
- evidence
- minimal fix
- verification scope
