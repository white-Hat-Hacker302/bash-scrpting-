#!/bin/bash

# Banner
echo -e "\033[1;32m"
echo "============================================="
echo "  Pakistani Phone Number Information Tool    "
echo "  Coded by Pakistani White Hat Hacker       "
echo "  Mr Sabaz Ali Khan                        "
echo "============================================="
echo -e "\033[0m"

# Function to validate Pakistani phone number format
validate_number() {
    local number=$1
    # Pakistani phone numbers: +92 followed by 3 and 9 digits (e.g., +923001234567)
    if [[ $number =~ ^\+923[0-4][0-9]{8}$ ]]; then
        return 0 # Valid
    else
        return 1 # Invalid
    fi
}

# Function to identify telecom operator based on mobile code
get_operator() {
    local number=$1
    local code=${number:3:3} # Extract mobile code (e.g., 300, 321)

    case $code in
        "300"|"301"|"302"|"303"|"304"|"305"|"306"|"307"|"308"|"309")
            echo "Jazz"
            ;;
        "310"|"311"|"312"|"313"|"314"|"315"|"316"|"317"|"318"|"319")
            echo "Zong"
            ;;
        "320"|"321"|"322"|"323"|"324"|"325"|"326"|"327"|"328"|"329")
            echo "Warid"
            ;;
        "330"|"331"|"332"|"333"|"334"|"335"|"336"|"337"|"338"|"339")
            echo "Ufone"
            ;;
        "340"|"341"|"342"|"343"|"344"|"345"|"346"|"347"|"348"|"349")
            echo "Telenor"
            ;;
        *)
            echo "Unknown Operator"
            ;;
    esac
}

# Main script
echo "Enter a Pakistani phone number (e.g., +923001234567): "
read phone_number

# Validate the input
if validate_number "$phone_number"; then
    echo -e "\033[1;32m[+] Valid Pakistani phone number\033[0m"
    operator=$(get_operator "$phone_number")
    echo -e "\033[1;34m[*] Operator: $operator\033[0m"
    echo -e "\033[1;34m[*] Number Format: $phone_number\033[0m"
else
    echo -e "\033[1;31m[-] Invalid phone number. Please use format +923XXXXXXXXX\033[0m"
    exit 1
fi

# Additional placeholder for future information gathering
echo -e "\033[1;33m[*] Additional Info: Limited data available. For advanced queries, integrate with external APIs.\033[0m"