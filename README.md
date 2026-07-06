<picture>
  <source media="(prefers-color-scheme: dark)" srcset="https://img.shields.io/badge/Swift-5.9%2B-F05138?logo=swift&logoColor=white&style=flat-square">
  <img alt="Swift" src="https://img.shields.io/badge/Swift-5.9%2B-F05138?logo=swift&logoColor=white&style=flat-square">
</picture>
![macOS](https://img.shields.io/badge/macOS-13.0%2B-915C0D?logo=apple&logoColor=white&style=flat-square)
![License](https://img.shields.io/badge/license-MIT-3DA639?style=flat-square)
![Platform](https://img.shields.io/badge/Apple-Silicon_%7C_Intel-999999?logo=apple&style=flat-square)

<br />

<p align="center">
  <img src="SpeedTracker/Assets.xcassets/AppIcon.appiconset/icon_512x512.png" width="128" height="128" alt="Speed Tracker icon">
</p>

<h1 align="center">⚡ Speed Tracker</h1>

<p align="center">
  <b>Monitor de red en tiempo real desde la barra de menú de macOS</b><br />
  Velocidad de subida, descarga, estadísticas de sesión y más — todo en un panel elegante nativo.
</p>

<p align="center">
  <i>Hecho en SwiftUI con ❤️ por <a href="https://github.com/betho1822">Alberto Guerrero</a></i>
</p>

<br />

---

## 📸 Vista previa

> 🖼️ *Agrega aquí una captura del panel de Speed Tracker para que se vea cómo luce en acción.*  
> *Sugerencia: abre la app, haz clic en el icono de la barra de menú y toma un screenshot del panel desplegado.*

```
┌──────────────────────────────────────┐
│  ⚡ Speed Tracker        ● Activo    │
│  en0 · Wi-Fi/Ethernet                │
│  Actualizado 09:42                   │
│                                      │
│  ┌────────────┐  ┌────────────┐      │
│  │ ↑ Subida   │  │ ↓ Descarga │      │
│  │  1.2 MB/s  │  │  8.5 MB/s  │      │
│  └────────────┘  └────────────┘      │
│                                      │
│  Sesión — desde que abriste la app   │
│  Total subido        1.2 GB          │
│  Total descargado    5.8 GB          │
│  ────────────────────────────        │
│  Pico subida         3.1 MB/s        │
│  Pico descarga       12.8 MB/s       │
│                                      │
│  [Refrescar]  [Reiniciar]            │
│  [Ajustes de Red]  [Salir]           │
│  [Mostrar en Dock]                   │
│                                      │
│        Un desarrollo de              │
│         Alberto Guerrero             │
└──────────────────────────────────────┘
```

---

## ✨ Funcionalidades

- **Velocidad en tiempo real** — Subida y descarga actualizadas cada segundo.
- **Detección inteligente de interfaz** — Prioriza Wi-Fi/Ethernet sobre Tailscale/VPN.
- **Estadísticas de sesión** — Total subido/descargado y picos desde que abriste la app.
- **Indicador visual dinámico** — Brillo, color y etiqueta cambian según la velocidad:
  - 🔥 *¡Máxima!* — más de 10 Mbps
  - ⚡ *Rápido* — más de 5 Mbps
  - ✅ *Activo* — navegación normal
- **Panel elegante nativo** — Diseño con materiales, sombras y animaciones fluidas de SwiftUI.
- **Modo Dock opcional** — Muestra u oculta el icono del Dock desde el mismo panel.
- **Atajo a Ajustes de Red** — Abre las preferencias de red de macOS con un clic.
- **Universal binary** — Compatible con Apple Silicon y Mac Intel.

---

## 📦 Instalación

### Descarga directa

1. Descarga [`SpeedTracker.dmg`](https://github.com/betho1822/SpeedTracker/releases/latest) desde la página de [Releases](https://github.com/betho1822/SpeedTracker/releases).
2. Abre el DMG y arrastra **Speed Tracker** a la carpeta **Applications**.
3. Abre la app desde Launchpad o la carpeta Applications.
4. La primera vez macOS mostrará una advertencia por ser una app sin firmar por Apple Developer ID.  
   → Ve a **Preferencias del Sistema > Privacidad y Seguridad** y haz clic en **Abrir de todas formas**.

### Homebrew (próximamente)

```bash
brew tap betho1822/tap
brew install speed-tracker
```

---

## 🔧 Compilar desde código fuente

**Requisitos:**

- macOS 13.0+ (Ventura o superior)
- Xcode 15.0+ (Swift 5.9+)

**Pasos:**

```bash
git clone https://github.com/betho1822/SpeedTracker.git
cd SpeedTracker
open "Speed Tracker.xcodeproj"
```

Luego presiona **Cmd+R** en Xcode para compilar y ejecutar.

O desde terminal:

```bash
xcodebuild -project "Speed Tracker.xcodeproj" -scheme "Speed Tracker" -configuration Release build
```

El `.app` compilado aparecerá en `Build/Products/Release/`.

---

## 🏗️ Arquitectura

```
SpeedTracker/
├── NetworkMonitorApp.swift   # Entry point, Scene, lógica de menubar
├── MenuBarView.swift         # Panel completo de la interfaz
├── NetworkMonitor.swift      # Lógica de red, muestreo de interfaces
└── Formatters.swift          # Formateo compacto de bytes/tasas
```

| Archivo | Propósito |
|---------|-----------|
| `NetworkMonitorApp.swift` | Define la escena `MenuBarExtra`, alterna política de activación (Dock/menubar). |
| `MenuBarView.swift` | Todo el UI del panel: tarjetas de velocidad, estadísticas, botones de acción, toggle del Dock. |
| `NetworkMonitor.swift` | Muestrea interfaces de red vía `getifaddrs()`, calcula diferencias byte/s, detecta interfaz activa. |
| `Formatters.swift` | Utilidades para mostrar bytes en formato legible (`1.2 MB/s`, `5.8 GB`). |

---

## ⚙️ Requisitos del sistema

| Requisito | Versión |
|-----------|---------|
| macOS | 13.0 Ventura o superior |
| Hardware | Apple Silicon o Intel |
| Xcode (*para compilar*) | 15.0+ (Swift 5.9+) |

---

## 👤 Autor

**Alberto Guerrero**

[![GitHub](https://img.shields.io/badge/GitHub-betho1822-181717?logo=github&style=flat-square)](https://github.com/betho1822)
[![Twitter/X](https://img.shields.io/badge/X-%40betho1822-000000?logo=x&style=flat-square)](https://x.com/betho1822)

---

## ☕ Donaciones / Apoyo

Si Speed Tracker te es útil y quieres apoyar el desarrollo, puedes invitarme un café:

[![Buy Me a Coffee](https://img.shields.io/badge/Buy_Me_a_Coffee-FFDD00?logo=buy-me-a-coffee&logoColor=black&style=for-the-badge)](https://buymeacoffee.com/betho1822)
[![GitHub Sponsors](https://img.shields.io/badge/GitHub_Sponsors-30363D?logo=github-sponsors&style=for-the-badge)](https://github.com/sponsors/betho1822)

> *Cualquier aporte, por pequeño que sea, motiva a seguir mejorando el proyecto. ¡Gracias! 🙌*

---

## 🤝 Contribuir

¿Encontraste un bug? ¿Tienes una idea para mejorar Speed Tracker?

1. **Abre un [Issue](https://github.com/betho1822/SpeedTracker/issues)** — para reportar bugs o proponer features.
2. **Haz un fork, crea una rama y envía un Pull Request** — toda contribución es bienvenida.

Por favor, sé respetuoso y sigue el [Código de Conducta](CODE_OF_CONDUCT.md).

---

## 📄 Licencia

Este proyecto se distribuye bajo la licencia **MIT**.

```
MIT License

Copyright (c) 2026 Alberto Guerrero

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files...
```

Ver el archivo [LICENSE](LICENSE) para más detalles.

---

<p align="center">
  <sub>Hecho con ⚡ en Querétaro, México 🇲🇽</sub>
</p>
