# Paddle Compare

A Flutter app to browse pickleball paddles, view their specs, and compare up to three side by side. Runs on web (phone and desktop sizes), iOS, and Android.

**Stack:** Flutter 3.47 (stable) · Riverpod 3 with code generation · go_router 18

## How to run

```bash
flutter pub get
dart run build_runner build   # generates Riverpod providers
flutter run --release -d chrome   # or an iOS/Android device
```

## How to test

```bash
flutter test
```

## Notes

Architecture, key decisions and trade-offs, how I used AI, and what I would do with another day are in [NOTES.md](NOTES.md).
