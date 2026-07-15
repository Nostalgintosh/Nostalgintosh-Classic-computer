# Nostalgintosh-Classic_Doculogue
This is for my small computer I created in a Macintosh Classic II case and I use Manjaro KDE Plasma operating system

# 🍏 Project Nostalgintosh
**A Cyber-Archeology Build: 1991 Chassis, 2026 Soul.**

![Status](https://img.shields.io/badge/Status-Operational-success)
![OS](https://img.shields.io/badge/OS-Fedora%20Kinoite-blue)
![Theme](https://img.shields.io/badge/Aesthetic-System%207%20Platinum-grey)

![Macintosh Classic](Macintosh.jpg

## 📖 About The Project
**Nostalgintosh** is a "Restomod" computer project that fits modern, immutable Linux architecture inside a vintage **Macintosh Classic II** chassis. 

Unlike typical Raspberry Pi emulators, this project runs a full-desktop **Atomic Linux** OS (Fedora Kinoite), customized to replicate the **System 7** environment of the early 90s while maintaining modern web browsing and development capabilities.

---

## 🛠️ Hardware Specifications
| Component | Details |
| :--- | :--- |
| **Chassis** | Original Macintosh Classic II (circa 1991) |
| **Display** | Retro-fitted 9" LCD Panel (Custom Mount) |
| **Compute** | x86_64 Architecture (Modern Laptop Mainboard/Mini PC) |
| **Input** | USB Keyboard/Mouse (ADB Converters planned) |

---

## 💾 The Software Stack: "Atomic Nostalgia"
Instead of a standard Linux distro that can break with updates, this build uses **Fedora Kinoite**. This ensures the "Console-like" reliability of the original Macintosh.

* **Base OS:** Fedora Kinoite (Immutable KDE Plasma).
* **Package Management:** `rpm-ostree` (Base) & `Flatpak` (Apps).
* **Browser:** Brave (Sandboxed via Flatpak).
* **Terminal:** Konsole (Themed as "SimpleText").

---

## 🎨 Aesthetic Configuration (The "System 7" Recipe)
Achieving the 1991 "Platinum" look on a 2026 operating system requires specific manual overrides.

### 1. The "Platinum" Window Manager
We replaced the modern rounded "Big Sur" style with hard-edged, pixel-perfect borders.
* **Theme:** `KDE Story` / `Platinum` (Window Decorations).
* **Controls:** Removed Maximize/Minimize buttons (Close & Collapse only).
* **Colors:** High-contrast White/Black/Grey.

### 2. Typography: The Return of Chicago
The interface uses a modern TrueType recreation of Susan Kare's original **Chicago** font.
* **Font File:** `ChicagoFLF.ttf`
* **Installation Path:** `~/.local/share/fonts/`
* **Rendering:** Anti-aliasing **Enabled**, Sub-pixel rendering **OFF**, Hinting **FULL**. (This forces the "crisp" pixelated look).

### 3. Desktop Environment
* **Wallpaper:** Solid Grey (`#808080`) to mimic the original 1-bit dither pattern.
* **Top Bar:** 24px height, Apple Logo Menu (Left), Clock (Right), Empty Center.
* **Dock:** "NeXTSTEP" style floating dock for modern utility (Brave, Terminal, Dolphin).

---

## 🚀 Installation & Reproduction
If you are building your own Nostalgintosh, here are the core setup commands used in this build.

### Enable Flatpak & Install Brave
```bash
# Add Flathub Repository
flatpak remote-add --if-not-exists flathub [https://dl.flathub.org/repo/flathub.flatpakrepo](https://dl.flathub.org/repo/flathub.flatpakrepo)

# Install Brave Browser
flatpak install flathub com.brave.Browser
```

## Classic Mac OS System 7 Window Decorations on Fedora Kinoite 41 (KDE Plasma)

A guide to installing retro Mac OS System 7 / Platinum-era window decorations on Fedora Kinoite 41 (Atomic KDE Plasma).

---

## Overview

Fedora Kinoite is an immutable (atomic) desktop that uses KDE Plasma. Because the root filesystem is read-only, all theming is done in **userspace** — no package layering required for Aurorae window decorations. KDE's Aurorae theme engine renders window decorations from SVG files stored in your home directory, making it perfectly suited for atomic desktops.

---

## Available Themes

### 1. "macos system7" — Aurorae Window Decoration

A dedicated System 7-inspired window decoration built for KDE's Aurorae engine.

| | |
|---|---|
| **KDE Store** | [https://store.kde.org/p/1119098](https://store.kde.org/p/1119098) |
| **Type** | Aurorae Window Decoration |
| **Style** | Classic Mac OS System 7 (black & white, pinstriped title bar) |

### 2. "Platinum" — Aurorae Window Decoration (by nielsvm)

A retro Platinum-inspired theme for KWin's Aurorae theme engine. Part of a larger "Platinum retro" look-and-feel package.

| | |
|---|---|
| **GitHub** | [https://github.com/nielsvm/kde-aurorae-platinum](https://github.com/nielsvm/kde-aurorae-platinum) |
| **KDE Store** | Search "Platinum" in Window Decorations |
| **Look & Feel** | [https://store.kde.org/p/1320042](https://store.kde.org/p/1320042) |
| **Full L&F Repo** | [https://github.com/nielsvm/kde-look-and-feel-platinum](https://github.com/nielsvm/kde-look-and-feel-platinum) |
| **Type** | Aurorae Window Decoration + optional full Global Theme |
| **Style** | Mac OS 8/9 Platinum appearance |

---

## Installation

### Method A: Via System Settings (Recommended)

KDE's built-in "Get New" downloader installs themes to `~/.local/share/`, so it works natively on Kinoite without touching the immutable root filesystem.

1. Open **System Settings**
2. Navigate to **Colors & Themes → Window Decorations**
3. Click **"Get New Window Decorations..."**
4. Search for **"system7"** or **"Platinum"**
5. Click **Install** on the desired theme
6. Select the theme from the list
7. Set **Window border size** to **Normal**
8. Click **Apply**

### Method B: Manual Installation

If the KDE Store download doesn't work, or you want to install from GitHub:

```bash
# Create the Aurorae themes directory if it doesn't exist
mkdir -p ~/.local/share/aurorae/themes/

# Option 1: Clone the Platinum theme from GitHub
git clone https://github.com/nielsvm/kde-aurorae-platinum.git /tmp/platinum-theme
cp -r /tmp/platinum-theme/Platinum ~/.local/share/aurorae/themes/

# Option 2: Download and extract from KDE Store
# Download the .tar.gz from https://store.kde.org/p/1119098
# Then extract:
tar -xzf <downloaded-file>.tar.gz -C ~/.local/share/aurorae/themes/
```

After copying the files, open **System Settings → Colors & Themes → Window Decorations** and select the newly installed theme.

### Method C: Full Platinum Look & Feel (Global Theme)

For the complete retro Platinum experience (window decorations + color scheme + Plasma style):

```bash
# Clone the full look-and-feel package
git clone https://github.com/nielsvm/kde-look-and-feel-platinum.git /tmp/platinum-laf

# Install the look-and-feel package
cp -r /tmp/platinum-laf/Platinum ~/.local/share/plasma/look-and-feel/
```

Then apply it via **System Settings → Colors & Themes → Global Theme**.

---

## Complementary Theming (Optional)

To go beyond window decorations and achieve a more complete classic Mac look:

### Color Scheme

- **Platinum** color scheme: [https://store.kde.org/p/1123528](https://store.kde.org/p/1123528)
- Install to: `~/.local/share/color-schemes/`

### Kvantum Application Style

For Qt application styling that matches the Platinum look, community members have created Kvantum themes:

- Search the KDE Store for **"Mac9Kvantum"** or **"QPlatinum"** under Kvantum themes
- Install Kvantum on Kinoite:
  ```bash
  rpm-ostree install kvantum
  ```
  *(This requires a reboot since it layers a package)*

### Icon Themes

- **NineIcons** (enhanced by drgordbord): combines classic Mac OS 9 icons with Platinum9 and Chicago95 assets
- Available on the KDE Store tagged `macos9`, `platinum`

### Titlebar Button Layout

To move window buttons to the left (Mac-style):

1. Go to **System Settings → Colors & Themes → Window Decorations**
2. Click **"Configure Titlebar Buttons..."**
3. Drag the Close, Maximize, and Minimize buttons to the **left** side
4. Remove any unwanted buttons by dragging them to the area below
5. Click **Apply**

---

## Important Notes for Kinoite Users

- **Aurorae themes install to your home directory** (`~/.local/share/aurorae/themes/`) and do not require package layering or modifying the immutable root filesystem.
- **KDE's "Get New" system** downloads directly to userspace — it does not use `rpm-ostree`.
- **SDDM login themes** are the one exception — they install to `/usr/share/sddm/themes/` which is read-only on Kinoite. This is a known limitation.
- **Global Themes** that include only Plasma styles, color schemes, and Aurorae decorations will work fine since they all install to `~/.local/share/`.
- If the "Get New" dialog fails to download, manually download the archive from the KDE Store and extract it to the appropriate `~/.local/share/` subdirectory.

---

## File Locations Reference

| Component | User Install Path |
|---|---|
| Aurorae Window Decorations | `~/.local/share/aurorae/themes/` |
| Plasma / Desktop Themes | `~/.local/share/plasma/desktoptheme/` |
| Global Themes / Look & Feel | `~/.local/share/plasma/look-and-feel/` |
| Color Schemes | `~/.local/share/color-schemes/` |
| Icon Themes | `~/.local/share/icons/` |
| Kvantum Themes | `~/.config/Kvantum/` |

---

## Related Projects

| Project | Description | Link |
|---|---|---|
| kde-aurorae-platinum | Platinum Aurorae window decoration | [GitHub](https://github.com/nielsvm/kde-aurorae-platinum) |
| kde-look-and-feel-platinum | Full Platinum look & feel package | [GitHub](https://github.com/nielsvm/kde-look-and-feel-platinum) |
| macos system7 | System 7 Aurorae decoration | [KDE Store](https://store.kde.org/p/1119098) |
| Platinum9 | Mac OS 9 theme (Xfce-focused) | [GitHub](https://github.com/grassmunk/Platinum9) |
| Chicago95 | Windows 95 theme (Xfce, experimental KDE) | [GitHub](https://github.com/grassmunk/Chicago95) |

---

## License

This guide is provided as-is. Individual themes are licensed by their respective authors — check each project's repository for license details.
