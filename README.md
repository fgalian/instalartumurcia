<!--
=========================================================================
📦 Proyecto: Instalador modular y autoarranque de Waydroid
👤 Autor: Fran Galian — Ayuntamiento de Murcia
🏷️ Versión: 0.0.3 (release 20251028)
📅 Fecha de publicación: 28 de octubre de 2025
📝 Descripción:
     Instalador modular para entornos Wayland minimalistas,
     que instala y configura Waydroid en modo tótem (pantalla completa),
     con arranque automático, sin escritorio Ubuntu ni ahorro de energía.
==========================================================================
-->

# 🚀 Instalador modular de Waydroid (Ubuntu 24 Wayland Minimal)

Este proyecto instala y configura **Waydroid** sobre un entorno **Ubuntu Server 24.04 minimal (sin escritorio)**,  
utilizando **Wayland + Cage + Seatd**, diseñado para sistemas tipo **tótem interactivo**  
que deben ejecutar Android a pantalla completa las 24 h, sin suspensión ni bloqueo.

---

## 🧩 Características principales

- ✅ Instalación modular en **dos fases** (entorno + app).  
- ✅ Usa **Wayland puro**, sin X11 ni GNOME.  
- ✅ Integra **Cage + Seatd** para entorno gráfico seguro.  
- ✅ Arranque automático con **autologin en TTY1**.  
- ✅ Desactiva suspensión e hibernación del sistema.  
- ✅ Copia e instala la APK **TuMurcia** (`mimurcia-x86_64.apk`).  
- ⚙️ Ideal para **tótems 24/7 y paneles públicos interactivos**.

---

## 🧱 Estructura del proyecto

```
instalartumurcia/
├── 1_instalar.sh       ← Instala entorno Wayland + Waydroid
├── 2_instalarapp.sh    ← Instala la aplicación Android (TuMurcia)
└── app/
    └── mimurcia-x86_64.apk   ← APK de la app
```

---

## ⚙️ Instalación paso a paso

1️⃣ **Clona el proyecto y entra en el directorio:**

```bash
git clone https://github.com/fgalian/instalartumurcia.git
cd instalartumurcia
```

2️⃣ **Ejecuta el instalador principal:**

```bash
chmod +x 1_instalar.sh
sudo ./1_instalar.sh
```

3️⃣ **Reinicia el sistema:**

```bash
sudo reboot
```

4️⃣ **Instala la aplicación Android (tras el reinicio):**

```bash
chmod +x 2_instalarapp.sh
sudo ./2_instalarapp.sh
```

---

## 🖥️ Funcionamiento en modo tótem

- El sistema configura autologin en TTY1 para el usuario `ayto`.  
- Se lanza automáticamente **Cage** y **Waydroid** en modo fullscreen.  
- La aplicación Android se ejecuta sin intervención del usuario.  
- Se desactivan suspensión y ahorro de energía.  

---

## 🔧 Personalización

Si tu aplicación Android tiene otro nombre de paquete, edita la variable en `2_instalarapp.sh`:

```bash
PKG="com.empresa.otraplicacion"
```

Puedes listar los paquetes instalados con:

```bash
waydroid app list
```

---

## 🧠 Comandos útiles

| Acción | Comando |
|--------|----------|
| Ver estado del contenedor Waydroid | `sudo systemctl status waydroid-container` |
| Mostrar Android manualmente | `cage -s -- waydroid show-full-ui` |
| Instalar APK manualmente | `waydroid app install ./app/archivo.apk` |
| Lanzar una app específica | `waydroid app launch com.paquete.app` |

---

## ⚡ Requisitos mínimos

| Componente | Recomendado |
|-------------|-------------|
| CPU | Intel Core i3 o superior |
| RAM | ≥ 4 GB |
| GPU | Intel i915 o AMD con DRM activo |
| Sistema base | Ubuntu Server 22.04 / 24.04 |
| Entorno | Wayland + Cage + Seatd |

---

## 🧰 Desinstalación

```bash
sudo rm -f /home/ayto/.bash_profile
sudo rm -rf /etc/systemd/system/getty@tty1.service.d
sudo apt remove --purge -y waydroid cage seatd weston
sudo apt autoremove -y
sudo reboot
```

---

## 🪄 Changelog

**v0.0.4 (29 oct 2025)**  
- Añadida configuración automática del idioma y región (`es-ES`).  
- Añadido ajuste de teclado por defecto (LatinIME).  
- Añadido tema visual claro/oscuro configurable.  
- Implementado arranque automático de la app **TuMurcia** (`es.aytomurcia.tumurcia`).  
- Soporte para **rotación de pantalla** mediante `WL_OUTPUTS` (modo vertical u horizontal).  
- Mejoras menores en la secuencia de arranque (espera dinámica hasta que Android complete el boot).  

**v0.0.3 (28 oct 2025)**  
- Separación del instalador en dos scripts (entorno + app).  
- Añadido soporte `Seatd` y permisos `video`/`render`.  
- Creación automática de `~/.bash_profile` con autoinicio.  
- Desactivación de suspensión e hibernación.  
- Copia segura de la APK antes del reinicio.

**v0.0.1 (26 oct 2025)**  
- Versión inicial de instalador único.  
- Configuración básica de Waydroid y autologin.  

---

## 📜 Licencia

Proyecto distribuido bajo licencia **MIT**.  
Libre de usar, modificar y redistribuir.

---

**Autor:**  
💻 Fran Galian — Ayuntamiento de Murcia  
🧠 Desarrollado para entornos Android embebidos sobre Linux Wayland.