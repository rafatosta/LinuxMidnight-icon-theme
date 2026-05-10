#!/usr/bin/env bash

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"

ALIASES_FILE="$ROOT_DIR/aliases/apps.txt"
BASE_DIR="$ROOT_DIR/scalable/apps"

echo "========================================"
echo " LinuxDark - Generate Symlinks"
echo "========================================"
echo

# Verifica se arquivo existe
if [ ! -f "$ALIASES_FILE" ]; then
    echo "Aliases file not found:"
    echo "$ALIASES_FILE"
    exit 1
fi

# Verifica se diretório existe
if [ ! -d "$BASE_DIR" ]; then
    echo "Apps directory not found:"
    echo "$BASE_DIR"
    exit 1
fi

echo "Cleaning old broken symlinks..."
find "$BASE_DIR" -xtype l -delete

echo
echo "Generating symlinks..."
echo

CREATED=0
SKIPPED=0
MISSING=0

while IFS=":" read -r original aliases || [ -n "$original" ]
do
    # Remove espaços extras
    original="$(echo "$original" | xargs)"
    aliases="$(echo "$aliases" | xargs)"

    # Ignora linhas vazias
    [ -z "$original" ] && continue

    # Ignora comentários
    [[ "$original" =~ ^# ]] && continue

    ORIGINAL_ICON="$BASE_DIR/$original.svg"

    # Verifica se ícone original existe
    if [ ! -f "$ORIGINAL_ICON" ]; then
        echo "[MISSING] $original.svg"
        ((MISSING+=1))
        continue
    fi

    # Divide aliases por vírgula
    IFS="," read -ra alias_array <<< "$aliases"

    for alias in "${alias_array[@]}"
    do
        # Remove espaços
        alias="$(echo "$alias" | xargs)"

        # Ignora vazio
        [ -z "$alias" ] && continue

        LINK_PATH="$BASE_DIR/$alias.svg"

        # Evita criar link para ele mesmo
        if [ "$alias" = "$original" ]; then
            echo "[SKIPPED] $alias.svg (same name)"
            ((SKIPPED+=1))
            continue
        fi

        # Se existir arquivo normal, ignora
        if [ -e "$LINK_PATH" ] && [ ! -L "$LINK_PATH" ]; then
            echo "[SKIPPED] $alias.svg already exists as regular file"
            ((SKIPPED+=1))
            continue
        fi

        # Cria symlink
        ln -sfn "$original.svg" "$LINK_PATH"

        echo "[LINKED] $alias.svg -> $original.svg"

        ((CREATED+=1))
    done

done < "$ALIASES_FILE"

echo
echo "========================================"
echo " Summary"
echo "========================================"
echo " Created : $CREATED"
echo " Skipped : $SKIPPED"
echo " Missing : $MISSING"
echo
echo "Done."