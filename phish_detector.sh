#!/bin/bash

# Phishing Link Detector (Heuristic)
# Coded by Mr. Sabaz Ali Khan - Pakistani White Hat Hacker
# Date: September 24, 2025
# Heuristics based on common phishing URL patterns: length > 75 chars, IP addresses, suspicious keywords, @ symbols, double slashes, etc.

if [ $# -ne 1 ]; then
    echo "Usage: $0 <URL>"
    exit 1
fi

URL="$1"
RISK=0
REASONS=""

# Normalize URL (remove scheme if present)
if [[ $URL =~ ^https?:// ]]; then
    URL="${URL#https://}"
    URL="${URL#http://}"
fi

# Heuristic 1: URL length > 75 characters (common in obfuscated phishing links)
if [ ${#URL} -gt 75 ]; then
    RISK=$((RISK + 1))
    REASONS+="Long URL (${#URL} chars); "
fi

# Heuristic 2: Contains IP address instead of domain
if [[ $URL =~ ^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3} ]]; then
    RISK=$((RISK + 1))
    REASONS+="Uses IP address; "
fi

# Heuristic 3: Contains suspicious keywords (login, update, verify, secure, account, banking, paypal, etc.)
SUSP_KEYWORDS=("login" "sign-in" "update" "verify" "secure" "account" "banking" "paypal" "amazon" "microsoft" "secure")
for keyword in "${SUSP_KEYWORDS[@]}"; do
    if [[ $URL =~ [?&/]$keyword[/?&] ]]; then
        RISK=$((RISK + 1))
        REASONS+="Suspicious keyword '$keyword'; "
        break
    fi
done

# Heuristic 4: Contains '@' symbol (e.g., user@fake.domain.com)
if [[ $URL =~ @ ]]; then
    RISK=$((RISK + 1))
    REASONS+="Contains '@' symbol; "
fi

# Heuristic 5: Double slashes or suspicious path (// in path)
if [[ $URL =~ /[^/]{1,}//{2,} ]]; then
    RISK=$((RISK + 1))
    REASONS+="Double slashes in path; "
fi

# Heuristic 6: Uses non-standard port (not 80/443)
if [[ $URL =~ :[0-9]{2,5}/ ]] && [[ ! $URL =~ :80/ ]] && [[ ! $URL =~ :443/ ]]; then
    RISK=$((RISK + 1))
    REASONS+="Non-standard port; "
fi

# Heuristic 7: Hex-encoded characters (common obfuscation)
if [[ $URL =~ %[0-9a-fA-F]{2} ]]; then
    RISK=$((RISK + 1))
    REASONS+="Hex encoding (%XX); "
fi

# Decision logic: Risk score > 2 = Phishing Risk
if [ $RISK -gt 2 ]; then
    echo "PHISHING RISK! Score: $RISK/7"
    echo "Reasons: $REASONS"
    echo "Action: Do NOT click. Verify manually."
else
    echo "SAFE (low risk). Score: $RISK/7"
    echo "No major red flags detected."
fi

echo "Analyzed URL: $URL"
