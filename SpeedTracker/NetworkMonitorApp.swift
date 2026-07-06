import SwiftUI
import AppKit

@main
struct NetworkMonitorApp: App {
    @AppStorage("showDockIcon") private var showDockIcon: Bool = false
    @StateObject private var monitor = NetworkMonitor()

    init() {
        let stored = UserDefaults.standard.bool(forKey: "showDockIcon")
        showDockIcon = stored
        // Defer activation policy to avoid crash during early App init
        DispatchQueue.main.async {
            NSApp.setActivationPolicy(stored ? .regular : .accessory)
        }
    }

    var body: some Scene {
        MenuBarExtra {
            MenuBarView(monitor: monitor, showDockIcon: $showDockIcon)
        } label: {
            Image(nsImage: menuBarTitleImage)
                .renderingMode(.original)
        }
        .menuBarExtraStyle(.window)
    }

    private var menuBarTitleImage: NSImage {
        let font = NSFont.monospacedDigitSystemFont(ofSize: 11, weight: .semibold)
        let title = NSMutableAttributedString()

        // Calculate speed level for intensity
        let totalMbps = Double(monitor.uploadSpeed + monitor.downloadSpeed) * 8 / 1_000_000
        let uploadColor: NSColor
        let downloadColor: NSColor

        if totalMbps > 10 {
            // Blazing: vivid saturated colors
            uploadColor = NSColor(calibratedHue: 0.02, saturation: 0.85, brightness: 0.95, alpha: 1.0)
            downloadColor = NSColor(calibratedHue: 0.33, saturation: 0.85, brightness: 1.0, alpha: 1.0)
        } else if totalMbps > 5 {
            // Fast: slightly brighter than normal
            uploadColor = NSColor(calibratedHue: 0.02, saturation: 0.85, brightness: 0.95, alpha: 1.0)
            downloadColor = NSColor(calibratedHue: 0.33, saturation: 0.7, brightness: 0.95, alpha: 1.0)
        } else {
            // Normal
            uploadColor = NSColor(calibratedHue: 0.02, saturation: 0.85, brightness: 0.95, alpha: 1.0)
            downloadColor = NSColor.systemGreen
        }

        title.append(NSAttributedString(
            string: "↑\(ByteFormatters.compactRate(monitor.uploadSpeed))",
            attributes: [
                .font: font,
                .foregroundColor: uploadColor
            ]
        ))

        title.append(NSAttributedString(
            string: " / ",
            attributes: [
                .font: font,
                .foregroundColor: NSColor.secondaryLabelColor
            ]
        ))

        title.append(NSAttributedString(
            string: "↓\(ByteFormatters.compactRate(monitor.downloadSpeed))",
            attributes: [
                .font: font,
                .foregroundColor: downloadColor
            ]
        ))

        let textSize = title.size()
        let imageSize = NSSize(width: ceil(textSize.width), height: 18)
        let image = NSImage(size: imageSize)
        image.isTemplate = false
        image.lockFocus()
        title.draw(at: NSPoint(x: 0, y: floor((imageSize.height - textSize.height) / 2)))
        image.unlockFocus()

        return image
    }
}
