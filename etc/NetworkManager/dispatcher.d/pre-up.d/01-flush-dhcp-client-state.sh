#!/bin/sh

set -oue pipefail
CONN_TYPE=$(nmcli -t -f TYPE connection show --active | head -n 1)
if [ "$CONN_TYPE" != "vpn" ]; then
    if ls /var/lib/NetworkManager/*.lease >/dev/null 2>&1; then
        /usr/bin/rm -f /var/lib/NetworkManager/*.lease
    fi
fi
