#!/usr/bin/env bash

set -u

INTERVAL="${INTERVAL:-10}"
LOG_FILE="${LOG_FILE:-$HOME/monitor.log}"
HIGH_CPU_COUNT=0

cleanup() {
    echo
    echo "Received signal. Graceful exit at $(date '+%Y-%m-%d %H:%M:%S')"
    exit 0
}

trap cleanup SIGINT
trap cleanup SIGTERM

read_cpu_stat() {
    awk '/^cpu / {
        idle=$5+$6
        total=$2+$3+$4+$5+$6+$7+$8+$9+$10
        print idle, total
    }' /proc/stat
}

get_mem_percent() {
    free | awk '/Mem:/ { printf "%.2f", ($3/$2)*100 }'
}

get_top3_cpu() {
    ps -eo pid,ppid,comm,%cpu,%mem --sort=-%cpu | head -n 4
}

echo "Monitor started at $(date '+%Y-%m-%d %H:%M:%S')"
echo "Interval: ${INTERVAL}s"
echo "Log file: $LOG_FILE"
echo

read PREV_IDLE PREV_TOTAL < <(read_cpu_stat)

while true; do
    sleep "$INTERVAL"

    read CUR_IDLE CUR_TOTAL < <(read_cpu_stat)

    DIFF_IDLE=$((CUR_IDLE - PREV_IDLE))
    DIFF_TOTAL=$((CUR_TOTAL - PREV_TOTAL))

    if [ "$DIFF_TOTAL" -eq 0 ]; then
        CPU_PERCENT="0.00"
    else
        CPU_PERCENT=$(awk -v total="$DIFF_TOTAL" -v idle="$DIFF_IDLE" \
            'BEGIN { printf "%.2f", ((total-idle)/total)*100 }')
    fi

    MEM_PERCENT=$(get_mem_percent)
    TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')

    echo "[$TIMESTAMP] CPU: ${CPU_PERCENT}% | MEM: ${MEM_PERCENT}%"
    echo "Top 3 CPU processes:"
    get_top3_cpu
    echo "------------------------------------------------------------"

    IS_HIGH=$(awk -v cpu="$CPU_PERCENT" 'BEGIN { print (cpu > 80) ? 1 : 0 }')

    if [ "$IS_HIGH" -eq 1 ]; then
        HIGH_CPU_COUNT=$((HIGH_CPU_COUNT + 1))
    else
        HIGH_CPU_COUNT=0
    fi

    if [ "$HIGH_CPU_COUNT" -ge 3 ]; then
        echo "[$TIMESTAMP] WARNING: CPU usage above 80% for ${HIGH_CPU_COUNT} consecutive samples. Current CPU=${CPU_PERCENT}%" >> "$LOG_FILE"
    fi

    PREV_IDLE=$CUR_IDLE
    PREV_TOTAL=$CUR_TOTAL
done
