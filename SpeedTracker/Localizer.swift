import Foundation

enum AppLanguage: String, CaseIterable, Identifiable {
    case english = "en"
    case spanish = "es"
    
    var id: String { self.rawValue }
    
    var displayName: String {
        switch self {
        case .english: return "English"
        case .spanish: return "Español"
        }
    }
}

enum LocalizedKeys {
    case appName
    case upload
    case download
    case session
    case sessionSub
    case totalUpload
    case totalDownload
    case peakUpload
    case peakDownload
    case refresh
    case reset
    case settings
    case quit
    case showDock
    case hideDock
    case active
    case fast
    case blazing
    case noNetwork
    case noInterface
    case updated
    case updatedNever
    case credit
    case errorNoInterface
    case errorCannotRead
}

func translate(_ key: LocalizedKeys, lang: AppLanguage) -> String {
    switch lang {
    case .english:
        switch key {
        case .appName: return "Speed Tracker"
        case .upload: return "Upload"
        case .download: return "Download"
        case .session: return "Session"
        case .sessionSub: return "since app launch"
        case .totalUpload: return "Total Uploaded"
        case .totalDownload: return "Total Downloaded"
        case .peakUpload: return "Peak Upload"
        case .peakDownload: return "Peak Download"
        case .refresh: return "Refresh"
        case .reset: return "Reset"
        case .settings: return "Network Settings"
        case .quit: return "Quit"
        case .showDock: return "Show in Dock"
        case .hideDock: return "Hide from Dock"
        case .active: return "Active"
        case .fast: return "Fast"
        case .blazing: return "🔥 Maximum!"
        case .noNetwork: return "No Network"
        case .noInterface: return "No active interface"
        case .updated: return "Updated"
        case .updatedNever: return "no readings"
        case .credit: return "Developed by Alberto Guerrero"
        case .errorNoInterface: return "No active interface detected."
        case .errorCannotRead: return "Could not read network interfaces."
        }
    case .spanish:
        switch key {
        case .appName: return "Speed Tracker"
        case .upload: return "Subida"
        case .download: return "Descarga"
        case .session: return "Sesión"
        case .sessionSub: return "desde que abriste la app"
        case .totalUpload: return "Total subido"
        case .totalDownload: return "Total descargado"
        case .peakUpload: return "Pico subida"
        case .peakDownload: return "Pico descarga"
        case .refresh: return "Refrescar"
        case .reset: return "Reiniciar"
        case .settings: return "Ajustes de Red"
        case .quit: return "Salir"
        case .showDock: return "Mostrar en Dock"
        case .hideDock: return "Ocultar del Dock"
        case .active: return "Activo"
        case .fast: return "Rápido"
        case .blazing: return "🔥 ¡Máxima!"
        case .noNetwork: return "Sin red"
        case .noInterface: return "Sin interfaz activa"
        case .updated: return "Actualizado"
        case .updatedNever: return "sin lectura"
        case .credit: return "Un desarrollo de Alberto Guerrero"
        case .errorNoInterface: return "No se detectó interfaz activa."
        case .errorCannotRead: return "No se pudieron leer las interfaces de red."
        }
    }
}
