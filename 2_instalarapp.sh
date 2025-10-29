#!/bin/bash
#==============================================================
# 📦 Proyecto: Instalador modular y autoarranque de Waydroid
# 👤 Autor: Fran Galian — Ayuntamiento de Murcia
# 🏷️ Versión: 0.0.4 (release 20251028)
# 📅 Fecha de publicación: 29 de octubre de 2025
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

# Idioma y país
sudo waydroid shell settings put system system_locales es-ES
sudo waydroid shell settings put system system_language es
sudo waydroid shell settings put system system_country ES

# Tema oscuro
sudo waydroid shell settings put secure ui_night_mode 0   # 0=claro, 2=oscuro

# Girar pantalla
sudo waydroid shell settings put system accelerometer_rotation 1
sudo waydroid shell settings put system user_rotation 1


# Layout teclado
sudo waydroid shell settings put secure default_input_method com.android.inputmethod.latin/.LatinIME
sudo waydroid shell ime enable com.android.inputmethod.latin/.LatinIME

# Confirmar cambios
echo "✅ Configuración aplicada:"
sudo waydroid shell settings get system system_locales
sudo waydroid shell settings get secure ui_night_mode

echo "📱 Sistema Android configurado correctamente (idioma: español, tema claro)."


# Instalar APK si no está instalada
if [ -f "$APK_PATH" ]; then
  echo "📲 Instalando aplicación..."
  waydroid app install "$APK_PATH"
  echo "✅ Aplicación instalada correctamente."
else
  echo "⚙️  APK ya instalada o no encontrada."
fi

