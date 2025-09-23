#!/bin/bash

# Banner
echo "============================================================="
echo "          Failed Login Monitor Script"
echo "          Coded by Pakistani White Hat Hacker"
echo "          Mr Sabaz Ali Khan"
echo "============================================================="

# Check if script is run as root
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root"
   exit 1
fi

# Log file to monitor (common auth log locations)
LOG_FILE="/var/log/auth.log"
if [ ! -f "$LOG_FILE" ]; then
    LOG_FILE="/var/log/secure"
fi

# Check if log file exists
if [ ! -f "$LOG_FILE" ]; then
    echo "Error: Log file not found. Please check your system configuration."
    exit 1
fi

# Output file for failed login attempts
OUTPUT_FILE="/var/log/failed_logins_$(date +%F).log"

# Monitor failed login attempts
echo "Monitoring failed login attempts..."
echo "Logging to: $OUTPUT_FILE"
echo "Press Ctrl+C to stop monitoring"

# Create or clear output file
> "$OUTPUT_FILE"

# Function to process failed login attempts
process_failed_logins() {
    tail -n 0 -f "$LOG_FILE" | grep --line-buffered "Failed password" | while read -r line; do
        timestamp=$(date '+%Y-%m-%d %H:%M:%S')
        ip=$(echo "$line" | grep -oE '[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+' | head -1)
        user=$(echo "$line" | grep -oE 'for [a-zA-Z0-9_-]+' | awk '{print $2}')
        service=$(echo "$line" | grep -oE 'sshd|sudo|login' | head -1)
        
        if [ -n "$ip" ] && [ -n "$user" ]; then
            echo "[$timestamp] Failed login attempt - User: $user, IP: $ip, Service: $service" >> "$OUTPUT_FILE"
            echo "[$timestamp] Failed login attempt - User: $user, IP: $ip, Service: $service"
        fi
    done
}

# Trap Ctrl+C to display summary
trap 'echo -e "\nMonitoring stopped. Check $OUTPUT_FILE for details."; exit 0' INT

# Start monitoring
process_failed_logins