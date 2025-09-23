#!/bin/bash

# Username Checking Tool
# Coded by Pakistani White Hacker Mr Sabaz Ali Khan
# Date: September 23, 2025

# Function to display banner
show_banner() {
    figlet -f banner "Username Checker" | lolcat  # Optional: Install lolcat for colors, or remove | lolcat
    echo "========================"
    echo "Coded by Pakistani White Hacker"
    echo "Mr Sabaz Ali Khan"
    echo "========================"
}

# Function to check a single platform
check_platform() {
    local platform=$1
    local url=$2
    local username=$3
    local response=$(curl -s -o /dev/null -w "%{http_code}" -L --max-time 10 "$url")
    
    if [[ $response == "200" ]]; then
        echo "? $platform: TAKEN"
    elif [[ $response == "404" ]] || [[ $response == "403" ]]; then
        echo "? $platform: AVAILABLE"
    else
        echo "??  $platform: UNKNOWN ($response) - Check manually"
    fi
}

# Main function
main() {
    if [[ $# -eq 0 ]]; then
        echo "Usage: $0 <username>"
        exit 1
    fi
    
    local username=$1
    show_banner
    echo "Checking username: $username"
    echo "------------------------"
    
    # Twitter/X
    check_platform "Twitter/X" "https://twitter.com/$username" "$username"
    
    # Instagram
    check_platform "Instagram" "https://www.instagram.com/$username/" "$username"
    
    # Facebook
    check_platform "Facebook" "https://www.facebook.com/$username" "$username"
    
    # GitHub
    check_platform "GitHub" "https://github.com/$username" "$username"
    
    # Reddit
    check_platform "Reddit" "https://www.reddit.com/user/$username" "$username"
    
    # YouTube
    check_platform "YouTube" "https://www.youtube.com/user/$username" "$username"
    
    # LinkedIn (note: LinkedIn often requires login, so this is approximate)
    check_platform "LinkedIn" "https://www.linkedin.com/in/$username" "$username"
    
    echo "------------------------"
    echo "Scan complete! Results above."
}

# Run main
main "$@"