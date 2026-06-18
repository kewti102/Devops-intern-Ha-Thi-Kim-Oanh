#!/usr/bin/env bash

echo "===== Top 5 RAM Processes ====="

ps aux \
| sort -rk4 \
| head -n 6 \
| awk '{print $2, $11, $4}'

echo
echo "===== Log Count ====="

sudo find /var/log -maxdepth 2 -type f -name "*.log" \
| wc -l

echo
echo "===== Top 10 IP ====="

if [ -f /var/log/auth.log ]; then
    grep -oE '([0-9]{1,3}\.){3}[0-9]{1,3}' /var/log/auth.log \
    | sort \
    | uniq -c \
    | sort -rn \
    | head -10
else
    echo "auth.log not found"
fi

echo
echo "===== System Info ====="

{
echo "host=$(hostname)"
echo "kernel=$(uname -r)"
echo "uptime=$(uptime -p)"
} > system-info.txt

cat system-info.txt
