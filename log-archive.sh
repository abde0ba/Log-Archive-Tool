#!/bin/bash

if [ "$#" -ne 1 ]; then
    echo "Usage: log-archive.sh <log_directory>"
    exit 1
fi

LOG_DIR="$1"

if [ ! -d "$LOG_DIR" ]; then
    echo "Error: Directory $LOG_DIR does not exist."
    exit 1
fi

# Create archive directory if it doesn't exist
ARCHIVE_DIR="./archives"
mkdir -p "$ARCHIVE_DIR"

# Find all .log files
log_files=("$LOG_DIR"/*.log)
[ -e "${log_files[0]}" ] || { echo "No log files found in $LOG_DIR"; exit 0; }


archive_name="logs_archive_$(date +%Y%m%d_%H%M%S).tar.gz"

# check tar command availability
if ! command -v tar &> /dev/null; then
    echo "Error: tar command not found. Please install tar to use this script."
    exit 1
fi
tar -czf "$ARCHIVE_DIR/$archive_name" -C "$LOG_DIR" "${log_files[@]##*/}"

echo "Archived ${#log_files[@]} log files to $archive_name"

# Log the archive operation
echo "$(date '+%Y-%m-%d %H:%M:%S') Archived ${#log_files[@]} files to $archive_name" >> "$ARCHIVE_DIR/archive.log"

# Ask user if they want to delete original logs
read -p "Do you want to delete the original log files? [y/N]: " response
case "$response" in
    [yY][eE][sS]|[yY])
        rm -f "${log_files[@]}"
        echo "Original log files deleted."
        ;;
    *)
        echo "Original log files retained."
        ;;
esac

exit 0