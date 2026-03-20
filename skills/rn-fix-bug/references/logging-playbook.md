# Logging Playbook

Use this when the existing evidence is not enough.

## Add logs only where they answer a specific question

Examples:

- Did callback `X` fire?
- Which branch chose state `Y`?
- Which item id was bound?
- Which native view size was actually measured?
- Did command `A` arrive before event `B`?

## Good temporary log points

- lifecycle boundaries
- state transitions
- bridge command entry
- bridge event emission
- network response mapping
- host size and viewport size calculations
- player bind and unbind points

## Avoid

- dumping unrelated objects
- broad noisy logs across the whole app
- logging secrets, tokens, or private user data
- leaving large-volume temporary logs in hot paths after the bug is verified

## Temporary instrumentation rule

If you add temporary logs:

- keep them narrow
- name them clearly
- remove or reduce them after verification unless they remain useful diagnostics
