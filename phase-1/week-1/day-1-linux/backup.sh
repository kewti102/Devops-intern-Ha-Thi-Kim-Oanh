#!/usr/bin/env bash

set -euo pipefail

show_help() {
cat << EOF
Usage:
    ./backup.sh <directory>

Options:
    -h, --help      Show help
EOF
}

if [[ $# -eq 0 ]]; then
    show_help
    exit 1
fi

case "${1:-}" in
    -h|--help)
        show_help
        exit 0
        ;;
esac

dir="$1"

if [[ ! -d "$dir" ]]; then
    echo "Error: directory does not exist"
    exit 1
fi

mkdir -p "$HOME/backups"

timestamp=$(date +%Y%m%d-%H%M%S)

dirname_only=$(basename "$dir")

archive="$HOME/backups/${dirname_only}-${timestamp}.tar.gz"

backup_directory() {
    tar -czf "$archive" "$dir"
}

backup_directory

file_count=$(find "$dir" -type f | wc -l)

total_size=$(du -sh "$dir" | awk '{print $1}')

echo "Backup created:"
echo "$archive"

echo "Files backed up: $file_count"
echo "Total size: $total_size"
