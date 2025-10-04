#!/bin/bash

# SabazIG: Information Gathering Framework
# Author: Inspired by Pakistani Ethical Hacker Mr. Sabaz Ali Khan (Original Creation)
# Version: 1.0
# Description: Ethical recon framework in pure Bash. Use responsibly!
# Legal: Only scan authorized targets. Comply with laws (e.g., CFAA in US, PTA in Pakistan).

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Global variables
LOG_FILE=""
JSON_FILE=""
TARGET=""
VERBOSE=0
MODULES=()

# Logging function
log() {
    echo -e "$(date '+%Y-%m-%d %H:%M:%S') - $1" | tee -a "$LOG_FILE"
    if [ $VERBOSE -eq 1 ]; then
        echo -e "$1"
    fi
}

# JSON output helper (simple, no jq dependency)
json_add() {
    echo "$1" >> "$JSON_FILE"
}

# Usage
usage() {
    echo "Usage: $0 -t <target> [-m <module>] [-v] [-h]"
    echo "  -t: Target (domain/IP/CIDR)"
    echo "  -m: Module (whois,dns,asn,http,subenum,portscan,full) - default: full"
    echo "  -v: Verbose mode"
    echo "  -h: Help"
    exit 1
}

# Parse args
while getopts "t:m:vh" opt; do
    case $opt in
        t) TARGET="$OPTARG" ;;
        m) IFS=',' read -ra MODULES <<< "$OPTARG" ;;
        v) VERBOSE=1 ;;
        h) usage ;;
        *) usage ;;
    esac
done

if [ -z "$TARGET" ]; then
    echo -e "${RED}Error: Target required.${NC}"
    usage
fi

# Setup files
LOG_FILE="sabazig_$(date +%Y%m%d_%H%M%S).log"
JSON_FILE="${LOG_FILE%.log}.json"
> "$LOG_FILE"
> "$JSON_FILE"
log "${GREEN}SabazIG started for target: $TARGET${NC}"

# Confirmation for active scans
confirm_active() {
    read -p "Active scans (e.g., portscan) will contact target. Proceed? (y/N): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        log "${YELLOW}Aborted by user.${NC}"
        exit 0
    fi
}

# Module: WHOIS
module_whois() {
    log "${YELLOW}[WHOIS]${NC}"
    json_add "{\"module\":\"whois\",\"target\":\"$TARGET\"}"
    whois_output=$(whois "$TARGET" 2>/dev/null | head -20)
    if [ $? -eq 0 ]; then
        echo "$whois_output" | tee -a "$LOG_FILE"
        json_add ",\"data\":\"$(echo "$whois_output" | tr '\n' ' ' | sed 's/"/\\"/g')\""
    else
        log "${RED}WHOIS failed.${NC}"
    fi
    json_add "}"
}

# Module: DNS Lookup
module_dns() {
    log "${YELLOW}[DNS]${NC}"
    json_add "{\"module\":\"dns\",\"target\":\"$TARGET\"}"
    dns_output=$(dig +short "$TARGET" A MX NS TXT 2>/dev/null)
    if [ $? -eq 0 ] && [ -n "$dns_output" ]; then
        echo "$dns_output" | tee -a "$LOG_FILE"
        json_add ",\"data\":\"$(echo "$dns_output" | tr '\n' ' ' | sed 's/"/\\"/g')\""
    else
        log "${RED}DNS lookup failed.${NC}"
    fi
    json_add "}"
}

# Module: ASN Info (passive via whois)
module_asn() {
    log "${YELLOW}[ASN]${NC}"
    json_add "{\"module\":\"asn\",\"target\":\"$TARGET\"}"
    ip=$(dig +short "$TARGET" A 2>/dev/null | head -1)
    if [ -n "$ip" ]; then
        asn_output=$(whois "$ip" | grep -i 'origin' | head -1 2>/dev/null)
        echo "IP: $ip | ASN: $asn_output" | tee -a "$LOG_FILE"
        json_add ",\"data\":\"IP: $ip | ASN: $asn_output\""
    else
        log "${RED}ASN resolution failed.${NC}"
    fi
    json_add "}"
}

# Module: HTTP Headers (passive-ish, low rate)
module_http() {
    log "${YELLOW}[HTTP]${NC}"
    confirm_active
    json_add "{\"module\":\"http\",\"target\":\"$TARGET\"}"
    http_output=$(curl -s -I "http://$TARGET" 2>/dev/null || curl -s -I "https://$TARGET" 2>/dev/null)
    if [ $? -eq 0 ] && [ -n "$http_output" ]; then
        echo "$http_output" | tee -a "$LOG_FILE"
        json_add ",\"data\":\"$(echo "$http_output" | tr '\n' ' ' | sed 's/"/\\"/g')\""
    else
        log "${RED}HTTP probe failed.${NC}"
    fi
    json_add "}"
}

# Module: Subdomain Enum (passive via crt.sh)
module_subenum() {
    log "${YELLOW}[SUBENUM]${NC}"
    json_add "{\"module\":\"subenum\",\"target\":\"$TARGET\"}"
    sub_output=$(curl -s "https://crt.sh/?q=%25.$TARGET&output=json" | grep -oE "[a-zA-Z0-9.-]+\.$TARGET" | sort -u | head -10)
    if [ -n "$sub_output" ]; then
        echo "$sub_output" | tee -a "$LOG_FILE"
        json_add ",\"data\":\"$(echo "$sub_output" | tr '\n' ' ' | sed 's/"/\\"/g')\""
    else
        log "${RED}No subdomains found.${NC}"
    fi
    json_add "}"
}

# Module: Port Scan (active, requires nmap)
module_portscan() {
    log "${YELLOW}[PORTSCAN]${NC}"
    confirm_active
    if ! command -v nmap &> /dev/null; then
        log "${RED}nmap not installed. Skipping.${NC}"
        return
    fi
    json_add "{\"module\":\"portscan\",\"target\":\"$TARGET\"}"
    port_output=$(nmap -sV -T4 --top-ports 100 "$TARGET" 2>/dev/null | grep -E '^[0-9]+/tcp' | head -10)
    if [ $? -eq 0 ] && [ -n "$port_output" ]; then
        echo "$port_output" | tee -a "$LOG_FILE"
        json_add ",\"data\":\"$(echo "$port_output" | tr '\n' ' ' | sed 's/"/\\"/g')\""
    else
        log "${RED}Port scan failed.${NC}"
    fi
    json_add "}"
}

# Run modules
if [ ${#MODULES[@]} -eq 0 ]; then
    MODULES=(whois dns asn http subenum portscan)
fi

json_start="["
first=1
for mod in "${MODULES[@]}"; do
    case $mod in
        whois) module_whois ;;
        dns) module_dns ;;
        asn) module_asn ;;
        http) module_http ;;
        subenum) module_subenum ;;
        portscan) module_portscan ;;
        full) module_whois; module_dns; module_asn; module_http; module_subenum; module_portscan ;;
        *) log "${RED}Unknown module: $mod${NC}" ;;
    esac
    if [ $first -eq 1 ]; then
        first=0
    else
        json_add ","
    fi
done
json_end="]"

# Write JSON
cat > "$JSON_FILE" << EOF
$json_start
$(tail -n +2 "$JSON_FILE" 2>/dev/null | head -n -1)  # Hacky way to build JSON array
$json_end
EOF

log "${GREEN}Scan complete. Log: $LOG_FILE | JSON: $JSON_FILE${NC}"
echo -e "${GREEN}Ethical Reminder: Report findings responsibly. Stay legal!${NC}"
