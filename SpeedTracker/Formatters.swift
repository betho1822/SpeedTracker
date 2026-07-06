import Foundation

enum ByteFormatters {
    private static let rateUnits = ["B", "K", "M", "G"]
    private static let totalUnits = ["B", "KB", "MB", "GB", "TB"]

    static func compactRate(_ bytesPerSecond: UInt64) -> String {
        var value = Double(bytesPerSecond)
        var unitIndex = 0

        while value >= 1024, unitIndex < rateUnits.count - 1 {
            value /= 1024
            unitIndex += 1
        }

        if unitIndex == 0 {
            return "\(Int(value))B/s"
        }

        return String(format: "%.1f%@/s", value, rateUnits[unitIndex])
    }

    static func totalBytes(_ bytes: UInt64) -> String {
        var value = Double(bytes)
        var unitIndex = 0

        while value >= 1024, unitIndex < totalUnits.count - 1 {
            value /= 1024
            unitIndex += 1
        }

        if unitIndex == 0 {
            return "\(Int(value)) B"
        }

        let format = value < 10 ? "%.1f %@" : "%.0f %@"
        return String(format: format, value, totalUnits[unitIndex])
    }
}
