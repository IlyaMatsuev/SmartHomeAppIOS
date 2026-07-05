---
description: Write/adjust unit tests for my recent code changes following the Tester workflow
---

I've just updated some code. Write unit tests for the new code, or adjust the existing tests if needed.

Rules:

- Do NOT change my newly written (non-test) code. Only add or modify test files. If something requires changes to write proper unit tests (e.g. a service is not exposed via a protocol), ask first.
- Validate my changes first: read the diff, confirm the code is correct, and flag anything that looks wrong before writing tests.
- **Do not pause for confirmation** before writing the tests. Flag concerns in your final summary, but make a reasonable judgment call and proceed. Only stop if you genuinely cannot write tests without a code change.
- Follow the Tester workflow defined in `.claude/agents/tester.md`: Swift Testing (`import Testing`, `@Test`, `#expect`/`#require`), `<Type>Tests.swift` under `MyHomeAppTests/`, `struct` test suites annotated `@MainActor` when they exercise a `@MainActor` view model, hand-rolled protocol stubs/mocks in `MyHomeAppTests/Mocks/`, fixtures via `Type.fixture(...)` extensions.
- Do not add new XCTest-style files to the unit-test target. UI tests under `MyHomeAppUITests/` stay XCTest.
- Match the existing test style and structure in the affected test files.
- When the implementation moved/renamed things, move/rename the corresponding tests the same way rather than duplicating.
- Run the affected tests (and then the whole unit suite) via the **UnitTests** plan — `xcodebuild test -scheme MyHomeApp -destination 'platform=iOS Simulator,name=iPhone 13 mini' -testPlan UnitTests` — to confirm everything is green before reporting. Do not run the UI tests (`AllTests` plan) unless explicitly asked. If `iPhone 13 mini` isn't available, pick another iOS 18.x or 26.x simulator from `xcrun simctl list devices available` — never claim success without a green run.
- Run `swiftlint` from the repo root after writing/updating any Swift file. Address any new warnings or errors the test files introduce before reporting done.

Scope: $ARGUMENTS

If no scope is given above, default to the changes in the last commit plus any uncommitted working-tree changes (`git show HEAD` and `git diff`).
