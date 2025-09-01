#!/bin/bash

# Banner
clear
echo "============================================================="
echo "          WiFi Monitoring Tool"
echo "          Coded by Pakistani White Hacker: Mr Sabaz Ali Khan"
echo "============================================================="
echo ""

# Check if nmcli is installed
if ! command -v nmcli &> /dev/null; then
    echo "Error: nmcli is not installed. Please install NetworkManager."
    exit 1
fi

# Check if script is run with sudo (required for some nmcli operations)
if [[ $EUID -ne 0 ]]; then
    echo "This script requires root privileges. Please run with sudo."
    exit 1
fi

# Function to scan and display WiFi networks
scan_wifi() {
    echo "Scanning for WiFi networks..."
    echo "-----------------------------------"
    # Use nmcli to scan WiFi networks and format output
    nmcli -f SSID,SIGNAL,CHAN,SECURITY device wifi list --rescan yes | awk 'NR>1 {print "SSID: "$1"\tSignal: "$2"%\tChannel: "$3"\tSecurity: "$4}'
    echo "-----------------------------------"
}

# Function to monitor WiFi continuously
monitor_wifi() {
    echo "Starting continuous WiFi monitoring (Press Ctrl+C to stop)..."
    while true; do
        clear
        echo "============================================================="
        echo "          WiFi Monitoring Tool"
        echo "          Coded by Pakistani White Hacker: Mr Sabaz Ali Khan"
        echo "============================================================="
        echo ""
        scan_wifi
        sleep 5 # Refresh every 5 seconds
    done
}

# Main menu
echo "WiFi Monitoring Tool Options:"
echo "1. Scan WiFi Networks (One-time)"
echo "2. Monitor WiFi Networks (Continuous)"
echo "3. Exit"
read -p "Choose an option (1-3): " choice

case $choice in
    1)
        scan_wifi
        ;;
    2)
        monitor_wifi
        ;;
    3)
        echo "Exiting..."
        exit 0
        ;;
    *)
        echo "Invalid option. Exiting..."
        exit 1
        ;;
esac