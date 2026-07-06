# Contributing to Speed Tracker

Thanks for taking the time to improve Speed Tracker. The project is small on purpose, so focused issues and pull requests are the easiest to review.

## Reporting Bugs

Open an [issue](https://github.com/betho1822/SpeedTracker/issues) and include:

- macOS version.
- Mac model or Apple Silicon/Intel.
- Speed Tracker version.
- What you expected to happen.
- What actually happened.
- Screenshots or screen recordings, if they help explain the issue.

## Requesting Features

Feature requests are welcome when they fit the app's scope: a lightweight macOS menu bar network monitor.

Please describe the user problem first, then the proposed solution. This makes it easier to compare alternatives and keep the app simple.

## Development

Requirements:

- macOS 13 Ventura or newer
- Xcode 15 or newer

Clone the repository and open the Xcode project:

```bash
git clone https://github.com/betho1822/SpeedTracker.git
cd SpeedTracker
open "Speed Tracker.xcodeproj"
```

Build from Terminal:

```bash
xcodebuild -project "Speed Tracker.xcodeproj" \
  -scheme "Speed Tracker" \
  -configuration Release \
  build
```

## Pull Requests

Before opening a PR:

- Keep the change focused.
- Follow the existing Swift and SwiftUI style.
- Avoid unrelated formatting or project-file churn.
- Make sure the project builds locally.
- Update README or CHANGELOG only when the change affects users or contributors.

PR descriptions should explain what changed, why it changed and how it was tested.

## Code of Conduct

Please follow the [Code of Conduct](CODE_OF_CONDUCT.md) in all project spaces.
