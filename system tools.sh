#!/bin/bash

# Banner
echo "---------------------------------------------------"
echo "     System Maintenance Toolset"
echo "     Coded by Pakistani White Hat Hacker"
echo "           Mr Sabaz Ali Khan"
echo "---------------------------------------------------"

# Function to display the menu
display_menu() {
    echo -e "\nSystem Maintenance Toolset Menu:"
    echo "1. Check Disk Usage"
    echo "2. Monitor CPU and Memory Usage"
    echo "3. Clean Temporary Files"
    echo "4. Update System"
    echo "5. Exit"
}

# Function to check disk usage
check_disk_usage() {
    echo -e "\nChecking Disk Usage..."
    df -h
}

# Function to monitor CPU and memory usage
monitor_system() {
    echo -e "\nMonitoring CPU and Memory Usage..."
    top -bn1 | head -n 10
}

# Function to clean temporary files
clean_temp_files() {
    echo -e "\nCleaning Temporary Files..."
    sudo rm -rf /tmp/*
    echo "Temporary files cleaned."
}

# Function to update the system
update_system() {
    echo -e "\nUpdating System..."
    sudo apt-get update && sudo apt-get upgrade -y
    echo "System updated successfully."
}

# Main loop
while true; do
    display_menu
    read -p "Enter your choice (1-5): " choice

    case $choice in
        1)
            check_disk_usage
            ;;
        2)
            monitor_system
            ;;
        3)
            clean_temp_files
            ;;
        4)
            update_system
            ;;
        5)
            echo "Exiting..."
            exit 0
            ;;
        *)
            echo "Invalid choice! Please select a valid option."
            ;;
    esac
    read -p "Press Enter to continue..."
done