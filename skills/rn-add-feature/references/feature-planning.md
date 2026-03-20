# Feature Planning

Use this before adding code.

## Define first

- what the feature does
- who uses it
- where it starts
- where it ends
- what existing modules it touches

## Decide the narrowest implementation path

- RN-only if the feature is product UI or business flow
- bridge if RN must control a native capability
- native if the feature is timing-sensitive, rendering-heavy, or platform-specific

## Avoid

- architecture changes before feature boundaries are clear
- adding a generic system for a one-off requirement
