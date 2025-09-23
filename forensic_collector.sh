#!/bin/bash

# Banner
echo "============================================================="
echo "         Forensic Collector - Digital Forensics Tool          "
echo "       Coded by Mr. Sabaz Ali Khan, Pakistani White Hat Hacker"
echo "============================================================="

# Function to check if script is run as root
check_root() {
    if [ "$EUID" -ne 0 ]; then
        echo "This script must be run as root!"
        exit 1
    fi
}

# Function to create output directory with timestamp
setup_output_dir() {
    TIMESTAMP=$(date +%Y%m%d_%H%M%S)
    OUTPUT_DIR="forensic_collection_$TIMESTAMP"
    mkdir -p "$OUTPUT_DIR"
    echo "Output directory created: $OUTPUT_DIR"
}

# Function to collect system information
collect_system_info() {
    echo "Collecting system information..."
    {
        echo "=== System Information ==="
        uname -a > "$OUTPUT_DIR/system_info.txt"
        lscpu >> "$OUTPUT_DIR/system_info.txt"
        cat /proc/meminfo >> "$OUTPUT_DIR/system_info.txt"
        df -h >> "$OUTPUT_DIR/system_info.txt"
        echo "System information collected in $OUTPUT_DIR/system_info.txt"
    }
}

# Function to collect network information
collect_network_info() {
    echo "Collecting network information..."
    {
        echo "=== Network Information ==="
        ifconfig > "$OUTPUT_DIR/network_info.txt" 2>/dev/null || ip addr show > "$OUTPUT_DIR/network_info.txt"
        netstat -tuln >> "$OUTPUT_DIR/network_info.txt"
        arp -a >> "$OUTPUT_DIR/network_info.txt"
        echo "Network information collected in $OUTPUT_DIR/network_info.txt"
    }
}

# Function to collect process information
collect_process_info() {
    echo "Collecting process information..."
    {
        echo "=== Process Information ==="
        ps aux > "$OUTPUT_DIR/process_info.txt"
        echo "Process information collected in $OUTPUT_DIR/process_info.txt"
    }
}

# Function to collect user information
collect_user_info() {
    echo "Collecting user information..."
    {
        echo "=== User Information ==="
        cat /etc/passwd > "$OUTPUT_DIR/user_info.txt"
        cat /etc/group >> "$OUTPUT_DIR/user_info.txt"
        last >> "$OUTPUT_DIR/user_info.txt"
        echo "User information collected in $OUTPUT_DIR/user_info.txt"
    }
}

# Function to collect system logs
collect_logs() {
    echo "Collecting system logs..."
    {
        mkdir -p "$OUTPUT_DIR/logs"
        cp /var/log/syslog "$OUTPUT_DIR/logs/syslog" 2>/dev/null || cp /var/log/messages "$OUTPUT_DIR/logs/messages" 2>/dev/null
        cp /var/log/auth.log "$OUTPUT_DIR/logs/auth.log" 2>/dev/null
        echo "System logs collected in $OUTPUT_DIR/logs/"
    }
}

# Function to collect file system information
collect_filesystem_info() {
    echo "Collecting file system information..."
    {
        echo "=== File System Information ==="
        ls -la / > "$OUTPUT_DIR/filesystem_root.txt"
        find / -type f -mtime -1 > "$OUTPUT_DIR/recent_files.txt" 2>/dev/null
        echo "File system information collected in $OUTPUT_DIR/"
    }
}

# Function to create archive of collected data
create_archive() {
    echo "Creating archive of collected data..."
    tar -czf "forensic_collection_$TIMESTAMP.tar.gz" "$OUTPUT_DIR"
    echo "Archive created: forensic_collection_$TIMESTAMP.tar.gz"
}

# Main function
main() {
    check_root
    setup_output_dir
    collect_system_info
    collect_network_info
    collect_process_info
    collect_user_info
    collect_logs
    collect_filesystem_info
    create_archive
    echo "============================================================="
    echo "Forensic collection completed successfully!"
    echo "Coded by Mr. Sabaz Ali Khan, Pakistani White Hat Hacker"
    echo "============================================================="
}

# Execute main function
main