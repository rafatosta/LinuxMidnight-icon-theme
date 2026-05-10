#!/usr/bin/env bash

set -Eeuo pipefail

# ========================================
# LinuxDark Icon Theme - Dev Installer
# ========================================

THEME_NAME="LinuxDark-icon-theme"

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
TARGET_DIR="$HOME/.local/share/icons/$THEME_NAME"

ALIASES_FILE="$ROOT_DIR/aliases/apps.txt"
APPS_DIR="$ROOT_DIR/scalable/apps"

CREATED=0
SKIPPED=0
MISSING=0

echo "========================================"
echo " LinuxDark Icon Theme - Dev Install"
echo "========================================"
echo

# ========================================
# CHECK PROJECT STRUCTURE
# ========================================

echo "[1/7] Checking project structure..."
echo

required_dirs=(
    "$ROOT_DIR/scalable/apps"
    "$ROOT_DIR/scalable/actions"
    "$ROOT_DIR/scalable/places"
    "$ROOT_DIR/scalable/status"
)

for dir in "${required_dirs[@]}"
do
    if [ ! -d "$dir" ]; then
        echo "[ERROR] Missing directory:"
        echo "$dir"
        exit 1
    fi
done

if [ ! -f "$ROOT_DIR/index.theme" ]; then
    echo "[ERROR] index.theme not found"
    exit 1
fi

echo "[OK] Project structure valid"

# ========================================
# GENERATE SYMLINKS
# ========================================

echo
echo "[2/7] Generating symlinks..."
echo

if [ -f "$ALIASES_FILE" ]; then

    echo "Cleaning broken symlinks..."
    find "$APPS_DIR" -xtype l -delete

    while IFS=":" read -r original aliases || [ -n "${original:-}" ]
    do
        original="$(echo "${original:-}" | xargs)"
        aliases="$(echo "${aliases:-}" | xargs)"

        # Ignore empty lines
        [ -z "$original" ] && continue

        # Ignore comments
        [[ "$original" =~ ^# ]] && continue

        ORIGINAL_ICON="$APPS_DIR/$original.svg"

        # Original icon missing
        if [ ! -f "$ORIGINAL_ICON" ]; then
            echo "[MISSING] $original.svg"
            ((MISSING+=1))
            continue
        fi

        IFS="," read -ra alias_array <<< "$aliases"

        for alias in "${alias_array[@]}"
        do
            alias="$(echo "$alias" | xargs)"

            [ -z "$alias" ] && continue

            # Avoid same-name link
            if [ "$alias" = "$original" ]; then
                echo "[SKIPPED] $alias.svg (same name)"
                ((SKIPPED+=1))
                continue
            fi

            LINK_PATH="$APPS_DIR/$alias.svg"

            # Existing regular file
            if [ -e "$LINK_PATH" ] && [ ! -L "$LINK_PATH" ]; then
                echo "[SKIPPED] $alias.svg already exists"
                ((SKIPPED+=1))
                continue
            fi

            ln -sfn "$original.svg" "$LINK_PATH"

            echo "[LINKED] $alias.svg -> $original.svg"

            ((CREATED+=1))
        done

    done < "$ALIASES_FILE"

else
    echo "[INFO] aliases/apps.txt not found"
fi

echo
echo "Symlink summary:"
echo "  Created : $CREATED"
echo "  Skipped : $SKIPPED"
echo "  Missing : $MISSING"

# ========================================
# INSTALL THEME
# ========================================

echo
echo "[3/7] Installing theme..."
echo

mkdir -p "$HOME/.local/share/icons"

rm -rf "$TARGET_DIR"

cp -r "$ROOT_DIR" "$TARGET_DIR"

echo "[OK] Theme installed"
echo "$TARGET_DIR"

# ========================================
# UPDATE GTK CACHE
# ========================================

echo
echo "[4/7] Updating icon cache..."
echo

if command -v gtk-update-icon-cache >/dev/null 2>&1; then

    gtk-update-icon-cache -f -t "$TARGET_DIR" || true

    echo "[OK] GTK cache updated"

else
    echo "[WARNING] gtk-update-icon-cache not found"
fi

# ========================================
# UPDATE DESKTOP DATABASE
# ========================================

echo
echo "[5/7] Updating desktop database..."
echo

if command -v update-desktop-database >/dev/null 2>&1; then

    update-desktop-database "$HOME/.local/share/applications" || true

    echo "[OK] Desktop database updated"

else
    echo "[WARNING] update-desktop-database not found"
fi

# ========================================
# UPDATE MIME DATABASE
# ========================================

echo
echo "[6/7] Updating MIME database..."
echo

if command -v update-mime-database >/dev/null 2>&1; then

    update-mime-database "$HOME/.local/share/mime" || true

    echo "[OK] MIME database updated"

else
    echo "[WARNING] update-mime-database not found"
fi

# ========================================
# CLEAN CACHE
# ========================================

echo
echo "[7/7] Cleaning old caches..."
echo

rm -rf "$HOME/.cache/icon-cache.kcache" 2>/dev/null || true

echo "[OK] Cache cleaned"

# ========================================
# DONE
# ========================================

echo
echo "========================================"
echo " Installation completed"
echo "========================================"
echo
echo "Theme installed at:"
echo
echo "  $TARGET_DIR"
echo
echo "If icons do not refresh immediately:"
echo
echo "GNOME X11:"
echo "  ALT + F2 -> r"
echo
echo "Wayland:"
echo "  logout/login"
echo
echo "KDE Plasma:"
echo "  kquitapp5 plasmashell && kstart5 plasmashell"
echo
echo "XFCE:"
echo "  xfdesktop --reload"
echo
echo "Done."