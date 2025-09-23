#!/bin/bash

# Banner
echo "============================================="
echo " Log Rotator Script"
echo " Coded by Pakistani White Hat Hacker: Mr Sabaz Ali Khan"
echo "============================================="

# Configuration
LOG_DIR="/var/log"          # Directory containing logs
MAX_SIZE="10M"              # Max log size before rotation
BACKUP_DIR="/var/log/backup" # Directory for rotated logs
KEEP_DAYS=7                 # Days to keep rotated logs
COMPRESS="yes"              # Compress rotated logs (yes/no)

# Ensure backup directory exists
mkdir -p "$BACKUP_DIR"

# Function to rotate logs
rotate_log() {
    local log_file="$1"
    local timestamp=$(date +%Y%m%d_%H%M%S)
    local base_name=$(basename "$log_file")
    local backup_file="$BACKUP_DIR/${base_name%.*}_$timestamp.log"

    # Check if log exceeds max size
    if [ $(stat -c%s "$log_file") -gt $(numfmt --from=iec "$MAX_SIZE") ]; then
        echo "Rotating $log_file..."

        # Copy and truncate original log
        cp "$log_file" "$backup_file"
        : > "$log_file"

        # Compress if enabled
        if [ "$COMPRESS" = "yes" ]; then
            gzip "$backup_file"
            echo "Compressed to $backup_file.gz"
        fi
    fi
}

# Function to clean old logs
clean_old_logs() {
    find "$BACKUP_DIR" -type f -mtime +$KEEP_DAYS -exec rm -f {} \;
    echo "Cleaned logs older than $KEEP_DAYS days."
}

# Main process
echo "Starting log rotation process at $(date)"

# Check if log directory exists
if [ ! -d "$LOG_DIR" ]; then
    echo "Error: Log directory $LOG_DIR does not exist!"
    exit 1
fi

# Process each log file
for log_file in "$LOG_DIR"/*.log; do
    if [ -f "$log_file" ]; then
        rotate_log "$log_file"
    fi
done

# Clean old logs
clean_old_logs

echo "Log rotation completed at $(date)"
exit 0