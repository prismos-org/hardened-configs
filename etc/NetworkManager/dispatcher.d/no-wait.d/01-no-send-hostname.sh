#!/bin/sh
# Copyright (C) 2025 Prism OS Authors
#
# This file is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This file is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this file.  If not, see <https://www.gnu.org/licenses/>.

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
