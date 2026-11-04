#!/usr/bin/env bash
# Repeat four independently meaningful checks; do not change host state.
service_name="nginx"
status=0
current_host=$(hostname)
echo "Host: $current_host"
if command -v "$service_name" >/dev/null 2>&1
then
    echo "PASS: nginx command is available"
else
    echo "FAIL: nginx command is not available"
    status=1
fi
if systemctl is-active --quiet "$service_name"
then
    echo "PASS: nginx service is active"
else
    echo "FAIL: nginx service is not active"
    status=1
fi
if ss -lnt | grep -Eq ':[[:space:]]*80[[:space:]]'
then
    echo "PASS: TCP port 80 is listening"
else
    echo "FAIL: TCP port 80 is not listening"
    status=1
fi
if curl --fail --silent --show-error http://localhost >/dev/null 2>&1
then
    echo "PASS: local HTTP request succeeded"
else
    echo "FAIL: local HTTP request failed"
    status=1
fi
exit "$status"
