import SwiftUI

struct MenuBarView: View {
    @ObservedObject var monitor: NetworkMonitor
    @Binding var showDockIcon: Bool

    @AppStorage("appLanguage") private var appLanguage: AppLanguage = {
        let code = Locale.current.language.languageCode?.identifier ?? "en"
        return code == "es" ? .spanish : .english
    }()

    private let panelWidth: CGFloat = 316
    private let warmRed = Color(hue: 0.02, saturation: 0.85, brightness: 0.95)

    // MARK: - Speed Level

    private enum SpeedLevel: Int, Comparable {
        case idle = 0
        case normal = 1
        case fast = 2       // > 5 Mbps
        case blazing = 3    // > 10 Mbps

        static func < (lhs: SpeedLevel, rhs: SpeedLevel) -> Bool {
            lhs.rawValue < rhs.rawValue
        }
    }

    private var speedLevel: SpeedLevel {
        let mbps = Double(monitor.downloadSpeed + monitor.uploadSpeed) * 8 / 1_000_000
        if mbps > 10 { return .blazing }
        if mbps > 5  { return .fast }
        if mbps > 0.5 { return .normal }
        return .idle
    }

    private var speedGlowColor: Color {
        switch speedLevel {
        case .idle:    return .clear
        case .normal:  return .clear
        case .fast:    return .green.opacity(0.12)
        case .blazing: return .green.opacity(0.22)
        }
    }

    private var uploadGlowColor: Color {
        switch speedLevel {
        case .idle:    return .clear
        case .normal:  return .clear
        case .fast:    return warmRed.opacity(0.12)
        case .blazing: return warmRed.opacity(0.22)
        }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            header
            speedCards
            sessionStats

            if let errorMessage = monitor.errorMessage {
                errorBanner(errorMessage)
            }

            actionGrid
            dockToggle

            // Language Selector and Credits
            HStack(alignment: .center) {
                Picker("", selection: $appLanguage) {
                    ForEach(AppLanguage.allCases) { lang in
                        Text(lang.displayName).tag(lang)
                    }
                }
                .pickerStyle(.segmented)
                .frame(width: 130)
                .labelsHidden()

                Spacer()

                Text(translate(.credit, lang: appLanguage))
                    .font(.system(size: 9, weight: .medium))
                    .foregroundStyle(.tertiary)
            }
        }
        .padding(16)
        .frame(width: panelWidth, alignment: .topLeading)
        .background(.regularMaterial)
    }

    private var header: some View {
        HStack(alignment: .center, spacing: 12) {
            ZStack {
                RoundedRectangle(cornerRadius: 9, style: .continuous)
                    .fill(Color.accentColor.opacity(0.14))

                Image(systemName: monitor.currentInterface?.symbolName ?? "wifi.slash")
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundStyle(Color.accentColor)
            }
            .frame(width: 38, height: 38)

            VStack(alignment: .leading, spacing: 3) {
                HStack(spacing: 6) {
                    Text(translate(.appName, lang: appLanguage))
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundStyle(.primary)
                        .lineLimit(1)

                    statusBadge
                }

                Text(monitor.currentInterface?.displayName ?? translate(.noInterface, lang: appLanguage))
                    .font(.system(size: 11, weight: .medium))
                    .foregroundStyle(.secondary)
                    .lineLimit(1)
                    .truncationMode(.middle)

                Text("\(translate(.updated, lang: appLanguage)) \(lastUpdatedText)")
                    .font(.system(size: 10))
                    .foregroundStyle(.tertiary)
                    .lineLimit(1)
            }

            Spacer(minLength: 0)
        }
    }

    private var statusBadge: some View {
        HStack(spacing: 4) {
            Circle()
                .fill(monitor.isActive ? Color.green : Color.secondary.opacity(0.55))
                .frame(width: 6, height: 6)
                .shadow(color: speedLevel >= .blazing ? .green.opacity(0.6) : .clear, radius: 3)
                .scaleEffect(speedLevel >= .blazing ? 1.3 : 1.0)
                .animation(speedLevel >= .blazing
                    ? .easeInOut(duration: 0.8).repeatForever(autoreverses: true)
                    : .default, value: speedLevel)

            Text(monitor.isActive ? statusText : translate(.noNetwork, lang: appLanguage))
                .font(.system(size: 9, weight: .semibold))
                .foregroundStyle(monitor.isActive ? Color.green : Color.secondary)
        }
        .padding(.horizontal, 7)
        .padding(.vertical, 3)
        .background(.thinMaterial, in: Capsule())
        .animation(.easeInOut(duration: 0.3), value: speedLevel)
    }

    private var statusText: String {
        switch speedLevel {
        case .idle:    return translate(.active, lang: appLanguage)
        case .normal:  return translate(.active, lang: appLanguage)
        case .fast:    return translate(.fast, lang: appLanguage)
        case .blazing: return translate(.blazing, lang: appLanguage)
        }
    }

    private var speedCards: some View {
        HStack(spacing: 10) {
            metricCard(
                title: translate(.upload, lang: appLanguage),
                value: ByteFormatters.compactRate(monitor.uploadSpeed),
                symbolName: "arrow.up",
                tint: warmRed,
                glowColor: uploadGlowColor
            )

            metricCard(
                title: translate(.download, lang: appLanguage),
                value: ByteFormatters.compactRate(monitor.downloadSpeed),
                symbolName: "arrow.down",
                tint: .green,
                glowColor: speedGlowColor
            )
        }
    }

    private func metricCard(title: String, value: String, symbolName: String, tint: Color, glowColor: Color) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(spacing: 6) {
                Image(systemName: symbolName)
                    .font(.system(size: 11, weight: .bold))
                    .foregroundStyle(tint)
                    .frame(width: 18, height: 18)
                    .background(tint.opacity(0.14), in: Circle())

                Text(title)
                    .font(.system(size: 11, weight: .semibold))
                    .foregroundStyle(.secondary)
                    .lineLimit(1)
            }

            Text(value)
                .font(.system(size: 21, weight: .bold, design: .rounded))
                .monospacedDigit()
                .foregroundStyle(.primary)
                .lineLimit(1)
                .minimumScaleFactor(0.75)
                .contentTransition(.numericText())
        }
        .padding(12)
        .frame(maxWidth: .infinity, minHeight: 88, alignment: .leading)
        .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 10, style: .continuous))
        .overlay {
            if speedLevel >= .fast {
                RoundedRectangle(cornerRadius: 10, style: .continuous)
                    .fill(glowColor)
                    .animation(.easeInOut(duration: 1.2).repeatForever(autoreverses: true), value: speedLevel)
            }
        }
        .overlay {
            RoundedRectangle(cornerRadius: 10, style: .continuous)
                .stroke(tint.opacity(speedLevel >= .fast ? 0.35 : 0.18), lineWidth: speedLevel >= .fast ? 1.5 : 1)
        }
        .scaleEffect(speedLevel >= .blazing ? 1.015 : 1.0)
        .animation(.spring(response: 0.4, dampingFraction: 0.7), value: speedLevel)
    }

    private var sessionStats: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Label(translate(.session, lang: appLanguage), systemImage: "chart.bar.xaxis")
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundStyle(.primary)

                Spacer()

                Text(translate(.sessionSub, lang: appLanguage))
                    .font(.system(size: 10))
                    .foregroundStyle(.tertiary)
            }

            VStack(spacing: 8) {
                statRow(
                    label: translate(.totalUpload, lang: appLanguage),
                    value: ByteFormatters.totalBytes(monitor.sessionUploadBytes),
                    symbolName: "arrow.up.circle.fill",
                    tint: warmRed
                )

                statRow(
                    label: translate(.totalDownload, lang: appLanguage),
                    value: ByteFormatters.totalBytes(monitor.sessionDownloadBytes),
                    symbolName: "arrow.down.circle.fill",
                    tint: .green
                )

                Divider()
                    .opacity(0.35)

                statRow(
                    label: translate(.peakUpload, lang: appLanguage),
                    value: ByteFormatters.compactRate(monitor.peakUploadSpeed),
                    symbolName: "speedometer",
                    tint: warmRed
                )

                statRow(
                    label: translate(.peakDownload, lang: appLanguage),
                    value: ByteFormatters.compactRate(monitor.peakDownloadSpeed),
                    symbolName: "speedometer",
                    tint: .green
                )
            }
        }
        .padding(12)
        .background(Color.primary.opacity(0.045), in: RoundedRectangle(cornerRadius: 10, style: .continuous))
    }

    private func statRow(label: String, value: String, symbolName: String, tint: Color) -> some View {
        HStack(spacing: 9) {
            Image(systemName: symbolName)
                .font(.system(size: 11, weight: .semibold))
                .foregroundStyle(tint)
                .frame(width: 16)

            Text(label)
                .font(.system(size: 11, weight: .medium))
                .foregroundStyle(.secondary)
                .lineLimit(1)

            Spacer(minLength: 8)

            Text(value)
                .font(.system(size: 12, weight: .semibold))
                .monospacedDigit()
                .foregroundStyle(.primary)
                .lineLimit(1)
                .minimumScaleFactor(0.8)
        }
    }

    private func errorBanner(_ message: String) -> some View {
        HStack(alignment: .top, spacing: 8) {
            Image(systemName: "exclamationmark.triangle.fill")
                .font(.system(size: 12, weight: .semibold))
                .foregroundStyle(.orange)

            Text(message)
                .font(.system(size: 11, weight: .medium))
                .foregroundStyle(.secondary)
                .lineLimit(3)

            Spacer(minLength: 0)
        }
        .padding(10)
        .background(Color.orange.opacity(0.12), in: RoundedRectangle(cornerRadius: 9, style: .continuous))
    }

    private var actionGrid: some View {
        VStack(spacing: 8) {
            HStack(spacing: 8) {
                actionButton(translate(.refresh, lang: appLanguage), systemImage: "arrow.clockwise") {
                    monitor.refresh()
                }
                .help(appLanguage == .spanish ? "Tomar una lectura nueva" : "Take a new reading")

                actionButton(translate(.reset, lang: appLanguage), systemImage: "arrow.counterclockwise") {
                    monitor.resetSessionStats()
                }
                .help(appLanguage == .spanish ? "Reiniciar totales y picos de la sesión" : "Reset session totals and peaks")
            }

            HStack(spacing: 8) {
                actionButton(translate(.settings, lang: appLanguage), systemImage: "gearshape") {
                    monitor.openNetworkSettings()
                }
                .help(appLanguage == .spanish ? "Abrir Ajustes de Red de macOS" : "Open macOS Network Settings")

                actionButton(translate(.quit, lang: appLanguage), systemImage: "power", isDestructive: true) {
                    monitor.quit()
                }
                .help(appLanguage == .spanish ? "Cerrar Speed Tracker" : "Quit Speed Tracker")
            }
        }
    }

    private func actionButton(
        _ title: String,
        systemImage: String,
        isDestructive: Bool = false,
        action: @escaping () -> Void
    ) -> some View {
        Button(action: action) {
            HStack(spacing: 7) {
                Image(systemName: systemImage)
                    .font(.system(size: 12, weight: .semibold))
                    .frame(width: 15)

                Text(title)
                    .font(.system(size: 11, weight: .semibold))
                    .lineLimit(1)
                    .minimumScaleFactor(0.82)

                Spacer(minLength: 0)
            }
            .foregroundStyle(isDestructive ? Color.red : Color.primary)
            .padding(.horizontal, 10)
            .frame(maxWidth: .infinity, minHeight: 34, alignment: .leading)
            .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 8, style: .continuous))
            .contentShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
        }
        .buttonStyle(.plain)
    }

    private var dockToggle: some View {
        Button {
            showDockIcon.toggle()
            NSApp.setActivationPolicy(showDockIcon ? .regular : .accessory)
            UserDefaults.standard.set(showDockIcon, forKey: "showDockIcon")
        } label: {
            HStack(spacing: 7) {
                Image(systemName: showDockIcon ? "rectangle.on.rectangle" : "rectangle.dashed.badge.xmark")
                    .font(.system(size: 12, weight: .semibold))
                    .frame(width: 15)

                Text(showDockIcon ? translate(.hideDock, lang: appLanguage) : translate(.showDock, lang: appLanguage))
                    .font(.system(size: 11, weight: .semibold))
                    .lineLimit(1)
                    .minimumScaleFactor(0.82)

                Spacer(minLength: 0)
            }
            .foregroundStyle(showDockIcon ? Color.accentColor : Color.primary)
            .padding(.horizontal, 10)
            .frame(maxWidth: .infinity, minHeight: 34, alignment: .leading)
            .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 8, style: .continuous))
            .contentShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
        }
        .buttonStyle(.plain)
        .help(appLanguage == .spanish ? "Alternar icono en el Dock de macOS" : "Toggle macOS Dock icon")
    }

    private var lastUpdatedText: String {
        guard let lastUpdated = monitor.lastUpdated else {
            return translate(.updatedNever, lang: appLanguage)
        }

        return lastUpdated.formatted(date: .omitted, time: .shortened)
    }
}
