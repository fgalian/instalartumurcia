#!/bin/bash
#==============================================================
# 📦 Proyecto: Instalador modular y autoarranque de Waydroid
# 👤 Autor: Fran Galian — Ayuntamiento de Murcia
# 🏷️ Versión: 0.0.2 (release 20251028)
# 📅 Fecha de publicación: 28 de octubre de 2025
# 📝 Descripción:
#      Instalación 100 % funcional de Waydroid en un entorno
#      Ubuntu Server Minimal (sin escritorio).
#      Usa Wayland + Cage + Seatd para ejecutar Android
#      a pantalla completa en modo tótem.
#==============================================================

set -e

USUARIO="ayto"
APK_PATH="./app/mimurcia-x86_64.apk"
APK_PACKAGE="es.aytomurcia.tumurcia"  # ⚠️ Cambiar si tu paquete es otro

echo "🧱 Instalando dependencias básicas..."
apt update -y
apt install -y \
  cage \
  seatd \
  mesa-utils \
  libgl1-mesa-dri \
  xdg-desktop-portal-wlr \
  dbus-user-session \
  systemd-resolved \
  udev \
  wget curl ca-certificates

echo "🔌 Habilitando y arrancando seatd..."
systemctl enable --now seatd

echo "📦 Instalando Waydroid..."
curl -s https://repo.waydro.id | bash
apt install -y waydroid

echo "🪄 Inicializando contenedor Waydroid..."
waydroid init || true
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
sudo -u ayto bash -c 'cat > ~/.bash_profile <<EOF
#!/bin/bash
# 🟢 Arranque automático Waydroid (modo tótem) en Ubuntu Server Minimal

if [[ "\$(tty)" == "/dev/tty1" ]]; then
  echo "🟢 Iniciando entorno gráfico (Cage + Waydroid)..."

  # Esperar hasta que el contenedor de Waydroid esté activo
  for i in {1..30}; do
    if systemctl is-active --quiet waydroid-container; then
      break
    fi
    echo "⏳ Esperando contenedor Waydroid..."
    sleep 2
  done

  # Lanzar Android en modo fullscreen
  exec cage -s -- waydroid show-full-ui
fi
EOF
chmod +x ~/.bash_profile
'


chmod +x /home/$USUARIO/.bash_profile
chown $USUARIO:$USUARIO /home/$USUARIO/.bash_profile

echo "📁 Copiando APK al directorio del usuario..."
mkdir -p /home/$USUARIO/app
if [ -f "$APK_PATH" ]; then
  cp "$APK_PATH" /home/$USUARIO/app/
  chown $USUARIO:$USUARIO /home/$USUARIO/app/mimurcia-x86_64.apk
  echo "✅ Copiado $APK_PATH → /home/$USUARIO/app/mimurcia-x86_64.apk"
else
  echo "⚠️ Aviso: no se encontró $APK_PATH, asegúrate de copiarlo antes del reinicio."
fi

echo "🧭 Desactivando suspensión y ahorro de energía..."
systemctl mask sleep.target suspend.target hibernate.target hybrid-sleep.target || true

echo "✅ Instalación completa."
echo "➡️  Reinicia el sistema con:  sudo reboot"
echo "📱 Tras el reinicio, Waydroid se abrirá automáticamente en pantalla completa."
