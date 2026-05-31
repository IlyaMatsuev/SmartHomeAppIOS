# SmartHomeAppIOS — Claude Instructions

This file contains project-level instructions for Claude Code when working in this repo. Skim it before making changes.

## What this project is

A native iOS client for the SmartHome Hub. Built with SwiftUI. The app is a personal project — single developer, no production users yet — so prefer simple, idiomatic SwiftUI over enterprise-style abstractions.

## Toolchain & targets

| Setting                          | Value                                             |
| -------------------------------- | ------------------------------------------------- |
| Xcode                            | 26.x (latest)                                     |
| Swift                            | 5.0                                               |
| iOS Deployment Target            | **18.6** (app target)                             |
| Devices                          | iPhone + iPad (universal, see `Info` orientations)|
| Concurrency                      | `async`/`await`, `@MainActor`, strict-ish         |
| UI                               | SwiftUI only (no UIKit screens unless required)   |

Use iOS 17+ / iOS 18 APIs freely (e.g. Observation framework `@Observable`, `NavigationStack`, `.scrollTargetBehavior`, etc.). Do not reach for iOS 26-only APIs unless explicitly bumping the deployment target.

## Project structure

```
SmartHomeAppIOS/
├── SmartHomeAppIOSApp.swift         # @main entry point
├── ContentView.swift                # Root TabView
├── Assets.xcassets/                 # Colors, images, app icon
├── Core/                            # Models, networking, services (shared infra)
├── Shared/                          # Reusable views, modifiers, extensions
└── Screens/                         # Feature screens
    ├── Home/
    ├── Devices/
    ├── Scenarios/
    └── Settings/

SmartHomeAppIOSTests/                # XCTest unit tests
├── Mocks/                           # Hand-rolled protocol mocks + fixtures
└── ...                              # Mirrors Screens/Core layout

SmartHomeAppIOSUITests/              # XCUITest UI tests
```

Feature-folder layout. Each `Screens/Foo/` folder owns `FooView.swift`, `FooViewModel.swift`, and feature-local models. Cross-feature code goes in `Core/` or `Shared/`.

## Architecture

MVVM with SwiftUI:

- **Views** (`struct: View`) are dumb. No business logic in `body`. No network calls from `body`. Trigger async work via `.task { }`.
- **ViewModels** are `@Observable` `@MainActor` classes that own state. Inject dependencies via initializer with sensible defaults (`init(service: FooServiceProtocol = FooService.shared)`).
- **Services** expose a `protocol` + concrete implementation. Tests mock the protocol; production uses the concrete type.
- **Models** are `struct`s. Use `Codable`/`Identifiable`/`Equatable`/`Hashable` as needed.

The full conventions are in [.claude/agents/implementer.md](.claude/agents/implementer.md) and [.claude/agents/reviewer.md](.claude/agents/reviewer.md).

## Build & test

The scheme is **SmartHomeAppIOS**. Use an iPhone simulator on iOS 18.x.

```bash
# Build
xcodebuild build \
  -scheme SmartHomeAppIOS \
  -destination 'platform=iOS Simulator,name=iPhone 16'

# Run all tests
xcodebuild test \
  -scheme SmartHomeAppIOS \
  -destination 'platform=iOS Simulator,name=iPhone 16'

# Lint (requires SwiftLint — see below)
swiftlint
```

Discover available simulators with `xcrun simctl list devices available`.

**Before reporting a task done that touched Swift code**, run `xcodebuild build` (and `test` if you changed testable code) and report the result. If you cannot run the build, say so explicitly — do not claim success.

## Linting

[SwiftLint](https://github.com/realm/SwiftLint) is configured via `.swiftlint.yml` at the repo root. Run `swiftlint` before finishing a task that touched Swift files. If SwiftLint isn't installed locally (`brew install swiftlint`), say so and proceed without it.

## Coding rules (short list — see agent files for full version)

- `struct`/`enum` over `class`. `let` over `var`.
- No force unwraps (`!`) or force casts (`as!`) except for compile-time constants (`URL(string: "...")!`).
- No `print(...)` in production code — use `os.Logger`.
- ViewModels touching UI are `@MainActor`.
- No singletons inside view models — inject via init.
- Use the asset catalog for colors. Don't hardcode hex.
- One primary type per file; file name matches the type.
- Screen-level views get a `#Preview`. For small reusable components, add one only when the canvas would actually help iterate (e.g. multiple states shown side-by-side) — a lone capsule on a 6.7" canvas is noise.

## Agent workflow

The `.claude/agents/` folder defines five specialized prompts you can invoke:

- **Architect** — plan a feature, no code
- **Implementer** — write the code per the plan
- **Reviewer** — review the diff against project standards
- **Tester** — write XCTest unit tests
- **StoryTeller** — write DocC / README docs

See [.claude/agents/README.md](.claude/agents/README.md) for the handoff flow.

Slash commands live in `.claude/commands/`:

- `/tests` — write or adjust unit tests for recent code changes

## Things to avoid

- Don't introduce CocoaPods or Carthage. SPM only.
- Don't add comments that restate the code (`// Increment counter` above `counter += 1`).
- Don't create planning / decision docs unless explicitly asked.
- Don't add files to the Xcode project that should not be compiled (`README.md`, `.gitignore`, `.swiftlint.yml`, `LICENSE`). Either leave them out of the project entirely or add them with **all target memberships unchecked**.
- Don't refactor unrelated code while fixing a bug. Keep changes scoped to the request.

## Git

- Default branch: `main`
- Commit messages: short, imperative ("Add device pairing sheet", not "Added").
- Only commit when explicitly asked.
