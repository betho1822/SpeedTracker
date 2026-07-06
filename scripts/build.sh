#!/bin/bash
set -e

APP_NAME="Speed Tracker"
DMG_FINAL="dist/Speed Tracker.dmg"
STAGING_DIR="tmp_staging"

echo "=== 1. Compilando aplicación en modo Release ==="
xcodebuild -project "Speed Tracker.xcodeproj" \
  -scheme "Speed Tracker" \
  -configuration Release \
  -derivedDataPath Build/DerivedData \
  build

APP_PATH="Build/DerivedData/Build/Products/Release/Speed Tracker.app"

if [ ! -d "$APP_PATH" ]; then
  echo "Error: No se encontró la aplicación compilada en $APP_PATH"
  exit 1
fi

echo "=== 2. Creando entorno temporal para DMG ==="
rm -rf "$STAGING_DIR"
mkdir -p "$STAGING_DIR"
mkdir -p dist

# Copiar aplicación y crear enlace a Applications
cp -R "$APP_PATH" "$STAGING_DIR/"
ln -s /Applications "$STAGING_DIR/Applications"

echo "=== 3. Generando DMG estándar limpio ==="
rm -f "$DMG_FINAL"
hdiutil create -srcfolder "$STAGING_DIR" -volname "$APP_NAME" -fs HFS+ -format UDZO -imagekey zlib-level=9 "$DMG_FINAL"

echo "=== 4. Limpiando archivos temporales ==="
rm -rf "$STAGING_DIR"

echo "=== ¡Éxito! DMG normal creado en: $DMG_FINAL ==="
