#!/bin/sh

# Source: Adapted from "NetworkManager Trackability Reduction" by WanderingComputerer
# Original publication: https://wanderingcomputerer.gitlab.io/guides/linux/nm-trackability-reduction/
# Republished: https://privsec.dev/posts/linux/networkmanager-trackability-reduction/
# License: CC BY-SA 4.0 (https://creativecommons.org/licenses/by-sa/4.0/)

set -oue pipefail

WIFI_MAC=$(nmcli -g 802-11-wireless.cloned-mac-address connection show "$CONNECTION_UUID" 2>/dev/null || echo "")
ETH_MAC=$(nmcli -g 802-3-ethernet.cloned-mac-address connection show "$CONNECTION_UUID" 2>/dev/null || echo "")
if [ "$WIFI_MAC" = "permanent" ] || [ "$ETH_MAC" = "permanent" ]; then
    	nmcli connection modify "$CONNECTION_UUID" \
        ipv4.dhcp-send-hostname true \
        ipv6.dhcp-send-hostname true
else
    	nmcli connection modify "$CONNECTION_UUID" \
        ipv4.dhcp-send-hostname false \
        ipv6.dhcp-send-hostname false
fi
