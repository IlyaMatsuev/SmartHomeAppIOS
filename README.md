# SmartHome App (IOS)

iOS client for the [MySmartHome](https://github.com/IlyaMatsuev/MySmartHome) hub. Built with SwiftUI.

## Requirements

- **Xcode** 26.x
- **iOS** 18.6+ (deployment target)
- **Swift** 5.0
- **macOS** with Apple Silicon recommended

## Setup

1. Clone the repo and open `SmartHomeAppIOS.xcodeproj` in Xcode.
2. Install developer tools (one-time):

```bash
brew install swiftlint
```

3. Wait for Xcode to resolve Swift Package Manager dependencies on first open.

Dependencies are managed through SPM and pinned in `Package.resolved`. No CocoaPods or Carthage.

## Running the app

In Xcode: pick an iPhone simulator (iOS 18.x or 26.x) and press `Cmd+R`.

From the command line:

```bash
# Build
xcodebuild build -scheme SmartHomeAppIOS -destination 'platform=iOS Simulator,name=iPhone 13 mini'

# Discover available simulators
xcrun simctl list devices available
```

Substitute `iPhone 13 mini` with whatever simulator you have installed.

## Running tests

The scheme ships two test plans: **UnitTests** (default — unit tests only, fast) and **AllTests** (unit + UI tests).

Inside Xcode: `Cmd+U` runs the default plan (UnitTests). `Ctrl+Opt+Cmd+U` runs the test under the cursor. Switch plans from the Test Navigator's plan selector or `Product → Test Plan`.

From the command line:

```bash
# Unit tests (fast — no UI tests)
xcodebuild test -scheme SmartHomeAppIOS -destination 'platform=iOS Simulator,name=iPhone 13 mini' -testPlan UnitTests

# Everything, including UI tests
xcodebuild test -scheme SmartHomeAppIOS -destination 'platform=iOS Simulator,name=iPhone 13 mini' -testPlan AllTests

# A single test method
xcodebuild test \
  -scheme SmartHomeAppIOS \
  -destination 'platform=iOS Simulator,name=iPhone 13 mini' \
  -testPlan UnitTests \
  -only-testing:SmartHomeAppIOSTests/DevicesViewModelTests/loadGroupsDevicesByRoom
```

Unit tests live in `SmartHomeAppIOSTests/` and use [Swift Testing](https://developer.apple.com/documentation/testing) (`@Test`, `#expect`).

UI tests live in `SmartHomeAppIOSUITests/` and use XCTest / XCUITest.

## Linting

[SwiftLint](https://github.com/realm/SwiftLint) runs automatically during builds via a Swift Package Plugin and surfaces warnings inline in Xcode. To run it manually:

```bash
# Lint the whole project
swiftlint

# Auto-fix what it can
swiftlint --fix
```

## SideStore anisette servers

The app is installed on-device via [SideStore](https://sidestore.io). SideStore needs an anisette server to talk to Apple, and it lets you point it at a custom **anisette servers list** URL (Settings → Anisette Servers).

This repo ships that list as [sidestore-anisette-servers.json](sidestore-anisette-servers.json). Entry 1 is the self-hosted server from [docker-compose.yaml](docker-compose.yaml); the rest are community fallbacks in case the local one is unreachable.

### Hosting the list

SideStore fetches the list over HTTPS on every refresh, so it needs a stable raw URL. This repo uses a **secret GitHub gist** — unlisted, not indexed, but publicly reachable to anyone with the link, which is fine because SideStore itself needs to fetch it unauthenticated.

One-time setup:

1. Go to <https://gist.github.com> → **New secret gist**.
2. Filename: `sidestore-anisette-servers.json`. Paste the contents of the file in this repo.
3. Create the gist. Open the **Raw** button and copy that URL.
4. In SideStore → Settings → paste the raw URL into **Refresh anisette servers URL** and refresh.

## License

[PolyForm Noncommercial](LICENSE)
