# Contribuyendo a Speed Tracker

Gracias por tu interés en contribuir. Eres bienvenido aunque sea tu primera
vez en open source.

## Cómo contribuir

1. **Reporta bugs o propón ideas**  
   Abre un [Issue](https://github.com/betho1822/SpeedTracker/issues) y
   describe lo que encontraste o lo que te gustaría ver.

2. **Envía un Pull Request**  
   - Haz un fork del repo.  
   - Crea una rama descriptiva (`git checkout -b feature/nueva-funcionalidad`).  
   - Haz tus cambios y asegúrate de que compile.  
   - Abre un PR contra `main` y describe qué cambia y por qué.

## Estándares

- Sigue el estilo de código existente (Swift, SwiftUI).
- Mantén compatibilidad con macOS 13.0+.
- Comentarios en español o inglés, lo que te sea más natural.
- Sé respetuoso — revisa nuestro [Código de Conducta](CODE_OF_CONDUCT.md).

## Compilar antes de enviar

```bash
xcodebuild -project "Speed Tracker.xcodeproj" \
           -scheme "Speed Tracker" \
           -configuration Release build
```

Si compila, tu PR está listo para revisión.
