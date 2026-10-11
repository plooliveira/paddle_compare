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
│   ├── api/                   # Services: talk to the outside world, return raw JSON
│   │   ├── <name>_api.dart            # Contract (abstract interface class)
│   │   ├── fake_<name>_api.dart       # Implementation
│   │   ├── <name>_api_exception.dart
│   │   └── <name>_api_provider.dart
│   └── repositories/          # Single entry point for data, used by controllers
│       └── <domain>/          # Self-contained module, one per domain (e.g. paddle/)
│           ├── <domain>_repository.dart               # Contract
│           ├── <domain>_repository_from_<source>.dart # Implementation
│           ├── <domain>_repository_exception.dart
│           ├── <domain>_repository_provider.dart
│           └── models/        # Immutable models + tolerant JSON parsing for this domain
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
| `data/repositories/<domain>` | Model | Exposes domain models to controllers as `Result<T>`. Hides where the data comes from. |
| `data/repositories/<domain>/models` | Model | Immutable models (freezed). Parsing is tolerant: bad or missing fields become `null` or are normalized (e.g. weight units), never crash. |
| `data/api` | Model | Raw I/O. Here: loads `paddles.json` with simulated 300–800 ms latency and random failures. |

No reactive cache in the data layer for now: repositories fetch on demand, and Riverpod providers handle caching and invalidation.

### Repository modules

Each folder under `data/repositories/` is an isolated module: its contract, implementations, provider, models and parsing helpers live together. Everything a repository needs to work is inside its folder, except the services it reads from (`data/api`) and shared utilities (`core`, `config`).

- Models belong to the repository that produces them and are never shared between repositories.
- The contract file (`<domain>_repository.dart`) is the module's public entry point: it exports the models and the repository exception. Code outside the module imports only the contract (and the provider), never `models/` directly. Internal helpers such as `json_readers.dart` are not exported.
- A repository module never imports another repository module. If two repositories need a similar model, each one defines its own.
- The only thing a repository takes from `data/api` is the API contract (`PaddleApi`), never a concrete service (`FakePaddleApi`) or other API types. The concrete one is chosen in the provider. Errors raised by the repository itself use its own exception type.
- Repositories return `Result<T>` (`core/utils/result.dart`, from the [Flutter architecture guide](https://docs.flutter.dev/app-architecture/design-patterns/result)) and never throw. "Not found" is `Result.ok(null)`, not an error.

## Dependency rules

```
app  →  data  →  core
 └──────────────→ core
config can be read by any layer
```

- Views only talk to controllers. They never call repositories or services directly.
- Controllers depend on repository contracts, never on `data/api`.
- Inside `data`: `repositories → api`, never the other way. Repository modules don't import each other.
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
- Contracts are `abstract interface class` named after the role (`PaddleRepository`, `PaddleApi`). Repository implementations are named `<Contract>From<Source>` (`PaddleRepositoryFromFake`).

## Tests

`test/` mirrors `lib/` (e.g. `test/data/repositories/paddle/models/paddle_test.dart`). Priority: models (parsing of dirty data), repositories, and controllers, using provider overrides with fake repositories. Then widget tests for key views.

Test doubles for a contract (stub API, fake repository) live in the test file that uses them. Move one to a shared helper only when a second test file needs it.
