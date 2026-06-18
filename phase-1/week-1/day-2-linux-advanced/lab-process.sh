#!/usr/bin/env bash
set -u
echo "===Part A: Process & Signal Demo ==="
echo
echo "[1] Spawn sleep 300 in background..."
sleep 300 &
CHILD_PID=$!
echo "Child PID: $CHILD_PID"
echo "Current shell PID: $$"
echo
echo "[2] Show PID, PPID, STAT, CMD:"
ps -o pid,ppid,stat,cmd -p "$CHILD_PID"
echo
echo "[3] Show process tree:"
ps auxf | grep -E "PID|sleep 300" | grep -v grep
echo
echo "[4] Send SIGTERM to child process..."
kill -TERM "$CHILD_PID"
echo
echo "[5] Wait for process and get exit code..."
wait "$CHILD_PID"
EXIT_CODE=$?

echo "Exit code after SIGTERM: $EXIT_CODE"
echo
echo "[6] Verify process is gone:"
if ps -p "$CHILD_PID" > /dev/null; then
	echo "Process still exists"
else 
	echo "Process terminated successfully"
fi

