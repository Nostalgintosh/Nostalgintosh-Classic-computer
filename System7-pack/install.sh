#!/usr/bin/env bash
# System 7 pack installer for Fedora Kinoite (or any KDE Plasma distro).
# Everything goes into ~/.local — no rpm-ostree layering, no root, safe
# on immutable systems and survives upgrades/rollbacks.
#
#   ./install.sh             install all files, switch nothing
#   ./install.sh --apply     install AND switch the whole desktop over:
#                            icons, cursors, colors, window decoration,
#                            panel theme, wallpaper, Chicago fonts
#   ./install.sh --menubar   add a Mac-style top menu bar panel
#                            (global menu + clock)
#   ./install.sh --revert    switch back to Breeze defaults
set -euo pipefail

PACK="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SHARE="$HOME/.local/share"
ICON_DEST="$SHARE/icons/System7"
FONT_DEST="$SHARE/fonts/System7"
DATA_DEST="$SHARE/system7-pack"

kw() {
    command -v kwriteconfig6 2>/dev/null || command -v kwriteconfig5 2>/dev/null || true
}

qdb() {
    command -v qdbus6 2>/dev/null || command -v qdbus 2>/dev/null || true
}

set_icon_theme() {
    local theme="$1"
    if [[ -x /usr/libexec/plasma-changeicons ]]; then
        /usr/libexec/plasma-changeicons "$theme" >/dev/null 2>&1 && return 0
    fi
    local KW; KW="$(kw)"
    [[ -n "$KW" ]] && "$KW" --file kdeglobals --group Icons --key Theme "$theme"
}

refresh_kwin() {
    local QDBUS; QDBUS="$(qdb)"
    [[ -n "$QDBUS" ]] && "$QDBUS" org.kde.KWin /KWin reconfigure >/dev/null 2>&1 || true
}

install_files() {
    echo ">> Icons + cursors -> $ICON_DEST"
    mkdir -p "$ICON_DEST"
    cp -r "$PACK/icons/System7/." "$ICON_DEST/"

    echo ">> Fonts -> $FONT_DEST"
    mkdir -p "$FONT_DEST"
    cp "$PACK/fonts/"*.ttf "$FONT_DEST/"
    cp "$PACK/fonts/CREDITS.txt" "$PACK/fonts/ChicagoFLF-LICENSE.txt" "$FONT_DEST/" 2>/dev/null || true
    fc-cache -f "$FONT_DEST" >/dev/null

    echo ">> Color scheme -> $SHARE/color-schemes"
    mkdir -p "$SHARE/color-schemes"
    cp "$PACK/desktop/System7.colors" "$SHARE/color-schemes/"

    echo ">> Window decoration -> $SHARE/aurorae/themes/System7"
    mkdir -p "$SHARE/aurorae/themes"
    cp -r "$PACK/desktop/aurorae/System7" "$SHARE/aurorae/themes/"

    echo ">> Panel theme -> $SHARE/plasma/desktoptheme/System7"
    mkdir -p "$SHARE/plasma/desktoptheme"
    cp -r "$PACK/desktop/plasma-desktoptheme/System7" "$SHARE/plasma/desktoptheme/"

    echo ">> Wallpapers -> $DATA_DEST/wallpapers"
    mkdir -p "$DATA_DEST/wallpapers"
    cp "$PACK/wallpapers/"*.png "$DATA_DEST/wallpapers/"

    if command -v flatpak >/dev/null 2>&1; then
        echo ">> Granting Flatpak apps read access to icons/fonts"
        flatpak override --user --filesystem="$SHARE/icons:ro" 2>/dev/null || true
        flatpak override --user --filesystem="$SHARE/fonts:ro" 2>/dev/null || true
    fi
}

apply_all() {
    local KW; KW="$(kw)"
    echo ">> Applying System 7 look"

    set_icon_theme System7

    command -v plasma-apply-colorscheme >/dev/null 2>&1 \
        && plasma-apply-colorscheme System7 || true

    if command -v plasma-apply-cursortheme >/dev/null 2>&1; then
        plasma-apply-cursortheme System7 || true
    elif [[ -n "$KW" ]]; then
        "$KW" --file kcminputrc --group Mouse --key cursorTheme System7
    fi

    command -v plasma-apply-desktoptheme >/dev/null 2>&1 \
        && plasma-apply-desktoptheme System7 || true

    command -v plasma-apply-wallpaperimage >/dev/null 2>&1 \
        && plasma-apply-wallpaperimage "$DATA_DEST/wallpapers/system7-dither-3840x2160.png" || true

    if [[ -n "$KW" ]]; then
        # pinstriped Aurorae decoration, close box on the left
        "$KW" --file kwinrc --group org.kde.kdecoration2 --key library org.kde.kwin.aurorae
        "$KW" --file kwinrc --group org.kde.kdecoration2 --key theme __aurorae__svg__System7
        "$KW" --file kwinrc --group org.kde.kdecoration2 --key ButtonsOnLeft "X"
        "$KW" --file kwinrc --group org.kde.kdecoration2 --key ButtonsOnRight "IA"
        # Chicago for titles and menus
        "$KW" --file kdeglobals --group WM --key activeFont "ChicagoFLF,12,-1,5,50,0,0,0,0,0"
        "$KW" --file kdeglobals --group General --key menuFont "ChicagoFLF,11,-1,5,50,0,0,0,0,0"
    fi
    refresh_kwin
    echo "   Done. Log out and back in for everything to pick it up."
    echo "   Add the menu bar with:  ./install.sh --menubar"
    echo "   Undo everything with:   ./install.sh --revert"
}

add_menubar() {
    local QDBUS; QDBUS="$(qdb)"
    [[ -z "$QDBUS" ]] && { echo "qdbus not found - add a top panel manually."; exit 1; }
    echo ">> Adding Mac-style top menu bar (skips if a top panel exists)"
    "$QDBUS" org.kde.plasmashell /PlasmaShell org.kde.PlasmaShell.evaluateScript '
        var hasTop = false;
        panels().forEach(function (p) { if (p.location == "top") hasTop = true; });
        if (!hasTop) {
            var p = new Panel;
            p.location = "top";
            p.height = 28;
            p.addWidget("org.kde.plasma.appmenu");
            p.addWidget("org.kde.plasma.panelspacer");
            p.addWidget("org.kde.plasma.digitalclock");
        }' >/dev/null
    cat <<'EOF'
   Menu bar added. Notes:
   - Qt/KDE apps show their menus in it automatically. Most GTK and
     Electron apps do not export global menus - that is normal.
   - System 7 had no bottom taskbar: right-click your bottom panel >
     "Show Panel Configuration" > Remove Panel if you want to go all in.
     (Add a new one back anytime with right-click desktop > Add Panel.)
EOF
}

revert_all() {
    local KW; KW="$(kw)"
    [[ -z "$KW" ]] && { echo "kwriteconfig not found - revert manually in System Settings."; exit 1; }
    echo ">> Reverting to Breeze defaults"
    set_icon_theme breeze
    command -v plasma-apply-colorscheme >/dev/null 2>&1 \
        && plasma-apply-colorscheme BreezeLight || true
    command -v plasma-apply-cursortheme >/dev/null 2>&1 \
        && plasma-apply-cursortheme breeze_cursors || true
    command -v plasma-apply-desktoptheme >/dev/null 2>&1 \
        && plasma-apply-desktoptheme default || true
    "$KW" --file kwinrc --group org.kde.kdecoration2 --key library --delete || true
    "$KW" --file kwinrc --group org.kde.kdecoration2 --key theme --delete || true
    "$KW" --file kwinrc --group org.kde.kdecoration2 --key ButtonsOnLeft --delete || true
    "$KW" --file kwinrc --group org.kde.kdecoration2 --key ButtonsOnRight --delete || true
    "$KW" --file kdeglobals --group WM --key activeFont --delete || true
    "$KW" --file kdeglobals --group General --key menuFont --delete || true
    refresh_kwin
    echo "   Reverted. The top menu bar panel (if added) must be removed by hand:"
    echo "   right-click it > Show Panel Configuration > Remove Panel."
    echo "   Wallpaper: pick a new one in desktop settings."
}

case "${1:-}" in
    --apply)   install_files; apply_all ;;
    --menubar) add_menubar ;;
    --revert)  revert_all ;;
    *)
        install_files
        cat <<'EOF'

Files installed. Switch everything on with  ./install.sh --apply
or pick pieces manually in System Settings > Appearance & Style:

  Colors & Themes > Icons            -> System7
  Colors & Themes > Colors           -> System 7
  Colors & Themes > Cursors          -> System7
  Colors & Themes > Window Decorations -> System 7  (button layout:
       drag Close to the left side for the authentic close box)
  Colors & Themes > Plasma Style     -> System7
  Fonts: Window title -> ChicagoFLF 12pt, Menu -> ChicagoFLF 11pt
       (pixel-perfect bitmap option: ChiKareGo2 / FindersKeepers,
        exactly 12pt - other sizes blur)
  Wallpaper: right-click desktop > Configure Desktop and Wallpaper,
       pick a PNG from ~/.local/share/system7-pack/wallpapers
       - for the tile-64 files choose Positioning: Tiled

Then:  ./install.sh --menubar   for the Mac-style top menu bar.
EOF
        ;;
esac
