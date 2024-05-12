#!/bin/bash

set -eou pipefail

OUTPUT_NAME="game"

# if [ -n "$(git status --porcelain)" ]; then
#     echo "Error: Uncommitted or untracked changes."
#     exit 1
# fi

godot4 --version

timestamp="$(date "+%Y-%m-%d %H:%M:%S")"
gitrev="$(git rev-parse --short HEAD 2>/dev/null)"

godot_export() {
    local preset="$1"
    local output_dir="$2"
    local output_name="$3"

    local log_file="$output_dir/build.log"

    mkdir -p "$output_dir"

    echo "Building $preset"
    echo "Building $preset from $gitrev at $timestamp" > "$log_file"

    (
        cd project
        godot4 --export-release "$preset" \
            "../$output_dir/$output_name" >> "../$log_file" 2>&1 \
            || (echo "Error. Check log file: $log_file" && exit 2)
    )
}

[[ -d "build/" ]] && rm -rf "build/"

godot_export "Web" "build/web" "index.html"
godot_export "Windows Desktop" "build/windows" "$OUTPUT_NAME.zip"
godot_export "macOS" "build/osx" "$OUTPUT_NAME.zip"
godot_export "Linux/X11" "build/linux" "$OUTPUT_NAME.zip"

echo "Done"
