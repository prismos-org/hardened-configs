#!/bin/sh

# Source: Adapted from "NetworkManager Trackability Reduction" by WanderingComputerer
# Original publication: https://wanderingcomputerer.gitlab.io/guides/linux/nm-trackability-reduction/
# Republished: https://privsec.dev/posts/linux/networkmanager-trackability-reduction/
# License: CC BY-SA 4.0 (https://creativecommons.org/licenses/by-sa/4.0/)

set -oue pipefail

WIFI_MAC=$(nmcli -g 802-11-wireless.cloned-mac-address connection show "$CONNECTION_UUID" 2>/dev/null || echo "")
ETH_MAC=$(nmcli -g 802-3-ethernet.cloned-mac-address connection show "$CONNECTION_UUID" 2>/dev/null || echo "")
if [ "$WIFI_MAC" = "permanent" ] || [ "$ETH_MAC" = "permanent" ]; then
    echo "Permanent MAC address detected for connection '$CONNECTION_UUID'. Enabling DHCP hostname sending."
    nmcli connection modify "$CONNECTION_UUID" \
        ipv4.dhcp-send-hostname true \
        ipv6.dhcp-send-hostname true
else
    echo "Randomized or non-permanent MAC address detected for connection '$CONNECTION_UUID'. Disabling DHCP hostname sending."
    nmcli connection modify "$CONNECTION_UUID" \
        ipv4.dhcp-send-hostname false \
        ipv6.dhcp-send-hostname false
fi
if nmcli connection reload "$CONNECTION_UUID" >/dev/null 2>&1; then
    echo "Connection '$CONNECTION_UUID' reloaded successfully."
else
    echo "Warning: Failed to reload connection '$CONNECTION_UUID'. Changes may not take effect until reconnection."
fi
