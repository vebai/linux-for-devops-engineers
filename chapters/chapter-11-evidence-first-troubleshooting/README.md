# Chapter 11 — Troubleshoot Linux Systems from Evidence

**Goal:** practise locating the first abnormal boundary and restoring an HTTP requirement without speculative changes.

## Before you begin

**Authorised disposable VM only.** NGINX must respond successfully to `http://localhost` and `~/devops-lab/scripts/verify-nginx.sh` must be executable and return 0. The exercise will intentionally stop a service. Do not run it on a production/shared host.

## Establish the known-good state

```bash
cd ~/devops-lab
hostname
whoami
pwd
systemctl status nginx
ss -lnt
curl --fail --silent --show-error http://localhost
./scripts/verify-nginx.sh
```

Confirm all checks before introducing failure. If any are already failing, troubleshoot that starting state instead.

## Break exactly one property

Only after verifying the disposable host and recording normal evidence:

```bash
sudo systemctl stop nginx
```

## Observe, then diagnose

```bash
curl --fail --silent --show-error http://localhost
ss -lnt
systemctl status nginx
journalctl -u nginx -n 20
```

The failed curl and absence of the expected listener point you towards the service boundary. An inactive service does **not** by itself establish the original cause of an unplanned incident.

## Make the smallest supported repair

The deliberately introduced fault was a stopped service. Reverse exactly that change:

```bash
sudo systemctl start nginx
```

## Verify the original requirement again

```bash
systemctl status nginx
ss -lnt
curl --fail --silent --show-error http://localhost
./scripts/verify-nginx.sh
result=$?
printf 'Verification status: %s\n' "$result"
```

Expected: local HTTP succeeds and the script returns 0. If repair fails, **stop** and inspect new evidence rather than changing unrelated files or permissions.

## Record useful evidence

```bash
./scripts/verify-nginx.sh > logs/nginx-verification.txt
result=$?
cat logs/nginx-verification.txt
printf 'Verification status: %s\n' "$result"
```

Repeat verification rather than treating an old report as current proof. See [the evidence method](../../docs/EVIDENCE-METHOD.md) and [safe cleanup](../../docs/CLEANUP.md).
