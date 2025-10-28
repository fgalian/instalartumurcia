<!--
==============================================================
📦 Proyecto: Instalador automático de Waydroid + App TuMurcia
👤 Autor: Fran Galian — Ayuntamiento de Murcia
🏷️ Versión: 0.0.1 (release 20251026)
📅 Fecha de publicación: 26 de octubre de 2025
📝 Descripción:
     Instalador minimalista para Ubuntu 24 Wayland Server que
     configura Waydroid en modo tótem (pantalla completa) y lanza
     automáticamente la aplicación Android "TuMurcia" al arranque.
==============================================================
-->

# 🚀 Instalador automático de Waydroid en modo Tótem (Ubuntu 24 Wayland Minimal)

Este proyecto instala y configura **Waydroid** sobre un entorno **Ubuntu Server 24.04 sin escritorio**,  
utilizando **Wayland + Cage**, pensado para **tótems interactivos y paneles públicos**  
que ejecutan Android a pantalla completa sin intervención del usuario.

---

## 🧩 Características principales

- ✅ Instalación completamente automática (un solo script).  
- ✅ Entorno **Wayland puro (sin X11 ni GNOME)**.  
- ✅ Uso de **Cage** para ejecutar Waydroid en pantalla completa.  
- ✅ Arranque directo de la aplicación **TuMurcia** (`es.aytomurcia.tumurcia`).  
- ✅ Compatible con Ubuntu 22.04 y 24.04 (basado en `noble`).  
- ⚙️ Diseñado para **sistemas tótem 24 h sin suspensión ni bloqueo**.

---

## 🧱 Estructura del proyecto

```
instalartumurcia/
├── instalar-waydroid-kiosk.sh     ← Instalador completo del entorno y app TuMurcia
└── app/
    └── mimurcia-x86_64.apk        ← APK de TuMurcia (instalación automática)
```

---

## ⚙️ Instalación paso a paso

1️⃣ **Clona el proyecto**:

```bash
git clone https://github.com/fgalian/instalartumurcia.git
cd instalartumurcia
```

2️⃣ **Da permisos y ejecuta el instalador**:

```bash
chmod +x instalar.sh
sudo ./instalar.sh
```

3️⃣ **Reinicia el sistema**:

```bash
sudo reboot
```

🟢 En el primer arranque:
- El usuario `ayto` inicia sesión automáticamente.  
- Se inicia el contenedor Waydroid.  
- Se instala la app `mimurcia-x86_64.apk` si no estaba.  
- Se lanza directamente **TuMurcia** en pantalla completa.

---

## 🧠 Personalización de la aplicación Android

Por defecto se lanza la app:

```bash
APK_PACKAGE="es.aytomurcia.tumurcia"
```

Si quieres usar otra, edita el script y cambia esa línea por el nombre de tu paquete:  
(puedes obtenerlo con `waydroid app list` tras instalar tu APK)

```bash
APK_PACKAGE="com.empresa.otraplicacion"
```

---

## 🖥️ Funcionamiento en modo tótem

El sistema:
- Configura **autologin** del usuario `ayto` en TTY1.  
- Lanza **Waydroid** mediante **Cage** en fullscreen.  
- Instala y ejecuta automáticamente la app Android configurada.  

Sin escritorio, sin login gráfico y sin ahorro de energía.

---

## 🔧 Comandos útiles

| Acción | Comando |
|--------|----------|
| Ver estado del contenedor | `sudo systemctl status waydroid-container` |
| Mostrar interfaz Android manualmente | `cage -s waydroid show-full-ui` |
| Listar apps Android instaladas | `waydroid app list` |
| Instalar APK manualmente | `waydroid app install ./app/archivo.apk` |
| Lanzar una app específica | `waydroid app launch com.paquete.app` |

---

## ⚙️ Requisitos mínimos

| Componente | Recomendado |
|-------------|-------------|
| CPU | Intel Core i3 o superior |
| RAM | ≥ 4 GB |
| GPU | Intel i915 o AMD con DRM activo |
| Sistema base | Ubuntu Server 22.04 / 24.04 |
| Entorno | Wayland + Cage |

---

## ⚡ Funcionamiento 24 h

Diseñado para uso continuo en entornos públicos:  
sin suspensión, sin ahorro de energía y con arranque directo en Android.

---

## 🧰 Desinstalación

```bash
sudo rm -f /home/ayto/.bash_profile
sudo rm -rf /etc/systemd/system/getty@tty1.service.d
sudo apt remove --purge -y waydroid cage weston
sudo apt autoremove -y
sudo reboot
```

---

## 📜 Licencia

Proyecto distribuido bajo licencia **MIT**.  
Libre de usar, modificar y redistribuir.

---

**Autor:**  
💻 Fran Galian — Ayuntamiento de Murcia  
🧠 Desarrollado para entornos Android embebidos sobre Linux Wayland.