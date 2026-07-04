# System 7 Pack for Fedora Kinoite

Turn KDE Plasma into a Macintosh Classic II running System 7: icons,
fonts, cursors, colors, pinstriped window decorations, the gray
stippled desktop, and a real top menu bar. Built for immutable Fedora
(Kinoite/Silverblue): everything installs into your home directory —
**no `rpm-ostree` layering, no root, no reboot.**

## What's inside

```
system7-pack/
├── icons/System7/           KDE icon theme: 23 hand-pixeled System 7
│   ├── scalable/            icons (folders, trash, happy Mac, floppy,
│   │                        CD, documents...), Breeze fallback
│   └── cursors/             cursor theme: the arrow, I-beam, the
│                            wristwatch wait cursor, pointing hand
├── fonts/
│   ├── ChicagoFLF.ttf       Chicago, vector, public domain
│   ├── ChiKareGo2.ttf       Chicago, pixel-perfect at 12pt (CC-BY)
│   └── FindersKeepers.ttf   Geneva 9, pixel-perfect at 12pt (CC-BY)
├── desktop/
│   ├── System7.colors       color scheme: white windows, black
│   │                        selection, balloon-help yellow tooltips
│   ├── aurorae/System7/     window decoration: pinstriped title bar,
│   │                        glyph-free close box, zoom + collapse
│   │                        boxes, buttons vanish on inactive windows
│   └── plasma-desktoptheme/ panel theme: white menu bar with 1px
│                            black underline
├── wallpapers/              the 50% gray dither desktop pattern
│                            (several sizes + tiles + platinum)
├── tools/                   generators for icons, cursors, wallpapers
└── install.sh
```

The icons, cursors, decoration and wallpapers are original pixel art
drawn in the System 7 style; the fonts are freeware/openly-licensed
recreations (see `fonts/CREDITS.txt`). No Apple-copyrighted assets.

## Install (on the Kinoite machine)

Copy this folder over (USB, `scp`, git — anything), then:

```bash
cd system7-pack
chmod +x install.sh
./install.sh --apply     # install + switch the whole desktop over
./install.sh --menubar   # add the Mac-style top menu bar
```

Log out and back in afterwards so every app picks up the theme.
`./install.sh` alone installs files without switching anything
(it prints the manual System Settings steps), and
`./install.sh --revert` returns to Breeze defaults.

### What --apply switches

| Piece            | Set to                                          |
|------------------|--------------------------------------------------|
| Icons            | System7 (falls back to Breeze where uncovered)   |
| Cursors          | System7 (arrow, wristwatch, I-beam...)           |
| Colors           | System 7 (white windows, black selection)        |
| Window deco      | Aurorae "System 7", close box moved to the left  |
| Plasma style     | System7 (white panel, black underline)           |
| Wallpaper        | 50% gray dither                                  |
| Title/menu fonts | ChicagoFLF 12pt / 11pt                           |

### The menu bar

`--menubar` adds a 28px top panel with the Global Menu applet, a
spacer, and a clock — Qt/KDE apps put their File/Edit menus up there
automatically, like a real Mac. GTK and Electron apps mostly don't
support global menus; their menus stay in-window.

For the full effect, remove the bottom taskbar (System 7 had none):
right-click it → Show Panel Configuration → Remove Panel. Launch apps
from the menu or add a slim auto-hiding panel back later.

### Going full Classic II (black & white)

The Classic II had a 1-bit monochrome screen. For maximum authenticity:

* Wallpaper: use `system7-dither-tile-64.png` with Positioning →
  **Tiled** (pixel-exact dither), or the pre-rendered
  `system7-dither-*.png` at your native resolution.
* Fonts: set General to **FindersKeepers 12pt** and Fixed width to
  ChiKareGo2 12pt. Pixel fonts are razor-sharp at exactly 12pt
  (16px) or whole multiples and blurry at anything else. ChicagoFLF
  is vector and works at any size.
* Disable desktop effects you find too modern: System Settings →
  Apps & Windows → Window Management → Desktop Effects (blur,
  translucency, wobbly anything).

## Customizing

All pixel art is generated from plain-Python scripts (no deps):

```bash
cd tools
python3 generate_icons.py ../icons preview.png    # icons
python3 generate_extras.py ..                     # cursors + wallpapers
./install.sh                                      # reinstall
```

## Limits and notes for Kinoite

* Nothing touches the ostree deployment; `rpm-ostree upgrade` and
  rollbacks are unaffected.
* The login screen (SDDM) stays stock — theming it needs system-level
  changes, deliberately out of scope.
* Widget internals (buttons, scrollbars) still render with Breeze
  geometry — colors, fonts, icons and decorations carry the look.
  A pixel-perfect System 7 widget style would need a custom Qt style
  engine.
* Flatpak apps get read access to the icon/font dirs via
  `flatpak override --user` (done by the installer). Sandboxed GTK
  apps may additionally want:
  `flatpak override --user --env=ICON_THEME=System7`
* No system sounds included — the classic beeps are Apple-copyrighted.
