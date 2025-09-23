#!/bin/bash

# traffic_replay_lab - A simple network traffic replay lab tool
# This script captures live network traffic using tcpdump, saves it to a pcap file,
# and provides options to replay it using tcpreplay. It assumes tcpdump and tcpreplay
# are installed (e.g., via apt install tcpdump tcpreplay on Debian-based systems).
# Usage: ./traffic_replay_lab.sh [capture|replay] [interface] [options]
# Example: ./traffic_replay_lab.sh capture eth0 -i 10 -w capture.pcap
#          ./traffic_replay_lab.sh replay eth0 capture.pcap
#
# WARNING: This tool is for educational/lab purposes only. Use responsibly and
# ensure you have permission to capture/replay traffic on the network.
# Replay can generate high traffic; test in isolated environments.
#
# Coded by Pakistani White Hat Hacker Mr. Sabaz Ali Khan

# Banner function
print_banner() {
    echo "+------------------------------------------------------------------------------+"
    echo "¦                                                                              ¦"
    echo "¦    ¦¦¦¦¦¦+ ¦¦¦¦¦¦¦+ ¦¦¦¦¦¦+ ¦¦¦¦¦¦+  ¦¦¦¦¦¦+ ¦¦¦+   ¦¦+¦¦¦¦¦¦¦+ ¦¦¦¦¦+       ¦"
    echo "¦   ¦¦+----+ ¦¦+----+¦¦+----+¦¦+---¦¦+¦¦+---¦¦+¦¦¦¦+  ¦¦¦¦¦+----+¦¦+--¦¦+      ¦"
    echo "¦   ¦¦¦  ¦¦¦+¦¦¦¦¦+  ¦¦¦     ¦¦¦   ¦¦¦¦¦¦   ¦¦¦¦¦+¦¦+ ¦¦¦¦¦¦¦¦+  ¦¦¦¦¦¦¦¦      ¦"
    echo "¦   ¦¦¦   ¦¦¦¦¦+--+  ¦¦¦     ¦¦¦   ¦¦¦¦¦¦   ¦¦¦¦¦¦+¦¦+¦¦¦¦¦+--+  ¦¦+--¦¦¦      ¦"
    echo "¦   +¦¦¦¦¦¦++¦¦¦¦¦¦¦++¦¦¦¦¦¦++¦¦¦¦¦¦+++¦¦¦¦¦¦++¦¦¦ +¦¦¦¦¦¦¦¦¦¦¦¦+¦¦¦  ¦¦¦      ¦"
    echo "¦    +-----+ +------+ +-----+ +-----+  +-----+ +-+  +---++------++-+  +-+      ¦"
    echo "¦                                                                              ¦"
    echo "¦                          TRAFFIC REPLAY LAB TOOL                            ¦"
    echo "¦                                                                              ¦"
    echo "¦  Coded by Pakistani White Hat Hacker Mr. Sabaz Ali Khan                      ¦"
    echo "¦                                                                              ¦"
    echo "+------------------------------------------------------------------------------+"
    echo ""
}

# Function to display usage
usage() {
    echo "Usage: $0 <command> [interface] [options]"
    echo "Commands:"
    echo "  capture [interface] [tcpdump_options] - Capture traffic to a pcap file"
    echo "    Example: $0 capture eth0 -i 10 -w my_capture.pcap"
    echo "  replay [interface] <pcap_file> [tcpreplay_options] - Replay captured traffic"
    echo "    Example: $0 replay eth0 my_capture.pcap --loop=5"
    echo ""
    echo "Default interface: eth0"
    echo "Default pcap file for capture: traffic_lab.pcap"
    echo ""
    exit 1
}

# Check if running as root (required for tcpdump and tcpreplay)
if [[ $EUID -ne 0 ]]; then
    echo "Error: This script must be run as root (sudo)."
    exit 1
fi

# Print banner
print_banner

# Check for required tools
if ! command -v tcpdump &> /dev/null; then
    echo "Error: tcpdump not found. Install it with 'sudo apt install tcpdump' or equivalent."
    exit 1
fi

if ! command -v tcpreplay &> /dev/null; then
    echo "Error: tcpreplay not found. Install it with 'sudo apt install tcpreplay' or equivalent."
    exit 1
fi

# Default values
CMD=${1:-}
IFACE=${2:-eth0}
PCAP_FILE="traffic_lab.pcap"

case "$CMD" in
    "capture")
        shift 2
        TCPDUMP_OPTS="${@:- -i 10 -w $PCAP_FILE}"
        echo "Capturing traffic on interface $IFACE for 10 seconds..."
        echo "Press Ctrl+C to stop early."
        tcpdump -i $IFACE $TCPDUMP_OPTS
        echo "Capture complete. File: $PCAP_FILE"
        ;;
    "replay")
        PCAP_FILE=${2:-$PCAP_FILE}
        shift 2
        TCPLAY_OPTS="${@}"
        if [[ ! -f "$PCAP_FILE" ]]; then
            echo "Error: PCAP file '$PCAP_FILE' not found."
            exit 1
        fi
        echo "Replaying traffic from '$PCAP_FILE' on interface $IFACE..."
        tcpreplay --intf1=$IFACE $TCPLAY_OPTS $PCAP_FILE
        ;;
    *)
        usage
        ;;
esac