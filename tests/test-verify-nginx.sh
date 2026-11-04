#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."

tmp=$(mktemp -d)
trap 'rm -rf -- "$tmp"' EXIT
mkdir -p "$tmp/bin"
cat > "$tmp/bin/nginx" <<'MOCK'
#!/usr/bin/env bash
exit 0
MOCK
cat > "$tmp/bin/systemctl" <<'MOCK'
#!/usr/bin/env bash
if [[ "${MOCK_NGINX_SERVICE:-active}" == active ]]; then exit 0; else exit 3; fi
MOCK
cat > "$tmp/bin/ss" <<'MOCK'
#!/usr/bin/env bash
if [[ "${MOCK_NGINX_PORT:-open}" == open ]]; then
  printf 'State  Recv-Q Send-Q Local Address:Port Peer Address:Port\nLISTEN 0 128 127.0.0.1:80 0.0.0.0:*\n'
fi
MOCK
cat > "$tmp/bin/curl" <<'MOCK'
#!/usr/bin/env bash
if [[ "${MOCK_NGINX_HTTP:-ok}" == ok ]]; then exit 0; else exit 7; fi
MOCK
chmod +x "$tmp/bin/"*
PATH="$tmp/bin:$PATH" bash scripts/verify-nginx.sh > "$tmp/success.txt"
grep -q 'PASS: nginx command is available' "$tmp/success.txt"
grep -q 'PASS: nginx service is active' "$tmp/success.txt"
grep -q 'PASS: TCP port 80 is listening' "$tmp/success.txt"
grep -q 'PASS: local HTTP request succeeded' "$tmp/success.txt"
if PATH="$tmp/bin:$PATH" MOCK_NGINX_SERVICE=inactive MOCK_NGINX_PORT=closed MOCK_NGINX_HTTP=fail bash scripts/verify-nginx.sh > "$tmp/failure.txt"; then
  echo 'FAIL: verification script reported success despite mocked failures' >&2
  exit 1
fi
grep -q 'FAIL: nginx service is not active' "$tmp/failure.txt"
grep -q 'FAIL: TCP port 80 is not listening' "$tmp/failure.txt"
grep -q 'FAIL: local HTTP request failed' "$tmp/failure.txt"
echo 'Mocked NGINX verification success/failure tests: passed'
