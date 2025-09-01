#!/bin/bash

# Advanced Banner
banner() {
    echo -e "\e[1;32m"
    echo "   _____     _          _____          _   _  _____ "
    echo "  / ____|   | |        / ____|        | \ | |/ ____|"
    echo " | |   _   _| |__   ___| (___   ___  ___|  \| | |  __ "
    echo " | |  | | | | '_ \ / _ \\\___ \ / _ \/ _ \ . \` | | |_ |"
    echo " | |__| | |_| |_) |  __/____) |  __/  __/ |\  | |__| |"
    echo "  \_____|\__,_|_.__/ \___|_____/ \___|\___|_| \_|\_____|"
    echo ""
    echo "    Cyber Security Information Gathering Framework"
    echo "    =============================================="
    echo "    Coded by Pakistani White Hat Hacker Mr Sabaz Ali Khan"
    echo "    Version: 1.0 | Ethical Use Only"
    echo -e "\e[0m"
}

# Function to check if a tool is installed
check_tool() {
    if ! command -v "$1" &> /dev/null; then
        echo -e "\e[1;31mError: $1 is not installed. Please install it to use this feature.\e[0m"
        return 1
    fi
    return 0
}

# Main Menu
menu() {
    echo -e "\e[1;33mSelect an Information Gathering Tool:\e[0m"
    echo "1. Domain WHOIS Lookup"
    echo "2. DNS Enumeration (dig)"
    echo "3. Subdomain Enumeration (sublist3r)"
    echo "4. Email Harvesting (theHarvester)"
    echo "5. Network Scanning (nmap)"
    echo "6. Exit"
    read -p "Enter your choice: " choice
}

# Tool Functions
whois_lookup() {
    read -p "Enter domain: " domain
    if check_tool "whois"; then
        whois "$domain"
    fi
}

dns_enum() {
    read -p "Enter domain: " domain
    if check_tool "dig"; then
        dig any "$domain"
    fi
}

subdomain_enum() {
    read -p "Enter domain: " domain
    if check_tool "sublist3r"; then
        sublist3r -d "$domain"
    else
        echo -e "\e[1;31mSublist3r not found. Install via: pip install sublist3r\e[0m"
    fi
}

email_harvest() {
    read -p "Enter domain: " domain
    if check_tool "theHarvester"; then
        theHarvester -d "$domain" -l 500 -b google,linkedin,bing
    else
        echo -e "\e[1;31mtheHarvester not found. Install via: apt install theharvester or similar.\e[0m"
    fi
}

network_scan() {
    read -p "Enter target IP/Host: " target
    if check_tool "nmap"; then
        nmap -A "$target"
    fi
}

# Main Execution
banner
while true; do
    menu
    case $choice in
        1) whois_lookup ;;
        2) dns_enum ;;
        3) subdomain_enum ;;
        4) email_harvest ;;
        5) network_scan ;;
        6) echo -e "\e[1;32mExiting framework. Stay ethical!\e[0m"; exit 0 ;;
        *) echo -e "\e[1;31mInvalid choice. Try again.\e[0m" ;;
    esac
    echo ""
done