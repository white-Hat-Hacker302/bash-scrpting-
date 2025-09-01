#!/bin/bash

# Banner
echo "============================================="
echo "  Social Media Account Information Gatherer  "
echo "  Coded by Pakistani White Hacker Mr Sabaz Ali Khan  "
echo "============================================="
echo ""

# Function to gather account information
gather_info() {
    echo "Enter Social Media Platform (e.g., Twitter, Instagram, Facebook):"
    read platform
    echo "Enter Username:"
    read username
    echo "Enter Profile URL (optional, press Enter to skip):"
    read url
    echo "Enter any additional notes (optional, press Enter to skip):"
    read notes

    # Save to file
    echo "Platform: $platform" >> social_media_info.txt
    echo "Username: $username" >> social_media_info.txt
    echo "Profile URL: $url" >> social_media_info.txt
    echo "Notes: $notes" >> social_media_info.txt
    echo "-------------------" >> social_media_info.txt
    echo "Information saved to social_media_info.txt"
}

# Main menu
while true; do
    echo "1. Add new social media account info"
    echo "2. View saved information"
    echo "3. Exit"
    echo "Select an option (1-3):"
    read choice

    case $choice in
        1)
            gather_info
            ;;
        2)
            if [ -f social_media_info.txt ]; then
                cat social_media_info.txt
            else
                echo "No information saved yet."
            fi
            ;;
        3)
            echo "Exiting..."
            exit 0
            ;;
        *)
            echo "Invalid option, please try again."
            ;;
    esac
    echo ""
done