#!/bin/bash

set -euo pipefail

usage() {
    cat <<EOF
Usage:
    $0 -list
        List all NetworkManager connection profiles

    $0 [ethernet|wifi] CONNECTION_NAME IP/CIDR GATEWAY DNS1[,DNS2,...]
        Apply static IPv4 settings via nmcli

Examples:
    sudo $0 -list
    sudo $0 ethernet "Wired connection 1" 192.168.100.23/24 192.168.100.1 8.8.8.8,1.1.1.1
    sudo $0 wifi     "WiFi"          192.168.100.42/24 192.168.100.1 8.8.4.4,8.8.8.8
EOF
    exit 1
}

# Just shows the help page
if [[ $# -lt 1 ]]; then
    usage
fi

# Lists all the available connections
if [[ "$1" == "-list" ]]; then
    echo "Available connections:"
    nmcli --terse --fields NAME,UUID,DEVICE connection show | \
        awk -F: '{ printf "  • %-25s  dev=%-6s  uuid=%s\n", $1, ($3==""?"–":$3), $2 }'
    exit 0
fi

if [[ $EUID -ne 0 ]] || [[ $# -ne 5 ]]; then
    usage
fi

MODE="$1"; CONN="$2"; ADDR="$3"; GW="$4"; DNS="$5"

# Check if the connection mode is valid
if ! nmcli -t -f NAME connection show | grep -xq "$CONN"; then
    echo "Error: connection '$CONN' not found." >&2
    exit 1
fi

# Apply static IPv4 settings
nmcli connection modify "$CONN" \
    ipv4.method manual \
    ipv4.addresses "$ADDR" \
    ipv4.gateway "$GW" \
    ipv4.dns "${DNS//,/ }"

nmcli connection down "$CONN"
nmcli connection up   "$CONN"

echo "Static IP applied to '$CONN':"
echo "    Address: $ADDR"
echo "    Gateway: $GW"
echo "    DNS:     $DNS"
