<p align="center">
  <img src="SpeedTracker/Assets.xcassets/AppIcon.appiconset/icon_512x512.png" width="112" height="112" alt="Speed Tracker icon">
</p>

<h1 align="center">Speed Tracker</h1>

<p align="center">
  Native and lightweight network monitor for the macOS menu bar.
  <br>
  Displays real-time upload and download speeds, session totals, and peak speeds.
</p>

<p align="center">
  <a href="https://github.com/betho1822/SpeedTracker/releases/latest"><img alt="Version" src="https://img.shields.io/github/v/release/betho1822/SpeedTracker?style=flat-square&label=version"></a>
  <a href="https://github.com/betho1822/SpeedTracker/releases"><img alt="Downloads" src="https://img.shields.io/github/downloads/betho1822/SpeedTracker/total?style=flat-square"></a>
  <a href="https://github.com/betho1822/SpeedTracker/issues"><img alt="Issues" src="https://img.shields.io/github/issues/betho1822/SpeedTracker?style=flat-square"></a>
  <a href="https://github.com/betho1822/SpeedTracker/stargazers"><img alt="Stars" src="https://img.shields.io/github/stars/betho1822/SpeedTracker?style=flat-square"></a>
  <img alt="macOS Compatibility" src="https://img.shields.io/badge/macOS-13%2B-111111?style=flat-square&logo=apple">
  <a href="LICENSE"><img alt="License" src="https://img.shields.io/badge/license-MIT-3DA639?style=flat-square"></a>
</p>

<p align="center">
  <a href="https://github.com/betho1822/SpeedTracker/releases/latest">Download</a>
  ·
  <a href="https://github.com/betho1822/SpeedTracker/releases">Releases</a>
  ·
  <a href="https://github.com/betho1822/SpeedTracker/issues/new?assignees=&labels=bug&template=bug_report.md">Report Bug</a>
  ·
  <a href="https://github.com/betho1822/SpeedTracker/issues/new?assignees=&labels=enhancement&template=feature_request.md">Request Feature</a>
  ·
  <a href="https://payrequest.me/alberto_guerrero">Donate</a>
</p>

## Preview

<p align="center">
  <img src="assets/screenshot.png?v=2" alt="Speed Tracker menu bar panel" width="720">
</p>

## Features

- **Real-time monitoring:** Upload and download speeds displayed directly in the menu bar.
- **Session statistics:** Accumulated totals and peak speeds since the start of the current session.
- **Smart interface detection:** Prioritizes Wi-Fi or Ethernet over secondary or virtual interfaces (like VPNs or Tailscale).
- **Native SwiftUI panel:** Modern design aligned with macOS aesthetics, including manual refresh controls and direct access to network settings.
- **Multi-language UI:** Dynamically switch between English and Spanish directly from the panel.
- **Dock icon control:** Toggle the application icon in the Dock directly from the panel.
- **Universal binary:** Native support for both Apple Silicon and Intel processors.

## Installation

1. Download the latest `.dmg` file from [GitHub Releases](https://github.com/betho1822/SpeedTracker/releases/latest).
2. Open the downloaded DMG file.
3. Drag **Speed Tracker.app** to your **Applications** folder.
4. Launch **Speed Tracker** from your Applications folder or Launchpad.

### Running on macOS (Gatekeeper)

Since Speed Tracker is not signed with an Apple Developer ID, macOS may display a Gatekeeper warning the first time you open it.

To run it:
1. Right-click (or `Ctrl` + click) **Speed Tracker.app** in Applications and choose **Open**.
2. Click **Open** in the macOS confirmation dialog.

*Note: The source code is publicly available in this repository for review and auditing. If you prefer not to use the precompiled binary, you can [build the project from source](#building-from-source).*

### Building from Source

Requirements:
- macOS 13 Ventura or newer
- Xcode 15 or newer

1. Clone the repository and navigate to the project directory:
   ```bash
   git clone https://github.com/betho1822/SpeedTracker.git
   cd SpeedTracker
   ```
2. Open the project in Xcode:
   ```bash
   open "Speed Tracker.xcodeproj"
   ```
3. Select the **Speed Tracker** scheme, set the target destination to **My Mac**, and press `Cmd + R` to build and run.

You can also build from the terminal:
```bash
xcodebuild -project "Speed Tracker.xcodeproj" \
  -scheme "Speed Tracker" \
  -configuration Release \
  build
```

## Architecture

The project layout is modular and lightweight:

| File | Responsibility |
| :--- | :--- |
| `NetworkMonitorApp.swift` | App entry point, `MenuBarExtra` configuration, and Dock visibility policy. |
| `MenuBarView.swift` | SwiftUI panel, user controls, speed indicators, and session stats. |
| `NetworkMonitor.swift` | Network interface sampling using `getifaddrs()`, speed calculation, and active interface selection. |
| `Formatters.swift` | Formatting utilities for human-readable speeds and byte sizes. |

## System Requirements

- **macOS:** 13 Ventura or newer.
- **Architecture:** Apple Silicon or Intel.

## Privacy

Speed Tracker respects your privacy by design:
- It only reads local network interface counters exposed by the macOS kernel.
- It does not inspect packet contents.
- It does not collect browsing history, hostnames, or IP addresses.
- It does not contain telemetry, analytics, or send any network data to external servers.

## Contributing

Bug reports, feature requests, and code contributions are welcome.

Please refer to [CONTRIBUTING.md](CONTRIBUTING.md) for development guidelines and [CODE_OF_CONDUCT.md](CODE_OF_CONDUCT.md) for community standards.

## Support the Project

If you find this application useful, you can support its development and maintenance:

<p align="left">
  <a href="https://payrequest.me/alberto_guerrero"><img src="https://img.shields.io/badge/Buy%20Me%20a%20Coffee-ffdd00?style=flat-square&logo=buy-me-a-coffee&logoColor=black" alt="Buy Me a Coffee"></a>
  <a href="https://payrequest.me/alberto_guerrero"><img src="https://img.shields.io/badge/Donate-PayPal-003087?style=flat-square&logo=paypal" alt="Donate with PayPal"></a>
</p>

## Changelog

Notable changes are documented in [CHANGELOG.md](CHANGELOG.md).

## License

This project is licensed under the MIT License. See [LICENSE](LICENSE) for details.

---

<p align="center">
  <sub>Hecho en Querétaro, México 🇲🇽</sub>
</p>
