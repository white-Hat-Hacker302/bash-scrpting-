#!/bin/bash

# Banner
echo "============================================================="
echo "            WPScan-Bash - WordPress Security Scanner          "
echo "       Coded by Pakistani White Hat Hacker Mr Sabaz Ali Khan  "
echo "============================================================="

# Function to check if required tools are installed
check_requirements() {
    if ! command -v curl &> /dev/null; then
        echo "[!] Error: curl is not installed. Please install it."
        exit 1
    fi
    if ! command -v grep &> /dev/null; then
        echo "[!] Error: grep is not installed. Please install it."
        exit 1
    fi
}

# Function to display usage
usage() {
    echo "Usage: $0 -u <target_url>"
    echo "Example: $0 -u https://example.com"
    exit 1
}

# Function to check if the target is a WordPress site
check_wordpress() {
    local url=$1
    echo "[*] Checking if $url is a WordPress site..."
    response=$(curl -s -L "$url")
    
    if echo "$response" | grep -qi "wp-content"; then
        echo "[+] Confirmed: $url is a WordPress site."
    else
        echo "[!] Error: $url does not appear to be a WordPress site."
        exit 1
    fi
}

# Function to detect WordPress version
detect_version() {
    local url=$1
    echo "[*] Detecting WordPress version..."
    version=$(curl -s -L "$url" | grep -oP 'content="WordPress\s*[\d\.]+' | grep -oP '[\d\.]+' | head -1)
    if [ -n "$version" ]; then
        echo "[+] WordPress Version: $version"
    else
        echo "[!] Could not detect WordPress version."
    fi
}

# Function to detect themes
detect_themes() {
    local url=$1
    echo "[*] Detecting themes..."
    themes=$(curl -s -L "$url" | grep -oP 'wp-content/themes/[^/]+' | sort -u)
    if [ -n "$themes" ]; then
        echo "[+] Found themes:"
        echo "$themes" | while read -r theme; do
            theme_name=$(echo "$theme" | cut -d'/' -f3)
            echo "    - $theme_name"
        done
    else
        echo "[!] No themes detected."
    fi
}

# Function to detect plugins
detect_plugins() {
    local url=$1
    echo "[*] Detecting plugins..."
    plugins=$(curl -s -L "$url" | grep -oP 'wp-content/plugins/[^/]+' | sort -u)
    if [ -n "$plugins" ]; then
        echo "[+] Found plugins:"
        echo "$plugins" | while read -r plugin; do
            plugin_name=$(echo "$plugin" | cut -d'/' -f3)
            echo "    - $plugin_name"
        done
    else
        echo "[!] No plugins detected."
    fi
}

# Main function
main() {
    check_requirements

    # Parse command-line arguments
    while getopts "u:" opt; do
        case $opt in
            u) TARGET_URL="$OPTARG" ;;
            *) usage ;;
        esac
    done

    # Validate input
    if [ -z "$TARGET_URL" ]; then
        usage
    fi

    # Normalize URL (add https:// if no protocol is specified)
    if [[ ! "$TARGET_URL" =~ ^https?:// ]]; then
        TARGET_URL="https://$TARGET_URL"
    fi

    # Remove trailing slash
    TARGET_URL=${TARGET_URL%/}

    echo "[*] Scanning target: $TARGET_URL"
    echo "--------------------------------------------------"

    # Perform scans
    check_wordpress "$TARGET_URL"
    detect_version "$TARGET_URL"
    detect_themes "$TARGET_URL"
    detect_plugins "$TARGET_URL"

    echo "--------------------------------------------------"
    echo "[*] Scan completed for $TARGET_URL"
}

# Execute main function
main "$@"
