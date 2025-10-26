#!/bin/bash
#==============================================================
# 📦 Proyecto: Instalador modular y autoarranque de Waydroid
# 👤 Autor: Fran Galian — Ayuntamiento de Murcia
# 🏷️ Versión: 0.0.1 (release 20251026)
# 📅 Fecha de publicación: 26 de octubre de 2025
# 📝 Descripción:
#      Sistema de instalación modular para entornos Wayland minimalistas,
#      que instala y configura Waydroid en modo tótem (pantalla completa),
#      con arranque automático, sin escritorio Ubuntu ni ahorro de energía.
#==============================================================

set -e

USUARIO="ayto"
APK_PATH="./app/mimurcia-x86_64.apk"
APK_PACKAGE="es.aytomurcia.tumurcia"   # ⚠️ Cambia esto si tu paquete tiene otro nombre

echo "🧱 Instalando dependencias básicas..."
apt update -y
apt install -y cage mesa-utils libgl1-mesa-dri xdg-desktop-portal-wlr dbus-user-session systemd-resolved udev wget curl ca-certificates

echo "📦 Instalando Waydroid..."
curl -s https://repo.waydro.id | bash
apt install -y waydroid

echo "🪄 Inicializando contenedor Waydroid..."
waydroid init
systemctl enable --now waydroid-container

echo "🔧 Configurando permisos de vídeo/render para $USUARIO..."
usermod -aG video $USUARIO
usermod -aG render $USUARIO

echo "⚙️  Configurando autologin en tty1..."
mkdir -p /etc/systemd/system/getty@tty1.service.d
cat <<EOF >/etc/systemd/system/getty@tty1.service.d/override.conf
[Service]
ExecStart=
ExecStart=-/sbin/agetty --autologin $USUARIO --noclear %I \$TERM
Type=simple
EOF

systemctl daemon-reload
systemctl restart getty@tty1

echo "🧩 Creando script de inicio automático para Waydroid..."
sudo -u $USUARIO bash -c "cat > /home/$USUARIO/.bash_profile <<'EOF'
#!/bin/bash

if [[ \"\$(tty)\" == \"/dev/tty1\" ]]; then
  echo '🟢 Iniciando Waydroid kiosk...'
  for i in {1..10}; do
    if systemctl is-active --quiet waydroid-container; then
      break
    fi
    echo '⏳ Esperando contenedor Waydroid...'
    sleep 2
  done

  APK_PATH=\"/home/$USER/app/mimurcia-x86_64.apk\"
  APK_PACKAGE=\"com.fgtech.mimurcia\"  # ⚠️ Cambia si tu app tiene otro paquete

  if [ -f \"\$APK_PATH\" ]; then
    echo \"📲 Instalando app desde \$APK_PATH...\"
    waydroid app install \"\$APK_PATH\" || true
  fi

  # Esperar que Waydroid esté completamente listo
  sleep 3

  echo \"🚀 Lanzando app TuMurcia (\$APK_PACKAGE)...\"
  waydroid app launch \"\$APK_PACKAGE\" || echo \"⚠️ No se pudo lanzar la app.\"

  # Mostrar Android en fullscreen (por si la app se cierra)
  exec cage -s waydroid show-full-ui
fi
EOF"

chmod +x /home/$USUARIO/.bash_profile
chown $USUARIO:$USUARIO /home/$USUARIO/.bash_profile

echo "📁 Copiando APK al directorio del usuario..."
mkdir -p /home/$USUARIO/app
if [ -f "$APK_PATH" ]; then
  cp "$APK_PATH" /home/$USUARIO/app/
  chown $USUARIO:$USUARIO /home/$USUARIO/app/mimurcia-x86_64.apk
  echo "✅ Copiado $APK_PATH → /home/$USUARIO/app/mimurcia-x86_64.apk"
else
  echo "⚠️ Aviso: no se encontró $APK_PATH, asegúrate de que existe antes de reiniciar."
fi

echo "✅ Instalación completa."
echo "➡️  Reinicia el sistema con:  sudo reboot"
echo "📱 Tras el reinicio, Waydroid se abrirá y lanzará automáticamente TuMurcia en pantalla completa."
