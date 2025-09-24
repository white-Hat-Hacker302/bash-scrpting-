#!/bin/bash

# Account Safety Playbook CLI
# A tool to help users check and improve their account security

# Function to display help menu
show_help() {
    echo "Account Safety Playbook CLI"
    echo "Usage: $0 [command]"
    echo
    echo "Commands:"
    echo "  check-password    Check password strength"
    echo "  check-common      Check if password is in common password list"
    echo "  recommendations   Show account security recommendations"
    echo "  help             Show this help message"
    echo
}

# Function to check password strength
check_password_strength() {
    echo "Enter password to check (input will be hidden):"
    read -s password
    echo

    length=${#password}
    has_upper=$(echo "$password" | grep -q '[A-Z]' && echo 1 || echo 0)
    has_lower=$(echo "$password" | grep -q '[a-z]' && echo 1 || echo 0)
    has_number=$(echo "$password" | grep -q '[0-9]' && echo 1 || echo 0)
    has_special=$(echo "$password" | grep -q '[!@#$%^&*(),.?":{}|<>]' && echo 1 || echo 0)

    score=$((has_upper + has_lower + has_number + has_special))
    
    if [ $length -lt 8 ]; then
        echo "Password is too short (minimum 8 characters)"
        return
    fi

    case $score in
        1)
            echo "Weak password: Consider adding more character types (uppercase, lowercase, numbers, special characters)"
            ;;
        2)
            echo "Moderate password: Consider adding more character types"
            ;;
        3)
            echo "Good password: Meets most security criteria"
            ;;
        4)
            echo "Strong password: Meets all security criteria"
            ;;
    esac

    if [ $length -ge 12 ]; then
        echo "Bonus: Password length ($length) is excellent!"
    fi
}

# Function to check for common passwords
check_common_password() {
    # Simulated common password list (in practice, this would be a larger file)
    common_passwords=("password" "123456" "qwerty" "admin" "letmein")

    echo "Enter password to check against common passwords (input will be hidden):"
    read -s password
    echo

    for common in "${common_passwords[@]}"; do
        if [ "$password" = "$common" ]; then
            echo "WARNING: This password is commonly used and insecure!"
            return
        fi
    done
    echo "Password not found in common password list"
}

# Function to show security recommendations
show_recommendations() {
    echo "Account Safety Recommendations:"
    echo "1. Use unique passwords for each account"
    echo "2. Enable Two-Factor Authentication (2FA) where available"
    echo "3. Use a password manager to generate and store complex passwords"
    echo "4. Regularly update passwords (every 6-12 months)"
    echo "5. Avoid using personal information in passwords"
    echo "6. Be cautious of phishing attempts"
    echo "7. Keep software and systems updated"
    echo "8. Use strong, complex passwords (12+ characters, mixed types)"
}

# Main command processing
case "$1" in
    check-password)
        check_password_strength
        ;;
    check-common)
        check_common_password
        ;;
    recommendations)
        show_recommendations
        ;;
    help|"")
        show_help
        ;;
    *)
        echo "Unknown command: $1"
        show_help
        exit 1
        ;;
esac

exit 0
