#!/bin/sh

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
