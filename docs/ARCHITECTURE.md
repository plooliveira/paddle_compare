# Architecture

MVC + Repository, organized in layers. Riverpod (generated) wires the layers together; go_router owns navigation.

## Folder structure

```
lib/
├── main.dart                  # ProviderScope + runApp
├── app/                       # App layer
│   ├── app.dart               # MaterialApp.router
│   ├── router.dart            # All routes (routerProvider)
│   └── <feature>/             # One folder per feature ("flow")
│       ├── <feature>_view.dart
│       ├── <feature>_controller.dart
│       └── widgets/           # Widgets used only by this feature
├── data/                      # Data layer (Model)
│   ├── api/                   # Services: talk to the outside world
│   ├── models/                # Immutable domain models + JSON parsing
│   └── repositories/          # Single entry point for data, used by controllers
├── core/                      # Shared, feature-agnostic code
│   ├── widgets/               # Common widgets (buttons, inputs, empty/error states)
│   ├── theme/
│   └── utils/
└── config/                    # App configuration (e.g. simulated latency, failure rate)
```

Feature packages (separate Dart packages for complex features) are out of scope for this app.

## Layers

| Layer | MVC role | Responsibility |
|---|---|---|
| `app/<feature>/*_view.dart` | View | Renders state and forwards user intent to the controller. No business logic. |
| `app/<feature>/*_controller.dart` | Controller | Riverpod `@riverpod` notifier/provider. Holds feature state, calls repositories, exposes `AsyncValue`. |
| `data/repositories` | Model | Exposes domain models to controllers. Hides where the data comes from. |
| `data/api` | Model | Raw I/O. Here: loads `paddles.json` with simulated 300–800 ms latency and random failures. |
| `data/models` | Model | Immutable models. Parsing is tolerant: bad or missing fields become `null` or are normalized (e.g. weight units), never crash. |

No reactive cache in the data layer for now: repositories fetch on demand, and Riverpod providers handle caching and invalidation.

## Dependency rules

```
app  →  data  →  core
 └──────────────→ core
config can be read by any layer
```

- Views only talk to controllers. They never call repositories or services directly.
- Controllers depend on repositories, never on `data/api`.
- `data` never imports `app`. `core` never imports `app` or `data`.
- A widget used by two or more features moves from `app/<feature>/widgets/` to `core/widgets/`.

## Riverpod

- Use code generation (`@riverpod` / `@Riverpod(keepAlive: true)`) for every provider.
- Services and repositories are exposed as providers in their own files (`paddleRepositoryProvider`), so tests can override them.
- Controllers are scoped to their feature. Shared state across screens (e.g. the compare selection) lives in the controller of the feature that owns it and is read by others.
- Watch the narrowest thing you need (`select`) to avoid unnecessary rebuilds.

## Routing

- All routes live in `app/router.dart`.
- The URL is the source of truth for anything shareable: paddle id on the detail route, paddle ids on the compare route. Controllers read their parameters from the route, so web refresh and deep links restore the same screen.

## Naming

- Files in `snake_case`, one public widget or class per file.
- Feature files are prefixed with the feature name: `catalog_view.dart`, `catalog_controller.dart`.

## Tests

`test/` mirrors `lib/`. Priority: models (parsing of dirty data), repositories, and controllers, using provider overrides with fake repositories. Then widget tests for key views.
