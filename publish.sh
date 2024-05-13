#!/bin/bash

set -eou pipefail

# Script settings

OUTPUT_NAME="game"
BUTLER_NAME="okayscott/lospec-shmup"
BUTLER_CHANNEL_SUFFIX="-dev"

GODOT=godot4

# Navigate to this script's directory
cd "$(dirname "$(realpath "${BASH_SOURCE[0]}")")"

# Add ./bin dir to path
PATH="$PATH:$(pwd)/bin"
export PATH

# Add .env file
[[ -f ./.env ]] && source ./.env

# if [ -n "$(git status --porcelain)" ]; then
#     echo "Error: Uncommitted or untracked changes."
#     exit 1
# fi

# butler nix package is broken, download manually
if ! type butler > /dev/null; then
    (
        mkdir -p bin
        cd bin
        curl -L "https://broth.itch.ovh/butler/linux-amd64/LATEST/archive/default" -o butler.zip
        unzip butler.zip
    )
fi

echo "Godot: $($GODOT --version)"
echo "Butler: $(butler --version 2>&1)"

# log in and write key to .env
if [[ -z "${BUTLER_API_KEY:-}" ]]; then
    butler login
    (
        echo
        printf "BUTLER_API_KEY="
        cat ~/.config/itch/butler_creds
        echo
    ) >> .env
fi

timestamp="$(date "+%Y-%m-%d %H:%M:%S")"
gitrev="$(git rev-parse --short HEAD 2>/dev/null)"

godot_export() {
    local preset="$1"
    local channel="$2"
    local output_name="$3"

    local output_dir="build/$channel"
    local log_file="build/build.log"

    mkdir -p "$output_dir"

    echo "Building $preset"
    echo "Building $preset from $gitrev at $timestamp" >> "$log_file"

    (
        cd project
        $GODOT --headless --export-release "$preset" \
            "../$output_dir/$output_name" >> "../$log_file" 2>&1 \
            || (echo "Error. Check log file: $log_file" && exit 2)
    )

    local butler_dir="$output_dir"
    if [[ "$output_name" == *.zip ]]; then
        butler_dir="$output_dir/$output_name"
    fi

    butler push "$butler_dir" "$BUTLER_NAME:$channel$BUTLER_CHANNEL_SUFFIX"
}

[[ -d "build/" ]] && rm -rf "build/"

godot_export "Web" "web" "index.html"
godot_export "Windows Desktop" "windows" "$OUTPUT_NAME.zip"
godot_export "macOS" "osx" "$OUTPUT_NAME.zip"
godot_export "Linux/X11" "linux" "$OUTPUT_NAME.zip"

echo "Done"
