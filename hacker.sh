#!/bin/bash

# World's Number One Information Gathering Tool
# Coded by Pakistani White Hat Hacker Mr. Sabaz Ali Khan
# For ethical reconnaissance only. Use responsibly!

# Function to display advanced banner
display_banner() {
    clear
    echo ""
    echo "+------------------------------------------------------------------------------+"
    echo "¦                                                                              ¦"
    echo "¦    ¦¦¦¦¦¦+ ¦¦¦¦¦¦¦+¦¦¦+   ¦¦+¦¦¦¦¦¦¦+ ¦¦¦¦¦+ ¦¦¦¦¦¦¦¦+¦¦+  ¦¦+¦¦¦¦¦¦¦+       ¦"
    echo "¦    ¦¦+--¦¦+¦¦+----+¦¦¦¦+  ¦¦¦¦¦+----+¦¦+--¦¦++--¦¦+--+¦¦¦  ¦¦¦¦¦+----+       ¦"
    echo "¦    ¦¦¦¦¦¦++¦¦¦¦¦+  ¦¦+¦¦+ ¦¦¦¦¦¦¦¦+  ¦¦¦¦¦¦¦¦   ¦¦¦   ¦¦¦¦¦¦¦¦¦¦¦¦¦+         ¦"
    echo "¦    ¦¦+--¦¦+¦¦+--+  ¦¦¦+¦¦+¦¦¦¦¦+--+  ¦¦+--¦¦¦   ¦¦¦   ¦¦+--¦¦¦¦¦+--+         ¦"
    echo "¦    ¦¦¦  ¦¦¦¦¦¦¦¦¦¦+¦¦¦ +¦¦¦¦¦¦¦¦¦¦¦¦+¦¦¦  ¦¦¦   ¦¦¦   ¦¦¦  ¦¦¦¦¦¦¦¦¦¦+       ¦"
    echo "¦    +-+  +-++------++-+  +---++------++-+  +-+   +-+   +-+  +-++------+       ¦"
    echo "¦                                                                              ¦"
    echo "¦                    ¦¦+  ¦¦+¦¦¦¦¦¦¦+¦¦¦+   ¦¦¦+¦¦+   ¦¦+¦¦+  ¦¦+              ¦"
    echo "¦                    ¦¦¦  ¦¦¦¦¦+----+¦¦¦¦+ ¦¦¦¦¦¦¦¦   ¦¦¦¦¦¦  ¦¦¦              ¦"
    echo "¦                    ¦¦¦¦¦¦¦¦¦¦¦¦¦+  ¦¦+¦¦¦¦+¦¦¦¦¦¦   ¦¦¦¦¦¦¦¦¦¦¦              ¦"
    echo "¦                    ¦¦+--¦¦¦¦¦+--+  ¦¦¦+¦¦++¦¦¦¦¦¦   ¦¦¦¦¦+--¦¦¦              ¦"
    echo "¦                    ¦¦¦  ¦¦¦¦¦¦¦¦¦¦+¦¦¦ +-+ ¦¦¦+¦¦¦¦¦¦++¦¦¦  ¦¦¦              ¦"
    echo "¦                    +-+  +-++------++-+     +-+ +-----+ +-+  +-+              ¦"
    echo "¦                                                                              ¦"
    echo "¦  World Number One Information Gathering Tool - Advanced Reconnaissance       ¦"
    echo "¦                                                                              ¦"
    echo "¦  Coded by: Pakistani White Hat Hacker Mr. Sabaz Ali Khan                     ¦"
    echo "¦  Version: 1.0 | Ethical Use Only | No Liability for Misuse                   ¦"
    echo "¦                                                                              ¦"
    echo "+------------------------------------------------------------------------------+"
    echo ""
}

# Function to check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Function to perform WHOIS lookup
whois_lookup() {
    if command_exists whois; then
        echo "--- WHOIS Information ---"
        whois "$target" 2>/dev/null | head -20
        echo ""
    else
        echo "WHOIS: whois command not found. Install it for full results."
        echo ""
    fi
}

# Function to perform DNS lookup with dig
dig_lookup() {
    if command_exists dig; then
        echo "--- DNS Records (dig) ---"
        dig +short "$target" A
        dig +short "$target" AAAA
        dig +short "$target" MX
        dig +short "$target" NS
        dig +short "$target" TXT
        echo ""
    else
        echo "DNS (dig): dig command not found. Install it for full results."
        echo ""
    fi
}

# Function to perform host lookup
host_lookup() {
    if command_exists host; then
        echo "--- Host Lookup ---"
        host "$target"
        echo ""
    else
        echo "Host: host command not found."
        echo ""
    fi
}

# Function to perform nslookup
nslookup_info() {
    if command_exists nslookup; then
        echo "--- NSLookup Information ---"
        nslookup "$target" 2>/dev/null
        echo ""
    else
        echo "NSLookup: nslookup command not found."
        echo ""
    fi
}

# Function to get HTTP headers
http_headers() {
    if command_exists curl; then
        echo "--- HTTP Headers (curl) ---"
        curl -s -I "http://$target" 2>/dev/null || curl -s -I "https://$target" 2>/dev/null
        echo ""
    else
        echo "HTTP Headers: curl command not found."
        echo ""
    fi
}

# Function to ping the target
ping_target() {
    if command_exists ping; then
        echo "--- Ping Results ---"
        ping -c 4 "$target" 2>/dev/null
        echo ""
    else
        echo "Ping: ping command not found."
        echo ""
    fi
}

# Main function
main() {
    display_banner
    echo "Enter target (domain or IP): "
    read -r target

    if [[ -z "$target" ]]; then
        echo "Error: No target provided. Exiting."
        exit 1
    fi

    echo "Gathering information for: $target"
    echo "-------------------------------------------------------------------------------"
    echo ""

    whois_lookup
    dig_lookup
    host_lookup
    nslookup_info
    http_headers
    ping_target

    echo "-------------------------------------------------------------------------------"
    echo "Reconnaissance complete for $target."
    echo "Coded by Pakistani White Hat Hacker Mr. Sabaz Ali Khan"
    echo ""
}

# Trap to handle exit
trap 'echo -e "\nExiting tool. Stay ethical! ?????"; exit' INT

# Run main
main "$@"