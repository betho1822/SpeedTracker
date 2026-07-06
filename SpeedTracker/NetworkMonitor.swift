import AppKit
import Foundation

#if os(macOS)
import Darwin
#endif

@MainActor
final class NetworkMonitor: ObservableObject {
    @Published private(set) var currentInterface: NetworkInterface?
    @Published private(set) var downloadSpeed: UInt64 = 0
    @Published private(set) var uploadSpeed: UInt64 = 0
    @Published private(set) var sessionDownloadBytes: UInt64 = 0
    @Published private(set) var sessionUploadBytes: UInt64 = 0
    @Published private(set) var peakDownloadSpeed: UInt64 = 0
    @Published private(set) var peakUploadSpeed: UInt64 = 0
    @Published private(set) var lastUpdated: Date?
    @Published private(set) var isActive = false
    @Published private(set) var errorMessage: String?

    private var timer: Timer?
    private var lastSample: InterfaceSample?

    var menuBarTitle: String {
        "↑\(ByteFormatters.compactRate(uploadSpeed)) / ↓\(ByteFormatters.compactRate(downloadSpeed))"
    }

    init() {
        start()
    }

    deinit {
        timer?.invalidate()
    }

    func quit() {
        NSApplication.shared.terminate(nil)
    }

    func refresh() {
        sampleNetwork()
    }

    func resetSessionStats() {
        sessionDownloadBytes = 0
        sessionUploadBytes = 0
        peakDownloadSpeed = 0
        peakUploadSpeed = 0
    }

    func openNetworkSettings() {
        let urls = [
            "x-apple.systempreferences:com.apple.Network-Settings.extension",
            "x-apple.systempreferences:com.apple.preference.network"
        ]

        for urlString in urls {
            guard let url = URL(string: urlString) else {
                continue
            }

            if NSWorkspace.shared.open(url) {
                return
            }
        }
    }

    private func start() {
        sampleNetwork()

        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            Task { @MainActor in
                self?.sampleNetwork()
            }
        }

        timer?.tolerance = 0.15
    }

    private func sampleNetwork() {
        do {
            let samples = try readInterfaceSamples()
            guard let sample = selectBestInterface(from: samples) else {
                markInactive("No se detectó interfaz activa.")
                return
            }

            currentInterface = sample.interface
            isActive = true
            errorMessage = nil
            lastUpdated = Date()

            guard let previous = lastSample,
                  previous.interface.name == sample.interface.name else {
                lastSample = sample
                downloadSpeed = 0
                uploadSpeed = 0
                return
            }

            downloadSpeed = sample.receivedBytes >= previous.receivedBytes
                ? sample.receivedBytes - previous.receivedBytes
                : 0
            uploadSpeed = sample.sentBytes >= previous.sentBytes
                ? sample.sentBytes - previous.sentBytes
                : 0

            sessionDownloadBytes += downloadSpeed
            sessionUploadBytes += uploadSpeed
            peakDownloadSpeed = max(peakDownloadSpeed, downloadSpeed)
            peakUploadSpeed = max(peakUploadSpeed, uploadSpeed)
            lastSample = sample
        } catch {
            markInactive(error.localizedDescription)
        }
    }

    private func markInactive(_ message: String) {
        currentInterface = nil
        isActive = false
        errorMessage = message
        downloadSpeed = 0
        uploadSpeed = 0
        lastUpdated = Date()
        lastSample = nil
    }

    private func selectBestInterface(from samples: [InterfaceSample]) -> InterfaceSample? {
        let activeSamples = samples.filter {
            $0.interface.isRunning
                && !$0.interface.isLoopback
                && ($0.receivedBytes > 0 || $0.sentBytes > 0)
        }

        guard !activeSamples.isEmpty else {
            return nil
        }

        if let previousName = lastSample?.interface.name,
           let previousSample = activeSamples.first(where: { $0.interface.name == previousName }) {
            return previousSample
        }

        return activeSamples.sorted { lhs, rhs in
            if lhs.interface.priority != rhs.interface.priority {
                return lhs.interface.priority < rhs.interface.priority
            }

            return lhs.receivedBytes + lhs.sentBytes > rhs.receivedBytes + rhs.sentBytes
        }
        .first
    }

    private func readInterfaceSamples() throws -> [InterfaceSample] {
        var addressList: UnsafeMutablePointer<ifaddrs>?

        guard getifaddrs(&addressList) == 0 else {
            throw NetworkMonitorError.cannotReadInterfaces
        }

        defer {
            freeifaddrs(addressList)
        }

        var samples: [InterfaceSample] = []
        var cursor = addressList

        while cursor != nil {
            guard let interfaceAddress = cursor?.pointee else {
                cursor = cursor?.pointee.ifa_next
                continue
            }

            defer {
                cursor = interfaceAddress.ifa_next
            }

            guard let socketAddress = interfaceAddress.ifa_addr,
                  socketAddress.pointee.sa_family == UInt8(AF_LINK),
                  let dataPointer = interfaceAddress.ifa_data else {
                continue
            }

            let name = String(cString: interfaceAddress.ifa_name)
            let flags = Int32(interfaceAddress.ifa_flags)
            let data = dataPointer.assumingMemoryBound(to: if_data.self).pointee
            let networkInterface = NetworkInterface(
                name: name,
                displayName: displayName(for: name),
                kind: kind(for: name),
                isRunning: (flags & IFF_UP) != 0 && (flags & IFF_RUNNING) != 0,
                isLoopback: (flags & IFF_LOOPBACK) != 0
            )

            samples.append(
                InterfaceSample(
                    interface: networkInterface,
                    receivedBytes: UInt64(data.ifi_ibytes),
                    sentBytes: UInt64(data.ifi_obytes)
                )
            )
        }

        return samples
    }

    private func kind(for name: String) -> NetworkInterface.Kind {
        if name.hasPrefix("en") {
            return .ethernetOrWiFi
        }

        if name.localizedCaseInsensitiveContains("tailscale") || name.hasPrefix("utun") {
            return .tailscale
        }

        return .other
    }

    private func displayName(for name: String) -> String {
        switch kind(for: name) {
        case .ethernetOrWiFi:
            return "\(name) · Wi-Fi/Ethernet"
        case .tailscale:
            return "\(name) · Tailscale/VPN"
        case .other:
            return name
        }
    }

    func mockValuesForScreenshot() {
        self.currentInterface = NetworkInterface(name: "en1", displayName: "en1 · Wi-Fi/Ethernet", kind: .ethernetOrWiFi, isRunning: true, isLoopback: false)
        self.downloadSpeed = 101_400_000 / 8
        self.uploadSpeed = 18_100_000 / 8
        self.sessionDownloadBytes = 15_000_000_000
        self.sessionUploadBytes = 4_800_000_000
        self.peakDownloadSpeed = 101_400_000 / 8
        self.peakUploadSpeed = 18_100_000 / 8
        self.isActive = true
        self.lastUpdated = Date()
    }
}


struct NetworkInterface: Equatable {
    enum Kind: Equatable {
        case ethernetOrWiFi
        case tailscale
        case other
    }

    let name: String
    let displayName: String
    let kind: Kind
    let isRunning: Bool
    let isLoopback: Bool

    var priority: Int {
        switch kind {
        case .ethernetOrWiFi:
            return 0
        case .tailscale:
            return 1
        case .other:
            return 2
        }
    }

    var symbolName: String {
        switch kind {
        case .ethernetOrWiFi:
            return "wifi"
        case .tailscale, .other:
            return "network"
        }
    }
}

private struct InterfaceSample {
    let interface: NetworkInterface
    let receivedBytes: UInt64
    let sentBytes: UInt64
}

private enum NetworkMonitorError: LocalizedError {
    case cannotReadInterfaces

    var errorDescription: String? {
        "No se pudieron leer las interfaces de red."
    }
}
