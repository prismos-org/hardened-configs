#!/bin/sh
# Source: "NetworkManager Trackability Reduction" by WanderingComputerer
# Originally published: https://wanderingcomputerer.gitlab.io/guides/linux/nm-trackability-reduction/
# Republished: https://privsec.dev/posts/linux/networkmanager-trackability-reduction/
# License: CC BY-SA 4.0 (https://creativecommons.org/licenses/by-sa/4.0/)
# Note: No modifications made to the original content.

if [ "$(nmcli -g 802-11-wireless.cloned-mac-address c show "$CONNECTION_UUID")" = 'permanent' ] \
        || [ "$(nmcli -g 802-3-ethernet.cloned-mac-address c show "$CONNECTION_UUID")" = 'permanent' ]
then
    nmcli connection modify "$CONNECTION_UUID" \
            ipv4.dhcp-send-hostname true \
            ipv6.dhcp-send-hostname true
else
    nmcli connection modify "$CONNECTION_UUID" \
            ipv4.dhcp-send-hostname false \
            ipv6.dhcp-send-hostname false
fi
