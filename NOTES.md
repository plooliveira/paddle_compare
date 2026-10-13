# Paddle Compare: notes

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

Most of the tests cover the state and logic layer: parsing of dirty data, the fake API and the repository, the controllers, and the URL parsing in the router. Widget tests then cover the key screens, mobile and desktop, by pumping the whole app and tapping through it. Controller and widget tests use the real repository over an in-memory API, so queries run exactly like in the app, with no latency.

## Architecture

MVC + Repository, in layers. Riverpod (with code generation) wires the layers together, and go_router owns navigation.

```
View  →  Controller  →  PaddleRepository  →  PaddleApi
         AsyncValue     Result<T>            raw JSON
```


### Folder structure

```
lib/
├── main.dart                # ProviderScope + runApp, path URL strategy
├── app/                     # App layer: features (views + controllers) and routes
│   ├── <feature>/           # One folder per feature (catalog, detail, compare)
│   ├── app.dart             # MaterialApp.router
│   ├── router.dart          # All routes (typed, go_router_builder) and the navigation helpers
│   └── shared/              # Code used by 2+ features that needs the paddle models 
├── data/                    # Data layer
│   ├── api/                 # Raw I/O, shaped like a backend
│   └── repositories/
│       └── paddle/          # The paddle repository and its models
├── core/                    # Code that knows no feature and no model: widgets, theme, utils
└── config/                  # ApiConfig: simulated latency and failure rate
```

#### `app/`: one folder per feature

A feature is one flow of the app (catalog, detail, comparison) and owns its controllers and views:

```
<feature>/
├── controller/              # The feature's logic (Riverpod providers)
├── state/                   # The controller's state, when it needs its own class
└── view/
    ├── <feature>_view.dart  # Entry point from the router; picks the mobile or desktop page
    ├── widgets/             # Shared by both pages
    ├── mobile/              # Mobile page and its widgets
    └── desktop/             # Desktop page and its widgets
```


#### `data/`, `core/`, `config/`

- **`data/api/`**: talking to the outside world. Returns raw JSON.
- **`data/repositories/`**: the single entry point for data. Turns the API's JSON into models for the controllers and hides where it came from.
- **`core/`**: shared code that knows no feature and no model.
- **`config/`**: app configuration, readable by any layer.

### Providers

- **Data**: `paddleApiProvider` and `paddleRepositoryProvider` live for the whole app. Tests override them.
- **Router**: `routerProvider` holds the `GoRouter`.
- **Features**: each feature has a controller that loads its data through the repository: `CatalogController`, `PaddleDetailController` and `ComparePaddleController`.

The URL is the source of truth. Each feature reads its route parameters (catalog filter, paddle id, compared ids) from a provider that its entry view fills from the route, so a refresh or a shared link rebuilds the same screen.

The comparison has one provider per paddle (`comparePaddleControllerProvider(id)`), shared by the tray and the comparison: each paddle loads and retries on its own, and adding one fetches only that one.

### Routing

All routes are typed and live in [lib/app/router.dart](lib/app/router.dart):

```
/                 catalog
├── paddles/:id   detail
└── compare       comparison (bottom sheet on mobile, page on desktop)
```

- **Everything shareable is in the URL**: search, filters, sort and the compared paddles, e.g. `/?q=apex&shape=hybrid&sort=price-asc&compare=summit`. Detail and comparison carry the same query, so a refresh or a shared link restores the whole screen, with the catalog underneath to go back to.
- **History follows the user's path**: `push` to go forward, `pop` to go back. Filter changes replace the URL without adding history, so Back leaves the catalog instead of undoing filters one by one.
- **Bad URLs don't break the app**: unknown or invalid parameters are ignored.

## Key decisions and trade-offs

1. **Routing at the center.** Everything the user can share lives in the URL: search, filters, sort, the open paddle and the compared paddles. A refresh or a shared link opens the same screen, and Back goes where the user came from. *Trade-off:* The native apps follow web rules too: every screen must be rebuildable from its URL, so pages pass ids instead of objects.

2. **Route parameters reach the controllers through scoped providers.** Each screen puts its URL's parameters (filter, paddle id, compared ids) in providers scoped to it, so widgets below read them without passing them down. The compared paddles are the exception: a family by id, shared by the tray and the comparison (see decision 6). Automatic retry is off, so a failure shows an error and a retry button. *Trade-off:* it's the most complex part of the app and the first thing I'd change (see "With another day"): each screen needs its own `ProviderContainer`, and a new URL reaches the controllers a frame later.

3. **A separate page per screen size.** Each screen has a mobile page and a desktop page, sharing the same logic. The choice depends on window width, not on the device, so an iPad in landscape gets the desktop page. *Trade-off:* two layouts to maintain, but each one fits its screen.

4. **Select where you browse, compare on a dedicated screen.** Paddles are added from the catalog or the detail page, and the selection shows in a tray at the bottom of the catalog (and of the desktop detail page), where it can be changed or opened. The comparison itself is its own screen: a bottom sheet on mobile, a full page on desktop. Mobile compares 2 paddles, desktop compares 3: at 375 px, two columns get about 165 px each, room for the image, the name and the rating bars, while three would get about 106 px. So the phone shows two, with each label above its values instead of beside them. Rows whose values differ are highlighted; a spec that isn't listed doesn't count as a difference. The selection lives in the URL, so it survives a refresh and can be shared. *Trade-off*: the URL only holds ids, so adding a paddle fetches it again, even from its own detail page. That's normal on the web, but in the native apps it's a fetch an in-memory selection wouldn't need. 

5. **Dirty data never crashes the app.** Parsing is tolerant: a paddle without an id, brand or name is skipped, a duplicate id keeps the first entry, and a bad or missing field becomes empty and shows as "Not listed". Weight is converted to ounces whatever the unit, so paddles compare fairly. A missing or broken image shows a placeholder. An unknown id shows "Paddle not found", on the detail page and in the comparison. A 4th paddle can't be added: "Compare" is disabled once the comparison is full. *Trade-off:* bad data is hidden instead of reported. A typo in a key or value just shows up as "Not listed", and one in the id, brand or name drops the paddle from the catalog. With a real backend I'd log what the parser drops, so bad data gets noticed and fixed at the source.

6. **Each compared paddle loads on its own.** Adding a paddle loads only that one, and if one fails, only that one shows an error and a retry button. *Trade-off:* opening a shared or refreshed compare URL sends one request per paddle instead of a single batch, so with the simulated failure rate one of them fails more often.

7. **Built and tested for a slow, unreliable network.** The fake API adds delay and random errors, so every screen has loading, error and retry states. Tests use the same in-memory server the fake API wraps, so they run the app's real queries without the delay.

8. **The JSON is treated as a real backend.** Search, filters, sort and pagination are sent as query parameters, and a paddle has its own endpoint, so swapping the fake API for an HTTP client wouldn't change the repository or the controllers. *Trade-off:* more code than filtering 32 paddles in memory, and the fake server repeats the app's parsing rules, so the two have to change together.

9. **Accessibility basics.** A screen reader stops once per card, and adding a card to the comparison is a custom action. In the comparison, each value is read with its paddle's name, ratings as "7 out of 10", and a highlighted row as "Shape, differs". Images and skeletons are hidden from it, icon buttons have tooltips, and a missing spec is read as "Not listed" instead of a dash. Tap targets are at least 48 px, secondary text keeps a 4.5:1 contrast, and fixed-height text areas grow with the system text size.

### Deliberately left out

- **A data cache.** The repository fetches on every call, so opening a paddle the catalog already loaded fetches it again, and with the simulated latency and failures that means extra spinners and errors. A cache by id would go in the repository, without changing the controllers. I left it out because it needs an invalidation rule (how long a price stays fresh), which I'd rather decide against a real backend.
- **Dark theme and "find similar paddles"** (stretch goals). I spent the time on the core flows instead.
- **Cleaning up some AI-written code.** A few spots keep patterns the AI wrote that I don't like and would rewrite in a real codebase. I left them on purpose, like the local widget-builder functions in [paddle_detail_skeleton.dart](lib/app/paddle_detail/view/mobile/widgets/paddle_detail_skeleton.dart).

- **Trimming the AI's comments.** Some files keep comments the AI wrote to explain its code. I kept them for my own understanding while reviewing; in production I'd leave fewer.

- **Reviewing [docs/ARCHITECTURE.md](docs/ARCHITECTURE.md).** I wrote the first version with the AI's help, but the AI kept changing it across commits, including a few changes of direction I hadn't asked for. It could, because I never set guardrails for it (e.g. "don't edit this doc without asking"). I left it as it is, as an example of a risk of working with AI: the doc the agent is told to follow is also one it can rewrite, so the rules can drift without anyone deciding it. I see this all the time at work... And when there are guardrails, development slows down because every change needs human approval, so some devs end up bypassing the rule and letting the agent run free.

## How I used AI

I used Claude Code. About 90% of the code was generated, but under close supervision: I planned every feature, set the rules the agent follows, and reviewed its output, rejecting or reworking what didn't fit.

- **What I did myself:** the folder structure and the architecture. The architecture is a simplified version of [one I drew a while ago](https://excalidraw.com/#json=eT5-g-33zXarME0iX99xc,fGON4od9MDWYGNUOG7Jnig), written down in [docs/ARCHITECTURE.md](docs/ARCHITECTURE.md), which the agent is told to follow before building any feature. I also wrote some interfaces and the initial structure of some widgets, so the AI could generate the rest.
- **What worked:** planning first and writing detailed prompts. Short or vague prompts didn't get a good enough result; a plan with the rules spelled out did. I didn't use spec-driven development (SDD), just a plan per feature.
- **What I rejected:** some of the AI's output, simply because it was bad. The clearest case was the first version of the routing: the AI assumed a `ShellRoute` was the right way to handle the `CompareTray`, which made the routing unnecessarily complex, so I threw it away. I also didn't accept code that I judged too verbose.
- **Where I leaned on it most: Riverpod.** It's the library I had used least, so I accepted the AI's way of passing route parameters to the controllers (decision 2). It works and is tested, but I only saw its cost along the way, when the comparison used a family and came out simpler.
- **What I left as is:** see "Deliberately left out" above, for the AI-written code and comments I'd clean up, and for how the architecture doc drifted.

## With another day

- **Families instead of scoped providers**, like the comparison already uses (`paddleDetailControllerProvider(id)`). No more child containers or one-frame delay. The cost: widgets have to receive the id or filter, and the catalog would need extra work to keep old results on screen while a new filter loads.
- **Remove from the comparison on the mobile detail page.** Today it only says "Added to compare"; removing takes the catalog's tray. (I forgot to implement this, but it's simple)
- **Change the selection from the comparison itself**: remove or replace a paddle without going back. (Same as above)
- **Differences that stand out.** My idea was to mark the best value in each row, or add a "differences only" switch. Yesterday I built only a simple version, a band on the rows that differ (pushed today), and didn't start another coding session for the rest, since I'd already spent about 6 hours. With three paddles almost every row differs, so the band alone says little.
- **More on the cards**: shape, weight and power at a glance, so sorting by power shows why. But I would need to think about how to show that without cluttering the card.
- **Shared links with three paddles on a phone browser.** A comparison shared from the desktop web holds three paddles, but a phone browser shows only the first two, without saying a third is hidden.
- **A tablet layout.** Below 840 px a tablet gets the phone layout, just stretched.
- **Better animations**, especially on scroll, while keeping the UI minimalist.
- **A closer review of the code**, including the cleanups in "Deliberately left out".
- **Separate routing for mobile and web.** I'd study whether separate routing for mobile and web would pay off in the long run, so mobile doesn't carry the browser's limitations (see decision 1).
- **Accessibility checks in the widget tests**, with Flutter's `meetsGuideline` for tap targets, labels and contrast, so a regression fails the build.
