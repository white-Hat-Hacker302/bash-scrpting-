#!/bin/bash

# Banner
echo -e "\033[1;34m"
echo "============================================="
echo "     Social Account Health Dashboard          "
echo "============================================="
echo "   Coded by Pakistani White Hat Hacker       "
echo "        Mr. Sabaz Ali Khan                   "
echo "============================================="
echo -e "\033[0m"

# Simulated social media platforms and their metrics
declare -A platforms=(
    ["Twitter"]="X"
    ["Instagram"]="Insta"
    ["Facebook"]="FB"
)

# Simulated data generation functions
generate_followers() {
    echo $((RANDOM % 10000 + 500))
}

generate_engagement_rate() {
    printf "%.2f" $(echo "scale=2; $RANDOM % 100 / 10" | bc)
}

check_account_status() {
    local status=("Active" "Suspended" "Under Review")
    echo ${status[$((RANDOM % 3))]}
}

# Function to display dashboard
display_dashboard() {
    echo -e "\n\033[1;32mSocial Media Health Report - $(date '+%Y-%m-%d %H:%M:%S')\033[0m"
    echo "---------------------------------------------"
    
    for platform in "${!platforms[@]}"; do
        echo -e "\nPlatform: ${platforms[$platform]} ($platform)"
        echo "Followers: $(generate_followers)"
        echo "Engagement Rate: $(generate_engagement_rate)%"
        echo "Account Status: $(check_account_status)"
        echo "Last Checked: $(date '+%Y-%m-%d %H:%M:%S')"
        echo "---------------------------------------------"
    done
}

# Function to check for potential issues
check_issues() {
    echo -e "\n\033[1;33mPotential Issues\033[0m"
    echo "---------------------------------------------"
    for platform in "${!platforms[@]}"; do
        local followers=$(generate_followers)
        local engagement
