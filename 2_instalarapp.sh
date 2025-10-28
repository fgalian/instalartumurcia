#!/bin/bash
#==============================================================
# 📦 Proyecto: Instalador modular y autoarranque de Waydroid
# 👤 Autor: Fran Galian — Ayuntamiento de Murcia
# 🏷️ Versión: 0.0.3 (release 20251028)
# 📅 Fecha de publicación: 28 de octubre de 2025
# 📝 Descripción:
#      Instalación 100 % funcional de Waydroid en un entorno
#      Ubuntu Server Minimal (sin escritorio).
#      Usa Wayland + Cage + Seatd para ejecutar Android
#      a pantalla completa en modo tótem.
#==============================================================
set -e

USUARIO="ayto"
APK_PATH="/home/$USUARIO/app/mimurcia-x86_64.apk"
PKG="es.aytomurcia.tumurcia"   # cambia si el nombre de paquete es distinto

# Esperar a que Waydroid esté listo
for i in {1..30}; do
  if waydroid status 2>/dev/null | grep -q "RUNNING"; then
    break
  fi
  echo "⏳ Esperando Waydroid..."
  sleep 2
done

# Si no arranca, salir
if ! waydroid status 2>/dev/null | grep -q "RUNNING"; then
  echo "❌ Waydroid no está activo. Abortando instalación de APK."
  exit 1
fi

# Instalar APK si no está instalada
if [ -f "$APK_PATH" ]; then
  echo "📲 Instalando aplicación..."
  waydroid app install "$APK_PATH"
  echo "✅ Aplicación instalada correctamente."
else
  echo "⚙️  APK ya instalada o no encontrada."
fi

