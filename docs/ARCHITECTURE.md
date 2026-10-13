# Architecture

MVC + Repository, organized in layers. Riverpod (generated) wires the layers together; go_router owns navigation.

Material and Cupertino come from the `material_ui` and `cupertino_ui` packages, never from `package:flutter/material.dart` or `cupertino.dart`. go_router 18 only recognizes `material_ui`'s `MaterialApp`. With the framework's copy it falls back to `NoTransitionPage`, which removes every page transition and the iOS swipe-back gesture.

## Folder structure

```
lib/
├── main.dart                  # ProviderScope + runApp
├── app/                       # App layer
│   ├── app.dart               # MaterialApp.router
│   ├── router.dart            # All routes (routerProvider)
│   └── <feature>/             # One folder per feature ("flow")
│       ├── controller/
│       │   ├── <feature>_controller.dart    # Shared by both variants
│       │   └── ...                          # Models the controller works with (e.g. catalog_filter)
│       ├── state/
│       │   └── <feature>_state.dart         # Controller state
│       └── view/
│           ├── <feature>_view.dart          # Entry point used by the router; only picks the variant
│           ├── widgets/                     # Widgets shared by both variants of this feature
│           ├── mobile/
│           │   ├── <feature>_mobile_page.dart
│           │   └── widgets/                 # Widgets used only by the mobile variant
│           └── desktop/
│               ├── <feature>_desktop_page.dart
│               └── widgets/                 # Widgets used only by the desktop variant
├── data/                      # Data layer (Model)
│   ├── api/                   # Services: talk to the outside world, return raw JSON
│   │   ├── <name>_api.dart            # Contract (abstract interface class)
│   │   ├── fake_<name>_api.dart       # Implementation (latency, failures, loads the asset)
│   │   ├── in_memory_<name>_api.dart  # Answers requests from raw JSON in memory, like a server
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
│   ├── widgets/               # Common widgets (AdaptiveView, PaddleHero, empty/error states)
│   ├── theme/                 # AppColors, AppTheme (including page transitions)
│   └── utils/                 # Result, FormFactor, formatUsd
└── config/                    # App configuration (e.g. simulated latency, failure rate)
```

Feature packages (separate Dart packages for complex features) are out of scope for this app.

## Layers

| Layer | MVC role | Responsibility |
|---|---|---|
| `app/<feature>/view/` | View | Renders state and forwards user intent to the controller. No business logic. |
| `app/<feature>/controller/` | Controller | Riverpod `@riverpod` notifier/provider. Holds feature state, calls repositories, exposes `AsyncValue`. |
| `data/repositories/<domain>` | Model | Exposes domain models to controllers as `Result<T>`. Hides where the data comes from. |
| `data/repositories/<domain>/models` | Model | Immutable models (freezed). Parsing is tolerant: bad or missing fields become `null` or are normalized (e.g. weight units), never crash. |
| `data/api` | Model | Raw I/O, shaped like a backend's endpoints. Here: loads `paddles.json` with simulated 300–800 ms latency and random failures, and answers search, filters, sort and pagination over it. |

No reactive cache in the data layer for now: repositories fetch on demand, and Riverpod providers handle caching and invalidation.

### Responsive views

Each screen has a mobile and a desktop variant in its own file. The entry view (`view/<feature>_view.dart`) only picks one with `AdaptiveView`.

- The variant depends on window width, not platform: `FormFactor.of(context)` returns desktop at 840 px and up. The web app on a phone gets the mobile variant, and an iPad in landscape gets the desktop one.
- Variants keep no feature state: they share the feature's controller, and UI-only state (e.g. a search field's text) is seeded from it, so a resize that swaps the layout loses nothing. The swap happens inside each page, so the navigator's page stack is not touched.
- Rules that depend on form factor are applied by views and controllers, never by routes. Example: `CompareLimits`, 2 paddles side by side on mobile and 3 on desktop. The URL is the same at every width: the compare route holds up to `CompareLimits.max` ids, and each layout shows as many as it fits.
- A screen that looks the same on both (e.g. `NotFoundView`) can skip the variants.

### Repository modules

Each folder under `data/repositories/` is an isolated module: its contract, implementations, provider, models and parsing helpers live together. Everything a repository needs to work is inside its folder, except the services it reads from (`data/api`) and shared utilities (`core`, `config`).

- Models belong to the repository that produces them and are never shared between repositories.
- The contract file (`<domain>_repository.dart`) is the module's public entry point: it exports the models and the repository exception. Code outside the module imports only the contract (and the provider), never `models/` directly.
- A repository module never imports another repository module. If two repositories need a similar model, each one defines its own.
- The only thing a repository takes from `data/api` is the API contract (`PaddleApi`), never a concrete service (`FakePaddleApi`) or other API types. The concrete one is chosen in the provider. Errors raised by the repository itself use its own exception type.
- Repositories return `Result<T>` (`core/utils/result.dart`, from the [Flutter architecture guide](https://docs.flutter.dev/app-architecture/design-patterns/result)) and never throw. "Not found" is `Result.ok(null)`, not an error.
- Search, filters, sort and pagination are the backend's job, never the controller's or the repository's. `PaddleRepository.getPaddles(query:, offset:, limit:)` takes a `PaddleQuery`, and `PaddleRepositoryFromFake` only translates it into `PaddleApi.fetchPaddles` parameters (shape names, `PaddleApi.sort*` values) and parses the page it gets back. The order is stable across pages, so consecutive pages never overlap. It returns `List<Paddle>`, with no total.
- A single paddle has its own endpoint, like `GET /paddles/:id`: `getPaddleById` calls `PaddleApi.fetchPaddle(id)` and never loads the catalog. The API answers `null` for an unknown id (a 404), and the repository turns that, or an entry it can't parse, into `Result.ok(null)`.
- `PaddleApi` takes primitive parameters, like an HTTP client would send, because `data/api` can't import a repository's models. `FakePaddleApi` simulates the network and loads the asset, then hands the request to `InMemoryPaddleApi`, which stands in for the server: it keeps the entries that make a paddle (the first one per id), filters, sorts and slices them on the raw JSON, and sends the entries back as stored.
- The server and the app must agree on what each field means, or a paddle could match a price filter and show no price. `InMemoryPaddleApi` follows the parsing rules of `Paddle.tryFromJson` with the same readers (`core/utils/json_readers.dart`): ids are trimmed, shapes are compared as tokens ("Wide-Body" is `widebody`), prices must be positive and ratings 0–10. A change to a parsing rule the query depends on has to be made in both.

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
- A widget used by two or more features moves from `app/<feature>/view/widgets/` to `core/widgets/`.

## Riverpod

- Use code generation (`@riverpod` / `@Riverpod(keepAlive: true)`) for every provider.
- Services and repositories are exposed as providers in their own files (`paddleRepositoryProvider`), so tests can override them.
- Controllers are scoped to their feature. Shared state across screens (e.g. the compare selection) lives in the controller of the feature that owns it and is read by others.
- Watch the narrowest thing you need (`select`) to avoid unnecessary rebuilds.
- A route parameter reaches controllers through a scoped provider that the feature's entry view overrides for its subtree. The controller lists it in `dependencies`, which scopes the controller to the same subtree. Example: `catalogFilterProvider` (the filter in the catalog URL), overridden by `CatalogView`. `CatalogController` watches `catalogFilterProvider.select((f) => f.toQuery())`, so a new URL reloads from the first page, while a change that doesn't alter the query (e.g. extra spaces in the search) doesn't refetch.
- The entry view owns the child `ProviderContainer` and applies a new value after the frame, instead of using `ProviderScope(overrides:)`. `ProviderScope` updates overrides during its build, and a sheet that shares the container from outside the subtree would be marked dirty mid-build, which Flutter rejects.
- Sheets and dialogs are routes outside the entry view's subtree, so they re-expose its scope: `UncontrolledProviderScope(container: ProviderScope.containerOf(context, listen: false), child: ...)`.

## Routing

- All routes live in `app/router.dart` as typed routes (`go_router_builder`). Navigate through the route classes (`PaddleDetailRoute(id: id).push(context)`), never with path strings.
- Route tree: plain `GoRoute`s, no shell route. `/` (catalog) is the root, with `paddles/:id` (detail) and `compare?ids=a&ids=b` (compare) nested under it. go_router builds the page stack from the matched path, so a deep link always has the catalog underneath to go back to.
- Use `push` to move forward, `pop` to go back, and `go` only to reset the stack (e.g. not found → catalog). The back stack, and with it the iOS swipe-back gesture, follows the path the user actually took. `GoRouter.optionURLReflectsImperativeAPIs` is on, so the web URL always shows the visible page. go_router discourages this flag only because a pushed route may not be deep-linkable, and every route here is.
- Routes only override `build`, so go_router wraps them in a `MaterialPage` and the transition comes from `AppTheme`'s `PageTransitionsTheme`. On native that is the platform default: Cupertino with swipe-back on iOS and macOS, predictive back on Android. On web every platform fades, because the browser owns the back gesture. Don't use `CustomTransitionPage` or `fullscreenDialog` for pages: both drop the swipe-back gesture.
- Heroes shared between screens use `PaddleHero` (`transitionOnUserGestures: true`), so they follow the finger during swipe-back.
- Web uses the path URL strategy (`/paddles/x`, not `/#/paddles/x`). Hosting must rewrite unknown paths to `index.html`.
- The URL is the source of truth for anything shareable: paddle id on the detail route, paddle ids on the compare route, and the catalog's search, filters and sort. Controllers read their parameters from the route, so web refresh and deep links restore the same screen.
- The catalog's filter lives in the query: `/?q=apex&shape=hybrid&max-price=200&in-stock=true&sort=price-asc`. The route keeps the parameters as raw strings, and `CatalogRoute.filter` parses them tolerantly: unknown values are ignored, invalid prices dropped, prices clamped to the price filter's bounds, and a min above the max swapped. A hand-edited URL never lands on the error page. `CatalogRoute.fromFilter` leaves defaults out, so the default filter is `/`.
- Filter changes go through `CatalogRoute.goInPlace`, which wraps `go` in `Router.neglect`: the URL is replaced without a new history entry, so Back leaves the catalog instead of undoing filters one by one. This is the one use of `go` that doesn't reset the stack. The page key depends on the path, not the query, so the page and an open sheet stay.

## Naming

- Files in `snake_case`, one public widget or class per file.
- Feature files are prefixed with the feature name: `catalog_view.dart`, `catalog_controller.dart`, `catalog_mobile_page.dart`.
- Contracts are `abstract interface class` named after the role (`PaddleRepository`, `PaddleApi`). Repository implementations are named `<Contract>From<Source>` (`PaddleRepositoryFromFake`).

## Tests

`test/` mirrors `lib/` (e.g. `test/data/repositories/paddle/models/paddle_test.dart`). Priority: models (parsing of dirty data), repositories, and controllers, using provider overrides with fake repositories. Then widget tests for key views.

Test doubles for a contract (stub API, fake repository) live in the test file that uses them. Move one to a shared helper only when a second test file needs it.

`test/helpers/fake_paddle_repository.dart` serves its `Paddle`s through the real `PaddleRepositoryFromFake` over an `InMemoryPaddleApi` (it turns them back into JSON), so controller and view tests run queries exactly like the app, with no latency, instead of duplicating the filter logic.
