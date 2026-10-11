# Paddle Compare

Flutter take-home: browse, inspect and compare pickleball paddles. Riverpod (generated) + go_router.

## Architecture

Before planning or building any feature, check the architecture doc and follow its folder placement, layer and dependency rules. If a feature needs to break a rule, call it out in the plan instead of silently deviating.

@docs/ARCHITECTURE.md

## Commands

```bash
dart run build_runner build   # after changing any @riverpod provider
flutter analyze
flutter test
```
