#!/usr/bin/env bash

set -Eeuo pipefail

# ========================================
# LinuxMidnight Icon Theme - Dev Installer
# ========================================

THEME_NAME="LinuxMidnight"

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
TARGET_DIR="$HOME/.local/share/icons/$THEME_NAME"

CREATED=0
SKIPPED=0
MISSING=0

echo "========================================"
echo " LinuxMidnight Icon Theme - Dev Install"
echo "========================================"
echo

# ========================================
# CONTEXTS
# ========================================

declare -A CONTEXTS=(
    ["apps"]="scalable/apps"
    ["places"]="scalable/places"
    ["mimetypes"]="scalable/mimetypes"
    ["devices"]="scalable/devices"
    ["actions"]="scalable/actions"
    ["status"]="scalable/status"
)

# ========================================
# VALIDATE STRUCTURE
# ========================================

echo "[1/6] Validating project structure..."
echo

required_dirs=(
    "$ROOT_DIR/scalable"
    "$ROOT_DIR/aliases"
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
# GENERATE ALIASES
# ========================================

echo
echo "[2/6] Generating aliases..."
echo

process_alias_file() {

    local context="$1"
    local aliases_file="$ROOT_DIR/aliases/$context.txt"
    local base_dir="$ROOT_DIR/${CONTEXTS[$context]}"

    echo "----------------------------------------"
    echo " Context: $context"
    echo "----------------------------------------"

    # Alias file missing
    if [ ! -f "$aliases_file" ]; then
        echo "[INFO] aliases/$context.txt not found"
        echo
        return
    fi

    # Target directory missing
    if [ ! -d "$base_dir" ]; then
        echo "[INFO] Directory not found:"
        echo "$base_dir"
        echo
        return
    fi

    # Remove broken symlinks
    find "$base_dir" -xtype l -delete

    while IFS=":" read -r original aliases || [ -n "${original:-}" ]
    do
        original="$(echo "${original:-}" | xargs)"
        aliases="$(echo "${aliases:-}" | xargs)"

        # Ignore empty lines
        [ -z "$original" ] && continue

        # Ignore comments
        [[ "$original" =~ ^# ]] && continue

        ORIGINAL_ICON="$base_dir/$original.svg"

        # Original icon missing
        if [ ! -f "$ORIGINAL_ICON" ]; then
            echo "[MISSING] $context/$original.svg"
            ((MISSING+=1))
            continue
        fi

        # Split aliases
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

            LINK_PATH="$base_dir/$alias.svg"

            # Existing regular file
            if [ -e "$LINK_PATH" ] && [ ! -L "$LINK_PATH" ]; then
                echo "[SKIPPED] $context/$alias.svg already exists"
                ((SKIPPED+=1))
                continue
            fi

            # Create symlink
            ln -sfn "$original.svg" "$LINK_PATH"

            echo "[LINKED] $context/$alias.svg -> $original.svg"

            ((CREATED+=1))
        done

    done < "$aliases_file"

    echo
}

for context in "${!CONTEXTS[@]}"
do
    process_alias_file "$context"
done

echo "Alias summary:"
echo "  Created : $CREATED"
echo "  Skipped : $SKIPPED"
echo "  Missing : $MISSING"

# ========================================
# INSTALL THEME
# ========================================

echo
echo "[3/6] Installing theme..."
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
echo "[4/6] Updating GTK icon cache..."
echo

if command -v gtk-update-icon-cache >/dev/null 2>&1; then

    gtk-update-icon-cache -f -t "$TARGET_DIR" || true

    echo "[OK] GTK cache updated"

else
    echo "[WARNING] gtk-update-icon-cache not found"
fi

# ========================================
# UPDATE DESKTOP + MIME DATABASES
# ========================================

echo
echo "[5/6] Updating desktop databases..."
echo

if command -v update-desktop-database >/dev/null 2>&1; then

    update-desktop-database "$HOME/.local/share/applications" || true

    echo "[OK] Desktop database updated"

else
    echo "[WARNING] update-desktop-database not found"
fi

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
echo "[6/6] Cleaning old caches..."
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