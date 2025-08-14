#!/bin/sh 
if /usr/bin/systemctl is-active --quiet systemd-resolved; then
    /usr/bin/systemd-resolve --flush-caches
fi
