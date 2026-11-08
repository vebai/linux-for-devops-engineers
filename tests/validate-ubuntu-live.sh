#!/usr/bin/env bash
# Chapter-aligned operational smoke test, intended ONLY for an authorised disposable Ubuntu VM.
# Run AFTER following Chapter 7 to install and start NGINX.
# Chapter 11 service-stop drill is OFF by default and requires --allow-service-stop + confirmation.
# Usage: bash tests/validate-ubuntu-live.sh [--allow-service-stop]
set -Eeuo pipefail

ALLOW_STOP=0
case "${1:-}" in
    '') ;;
    --allow-service-stop) ALLOW_STOP=1 ;;
    *) printf 'Usage: bash tests/validate-ubuntu-live.sh [--allow-service-stop]\n' >&2; exit 2 ;;
esac
[[ $# -le 1 ]] || { echo 'Only one option is supported.' >&2; exit 2; }

REPO=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd -P)
STEP='Preflight'
TEMP_LAB=''
RECOVERY_NEEDED=0

fail() { printf 'FAIL [%s]: %s\n' "$STEP" "$*" >&2; exit 1; }
checkpoint() { STEP="$1"; printf '\n========== %s ==========\n' "$STEP"; }
pass() { printf 'PASS [%s]: %s\n' "$STEP" "$*"; }

cleanup() {
    local rc=$?
    trap - EXIT
    if (( RECOVERY_NEEDED )); then
        printf '\nRECOVERY: Attempting to restart NGINX after an interrupted Chapter 11 drill.\n' >&2
        if ! sudo -n systemctl start nginx; then
            printf 'URGENT: Automatic recovery failed. On the VM, run: sudo systemctl start nginx\n' >&2
            rc=1
        fi
    fi
    if [[ -n "$TEMP_LAB" && "$TEMP_LAB" == "$HOME/devops-lab/.linux-validation."* && -d "$TEMP_LAB" ]]; then
        rm -rf -- "$TEMP_LAB"
    fi
    if (( rc != 0 )); then
        printf '\nVALIDATION FAILED at checkpoint: %s\n' "$STEP" >&2
        printf 'Fix that condition and rerun; later checkpoints have not been proven.\n' >&2
    fi
    exit "$rc"
}
trap cleanup EXIT
trap 'exit 130' INT
trap 'exit 143' TERM

checkpoint '00 / Ubuntu VM prerequisites'
[[ $(uname -s) == Linux ]] || fail 'Run this inside the Ubuntu VM, not directly on macOS.'
[[ -r /etc/os-release ]] || fail '/etc/os-release is not readable.'
# shellcheck disable=SC1091
source /etc/os-release
[[ ${ID:-} == ubuntu ]] || fail 'This validator intentionally targets Ubuntu; use the book for Debian or RHEL-specific procedures.'
(( EUID != 0 )) || fail 'Use your normal Ubuntu account, not root.'
[[ -n ${HOME:-} && -d "$HOME" && ! -L "$HOME/devops-lab" ]] || fail 'HOME is invalid or devops-lab is a symlink.'
[[ $(ps -p 1 -o comm= | tr -d '[:space:]') == systemd ]] || fail 'This VM must run systemd as PID 1.'
for tool in bash python3 git hostname whoami pwd cat mkdir ls cp cmp chmod grep wc tar find gzip \
    systemctl journalctl nginx ss curl ip getent free df tee mktemp; do
    command -v "$tool" >/dev/null 2>&1 || fail "Required tool missing: $tool. Install the prerequisite or complete the relevant chapter, then rerun."
done
[[ -f "$REPO/scripts/verify-nginx.sh" ]] || fail 'Run from a complete repository clone.'

mkdir -p "$HOME/devops-lab/validation-reports"
REPORT="$HOME/devops-lab/validation-reports/ubuntu-live-$(date -u +%Y%m%dT%H%M%SZ)-$$.log"
exec > >(tee "$REPORT") 2>&1
printf 'Host: %s | User: %s | Distribution: %s\n' "$(hostname)" "$(whoami)" "${PRETTY_NAME:-Ubuntu}"
printf 'Report: %s\n' "$REPORT"
printf 'Scope: actual Linux commands; Chapter 11 service interruption is opt-in only.\n'
printf 'Note: authorised disposable VM only. Existing lab files will not be overwritten.\n'

checkpoint '01 / Establish operating context'
cat /etc/os-release | grep -E '^(NAME|VERSION_ID|ID)=' || true
whoami
hostname
pwd
[[ -e "$HOME/devops-lab" && ! -d "$HOME/devops-lab" ]] && fail '~/devops-lab exists but is not a directory.'
mkdir -p "$HOME/devops-lab"
TEMP_LAB=$(mktemp -d "$HOME/devops-lab/.linux-validation.XXXXXXXX")
[[ -d "$TEMP_LAB" ]] || fail 'Failed to create isolated practice workspace.'
pass 'Ubuntu identity, host, distribution and isolated workspace established'

checkpoint '02 / Filesystem navigation'
cd ~
[[ $(pwd -P) == "$(cd "$HOME" && pwd -P)" ]] || fail 'Home-directory navigation failed.'
cd /etc
[[ $(pwd -P) == /etc ]] || fail 'Absolute-path navigation failed.'
cd "$TEMP_LAB"
[[ $(pwd -P) == "$TEMP_LAB" ]] || fail 'Lab navigation failed.'
pass 'Absolute and home-relative navigation verified'

checkpoint '03 / Files, configuration and archives'
mkdir -p config logs scripts archive-test
printf 'environment=lab\n' > config/app.conf
cp config/app.conf config/app.conf.backup
cmp -s config/app.conf config/app.conf.backup || fail 'Configuration backup mismatch.'
tar -czf config-backup.tar.gz config
tar -tf config-backup.tar.gz | grep -q '^config/app.conf$' || fail 'Archive lacks expected configuration.'
tar -xf config-backup.tar.gz -C archive-test
cmp -s config/app.conf archive-test/config/app.conf || fail 'Archive extraction mismatch.'
pass 'Configuration, copy, archive and extraction verified'

checkpoint '04 / Identity and file permissions'
chmod 600 config/app.conf
[[ -r config/app.conf ]] || fail 'Initial owner-read permission missing.'
chmod u-r config/app.conf
if [[ -r config/app.conf ]]; then
    chmod u+r config/app.conf
    fail 'Permission failure was not reproduced; check for unusual ACLs or privileges.'
fi
chmod u+r config/app.conf
[[ -r config/app.conf ]] || fail 'Owner read permission was not restored.'
grep -qx 'environment=lab' config/app.conf || fail 'Original content was not preserved.'
pass 'Permission failure and smallest repair verified'

checkpoint '05 / Search and text evidence'
cp "$REPO/examples/app.log" logs/app.log
find config -maxdepth 1 -type f | grep -q 'app.conf' || fail 'Configuration search failed.'
grep -q 'WARNING retry requested' logs/app.log || fail 'Expected sample warning missing.'
[[ $(wc -l < logs/app.log) -eq 10 ]] || fail 'Example log has changed; review sample and update the expected count.'
pass 'Filesystem search, text search and sample log inspection verified'

checkpoint '06 / Pipelines, redirection and diagnostics'
[[ $(grep -c '^INFO ' logs/app.log) -eq 9 ]] || fail 'INFO lines in sample log differ from the expected count.'
[[ ! -e config/missing.conf ]] || fail 'Controlled missing-file precondition failed.'
if cat config/missing.conf 2> logs/error.log; then
    fail 'Reading a missing file unexpectedly succeeded.'
fi
[[ -s logs/error.log ]] || fail 'Expected stderr was not captured.'
pass 'Pipelines and captured error evidence verified'

checkpoint '07 / Software, service and resources'
command -v nginx >/dev/null || fail 'Install NGINX using Chapter 7 (sudo apt install nginx), then rerun.'
nginx -v
systemctl is-active --quiet nginx || fail 'NGINX is not active. Inspect Chapter 7 service setup before rerunning.'
free -h >/dev/null
df -h >/dev/null
pass 'NGINX exists, service is active, and memory/disk checks execute'

checkpoint '08 / Service logs and recorded evidence'
if journalctl -u nginx -n 10 --no-pager; then
    pass 'Journal query executed (absence of records is not proof of absence of incidents)'
else
    printf 'NOTE: journal access failed for this user. Review authorised journal permissions manually.\n'
fi

checkpoint '09 / Local network and HTTP boundaries'
ip -br addr
ip route
getent hosts localhost >/dev/null || fail 'Localhost resolution failed.'
ss -lnt | grep -Eq ':80[[:space:]]' || fail 'No TCP listener detected on port 80.'
curl --fail --silent --show-error http://localhost >/dev/null || fail 'Local HTTP request failed.'
pass 'Address, route, DNS, TCP listener and HTTP response checked'
printf 'MANUAL: SSH, scp and remote-host identity checks require a separately authorised host.\n'

checkpoint '10 / Bash automation and controlled script failure'
cp "$REPO/scripts/verify-nginx.sh" scripts/verify-nginx.sh
bash -n scripts/verify-nginx.sh
chmod u+x scripts/verify-nginx.sh
if ! ./scripts/verify-nginx.sh > logs/nginx-verification.txt; then
    cat logs/nginx-verification.txt
    fail 'The real four-check NGINX script returned non-zero.'
fi
cat logs/nginx-verification.txt
[[ $(grep -c '^PASS:' logs/nginx-verification.txt) -eq 4 ]] || fail 'Expected four PASS lines in report.'
chmod u-x scripts/verify-nginx.sh
if ./scripts/verify-nginx.sh >/dev/null 2> logs/script-permission-error.txt; then
    chmod u+x scripts/verify-nginx.sh
    fail 'Expected direct-execution permission failure did not occur.'
fi
chmod u+x scripts/verify-nginx.sh
./scripts/verify-nginx.sh >/dev/null || fail 'Execution did not recover after chmod u+x.'
pass 'Real script, exit status, four evidence checks and execute-bit recovery verified'

checkpoint '11 / Evidence-first troubleshooting and recovery'
[[ $(systemctl is-active nginx) == active ]] || fail 'Start with an active service before a controlled failure.'
if (( ! ALLOW_STOP )); then
    printf 'SKIPPED: intentional NGINX stop/restart (requires --allow-service-stop).\n'
    printf 'Core real-VM checkpoints 01–10 PASSED. Chapter 11 stop/restart is NOT yet validated.\n'
    printf 'To complete the controlled failure lab, rerun with: bash tests/validate-ubuntu-live.sh --allow-service-stop\n'
else
    [[ -t 0 ]] || fail 'The service-stop drill requires an interactive terminal confirmation.'
    expected="STOP $(hostname)"
    printf 'On the disposable VM ONLY, this will stop NGINX briefly, then restart it.\n'
    printf 'Type exactly [%s] to confirm: ' "$expected"
    read -r answer || fail 'Confirmation input unavailable.'
    [[ "$answer" == "$expected" ]] || fail 'Not confirmed. NGINX was not stopped.'
    command -v sudo >/dev/null || fail 'sudo is required for the authorised stop/restart drill.'
    sudo -v || fail 'Unable to authenticate authorised sudo access.'
    RECOVERY_NEEDED=1
    sudo systemctl stop nginx || fail 'Could not stop NGINX; recovery will be attempted.'
    if systemctl is-active --quiet nginx; then
        fail 'NGINX remained active after the deliberate stop.'
    fi
    if curl --fail --silent --show-error http://localhost >/dev/null 2>&1; then
        fail 'HTTP unexpectedly continued to succeed; the controlled fault did not isolate the required boundary.'
    fi
    systemctl is-active nginx || true
    journalctl -u nginx -n 10 --no-pager || true
    sudo systemctl start nginx || fail 'Could not restart NGINX; recovery will be attempted.'
    systemctl is-active --quiet nginx || fail 'NGINX did not become active after restart.'
    RECOVERY_NEEDED=0
    ./scripts/verify-nginx.sh > logs/nginx-recovery.txt || fail 'The original four-check requirement did not recover.'
    [[ $(grep -c '^PASS:' logs/nginx-recovery.txt) -eq 4 ]] || fail 'Recovered report lacks four PASS checks.'
    pass 'Deliberate NGINX outage, evidence, authorised repair and end-to-end recovery verified'
fi

printf '\nVALIDATION SUMMARY: completed the reported checkpoints successfully.\n'
printf 'This is NOT proof of optional remote SSH, all distribution variants, or every exercise in the manuscript.\n'
printf 'See docs/VALIDATION-CHECKLIST.md for manual release sign-off.\n'
printf 'Full output was saved outside the repository: %s\n' "$REPORT"
